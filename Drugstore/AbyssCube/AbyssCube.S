;------------------------------------------------------------------------
;|                                                                      |
;|                             Abyss Cube                               |
;|                           --------------                             |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                         17-Jul-94 |
;------------------------------------------------------------------------

forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
intena=$09a
openlibrary=-30-522

bplcon0=$100
bplcon1=$102
bplcon2=$104
bpl1pth=$0e0
bpl1ptl=$0e2
bpl2pth=$0e4
bpl2ptl=$0e6
bpl3pth=$0e8
bpl3ptl=$0ea
bpl4pth=$0ec
bpl4ptl=$0ee
bpl5pth=$0f0
bpl5ptl=$0f2
bpl6pth=$0f4
bpl6ptl=$0f6
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094

;blitteroffsets
bltddat=$000
bltcon0=$040
bltcon1=$042
bltafwm=$044
bltalwm=$046
bltcpth=$048
bltcptl=$04a
bltbpth=$04c
bltbptl=$04e
bltapth=$050
bltaptl=$052
bltdpth=$054
bltdptl=$056
bltsize=$058
bltcmod=$060
bltbmod=$062
bltamod=$064
bltdmod=$066
bltcdat=$070
bltbdat=$072
bltadat=$074

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
;--------------------------------
	jmp	start		;
	jmp	main_init	;
	jmp	main_program	;
	jmp	main_back	;
	rts			;
;--------------------------------
;--------------------------------------------------------
start:							;
	move.l	4.w,a6					;
	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001100000,intena(a5)		;
	move.l	$6c.w,oldint				;
	move.l	#main_vbi,$6c.w				;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000100000,intena(a5)		;
	move.w	#%1000001111000000,dmacon(a5)		;
	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	bsr.w	main_init				;
	bsr.w	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq.b	back					;
	tst.w	f_endprogram				;
	beq.b	wait					;
back:							;
	move.l	oldint,$6c.w				;
	move.l	4.w,a6					;
	lea	gfxname(pc),a1				;
	moveq	#0,d0					;
	jsr	openlibrary(a6)				;
	move.l	d0,a0					;
	lea	$dff000,a5				;
	move.l	38(a0),cop1lch(a5)			;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1000001111100000,dmacon(a5)		;
	move.l	4.w,a6					;
	jsr	permit(a6)				;
	moveq	#0,d0					;
	rts						;
;--------------------------------------------------------
;--------------------------------------------------------
main_vbiuser:		dc.l	0			;
fakemain_vbiuser:	dc.l	0			;
main_copperlist:	dc.l	0			;
fakemain_copperlist:	dc.l	main_emptycopperlist	;
main_talk:		dc.l	0			;
fakemain_talk:		dc.l	0			;
oldint:			dc.l	0			;
main_emptycopperlist:	dc.l	-2			;
intflag:		dc.w	0			;
f_endprogram:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
;--------------------------------------------------------
;----------------------------------------------------------------
main_vbi:							;
	btst.b	#5,$dff01f					;
	beq.b	main_vbiback					;
	movem.l	d0-a6,-(a7)					;
;--------------------------					;
	lea	$dff000,a5					;

	lea	main_vbiuser(pc),a0 ;adress of UserVbiAdress	;
	move.l	(a0),a0		;adress of UserVbi		;
	tst.l	(a0)						;
	beq.b	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;

	lea	main_copperlist(pc),a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq.b	nomain_copperlist				;
	bpl.b	noempty_copperlist
	lea	main_emptycopperlist(pc),a1
	move.l	a1,cop1lch(a5)					;
	clr.l	(a0)						;
	bra.b	nomain_copperlist				;
noempty_copperlist:
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
;	move.w	#0,copjmp1(a5); should be removed!!		;
nomain_copperlist:						;

ifd	showtime						;
	move.w	#$0f00,$dff180					;
endif								;
	movem.l	(a7)+,d0-a6					;
ifd	showtime						;
	move.w	#$0000,$dff180					;
endif								;
main_vbiback:							;
	move.w	#%0000000001100000,$dff09c			;
	rte							;
;----------------------------------------------------------------

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
commander:; v4.1 last optimizing: 93-10-30
	lea	comsleep(pc),a0		;  8
	subq.w	#1,(a0)+		; 12
	beq.b	commanderl1		; 10 (true), 8 (false)
	rts				; 16
commanderl1:
	move.w	(a0),d0			;  8
	addq.w	#8,(a0)			; 12
	lea	commands+2(pc,d0.w),a1	; 12
	move.w	(a1)+,-(a0)		; 12
	move.l	(a1),a0			; 12
	jmp	(a0)			;  8
