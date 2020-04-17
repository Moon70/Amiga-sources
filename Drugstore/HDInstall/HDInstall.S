;------------------------------------------------------------------------
;|                                                                      |
;|                         DRUGSTORE HD Installer                       |
;|                        ------------------------                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/Abyss                                                   |
;------------------------------------------------------------------------
Main_Enable_JP60music=0
Main_Enable_SetIntflag=1
Main_Enable_JCommander=0
Main_Enable_Exit=1
showtime=0
Main_Initcall2=0
Program_ID=99
determblink=0

execbase=4
openlib=-408
open=	-30
close=	-36
write=	-48
seek=	-66
read=	-42
lock=	-84
unlock=	-90
output=	-60
info=	-114
allocmem=-30-168
freemem=-30-180
mode_old=1005
mode_new=1006
offset_beginning=-1
offset_current=0
offset_end=1

UseSection=1
Printmem=1
OnlyDisc=1

;	addq.w	#8,Commander_Point
skipper=0
skipper2=0
a:
planesize=40*103
;intena=$09a

;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
ifne	UseSection
section	CodeC,code_c
endif
codec_s:

include	"/maininit/maininit6.01.s"


;---------------------------------------------
commands:	dc.l	60000,	nothing
nothing:	rts
;---------------------------------------------

Discerror:
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)

	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)

Discerror2:
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)

	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)

	lea	Discerrorcode,a1
	lea	Chip_Memory,a0
	bsr.w	determ;-----------
	lea	Chip_Memory,a0
	move.l	a0,a1			;source=dest chip;
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	Chip_Memory,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	lea	Chip_Memory,a4
	jsr	2*6(a4)
	rts
;----------

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbivector
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	move.w	#1,f_skipmusic
	bsr.w	track_getdrivecode

	move.l	4.w,a6
	lea	dosname,a1		;adresse doslibname
	moveq	#0,d0			;version egal
	jsr	openlib(a6)		;library oeffnen
	move.l	d0,dosbase		;basisadresse speichern

clrscreen:
	lea	screen,a0
	move.w	#40*256/4,d7
	moveq	#0,d0
clrscreenloop:
	move.l	d0,(a0)+
	dbf	d7,clrscreenloop

	bsr	coppercopy
	bsr	textcalc
rept	10
	bsr	writeline
endr
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#main_emptycopperlist,(a1)

	rts
;----------


Main_program:;;
	move.l	Main_VBIVector(pc),a0
	move.l	#Vbi,(a0)

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#Copperlist,(a1)

	lea	trackbuffer(pc),a1
	move.l	#DiscBuffer,(a1)

;------------------------
	move.l	4.w,a6
	jsr	Permit(a6)
	lea	$dff000,a5
	move.w	#%1110000000101000,Intena(a5)
	move.w	#%1000001111000000,Dmacon(a5)

	move.l	dosbase,a6		;doslibstart in a6
	move.l	#installname,d1
	move.l	#-2,d2	;access_read
	jsr	lock(a6)		;datei oeffnen
	move.l	d0,lockadr		;filehandle retten
	beq	skipinstall2

	move.l	dosbase,a6		;doslibstart in a6
	move.l	lockadr(pc),d1
	move.l	#parameter,d2
	jsr	info(a6)

	move.l	dosbase,a6		;doslibstart in a6
	move.l	lockadr(pc),d1
	jsr	unlock(a6)		;datei oeffnen

	lea	parameter(pc),a0
	move.l	12(a0),d0		;number of blocks
	sub.l	16(a0),d0		;number of used blocks
	move.l	20(a0),d1		;bytes per block
	mulu	d1,d0
	move.l	d0,(a0)
	lea	$dff000,a5
	move.w	#%1100000000100000,Intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	4.w,a6
	jsr	Forbid(a6)

	move.l	parameter(pc),d0
	cmp.l	#1300000,d0
	bge	harddiscok

	bsr	writeline
	bsr	writeline
	bsr	writeline
	bra	skipinstall
harddiscok:
	add.l	#40*3*2,text_point
