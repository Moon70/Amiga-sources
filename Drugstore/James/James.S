;------------------------------------------------------------------------
;|                                                                      |
;|                               James Dean                             |
;|                              ------------                            |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                         |
;------------------------------------------------------------------------
;Valid talk messages:
;$xxxx 00 10  endcode 			routine --> mainpart
;$xxxx 01 10  end james 		routine <-- mainpart

Leftmouseexit=1
hide=0
fulllines=0
fillit=1

dmaconr=$002
planesize=40*256

section code,code_c
codec_s:


showtime=0
Program_ID=16
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

;	lea	bssc_s,a0
;	moveq	#0,d0
;	move.w	#(bssc_e-bssc_s)/4-1,d7
;bssc_clr:
;	move.l	d0,(a0)+
;	dbf	d7,bssc_clr

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
	move.l	#VBI_James,(a0)
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0101001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#0,bpl1mod(a5)
	move.w	#0,bpl2mod(a5)

	lea	main_vbivector,a0
	move.l	(a0),a0
	move.l	#vbi_James,(a0)

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
;	move.l	#0,maincommand

main_loop:
;ifne	Leftmouseexit
;	btst	#6,ciaapra
;	beq	Main_loopexit
;endif

;btst	#10,$dff016
;bne	.noright
;move.l	main_talk(pc),a0
;move.l	#1,(a0)
;bra	main_loopexit
;.noright:



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
		dc.l	4,nothing
		dc.l	90,Start_fader
		dc.l	90,Cont_fader
		dc.l	90,Cont_fader
		dc.l	90,Cont_fader	;60000
		dc.l	300,	disablevec
		dc.l	4,	enablevec
		dc.l	120,Cont_fader
		dc.l	90,Cont_fader
		dc.l	20,Cont_fader2
		dc.l	1,	send_endsignal
		dc.l	1,	disablevec
		dc.l	65000,nothing


nothing:	rts

send_endsignal:
	move.l	main_talk(pc),a0
	move.w	#Program_ID,d0
	lsl.w	#8,d0
	move.b	#1,d0
	move.w	d0,2(a0)
	rts

disablevec:
	move.w	#1,f_disablevec
	rts

enablevec:
	move.w	#0,f_disablevec
	rts

Start_fader:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#3,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_xxx,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_xxx,Fader2_pos	;...fade backward
rts

Cont_fader:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#5,fader2_sleep	;fading speed, 1=fastest
rts

Cont_fader2:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#1*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest
rts

f_disablevec:	dc.w	0

