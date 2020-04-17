UseSection=1
;------------------------------------------------------------------------
;-                                 SPIRAL                               -
;-                                --------                              -
;-                                                                      -
;-                                                                      -
;- coded in august 1992 by Moon/LUNATICS                                -
;------------------------------------------------------------------------


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

showtime=0
Program_ID=1
Main_Initcall2=1
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
;------------------------------------------------------------------------
Commands:;;
	dc.l	300,	linemaskon
	dc.l	50,	linemaskoff
	dc.l	1,	setonepoint
	dc.l	1,	setspiral2_1
	dc.l	1,	setspiral2_2
	dc.l	300,	linemaskon
	dc.l	50,	linemaskoff

	dc.l	1,	setonepoint
	dc.l	1,	setspiral3_1
	dc.l	1,	setspiral3_2
	dc.l	300,	linemaskon
	dc.l	50,	linemaskoff

	dc.l	1,	setonepoint
	dc.l	1,	setspiral4_1
	dc.l	1,	setspiral4_2
	dc.l	400,	linemaskon
	dc.l	50,	linemaskoff



	dc.l	60000,	nothing
;------------------------------------------------------------------------
f_firstprecalc:	dc.w	0
;------------------------------------------------------------------------

nothing:	rts

linemaskon:
	move.w	#-1,linemaskchange
	rts

linemaskoff:
	move.w	#0,linemaskchange
	rts

setonepoint:
	move.w	#0,circles_cnt
	move.w	#0,points_cnt
	rts

setspiral2_1:
	lea	spiralsinus6,a0
	lea	spiralsinus6,a1
	move.w	#4*points1*circles1,d1
	bsr.w	sinuscorrector1
	rts

setspiral2_2:
	lea	spiralsinus6,a0
	lea	spiralsinus6,a1
	move.w	#4*points1*circles1,d1
	bsr.w	sinuscorrector2

	move.l	#spirsinx0,spiralsinusxy_pt
	move.l	#spiralsinus6,spiralsinus_pt
	move.l	#spiraldata1,spiraldata_pt
	move.w	#11,circles_cnt
	move.w	#9,points_cnt
	move.w	#4*points1,pointsfaktor
	rts

setspiral3_1:
	lea	spiralsinus8,a0
	lea	spiralsinus8,a1
	move.w	#4*points2*circles2,d1
	bsr.w	sinuscorrector1
	rts

setspiral3_2:
	lea	spiralsinus8,a0
	lea	spiralsinus8,a1
	move.w	#4*points2*circles2,d1
	bsr.w	sinuscorrector2

	move.l	#spirsinx1,spiralsinusxy_pt
	move.l	#spiralsinus8,spiralsinus_pt
	move.l	#spiraldata2,spiraldata_pt
	move.w	#30,circles_cnt
	move.w	#4,points_cnt
	move.w	#4*points2,pointsfaktor
	rts

setspiral4_1:
	lea	spiralsinus9,a0
	lea	spiralsinus9,a1
	move.w	#4*points2*circles2,d1
	bsr.w	sinuscorrector1
	rts

setspiral4_2:
	lea	spiralsinus9,a0
	lea	spiralsinus9,a1
	move.w	#4*points2*circles2,d1
	bsr.w	sinuscorrector2

	move.l	#spirsinx2,spiralsinusxy_pt
	move.l	#spiralsinus9,spiralsinus_pt
	move.l	#spiraldata2,spiraldata_pt
	move.w	#25,circles_cnt
	move.w	#4,points_cnt
	move.w	#4*points2,pointsfaktor
	rts


;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk

	tst.w	f_firstprecalc
	bne.b	secondprecalc
	move.w	#1,f_firstprecalc
	bsr.w	precalc1
	bra.b	skipfromfirstprecalc

secondprecalc:
	lea	spiralsinus7,a0
	lea	spiralsinus7,a1
	move.w	#4*points1*circles1,d1
	bsr.w	sinuscorrector1
	lea	spiralsinus7,a0
	lea	spiralsinus7,a1
	move.w	#4*points1*circles1,d1
	bsr.w	sinuscorrector2





	lea	bssc_s,a0
	moveq	#0,d0
	move.w	#(bssc_e-bssc_s)/16-1,d7
bssc_clr:
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	dbf	d7,bssc_clr

	bsr.w	switchplanes