;///////////////////////////////////////////////////////////////////////
	bsr	writeline
	lea	Buffer,a0
	move.l	#DiscPos_Part1,d0
	move.l	#DiscLen_Part1,d1
	move.l	#DiscNam_Part1,d2
	bsr.w	loadtracks
;	tst.w	d3
;	bne.w	Discerror

	bsr	writeline
	lea	Buffer+$1600*DiscLen_Part1,a0
	move.l	#DiscPos_Lomem,d0
	move.l	#DiscLen_Lomem,d1
	move.l	#DiscNam_Lomem,d2
	bsr.w	loadtracks
;	tst.w	d3
;	bne.w	Discerror

	lea	buffer,a0
	lea	1024(a0),a1
	move.w	#DiscLen_Main*$1600-1-1024,d7
copyloop:
	move.b	(a1)+,(a0)+
	dbf	d7,copyloop

	move.w	#1024-1,d7
clearloop:
	move.b	#0,(a0)+
	dbf	d7,clearloop


	move.l	4.w,a6
	jsr	Permit(a6)
	lea	$dff000,a5
	move.w	#%1110000000101000,Intena(a5)
	move.w	#%1000001111000000,Dmacon(a5)
	move.l	#DataName,d1
	move.l	#mode_new,d2
	jsr	openfile
	move.l	#buffer,d2
	move.l	#(DiscLen_Part1+DiscLen_Lomem)*$1600,d3
	jsr	writefile
	jsr	closefile

	bsr	wait2seconds

	lea	$dff000,a5
	move.w	#%1100000000100000,Intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	4.w,a6
	jsr	Forbid(a6)
;///////////////////////////////////////////////////////////////////////
	bsr	writeline
	lea	Buffer,a0
	move.l	#DiscPos_Part2,d0
	move.l	#DiscLen_Part2,d1
	move.l	#DiscNam_Part2,d2
	bsr.w	loadtracks
;	tst.w	d3
;	bne.w	Discerror

	bsr	writeline
	move.l	4.w,a6
	jsr	Permit(a6)
	lea	$dff000,a5
	move.w	#%1110000000101000,Intena(a5)
	move.w	#%1000001111000000,Dmacon(a5)
	move.l	#DataName,d1
	move.l	#mode_old,d2
	jsr	openfile

	move.l	#0,d2
	move.l	#Offset_end,d3
	jsr	seekfile
	
	move.l	#buffer,d2
	move.l	#DiscLen_Part2*$1600,d3
	jsr	writefile
	jsr	closefile

	bsr	wait2seconds

	lea	$dff000,a5
	move.w	#%1100000000100000,Intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	4.w,a6
	jsr	Forbid(a6)

;///////////////////////////////////////////////////////////////////////
	bsr	writeline
	lea	Buffer,a0
	move.l	#DiscPos_Part3,d0
	move.l	#DiscLen_Part3,d1
	move.l	#DiscNam_Part3,d2
	bsr.w	loadtracks
;	tst.w	d3
;	bne.w	Discerror

	bsr	writeline
	move.l	4.w,a6
	jsr	Permit(a6)
	lea	$dff000,a5
	move.w	#%1110000000101000,Intena(a5)
	move.w	#%1000001111000000,Dmacon(a5)
	move.l	#DataName,d1
	move.l	#mode_old,d2
	jsr	openfile

	move.l	#0,d2
	move.l	#Offset_end,d3
	jsr	seekfile
	
	move.l	#buffer,d2
	move.l	#DiscLen_Part3*$1600,d3
	jsr	writefile
	jsr	closefile

	bsr	wait2seconds

	lea	$dff000,a5
	move.w	#%1100000000100000,Intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	4.w,a6
	jsr	Forbid(a6)

;///////////////////////////////////////////////////////////////////////
	bsr	writeline
	lea	Buffer,a0
	move.l	#DiscPos_Part4,d0
	move.l	#DiscLen_Part4,d1
	move.l	#DiscNam_Part4,d2
	bsr.w	loadtracks
