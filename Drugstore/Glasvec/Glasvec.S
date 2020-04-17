;------------------------------------------------------------------------
;|                                                                      |
;|                               Glass Vector                           |
;|                              --------------                          |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                         |
;------------------------------------------------------------------------
usesection=1
startlist=38

hide=0
fulllines=0
fillit=1

dmaconr=$002




ifne	usesection
section code,code_c
endif
codec_s:


showtime=0
Program_ID=14
Main_Initcall2=0
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk

	bsr.w	MemClrCPU

	jsr	bars_reset

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	linequant1,linequant
	move.l	#lines1,lines

	move.w	#4*0,turnaddx
	move.w	#4*0,turnaddy
	move.w	#4*4,turnaddz	;;
	jsr	turner

	jsr	switchplanes
	jsr	fader2_xxx

	bsr.w	logocopy

	bsr.w	switchplanes2

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
	movem.l	d0-a6,-(a7)
	move.l	main_vbivector(pc),a0
	move.l	#VBI_Robots,(a0)

	move.w	#%0000001000000000,bplcon0(a5)

	lea	$180(a5),a0
	lea	Col_Dialog(pc),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+


skip:
	move.w	#4*90,turnz
	bsr.w	SetCopScr_Robots

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
	movem.l	(a7)+,d0-a6
	rts
;----------

Commands:;;
		dc.l	2,nothing

		dc.l	200,start_closebar
		dc.l	20,Start_fader
		dc.l	60,start_openbar
		dc.l	120,Cont_fader

		dc.l	1,	SetCopScr_glasvec
		dc.l	50,	setint_glasvec
rept 19
		dc.l	14,addglaspos
endr
		dc.l	300,addglaspos
;1019
rept 17
		dc.l	14,subglaspos
endr

		dc.l	1,	vecout

rept 3
		dc.l	30,subglaspos
endr

;1348
		dc.l	30,nothing


		dc.l	500,	vecin2

		dc.l	100,	vecout


;		dc.l	1,SetCopScr_Robots
		dc.l	1,Setint_bar
		dc.l	40,start_closebar
		dc.l	200,Start_faderback
;2219

		dc.l	60000,nothing


nothing:	rts

vecout:
	move.w	#-1,focusadd
	subq.w	#1,focus2
	rts

vecin2:
	move.w	#1,focusadd
	addq.w	#1,focus2
	move.w	#12*21,glaspos
	move.l	#Robots_Vec,Robotsvec
	move.w	#4*4,turnaddz	;;
	rts


addglaspos:
	add.w	#12,glaspos
	rts

subglaspos:
	sub.w	#12,glaspos
	rts

setint_bar:
	move.l	main_vbivector(pc),a0
	move.l	#VBI_Robots,(a0)

	bsr.b	SetCopScr_Robots

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1(pc),turnquant
	move.w	linequant1(pc),linequant
	move.l	#lines1,lines

	move.w	#4*0,turnaddx
	move.w	#4*0,turnaddy
	move.w	#4*4,turnaddz	;;
;	jsr	turner
rts

CopScr_Robots:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,$0000
	dc.w	bplcon2,$0000
	dc.w	bpl1mod,$0000
	dc.w	bpl2mod,$0000
	dc.w	bplcon0,%0100001000000000
	dc.l	-2

SetCopScr_Robots:
	lea	CopScr_robots(pc),a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)
rts

start_fader:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_xxx,Fader2_pos	;...fade forward
rts

start_faderback:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#7,fader2_sleep	;fading speed, 1=fastest

	move.w	#-1,fader2_direct		;this combination to...
	move.l	#fader2_tableend_xxx,Fader2_pos	;...fade backward
rts

Cont_fader:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#6+1,fader2_sleep	;fading speed, 1=fastest

rts

start_closebar:
	move.w	#length,bars_closecount
	move.w	#4*60,turnz
rts

start_openbar:
	move.w	#length,bars_opencount
rts