skipfromfirstprecalc:
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
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003000d0,ddfstrt(a5)	;strt+stop!
	move.w	#%0100001000000000,bplcon0(a5)
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.l	#$00160016,bpl1mod(a5)	;1mod+2mod!
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)

	move.l	shadowplane11,d0
	move.l	d0,bpl2pth(a5)
	move.l	shadowplane12,d0
	move.l	d0,bpl3pth(a5)
	move.l	shadowplane13,d0
	move.l	d0,bpl4pth(a5)

	lea	colour2,a0
	lea	$180(a5),a1
rept	8
	move.l	(a0)+,(a1)+
endr

	move.w	#%1000010000000000,$096(a5)

	bsr.b	precalc2

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

points1=10
circles1=15
angles1=360
radstep1=7

;points1=5
;circles1=32
;angles1=360
;radstep1=3


points2=5
circles2=32
angles2=360
radstep2=3

precalc1:
	move.l	#32768,d2
	move.w	#128,d4
	lea	spiraldata1,a0
	lea	sinus(pc),a1
	
	move.w	#359,d5
aloop1:
	moveq	#radstep1*2,d3	;startrad

	moveq	#circles1-1,d7
rsloop1:

	move.w	#359,d6
wloop1:
	move.w	d6,d0	;d0=angle
	sub.w	d5,d0
	bpl.b	.noangleflow1
	add.w	#360,d0
.noangleflow1:
	add.w	d0,d0	;*2...
	add.w	d0,d0	;...*2?*4=offset

	move.w	2(a1,d0.w),d1	;sin.w;cos.w	2+56
	move.w	(a1,d0.w),d0	;sin.w;cos.w

	muls	d3,d0
	muls	d3,d1
;	add.l	d0,d0
	add.l	d2,d0	;#32768
	swap	d0
;	add.l	d1,d1
	add.l	d2,d1	;#32768
	swap	d1

	add.w	#180,d0
	add.w	d4,d1	;#128

	move.w	d0,(a0)+
	move.w	d1,(a0)+

	sub.w	#360/points1,d6
	bpl.b	wloop1
	add.w	#radstep1*2,d3
	dbf	d7,rsloop1
	sub.w	#360/angles1,d5
	bpl.b	aloop1
rts





precalc2:
	lea	spiraldata2,a0
	lea	sinus,a1
	
	move.w	#359,d5
aloop2:
	moveq	#radstep2,d3	;startrad

	move.w	#circles2-1,d7
rsloop2:

	move.w	#359,d6
wloop2:
	move.w	d6,d0	;d0=angle
	sub.w	d5,d0
	bpl.b	.noangleflow2
	add.w	#360,d0
.noangleflow2:
	add.w	d0,d0	;*2...
	add.w	d0,d0	;...*2?*4=offset

	move.w	2+56(a1,d0.w),d1	;sin.w;cos.w	2+56
	move.w	(a1,d0.w),d0	;sin.w;cos.w

	muls	d3,d0
	muls	d3,d1
	add.l	d0,d0
	add.l	#32768,d0
	swap	d0
	add.l	d1,d1
	add.l	#32768,d1
	swap	d1

	add.w	#180,d0
	add.w	#128,d1

	move.w	d0,(a0)+
	move.w	d1,(a0)+

	sub.w	#360/points2,d6
	bpl.b	wloop2
	add.w	#radstep2,d3
	dbf	d7,rsloop2
	sub.w	#360/angles2,d5
	bpl.b	aloop2
rts



offset:	dc.w	0

circletab:	dcb.l	2*points1,0
cirsinxpos:	dc.w	0


;spiral definition
spiralsinusxy_pt:	dc.l	spirsinx0
spiralsinusx_size=1440*2
spiralsinus_pt:		dc.l	spiralsinus7
spiraldata_pt:		dc.l	spiraldata1
circles_cnt:		dc.w	13
points_cnt:		dc.w	9
pointsfaktor:	dc.w	4*points1


;;spiral definition
;spiralsinusxy_pt:	dc.l	spirsinx0
;spiralsinusx_size=1440*2
;spiralsinus_pt:		dc.l	spiralsinus6
;spiraldata_pt:		dc.l	spiraldata1
;circles_cnt:		dc.w	11
;points_cnt:		dc.w	9




;;spiral definition
;spiralsinusxy_pt:	dc.l	spirsinx1
;spiralsinusx_size=1440*2
;spiralsinus_pt:		dc.l	spiralsinus7
;spiraldata_pt:		dc.l	spiraldata2
;circles_cnt:		dc.w	30
;points_cnt:		dc.w	4



