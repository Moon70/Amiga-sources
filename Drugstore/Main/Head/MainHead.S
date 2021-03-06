writecode=1

PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"//include/DiscPosLen.i"


allocmem=-30-168
superstate=-150

aa:
	cmp.l	#"Moon",d0
	bne.b	FromDisc
	lea	launchcode(pc),a0
	addq.w	#1,(a0)
	lea	MemoryTrack(pc),a0
	move.l	d1,(a0)
	lea	MemoryChip(pc),a0
	move.l	d2,(a0)
	lea	MemoryFast(pc),a0
	move.l	d3,(a0)

	move.l	MemoryTrack(pc),a0
	add.l	#DiscLen_Main*$1600,a0
	move.l	MemoryFast(pc),a2
	move.l	#DiscLen_PDNote*$1600,d7
PDNote_Copy:
	move.b	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	PDNote_Copy

	move.l	memoryfast(pc),a2
	add.l	#466000-338000,a2
	move.l	#DiscLen_Block1*$1600,d7
Block1_Copy:
	move.b	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	Block1_Copy

	lea	DR_Main(pc),a0
	rts

;------------------------------------------------------------------------
FromDisc:
	move.l	4.w,a6
	move.l	#465000,d0
	moveq	#2,d1
	jsr	allocmem(a6)
	lea	MemoryChip(pc),a0
	move.l	d0,(a0)
	bne.b	gotchip

	lea	MemoryError(pc),a0
	addq.w	#1,(a0)

	move.l	#100000,d0
	moveq	#2,d1
	jsr	allocmem(a6)
	lea	MemoryChip(pc),a0
	move.l	d0,(a0)


;	cmp.l	#"DRUG",$100.w
;	bne	reset

;	bne	gotfast	;fast not needed for lomem


gotchip:
	move.l	#468000,d0
	moveq	#0,d1
	jsr	allocmem(a6)
	lea	MemoryFast(pc),a0
	move.l	d0,(a0)
	bne.b	gotfast

	lea	MemoryError(pc),a0
	addq.w	#2,(a0)

	move.l	#20000,d0
	moveq	#0,d1
	jsr	allocmem(a6)
	lea	MemoryFast(pc),a0
	move.l	d0,(a0)

gotfast:
	lea	MemoryError(pc),a0
	tst.w	(a0)
	beq	gotallmem

;got not all mem, now asking if this is the first or second try...
	cmp.l	#"DRUG",$100.w
	beq	nofastdolomem	;second, reset dont help
	;if this happens, there is still too less memory after reset,
	;(but fastmem is present, maybe resident allocated or damaged!)


;first allocation-try failed, now asking if any fastmem is present:
	move.l	#1000,d0
	moveq	#4,d1
	jsr	allocmem(a6)
	tst.l	d0
	bne	reset	;yes, lets reset the amiga and try again

;the amiga seems to have no fastmem, so i dont do a reset.
;lets show the out-of-mem pig

nofastdolomem:
;	move.l	MemoryChip(pc),d0
;	lea	MemoryFast(pc),a1
;	add.l	#200000,d0
;	move.l	d0,(a1)


;------------------------------------------------------------------------
gotallmem:
DR_Main:
	lea	termfile(pc),a1		;terminator source
	move.l	memorychip(pc),a0	;terminator destination
	bsr.b	determ			;determinate mainloader

	move.l	memorychip(pc),a0	;adress reloc file
	move.l	memorychip(pc),a1	;adress section chip
	move.l	memoryfast(pc),a2	;adress section fast
	bsr.w	relocator		;relocate memory

	moveq	#0,d0
	move.w	LaunchCode(pc),d0
	moveq	#0,d1
	move.w	MemoryError(pc),d1
	move.l	MemoryTrack(pc),a0
	move.l	memorychip(pc),a1
	move.l	#"YEAH",$100.w
	jmp	(a1)

LoadFile2Pos:	dc.l	0
LaunchCode:	dc.w	0
MemoryError:	dc.w	0
MemoryTrack:	dc.l	0
MemoryChip:	dc.l	0
MemoryFast:	dc.l	0

reset:
move.l	#"DRUG",$100.w
move.l	4.w,a6
jsr	superstate(a6)
lea	$1000000,a0
sub.l	-20(a0),a0
move.l	4(a0),a0
subq.l	#2,a0
cnop	0,4
reset
jmp	(a0)

;------------------------------------------------------------------------
;---	      BYTESTRING decrunchroutine by Moon, april 1991		-
;------------------------------------------------------------------------
determ:
;a0=adress of memory to decrunch
;a1=adress of crunched data

move.l	(a1)+,d1	;crunched length
move.l	(a1)+,d2	;decrunched length
tst.b	(a1)+		;routine-code
move.b	(a1)+,d0	;codebyte

sub.l	#4+4+1+1,d1

decrunchl1:
;move.w	#$0990,$dff180
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3
;move.w	#$0009,$dff180

decrunchl4:
move.b	d3,(a0)+
dbf	d2,decrunchl4
subq.l	#3,d1
bra.b	decrunchl3

decrunchl2:
move.b	-1(a1),(a0)+
subq.l	#1,d1

decrunchl3:
bne.b	decrunchl1

rts



