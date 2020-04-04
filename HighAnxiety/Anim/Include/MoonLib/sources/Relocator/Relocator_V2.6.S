;------------------------------------------------------------------------
;-			       RELOCATOR 2				-
;-			      -------------				-
;-									-
;- -->a0 address of reloc file						-
;- -->a1 address of chipmem						-
;- -->a2 address of fastmem						-
;- -->d0 fillpattern for bss-hunks					-
;- <--d0 0.l if ok, -1.l if error					-
;-									-
;-  Relocator_FillBSS=0 --> don't init BSS-memory  !default		-
;-  Relocator_FillBSS=1 --> fill BSS-memory with fillpattern (d0)	-
;- Note: Relocator_FillBSS must not exist				-
;-									-
;- Support:								-
;-  Hunk codeb (chip/fast/public)					-
;-  Hunk reloc 32							-
;-  Hunk data (chip/fast/public)					-
;-  Hunk bss (chip/fast/public)						-
;-									-
;-									-
;- Usage:								-
;-	   lea	program,a0	;address of reloc-file			-
;-	   lea	chip,a1		;free chipmemory			-
;-	   lea	fast,a2		;free fastmemory			-
;-	   jsr	relocator						-
;-	   tst	d0		;bug ?					-
;-	   bne	error							-
;-	   jmp	chip/fast	;position of first code segment		-
;-									-
;-  its your turn to make sure that both memoryblocks (chip/fast)	-
;-  are big enough!							-
;-  if you want to force all to chipmem, set a2 to zero: sub.l	a2,a2	-
;-									-
;-									-
;- code by Moon/ABYSS					       May 1994	-
;-						last update:  July 1995	-
;------------------------------------------------------------------------
Relocator:
	movem.l	d1-a6,-(a7)
	lea	Reloc_Data(pc),a3
	move.l	a1,Reloc_MemPtChip(a3)	;memorypoint_chip
	move.l	a2,Reloc_MemPtFast(a3)	;memorypoint_fast

	cmp.l	#$000003f3,(a0)+	;hunk header
	bne.w	Reloc_Bug		;not executable or file damaged

	cmp.l	#0,(a0)+		;hunkname
	bne.w	Reloc_Bug		;bug if there's a hunkname
					;(not supported yet)

	move.l	(a0)+,Reloc_HunkQuant(a3)	;number of hunks
	move.l	(a0)+,Reloc_HunkFirst(a3)	;first hunknumber
	move.l	(a0)+,Reloc_HunkLast(a3)	;last hunknumber
	move.w	#0,Reloc_HunkWork(a3)

	move.l	Reloc_HunkQuant(a3),d7		;number of hunks
	subq.w	#1,d7
	lea	Reloc_HunkLengths(pc),a1	;memory for hunk-lengths
	move.l	a2,d6				;fastmem to test if valid
Reloc_Copylengths:
	move.l	(a0)+,d3		;next hunk length
	tst.l	d6
	beq.b	Reloc_takechip		;no fastmem=force all to chipmem
	btst.l	#30,d3			;chipmem?
	bne.b	Reloc_takechip
;	btst.l	#31,d3			;fastmem or public->take fast
;	bne	Reloc_takefast
Reloc_takepublic:
Reloc_takefast:
	add.l	d3,d3
	add.l	d3,d3
	move.l	d3,(a1)+		;store length
	move.l	Reloc_MemPtFast(a3),d1	;next address in fast-mem
	move.l	d1,(a1)+		;store startaddress
	add.l	d3,d1			;add size (bytes)
	addq.l	#7,d1
	and.l	#%11111111111111111111111111111000,d1	;8 byte-aligned
	move.l	d1,Reloc_MemPtFast(a3)
	bra.b	reloc_memorytaken