comsleep:	dc.w	1	;|
compoint:	dc.w	0	;|
commands:;;
		dc.l	10,	nothing
		dc.l	9,	movecube

		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus
		dc.l	8,morphfocus

		dc.l	1,	set_skipturner
		dc.l	60001,	setente

;---------------------------------------------
commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	lea	main_talk(pc),a0
	move.l	(a0),a0
	move.w	#1,(a0)

	move.w	#1,f_endprogram
	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1(pc),turnquant

	bsr.w	switchplanes
	bsr.w	turner
	bsr.w	perspective
	bsr.w	hidesort
	bsr.w	drawline
	bsr.w	turner
	bsr.w	perspective
	bsr.w	hidesort

	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	movem.l	d0-a6,-(a7)
;---
;---
	movem.l	(a7)+,d0-a6
	rts
;----------

Main_program:;;
	movem.l	d0-a6,-(a7)
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	#CopScreen_cube,(a0)

	move.w	#$0013,$180(a5)
	move.w	#$0413,$182(a5)
	move.w	#$0623,$184(a5)
	move.w	#$0844,$186(a5)
	move.w	#$0f00,$188(a5)
	move.w	#$0f0f,$18a(a5)
	move.w	#$0ff0,$18c(a5)
	move.w	#$0888,$18e(a5)

	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	lea	$dff000,a5
	bsr.w	switchplanes

	move.l	showplane(pc),d0
	move.l	d0,bpl1pth(a5)
	add.l	#40,d0
	move.l	d0,bpl2pth(a5)

	bsr.w	drawline
	tst.w	skipturn
	bne.b	skipturner

	bsr.w	turner
	bsr.w	perspective
skipturner:
	bsr.w	hidesort

	waitblit
;-----
	move.w	#1,intflag
	bsr.w	commander

	rts
;----------


;----------------------------------------------------------------------
morphfocus:
	subq.w	#1,focus
rts

set_skipturner:
	move.w	#1,skipturn
	rts

movecube:
	move.w	#1*4,turnaddx
	move.w	#2*4,turnaddy	;disabled in turner-routine
	move.w	#3*4,turnaddz
rts

nothing:	rts

;------------------------------------------------------------------------

CopScreen_cube:
	dc.w	diwstrt,$4f81
	dc.w	diwstop,$00c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,40
	dc.w	bpl2mod,40
	dc.w	bplcon0,%0010001000000000
	dc.l	-2

skipturn:	dc.w	0

turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0

turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0
turnx:		dc.w	0
turny:		dc.w	0
turnz:		dc.w	0


turner:	;last optimizing:93-09-05
	move.w	turnx(pc),a1
	add.w	turnaddx(pc),a1
	cmp.w	#1436,a1
	ble.b nolaufx
	sub.w	#1440,a1
nolaufx:
	move.w	a1,turnx

	move.w	turny(pc),a2
	add.w	turnaddy(pc),a2
	cmp.w	#1436,a2
	ble.b nolaufy
	sub.w	#1440,a2
nolaufy:
	move.w	a2,turny

	move.w	turnz(pc),a0
	add.w	turnaddz(pc),a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz


turner1:
	move.l	turnkoord(pc),a4	;koordinaten
	move.l	turnkoords(pc),a3
	lea	sinus(pc),a6	;sinus/cosinus
	move.w	turnquant(pc),d0
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
	add.l	#$00008000,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	add.l	#$00008000,d6
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
	add.l	#$00008000,d3
	swap	d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	add.l	d6,d6
	add.l	#$00008000,d6
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
	add.l	#$00008000,d3
	swap	d3
	sub.l	d7,d6		;d6=z*cos y - x*sin y
	add.l	d6,d6
	add.l	#$00008000,d6
	swap	d6
	move.w	d3,2(a4,d0.w)
	move.w	d6,6(a4,d0.w)

	subq.w	#8,d0
	bpl.w	turnrout1
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
move.w	focus(pc),d3
muls.w	d3,d0
muls.w	d3,d1
divs	d2,d0
divs	d2,d1

;---

move.w	d0,2(a4)
sub.w	#38,d1
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop
rts


focus:	dc.w	70	;70	;59=46*46	;57=45*44


switchmark:	dc.l	-1
switchplanes:
	tst.w	switchmark
	beq.b	do2
	bpl.b	do3
do1:
	addq.w	#1,switchmark	;=0
	move.l	#plane1,clearplane
	move.l	#plane2,showplane
	move.l	#plane3,pointplane
	rts
do2:
	addq.w	#1,switchmark	;=1
	move.l	#plane1,pointplane
	move.l	#plane2,clearplane
	move.l	#plane3,showplane
	rts
