;------------------------------------------------------------------------
;|                                                                      |
;|                          The Dotty Mountains                         |
;|                         ---------------------                        |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                                   |
;------------------------------------------------------------------------
UseSection=1

xsize=56
ysize=54
angstep=6*4
angles=180/(angstep/4)

dotxdiff=5
dotydiff=5
dotxstart=-(xsize/2*dotxdiff)
dotystart=-(ysize/2*dotydiff)

kx=0
ky=0
kz=200

;500 $0dfa
;300 $189c
;250 $23ab
;200 $3a64
;180 $499b
;175 $4dae



ifne	UseSection
section	CodeC,code_c
endif
codec_s:
;-----------------------------------

showtime=0
Program_ID=1
Main_Initcall2=1
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	tst.w	f_initcount
	bne.b	secondinitcall
	move.w	#1,f_initcount
	jsr	precalc
	jsr	landprecalc
	jsr	makecode
	bra.b	main_initback
secondinitcall:
	lea	bssc_s,a0
	moveq	#0,d0
	move.w	#(bssc_e-bssc_s)/4-1,d7
bssc_clr:
	move.l	d0,(a0)+
	dbf	d7,bssc_clr
	
	jsr	switchplanes

main_initback:
	movem.l	(a7)+,d0-a6
	rts
;----------
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
	move.l	Main_VBIVector(pc),a0
	move.l	#introut,(a0)

	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist,(a0)

	lea	$180(a5),a0
	move.l	#$00000000,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+

	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003800d0,ddfstrt(a5)	;strt+stop!
	move.w	#%0011001000000000,bplcon0(a5)
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.l	#$00500050,bpl1mod(a5)	;1mod+2mod!



main_loop:
	lea	maincommand(pc),a0
	tst.l	(a0)
	bmi.b	main_loopexit
	beq.b	main_loop

	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	bra.b	main_loop

main_loopexit:
	rts
;----------

Commands:;;





;------------------------------------------------------------------------
introut:
	movem.l	d0-d7/a0-a6,-(a7)

	lea	$dff000,a5
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)

	add.l	#40,d0
	move.l	d0,bpl2pth(a5)

	add.l	#40,d0
	move.l	d0,bpl3pth(a5)

	add.l	#40,d0
	move.l	d0,bpl4pth(a5)


	jsr	planecls
	jsr	Draw
	jsr	switchplanes

	jsr	joystic
	movem.l	(a7)+,d0-d7/a0-a6
	rts
;----------
;------------------------------------------------------------------------
;--------
makecode:
	lea	dotcode,a0
	moveq	#ysize-1,d7
makecodel1:
	moveq	#xsize/4-1,d6
makecodel2:
	lea	code1,a1
	moveq	#code2-code1-1,d5
makecodel3:
	move.b	(a1)+,(a0)+
	dbf	d5,makecodel3
	dbf	d6,makecodel2
	lea	code2,a1
	moveq	#code3-code2-1,d5
makecodel4:
	move.b	(a1)+,(a0)+
	dbf	d5,makecodel4
	dbf	d7,makecodel1
	rts	
;----------
;-----
code1:
	movem.w	(a0)+,d0-d7
	sub.w	(a5)+,d0
	bset.b	d1,(a1,d0.w)

 	sub.w	(a5)+,d2
	bset.b	d3,(a1,d2.w)

	sub.w	(a5)+,d4
	bset.b	d5,(a1,d4.w)

	sub.w	(a5)+,d6
	bset.b	d7,(a1,d6.w)
code2:
	lea	320*2-xsize*2(a5),a5
code3:
;-----
;----
Draw:
	move.w	conpoint(pc),d0
	lea	dottable(pc),a0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a0,d0.w),d0

	lea	dotscon,a0
	add.l	d0,a0

	move.l	pointplane(pc),a1
	lea	256*40(a1),a2
	lea	256*40(a2),a3
	lea	256*40(a3),a4

	lea	landcalc,a5
	moveq	#0,d7
	move.w	camposy(pc),d7
	mulu	#640,d7
	lea	(a5,d7.l),a5
	move.w	camposx(pc),d7
	lea	(a5,d7.w),a5
	jmp	dotcode
;----------------------
;-----------
Landprecalc:
	lea	landcalcend,a0
	lea	landpic+51200,a1
	lea	multab_land(pc),a2
	move.w	#255,d7
landcalcy:
	swap	d7
	move.w	#39,d7
landcalcx:
	move.b	-(a1),d5
	move.b	-1*40(a1),d4
	move.b	-2*40(a1),d3
	move.b	-3*40(a1),d2
	move.b	-4*40(a1),d1
	moveq	#7,d6
