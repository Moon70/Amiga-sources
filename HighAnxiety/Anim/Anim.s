UseSection=1

Main_Initcall=2

Planesize=64*40



;------
Main_Showtime=0
Main_ProgramID=1
Main_Cache=1
Main_SkipWBStartTest=1
Main_Joyhold=0
;------

ifne	UseSection
section	CodeC,code_c
endif
codec_s:
include	"include/maininit/Maininit6.2.s"

bpl7ptl=bpl6ptl+4
bpl8ptl=bpl7ptl+4
bpl7pth=bpl6pth+4
bpl8pth=bpl7pth+4
bplcon3=$106
fmode=$1fc

;------------------------------------------------------------------------

main_init:;;
	tst.w	firstinit
	bne	secondinit

	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand

	move.w	#1,firstinit

bssc_clr:
	lea	bssc_s,a0
	move.w	#(bssc_c-bssc_s)/4-1,d7
	moveq	#0,d0
bssc_clrloop:
	move.l	d0,(a0)+
	dbf	d7,bssc_clrloop

	jsr	coppercopy
	jsr	calchashzoomtable

	move.l	Main_Talk,a0
	move.l	#Loaderdata,d0
	lsl.l	#8,d0
	move.b	#Main_ProgramID,d0
	ror.l	#8,d0
	move.l	d0,(a0)



	movem.l	(a7)+,d0-a6
	rts
;----------
secondinit:
	movem.l	d0-a6,-(a7)
	jsr	setpic
	jsr	switchplanes_anim
	movem.l	(a7)+,d0-a6
	rts
;------------------------------------------------------------------------
;---------
main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
;-------------------------
	movem.l	d0-a6,-(a7)
	move.w	#$4181,diwstrt(a5)
	move.w	#$01c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0000001000010000,bplcon0(a5)
;	move.w	#%0111001000000000,bplcon0(a5)
	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
;	move.w	#%0000001000000000,bplcon2(a5)
	move.w	#%0000000000000000,bplcon2(a5)

	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

	move.w	#0,bpl1mod(a5)
	move.w	#0,bpl2mod(a5)

	move.l	Main_VBIVector,a0
	move.l	#VBI,(a0)

	move.l	Main_Copperlist,a0
	move.l	#copperlist,(a0)

	move.l	Main_MasterCommand,a0
	move.l	#MainLoop,4(a0)		;second priority mastercommand
	movem.l	(a7)+,d0-a6
;-------------------------
	rts


MainLoop:
	tst.w	sleep_wave
	bne	skipsetwave
	move.w	#3,sleep_wave
	tst.w	f_skipwave
	bne	skipsetwave
	jsr	setwave
	jsr	switchplanes_wave
	move.w	#0,sleep_coppercopy
skipsetwave:
	rts






MoonLib:
incdir	"include/moonlib/"
include	"moonlib1.0.s"
incdir	""


animsleep:	dc.w	3
animcount:	dc.w	160


Commands:;;
	dc.l	360,	nothing
	dc.l	1,	decrunch,	moon
	dc.l	1,	enablewave
	dc.l	1,	enablewave
	dc.l	1,	FadeToWhite
	dc.l	591,	nothing
	dc.l	15*3,	FadeToAnim

	dc.l	1,	decrunch,	dexter

	dc.l	1,	enablewave
	dc.l	1,	enablewave
	dc.l	1,	FadeToWhite
	dc.l	591,	nothing
	dc.l	15*3,	FadeToAnim

	dc.l	1,	decrunch,	pink

	dc.l	1,	enablewave
	dc.l	1,	enablewave
	dc.l	1,	FadeToWhite
	dc.l	591,	nothing
	dc.l	15*3,	FadeToAnim

	dc.l	1,	decrunch,	toxic

	dc.l	1,	enablewave
	dc.l	1,	enablewave
	dc.l	1,	FadeToWhite
	dc.l	591,	nothing
	dc.l	15*3,	FadeToAnim
	dc.l	1,	clearwavepic
	dc.l	1,	enablesetpic