;;spiral definition
;spiralsinusxy_pt:	dc.l	spirsinx2
;spiralsinusx_size=1440*2
;spiralsinus_pt:		dc.l	spiralsinus6
;spiraldata_pt:		dc.l	spiraldata2
;circles_cnt:		dc.w	25
;points_cnt:		dc.w	4


point:
	move.w	cirsinxpos(pc),d0
	addq.w	#4,d0
	cmp.w	#1440,d0
	bne.b	.nocirsinxflow
	moveq	#0,d0
.nocirsinxflow:
	move.w	d0,cirsinxpos

	move.l	spiralsinusxy_pt(pc),a6
	add.w	d0,a6
	moveq	#90,d0
	add.w	d0,d0
	moveq	#127,d1

	add.w	(a6),d0
	add.w	spiralsinusx_size(a6),d1

	lea	circletab(pc),a4
	move.w	points_cnt(pc),d7
circletabinit:
	move.l	d0,(a4)+
	move.l	d1,(a4)+
	dbf	d7,circletabinit


	move.w	spiralsinuspoint(pc),d0
	addq.w	#4,d0
	cmp.w	#spiralsinussize,d0
	bne.b	okidoki
	moveq	#0,d0
okidoki:
	move.w	d0,spiralsinuspoint

	move.l	spiraldata_pt(pc),a0
	move.l	spiralsinus_pt(pc),a1
	lea	(a1,d0.w),a1

	move.w	circles_cnt(pc),d7
Draw_lc:
	move.l	(a1)+,d1

	lea	16(a1),a1
;	mulu	#4*points1*circles1,d1
	move.l	a0,a3
	add.l	d1,a3

	lea	circletab(pc),a4
	move.w	points_cnt(pc),d6
Draw_lp:
pointloop:
	moveq	#0,d0
	moveq	#0,d1

	move.w	(a3)+,d0		;this x without add
	move.w	(a3)+,d1		;this y without add

	add.w	(a6),d0			;this x with add
	add.w	spiralsinusx_size(a6),d1;this y with add
	move.l	(a4),d2			;last x
	move.l	d0,(a4)+		;this x
	move.l	(a4),d3			;last y
	move.l	d1,(a4)+		;this y

move.l	a0,-(a7)
;exg.l	d0,d2
;------------------------------------------------------------------------
;DRAW:	;d0-d3=koords , d4/a2=calc , a0=plane , a5=customchip
;lea	$dff000,a5
;moveq	#50,d0
;moveq	#50,d1
;moveq	#10,d2
;moveq	#10,d3

	move.l	pointplane(pc),a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
;	beq	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
;	SUBQ.W	#1,D3		;y2=y2-1
	SUB.W	D1,D3		;y2=y2-y1 , d3=ydiff (always positive)
	SUB.W	D0,D2		;x2=x2-x1 , d2=xdiff
	bpl.b	.OK2		;xdiff positive ?
	NEG.W	D2		;no-then make positive (xdiff=xdiff*-1)
	ADDQ.L	#8,A2		;octant adress
.OK2:	CMP.W	D2,D3		;xdiff,ydiff
	BLE.S	.OK3		;branch if xdiff>=ydiff
	ADDQ.L	#4,A2		;octopussy
	EXG	D2,D3		;xdiff<-->ydiff
.OK3:				;d2=HIdiff , d3=LOdiff
;d4 need first
	MOVE.L	(A2),D4		;get the pussy
	ROR.L	#3,D0		;d0.w=d0-w/8
	LEA	(A0,D0.W),A2	;a2=screenptr+x1-offset
;a0 free
	ROR.L	#1,D0		;d0/2 (d0.w = x1/16
	AND.L	#$F0000000,D0	;bit 12-15 =x1bit 0-3
	OR.L	D0,D4		;d4=octant or x1bits
	MOVE.W	D1,D0		;d0=y1

;	MULU.W	#64,D0		;d0=y1*screen offset
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
;	LSL.W	#1,D3		;d3=lodiff*2
	add.w	d3,d3
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.S	.NOSIGN		;branch if lodiff*2 >hidiff
	OR.B	#$40,D4		;set bit 6	
;d4 waits
.NOSIGN:
;	LSL.W		#1,D0		;d0=lodiff*4
	add.w	d0,d0
	MOVE.W		D0,D1		;d1=lodiff*4
;d0 waits
	LSL.W		#2,D2		;d2=hidiff*4
	SUB.W		D2,D1		;d1=(lodiff*4) - (hidiff*4) 