landcalcxb:
	moveq	#0,d0
	roxr.b	#1,d5
;	roxl.b	#1,d0
	addx.w	d0,d0
	roxr.b	#1,d4
;	roxl.b	#1,d0
	addx.w	d0,d0
	roxr.b	#1,d3
;	roxl.b	#1,d0
	addx.w	d0,d0
	roxr.b	#1,d2
;	roxl.b	#1,d0
	addx.w	d0,d0
	roxr.b	#1,d1
;	roxl.b	#1,d0
	addx.w	d0,d0
	add.w	d0,d0
	beq.b	landcalczero

	move.w	(a2,d0.w),d0
;	mulu	#120,d0
;	add.w	#40,d0

;	cmp.w	#120*15,d0
;	ble	landcalclocol
;	add.w	#40,d0
landcalclocol:
landcalczero:
	move.w	d0,-(a0)
	dbf	d6,landcalcxb
	dbf	d7,landcalcx
	lea	-40*4(a1),a1
	swap	d7
	dbf	d7,landcalcy
	rts
;----------
Multab_Land:
value:	set	0
rept	16
	dc.w	value*120+40
value:	set	value+1
endr

rept	16
	dc.w	value*120+40+40
value:	set	value+1
endr

;-------
precalc:
;data usage: 4 bytes per dot, word1 and word2
;1: prepare main grid, word1=x, word2=y

	lea	turnanim,a0
	moveq	#angles-1,d7	;number of pics
gridsetangle:
	move.w	#dotystart,d1
	moveq	#ysize-1,d6	;dots y
gridsety:
	move.w	#dotxstart,d0
	moveq	#xsize-1,d5	;dots x
gridsetx:
	move.w	d0,(a0)+
	move.w	d1,(a0)+

	addq.w	#dotxdiff,d0
	dbf	d5,gridsetx
	addq.w	#dotydiff,d1
	dbf	d6,gridsety
	dbf	d7,gridsetangle
;-------------------------------

;-------------------------------
;turn grid, word1=x, word2=y

	lea	turnanim,a0
	move.w	#60*4,turnx
	move.w	#0,turny
	move.w	#0,turnz
	moveq	#angles-1,d7	;number of pics
turnangle:
	moveq	#ysize-1,d6	;dots y
turnsety:
	moveq	#xsize-1,d5	;dots x
turnsetx:
	move.w	(a0),d0
	move.w	2(a0),d1
	movem.l	d5-d7/a0,-(a7)
	bsr.w	turner
				;now d0=x
				;    d1=y
				;    d2=z
;now perspective calculation
;(of course now, coz theres no mem to prestore the z-values!)
;bra	skippers
	sub.w	#kz,d2

;	sub.w	#kx,d0
	muls	#kx-kz,d0
	divs	d2,d0

;	sub.w	#ky,d1
	muls	#ky-kz,d1
	divs	d2,d1

skippers:
	movem.l	(a7)+,d5-d7/a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	dbf	d5,turnsetx
	dbf	d6,turnsety
	add.w	#angstep,turnz
	dbf	d7,turnangle
;-------------------------------


;-------------------------------
;convert data, word1=offset, word2=0.b;bit.b

	lea	turnanim,a0
	lea	Multab_Conv(pc),a1

	moveq	#angles-1,d7	;number of pics
convertangle:
	moveq	#ysize-1,d6	;dots y
converty:
	moveq	#xsize-1,d5	;dots x
convertx:
	moveq	#80,d0
	add.w	d0,d0
	moveq	#78,d1
	add.w	(a0),d0
	bpl.b	convxnoneg
convbeyond:			;dot beyond spezified area
	moveq	#0,d0
	moveq	#0,d1
	bra.b	convertwrite

convxnoneg:
	add.w	2(a0),d1
	bmi.b	convbeyond
	cmp.w	#319,d0
	bhi.b	convbeyond
	cmp.w	#255,d1
	bhi.b	convbeyond

;	mulu.w	#40*3,d1	;y * bytes/plane
	add.w	d1,d1
	move.w	(a1,d1.w),d1

	move.w	d0,d2
	lsr.l	#3,d2		;x/8
	add.w	d2,d1		;add xoffset to yoffset
	not.w	d0
	and.w	#%0000000000000111,d0
	
convertwrite:
	move.w	d1,(a0)+
	move.w	d0,(a0)+
	dbf	d5,convertx
	dbf	d6,converty
	dbf	d7,convertangle
;-------------------------------
	rts
;----------
Multab_Conv:
value:	set	0
rept	256
	dc.w	value*40*3
value:	set	value+1
endr

f_initcount:	dc.w	0
turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0

turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0
turnx:		dc.w	0
turny:		dc.w	0
turnz:		dc.w	0


turner:

turner1:
	lea	sinus,a6	;sinus/cosinus
	move.w	turnx(pc),a1
	move.w	turny(pc),a2
	move.w	turnz(pc),a0

	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.w	d0,d3		;x
	move.w	d1,d4		;y
	move.l	#$8000,d0

	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=y
	muls.w	d5,d3		;d3=x*cos z
	muls.w	d5,d7		;d7=y*cos z
	swap	d5
	muls.w	d5,d4		;d4=y*sin z
	muls.w	d5,d6		;d6=x*sin z
	sub.l	d4,d3		;d3=x*cos z - y*sin z  ->new  x-koord
	add.l	d3,d3
add.l	d0,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
add.l	d0,d6
	swap	d6


move.w	d3,d1	;x
move.w	d6,d3	;y
	move.l	0(a6,a1.w),d5	;d5:hiword=sin x ,loword=cos x 
moveq	#0,d4	;z

	move.w	d3,d6		;d6=y
	move.w	d4,d7		;d7=z
	muls.w	d5,d3		;d3=y*cos x
	muls.w	d5,d7		;d7=z*cos x
	swap	d5
	muls.w	d5,d4		;d4=z*sin x
	muls.w	d5,d6		;d6=y*sin x
	sub.l	d4,d3		;d3=y*cos x - z*sin x ->new y-koord
	add.l	d3,d3
add.l	d0,d3
	swap	d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	add.l	d6,d6
add.l	d0,d6
	swap	d6

move.w	d1,d0
move.w	d3,d1
move.w	d6,d2
rts
;*****

