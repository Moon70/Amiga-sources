;------------------------------------------------------------------------
;|                              Starscroller                            |
;|                             --------------                           |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                                   |
;------------------------------------------------------------------------
showtime=0
hide=0
fulllines=0
fillit=1


forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
dmaconr=$002
planesize=40*256
planeoffset=44+256*128
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
section	code,code_c
codec_s:
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

ifne	showtime						;
	move.w	#$0f00,$dff180					;
endif								;
	movem.l	(a7)+,d0-a6					;
ifne	showtime						;
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
;		dc.l	100,	nothing
		dc.l	200,	setint_star
		dc.l	1,	clr_f_fillclsfull
		dc.l	1530,	setcopcoltabcopy

		dc.l	80,	clrcoltabs
		dc.l	1,	set_f_fillclsfull
		dc.l	166,	set_f_metamorph
		dc.l	60000,	stop_turner
;		dc.l	1,	setente
		dc.l	60000,	commandrestart
;---------------------------------------------
f_copcoltabcopy:	dc.w	0
f_metamorph:		dc.w	0
f_fillclsfull:		dc.w	1

nothing:	rts

setcopcoltabcopy:
	move.w	#1,f_copcoltabcopy
	rts

clrcoltabs:
	lea	copcoltabs(pc),a0
	move.l	#$00040004,d0
	moveq	#(60/2)-1,d7
clrcoltabloop:
	move.l	d0,(a0)+
	dbf	d7,clrcoltabloop
	move.w	d0,(a0)
	move.w	#(61-1)*2,randompos
	rts

clr_f_fillclsfull:
	move.w	#0,f_fillclsfull
	rts

set_f_fillclsfull:
	move.w	#1,f_fillclsfull
	rts

set_f_metamorph:
	move.w	#1,f_metamorph
	rts

stop_turner:
	move.w	#0,turnaddz
	rts

commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	lea	main_talk(pc),a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts

setint_star:
;	lea	main_vbiuser,a0				;
;	move.l	(a0),a0					;
;	move.l	#int_test,(a0)				;
	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#copperlist,(a1)

	move.w	#%0000001000000000,bplcon0(a5)
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003800d0,ddfstrt(a5)	;strt+stop!
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.l	#$00180018,bpl1mod(a5)	;1mod+2mod!
	move.l	#plane_1,bpl1pth(a5)
	move.l	#plane_2,bpl2pth(a5)
	move.l	#plane_3,bpl3pth(a5)
	move.l	#plane_4,bpl4pth(a5)
	move.l	showplane,bpl5pth(a5)

lea	fontcol(pc),a0
lea	$180(a5),a1
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+

move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+

	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	lea	bssc_s,a0
	moveq	#0,d0
	move.w	#(bssc_e-bssc_s)/4-1,d7
bssclrloop:
	move.l	d0,(a0)+
	dbf	d7,bssclrloop

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1(pc),turnquant
	move.w	linequant1(pc),linequant
	move.l	#lines1,lines
	move.w	#4*0,turnaddx
	move.w	#4*0,turnaddy
	move.w	#4*3,turnaddz
	bsr.w	turner
	bsr.w	metinit
	bsr.w	coppercopy
	bsr.w	switchplanes
	bsr.w	textcalc
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	rts
;----------

Main_program:;;
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)
	move.w	#0,intflag

;jsr	drawchar
	rts

main_intuser:;;
	lea	$dff000,a5

	move.w	#%0101001000000000,bplcon0(a5)

move.l	#plane_1,bpl1pth(a5)
move.l	#plane_2,bpl2pth(a5)
move.l	#plane_3,bpl3pth(a5)
move.l	#plane_4,bpl4pth(a5)
move.l	showplane,bpl5pth(a5)


	tst.w	f_fillclsfull
	beq.b	notclearfull
	bsr.w	planecls_full
	bra.b	cleared
notclearfull:
	bsr.w	planecls
cleared:

	tst.w	f_metamorph
	beq.b	skipmeta
	bsr.w	movep
skipmeta:
	bsr.w	turner
	bsr.w	scroller
	bsr.w	drawline
	bsr.w	copcoltabcopy
	bsr.w	coppercopy

ifne	fillit
	tst.w	f_fillclsfull
	beq.b	notfillfull
	bsr.w	fill_full
	bra.b	filled
notfillfull:
	bsr.w	fill
filled:
endif
	bsr.b	switchplanes


waitblit

	move.w	#1,intflag
	bsr.w	commander
	rts
;----------



;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
switchmark:	dc.l	-1

switchplanes:
	tst.w	switchmark
	beq.b	do2
	bpl.b	do3