;d1 waits
	ADDQ.W		#4,D2		;d2=hidiff*4+4
	LSL.W		#4,D2		;d2=(hidiff*4+4)*16
	ADDQ.W		#2,D2		;d2=(hidiff*4+4)*16+2
;d2 waits


waitblit
	MOVE.w	d0,bltbmod(a5)
	moveq	#-1,d0
	MOVE.l	d0,bltafwm(a5)
	moveq	#64,d0
	MOVE.w	d0,bltcmod(a5)
	MOVE.w	d0,bltdmod(a5)
	MOVE.w	linemask(pc),bltbdat(a5)
	MOVE.w	#$8000,bltadat(a5)

	MOVE.l	a2,bltcpth(a5)
	MOVE.w	d3,bltaptl(a5)
	MOVE.l	a2,bltdpth(a5)

	MOVE.l	d4,bltcon0(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)

drawl2:
;	RTS
;------------------------------------------------------------------------
;jsr	draw
move.l	(a7)+,a0

dbf	d6,Draw_lp

;lea	4*points1(a0),a0
add.w	pointsfaktor(pc),a0

addq.w	#6,a6
dbf	d7,Draw_lc
rts



sinuscorrector1:
	move.w	#spiralsinussize/4/2-1,d7
sinuscorrector1_l1:
	move.l	(a0),d0

sinuscorrector1_l2:
	cmp.l	#360,d0
	blt.b	sinuscorrector1_l3
	sub.l	#360,d0
	bra.b	sinuscorrector1_l2
sinuscorrector1_l3:
	mulu	d1,d0
	move.l	d0,spiralsinussize*6(a0)
	move.l	d0,spiralsinussize*5(a0)
	move.l	d0,spiralsinussize*4(a0)
	move.l	d0,spiralsinussize*3(a0)
	move.l	d0,spiralsinussize*2(a0)
	move.l	d0,spiralsinussize*1(a0)
	move.l	d0,(a0)+
	dbf	d7,sinuscorrector1_l1
	rts

sinuscorrector2:
	move.w	#spiralsinussize/4/2-1,d7
	lea	spiralsinussize/4/2*4(a0),a0

sinuscorrector2_l1:
	move.l	(a0),d0

sinuscorrector2_l2:
	cmp.l	#360,d0
	blt.b	sinuscorrector2_l3
	sub.l	#360,d0
	bra.b	sinuscorrector2_l2
sinuscorrector2_l3:
	mulu	d1,d0
	move.l	d0,spiralsinussize*6(a0)
	move.l	d0,spiralsinussize*5(a0)
	move.l	d0,spiralsinussize*4(a0)
	move.l	d0,spiralsinussize*3(a0)
	move.l	d0,spiralsinussize*2(a0)
	move.l	d0,spiralsinussize*1(a0)
	move.l	d0,(a0)+
	dbf	d7,sinuscorrector2_l1
	rts


introut:
movem.l	d0-d7/a0-a6,-(a7)

	bsr.w	planecls
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)

	move.l	shadowplane11,d0
	move.l	d0,bpl2pth(a5)
	move.l	shadowplane12,d0
	move.l	d0,bpl3pth(a5)
	move.l	shadowplane13,d0
	move.l	d0,bpl4pth(a5)

;jsr	spiral
;jsr	spiralturn
;jsr	draw
	bsr.w	point

;	jsr	mt_music

	bsr.b	switchplanes

	not.w	vbiflag
	beq.b	skiplinemaskchange
	move.w	linemask(pc),d0
	moveq	#0,d1
	sub.w	linemaskchange(pc),d1
	addx.w	d0,d0
	move.w	d0,linemask
skiplinemaskchange:

	bsr.w	commander
	movem.l	(a7)+,d0-d7/a0-a6
rts

;intback:
	move.w	#%0000000001100000,$dff09c
	rte
vbiflag:	dc.w	0
;oldint:		dc.l	0


planeslist:
	dc.l	plane_1
	dc.l	plane_2
	dc.l	plane_3
	dc.l	plane_4
	dc.l	plane_5
	dc.l	plane_6
	dc.l	plane_1
	dc.l	plane_2
	dc.l	plane_3
	dc.l	plane_4
	dc.l	plane_5
	dc.l	plane_6

planes:
showplane:
plane1:	dc.l	0

pointplane:
workplane:
plane2:	dc.l	0