;--------
planecls:
	lea	$dff000,a5
	move.l	clearplane(pc),d0
	move.l	d0,BLTDPTH(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#3*256*64+20,BLTSIZE(A5)
	rts
;----------
;------------
switchplanes:
	tst.w	switchmark
	beq.b	switch1
	bmi.b	switch2
	move.l	#plane1,showplane
	move.l	#plane2,clearplane
	move.l	#plane3,pointplane
	move.w	#0,switchmark
	rts
switch1:
	move.l	#plane3,showplane
	move.l	#plane1,clearplane
	move.l	#plane2,pointplane
	move.w	#-1,switchmark
	rts
switch2:
	move.l	#plane2,showplane
	move.l	#plane3,clearplane
	move.l	#plane1,pointplane
	move.w	#1,switchmark
	rts
switchmark:	dc.l	0
;----------

sinxpos:	dc.w	0
sinypos:	dc.w	0
sinzpos:	dc.w	0

joystic:
	move.w	sinxpos,d0
	addq.w	#2,d0
	cmp.w	#1440,d0
	bne.b	noxflow
	moveq	#0,d0
noxflow:
	move.w	d0,sinxpos

	move.w	sinypos,d1
	addq.w	#4,d1
	cmp.w	#1440,d1
	bne.b	noyflow
	moveq	#0,d1
noyflow:
	move.w	d1,sinypos

	move.w	sinzpos,d2
	addq.w	#4,d2
	cmp.w	#360+800,d2
	bne.b	nozflow
	moveq	#0,d2
nozflow:
	move.w	d2,sinzpos


	lea	sinusx,a0
	move.w	(a0,d0.w),d0
	bclr	#0,d0
	lea	sinusy,a0
	move.w	(a0,d1.w),d1
	lea	sinusz,a0
	move.w	(a0,d2.w),d2

	move.w	d0,camposx
	move.w	d1,camposy
	move.w	d2,conpoint

rts
	

camposx:	dc.w	0
camposy:	dc.w	0
conpoint:	dc.w	0





dottable:
value:	set	0
rept	30
dc.l	value*xsize*ysize*4
value:	set	value+1
endr

;	blk.l	angles,0



pointplane:	dc.l	0
clearplane:	dc.l	0
showplane:	dc.l	0




;col:
dc.w	$0732,$0621,$0511,$0310
dc.w	$0c74,$0b63,$0953,$0843
dc.w	$0fb7,$0fa6,$0e95,$0feb
dc.w	$0321,$0d85,$0fd9,$0fc8





>extern	"data/mont.blt",landpic
landpic:
	dcb.b	40*5,0
landcalc:
	dcb.b	163840,0
landcalcend:





copperlist:
dc.l	$240ffffe
dc.l	$01800102
dc.l	$01820123
dc.l	$01840310
dc.l	$01880021

dc.l	$300ffffe
dc.l	$01800102
dc.l	$01820124
dc.l	$01840420
dc.l	$01880032

dc.l	$3c0ffffe
dc.l	$01800102
dc.l	$01820124
dc.l	$01840531
dc.l	$01880032

dc.l	$480ffffe
dc.l	$01800102
dc.l	$01820224
dc.l	$01840642
dc.l	$01880143

dc.l	$540ffffe
dc.l	$01800102
dc.l	$01820224
dc.l	$01840753
dc.l	$01880143

dc.l	$600ffffe
dc.l	$01800102
dc.l	$01820224
dc.l	$01840864
dc.l	$01880254

dc.l	$6c0ffffe
dc.l	$01800102
dc.l	$01820224
dc.l	$01840975
dc.l	$01880254

dc.l	$780ffffe
dc.l	$01800102
dc.l	$01820234
dc.l	$01840a86
dc.l	$01880365

dc.l	$840ffffe
dc.l	$01800102
dc.l	$01820234
dc.l	$01840b97
dc.l	$01880476

dc.l	$900ffffe
dc.l	$01800102
dc.l	$01820234
dc.l	$01840ca8
dc.l	$01880476

dc.l	$9c0ffffe
dc.l	$01800102
dc.l	$01820234
dc.l	$01840db9
dc.l	$01880476

dc.l	$a80ffffe
dc.l	$01800102
dc.l	$01820235
dc.l	$01840eca
dc.l	$01880476

dc.l	$b40ffffe
dc.l	$01800102
dc.l	$01820235
dc.l	$01840fdb
dc.l	$01880476

dc.l	$c00ffffe
dc.l	$01800102
dc.l	$01820235
dc.l	$01840fdb
dc.l	$01880476

dc.l	$cc0ffffe
dc.l	$01800102
dc.l	$01820235
dc.l	$01840fdb
dc.l	$01880476



dc.l	-2

auto	e\





b:


codec_e:
;------------------------------------------------------------------------
ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:
;------------------------------------------------------------------------
ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
	ds.b	3*50*40
plane1:	ds.b	3*256*40
	ds.b	3*50*40
plane2:	ds.b	3*256*40
	ds.b	3*50*40
plane3:	ds.b	3*256*40
	ds.b	3*50*40
bssc_e:
;------------------------------------------------------------------------
ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:
;------------------------------------------------------------------------
ifne	UseSection
section	DataP,data_p
endif
datap_s:
Sinusx:
dc.W  264, 270, 275, 281, 287, 292, 298, 304, 309, 315, 321
dc.W  326, 332, 337, 343, 348, 353, 359, 364, 369, 374, 380
dc.W  385, 390, 395, 399, 404, 409, 414, 418, 423, 427, 432
dc.W  436, 440, 444, 448, 452, 456, 460, 464, 467, 471, 474
dc.W  477, 481, 484, 487, 490, 492, 495, 498, 500, 503, 505
dc.W  507, 509, 511, 513, 514, 516, 517, 519, 520, 521, 522
dc.W  523, 524, 525, 525, 526, 526, 527, 527, 527, 527, 527
dc.W  526, 526, 526, 525, 524, 524, 523, 522, 521, 520, 518
dc.W  517, 516, 514, 513, 511, 509, 508, 506, 504, 502, 500
dc.W  497, 495, 493, 491, 488, 486, 483, 481, 478, 475, 473
dc.W  470, 467, 464, 461, 459, 456, 453, 450, 447, 444, 441
dc.W  438, 435, 432, 428, 425, 422, 419, 416, 413, 410, 407
dc.W  404, 401, 398, 395, 392, 389, 386, 384, 381, 378, 375
dc.W  372, 370, 367, 365, 362, 360, 357, 355, 353, 350, 348
dc.W  346, 344, 342, 340, 338, 337, 335, 333, 332, 330, 329
dc.W  328, 326, 325, 324, 323, 322, 322, 321, 320, 320, 319
dc.W  319, 318, 318, 318, 318, 318, 318, 318, 319, 319, 320
dc.W  320, 321, 322, 322, 323, 324, 325, 326, 328, 329, 330
dc.W  332, 333, 335, 337, 338, 340, 342, 344, 346, 348, 350
dc.W  353, 355, 357, 360, 362, 365, 367, 370, 372, 375, 378
dc.W  381, 384, 386, 389, 392, 395, 398, 401, 404, 407, 410
dc.W  413, 416, 419, 422, 425, 428, 432, 435, 438, 441, 444
dc.W  447, 450, 453, 456, 459, 461, 464, 467, 470, 473, 475
dc.W  478, 481, 483, 486, 488, 491, 493, 495, 497, 500, 502
dc.W  504, 506, 508, 509, 511, 513, 514, 516, 517, 518, 520
dc.W  521, 522, 523, 524, 524, 525, 526, 526, 526, 527, 527
dc.W  527, 527, 527, 526, 526, 525, 525, 524, 523, 522, 521
dc.W  520, 519, 517, 516, 514, 513, 511, 509, 507, 505, 503
dc.W  500, 498, 495, 492, 490, 487, 484, 481, 477, 474, 471
dc.W  467, 464, 460, 456, 452, 448, 444, 440, 436, 432, 427
dc.W  423, 418, 414, 409, 404, 399, 395, 390, 385, 380, 374
dc.W  369, 364, 359, 353, 348, 343, 337, 332, 326, 321, 315
dc.W  309, 304, 298, 292, 287, 281, 275, 270, 264, 258, 253
dc.W  247, 241, 236, 230, 224, 219, 213, 207, 202, 196, 191
dc.W  185, 180, 175, 169, 164, 159, 154, 148, 143, 138, 133
dc.W  129, 124, 119, 114, 110, 105, 101, 96, 92, 88, 84, 80
dc.W  76, 72, 68, 64, 61, 57, 54, 51, 47, 44, 41, 38, 36
dc.W  33, 30, 28, 25, 23, 21, 19, 17, 15, 14, 12, 11, 9, 8
dc.W  7, 6, 5, 4, 3, 3, 2, 2, 1, 1, 1, 1, 1, 2, 2, 2, 3, 4
dc.W  4, 5, 6, 7, 8, 10, 11, 12, 14, 15, 17, 19, 20, 22, 24
dc.W  26, 28, 31, 33, 35, 37, 40, 42, 45, 47, 50, 53, 55
dc.W  58, 61, 64, 67, 69, 72, 75, 78, 81, 84, 87, 90, 93
dc.W  96, 100, 103, 106, 109, 112, 115, 118, 121, 124, 127
dc.W  130, 133, 136, 139, 142, 144, 147, 150, 153, 156, 158
dc.W  161, 163, 166, 168, 171, 173, 175, 178, 180, 182, 184
dc.W  186, 188, 190, 191, 193, 195, 196, 198, 199, 200, 202
dc.W  203, 204, 205, 206, 206, 207, 208, 208, 209, 209, 210
dc.W  210, 210, 210, 210, 210, 210, 209, 209, 208, 208, 207
dc.W  206, 206, 205, 204, 203, 202, 200, 199, 198, 196, 195
dc.W  193, 191, 190, 188, 186, 184, 182, 180, 178, 175, 173
dc.W  171, 168, 166, 163, 161, 158, 156, 153, 150, 147, 144
dc.W  142, 139, 136, 133, 130, 127, 124, 121, 118, 115, 112
dc.W  109, 106, 103, 100, 96, 93, 90, 87, 84, 81, 78, 75
dc.W  72, 69, 67, 64, 61, 58, 55, 53, 50, 47, 45, 42, 40
dc.W  37, 35, 33, 31, 28, 26, 24, 22, 20, 19, 17, 15, 14
dc.W  12, 11, 10, 8, 7, 6, 5, 4, 4, 3, 2, 2, 2, 1, 1, 1, 1
dc.W  1, 2, 2, 3, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 17
dc.W  19, 21, 23, 25, 28, 30, 33, 36, 38, 41, 44, 47, 51
dc.W  54, 57, 61, 64, 68, 72, 76, 80, 84, 88, 92, 96, 101
dc.W  105, 110, 114, 119, 124, 129, 133, 138, 143, 148, 154
dc.W  159, 164, 169, 175, 180, 185, 191, 196, 202, 207, 213
dc.W  219, 224, 230, 236, 241, 247, 253, 260

Sinusy:
dc.W  101, 102, 104, 105, 107, 108, 110, 111, 112, 114, 115
dc.W  117, 118, 120, 121, 122, 124, 125, 127, 128, 129, 131
dc.W  132, 133, 135, 136, 138, 139, 140, 142, 143, 144, 145
dc.W  147, 148, 149, 150, 152, 153, 154, 155, 157, 158, 159
dc.W  160, 161, 162, 163, 165, 166, 167, 168, 169, 170, 171
dc.W  172, 173, 174, 175, 176, 177, 178, 179, 180, 180, 181
dc.W  182, 183, 184, 184, 185, 186, 187, 187, 188, 189, 190
dc.W  190, 191, 191, 192, 193, 193, 194, 194, 195, 195, 196
dc.W  196, 197, 197, 197, 198, 198, 198, 199, 199, 199, 200
dc.W  200, 200, 200, 200, 201, 201, 201, 201, 201, 201, 201
dc.W  201, 201, 201, 201, 201, 201, 201, 201, 201, 201, 201
dc.W  200, 200, 200, 200, 200, 199, 199, 199, 199, 198, 198
dc.W  198, 197, 197, 196, 196, 196, 195, 195, 194, 194, 193
dc.W  193, 192, 192, 191, 191, 190, 189, 189, 188, 188, 187
dc.W  186, 186, 185, 184, 184, 183, 182, 181, 181, 180, 179
dc.W  178, 178, 177, 176, 175, 174, 174, 173, 172, 171, 170
dc.W  169, 169, 168, 167, 166, 165, 164, 163, 162, 162, 161
dc.W  160, 159, 158, 157, 156, 155, 154, 153, 153, 152, 151
dc.W  150, 149, 148, 147, 146, 145, 144, 143, 142, 142, 141
dc.W  140, 139, 138, 137, 136, 135, 134, 133, 133, 132, 131
dc.W  130, 129, 128, 127, 127, 126, 125, 124, 123, 122, 122
dc.W  121, 120, 119, 118, 118, 117, 116, 115, 115, 114, 113
dc.W  113, 112, 111, 111, 110, 109, 109, 108, 107, 107, 106
dc.W  105, 105, 104, 104, 103, 103, 102, 102, 101, 101, 100
dc.W  100, 99, 99, 98, 98, 97, 97, 97, 96, 96, 95, 95, 95
dc.W  94, 94, 94, 94, 93, 93, 93, 93, 92, 92, 92, 92, 91
dc.W  91, 91, 91, 91, 91, 91, 91, 90, 90, 90, 90, 90, 90
dc.W  90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 91
dc.W  91, 91, 91, 91, 91, 91, 91, 92, 92, 92, 92, 92, 92
dc.W  93, 93, 93, 93, 93, 94, 94, 94, 94, 95, 95, 95, 95
dc.W  96, 96, 96, 97, 97, 97, 97, 98, 98, 98, 99, 99, 99
dc.W  99, 100, 100, 100, 101, 101, 101, 102, 102, 102, 103
dc.W  103, 103, 103, 104, 104, 104, 105, 105, 105, 105, 106
dc.W  106, 106, 107, 107, 107, 107, 108, 108, 108, 108, 109
dc.W  109, 109, 109, 109, 110, 110, 110, 110, 110, 110, 111
dc.W  111, 111, 111, 111, 111, 111, 111, 112, 112, 112, 112
dc.W  112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112
dc.W  112, 112, 112, 111, 111, 111, 111, 111, 111, 111, 111
dc.W  110, 110, 110, 110, 109, 109, 109, 109, 108, 108, 108
dc.W  108, 107, 107, 107, 106, 106, 105, 105, 105, 104, 104
dc.W  103, 103, 102, 102, 101, 101, 100, 100, 99, 99, 98
dc.W  98, 97, 97, 96, 95, 95, 94, 93, 93, 92, 91, 91, 90
dc.W  89, 89, 88, 87, 87, 86, 85, 84, 84, 83, 82, 81, 80
dc.W  80, 79, 78, 77, 76, 75, 75, 74, 73, 72, 71, 70, 69
dc.W  69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 60, 59, 58
dc.W  57, 56, 55, 54, 53, 52, 51, 50, 49, 49, 48, 47, 46
dc.W  45, 44, 43, 42, 41, 40, 40, 39, 38, 37, 36, 35, 34
dc.W  33, 33, 32, 31, 30, 29, 28, 28, 27, 26, 25, 24, 24
dc.W  23, 22, 21, 21, 20, 19, 18, 18, 17, 16, 16, 15, 14
dc.W  14, 13, 13, 12, 11, 11, 10, 10, 9, 9, 8, 8, 7, 7, 6
dc.W  6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 2, 1, 1
dc.W  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2
dc.W  2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8
dc.W  9, 9, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16, 17, 18
dc.W  18, 19, 20, 21, 22, 22, 23, 24, 25, 26, 27, 28, 29
dc.W  30, 31, 32, 33, 34, 35, 36, 37, 39, 40, 41, 42, 43
dc.W  44, 45, 47, 48, 49, 50, 52, 53, 54, 55, 57, 58, 59
dc.W  60, 62, 63, 64, 66, 67, 69, 70, 71, 73, 74, 75, 77
dc.W  78, 80, 81, 82, 84, 85, 87, 88, 90, 91, 92, 94, 95
dc.W  97, 98, 100

Sinusz:
dc.W  14, 15, 15, 16, 16, 17, 17, 18, 18, 18, 19, 19, 20
dc.W  20, 21, 21, 22, 22, 23, 23, 23, 24, 24, 24, 25, 25
dc.W  25, 26, 26, 26, 27, 27, 27, 27, 27, 28, 28, 28, 28
dc.W  28, 28, 28, 28, 28, 28, 29, 28, 28, 28, 28, 28, 28
blk.w	200,28
dc.W  28, 28, 28, 28, 27, 27, 27, 27, 27, 26, 26, 26, 25
dc.W  25, 25, 24, 24, 24, 23, 23, 23, 22, 22, 21, 21, 20
dc.W  20, 19, 19, 18, 18, 18, 17, 17, 16, 16, 15, 15, 14
dc.W  13, 13, 12, 12, 11, 11, 10, 10, 10, 9, 9, 8, 8, 7, 7
dc.W  6, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1
dc.W  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
blk.w	200,0
dc.W  0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4
dc.W  5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 11, 11
dc.W  12, 12, 13, 13

sinus:
dc.w  0, 32767, 572, 32763, 1144, 32748, 1715, 32723, 2286, 32688
dc.w  2856, 32643, 3425, 32588, 3993, 32524, 4560, 32449, 5126, 32365
dc.w  5690, 32270, 6252, 32166, 6813, 32052, 7371, 31928, 7927, 31795
dc.w  8481, 31651, 9032, 31499, 9580, 31336, 10126, 31164, 10668, 30983
dc.w  11207, 30792, 11743, 30592, 12275, 30382, 12803, 30163
dc.w  13328, 29935, 13848, 29698, 14365, 29452, 14876, 29197
dc.w  15384, 28932, 15886, 28660, 16384, 28378, 16877, 28088
dc.w  17364, 27789, 17847, 27482, 18324, 27166, 18795, 26842
dc.w  19261, 26510, 19720, 26170, 20174, 25822, 20622, 25466
dc.w  21063, 25102, 21498, 24730, 21926, 24351, 22348, 23965
dc.w  22763, 23571, 23170, 23170, 23571, 22763, 23965, 22348
dc.w  24351, 21926, 24730, 21498, 25102, 21063, 25466, 20622
dc.w  25822, 20174, 26170, 19720, 26510, 19261, 26842, 18795
dc.w  27166, 18324, 27482, 17847, 27789, 17364, 28088, 16877
dc.w  28378, 16384, 28660, 15886, 28932, 15384, 29196, 14876
dc.w  29452, 14365, 29698, 13848, 29935, 13328, 30163, 12803
dc.w  30382, 12275, 30592, 11743, 30792, 11207, 30983, 10668
dc.w  31164, 10126, 31336, 9580, 31499, 9032, 31651, 8481, 31795, 7927
dc.w  31928, 7371, 32052, 6813, 32166, 6252, 32270, 5690, 32365, 5126
dc.w  32449, 4560, 32524, 3993, 32588, 3425, 32643, 2856, 32688, 2286
dc.w  32723, 1715, 32748, 1144, 32763, 572, 32767, 0, 32763,-572
dc.w  32748,-1144, 32723,-1715, 32688,-2286, 32643,-2856, 32588,-3425
dc.w  32524,-3993, 32449,-4560, 32365,-5126, 32270,-5690, 32166,-6252
dc.w  32052,-6813, 31928,-7371, 31795,-7927, 31651,-8481, 31499,-9032
dc.w  31336,-9580, 31164,-10126, 30983,-10668, 30792,-11207, 30592,-11743
dc.w  30382,-12275, 30163,-12803, 29935,-13328, 29698,-13848
dc.w  29452,-14365, 29197,-14876, 28932,-15384, 28660,-15886
dc.w  28378,-16384, 28088,-16877, 27789,-17364, 27482,-17847
dc.w  27166,-18324, 26842,-18795, 26510,-19261, 26170,-19720
dc.w  25822,-20174, 25466,-20622, 25102,-21063, 24730,-21498
dc.w  24351,-21926, 23965,-22348, 23571,-22763, 23170,-23170
dc.w  22763,-23571, 22348,-23965, 21926,-24351, 21498,-24730
dc.w  21063,-25102, 20622,-25466, 20174,-25822, 19720,-26170
dc.w  19261,-26510, 18795,-26842, 18324,-27166, 17847,-27482
dc.w  17364,-27789, 16877,-28088, 16384,-28378, 15886,-28660
dc.w  15384,-28932, 14876,-29196, 14365,-29452, 13848,-29698
dc.w  13328,-29935, 12803,-30163, 12275,-30382, 11743,-30592
dc.w  11207,-30792, 10668,-30983, 10126,-31164, 9580,-31336, 9032,-31499
dc.w  8481,-31651, 7927,-31795, 7371,-31928, 6813,-32052, 6252,-32166
dc.w  5690,-32270, 5126,-32365, 4560,-32449, 3993,-32524, 3425,-32588
dc.w  2856,-32643, 2286,-32688, 1715,-32723, 1144,-32748, 572,-32763
dc.w  0,-32768,-572,-32763,-1144,-32748,-1715,-32723,-2286,-32688
dc.w -2856,-32643,-3425,-32588,-3993,-32524,-4560,-32449,-5126,-32365
dc.w -5690,-32270,-6252,-32166,-6813,-32052,-7371,-31928,-7927,-31795
dc.w -8481,-31651,-9032,-31499,-9580,-31336,-10126,-31164,-10668,-30983
dc.w -11207,-30792,-11743,-30592,-12275,-30382,-12803,-30163
dc.w -13328,-29935,-13848,-29698,-14365,-29452,-14876,-29196
dc.w -15384,-28932,-15886,-28660,-16384,-28378,-16877,-28088
dc.w -17364,-27789,-17847,-27482,-18324,-27166,-18795,-26842
dc.w -19261,-26510,-19720,-26170,-20174,-25822,-20622,-25466
dc.w -21063,-25102,-21498,-24730,-21926,-24351,-22348,-23965
dc.w -22763,-23571,-23170,-23170,-23571,-22763,-23965,-22348
dc.w -24351,-21926,-24730,-21498,-25102,-21063,-25466,-20622
dc.w -25822,-20174,-26170,-19720,-26510,-19261,-26842,-18795
dc.w -27166,-18324,-27482,-17847,-27789,-17364,-28088,-16877
dc.w -28378,-16384,-28660,-15886,-28932,-15384,-29196,-14876
dc.w -29452,-14365,-29698,-13848,-29935,-13328,-30163,-12803
dc.w -30382,-12275,-30592,-11743,-30792,-11207,-30983,-10668
dc.w -31164,-10126,-31336,-9580,-31499,-9032,-31651,-8481,-31795,-7927
dc.w -31928,-7371,-32052,-6813,-32166,-6252,-32270,-5690,-32365,-5126
dc.w -32449,-4560,-32524,-3993,-32588,-3425,-32643,-2856,-32688,-2286
dc.w -32723,-1715,-32748,-1144,-32763,-572,-32768, 0,-32763, 572
dc.w -32748, 1144,-32723, 1715,-32688, 2286,-32643, 2856,-32588, 3425
dc.w -32524, 3993,-32449, 4560,-32365, 5126,-32270, 5690,-32166, 6252
dc.w -32052, 6813,-31928, 7371,-31795, 7927,-31651, 8481,-31499, 9032
dc.w -31336, 9580,-31164, 10126,-30983, 10668,-30792, 11207,-30592, 11743
dc.w -30382, 12275,-30163, 12803,-29935, 13328,-29698, 13848
dc.w -29452, 14365,-29197, 14876,-28932, 15384,-28660, 15886
dc.w -28378, 16384,-28088, 16877,-27789, 17364,-27482, 17847
dc.w -27166, 18324,-26842, 18795,-26510, 19261,-26170, 19720
dc.w -25822, 20174,-25466, 20622,-25102, 21063,-24730, 21498
dc.w -24351, 21926,-23965, 22348,-23571, 22763,-23170, 23170
dc.w -22763, 23571,-22348, 23965,-21926, 24351,-21498, 24730
dc.w -21063, 25102,-20622, 25466,-20174, 25822,-19720, 26170
dc.w -19261, 26510,-18795, 26842,-18324, 27166,-17847, 27482
dc.w -17364, 27789,-16877, 28088,-16384, 28378,-15886, 28660
dc.w -15384, 28932,-14876, 29197,-14365, 29452,-13848, 29698
dc.w -13328, 29935,-12803, 30163,-12275, 30382,-11743, 30592
dc.w -11207, 30792,-10668, 30983,-10126, 31164,-9580, 31336,-9032, 31499
dc.w -8481, 31651,-7927, 31795,-7371, 31928,-6813, 32052,-6252, 32166
dc.w -5690, 32270,-5126, 32365,-4560, 32449,-3993, 32524,-3425, 32588
dc.w -2856, 32643,-2286, 32688,-1715, 32723,-1144, 32748,-572, 32763


dotcode:	dcb.b	(xsize/4*(code2-code1)+(code3-code2))*ysize,0
rts

datap_e:
;------------------------------------------------------------------------
ifne	UseSection
section	BSSP,bss_p
endif
bssp_s:
turnanim:
dotscon:
	ds.b	xsize*ysize*4*angles
;incbin	"dotscon"
dotsconend:

bssp_e:
;------------------------------------------------------------------------

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


	