;	tst.w	d3
;	bne.w	Discerror

	bsr	writeline
	lea	$dff000,a5
	move.w	#%1110000000101000,Intena(a5)
	move.w	#%1000001111000000,Dmacon(a5)
	move.l	4.w,a6
	jsr	Permit(a6)
	move.l	#DataName,d1
	move.l	#mode_old,d2
	jsr	openfile

	move.l	#0,d2
	move.l	#Offset_end,d3
	jsr	seekfile
	
	move.l	#buffer,d2
	move.l	#DiscLen_Part4*$1600,d3
	jsr	writefile
	jsr	closefile


	bsr	writeline
	move.l	#LoaderName,d1
	move.l	#mode_new,d2
	jsr	openfile

	move.l	#Loader_s,d2
	move.l	#Loader_e-Loader_s,d3
	jsr	writefile
	jsr	closefile



	bsr	wait2seconds
	lea	$dff000,a5
	move.w	#%1100000000100000,Intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	4.w,a6
	jsr	Forbid(a6)


	bsr	writeline
	bsr	writeline
skipinstall:
Main_Loop:
ifne	Main_Enable_Exit
	btst.b	#6,ciaapra
	beq.b	Main_Exit2
endif
	tst.w	f_endprogram
	beq.b	Main_Loop
Main_Exit2:
skipinstall2:
	rts

Vbi:;;
	lea	$dff000,a5

	rts
;----------

Coppercopy:
	lea	Copperlist(pc),a0
	move.l	#Screen,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	move.w	#diwstrt,(a0)+
	move.w	#$2981,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$29c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0001001000000000,(a0)+

	move.l	#$01800102,(a0)+
	move.l	#$01820555,(a0)+
	move.l	#-2,(a0)
rts

Copperlist:	dcb.b	60,0

;align	0,4
parameter:	dcb.b	50,0

wait2seconds:
	move.w	#2*50,d7
wait2secondsl1:
	move.w	#0,intflag
wait2secondsl2:
	tst.w	intflag
	beq	wait2secondsl2
	dbf	d7,wait2secondsl1
	rts



f_endprogram:		dc.w	0
;routines

;------------------------------------------------------------------------
;|                                                                      |
;|                              TRACKLOADER                             |
;|                                                                      |
;| Features: accessing disc, NOT drive!!                                |
;|   supporting df0: to df3:                                            |
;|   discsearch: last load = first seek                                 |
;|                                                                      |
;|                                                                      |
;| Usage:    jsr loadtracks                                             |
;|   a0...adress for loaded data                                        |
;|   d0...start track                                                   |
;|   d1...number of tracks                                              |
;|   d2...disc name                                                     |
;|                                                                      |
;|                                                                      |
;| code by Moon                                               16-Oct-93 |
;------------------------------------------------------------------------

trackloaderexc:
	movem.l	d0-a6,-(a7)
	bsr.b	loadtrack
	movem.l	(a7)+,d0-a6
	rte

loadtrack:
;a0=destination adress
;d0=starttrack
;d1=length tracks

movem.l	d0-a6,-(a7)

	lea	$dff000,a5
	lea	$bfd100,a6
	bsr.w	sethead	;d2/d7 changed

readloop:
	subq.w	#1,d1		;length tracks
	bmi.b	loadtrackfin

;move.l	a4,-(a7)
;lea	readerror,a4
;move.w	#0,(a4)
;move.l	(a7)+,a4

move.w	#3,rereadcount
move.w	#0,trys

rereadloop:
bsr.w	readtrack
bsr.w	trackdecoder
	
;move.w	readerror,d7

tst.w	d2
beq.b	noreaderror

sub.w	#1,rereadcount
bne.b	rereadloop

addq.w	#1,trys
cmp.w	#4,trys
bne.b	nogiveup


	bsr.w	discerror
baddisc:
	bra.b	baddisc


nogiveup:

move.w	#10,rereadcount

bsr.b	sethead		;d2/d7 changed	;reset head, try again

	btst.b	#6,ciaapra
	beq.b loadtrackfin
	bra.b	rereadloop


noreaderror:
	lea	$1600(a0),a0
	addq.w	#1,d0		;starttrack+1=next track
	bchg	#2,(a6)
	btst.l	#0,d0		;even track?
	bne.b	readloop
	bclr.b	#1,(a6)		;CIA-B PRB, bit 1=direction signal
	bclr.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
	;move.w	#1,d7		;number of rasterlines to wait...
	;bsr.w	timewait
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
	move.w	#100,d7		;number of rasterlines to wait...
	bsr.w	timewait
	bra.b	readloop