clearplane:
plane3:	dc.l	0

shadowplane13:
plane4:	dc.l	0
shadowplane12:
plane5:	dc.l	0
shadowplane11:
plane6:	dc.l	0

switchmark:	dc.w	0

switchplanes:
	lea	switchmark(pc),a0
	move.w	(a0),d0
	addq.w	#4,d0
	cmp.w	#4*6,d0
	bne.b	switchplanesl1
	moveq	#0,d0
switchplanesl1:
	move.w	d0,(a0)
	lea	planeslist,a0
	lea	(a0,d0.w),a0
	lea	planes,a1
	movem.l	(a0),d0-d5
	movem.l	d0-d5,(a1)
	rts
;--------

;switchmark:	dc.l	-1
;switchplanes:
;	tst.w	switchmark
;	beq.b	do2
;	bpl.b	do3
;do1:
;	move.w	#0,switchmark
;	move.l	#plane1,clearplane
;	move.l	#plane2,showplane
;	move.l	#plane3,pointplane
;	rts
;do2:
;	move.w	#1,switchmark
;	move.l	#plane1,pointplane
;	move.l	#plane2,clearplane
;	move.l	#plane3,showplane
;	rts
;do3:
;	move.w	#-1,switchmark
;	move.l	#plane1,showplane
;	move.l	#plane2,pointplane
;	move.l	#plane3,clearplane
;	rts
;--------





planecls:
	lea	$dff000,a5
	move.l	clearplane,d0
	addq.l	#0*64+6,d0
	move.l	d0,BLTDPTH(A5)
	move.w	#32,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#253*64+16,BLTSIZE(A5)
	rts




linemask:	dc.w	0
linemaskchange:	dc.w	-1





OCTANTS:;        01234567012345670123456701234567
	DC.L	%00001011110010001111000000010001
	DC.L	%00001011110010001111000000000001
	DC.L	%00001011110010001111000000010101
	DC.L	%00001011110010001111000000001001

	DC.L	%00001011111110101111000000010001
	DC.L	%00001011111110101111000000000001
	DC.L	%00001011111110101111000000010101
	DC.L	%00001011111110101111000000001001

sinus:
	incbin	"data/3dsine.bin"
	incbin	"data/3dsine.bin"
	incbin	"data/3dsine.bin"
	incbin	"data/3dsine.bin"

spiralsinuspoint:	dc.w	0


spiralsinussize=720*4

colour2:
dc.w $002,$378,$266,$7BC,$155,$7BC,$7BC,$DEF
dc.w $044,$7BC,$7BC,$DEF,$7BC,$DEF,$DEF,$FFF





spirsinx1:
	incbin	"data/spirsinx.bin"
	incbin	"data/spirsinx.bin"

spirsiny1:
	incbin	"data/spirsiny.bin"
	incbin	"data/spirsiny.bin"


spirsinx2:
	incbin	"data/spirsinx2.bin"
	incbin	"data/spirsinx2.bin"

spirsiny2:
	incbin	"data/spirsiny2.bin"
	incbin	"data/spirsiny2.bin"




spiralsinus9:
	incbin	"data/spiralsin6.bin"
spiralsinus8:
	incbin	"data/spiralsin7.bin"
spiralsinus6:
	incbin	"data/spiralsin6.bin"
spiralsinus7:
	incbin	"data/spiralsin7.bin"
aa:
	dcb.b	spiralsinussize
	dcb.b	spiralsinussize
	dcb.b	spiralsinussize
	dcb.b	spiralsinussize
	dcb.b	spiralsinussize
	dcb.b	spiralsinussize


spirsinx0:	dcb.w	720*2,0
spirsiny0:	dcb.w	720*2,0
bb:

codec_e:

ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:

ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
plane_1:	ds.b	1*256*64
plane_2:	ds.b	1*256*64
plane_3:	ds.b	1*256*64
plane_4:	ds.b	1*256*64
plane_5:	ds.b	1*256*64
plane_6:	ds.b	1*256*64
bssc_e:

ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:

ifne	UseSection
;section	DataP,data_p
endif
datap_s:
datap_e:

ifne	UseSection
section	BSSP,bss_p
endif
bssp_s:
spiraldata1:	dcb.b	4*points1*circles1*angles1
spiraldata2:	dcb.b	4*points2*circles2*angles2
printt	"Tablesize1:"
printv	4*points1*circles1*angles1
printt	"Tablesize2:"
printv	4*points2*circles2*angles2
printt
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