Reloc_takechip:
	add.l	d3,d3
	add.l	d3,d3
	move.l	d3,(a1)+		;store length
	move.l	Reloc_MemPtChip(a3),d1
	move.l	d1,(a1)+		;store startaddress
	add.l	d3,d1			;add size (bytes)
	addq.l	#7,d1
	and.l	#%11111111111111111111111111111000,d1	;8 byte-aligned
	move.l	d1,Reloc_MemPtChip(a3)

Reloc_memorytaken:
	dbf	d7,Reloc_Copylengths
	lea	Reloc_HunkLengths(pc),a1	;memory for hunk-lengths

;-------------------------

Reloc_MainLoop:
	move.l	(a0)+,d3		;new hunk
	cmp.l	#$000003e9,d3		;hunk code ?
	beq.b	Reloc_HunkCode

	cmp.l	#$000003ec,d3		;hunk reloc 32 ?
	beq.b	Reloc_HunkReloc32

	cmp.l	#$000003ea,d3		;hunk data ?
	beq.b	Reloc_HunkData

	cmp.l	#$000003eb,d3		;hunk bss ?
	beq.b	Reloc_HunkBSS

	cmp.l	#$000003f2,d3		;hunk end ?
	beq.w	Reloc_HunkEnd

Reloc_Bug:
;	move.w	#$0f00,$dff180
;	move.w	#$0ff0,$dff180
;	btst	#6,$bfe001
;	bne.b	Reloc_Bug
	moveq	#-1,d0
	movem.l	(a7)+,d1-a6
	rts
;------------------------------------------------------------------------
;---------
Reloc_HunkCode:
	move.l	(a0)+,d7		;hunk code length (longwords)
	beq.b	Reloc_MainLoop		;length 0 is possible...
	move.w	Reloc_HunkWork(a3),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk address
Reloc_HunkCode_Loop:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	Reloc_HunkCode_Loop
	bra.b	Reloc_MainLoop
;-----------------------------
Reloc_HunkReloc32:
	move.l	(a0)+,d7		;hunk reloc 32 offsets length
	beq.b	Reloc_MainLoop
	move.l	(a0)+,d6		;hunknumber of offsets
	lsl.w	#3,d6
	move.l	4(a1,d6.w),d1		;hunkaddress of offsets (source)
	move.w	Reloc_HunkWork(a3),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk address (dest)
Reloc_HunkReloc32_Loop:
	move.l	(a0)+,d2		;next offset
	add.l	d1,(a2,d2.l)		;add hunk startaddress
	subq.l	#1,d7
	bne.b	Reloc_HunkReloc32_Loop
	bra.b	Reloc_HunkReloc32
;---------------------------------
Reloc_HunkData:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	Reloc_MainLoop		;length 0 is possible...
	move.w	Reloc_HunkWork(a3),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk address
Reloc_HunkData_Loop:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	Reloc_HunkData_Loop
	bra.w	reloc_mainloop
;-----------------------------
Reloc_HunkBSS:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	ifd	Reloc_FillBSS
	ifne	Reloc_FillBSS
	move.w	Reloc_HunkWork(a3),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk address
Reloc_HunkBSS_Loop:
	move.l	d0,(a2)+
	subq.l	#1,d7
	bne.b	Reloc_HunkBSS_Loop
	endif
	endif
	bra.w	reloc_mainloop
;-----------------------------
Reloc_HunkEnd:
	addq.w	#1,Reloc_HunkWork(a3)
	subq.l	#1,Reloc_HunkQuant(a3)
	bne.w	Reloc_MainLoop
	moveq	#0,d0			;no bug
	movem.l	(a7)+,d1-a6
	rts				;;finished
;----------



Reloc_Data:		dcb.b	5*4+1*2,0
			rsreset
Reloc_MemPtChip:	rs.l	1
Reloc_MemPtFast:	rs.l	1
Reloc_HunkQuant:	rs.l	1
Reloc_HunkFirst:	rs.l	1
Reloc_HunkLast:		rs.l	1
Reloc_HunkWork:		rs.w	1


Reloc_HunkMaximum=20
Reloc_HunkLengths:	dcb.l	Reloc_HunkMaximum*2,0