loadtrackfin:
	btst.b	#5,$f01(a6)
	bne.b	loadtrackfin
	moveq	#100,d7
	bsr.w	timewait
	movem.l	(a7)+,d0-a6
rts

;-------
sethead:;d2/d7 changed
	bset.b	#1,(a6)		;CIA-B PRB, direction signal to drive
waitdrive:
	btst.b	#5,$f01(a6)
	bne.b	waitdrive
zeromove:
	btst.b	#4,$f01(a6)	;CIA-A PRA(bfe001), bit4=track00
	beq.b	zeromoved
	bclr.b	#0,(a6)		;CIA-B PRB, step signal
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, step signal
	moveq	#70,d7		;number of rasterlines to wait...
	bsr.w	timewait
	bra.b	zeromove
zeromoved:
	bset.b	#2,(a6)	;CIA-B PRB, bit 2=side select (choose side 0)
	move.w	d0,d2	;copy of starttrack
	lsr.w	#1,d2	;tracknumber/2=cylindernumber
	bcc.b	eventrack
	bclr.b	#2,(a6)	;CIA-B PRB, side select (choose side 1)
eventrack:
	subq.w	#1,d2
	bmi.b	rightpos
	bclr.b	#1,(a6)		;CIA-B PRB, direction signal to drive
movehead:
	bclr.b	#0,(a6)		;CIA-B PRB, step signal
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, step signal
	moveq	#70,d7		;number of rasterlines to wait...
	bsr.b	timewait
	dbf	d2,movehead
rightpos:
	rts
;----------


readtrack:
	move.w	#%0111111100000000,$9e(a5)	;adkcon7 all off
	move.w	#%1000010100000000,$9e(a5)	;adkcon7, mfm+wordsync on
	move.w	#$4489,$7e(a5)			;dsksync
	move.w	#%1000001000010000,$96(a5)	;dmacon, diskdma on
waitdrive2:
	btst.b	#5,$f01(a6)	;CIA-A PRA(bfe001, disk ready
	bne.b	waitdrive2

	move.w	#$4000,$24(a5)	;dsklen
	move.l	trackbuffer(pc),$20(a5)
	move.w	#$8000+6436,d2	;dma on, 6436 words length
	move.w	d2,$24(a5)	;dsklen
	move.w	d2,$24(a5)	;dsklen
	move.w	#%0000000000000010,$9c(a5)	;intreq, clear disk-irq
diskdmawait:
	btst	#1,$1f(a5)	;intreq (lobyte)
	beq.b	diskdmawait
	move.w	#$4000,$24(a5)	;dsklen dma off
	move.w	#$400,$9e(a5)	;adkcon wordsync off
rts


;------------------------------------------------------------------------
timewait:
	movem.l	d1/d2,-(a7)
timewait0:
	move.w	$dff006,d1	;vhpos
	lsr.w	#8,d1		;d1=vertical position
timewait1:
	move.w	$dff006,d2	;vhpos
	lsr.w	#8,d2		;d2=vertical position
	cmp.w	d1,d2		;first test and last test the same line?
	beq.s	timewait1	;yep, wait...
	dbf	d7,timewait0	;wait for next line
	movem.l	(a7)+,d1/d2
	rts

waitawhile:
	movem.l	d5-d7,-(a7)
	moveq	#1,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
;	move.b	$dff007,d5
;	cmp.b	d5,d6
	cmp.b	$dff007,d6
	beq.b	waitawhileloop2
	dbf	d7,waitawhileloop1
	movem.l	(a7)+,d5-d7
	rts
;------------------------------------------------------------------------


ActDiscName:	dc.l	0
loadtracks:
;searchdisc:
	move.l	d2,discname
	movem.l	d0-a6,-(a7)
searchdiscl1:
	moveq	#3,d7			;4 drivecounter
	move.w	lastdrive(pc),opendrive