;	dc.l	5,	enablewave
;	dc.l	1,	disablewave

;-------
	dc.l	50000,	nothing
;-------
	dc.l	60000,	exit
	dc.l	60000,	exit


codec_e:
;-----------------------------------------------

ifne	UseSection
section	CodeP,code
endif
codep_s:




nothing:	rts

exit:
	move.l	Main_Talk,a0
	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	d0,(a0)
	rts

restart:
	move.w	#0,Commander_Point
	rts

decrunch:
	move.l	(a1),a1
	addq.w	#4,Commander_Point
	lea	wavepic,a0
	lea	MoonLib,a6
	jsr	(a6)
rts

enablesetpic:
	move.w	#0,f_skipsetpic
rts

clearwavepic:
	lea	wavepic,a0
	moveq	#0,d0
	move.w	#80*192/4-1,d7
clearwavepic_loop:
	move.l	d0,(a0)+
	dbf	d7,clearwavepic_loop
rts

FadeToWhite:
	move.w	#4,colfaktordir
rts

FadeToAnim:
	move.w	#-16,colfaktordir
rts

enablewave:
	move.w	#0,f_skipwave
	move.w	#3,sleep_wave
	move.w	#8,testsindir
	move.w	#0,testsinpos
	rts

disablewave:
	move.w	#1,f_skipwave
	move.w	#0,testsindir
	move.w	#0,testsinpos
	rts


setpalette:
	lea	colfaktordir(pc),a0
	move.w	(a0)+,d0
	move.w	(a0),d1
	add.w	d0,d1
	bmi	colfaktorunderflow
	cmp.w	#256,d1
	bne	nocolfaktorflow
colfaktorunderflow:
	move.w	#0,-2(a0)
	sub.w	d0,d1
nocolfaktorflow:	
	move.w	d1,(a0)



	move.l	showplanes(pc),a0
	move.l	(a0),a0


	moveq	#1,d6
colcopyhiloop2:
	moveq	#1,d2
	sub.w	d6,d2
	ror.w	#3,d2
	or.w	#2^5,d2
	bset.l	#9,d2

	lea	$180(a5),a1
	moveq	#15,d7
	move.w	d2,bplcon3(a5)
colcopyhiloop1:
	move.l	(a0)+,(a1)+
	dbf	d7,colcopyhiloop1
	dbf	d6,colcopyhiloop2


	moveq	#1,d6
colcopyloloop2:
	moveq	#1,d2
	sub.w	d6,d2
	ror.w	#3,d2

	lea	$180(a5),a1
	moveq	#15,d7
	move.w	d2,bplcon3(a5)
colcopyloloop1:
	move.l	(a0)+,(a1)+
	dbf	d7,colcopyloloop1
	dbf	d6,colcopyloloop2

	sub.w	#64*2,a0

	moveq	#1,d6
colcopyloop2_2:
	moveq	#3,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)

move.w	d6,-(a7)
moveq	#0,d6
move.w	colfaktor(pc),d6

	lea	$180(a5),a1
	moveq	#31,d7
colcopyloop1_2:
	moveq	#0,d0
	move.w	(a0)+,d0	;rgb
	move.l	d0,d1
	move.l	d0,d2
	lsr.w	#8,d0		;r
	lsr.w	#4,d1
	and.w	#%1111,d1	;g
	and.w	#%1111,d2	;b

	moveq	#%1111,d3	;r white
	move.l	d3,d4		;g white
	move.l	d3,d5		;b white

	sub.w	d0,d3		;delta r
	sub.w	d1,d4		;delta g
	sub.w	d2,d5		;delta b
;always fading to white-->always positive delta's (always ultra)

	lsl.l	#8,d3		;=swap	d3 + lsr.l #8,d3 (float + /256)
	lsl.l	#8,d4
	lsl.l	#8,d5
	mulu.l	d6,d3
	mulu.l	d6,d4
	mulu.l	d6,d5
	swap	d3
	swap	d4
	swap	d5
	add.w	d3,d0
	add.w	d4,d1
	add.w	d5,d2
	lsl.w	#4,d0
	or.w	d1,d0
	lsl.w	#4,d0
	or.w	d2,d0

	move.w	d0,(a1)+

	dbf	d7,colcopyloop1_2
