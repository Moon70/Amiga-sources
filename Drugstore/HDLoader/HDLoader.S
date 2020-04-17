;------------------------------------------------------------------------
;|                                                                      |
;|                               DRUGSTORE                              |
;|                                                                      |
;|                               HD-loader                              |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/Abyss                                        March 1995 |
;------------------------------------------------------------------------

PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"/include/DiscPosLen.i"

AttnFlags=296	;struct ExecBase
ThisTask=276	;struct ExecBase

GetMsg=-372
ReplyMsg=-378
WaitPort=-384
LVO_Supervisor=-30

execbase=4
openlib=-408
CloseLibrary=-414
open=	-30
seek=	-66
close=	-36
write=	-48
read=	-42
output=	-60
allocmem=-30-168
freemem=-30-180
mode_old=1005
mode_new=1006
offset_beginning=-1
offset_current=0
offset_end=1

section	code,code_p

;--------
	move.l	4.w,a6
	move.w	AttnFlags(a6),d0
	btst.l	#0,d0
	beq	Main_Vectorsokay
	lea	Main_GetVBR(pc),a5
	jsr	LVO_Supervisor(a6)
	bra	Main_Vectorsokay

Main_GetVBR:
	move.l	d0,-(a7)
	dc.l	$4e7a0002
	bclr	#0,d0
	bclr	#4,d0
	bclr	#8,d0
	bclr	#12,d0
	dc.l	$4e7b0002
	move.l	(a7)+,d0
	rte

Main_Vectorsokay:
	move.l	4.w,a6
	move.l	ThisTask(a6),a4
	tst.l	$ac(a4)
	bne	Main_StartCLI
	lea	$5c(a4),a0
	jsr	WaitPort(a6)
	lea	$5c(a4),a0
	jsr	GetMSG(a6)
	move.l	d0,Main_Message
Main_StartCLI:


start:
	move.l	4.w,a6
	lea	dosname(pc),a1		;adresse doslibname
	moveq	#0,d0			;version egal
	jsr	openlib(a6)		;library oeffnen
	move.l	d0,dosbase		;basisadresse speichern
	beq.w Error1

;##### Chip Drug
	move.l	4.w,a6
	move.l	#465000,d0	;Chip Drug
	moveq	#2,d1
	jsr	allocmem(a6)
	lea	MemoryChip(pc),a0
	move.l	d0,(a0)
	bne.w	GotChipDrug
;#####
Lomem:
	move.l	4.w,a6
	move.l	#45000,d0
	moveq	#2,d1
	jsr	allocmem(a6)
	lea	MemoryChip(pc),a0
	move.l	d0,(a0)
	beq.w	Error2

	move.l	dosbase,a6
	move.l	#sourcename,d1
	move.l	#mode_old,d2
	jsr	openfile
	tst.l	filehandle
	beq.b	Error3

LomemOpenOK:
	move.l	#382976,d2	;skip first part
	move.l	#Offset_beginning,d3
	jsr	seekfile
	move.l	#$1600*2,d3
	move.l	#Mainhead,d2
	jsr	readfile
	move.l	d0,-(a7)
	jsr	closefile
	move.l	(a7)+,d0
	bmi.b	Error3

	move.l	MemoryChip(pc),a0	;terminator destination
	lea	Mainhead,a1		;terminator source
	bsr.w	determ			;determinate mainloader

	move.l	MemoryChip(pc),a0	;adress reloc file
	move.l	a0,a1			;adress section chip
	sub.l	a2,a2			;adress section fast (NOT USED)
	bsr.w	relocator		;relocate memory

	move.l	MemoryChip(pc),a0	;adress reloc file
	jsr	(a0)			;execute Lomem-Part
	
Error3:;error opening file
	move.l	4.w,a6
	move.l	#45000,d0
	move.l	MemoryChip(pc),a1
	jsr	Freemem(a6)
	bra.w	Back_Lomem

GotChipDrug:
	move.l	4.w,a6
	move.l	#870000,d0	;Public Track
	moveq	#0,d1
	jsr	allocmem(a6)
	lea	MemoryTrack(pc),a0
	move.l	d0,(a0)
	bne.b	GotPublicTrack

FreeChipDrug:
	move.l	4.w,a6
	move.l	#465000,d0	;Chip Drug
	move.l	MemoryChip(pc),a1
	jsr	Freemem(a6)
	bra.w	Lomem


GotPublicTrack:
	move.l	#468000,d0	;Public Drug
	moveq	#0,d1
	jsr	allocmem(a6)
	lea	MemoryFast(pc),a0
	move.l	d0,(a0)
	bne.b	GotPublicDrug

	move.l	4.w,a6
	move.l	#870000,d0	;Public Track
	move.l	MemoryTrack(pc),a1
	jsr	Freemem(a6)
	bra.b	FreeChipdrug


GotPublicDrug:


;load sourcefile
	move.l	#sourcename,d1
	move.l	#mode_old,d2
	jsr	openfile

	tst.l	filehandle
	beq.w	Error4

File1OpenOK:

	move.l	#382976,d3
	move.l	MemoryTrack(pc),d2
	jsr	readfile
	move.l	d0,-(a7)
	jsr	closefile
	move.l	(a7)+,d0
	bmi.w	Error4