searchdiscl3:


	move.w	d7,drivecountstore
	move.w	opendrive,d0
	btst.b	d0,availdrives
	beq.w	searchdiscl4	;drive not available, skip test


	lea	$bfd100,a6
	move.b	#%01111111,(a6)	;set all bits except dsk-motor
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 1

	bclr.b	d0,(a6)	;driveselect

	bset.b	#1,(a6)		;CIA-B PRB, direction to zero
	btst.b	#4,$bfe001	;head on zero-position ?
	bne.b	headnotzero
	bclr.b	#1,(a6)		;CIA-B PRB, direction from zero
headnotzero:
	bclr.b	#0,$bfd100	;step signal
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 2
	bset.b	#0,$bfd100	;step signal
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 3
	btst.b	#2,$bfe001
	beq.b	searchdiscl5	;drive available, but no disc in it!

	moveq	#0,d0		;track 0
	moveq	#1,d1		;1 track

;	lea	trackloaderexc(pc),a2
;	move.l	a2,$80.w
;	trap	#0

	movem.l	d0-a6,-(a7)
	bsr.w	loadtrack
	movem.l	(a7)+,d0-a6

;	jsr	trackloader

	movem.l	(a7),d0-a6
	move.l	discname,d0
	move.l	14(a0),ActDiscName
	cmp.l	14(a0),d0
	beq.b	searchdiscl2

searchdiscl5:
move.w	opendrive,d0
lea	$bfd100,a6
move.b	#%11111111,(a6)	;set all bits except dsk-motor
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
bsr.w	waitawhile	;;james 4
bclr.b	d0,(a6)	;bit 3=drive0select
searchdiscl4:
	addq.w	#1,opendrive
	cmp.w	#7,opendrive
	bne.b	nodrivecyclerestart

	move.w	#3,opendrive
nodrivecyclerestart:
	move.w	drivecountstore,d7
	dbf	d7,searchdiscl3	;next drive

;-------------------------
	move.l	#100,d0
flash:
	move.w	#1,intflag2
intwait2:
	move.w	#$0600,$dff180
	nop
	nop
	nop
	move.w	#$0,$dff180
	tst.w	intflag2
	bne.b	intwait2

	dbf	d0,flash
;--------------------
;	movem.l	(a7)+,d0-a6
;	moveq	#1,d3	;code for 'disc not found'
;	rts
	bra	searchdiscl1

searchdiscl2:
	move.w	opendrive,lastdrive
	movem.l	(a7)+,d0-a6
;	lea	trackloaderexc(pc),a2
;	move.l	a2,$80.w
;	trap	#0
	movem.l	d0-a6,-(a7)
	bsr.w	loadtrack
	movem.l	(a7)+,d0-a6

;	jsr	trackloader
move.w	opendrive,d0
lea	$bfd100,a6
move.b	#%11111111,(a6)	;set all bits except dsk-motor

;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
bsr.w	waitawhile	;;james 5
bclr.b	d0,(a6)	;bit 3=drive0select
;;alfred
bsr.w	waitawhile	;;james 6
bset.b	d0,(a6)	;bit 3=drive0select
moveq	#0,d3
	rts



;########################################################################
;------------------
track_getdrivecode:
	move.b	#%00001000,d7	;df0 always available !
	moveq	#1,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive1
	bset.l	#4,d7
skipdrive1:
	moveq	#2,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive2
	bset.l	#5,d7
skipdrive2:
	moveq	#3,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive3
	bset.l	#6,d7
skipdrive3:
	lea	availdrives,a0
	move.b	d7,(a0)
	rts
;----------
;-----------
trackdecoder:;V2.3, 931016 ,code by Moon/ABYSS
movem.l	d0-a6,-(a7)
	move.l	trackbuffer(pc),a1
	moveq	#10,d7		;1 track = 11 sectors
	move.l	#$55555555,d6	;mascbits
trackdecoderl1:
	cmp.w	#$4489,(a1)+	;search syncword
	bne.b	trackdecoderl1
	cmp.w	#$4489,(a1)+	;second syncword
	beq.b	trackdecoderl2
	subq.l	#2,a1		;no second sync
	eor.l	d2,d0