move.w	(a7)+,d6
	dbf	d6,colcopyloop2_2



	moveq	#1,d6
colclrhiloop2:
	moveq	#3,d2
	sub.w	d6,d2
	ror.w	#3,d2
	bset.l	#9,d2

	lea	$180(a5),a1
	moveq	#15,d7
	move.w	d2,bplcon3(a5)
	moveq	#0,d0
colclrhiloop1:
	move.l	d0,(a1)+
	dbf	d7,colclrhiloop1
	dbf	d6,colclrhiloop2


;move.w	#0,bplcon3(a5)
;move.w	#$000f,$180(a5)
	rts

colfaktordir:	dc.w	0	;|
colfaktor:	dc.w	0	;|
Animpixpos:	dc.l	anim
Animcolpos:	dc.l	animcol

waitforcont:	dc.l	0	;if not zero, wait for pos and continue...

firstinit:	dc.w	0,0


setpic:
	move.l	waitforcont(pc),d0
	beq	nowaitingforcont
	cmp.l	workplanes(pc),d0
	bne	setpic_skip
	move.l	#0,waitforcont
	move.w	#1,f_skipwave

nowaitingforcont:
	lea	hashzoomtable(pc),a3
	move.w	animpos(pc),d0
	addq.w	#1,d0
	move.w	d0,animpos
	cmp.w	#121,d0
	bne	noanimloop
	move.w	#1,f_skipsetpic
	move.l	workplanes(pc),waitforcont
noanimloop:
	move.l	animcolpos(pc),d1
	move.l	d1,nextpalette
	move.l	workplanes(pc),a1
	move.l	d1,(a1)+
	addq.l	#4,a1
	add.l	#256,d1
	move.l	d1,animcolpos

;	move.l	a0,nextpalette
	move.l	animpixpos(pc),a0


;	add.l	#64*2*2,a0

	moveq	#0,d1

	moveq	#15,d2
	moveq	#5,d5	;planes
planeloop:
	move.l	a1,a2

	move.w	#10*64-1,d7	;10 bytes/line * 64 lines (bytecounter)
byteloop:
	move.b	(a0)+,d1

	move.l	(a3,d1.w*4),d0

	move.l	d0,(a2)+

	dbf	d7,byteloop
	add.l	#planesize,a1
	dbf	d5,planeloop
	move.l	a0,animpixpos

	move.w	animcount,d0
	subq.w	#1,d0
	bne	setpic_noanimend
;	move.w	#1,f_skipsetpic
	sub.l	#256,animcolpos
	sub.l	#3840,animpixpos

	cmp.w	#3,Commander_Sleep
	bls	Setpic_Commandersleepset
	move.w	#3,Commander_Sleep
Setpic_Commandersleepset:

	bra	setpic_skip

setpic_noanimend:
	move.w	d0,animcount

setpic_skip:
rts



calchashzoomtable:
	lea	hashzoomtable(pc),a0
	moveq	#%1111,d2

	move.w	#256-1,d7
calchashzoomtable_byteloop:
	moveq	#0,d0
	move.l	(a0),d1
	moveq	#7,d6		;8 bit/byte (what else)
calchashzoomtable_bitloop:
	lsl.l	#4,d0
	roxl.b	#1,d1
	bcc	calchashzoomtable_nobit
	add.w	d2,d0
calchashzoomtable_nobit:
	dbf	d6,calchashzoomtable_bitloop
	move.l	d0,(a0)+
	dbf	d7,calchashzoomtable_byteloop
rts


hashzoomtable:
value:	set	0
rept	256
dc.l	value
value:	set	value+1
endr


testsindir:	dc.w	0	;|
testsinpos:	dc.w	0	;|