do1:
	move.w	#0,switchmark
	move.l	#plane1,clearplane
	move.l	#plane2,showplane
	move.l	#plane3,pointplane
	rts
do2:
	move.w	#1,switchmark
	move.l	#plane1,pointplane
	move.l	#plane2,clearplane
	move.l	#plane3,showplane
	rts
do3:
	move.w	#-1,switchmark
	move.l	#plane1,showplane
	move.l	#plane2,pointplane
	move.l	#plane3,clearplane
	rts

planecls:
	lea	$dff000,a5
	move.l	clearplane(pc),a0
	lea	43*64+10(a0),a0
	waitblit
	move.l	a0,BLTDPTH(A5)
	move.w	#24+16,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#(145+27)*64+12,BLTSIZE(A5)
rts
;;;
rept	111-86
	movem.l	d0-d5,(a0)
	lea	64(a0),a0
endr
	rts

Planecls_full:
	lea	$dff000,a5
	move.l	clearplane(pc),a0
	waitblit
	move.l	a0,BLTDPTH(A5)
	move.w	#24,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#145*64+20,BLTSIZE(A5)

	lea	145*64(a0),a0

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
rept	111
	movem.l	d0-d7/a1-a2,(a0)
	lea	64(a0),a0
endr
	rts

fill:
	lea	$dff000,a5
	move.l	pointplane(pc),d0
	add.l	#(255-41)*64+40,d0
	waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#24,bltamod(A5)
	MOVE.w	#24,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#(256-84)*64+20,BLTSIZE(A5)
	rts

Fill_full:
	lea	$dff000,a5
	move.l	pointplane(pc),d0
	add.l	#255*64+38,d0
	waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#24,bltamod(A5)
	MOVE.w	#24,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#256*64+20,BLTSIZE(A5)
	rts



showplane:	dc.l	0
clearplane:	dc.l	0
pointplane:	dc.l	0


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
	move.w	turnz(pc),a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz

turner1:
	move.l	turnkoord(pc),a4	;koordinaten
	move.l	turnkoords(pc),a3
	lea	sinus(pc),a6	;sinus/cosinus
	move.w	focus(pc),d1
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

	cmp.w	#64,d1
	beq.b	nozoomflow
tst.w	switchmark
bne	nozoomflow
	addq.w	#1,focus
nozoomflow:

	rts
;*****
focus:	dc.w	6




drawline:
lea	$dff000,a5

move.l	turnkoord(pc),a0
move.l	lines(pc),a1
move.w	linequant(pc),d7

drawloop:
;moveq	#0,d0
;moveq	#0,d2

moveq	#0,d0
move.w	#173,d0
move.l	d0,d2

moveq	#0,d1
move.w	#132,d1
move.l	d1,d3

;move.w	#160,d0
;moveq	#127,d1
;move.w	#160,d2
;moveq	#127,d3

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
	bge.b	line_borderline1	;both points out of range-->draw border
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
rts

line_borderline1:
move.w	#winx2,d0
move.w	d0,d2
bsr.b	line
bra.b	line_skip



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
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
	LSL.W	#1,D3		;d3=lodiff*2
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.B	.NOSIGN		;branch if lodiff*2 >hidiff
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

bwait5:
btst	#14,dmaconr(a5)
bne.b	bwait5

	MOVE.l	#-1,bltafwm(a5)
	MOVE.w	#64,bltcmod(a5)
	MOVE.w	#64,bltdmod(a5)
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


step=1000

metinit:
	lea	mettab,a0
	lea	linekoords1,a1
	move.w	linepoints1,d7
metintloop:
	move.w	2(a1),d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+

	move.w	4(a1),d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	addq.l	#8,a1
	dbf	d7,metintloop
;---
	lea	metdiff,a0
	lea	linekoords1,a1
	lea	linekoords2,a2
	move.w	linepoints1,d7
diffloop:
	move.w	2(a1),d0	;x1
	move.w	2(a2),d1	;x2

	sub.w	d0,d1		;d1=x2-x1

	ext.l	d1
	asl.l	#8,d1
	asl.l	#8,d1
	divs	#step,d1
	ext.l	d1
	move.l	d1,(a0)+

	move.w	4(a1),d0	;y1
	move.w	4(a2),d1	;y2

	sub.w	d0,d1		;d1=y2-y1

	ext.l	d1
	asl.l	#8,d1
	asl.l	#8,d1
	divs	#step,d1
	ext.l	d1
	move.l	d1,(a0)+
	addq.l	#8,a1
	addq.l	#8,a2
	dbf	d7,diffloop
	move.w	#step/8,stepcount