;----------------------------------------------------------------

	move.l	MemoryTrack(pc),a0
	lea	MainHead,a1
	move.l	#DiscLen_Main*$1600,d7
CopyTracks:
	move.b	(a0)+,(a1)+
	subq.l	#1,d7
	bne.b	copytracks

	move.l	#"Moon",d0
	move.l	MemoryTrack(pc),d1
	move.l	MemoryChip,d2
	move.l	MemoryFast,d3

	movem.l	d0-a6,-(a7)
	jsr	mainhead
	move.l	a0,IgnitionCode
	movem.l	(a7)+,d0-a6

LoadFile2:
	move.l	dosbase,a6
	move.l	#sourcename,d1
	move.l	#mode_old,d2
	jsr	openfile
	tst.l	filehandle
	beq.b	Error4

File2OpenOK:
	move.l	#382976,d2
	move.l	#Offset_beginning,d3
	jsr	seekfile
	move.l	#867328,d3
	move.l	MemoryTrack(pc),d2
	jsr	readfile
	move.l	d0,-(a7)
	jsr	closefile
	move.l	(a7)+,d0
	bmi.b	Error4


	move.l	IgnitionCode(pc),a0
	jsr	(a0)



Error4:;File load error
	move.l	4.w,a6
	move.l	#465000,d0	;Chip Drug
	move.l	MemoryChip(pc),a1
	jsr	Freemem(a6)

	move.l	4.w,a6
	move.l	#870000,d0	;Public Track
	move.l	MemoryTrack(pc),a1
	jsr	Freemem(a6)

	move.l	4.w,a6
	move.l	#468000,d0	;Public Drug
	move.l	MemoryFast(pc),a1
	jsr	Freemem(a6)

Back_Lomem:
Error2:	;LoMem (50000 bytes chip) not available
	move.l	4.w,a6
	move.l	dosbase(pc),a1
	jsr	CloseLibrary(a6)
Error1:	;could not open dos.library

	move.l	Main_Message(pc),d0
	beq	Main_NoReply
	move.l	d0,a1
	jsr	ReplyMsg(a6)
Main_Noreply:
	moveq	#0,d0
	rts

openfile:				;routine oeffnet file
					;modus in D0 (load/save)
					;zeiger auf dateiname in D1
	move.l	dosbase,a6		;doslibstart in a6
	jsr	open(a6)		;datei oeffnen
	move.l	d0,filehandle		;filehandle retten
	rts

seekfile:
					;got modus in d3
					;got position in d2
	move.l	dosbase,a6		;doslibstart in a6
	move.l	filehandle,d1		;filehandle in D1
	jsr	seek(a6)
	rts

closefile:				;routine schliesst file
	move.l	dosbase,a6		;doslibstart in a6
	move.l	filehandle,d1		;filehandle in D1
	jsr	close(a6)		;datei schliessen
	rts

readfile:				;routine laedt file
					;got length in d3
	move.l	dosbase,a6		;dosbase in a6
	move.l	filehandle,d1		;filehandle in d1
	jsr	read(a6)		;daten lesen
	rts

;------------------------------------------------------------------------
;------------------------------------------------------------------------

Main_Message:		dc.l	0
filehandle:		dc.l	0	;filehandle
dosbase:		dc.l	0
MemoryChip:		dc.l	0
MemoryFast:		dc.l	0
MemoryTrack:		dc.l	0
IgnitionCode:		dc.l	0
;outhandle:		dc.l	0
dosname:		dc.b	"dos.library",0,0
even
cnop	0,4
sourcename:		dc.b	"Drugstore.data",0
even

dc.b "$VER: DRUGSTORE by Moon/Toxic/Jumping Pixel/Neurodancer of ABYSS",0
even
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
;-                               RELOCATOR 2                            -
;-                              -------------                           -
;-                                                                      -
;- Support:                                                             -
;-  Hunk code (chip/fast/public)                                        -
;-  Hunk reloc 32                                                       -
;-  Hunk data                                                           -
;-  Hunk bss                                                            -
;-                                                                      -
;-                                                                      -
;- Usage:                                                               -
;-   lea	program,a0	;adress of reloc-file                           -
;-   lea	chip,a1		;free chipmemory                                -
;-   lea	fast,a2		;free fastmemory                                -
;-   jsr	relocator                                                   -
;-   tst	d0		;error ?                                            -
;-   bne	error                                                       -
;-   jmp	chip/fast	;position of first code segment                 -
;-                                                                      -
;-  its your turn to make sure that both memoryblocks (chip/fast)       -
;-  are big enough!                                                     -
;-  if you want to force all to chipmem, set a2 to zero: sub.l	a2,a2	-
;-                                                                      -
;-                                                                      -
;-                                                                      -
;- code by Moon/ABYSS                                          May 1994 -
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
	beq.b	hunk_bss

	cmp.l	#$000003f2,d0		;hunk end ?
	beq.b	hunk_end

bug:
	bra.w	Error3

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
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work(pc),d6	;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_data_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
furz:
	bne.b	hunk_data_copy
	bra.b	reloc_mainloop

;-----------------------------
hunk_bss:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
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



section	MainHead,bss_c
MainHead:	ds.b	19000