setwave:
	lea	testsindir(pc),a0
	move.w	(a0)+,d1
	move.w	(a0),d0
	add.w	d1,d0
	cmp.w	#testsinxend-testsinx-544,d0	;544=96*4+80*2
;	cmp.w	#720,d0
	bne	notestsinxflow
	sub.w	d1,d0
	move.w	#0,-2(a0)
notestsinxflow:
	move.w	d0,(a0)

	lea	testsinx(pc),a3
	add.w	d0,a3
	lea	testsiny(pc),a5
	add.w	d0,a5

	lea	wavepic,a0
	move.l	workwaveplane(pc),a1

	move.l	a1,a2

	moveq	#96-1,d7	;10 bytes/line * 64 lines (bytecounter)
setwave_lineloop:
	move.l	a3,a4
	move.l	a5,a6
	addq.l	#4,a3
	addq.l	#2,a5

	moveq	#10-1,d6
setwave_byteloop:

	moveq	#2-1,d5		;8 bit/byte (what else)
setwave_bitloop:
	movem.l	(a4)+,d3-d4	;*160
	movem.l	(a6)+,d1-d2

	add.l	d3,d1
	swap	d1
	lsl.l	#2,d0
	add.b	(a0,d1.w),d0

	swap	d1
	lsl.l	#2,d0
	add.b	1(a0,d1.w),d0

	add.l	d4,d2
	swap	d2
	lsl.l	#2,d0
	add.b	2(a0,d2.w),d0

	swap	d2
	lsl.l	#2,d0
	add.b	3(a0,d2.w),d0



	movem.l	(a4)+,d3-d4	;*160
	movem.l	(a6)+,d1-d2

	add.l	d3,d1
	swap	d1
	lsl.l	#2,d0
	add.b	4(a0,d1.w),d0

	swap	d1
	lsl.l	#2,d0
	add.b	5(a0,d1.w),d0

	add.l	d4,d2
	swap	d2
	lsl.l	#2,d0
	add.b	6(a0,d2.w),d0

	swap	d2
	lsl.l	#2,d0
	add.b	7(a0,d2.w),d0

	addq.l	#8,a0

	dbf	d5,setwave_bitloop
	move.l	d0,(a2)+
	dbf	d6,setwave_byteloop
	dbf	d7,setwave_lineloop
	lea	$dff000,a5
	rts


VBI:
	move.l	showplanes(pc),a0
	addq.l	#8,a0		;skip coltab-ptr and dummy.l
	move.l	a0,bpl1pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl6pth(a5)

	bsr	setpalette

	tst.w	sleep_coppercopy
	bne	skip_coppercopy
	move.w	#1,sleep_coppercopy
	bsr	coppercopy2
skip_coppercopy:

	subq.w	#1,animsleep
	bne	skip_anim
	move.w	#3,animsleep

	tst.w	f_skipsetpic
	bne	skipsetpic
	bsr	setpic
skipsetpic:
	bsr	switchplanes_anim

skip_anim:
	jsr	commander

	subq.w	#1,sleep_wave
	bpl	no_wavetimeoverflow
	move.w	#0,sleep_wave
;	move.w	#$0,bplcon3(a5)
;	move.w	#$0s0f0,$180(a5)
no_wavetimeoverflow:
rts

sleep_coppercopy:	dc.w	1
sleep_wave:		dc.w	10

showwaveplane:
		dc.l	wavescreen1		;|
workwaveplane:	dc.l	wavescreen2		;|

showplanes:	dc.l	screen+planesize*6	;|
workplanes:	dc.l	screen			;|

nextpalette:	dc.l	animcol
f_skipsetpic:	dc.w	0
f_skipwave:	dc.w	1
animpos:	dc.w	0


switchplanes_anim:
	lea	showplanes(pc),a0
	move.l	4(a0),d0
	move.l	d0,(a0)+
	add.l	#planesize*6+8,d0
	cmp.l	#screenend,d0
	bne	noscreenrestart
	move.l	#screen,d0
noscreenrestart:
	move.l	d0,(a0)
	rts