Planesize_James=40*256
VBI_Robots:
	movem.l	d0-a6,-(a7)
	lea	$dff000,a5
	lea	james(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	Planesize_James(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize_James(a0),a0
	move.l	a0,bpl3pth(a5)


	move.l	showplane1(pc),d0
	move.l	d0,bpl4pth(a5)

	bsr	fader2_real
move.w	#800,d0
sleep:
;dbf	d0,sleep
	bsr	bars_open
	bsr	bars_close

	bsr	drawline
	bsr	fill
	bsr	turner
	bsr	planecls_cpu
waitblit
	bsr	planecls_blit



	bsr	switchplanes
	bsr	commander

waitblit

	movem.l	(a7)+,d0-a6
rts


barcol=$fff
Col_Dialog:
	dcb.w	8,$202
	dcb.w	8,barcol


Col_Robots1:
;dc.w $444,$DDE,$CCC,$BAB,$999,$877,$766,$555
dc.w $433,$EDC,$CBA,$B98,$A77,$866,$655,$544
dcb.w	8,barcol


Col_Robots2:
;dc.w $444,$DDE,$CCC,$BAB,$999,$877,$766,$555
;dc.w $444,$DDE,$CCC,$BAB,$999,$877,$766,$555
dc.w $433,$EDC,$CBA,$B98,$A77,$866,$655,$544
dc.w $433,$EDC,$CBA,$B98,$A77,$866,$655,$544
dcb.w	8,barcol





MemClrCPU:
	lea	bssc_e,a0
	move.w	#(bssc_e-bssc_s)/(13*4)-1,d7

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6

	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	move.l	d0,a5
	move.l	d0,a6

MemClrCPU_loop:
	movem.l	d0-d6/a1-a6,-(a0)
	dbf	d7,MemClrCPU_loop
	movem.l	d0-d6/a1-a5,-(a0)
	lea	$dff000,a5
	rts



planes:
showplane1:	dc.l	planes1
clearplane:	dc.l	planes2
pointplane:	dc.l	planes3


switchplanes:
	lea	planes+2*4(pc),a0
	move.l	(a0),d0
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	d0,(a0)
	rts


planecls_blit:
rts
	lea	$dff000,a5
	move.l	clearplane,a0
waitblit
	move.l	a0,BLTDPTH(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#145*64+20,BLTSIZE(A5)
rts

planecls_cpu:
	move.l	clearplane,a0

;	lea	145*40(a0),a0

moveq	#0,d0
moveq	#0,d1
moveq	#0,d2
moveq	#0,d3
moveq	#0,d4
moveq	#0,d5
moveq	#0,d6
moveq	#0,d7
move.l	d0,a1
move.l	d0,a2

rept	256
movem.l	d0-d7/a1-a2,(a0)
lea	40(a0),a0
endr

	rts

fill:
	lea	$dff000,a5
	move.l	pointplane,d0
	add.l	#255*40+38,d0
waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#0,bltamod(A5)
	MOVE.w	#0,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#(256)*64+20,BLTSIZE(A5)
	rts









linequant:	dc.w	0
lines:		dc.l	0

;------------------------------------------------------------------------
;------------------------------------------------last optimizing:93-09-05
turnkoord:	dc.l	0	;|
turnkoords:	dc.l	0	;|
turnquant:	dc.w	0	;|
turnaddx:	dc.w	0	;|
turnaddy:	dc.w	0	;|
turnaddz:	dc.w	0	;|
turnx:		dc.w	0
turny:		dc.w	0
turnz:		dc.w	0


turner:
	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz

turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sinus,a6	;sinus/cosinus
	move.w	focus(pc),d1
	move.w	turnquant,d0
	lsl.w	#3,d0		;*8 als offset/koord
turnrout1:

	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.l	2(a3,d0.w),d3	;d3:hi=x , lo=y

	move.w	d3,d4		;d4=y
	swap	d3		;d3.w=x
	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=y
	muls.w	d5,d3		;d3=x*cos z
	muls.w	d5,d7		;d7=y*cos z
	swap	d5
	muls.w	d5,d4		;d4=y*sin z
	muls.w	d5,d6		;d6=x*sin z
	sub.l	d4,d3		;d3=x*cos z - y*sin z  ->new  x-koord
	add.l	d3,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	swap	d6



muls.w	d1,d3
muls.w	d1,d6
asr.l	#8,d3
asr.l	#8,d6

skippers:
	move.w	d3,2(a4,d0.w)
	move.w	d6,4(a4,d0.w)
;	move.w	6(a3,d0.w),6(a4,d0.w)

	subq.w	#8,d0
	bpl.b	turnrout1
	rts
;*****
focus:	dc.w	256



drawline:
lea	$dff000,a5
move.w	#%1000010000000000,dmacon(a5)

move.l	turnkoord(pc),a0
move.l	lines(pc),a1
move.w	linequant(pc),d7

drawloop:
moveq	#80,d0
add.w	d0,d0
move.l	d0,d2

moveq	#127,d1
moveq	#127,d3

move.w	0(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d0
add.w	4(a0,a2.w),d1
ifne	hide
tst.w	6(a0,a2.w)
bpl	samepoint
endif
move.w	2(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d2
add.w	4(a0,a2.w),d3

ifne	hide
tst.w	6(a0,a2.w)
bpl	samepoint
endif
cmp.w	d0,d2
bne.b	notsamepoint
cmp.w	d1,d3
bne.b	notsamepoint
bra.w	samepoint


notsamepoint:
movem.l	d4-d7/a0/a2/a6,-(a7)
winx1=0
winy1=0
winx2=319
winy2=255
;checktop
	cmp.w	#winy1,d1
	bge.b	notop1flow
	cmp.w	#winy1,d3
	blt.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy1,d7
	sub.w	d3,d7		;d7=winy1-y2	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DXS
	bra.b	checkbot
notop1flow:
	cmp.w	#winy1,d3
	bge.b	checkbot
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy1,d7
	sub.w	d1,d7		;d7=winy1-y1	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkbot:
	cmp.w	#winy2,d1
	blt.b	nobot1flow
	cmp.w	#winy2,d3
	bge.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy2,d7
	sub.w	d3,d7		;d7=winy2-y2	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DXS
	bra.b	checklef
nobot1flow:
	cmp.w	#winy2,d3
	blt.b	checklef
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy2,d7
	sub.w	d1,d7		;d7=winy2-y1	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS


checklef:
	cmp.w	#winx1,d0
	bge.b	nolef1flow
	cmp.w	#winx1,d2
	blt.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx1,d6
	sub.w	d2,d6		;d6=winx1-x2	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DYS
	bra.b	checkrig
nolef1flow:
	cmp.w	#winx1,d2
	bge.b	checkrig
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx1,d6
	sub.w	d0,d6		;d6=winx1-x1	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkrig:
	cmp.w	#winx2,d0
	blt.b	norig1flow
	cmp.w	#winx2,d2
	bge.w	line_borderline1	;both points out of range-->draw border
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx2,d6
	sub.w	d2,d6		;d6=winx1-x2	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
movem.l	d0-d6,-(a7)
move.w	#winx2,d0
move.w	d0,d2
add.w	d7,d3
bsr.b	line
movem.l	(a7)+,d0-d6
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DYS

	bra.b	checkfin
norig1flow:
	cmp.w	#winx2,d2
	blt.b	checkfin
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx2,d6
	sub.w	d0,d6		;d6=winx1-x1	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
movem.l	d0-d6,-(a7)
move.w	#winx2,d0
move.w	d0,d2
add.w	d7,d1
bsr.b	line
movem.l	(a7)+,d0-d6
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkfin:

bsr.b	line
line_skip:
movem.l	(a7)+,d4-d7/a0/a2/a6

samepoint:
subq.w	#4,d7
bpl.w	drawloop

bwait1:	
btst	#14,dmaconr(a5)
bne.b	bwait1
move.w	#%0000010000000000,dmacon(a5)

rts

line_borderline1:
move.w	#winx2,d0
move.w	d0,d2
bsr.b	line
bra.b	line_skip


;x1=d0
;y1=d1
;x2=d2
;y2=d3
draw:
line:
	move.l	pointplane(pc),a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
ifeq fulllines
	beq.w	drawl2		;points equal, dont draw-->exit
endif
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
	SUBQ.W	#1,D3		;y2=y2-1
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
;	lsl.w	#6,d0
add.w	d0,d0
lea	multab(pc,d0.w),a0
move.w	(a0),d0

	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
;	LSL.W	#1,D3		;d3=lodiff*2
	add.w	d3,d3
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.B	.NOSIGN		;branch if lodiff*2 >hidiff
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

bwait5:
btst	#14,dmaconr(a5)
bne.b	bwait5

	MOVE.w	d0,bltbmod(a5)
	moveq	#-1,d0
	MOVE.l	d0,bltafwm(a5)
	moveq	#40,d0
	MOVE.w	d0,bltcmod(a5)
	MOVE.w	d0,bltdmod(a5)
	MOVE.l	#$00008000,bltbdat(a5);b+a dat

	MOVE.l	a2,bltcpth(a5)
	MOVE.w	d3,bltaptl(a5)
	MOVE.l	a2,bltdpth(a5)

	MOVE.l	d4,bltcon0(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)

drawl2:
	RTS

OCTANTS:
;--------ssssccccmmmmmmmm
ifne fulllines
DC.w	%0000101111111010,$F013-2	; REMOVE THE ";" FOR NORMAL
DC.w	%0000101111111010,$F003-2	; DRAWING (WITH MORE THAN ONE
DC.w	%0000101111111010,$F017-2	; BIT/LINE.
DC.w	%0000101111111010,$F00B-2
;                1 1
endif

DC.w	%0000101101011010,$F013;-2	; REMOVE THE ";" FOR NORMAL
DC.w	%0000101101011010,$F003;-2	; DRAWING (WITH MORE THAN ONE
DC.w	%0000101101011010,$F017;-2	; BIT/LINE.
DC.w	%0000101101011010,$F00B;-2
;                1 1

mulval:	set	0

multab:
rept	256
	dc.w	40*mulval
mulval:	set	mulval+1
endr


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


length=208
bars_reset:
	lea	linekoords1(pc),a0
	lea	16*8(a0),a1

	move.w	linepoints1(pc),d7
	sub.w	#16+8,d7
bars_resetl1:
	move.w	#-length,2+8(a0)
	move.w	#length,2(a1)

	lea	16(a0),a0
	lea	16(a1),a1
	dbf	d7,bars_resetl1
rts


bars_closecount:	dc.w	0;length*2
bars_close:
	tst.w	bars_closecount
	beq.b	bars_closeexit
	subq.w	#1,bars_closecount

	lea	linekoords1(pc),a0
	lea	16*8(a0),a1

	move.w	linepoints1(pc),d7
	sub.w	#16+8,d7

bars_closel1:
	addq.w	#2,2+8(a0)
	subq.w	#2,2(a1)

	lea	16(a0),a0
	lea	16(a1),a1
	dbf	d7,bars_closel1
bars_closeexit:
rts

bars_opencount:	dc.w	0;length*2-2
bars_open:
	tst.w	bars_opencount
	beq.b	bars_openexit
	subq.w	#1,bars_opencount

	lea	linekoords1(pc),a0
	lea	16*8(a0),a1

	move.w	linepoints1(pc),d7
	sub.w	#16+8,d7

bars_openl1:
	subq.w	#2,2+8(a0)
	addq.w	#2,2(a1)

	lea	16(a0),a0
	lea	16(a1),a1
	dbf	d7,bars_openl1
bars_openexit:
rts




linekoord1:	dcb.b	256,0

linepoints1: dc.w  15+16
linequant1: dc.w  (15+16)*4
linekoords1:
dc.w 0,-208,-208,0
dc.w 0, 208,-208,0
dc.w 0,-208,-156,0
dc.w 0, 208,-156,0
dc.w 0,-208,-104,0
dc.w 0, 208,-104,0
dc.w 0,-208,-52,0
dc.w 0, 208,-52,0
dc.w 0,-208, 0,0
dc.w 0, 208, 0,0
dc.w 0,-208, 52,0
dc.w 0, 208, 52,0
dc.w 0,-208, 104,0
dc.w 0, 208, 104,0
dc.w 0,-208, 156,0
dc.w 0, 208, 156,0

dc.w 0,-208,-156,0
dc.w 0, 208,-156,0
dc.w 0,-208,-104,0
dc.w 0, 208,-104,0
dc.w 0,-208,-52,0
dc.w 0, 208,-52,0
dc.w 0,-208, 0,0
dc.w 0, 208, 0,0
dc.w 0,-208, 52,0
dc.w 0, 208, 52,0
dc.w 0,-208, 104,0
dc.w 0, 208, 104,0
dc.w 0,-208, 156,0
dc.w 0, 208, 156,0
dc.w 0,-208, 208,0
dc.w 0, 208, 208,0

lines1:
dc.w  0, 2
dc.w  0, 1
dc.w  1, 3
dc.w  2, 3
dc.w  4, 6
dc.w  4, 5
dc.w  5, 7
dc.w  6, 7
dc.w  8, 10
dc.w  8, 9
dc.w  9, 11
dc.w  10, 11
dc.w  12, 14
dc.w  12, 13
dc.w  13, 15
dc.w  14, 15

dc.w  0+16, 2+16
dc.w  0+16, 1+16
dc.w  1+16, 3+16
dc.w  2+16, 3+16
dc.w  4+16, 6+16
dc.w  4+16, 5+16
dc.w  5+16, 7+16
dc.w  6+16, 7+16
dc.w  8+16, 10+16
dc.w  8+16, 9+16
dc.w  9+16, 11+16
dc.w  10+16, 11+16
dc.w  12+16, 14+16
dc.w  12+16, 13+16
dc.w  13+16, 15+16
dc.w  14+16, 15+16



include	"/include/Fader2/Calc1.2.i"
;include	"/include/Fader2/Makegrey1.1.i"

Fader2_Colquant_xxx=16			;number of colours in this calculation
Fader2_Tablequant_xxx=2;	maximal number of colours in program!!
Fader2_Table_xxx:	dcb.w	Fader2_Tablequant_xxx*Fader2_Colquant_xxx*16
Fader2_Tableend_xxx:

Fader2_xxx:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_xxx,d7	;number of colours


	lea	Col_Dialog(pc),a0	;colour source
	lea	fader2_table_xxx(pc),a2	;point in fader-table
	lea	Col_robots1(pc),a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	Col_robots2(pc),a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
rts


Fader2Start_xxx:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#fader2_Tablequant_xxx*16,fader2_step
	move.w	#4,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_xxx,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_xxx,Fader2_pos	;...fade backward
rts


Fader2_real:
	tst.w	Fader2_step			;fading finished?
	beq.b	Fader2_skip			;yes-->exit

	subq.w	#1,Fader2_slpcount		;fader sleeping?
	bne.b	Fader2_skip			;yes-->exit
	move.w	Fader2_sleep,Fader2_slpcount	;new sleepcounter
	subq.w	#1,Fader2_step
	move.w	Fader2_quant(pc),d0
	move.w	d0,d1
	add.w	d1,d1
	move.l	Fader2_pos(pc),a0
	move.l	a0,a1

	tst.w	Fader2_direct
	bpl.b	Fader2_forward
	neg.w	d1
	lea	(a0,d1.w),a0
Fader2_forward:
	lea	(a1,d1.w),a1
	move.l	a1,Fader2_pos

	subq.w	#1,d0
;-------
	lea	$dff180,a1
Fader2_copy:
	move.w	(a0)+,(a1)+
	dbf	d0,Fader2_copy
;-------
Fader2_skip:
	rts



;---------------------------------------------
setente:
	move.w	#1,f_endprogram
	rts


CopScr_glasvec:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,$0000
	dc.w	bplcon2,$0000
	dc.w	bpl1mod,$0000
	dc.w	bpl2mod,$0000
	dc.w	bplcon0,%0011001000000000
	dc.l	-2

SetCopScr_glasvec:
	lea	CopScr_glasvec(pc),a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)
rts

setint_glasvec:
	lea	turnkoord(pc),a0
	move.l	#linekoord2,(a0)+
	move.l	#linekoords2,(a0)+
	move.w	linepoints2,(a0)+
	move.w	#2*4,(a0)+
	move.w	#1*4,(a0)+
	move.w	#4*4,(a0)+
	jsr	turner2
	bsr.w	perspective
	jsr	hidesort

	bsr.w	switchplanes2

	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#glasvec_vbi,(a0)
	rts

;------------------------------------------------------------------------
;---------
main_initxxx:;;
	rts
;----------
;----------

;Main_program:;;
	movem.l	d0-a6,-(a7)
	lea	main_intuser(pc),a1
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)
	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------

glasvec_vbi:
	move.l	showplane2,a0
	move.l	a0,bpl1pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl5pth(a5)


	jsr	clrstars
	jsr	turner2
	bsr.w	perspective
	jsr	hidesort
skipturn:
	move.w	#%1000010000000000,dmacon(a5)


waitblit
	jsr	drawline2	

;	move.w	#%0000010000000000,dmacon(a5)


	jsr	switchplanes2
skipall:

	move.w	focus2(pc),d0
	cmp.w	#85,d0
	beq.b	nozoom
	cmp.w	#4,d0
	beq.b	nozoom
	add.w	focusadd,d0
	move.w	d0,focus2
nozoom:
	jsr	commander
	waitblit
	rts



switchmark:	dc.l	0

switchplanes2:
	not.w	switchmark
	beq.b	switchplanesl2
	move.l	#logopic0,showplane2
	move.l	#logopic1,pointplane2
	rts
switchplanesl2:
	move.l	#logopic1,showplane2
	move.l	#logopic0,pointplane2
	rts
;--------






;------------------------------------------------------------------------

;------------------------------------------------last optimizing:93-09-05

turner2:	;last optimizing:93-09-05
	move.w	#1440,d0
	move.w	d0,d1
	subq.w	#4,d1

	move.w	turnx(pc),a1
	add.w	turnaddx(pc),a1
	cmp.w	d1,a1
	ble.b nolaufx2
	sub.w	d0,a1
nolaufx2:
	move.w	a1,turnx

	move.w	turny(pc),a2
	add.w	turnaddy(pc),a2
	cmp.w	d1,a2
	ble.b nolaufy2
	sub.w	d0,a2
nolaufy2:
	move.w	a2,turny

	move.w	turnz(pc),a0
	add.w	turnaddz(pc),a0
	cmp.w	d1,a0
	ble.b nolaufz2
	sub.w	d0,a0
nolaufz2:
	move.w	a0,turnz


turner21:
	move.l	turnkoord(pc),a4	;koordinaten
	move.l	turnkoords(pc),a3
	lea	sinus(pc),a6	;sinus/cosinus
	move.w	turnquant(pc),d0
	lsl.w	#3,d0		;*8 als offset/koord
turnrout12:

	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.l	2(a3,d0.w),d3	;d3:hi=x , lo=y

	move.w	d3,d4		;d4=y
	swap	d3		;d3.w=x
	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=y
	muls.w	d5,d3		;d3=x*cos z
	muls.w	d5,d7		;d7=y*cos z
	swap	d5
	muls.w	d5,d4		;d4=y*sin z
	muls.w	d5,d6		;d6=x*sin z
	sub.l	d4,d3		;d3=x*cos z - y*sin z  ->new  x-koord
	add.l	d3,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	swap	d6

move.w	d3,d1
;	move.w	d3,2(a4,d0.w)
;	move.w	d6,4(a4,d0.w)


	move.l	0(a6,a1.w),d5	;d5:hiword=sin z ,loword=cos z 
;	move.w	4(a4,d0.w),d3	;d3=y
move.w	d6,d3
	move.w	6(a3,d0.w),d4	;d4=z
	move.w	d3,d6		;d6=y
	move.w	d4,d7		;d7=z
	muls.w	d5,d3		;d3=y*cos x
	muls.w	d5,d7		;d7=z*cos x
	swap	d5
	muls.w	d5,d4		;d4=z*sin x
	muls.w	d5,d6		;d6=y*sin x
	sub.l	d4,d3		;d3=y*cos x - z*sin x ->new y-koord
	add.l	d3,d3
	swap	d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	add.l	d6,d6
	swap	d6
	move.w	d3,4(a4,d0.w)
;move.w	d6,6(a4,d0.w)



	move.l	0(a6,a2.w),d5	;d5:hiword=sin z ,loword=cos z 
;	move.w	2(a4,d0.w),d3	;d3=x
;	move.w	6(a4,d0.w),d4	;d4=z
move.w	d1,d3
move.w	d6,d4
	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=z
	muls.w	d5,d3		;d3=x*cos y
	muls.w	d5,d7		;d7=z*cos y
	swap	d5
	muls.w	d5,d4		;d4=z*sin y
	muls.w	d5,d6		;d6=x*sin y
	add.l	d4,d3		;d3=x*cos y + z*sin y
	add.l	d3,d3
	swap	d3
	sub.l	d7,d6		;d6=z*cos y - x*sin y
	add.l	d6,d6
	swap	d6
	move.w	d3,2(a4,d0.w)
	move.w	d6,6(a4,d0.w)

	subq.w	#8,d0
	bpl.b	turnrout12
	rts
;*****

perspective:
	move.l	turnkoord(pc),a3
	move.l	turnkoord(pc),a4
	move.w	turnquant(pc),d7

perspectiveloop:

move.w	2(a3),d0
move.w	4(a3),d1
move.w	6(a3),d2
neg.w	d2
asr.w	#1,d2
add.w	#100,d2

;---
move.w	focus2(pc),d3
muls.w	d3,d0
muls.w	d3,d1
divs	d2,d0
divs	d2,d1

;---

move.w	d0,2(a4)
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop
rts


focus2:		dc.w	5	;85
focusadd:	dc.w	1


veccol:
dc.w	$0180,$0000,$0182,$0555,$0184,$0655,$0186,$0666
dc.w	$0188,$0766,$018a,$0877,$018c,$0877,$018e,$0977
dc.w	$0190,$0a88,$0192,$0a88,$0194,$0b88,$0196,$0c88
dc.w	$0198,$0c88,$019a,$0d88,$019c,$0e88,$019e,$0e88
dc.w	$01a0,$0f88,$01a2,$0e77,$01a4,$0e66,$01a6,$0e66
dc.w	$01a8,$0d55,$01aa,$0d44,$01ac,$0c44,$01ae,$0c33
dc.w	$01b0,$0b33,$01b2,$0b22,$01b4,$0a22,$01b6,$0a11
dc.w	$01b8,$0911,$01ba,$0911,$01bc,$0800,$01be,$0800



showplane2:	dc.l	0
pointplane2:	dc.l	0


logocopy:
	lea	Robots_Pic,a0
	lea	logopic0,a1
	lea	logopic1,a2
	move.w	#30720/4-1,d0
logocopyl1:
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,logocopyl1
	rts




james:
Robots_pic:	incbin	"data/Robots_Pic3.raw"	;original to clear
Robots_Vec:	incbin	"data/Robots_Vec7.40.raw"	;star-modified

Robotsvec:	dc.l	Robots_Pic


logocol:
col0:
;dc.w $444,$DDE,$CCC,$BAB,$999,$877,$766,$555
dc.w $433,$EDC,$CBA,$B98,$A77,$866,$655,$544



size=128

sinxpos:	dc.w	0
sinypos:	dc.w	0
lastoffset:	dc.w	0

clrstars:
	lea	sinxpos(pc),a3	
	move.w	(a3),d1
	addq.w	#4,d1
	cmp.w	#720,d1
	bne.b	nosinxrestart
	moveq	#0,d1
nosinxrestart:
	move.w	d1,(a3)+		;x-pos of vector

	move.w	(a3),d2
	addq.w	#2,d2
	cmp.w	#720,d2
	bne.b	nosinyrestart
	moveq	#0,d2
nosinyrestart:
	move.w	d2,(a3)			;y-pos of vector

	move.w	lastoffset(pc),d2

	lea	Robots_Pic+64*40+12-(4*40),a0	;midscreen source
	move.l	pointplane2,a1
	lea	64*40+12-(4*40)(a1),a1		;midscreen dest SCREEN
	add.w	d2,a0				;add y-offset
	add.w	d2,a1				;add y-offset


	moveq	#3,d7
clrstarl1:

waitblit
	move.l	#-1,bltafwm(a5)
	move.l	a0,bltapth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#40-18,bltamod(a5)
	move.w	#40-18,bltdmod(a5)
	move.l	#%00001001111100000000000000000000,bltcon0(a5);0+1
	move.w	#(size+4)*64+9,bltsize(a5)

	lea	256*40(a0),a0
	lea	256*40(a1),a1
	dbf	d7,clrstarl1
	rts





drawstars:
	move.w	sinxpos(pc),d1
	move.w	sinypos(pc),d2
	add.w	#720,d2
	lea	sinusx(pc),a3

	lea	calcplane,a0
	add.w	planeoffsets,a0

	move.l	pointplane2,a1
	add.w	planeoffsets,a1

	move.l	RobotsVec,a2
	add.w	planeoffsets,a2
	add.w	d5,a2

	move.w	(a3,d1.w),d1
	move.w	(a3,d2.w),d2
	ext.l	d1

;	lsl.w	#6,d2
mulu	#40,d2

	ror.l	#4,d1			;x/16=wordoffset	16
	add.w	d1,d1			;bytes to words		 4
	add.w	d1,d2
	move.w	d2,lastoffset

	swap	d1			;			 4
	and.w	#%1111000000000000,d1
	move.w	d1,d6			;...copy...		 4
	or.w	#%0000111111001010,d6	;...set miniterms...	 8
;	or.w	#%0000111111111111,d6	;...set miniterms...	 8
	swap	d6			;...word on highword...	 4
	move.w	d1,d6			;...and word!!!		 4
	move.w	#0,d6			;...and word!!!		 4

	add.w	d2,a1
	add.w	d2,a2

	moveq	#2,d7
drawstarl1:

	waitblit
	move.l	a0,bltapth(a5)	;stars
	move.l	a2,bltbpth(a5)	;logo2
	move.l	a1,bltcpth(a5)	;plane
	move.l	a1,bltdpth(a5)	;plane
;	move.w	#64-16,bltamod(a5)
;	move.w	#64-16,bltbmod(a5)
;	move.w	#64-16,bltcmod(a5)
;	move.w	#64-16,bltdmod(a5)
	move.w	planemodulos,bltamod(a5)
	move.w	planemodulos,bltbmod(a5)
	move.w	planemodulos,bltcmod(a5)
	move.w	planemodulos,bltdmod(a5)
;	move.w	#%0000111111001010,bltcon0(a5)
;	move.w	#%0000000000000000,bltcon1(a5)
	move.l	d6,bltcon0(a5)

	move.w	planesize,bltsize(a5)

	lea	256*40(a1),a1
	lea	256*40(a2),a2
	dbf	d7,drawstarl1
rts



sinxpos1:	dc.w	0
sinxpos2:	dc.w	0

Sinusx:;Created with Liberty Design's Sinusmaker
c:
dc.W  0, 2, 3, 5, 7, 8, 10, 12, 13, 15, 17, 18, 20, 21, 23
dc.W  24, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 39, 40
dc.W  42, 43, 44, 45, 46, 47, 48, 48, 49, 50, 51, 51, 52
dc.W  53, 53, 54, 54, 55, 55, 55, 56, 56, 56, 56, 56, 56
dc.W  56, 56, 56, 56, 56, 56, 55, 55, 55, 54, 54, 54, 53
dc.W  52, 52, 51, 51, 50, 49, 48, 48, 47, 46, 45, 44, 43
dc.W  42, 41, 41, 40, 38, 37, 36, 35, 34, 33, 32, 31, 30
dc.W  29, 27, 26, 25, 24, 23, 22, 21, 19, 18, 17, 16, 15
dc.W  14, 13, 12, 11, 10, 8, 7, 6, 5, 4, 4, 3, 2, 1, 0,-1
dc.W -2,-2,-3,-4,-5,-5,-6,-6,-7,-8,-8,-9,-9,-9,-10,-10,-10
dc.W -11,-11,-11,-11,-12,-12,-12,-12,-12,-12,-12,-12,-12
dc.W -12,-11,-11,-11,-11,-11,-10,-10,-10,-9,-9,-9,-8,-8,-7
dc.W -7,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1, 0, 1, 1, 2, 2
dc.W  3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 9, 10, 10
dc.W  10, 11, 11, 11, 11, 11, 12, 12, 12, 12, 12, 12, 12
dc.W  12, 12, 12, 11, 11, 11, 11, 10, 10, 10, 9, 9, 9, 8
dc.W  8, 7, 6, 6, 5, 5, 4, 3, 2, 2, 1, 0,-1,-2,-3,-4,-4,-5
dc.W -6,-7,-8,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-21
dc.W -22,-23,-24,-25,-26,-27,-29,-30,-31,-32,-33,-34,-35
dc.W -36,-37,-38,-40,-41,-41,-42,-43,-44,-45,-46,-47,-48
dc.W -48,-49,-50,-51,-51,-52,-52,-53,-54,-54,-54,-55,-55
dc.W -55,-56,-56,-56,-56,-56,-56,-56,-56,-56,-56,-56,-56
dc.W -55,-55,-55,-54,-54,-53,-53,-52,-51,-51,-50,-49,-48
dc.W -48,-47,-46,-45,-44,-43,-42,-40,-39,-38,-37,-36,-34
dc.W -33,-32,-30,-29,-27,-26,-24,-23,-21,-20,-18,-17,-15
dc.W -13,-12,-10,-8,-7,-5,-3,-2
d:

Sinusy:;Created with Liberty Design's Sinusmaker
dc.W  0, 1, 3, 4, 6, 7, 8, 10, 11, 13, 14, 15, 17, 18, 19
dc.W  20, 22, 23, 24, 25, 26, 28, 29, 30, 31, 32, 33, 34
dc.W  35, 36, 36, 37, 38, 39, 40, 40, 41, 41, 42, 43, 43
dc.W  43, 44, 44, 45, 45, 45, 45, 45, 46, 46, 46, 46, 46
dc.W  46, 45, 45, 45, 45, 44, 44, 44, 43, 43, 43, 42, 41
dc.W  41, 40, 40, 39, 38, 38, 37, 36, 35, 34, 34, 33, 32
dc.W  31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19
dc.W  18, 17, 16, 15, 14, 13, 11, 10, 9, 8, 7, 6, 5, 4, 3
dc.W  2, 1, 0, 0,-1,-2,-3,-4,-5,-6,-6,-7,-8,-8,-9,-10,-10
dc.W -11,-12,-12,-13,-13,-13,-14,-14,-15,-15,-15,-15,-16
dc.W -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-15
dc.W -15,-15,-15,-14,-14,-14,-13,-13,-13,-12,-12,-11,-11
dc.W -10,-10,-9,-8,-8,-7,-7,-6,-5,-5,-4,-3,-3,-2,-1,-1, 0
dc.W  1, 1, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 8, 9, 10, 10, 11
dc.W  11, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15, 15, 15
dc.W  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
dc.W  15, 15, 15, 15, 14, 14, 13, 13, 13, 12, 12, 11, 10
dc.W  10, 9, 8, 8, 7, 6, 6, 5, 4, 3, 2, 1, 0, 0,-1,-2,-3
dc.W -4,-5,-6,-7,-8,-9,-10,-11,-13,-14,-15,-16,-17,-18,-19
dc.W -20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31,-32
dc.W -33,-34,-34,-35,-36,-37,-38,-38,-39,-40,-40,-41,-41
dc.W -42,-43,-43,-43,-44,-44,-44,-45,-45,-45,-45,-46,-46
dc.W -46,-46,-46,-46,-45,-45,-45,-45,-45,-44,-44,-43,-43
dc.W -43,-42,-41,-41,-40,-40,-39,-38,-37,-36,-36,-35,-34
dc.W -33,-32,-31,-30,-29,-28,-26,-25,-24,-23,-22,-20,-19
dc.W -18,-17,-15,-14,-13,-11,-10,-8,-7,-6,-4,-3,-1


drawline2:
	move.l	turnkoord,a1	;turned koordinates
	lea	areaoffsets,a3	;areas to draw
	move.w	(a3)+,d7	;areacount
	lea	arealines+2,a4	;linecodes for each area
drawloop21:		;mainloop for each area
	move.w	(a3)+,d6	;get offset of area 1
	move.w	(a4,d6.w),d5	;number of lines in this area
	move.w	2(a4,d6.w),-(a7);areacolour of stack
	move.w	#$7fff,d0
	move.w	d0,lox
	move.w	d0,loy
	moveq	#0,d0
	move.l	d0,hix;(+hiy)
lea	$dff000,a5
waitblit

move.l	#-1,bltafwm(a5)
move.w	#40,bltcmod(a5)
move.w	#40,bltdmod(a5)
move.w	#0,bltbdat(a5)
move.w	#$8000,bltadat(a5)

drawloop22:
	moveq	#80,d0
add.b	d0,d0
move.l	d0,d2
moveq	#127,d1

move.l	4(a4,d6.w),d4	;pointcode1+2
move.l	2(a1,d4.w),d3
add.w	d3,d1
swap	d3
add.w	d3,d0
addq.w	#2,d6	;cant remove this
swap	d4
moveq	#127,d3
move.l	2(a1,d4.w),d4
add.w	d4,d3
swap	d4
add.w	d4,d2


jsr	draw2

dbf	d5,drawloop22

addq.w	#1,hiy	;highest x +1 coz difference 0-->1 line to blit
add.w	#31,hix
and.w	#%1111111111110000,hix
and.w	#%1111111111110000,lox

move.w	lox,d0		;lowest x	      	PLANEOFFSET CALCULATION
lsr.w	#4,d0		;/16=words
add.w	d0,d0		;*2=bytes from left border

move.w	loy,d1		;lowest y-koord
;lsl.w	#6,d1		;*64 (bytes/line)
mulu	#40,d1
move.w	d1,d4		;copy for later use
add.w	d0,d1		;x-offset + y-offset...
move.w	d1,planeoffsets	;...=planeoffset for blitterwindow sourcescreen

moveq	#40,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix,d1		;highest x...
sub.w	lox,d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source


move.w	hiy,d2	;highest y-value...			BLTSIZE CALC
sub.w	loy,d2	;...-lowest y-value
move.w	d2,d0
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize	;planesize for source and destination


mulu	#40,d0
add.w	d1,d0
add.w	planeoffsets,d0
addq.w	#4,d0
move.w	d0,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize,planesizef
move.w	planemodulos,planemodulof

addq.w	#4,planesizef
subq.w	#8,planemodulof
addq.w	#4,planeoffsetf

move.w	(a7)+,d0;areacolour from stack
	bsr.w	planefillcopycls
dbf	d7,drawloop21


rts




DRAW2:
	lea	calcplane,a0	;planeadress
	lea	octants2(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	draw2l1		;point 2 is greater--> okay
	beq.w	draw2l2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y


draw2l1:	
;----------searching lowest x/y and highest x/y of polygon
;y-koord alredy sorted:y1 is always lower than y2
	cmp.w	lox,d0
	bhs.b	nonewlox1
	move.w	d0,lox
nonewlox1:

	cmp.w	lox,d2
	bhs.b	nonewlox2
	move.w	d2,lox
nonewlox2:

	cmp.w	loy,d1
	bhs.b	nonewloy
	move.w	d1,loy
nonewloy:

	cmp.w	hix,d0
	bls.b	nonewhix1
	move.w	d0,hix
nonewhix1:

	cmp.w	hix,d2
	bls.b	nonewhix2
	move.w	d2,hix
nonewhix2:

	cmp.w	hiy,d3
	bls.b	nonewhiy
	move.w	d3,hiy
nonewhiy:

;----------
	SUBQ.W	#1,D3		;y2=y2-1
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

;	lsl.w	#6,d0
	MULU.W	#40,D0		;d0=y1*screen offset
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
	LSL.W	#1,D3		;d3=lodiff*2
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.S	.NOSIGN		;branch if lodiff*2 >hidiff
	OR.B	#$40,D4		;set bit 6	
;d4 waits
.NOSIGN:
	LSL.W		#1,D0		;d0=lodiff*4
	MOVE.W		D0,D1		;d1=lodiff*4
;d0 waits
	LSL.W		#2,D2		;d2=hidiff*4
	SUB.W		D2,D1		;d1=(lodiff*4) - (hidiff*4) 
;d1 waits
	ADDQ.W		#4,D2		;d2=hidiff*4+4
	LSL.W		#4,D2		;d2=(hidiff*4+4)*16
	ADDQ.W		#2,D2		;d2=(hidiff*4+4)*16+2
;d2 waits


lea	$dff000,a6
waitblit
	MOVE.w	d3,bltaptl(a6)
	MOVE.l	a2,bltcpth(a6)
	MOVE.l	a2,bltdpth(a6)

	MOVE.w	d0,bltbmod(a6)
	MOVE.l	d4,bltcon0(a6)
	MOVE.w	d1,bltamod(a6)
	MOVE.w	d2,bltsize(a6)

draw2l2:
	RTS


OCTANTS2:	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
	DC.L	$0B5AF017;-2		; BIT/LINE.
	DC.L	$0B5AF00B;-2


;cube

linepoints2: dc.w  7; 8 Linepoints
linekoord2:	blk.b	64,0
linekoords2:
side=36

dc.w 0,-side,-side, side
dc.w 0,-side, side, side
dc.w 0, side, side, side
dc.w 0, side,-side, side
dc.w 0,-side,-side,-side
dc.w 0,-side, side,-side
dc.w 0, side, side,-side
dc.w 0, side,-side,-side


arealines:
dc.w	5	;2 areas exist
dc.w	3,1,(0+0)*8,(1+0)*8,(2+0)*8,(3+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;1
dc.w	3,1,(4+0)*8,(7+0)*8,(6+0)*8,(5+0)*8,(4+0)*8,0,0,0,0,0,0,0,0,0;2
dc.w	3,2,(0+0)*8,(4+0)*8,(5+0)*8,(1+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;3
dc.w	3,2,(3+0)*8,(2+0)*8,(6+0)*8,(7+0)*8,(3+0)*8,0,0,0,0,0,0,0,0,0;4
dc.w	3,3,(1+0)*8,(5+0)*8,(6+0)*8,(2+0)*8,(1+0)*8,0,0,0,0,0,0,0,0,0;5
dc.w	3,3,(0+0)*8,(3+0)*8,(7+0)*8,(4+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;6

areaoffsets:
dc.w	5	;2 areas to draw
dc.w	0*32
dc.w	1*32
dc.w	2*32
dc.w	3*32
dc.w	4*32
dc.w	5*32



zpositions:
blk.w	10,0

glaspos:	dc.w	0
glasmove:
	dc.w	00*40,00*40,00*40,00*40,00*40,00*40
	dc.w	00*40,01*40,01*40,01*40,01*40,01*40
	dc.w	00*40,02*40,02*40,02*40,02*40,02*40
	dc.w	00*40,03*40,03*40,03*40,03*40,03*40
	dc.w	00*40,04*40,04*40,04*40,04*40,04*40
	dc.w	00*40,04*40,05*40,05*40,05*40,05*40
	dc.w	00*40,04*40,06*40,06*40,06*40,06*40
	dc.w	00*40,04*40,07*40,07*40,07*40,07*40
	dc.w	00*40,04*40,08*40,08*40,08*40,08*40
	dc.w	00*40,04*40,08*40,09*40,09*40,09*40
	dc.w	00*40,04*40,08*40,10*40,10*40,10*40
	dc.w	00*40,04*40,08*40,11*40,11*40,11*40
	dc.w	00*40,04*40,08*40,12*40,12*40,12*40
	dc.w	00*40,04*40,08*40,12*40,13*40,13*40
	dc.w	00*40,04*40,08*40,12*40,14*40,14*40
	dc.w	00*40,04*40,08*40,12*40,15*40,15*40
	dc.w	00*40,04*40,08*40,12*40,16*40,16*40
	dc.w	00*40,04*40,08*40,12*40,16*40,17*40
	dc.w	00*40,04*40,08*40,12*40,16*40,18*40
	dc.w	00*40,04*40,08*40,12*40,16*40,19*40
	dc.w	00*40,04*40,08*40,12*40,16*40,20*40

	dc.w	0*4*40+0*2-4
	dc.w	1*4*40+1*2-4
	dc.w	2*4*40+2*2-4
	dc.w	3*4*40+3*2-4
	dc.w	4*4*40+4*2-4
	dc.w	5*4*40+5*2-4


planefillcopycls:
;planefill:
	moveq	#0,d1
	move.w	planeoffsetf,d1
	add.l	#calcplane,d1

lea	$dff000,a6
waitblit

	MOVE.l	#%00001001111100000000000000001010,bltcon0(a6);0+1 con
	MOVE.l	#-1,bltafwm(a6)

	MOVE.l	d1,bltapth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.w	planemodulof,bltamod(a6)
	MOVE.w	planemodulof,bltdmod(a6)
	MOVE.w	planesizef,bltsize(a6)




movem.l	d5-a5,-(a7)
lea	glasmove(pc),a3
add.w	d0,d0
add.w	glaspos(pc),d0
moveq	#0,d5
move.w	(a3,d0.w),d5
bsr.w	drawstars
movem.l	(a7)+,d5-a5

;planecls:


	lea	calcplane,a0
	add.w	planeoffsets(pc),a0

waitblit
	MOVE.w	#%0000000100000000,bltcon0(a6)
	MOVE.w	#0,bltcon1(a6)

	MOVE.l	a0,bltdpth(a6)
	MOVE.w	planemodulos,bltdmod(a6)
	MOVE.w	planesize,bltsize(a6)

	rts

hideflag:	dc.w	0


hidesort:
;movem.l	d0-d7/a0-a6,-(a7)
lea	arealines(pc),a0	;basis of all areas
move.l	turnkoord,a1	;turned koordinates
lea	areaoffsets+2(pc),a2
lea	zpositions(pc),a3	;mittelwerte der z-koords
move.w	(a0)+,d7	;number of all areas
moveq	#-1,d6		;counter of non-hidden areas

hidel1:
move.w	d7,d5
lsl.w	#5,d5
;move.w	4(a0,d5.w),d0	;pointcode1
;move.w	6(a0,d5.w),d2	;pointcode2
;move.w	8(a0,d5.w),d4	;pointcode3

movem.w	4(a0,d5.w),d0/d2/d4

movem.w	2(a1,d0.w),d0-d1
movem.w	2(a1,d2.w),d2-d3
movem.w	2(a1,d4.w),d4-d5

sub.w	d0,d2	;delta x1 x2
sub.w	d1,d3	;delta y1 y2

sub.w	d0,d4	;delta x1 x3
sub.w	d1,d5	;delta y1 y3

muls	d2,d5	;delta x1 x2  *  delta y1 y3
muls	d3,d4	;delta y1 y2  *  delta x1 x3

sub.l	d5,d4
bpl.b	hidden
addq.w	#1,d6		;one more
move.w	d7,d5		;loopcounter
lsl.w	#5,d5		;*32
move.w	d5,(a2)+	;=offset

move.w	(a0,d5.w),d0	;number of points in area
move.w	d0,d4
addq.w	#1,d4
moveq	#0,d1		;addcounter for all z-values

bra.b	hidden
lea	4(a0,d5.w),a4

zaddloop:
move.w	(a4)+,d3
;lsl.w	#3,d3
move.w	6(a1,d3.w),d3
add.l	d3,d1
dbf	d0,zaddloop

;lsl.l	#2,d1
;muls	#4,d1
asl.w	#2,d1
ext.l	d1
divs	d4,d1
move.w	d1,(a3)+

hidden:
dbf	d7,hidel1
lea	areaoffsets(pc),a0
move.w	d6,(a0)

;movem.l	(a7)+,d0-d7/a0-a6

rts



bltfin:	dc.w	0

planeoffsets:	dc.w	0
planeoffsetf:	dc.w	0
planesizef:	dc.w	0
planesize:	dc.w	0
planemodulof:	dc.w	0
planemodulos:	dc.w	0
lox:	dc.w	0
loy:	dc.w	0
hix:	dc.w	0
hiy:	dc.w	0

f_endprogram:	dc.w	0


;----------------------------------------------------


codec_e:
;########################################################################
datac_s:
datac_e:
;########################################################################
ifne	usesection
section	memory,bss_c
endif
bssc_s:
planes1:	ds.b	1*256*64
planes2:	ds.b	1*256*64
planes3:	ds.b	1*256*64

wall=40*4*60
logopic0:				;show/work
	ds.b	30720
	ds.b	wall
logopic1:				;work/show
	ds.b	30720
	ds.b	wall

calcplane:	ds.b	256*40

bssc_e:
;########################################################################
codep_s:
codep_e:
;########################################################################
datap_s:
datap_e:
;########################################################################
bssp_s:
bssp_e:
;########################################################################

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