do3:
	subq.w	#2,switchmark	;=-1
	move.l	#plane1,showplane
	move.l	#plane2,pointplane
	move.l	#plane3,clearplane
	rts
;--------

showplane:	dc.l	0
clearplane:	dc.l	0
pointplane:	dc.l	0




drawline:
	move.l	turnkoord(pc),a1	;turned koordinates
	lea	areaoffsets(pc),a3	;areas to draw
	move.w	(a3)+,d7	;areacount
	lea	arealines+2(pc),a4	;linecodes for each area
drawloop1:		;mainloop for each area
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
move.w	#64,bltcmod(a5)
move.w	#64,bltdmod(a5)
move.w	#0,bltbdat(a5)
move.w	#$8000,bltadat(a5)

drawloop2:
;moveq	#90,d0
;add.b	d0,d0
;move.l	d0,d2
;moveq	#127,d1
;moveq	#127,d3
;move.w	4(a4,d6.w),d4	;pointcode1
;add.w	2(a1,d4.w),d0
;add.w	4(a1,d4.w),d1
;addq.w	#2,d6
;move.w	4(a4,d6.w),d4	;pointcode2
;add.w	2(a1,d4.w),d2
;add.w	4(a1,d4.w),d3



moveq	#80,d0
add.b	d0,d0
move.l	d0,d2
moveq	#121,d1

move.l	4(a4,d6.w),d4	;pointcode1+2
move.l	2(a1,d4.w),d3
add.w	d3,d1
swap	d3
add.w	d3,d0
addq.w	#2,d6	;cant remove this
swap	d4
moveq	#121,d3
move.l	2(a1,d4.w),d4
add.w	d4,d3
swap	d4
add.w	d4,d2


bsr.w	draw

dbf	d5,drawloop2
addq.w	#1,hiy	;highest x +1 coz difference 0-->1 line to blit
add.w	#16,hix
and.w	#%1111111111110000,hix
and.w	#%1111111111110000,lox

move.w	lox(pc),d0		;lowest x	      	PLANEOFFSET CALCULATION
lsr.w	#4,d0		;/16=words
add.w	d0,d0		;*2=bytes from left border

move.w	loy(pc),d1		;lowest y-koord
lsl.w	#6,d1		;*64 (bytes/line)
move.w	d1,d4		;copy for later use
add.w	d0,d1		;x-offset + y-offset...
move.w	d1,planeoffsets	;...=planeoffset for blitterwindow sourcescreen

move.w	loy(pc),d1		;again lowest y-koord
;lsl.w	#6,d4		;*(64*3) (bytes/line)
mulu.w	#40,d1
;move.w	d4,d1
add.w	d1,d1
add.w	d0,d1

;sub.w	#64*220+20,d1
move.w	d1,planeoffsetd	;planeoffset for destination screen


moveq	#64,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix(pc),d1		;highest x...
sub.w	lox(pc),d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source
add.w	#40-24,d0	;modulo+64+64...
move.w	d0,planemodulod	;...=modulo destination


move.w	hiy(pc),d2	;highest y-value...			BLTSIZE CALC
sub.w	loy(pc),d2	;...-lowest y-value
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize	;planesize for source and destination

add.w	planeoffsets(pc),d2
addq.w	#4,d2
move.w	d2,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize(pc),planesizef
move.w	planemodulos(pc),planemodulof

add.w	#5+64,planesizef
sub.w	#10,planemodulof
addq.w	#6,planeoffsetf

move.w	(a7)+,d0;areacolour from stack
	bsr.w	planefillcopycls
dbf	d7,drawloop1





move.l	clearplane(pc),d1
;add.w	#2*64*63+12,d1

add.l	#2*40*0+8+2,d1

lea	$dff000,a5
waitblit
move.l	d1,BLTDPTH(A5)
move.w	#32-24+6+4,BLTDMOD(A5)
move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
move.w	#154*2*64+16-3-2,BLTSIZE(A5)

rts





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



;***********************************************************




DRAW:
	lea	calcplane(pc),a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
	beq.w	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y


drawl1:	
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

;	MULU.W	#64,D0		;d0=y1*screen offset
	lsl.w	#6,d0
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

drawl2:
	RTS


OCTANTS:	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
	DC.L	$0B5AF017;-2		; BIT/LINE.
	DC.L	$0B5AF00B;-2


;cube
linepoints1: dc.w  7; 8 Linepoints

linekoord1:	blk.b	64,0
linekoords1:
sidex=207/2
sidey=37/2	;39 ;33
sidez=37/2