;	subq.w	#4,stepcount
	rts
	


MOVEP:
	tst.w	stepcount
	beq.b	skipmovep
	subq.w	#1,stepcount

	lea	mettab,a0
	lea	metdiff,a1
	lea	linekoords1,a2
	MOVE.w	linepoints1,D7
MOVEPLoop:
	move.l	(a1)+,d0
	move.l	(a1)+,d1
add.l	d0,d0
add.l	d0,d0
add.l	d0,d0
add.l	d1,d1
add.l	d1,d1
add.l	d1,d1
	add.l	d0,(a0)+
	add.l	d1,(a0)+
	move.w	-8(a0),2(a2)
	move.w	-4(a0),4(a2)
	addq.w	#8,a2
	DBF	D7,MOVEPLoop
skipmovep:
	RTS




stepcount:	dc.w	0


coppercopy:
	lea	copperlist,a0
	lea	copcoltab(pc),a1
	move.w	#$e00f,d0
	moveq	#55,d7
coppercopyl1:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.l	#$01800004,(a0)+
	add.w	#$76,d0
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.w	#$0180,(a0)+
	move.w	(a1)+,(a0)+
	add.w	#$8a,d0
	bcc.b	nocopborder
	move.l	#$ffe1fffe,(a0)+
nocopborder:
	dbf	d7,coppercopyl1


	moveq	#4,d7
coppercopyl2:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.l	#$01800004,(a0)+
	add.w	#$78,d0
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.w	#$0180,(a0)+
	move.w	(a1)+,(a0)+
	add.w	#$88,d0
	dbf	d7,coppercopyl2


	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.l	#$01800004,(a0)+
	move.l	#-2,(a0)
	rts

;325
;314

copcoltab:	dcb.w	61,$0004

copcoltabs:
		dcb.w	56,$0325
		dcb.w	5,$0314

copcoltabcopy:
	tst.w	f_copcoltabcopy
	beq.b	copcoltabcopy_skip
	move.w	randompos(pc),d0
	bmi.b	copcoltabcopy_skip
	lea	random(pc),a0
	move.w	(a0,d0.w),d1

	lea	copcoltab(pc),a0
	lea	copcoltabs(pc),a1
	move.w	(a1,d1.w),(a0,d1.w)
	subq.w	#2,d0
	move.w	d0,randompos
copcoltabcopy_skip:
	rts

;------------------------------------------------------------------------
chars:	dc.b " abcdefghijklmnopqrstuvwxyz0123456789?#!|&'()><,-./:;=*+"
;                                                   f "a
;                                                   a  n
;                                                   c  d
;                                                   e
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
;dc.b	"                  "
;dc.b	"get a pen for our addresses, but before that we "
;dc.b	"will show you a routine called * braindead in a box * "
;dc.b	"               "
;------
dc.b	"                  "
dc.b	"coming up is a routine called  * braindead in a box *  "
dc.b	"   remember- it's n#t aga..."
dc.b	"                                               "

;------
textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=4*31*4
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
	beq.b	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------

drawchar:
	lea	textpoint(pc),a0
	move.w	(a0),d0
	addq.w	#2,(a0)
	lea	2(a0,d0.w),a1
	move.w	(a1),d0
	bpl.b	notextrestart
	moveq	#0,d0	;space
	move.w	d0,(a0)	;text restart
notextrestart:

	lea	font,a0
	add.w	d0,a0
	lea	plane_1,a1
	lea	64*194+40(a1),a1
	lea	plane_size(a1),a2
	lea	plane_size(a2),a3
	lea	plane_size(a3),a4
	moveq	#30,d7
drawcharloop:
	move.l	(a0)+,(a1)
	move.l	(a0)+,(a2)
	move.l	(a0)+,(a3)
	move.l	(a0)+,(a4)
	lea	64(a1),a1
	lea	64(a2),a2
	lea	64(a3),a3
	lea	64(a4),a4
	dbf	d7,drawcharloop
rts

scrollcount:	dc.w	32
scroller:
	subq.w	#2,scrollcount
	bne.b	nonewchar
	bsr.b	drawchar
	move.w	#32,scrollcount