switchplanes_wave:
	lea	showwaveplane(pc),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	rts

coppercopy:
	lea	copperlist,a0
	move.l	a0,d6
	move.w	#$410f,d0
	move.l	showwaveplane(pc),d1
	moveq	#0,d2
	moveq	#40,d3
	move.w	d0,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0111001000000001,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#%0000000000000000,(a0)+
	move.w	#bplcon3,(a0)+
	move.w	#%0000000000100000,(a0)+

	lea	copperoffsets,a1

	moveq	#63,d7
coppercopy_loop:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+

	move.w	#bpl7ptl,(a0)+
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	move.w	#bpl7pth,(a0)+
	swap	d1
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	move.w	#bpl1mod,(a0)+
	move.w	#-40,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#-40,(a0)+

	add.w	#$0100,d0
	bcc	nocopperflow0
	move.l	#$ffdffffe,(a0)+
nocopperflow0:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+

	move.w	#bpl7ptl,(a0)+
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	move.w	#bpl7pth,(a0)+
	swap	d1
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	add.w	#$0100,d0
	bcc	nocopperflow3
	move.l	#$ffdffffe,(a0)+
nocopperflow3:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+

	move.w	#bpl7ptl,(a0)+
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	move.w	#bpl7pth,(a0)+
	swap	d1
move.l	a0,d5
sub.l	d6,d5
move.w	d5,(a1)+
	move.w	d1,(a0)+
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	add.w	#$0100,d0
	bcc	nocopperflow2
	move.l	#$ffdffffe,(a0)+
nocopperflow2:
	dbf	d7,coppercopy_loop

;	move.w	d0,(a0)+
;	move.w	#-2,(a0)+
;	move.w	#bplcon0,(a0)+
;	move.w	#%0000001000000000,(a0)+

	move.l	#-2,(a0)
	rts

coppercopy2:
	lea	copperlist,a0
	move.l	showwaveplane(pc),d1
	lea	copperoffsets,a1

	moveq	#0,d2
	moveq	#40,d3


	moveq	#63,d7
coppercopy1_loop:
	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	move.w	(a1)+,d6
	move.w	d1,(a0,d6.w)
	swap	d1
	add.l	d2,d1
	exg.l	d2,d3

	dbf	d7,coppercopy1_loop
	rts



credits:
moon:	incbin	"data/moon.term"
even
dexter:	incbin	"data/dexter.term"
even
pink:	incbin	"data/pink.term"
even
toxic:	incbin	"data/toxic.term"
even

testsinx:
incbin	"data/sinxx.bin"
testsinxend:

testsiny:
incbin	"data/sinyy.bin"
testsinyend:

Loaderdata:	dc.l	anim
		dc.l	animcol

CopperOffsets:	dcb.b	5000,0


animcol:	ds.b	64*4*160
animcolend:

codep_e:




ifne	UseSection
section	BSSC,data_c
endif
bssc_s:
Copperlist:	ds.b	3504
Wavescreen1:	ds.b	40*96
Wavescreen2:	ds.b	40*96

;dcb.b	2000,3
ds.b	25*160
wavepic:	ds.b	80*192
wavepicend:
ds.b	25*160
;dcb.b	2000,3

bssc_c:


Screen:
		ds.b	(40*64*6+8)*80
Screenend:					;|
		ds.b	614400-(10*64*6)*80	;|  animsize-part of screenmem
anim=Screenend-(10*64*6)*80
animend:



>extern	"data/HighAnxAnim5.raw",anim
>extern	"data/HighAnxAnim5.col",animcol


bssc_e:



ifne	UseSection
;section	DataC,data_c
endif
datac_s:

datac_e:

ifne	UseSection
;section	DataP,data_p
endif
datap_s:
datap_e:

ifne	UseSection
;section	BSSP,bss_p
endif
bssp_s:
bssp_e:

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
printt	"Object Memory:"
printv	codec_e-codec_s+datac_e-datac_s+codep_e-codep_s+datap_e-datap_s
printt	"Total Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s+codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s