Planesize_James=40*256
VBI_James:
	movem.l	d0-a6,-(a7)
	lea	$dff000,a5
	lea	James,a0
	move.l	a0,bpl1pth(a5)
	lea	Planesize_James(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize_James(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	Planesize_James(a0),a0
	move.l	a0,bpl4pth(a5)


	move.l	showplane1,d0
	move.l	d0,bpl5pth(a5)

	move.l	main_talk(pc),a0
	move.w	#Program_ID,d0
	lsl.w	#8,d0
	cmp.w	2(a0),d0
	bne.b	noendsignal
	move.w	#0,2(a0)	;clear signal

noendsignal:


	tst.w	f_disablevec
	bne.b	vectordisabled
	jsr	fader2_real

	jsr	drawline
	jsr	fill
	jsr	turner
	jsr	planecls_cpu
;	jsr	planecls_blit


vectordisabled:

	move.l	main_talk(pc),a0
	tst.l	(a0)
	beq.b	.nomessage
	move.l	#0,(a0)
	move.w	#1,commander_sleep

.nomessage:
	jsr	switchplanes
	jsr	commander

waitblit

	movem.l	(a7)+,d0-a6
rts


Col_Dialog:	dcb.w	32,$000

Col_DialogWhite:
		dcb.w	16,$002
		dcb.w	16,$bbd

Col_White:
		dcb.w	16,$eee
		dcb.w	16,$fff

Col_James1:
dc.w $211,$FDA,$EC8,$EB6,$EA5,$E94,$E83,$E73
dc.w $D63,$C53,$B43,$933,$722,$522,$422,$322

dcb.w	16,$fff

Col_James2:
dc.w $211,$FDA,$EC8,$EB6,$EA5,$E94,$E83,$E73
dc.w $D63,$C53,$B43,$933,$722,$522,$422,$322
dc.w $211,$FDA,$EC8,$EB6,$EA5,$E94,$E83,$E73
dc.w $D63,$C53,$B43,$933,$722,$522,$422,$322

Col_BlackWhite:
	dcb.w	16,0
	dcb.w	16,$fff

Col_Black:
	dcb.w	32,0

Col_Blue:
	dcb.w	32,$004


James:
	incbin	"data/James.raw"

;------------------------------------------------------------------------


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

move.l	turnkoord,a0
move.l	lines,a1
move.w	linequant,d7

drawloop:
moveq	#0,d0
moveq	#0,d2

move.w	#160,d0
moveq	#127,d1
move.w	#160,d2
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
line:
	move.l	pointplane,a0	;planeadress
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

	MOVE.l	#-1,bltafwm(a5)
	MOVE.w	#40,bltcmod(a5)
	MOVE.w	#40,bltdmod(a5)
	MOVE.l	#$00008000,bltbdat(a5);b+a dat

	MOVE.l	a2,bltcpth(a5)
	MOVE.w	d3,bltaptl(a5)
	MOVE.l	a2,bltdpth(a5)

	MOVE.w	d0,bltbmod(a5)
	MOVE.l	d4,bltcon0(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)

drawl2:
	RTS

OCTANTS:

;	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
;	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
;	DC.L	$0B5AF017;-2		; BIT/LINE.
;	DC.L	$0B5AF00B;-2

;	DC.L	$0B5AF013-2		; REMOVE THE ";" FOR NORMAL
;	DC.L	$0B5AF003-2		; DRAWING (WITH MORE THAN ONE
;	DC.L	$0B5AF017-2		; BIT/LINE.
;	DC.L	$0B5AF00B-2
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




linekoord1:	blk.b	300,0

linepoints1: dc.w  35
linequant1: dc.w  35*4
linekoords1:
dc.w 0,-234,-234,0
dc.w 0,-182,-234,0
dc.w 0,-130,-234,0
dc.w 0,-78,-234,0
dc.w 0,-26,-234,0
dc.w 0, 26,-234,0
dc.w 0, 78,-234,0
dc.w 0, 130,-234,0
dc.w 0, 182,-234,0
dc.w 0, 234,-234,0
dc.w 0,-234,-182,0
dc.w 0, 234,-182,0
dc.w 0,-234,-130,0
dc.w 0, 234,-130,0
dc.w 0,-234,-78,0
dc.w 0, 234,-78,0
dc.w 0,-234,-26,0
dc.w 0, 234,-26,0
dc.w 0,-234, 26,0
dc.w 0, 234, 26,0
dc.w 0,-234, 78,0
dc.w 0, 234, 78,0
dc.w 0,-234, 130,0
dc.w 0, 234, 130,0
dc.w 0,-234, 182,0
dc.w 0, 234, 182,0
dc.w 0,-234, 234,0
dc.w 0,-182, 234,0
dc.w 0,-130, 234,0
dc.w 0,-78, 234,0
dc.w 0,-26, 234,0
dc.w 0, 26, 234,0
dc.w 0, 78, 234,0
dc.w 0, 130, 234,0
dc.w 0, 182, 234,0
dc.w 0, 234, 234,0
lines1:
dc.w  0, 10
dc.w  0, 1
dc.w  1, 27
dc.w  2, 28
dc.w  2, 3
dc.w  3, 29
dc.w  4, 30
dc.w  4, 5
dc.w  5, 31
dc.w  6, 32
dc.w  6, 7
dc.w  7, 33
dc.w  8, 34
dc.w  8, 9
dc.w  9, 11
dc.w  10, 11
dc.w  12, 14
dc.w  12, 13
dc.w  13, 15
dc.w  14, 15
dc.w  16, 18
dc.w  16, 17
dc.w  17, 19
dc.w  18, 19
dc.w  20, 22
dc.w  20, 21
dc.w  21, 23
dc.w  22, 23
dc.w  24, 26
dc.w  24, 25
dc.w  25, 35
dc.w  26, 27
dc.w  28, 29
dc.w  30, 31
dc.w  32, 33
dc.w  34, 35




include	"/include/Fader2/Calc1.2.i"
;include	"/include/Fader2/Makegrey1.1.i"

Fader2_Colquant_xxx=32			;number of colours in this calculation
Fader2_Tablequant_xxx=7;	maximal number of colours in program!!
Fader2_Table_xxx:	dcb.w	Fader2_Tablequant_xxx*Fader2_Colquant_xxx*16
Fader2_Tableend_xxx:

Fader2_xxx:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_xxx,d7	;number of colours


	lea	Col_Dialog,a0	;colour source
	lea	fader2_table_xxx,a2	;point in fader-table
	lea	Col_DialogWhite,a1	;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	Col_White,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	Col_James1,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	Col_James2,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc


	lea	Col_BlackWhite,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc

	lea	Col_Black,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc

	lea	Col_Blue,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc

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



codec_e:
datac_s:
datac_e:
;-------------------
section	memory,bss_c
bssc_s:
planes1:	ds.b	1*256*64
planes2:	ds.b	1*256*64
planes3:	ds.b	1*256*64
bssc_e:
;-------------------
codep_s:
codep_e:
datap_s:
datap_e:
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