trackdecoderl2:
	subq.l	#8,a1
	move.l	60(a1),d0	;data chksum:ONLY the odd bits are used
	and.l	d6,d0		;clear even

;normaly the saved mfm-checksum will be decoded, then simply compared
;with the calculated one.
;the calculated checksum is built by EORing all longwords, startvalue
;is zero.
;I use the decoded mfm-checksum as startvalue, the solution must be
;zero....nice coding, eh?

	lea	64(a1),a2	;data block adress
	moveq	#63,d5		;64*4*4=1024 mfm-bytes=512 decoded bytes
trackdecoderl3:
	movem.l	(a2)+,d1/d2/d3/d4
	eor.l	d1,d0
	eor.l	d2,d0
	eor.l	d3,d0
	eor.l	d4,d0
	dbf	d5,trackdecoderl3
	and.l	d6,d0
	bne.b	checksumbug

	move.w	10(a1),d0	;sector number and distance mfm-word1
	move.w	14(a1),d1	;sector number and distance mfm-word2
	and.w	d6,d0
	add.w	d0,d0
	and.w	d6,d1
	or.w	d1,d0		;sector number and distance decoded
	sub.b	d0,d0		;sector number (distance killed)
	add.w	d0,d0		;offset in trackblock (sectornumber*512)

	lea	(a0,d0.w),a3	;data destination
	lea	64(a1),a5	;data mfm part1
	lea	512(a5),a2	;data mfm part2

	moveq	#127,d5		;1 sector =128 decoded longwords
decodeloop:
	move.l	(a5)+,d0
	move.l	(a2)+,d1
	and.l	d6,d0
	add.l	d0,d0
	and.l	d6,d1
	or.l	d1,d0
	move.l	d0,(a3)+
	dbf	d5,decodeloop
	lea	1088(a1),a1	;64 header-bytes and 1024 databytes
	dbf	d7,trackdecoderl1	;next sector

;	lea	readerror(pc),a1	;******************************
;	move.w	#0,(a1)			;******************************

	movem.l	(a7)+,d0-a6
	moveq	#0,d2
	rts			;track checked and decoded

checksumbug:
;	lea	readerror(pc),a1	;******************************
;	addq.w	#1,(a1)			;******************************
;	addq.w	#1,allbugs		;******************************

	movem.l	(a7)+,d0-a6
	moveq	#-1,d2
	rts
;----------
drive_check:
movem.l	d0/d2-a6,-(a7)
	addq.b	#3,d0
	moveq	#0,d1
 	move.b	#%10000011,$bfd100	;motor off (all drives)
	jsr	waitawhile

 	move.b	#%01111011,$bfd100	;deselect all drives+motorbit lo
	jsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor on
	jsr	waitawhile

	move.b	#%11111011,$bfd100	;deselect all drives+motorbit hi
	jsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor off
	jsr	waitawhile

	bset.b	d0,$bfd100		;deselect drive
	jsr	waitawhile

	moveq	#1,d2
getidcode:
	bclr.b	d0,$bfd100		;select drive
	jsr	waitawhile
	move.b	$bfe001,d4		;get drive status (CIA-A)
	roxl.b	#3,d4
	roxl.b	#1,d1			;get DSKRDY-bit
	bset.b	d0,$bfd100		;deselect drive
	jsr	waitawhile

	dbf	d2,getidcode
movem.l	(a7)+,d0/d2-a6
rts




memorypoint_chip:	dc.l	0
memorypoint_fast:	dc.l	0


Writeline:
	lea	screen,a0
	lea	8*40(a0),a1
	move.w	#248*40/4-1,d7
scrollloop:
	move.l	(a1)+,(a0)+
	dbf	d7,scrollloop


	lea	Font,a0
	lea	screen+248*40,a1
	move.l	text_point,a2

	moveq	#39,d6
Writeline_charloop:

	move.w	(a2)+,d0
	lea	(a0,d0.w),a3

	moveq	#7,d7
Writeline_byteloop:
	move.b	(a3)+,(a1)
	lea	40(a1),a1
	dbf	d7,Writeline_byteloop
	lea	1-8*40(a1),a1
	dbf	d6,Writeline_charloop
	move.l	a2,text_point