;------------------------------------------------------------------------
;-			       RELOCATOR 2				-
;-			      -------------				-
;-									-
;- Support:								-
;-  Hunk code (chip/fast/public)					-
;-  Hunk reloc 32							-
;-  Hunk data								-
;-  Hunk bss								-
;-									-
;-									-
;- Usage:								-
;-	   lea	program,a0	;adress of reloc-file			-
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
;-									-
;- code by Moon/ABYSS					      May 1994	-
;------------------------------------------------------------------------
relocator:
	lea	memorypoint_chip(pc),a3
	move.l	a1,(a3)+	;memorypoint_chip
	move.l	a2,(a3)+	;memorypoint_fast

	cmp.l	#$000003f3,(a0)+	;hunk header
	bne.b	bug			;not executable or file damaged

	cmp.l	#0,(a0)+		;hunkname
	bne.b	bug			;bug if there's a hunkname
					;(not supported yet)


	move.l	(a0)+,(a3)	;hunk_quant	;number of hunks
	addq.w	#8,a0

	move.l	hunk_quant(pc),d7		;number of hunks
	subq.w	#1,d7
	lea	hunk_lengths(pc),a1	;memory for hunk-lengths
	move.l	a2,d6			;fastmem to test if valid
reloc_copylengths:
	move.l	(a0)+,d0		;next hunk length
	tst.l	d6
	beq.b	reloc_takechip		;no fastmem=force all to chipmem
	btst.l	#30,d0			;chipmem?
	bne.b	reloc_takechip
;	btst.l	#31,d0			;fastmem or public->take fast
;	bne	reloc_takefast
reloc_takepublic:
reloc_takefast:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length
	lea	memorypoint_fast(pc),a3
	move.l	(a3),d1
;	move.l	memorypoint_fast(pc),d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
;	move.l	d1,memorypoint_fast
	move.l	d1,(a3)
	bra.b	reloc_memorytaken

reloc_takechip:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length
;	move.l	memorypoint_chip,d1
	lea	memorypoint_chip(pc),a3
	move.l	(a3),d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,(a3)
;	move.l	d1,memorypoint_chip

reloc_memorytaken:
	dbf	d7,reloc_copylengths
	lea	hunk_lengths(pc),a1	;memory for hunk-lengths

;-------------------------

reloc_mainloop:
	move.l	(a0)+,d0		;new hunk
	cmp.l	#$000003e9,d0		;hunk code ?
	beq.b	hunk_code

	cmp.l	#$000003ec,d0		;hunk reloc 32 ?
	beq.b	hunk_reloc32

	cmp.l	#$000003ea,d0		;hunk data ?
	beq.b	hunk_data

	cmp.l	#$000003eb,d0		;hunk bss ?
	beq.w	hunk_bss

	cmp.l	#$000003f2,d0		;hunk end ?
	beq.w	hunk_end

bug:
;	move.w	#$0f00,$dff180
;	move.w	#$0ff0,$dff180
;	btst	#6,$bfe001
;	bne.b	bug
;	moveq	#-1,d0
;	lea	bugcode(pc),a3
;	move.l	d7,(a3)
;	move.l	d7,bugcode
	rts
depp:	dc.w	0
;------------------------------------------------------------------------
;---------
hunk_code:
	move.l	(a0)+,d7		;hunk code length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work(pc),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_code_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	hunk_code_copy
	bra.b	reloc_mainloop
;-----------------------------
hunk_reloc32:
	move.l	(a0)+,d7		;hunk reloc 32 offsets length
	beq.b	reloc_mainloop
	move.l	(a0)+,d6		;hunknumber of offsets
	lsl.w	#3,d6
	move.l	4(a1,d6.w),d1		;hunkadress of offsets
	move.w	hunk_work(pc),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_reloc32_loop:
	move.l	(a0)+,d2		;next offset
	add.l	d1,(a2,d2.l)		;add hunk startadress
	subq.l	#1,d7
	bne.b	hunk_reloc32_loop
	bra.b	hunk_reloc32
;---------------------------------
hunk_data:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work(pc),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_data_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
furz:
	bne.b	hunk_data_copy
	bra.w	reloc_mainloop

;-----------------------------
hunk_bss:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	bra.w	reloc_mainloop
;-----------------------------
hunk_end:
	lea	hunk_quant(pc),a3
;	addq.w	#1,hunk_work
;	subq.l	#1,hunk_quant
	addq.w	#1,4(a3)
	subq.l	#1,(a3)
	bne.w	reloc_mainloop
	moveq	#0,d0			;no bug
	rts				;;finished
;----------


hunk_maximum=100

hunk_lengths:	dcb.l	hunk_maximum*2,0


memorypoint_chip:	dc.l	0;|
memorypoint_fast:	dc.l	0;|
hunk_quant:		dc.l	0;|
hunk_work:		dc.w	0;|



bugcode:	dc.l	0

termfile:	incbin	"dh0:de"
bb:

ifne	writecode
auto	wb\
auto	dh0:so/drug/code/MainLoader.head\
auto	y
auto	aa\bb\

endif

end

section	chipmem,code_c
chip_memory:
relocfile:
memory:
dcb.b	500000,0





section	fastmem,code_f
fast_memory:
dcb.b	500000,0