dc.w 0,-sidex-1,-sidey-1, sidez
dc.w 0,-sidex-1, sidey, sidez
dc.w 0, sidex, sidey, sidez
dc.w 0, sidex,-sidey-1, sidez
dc.w 0,-sidex-1,-sidey-1,-sidez
dc.w 0,-sidex-1, sidey,-sidez
dc.w 0, sidex, sidey,-sidez
dc.w 0, sidex,-sidey-1,-sidez


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


planefillcopycls:
;planefill:
	moveq	#0,d1
	move.w	planeoffsetf(pc),d1
	add.l	#calcplane,d1

lea	$dff000,a6
waitblit

	MOVE.l	#%00001001111100000000000000001010,bltcon0(a6);0+1 con
	MOVE.l	#-1,bltafwm(a6)

	MOVE.l	d1,bltapth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.w	planemodulof(pc),bltamod(a6)
	MOVE.w	planemodulof(pc),bltdmod(a6)
	MOVE.w	planesizef(pc),bltsize(a6)



;planecopy:
move.w	#%0000110111111100,d3
move.w	d3,d4

btst.l	#0,d0
bne.b	settest1
move.w	#%0000110100001100,d3
settest1:

btst.l	#1,d0
bne.b	settest2
move.w	#%0000110100001100,d4
settest2:


	moveq	#0,d2
	moveq	#0,d1
	move.w	planeoffsets(pc),d2
	move.w	planeoffsetd(pc),d1
	add.l	#calcplane,d2
	add.l	pointplane(pc),d1

waitblit

	MOVE.w	#0,bltcon1(a6)
	MOVE.l	#-1,bltafwm(a6)

	MOVE.w	d3,bltcon0(a6)
	MOVE.l	d1,bltbpth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.l	d2,bltapth(a6)
	MOVE.w	planemodulod(pc),bltbmod(a6)
	MOVE.w	planemodulod(pc),bltdmod(a6)
	MOVE.w	planemodulos(pc),bltamod(a6)
	MOVE.w	planesize(pc),bltsize(a6)

;-----

	add.l	#40,d1

waitblit

	MOVE.w	d4,bltcon0(a6)
	MOVE.l	d1,bltbpth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.l	d2,bltapth(a6)
	MOVE.w	planemodulod(pc),bltbmod(a6)
	MOVE.w	planemodulod(pc),bltdmod(a6)
	MOVE.w	planemodulos(pc),bltamod(a6)
	MOVE.w	planesize(pc),bltsize(a6)


;-----


;planecls:
	moveq	#0,d2
	move.w	planeoffsets(pc),d2
	add.l	#calcplane,d2


waitblit
	MOVE.w	#%0000000100000000,bltcon0(a6)
	MOVE.w	#0,bltcon1(a6)

	MOVE.l	d2,bltdpth(a6)
	MOVE.w	planemodulos(pc),bltdmod(a6)
	MOVE.w	planesize(pc),bltsize(a6)

	rts

hideflag:	dc.w	0


hidesort:
movem.l	d0-d7/a0-a6,-(a7)
lea	arealines(pc),a0	;basis of all areas
move.l	turnkoord(pc),a1	;turned koordinates
lea	areaoffsets+2(pc),a2
lea	zpositions(pc),a3	;mittelwerte der z-koords
move.w	(a0)+,d7	;number of all areas
moveq	#-1,d6		;counter of non-hidden areas

hidel1:
move.w	d7,d5
lsl.w	#5,d5
move.w	4(a0,d5.w),d0	;pointcode1
move.w	6(a0,d5.w),d2	;pointcode2
move.w	8(a0,d5.w),d4	;pointcode3
;lsl.w	#3,d0
;lsl.w	#3,d2
;lsl.w	#3,d4
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

movem.l	(a7)+,d0-d7/a0-a6

rts



bltfin:	dc.w	0

planeoffsets:	dc.w	0
planeoffsetd:	dc.w	0
planeoffsetf:	dc.w	0
planesizef:	dc.w	0
planesize:	dc.w	0
planemodulof:	dc.w	0
planemodulos:	dc.w	0
planemodulod:	dc.w	0
lox:	dc.w	0
loy:	dc.w	0
hix:	dc.w	0
hiy:	dc.w	0



calcplane:	blk.l	178*64/4,0;$ffffffff


plane1:	blk.l	2*256*40/4,0;$ffffffff
plane2:	blk.l	2*256*40/4,0;$ffffffff
plane3:	blk.l	2*256*40/4,0;$ffffffff
;plane1:	blk.l	2*178*40/4,$ffffffff
;plane2:	blk.l	2*178*40/4,$ffffffff
;plane3:	blk.l	2*178*40/4,$ffffffff