rts


;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789,./<>;:[]*()!"
charsend:
even
text_point:	dc.l	text
textpoint:	dc.w	0;	|
text:;				|
dc.b	"         drugstore hd installer         "
dc.b	"                                        "
dc.b	"                                        "
dc.b	"note:                                   "
dc.b	"  hd version needs 1 meg more           "
dc.b	"  (0.5 chip, 1.5 public)                "
dc.b	"                                        "
dc.b	"!! swap discs when screen flashes red !!"
dc.b	"                                        "
dc.b	"                                        "
dc.b	"!!!!     not enough disc space      !!!!"
dc.b	"!!!!         1.3 mb needed          !!!!"
dc.b	"!!!!    press left mouse button     !!!!"
dc.b	"loading part 1...                       "
dc.b	"writing part 1...                       "
dc.b	"loading part 2...                       "
dc.b	"writing part 2...                       "
dc.b	"loading part 3...                       "
dc.b	"writing part 3...                       "
dc.b	"loading part 4...                       "
dc.b	"writing part 4...                       "
dc.b	"writing loader...                       "
dc.b	"                                        "
dc.b	"ready, press left mouse button          "

textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=8
textcalc:
	lea	textoffsetend(pc),a0
	lea	textend(pc),a1
	lea	charsend(pc),a2
	move.w	#textend-text-1,d7
textcalcl1:
	move.l	a2,a3
	move.b	-(a1),d0
	moveq	#charsend-chars-1,d6
textcalcl2:
	cmp.b	-(a3),d0	
	beq	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------




drivecountstore:	dc.w	0
lastdrive:	dc.w	3
trys:		dc.w	0
rereadcount:	dc.w	0
trackbuffer:	dc.l	0
availdrives:	dc.b	0
even
opendrive:	dc.w	0

Font:	incbin	"data/topaz8.raw"

;------------------------------------------------------------------------
openfile:			;routine oeffnet file
					;modus in D0 (load/save)
					;zaeher auf dateiname in D1
	move.l	dosbase,a6		;doslibstart in a6
	jsr	open(a6)		;datei oeffnen
	move.l	d0,filehandle		;filehandle retten
	rts


closefile:				;routine schliesst file
	move.l	dosbase,a6		;doslibstart in a6
	move.l	filehandle,d1		;filehandle in D1
	jsr	close(a6)		;datei schliessen
	rts

readfile:				;routine laedt file
	move.l	dosbase,a6		;dosbase in a6
	move.l	filehandle,d1		;filehandle in d1
	move.l	#$ffffff,d3		;beliebig viele bytes lesen
	jsr	read(a6)		;daten lesen
	rts

writefile:				;routine laedt file
	move.l	dosbase,a6		;dosbase in a6
	move.l	filehandle,d1		;filehandle in d1
	jsr	write(a6)		;daten lesen
	rts

seekfile:
					;got modus in d3
					;got position in d2
	move.l	dosbase,a6		;doslibstart in a6
	move.l	filehandle,d1		;filehandle in D1
	jsr	seek(a6)
	rts


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
ifne	determblink
move.w	#$0990,$dff180
endif
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3
ifne	determblink
move.w	#$0009,$dff180
endif

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

ifne	determblink
move.l	#0,$dff180
endif
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
relocator2:
movem.l	d0-a6,-(a7)
	move.l	a1,memorypoint_chip
	move.l	a2,memorypoint_fast
	move.w	#0,hunk_work

	cmp.l	#$000003f3,(a0)+	;hunk header
	bne.w	bug2			;not executable or file damaged

	cmp.l	#0,(a0)+		;hunkname
	bne.w	bug2			;bug if there's a hunkname
					;(not supported yet)


	move.l	(a0)+,hunk_quant	;number of hunks
	move.l	(a0)+,hunk_first	;first hunknumber
	move.l	(a0)+,hunk_last		;last hunknumber

	move.l	hunk_quant,d7		;number of hunks
	subq.w	#1,d7
	move.l	a2,d6			;fastmem to test if valid
	move.l	a1,d5			;test if hunktable valid
	bne.b	reloc_nohunktab

	moveq	#0,d6