nonewchar:
	lea	plane_1,a1
	lea	64*194+18(a1),a1
	waitblit
	move.l	a1,bltapth(a5)
	subq.w	#2,a1
	move.l	a1,bltdpth(a5)
	move.w	#64-28,bltamod(a5)
	move.w	#64-28,bltdmod(a5)
	move.l	#%01111111111111111111111111111111,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%1110100111110000,bltcon0(a5)
	move.w	#31*64+14,bltsize(a5)

	lea	plane_2,a1
	lea	64*194+18(a1),a1
	waitblit
	move.l	a1,bltapth(a5)
	subq.w	#2,a1
	move.l	a1,bltdpth(a5)
	move.w	#64-28,bltamod(a5)
	move.w	#64-28,bltdmod(a5)
	move.l	#%01111111111111111111111111111111,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%1110100111110000,bltcon0(a5)
	move.w	#31*64+14,bltsize(a5)

	lea	plane_3,a1
	lea	64*194+18(a1),a1
	waitblit
	move.l	a1,bltapth(a5)
	subq.w	#2,a1
	move.l	a1,bltdpth(a5)
	move.w	#64-28,bltamod(a5)
	move.w	#64-28,bltdmod(a5)
	move.l	#%01111111111111111111111111111111,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%1110100111110000,bltcon0(a5)
	move.w	#31*64+14,bltsize(a5)

	lea	plane_4,a1
	lea	64*194+18(a1),a1
	waitblit
	move.l	a1,bltapth(a5)
	subq.w	#2,a1
	move.l	a1,bltdpth(a5)
	move.w	#64-28,bltamod(a5)
	move.w	#64-28,bltdmod(a5)
	move.l	#%01111111111111111111111111111111,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%1110100111110000,bltcon0(a5)
	move.w	#31*64+14,bltsize(a5)
rts

randompos:	dc.w	(61-1)*2
random:
jaul:
downup:
dc.w 0
dc.w 118
dc.w 4
dc.w 114
dc.w 8
dc.w 110
dc.w 12
dc.w 106
dc.w 16
dc.w 102
dc.w 20
dc.w 98
dc.w 24
dc.w 94
dc.w 28
dc.w 90
dc.w 32
dc.w 86
dc.w 36
dc.w 82
dc.w 40
dc.w 78
dc.w 44
dc.w 74
dc.w 48
dc.w 70
dc.w 52
dc.w 66
dc.w 56
dc.w 62
dc.w 60
dc.w 58
dc.w 64
dc.w 54
dc.w 68
dc.w 50
dc.w 72
dc.w 46
dc.w 76
dc.w 42
dc.w 80
dc.w 38
dc.w 84
dc.w 34
dc.w 88
dc.w 30
dc.w 92
dc.w 26
dc.w 96
dc.w 22
dc.w 100
dc.w 18
dc.w 104
dc.w 14
dc.w 108
dc.w 10
dc.w 112
dc.w 6
dc.w 116
dc.w 2
dc.w 2

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



linekoord1:	dcb.b	80,0

linepoints1: dc.w  9
linequant1: dc.w  9*4
linekoords1:
dc.w 0,-8,-336,0
dc.w 0, 76,-108,0
dc.w 0, 320,-112,0
dc.w 0, 124, 36,0
dc.w 0, 204, 268,0
dc.w 0, 0, 128,0
dc.w 0,-192, 276,0
dc.w 0,-124, 44,0
dc.w 0,-328,-100,0
dc.w 0,-80,-104,0
lines1:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  9, 0



linepoints2: dc.w  9
linequant2: dc.w  9*4
linekoords2:
dc.w 0,-384,-504,0
dc.w 0, 0,-504,0
dc.w 0, 388,-504,0
dc.w 0, 388,-168,0
dc.w 0, 388, 172,0
dc.w 0, 388, 508,0
dc.w 0, 4, 508,0
dc.w 0,-384, 508,0
dc.w 0,-384, 172,0
dc.w 0,-384,-168,0
lines2:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  9, 0

fontcol:
	dc.w $004,$AFF,$7CC,$5AA,$388,$166,$044,$022
	dc.w $FBF,$D8D,$B7B,$A6A,$858,$636,$424,$212

	dc.w $015,$015,$015,$015,$015,$015,$015,$015
	dc.w $015,$015,$015,$015,$015,$015,$015,$015

;	dc.w $015,$9ee,$6bb,$499,$277,$055,$033,$011
;	dc.w $eae,$c7c,$a6a,$959,$747,$525,$313,$101




font:	incbin	"data/pearlfont.blt"

datac_s:
datac_e:
codec_e:
;-------------------
section	memory,bss_c
bssc_s:
copperlist:	ds.b	1000

mettab:		ds.b	200
metdiff:	ds.b	200

plane1:	ds.b	1*256*64
plane2:	ds.b	1*256*64
plane3:	ds.b	1*256*64


plane_size=64*256
plane_1:	ds.b	plane_size
plane_2:	ds.b	plane_size
plane_3:	ds.b	plane_size
plane_4:	ds.b	plane_size
bssc_e:

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