reloc_nohunktab:

	lea	hunk_lengths(pc),a1	;memory for hunk-lengths
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
	move.l	memorypoint_fast,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_fast
	bra.b	reloc_memorytaken

reloc_takechip:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length

	tst.l	d5
	beq.b	reloc_gethunktable

	move.l	memorypoint_chip,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_chip
	bra.b	reloc_memorytaken

reloc_gethunktable:
	move.l	memorypoint_fast,a3
	move.l	(a3)+,(a1)+		;store startadress
	move.l	a3,memorypoint_fast

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

bug2:
;	move.w	#$0f00,$dff180
;	move.w	#$0ff0,$dff180
;	btst	#6,$bfe001
;	bne	bug2
	moveq	#-1,d0
	movem.l	(a7)+,d0-a6
	rts
depp:	dc.w	0
;------------------------------------------------------------------------
;---------
hunk_code:
	move.l	(a0)+,d7		;hunk code length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work,d6		;number of this hunk
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
	move.w	hunk_work,d6		;number of this hunk
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
	move.w	hunk_work,d6		;number of this hunk
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
	addq.w	#1,hunk_work
	subq.l	#1,hunk_quant
	bne.w	reloc_mainloop
	movem.l	(a7)+,d0-a6
	moveq	#0,d0			;no bug
	rts				;;finished
;----------


hunk_maximum=100
hunk_quant:	dc.l	0
hunk_first:	dc.l	0
hunk_last:	dc.l	0
hunk_lengths:	dcb.l	hunk_maximum*2,0

hunk_work:	dc.w	0




filehandle:		dc.l	0	;filehandle
lockadr:		dc.l	0
dosbase:		dc.l	0
length:			dc.l	100
dosname:		dc.b	"dos.library",0,0
even
DataName:		dc.b	"Drugstore.data",0
even
installname:		dc.b	"drugstore.install",0
even
LoaderName:		dc.b	"Drugstore.exe",0
even


;------------------------------------------------------------------------


discname:	dc.l	0



Discerrorcode:	incbin	"/code/Error.term"

b:

codec_e:

;------------------------------------------------------------------------
ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
Screen:		ds.b	256*40
Chip_Memory:
Discbuffer:	ds.b	30000
bssc_e:
;------------------------------------------------------------------------
ifne	UseSection
section	BSSP,bss_p
endif
bssp_s:

fastmemory:
Fast_Memory:
Buffer:	ds.b	400000
Fast_Memoryend:
bssp_e:



PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
Printblock=0
include	"/include/DiscPosLen.i"
;----------
;Disc names
DrugstoreDisc1="drg1"
DrugstoreDisc2="drg2"


DiscNam_LoMem=DrugstoreDisc1



ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:


ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:

ifne	UseSection
section	DataP,data_p
endif
datap_s:
Loader_s:
incbin	"data/HDLoader.code"
Loader_e:
datap_e:

ifne	Printmem
printt	"Code Chip:"
printv	codec_e-codec_s
printt	"Data Chip:"
printv	datac_e-datac_s
printt	"BSS Chip"
printv	bssc_e-bssc_s
printt	"Code Public:"
printv	codep_e-codep_s
printt	"Data Public:"
printv	datap_e-datap_s
printt	"BSS Public"
printv	bssp_e-bssp_s
printt
printt	"Chip Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s
printt	"Public Memory:"
printv	codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s
endif


DiscPos_Part1=DiscPos_Main
DiscLen_Part1=DiscLen_Main+DiscLen_PDNote+Disclen_Block1
DiscNam_Part1=DrugstoreDisc1
;including Lomem

DiscPos_Part2=DiscPos_Block2
DiscLen_Part2=DiscLen_Block2+DiscLen_Module2
DiscNam_Part2=DrugstoreDisc1

DiscPos_Part3=DiscPos_Block3
DiscLen_Part3=DiscLen_Block3
DiscNam_Part3=DrugstoreDisc2

DiscPos_Part4=DiscPos_Block4
DiscLen_Part4=DiscLen_Block4+DiscLen_Module3+DiscLen_Endpart
DiscNam_Part4=DrugstoreDisc2


