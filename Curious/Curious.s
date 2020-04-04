;------------------------------------------------------------------------
;-                                                                      -
;-                               CURIOUS                                -
;-                              ---------                               -
;-                                                                      -
;-      code by Moon, graphics by Artline, music by Neurodancer         -
;-                                                                      -
;-                   an ABYSS production in 1993                        -
;-                                                                      -
;------------------------------------------------------------------------

openlibrary=-30-522
startlist=38
dmaconr=$002

execbase=4
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
intena=$09a

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

start:
	move.l	execbase,a6
	jsr	forbid(a6)
	lea	$dff000,a5
	move.w	#0,$1fc(a5)
	bclr.b	#12,$106(a5)
	bclr.b	#13,$106(a5)
	bclr.b	#14,$106(a5)
	move.w	#%0000001111100000,dmacon(a5)

	move.w	#%0000000001101000,intena(a5)
	move.l	$6c,oldint
	move.l	#emptyintrout,$6c
	move.w	#%1100000000100000,intena(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	#0,$dff144	;kill mousesprite
	move.l	#pr_data,pr_module
	jsr	pr_init


	bsr.w	textcalc

	jsr	commander
	lea	sinus32,a0
	move.w	#360/2-1,d0
sin32copy:
	move.w	(a0),360*1(a0)
	move.w	(a0),360*2(a0)
	move.w	(a0)+,360*3(a0)
	dbf	d0,sin32copy

wait:
	move.w	dircommand,d0
	beq.b	nodircommand
	jsr	dircommander
nodircommand:
	btst	#6,ciaapra
	beq.b back
tst.w	escape
beq.b	wait

back:
move.w	#0,comsleep
cmp.w	#1,backphase
beq	back2

back1:
	lea	tofade,a0
	moveq	#15,d0
backblack:
	move.l	#$00000000,(a0)+
	dbf	d0,backblack
	move.w	#2,fadecount
	jsr	fader
waittillblack:
	cmp.w	#30,fadeflag
	bne	waittillblack
	bra	backcont

back2:
	move.w	#0,turnaddz
back2l1:
	moveq	#10,d0
back2intwait:
	tst.w	intmark
	bne	back2intwait
	move.w	#1,intmark
	dbf	d0,back2intwait

	move.w	#4*30,d0
	sub.w	turnaddz,d0
	divu.w	#4*7,d0
	addq.w	#2,d0
	move.w	d0,pr_speed

	add.w	#4,turnaddz
	cmp.w	#4*30,turnaddz
	bne	back2l1
	bra	backcont



backcont:
	lea	$dff000,a5
	move.w	#%0000001000000000,bplcon0(a5)
	move.l	#emptyintrout,$6c
	move.l	#nocopperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	jsr	bltwait

	jsr	pr_end
	move.l	execbase,a6
	lea	$dff000,a5
	lea	grname,a1
	moveq	#0,d0
	jsr	openlibrary(a6)
	move.l	d0,a4
	move.l	startlist(a4),cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000001111100000,dmacon(a5)
	move.w	#%1000000001101000,intena(a5)
	move.l	oldint,$6c
	jsr	permit(a6)
	moveq	#0,d0
	rts

introut:
	movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a5
	move.l	showplane,d0
	addq.l	#6,d0
	move.l	d0,bpl1pth(a5)
	add.l	#planesize,d0
	move.l	d0,bpl2pth(a5)
	move.w	#%0010001000000000,bplcon0(a5)

	bsr.w	coppercopy
	bsr.w	turner
	bsr.w	turner2
	bsr.w	corrector
	bsr.w	commander
	bsr.w	drawline
jsr	realfade
move.l	faded,$dff180
move.l	faded+4,$dff184
	bsr.w	scroller
	bsr.w	drawstars
	jsr	pr_music
	bsr.w	animator
	bsr.w	clearstars
	bsr.w	starmove
	bsr.b	switchplanes
	move.l	showlist,cop1lch+$dff000
	move.w	#0,intmark
	movem.l	(a7)+,d0-d7/a0-a6

intback:
	move.w	#%0000000001100000,$dff09c
	rte

switchplanes:
	tst.w	switchmark
	beq.b	do2
	bpl.w	do3
do1:
	move.w	#0,switchmark
	move.l	#plane1,clearplane
	move.l	#plane2,showplane
	move.l	#plane3,pointplane
	move.l	#scrolldatat1,workdat
	move.l	#scrolldatat2,cleardat
	move.l	#copperlist1,showlist
	move.l	#copperlist2,worklist
	rts
do2:
	move.w	#1,switchmark
	move.l	#plane1,pointplane
	move.l	#plane2,clearplane
	move.l	#plane3,showplane
	move.l	#scrolldatat2,workdat
	move.l	#scrolldatat3,cleardat
	move.l	#copperlist2,showlist
	move.l	#copperlist3,worklist
	rts
do3:
	move.w	#-1,switchmark
	move.l	#plane1,showplane
	move.l	#plane2,pointplane
	move.l	#plane3,clearplane
	move.l	#scrolldatat3,workdat
	move.l	#scrolldatat1,cleardat
	move.l	#copperlist3,showlist
	move.l	#copperlist1,worklist
	rts
;--------

drawline:
	move.l	worklist,a6
	lea	56(a6),a6
	lea	scrollfield,a3
	moveq	#15,d5
	move.l	workdat,a1

drawloop:
	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127-85,d1
	moveq	#127-85,d3
	add.w	(a1)+,d0
	add.w	(a1)+,d1
	add.w	(a1)+,d2
	add.w	(a1)+,d3
	bsr.w	draw2
	dbf	d5,drawloop

	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127,d1
	moveq	#127,d3
	add.w	(a1)+,d0
	add.w	(a1)+,d1
	add.w	(a1)+,d2
	add.w	(a1)+,d3
	move.l	clearplane,a0
	add.l	#planesize,a0
	MOVE.w	#$ffff,linemask
	bsr.w	draw

	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127,d1
	moveq	#127,d3
	add.w	(a1)+,d0
	add.w	(a1)+,d1
	add.w	(a1)+,d2
	add.w	(a1)+,d3
	move.l	clearplane,a0
	add.l	#planesize,a0
	bsr.w	draw

	move.l	cleardat,a1
	lea	16*8(a1),a1
	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127,d1
	moveq	#127,d3
	add.w	(a1)+,d0
	add.w	(a1)+,d1
	add.w	(a1)+,d2
	add.w	(a1)+,d3
	move.l	showplane,a0
	add.l	#planesize,a0
	MOVE.w	#$0,linemask
	bsr.w	draw

	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127,d1
	moveq	#127,d3
	add.w	(a1)+,d0
	add.w	(a1)+,d1
	add.w	(a1)+,d2
	add.w	(a1)+,d3
	move.l	showplane,a0
	add.l	#planesize,a0
	bsr.w	draw
	move.w	linequant2,d6
	move.w	#-1,linemask
	move.l	clearplane,a0
	lea	30*4(a1),a1
	lea	lines2(pc),a3

abyssloop:
	moveq	#115,d0
	add.w	d0,d0
	move.l	d0,d2
	moveq	#127,d1
	moveq	#127,d3
	move.l	(a3,d6.w),d4
	lsl.l	#2,d4
	add.w	(a1,d4.w),d0
	add.w	2(a1,d4.w),d1
	swap	d4
	add.w	(a1,d4.w),d2
	add.w	2(a1,d4.w),d3
	bsr.w	draw
	subq.w	#4,d6
	bpl.b	abyssloop
	move.l	#-2,(a6)
	rts

clearstars:
	move.l	cleardat,a1
	lea	18*8(a1),a1
	moveq	#27,d5
	move.l	clearplane,a0
	lea	planesize(a0),a0
dotclrloop:
	move.w	#180,d0
	moveq	#127,d1
	sub.w	(a1)+,d0
	add.w	(a1)+,d1
	lsl.w	#6,d1
	move.b  d0,d2
	lsr.w	#3,d0
	sub.w   d0,d1
	bclr.b  d2,50(a0,d1.w)
	dbf	d5,dotclrloop
	rts

drawstars:
	move.l	workdat,a1
	lea	18*8(a1),a1
	moveq	#27,d5
	move.l	pointplane,a0	;planeadress
	move.l	a0,a2
	lea	planesize(a2),a2
dotloop:
	move.w	#180,d0
	moveq	#127,d1
	sub.w	(a1)+,d0
	add.w	(a1)+,d1
	lsl.w	#6,d1
	move.b  d0,d2
	lsr.w	#3,d0
	sub.w   d0,d1
	bset.b  d2,50(a0,d1.w)
	bset.b  d2,50(a2,d1.w)
	dbf	d5,dotloop
	rts

DRAW2:
	move.l	clearplane,a0	;planeadress
	lea	64*85(a0),a0
	lea	octants(pc),a2	;octantbasis
draw2l1:	
	SUBQ.W	#1,D3
	SUB.W	D1,D3
bpl.b	noneg1
	lea	16(a2),a2
	NEG.W	D3
noneg1:
	SUB.W	D0,D2
	bpl.b	drawl3
	NEG.W	D2
	ADDQ.L	#8,A2
drawl3:	CMP.W	D2,D3
	BLE.S	drawl4
	ADDQ.L	#4,A2
	EXG.l	D2,D3
drawl4:
	MOVE.L	(A2),D4
	ROR.L	#3,D0
	LEA	(A0,D0.W),A2
	ROR.L	#1,D0
	AND.L	#$F0000000,D0
	OR.L	D0,D4
	MOVE.W	D1,D0
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2
	LSL.W	#1,D3
	MOVE.W	D3,D0
	SUB.W	D2,D3
	BGE.S	drawl5
	OR.B	#$40,D4
drawl5:
	LSL.W	#1,D0
	MOVE.W	D0,D1
	LSL.W	#2,D2
	SUB.W	D2,D1
	ADDQ.W	#4,D2
	LSL.W	#4,D2
	ADDQ.W	#2,D2

	move.w	d3,2(a6)
	move.l	a2,d3
	move.w	d3,6(a6)
	move.w	d3,10(a6)
	swap	d3
	move.w	d3,14(a6)
	move.w	d3,18(a6)
	move.w	d0,22(a6)
	move.w	d4,26(a6)
	swap	d4
	move.w	d4,30(a6)
	move.w	d1,34(a6)

	moveq	#22,d6
	lea	36(a6),a6

contline:
	move.w	(a3)+,2(a6)
	lea	16(a6),a6
	dbf	d6,contline
draw2l2:
	addq.l	#4,a3
	rts

turner:
	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz

	move.w	turn4x,a1
	add.w	turnaddx,a1
	cmp.w	#1436,a1
	ble.b nolaufx
	sub.w	#1440,a1
nolaufx:
	move.w	a1,turn4x

turner1:
	move.l	workdat,a4	;koordinaten
	lea	scrolldatas,a3
	lea	d3sinus,a6	;sinus/cosinus
	moveq	#15+16+4+30+29,d0
turnrout1:
;-------------
	move.w	2(a3),d3
	moveq	#0,d4

	move.l	0(a6,a1.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.w	d3,d6		;d6=y
;	move.w	d4,d7		;d7=z
	muls.w	d5,d3		;d3=y*cos x
;	muls.w	d5,d7		;d7=z*cos x
	swap	d5
;	muls.w	d5,d4		;d4=z*sin x
	muls.w	d5,d6		;d6=y*sin x
	sub.l	d4,d3		;d3=y*cos x - z*sin x ->new y-koord
	swap	d3
rol.l	#1,d3
;	add.l	d7,d6		;d6=y*sin x + z*cos x
	swap	d6
rol.l	#1,d6

	move.w	d3,d4
	move.w	(a3),d3

	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=y
	muls.w	d5,d3		;d3=x*cos z
	muls.w	d5,d7		;d7=y*cos z
	swap	d5
	muls.w	d5,d4		;d4=y*sin z
	muls.w	d5,d6		;d6=x*sin z
	sub.l	d4,d3		;d3=x*cos z - y*sin z  ->new  x-koord
	swap	d3
	rol.l	#1,d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	swap	d6
	rol.l	#1,d6

	move.w	d3,(a4)+
	move.w	d6,(a4)+
	addq.l	#4,a3
	dbf	d0,turnrout1
	rts

dircommander:

dircom1:
	cmp.w	#1,d0
	bne.w	dircom2
;-----
	lea	$dff000,a5
	move.l	#waitblankrout,$6c
	move.l	#nocopperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	jsr	bltwait
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0030,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
;	move.w	#%0110011000000000,bplcon0(a5)
	move.w	#%0000011000000000,bplcon0(a5)
	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
	move.w	#24+64+64-2,bpl1mod(a5)
	move.w	#24+64+64-2,bpl2mod(a5)
	move.w	#%0000000000000100,bplcon2(a5)
	jsr	mainmemcls
sinecopy1:
	lea	sinuss,a0
	move.w	#359,d0
sinecopyl1:
	move.w	(a0)+,720-2(a0)
	dbf	d0,sinecopyl1

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	#6*4,turnadd2x
;	move.w	#0*4,turnadd2y	;disabled in turner-routine
	move.w	#3*4,turnadd2z

	jsr	coppercopy1
	jsr	coppercopy3
	jsr	coppercopy4
	jsr	turner3
	jsr	hidesort
	jsr	colput
	jsr	coppercopy2
	lea	$dff000,a5

	movem.l	d0-a6,-(a7)
	jsr	switchplanes2
	jsr	animmaker
	movem.l	(a7)+,d0-a6
	move.w	#1,animfin
	move.l	#maincopperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
;-----
move.w	#0,dircommand
rts

dircom2:
	cmp.w	#2,d0
	bne.w	dircom3
;-----
	lea	$dff000,a5
	move.w	#%0000001000000000,bplcon0(a5)
	move.l	#musicintrout,$6c
	move.l	#nocopperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	jsr	bltwait

	jsr	mainmemcls
	lea	$dff000,a5
	move.l	#$24792ec9,diwstrt(a5)
	move.l	#$003000d8,ddfstrt(a5)
	bsr.w	switchplanes
	jsr	copperinit
	bsr.w	switchplanes
	jsr	copperinit
	bsr.w	switchplanes
	jsr	copperinit
	move.l	#-2,copperlist1
	move.l	#-2,copperlist2
	move.l	#-2,copperlist3
	bsr.w	turner2
	bsr.w	turner
	lea	$dff000,a5
;	move.w	#%0010001000000000,bplcon0(a5)
	move.l	#$00000000,bplcon1(a5)
	move.l	#$00140014,bpl1mod(a5)
	move.l	showlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	bset.b	#1,copcon(a5)


	lea	tofade,a0
	move.w	#$0044,(a0)+
	move.w	#$04ba,(a0)+	;scroll
	move.w	#$00ff,(a0)+	;bars
	move.w	#$0fff,(a0)+	;stars
	move.l	#$00440044,faded
	move.l	#$00440044,faded+4
	move.w	#6,fadecount
	jsr	fader



	move.l	#introut,$6c
;-----
move.w	#0,dircommand
rts

dircom3:
	cmp.w	#3,d0
	bne.b	dircom4
;-----
jsr	fader
;-----
move.w	#0,dircommand
rts

dircom4:
	cmp.w	#4,d0
	bne.w	dircom5
;-----
	lea	$dff000,a5
	move.w	#%0000001000000000,bplcon0(a5)
	move.l	#musicintrout,$6c
	move.l	#nocopperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	jsr	bltwait
	jsr	mainmemcls


;	move.l	execbase,a6
;	jsr	forbid(a6)
	lea	$dff000,a5
;	move.w	#%0000001111100000,dmacon(a5)
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003000d0,ddfstrt(a5)	;strt+stop!
;	move.w	#%0001001000000000,bplcon0(a5)
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.l	#$00160016,bpl1mod(a5)	;1mod+2mod!
;	move.w	#%1000001101000000,dmacon(a5)

;move.w	#$0044,$180(a5)
;move.w	#$04ba,$182(a5)
	lea	tofade,a0
	move.l	#$004404ba,(a0)+
	move.w	#6,fadecount
;	move.w	#3,dircommand
	jsr	fader
	jsr	switchplanes3
;	move.w	#%0000000001101000,intena(a5)
;	move.l	$6c,oldint3
	move.l	#introut3,$6c
;	move.w	#%1100000000100000,intena(a5)
	

wait33:
	btst	#6,ciaapra
	beq.b back33
tst.w	sinscrolloff
bne.b	back33
tst.w	intwait3
bne.b	wait33

	jsr	planecls3
	jsr	turner4
	jsr	maskscroller
	jsr	drawline4
	jsr	switchplanes3

move.w	#1,intwait3
bra.b	wait33

back33:
;-----
move.w	#0,dircommand
rts

dircom5:
move.w	#0,dircommand
rts

commander:
	subq.w	#1,comsleep
	bne.w	comend
	move.w	compoint,d0
	addq.w	#4,compoint
	lea	commands(pc),a0
	move.l	(a0,d0.w),d0
	move.w	d0,comsleep
	swap	d0

com1:
cmp.w	#1,d0
bne.b	com2
	move.w	#4,turnaddz
rts
;----------

com2:
cmp.w	#2,d0
bne.b	com3
	move.w	#1440-4,turnaddz
rts
;----------

com3:
cmp.b	#3,d0
bne.b	com4
	move.w	#0,turnaddz
rts
;----------

com4:
cmp.b	#4,d0
bne.b	com5
move.w	#0,scrolloff
rts
;----------

com5:
cmp.b	#5,d0
bne.b	com6
move.w	#1,scrolloff
rts
;----------

com6:
cmp.b	#6,d0
bne.b	com7
	move.w	#16,turnaddz
rts
;----------

com7:
cmp.b	#7,d0
bne.b	com8
	move.w	#1440-12,turnaddz
rts
;----------

com8:
cmp.b	#8,d0
bne.b	com9
move.l	#scrolldatas1,scrolldataso
rts
;----------

com9:
cmp.b	#9,d0
bne.b	com10
move.l	#scrolldatas2,scrolldataso
rts
;----------

com10:
cmp.b	#10,d0
bne.b	com11
move.l	#scrolldatas3,scrolldataso
rts
;----------

com11:
cmp.b	#11,d0
bne.b	com12
move.l	#scrolldatas4,scrolldataso
rts
;----------

com12:
cmp.b	#12,d0
bne.b	com13
move.l	#scrolldatas5,scrolldataso
rts
;----------

com13:
cmp.b	#13,d0
bne.b	com14
move.w	#3*4,turnaddx
rts
;----------

com14:
cmp.b	#14,d0
bne.b	com20		;!!!!!
move.w	#0,turnaddx
rts


com20:
cmp.b	#20,d0
bne.b	com21		;!!!!!
move.w	#1,dircommand	;init planeplasmaroutine
rts

com21:
cmp.b	#21,d0
bne.b	com22
move.w	#2,dircommand	;init curiousscroller
move.w	#1,backphase
rts

com22:
cmp.b	#22,d0
bne.b	com23

lea	tofade,a0
lea	logocol,a1
moveq	#7,d0
putcolloop:
addq.l	#2,a1
move.w	(a1)+,(a0)+
dbf	d0,putcolloop
	move.w	#10,fadecount
move.w	#3,dircommand

rts

com23:
cmp.b	#23,d0
bne.b	com24

	lea	tofade,a0
	lea	16(a0),a0
	move.l	#$000f0500,(a0)+
	move.l	#$00500005,(a0)+
	move.l	#$05500505,(a0)+
	move.l	#$00550000,(a0)+
	move.w	#10,fadecount
	move.w	#3,dircommand
rts

com24:
cmp.b	#24,d0
bne.b	com25
	move.w	#4,dircommand
rts

com25:
cmp.b	#25,d0
bne.b	com26
	move.w	#1,sinscrolloff
rts

com26:
cmp.b	#26,d0
bne.b	com27
	lea	tofade,a0
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.l	#$00000000,(a0)+
	move.w	#5,fadecount
	move.w	#3,dircommand
rts


com27:



move.w	#1,comsleep
move.w	#0,compoint
comend:
rts




scroller:
tst	scrolloff
beq.w	noscroll

	subq.w	#1,scrollpoint
	bne.b	scrollit
	lea	offsettext2,a0
	move.w	textpoint,d0
	move.w	(a0,d0.w),d1
	bpl.b	notextrestart
	moveq	#0,d0
;	move.w	d0,compoint
;	move.w	#1,comsleep
	move.w	#1,escape
	move.w	#0,backphase
	move.w	(a0,d0.w),d1

notextrestart:
	addq.w	#2,d0
	move.w	d0,textpoint
	lea	font,a1
	lea	0(a1,d1.w),a1
	move.w	#6,scrollpoint
	lea	scrollfield+46,a0
	moveq	#15,d0
drawcharloop:
	move.l	(a1)+,(a0)
	lea	50(a0),a0
	dbf	d0,drawcharloop

scrollit:
	lea	$dff000,a5

	move.l	#scrollfield,d0
	move.w	#bltdptl,(a6)
	move.w	d0,2(a6)
	swap	d0
	move.w	#bltdpth,4(a6)
	move.w	d0,6(a6)

	swap	d0
	addq.l	#2,d0

	move.w	#bltaptl,8(a6)
	move.w	d0,10(a6)
	swap	d0
	move.w	#bltapth,12(a6)
	move.w	d0,14(a6)

	move.w	#bltafwm,16(a6)
	move.w	#-1,18(a6)
	move.w	#bltalwm,20(a6)
	move.w	#%1111111100000000,22(a6)

	move.w	#bltamod,24(a6)
	move.w	#0,26(a6)
	move.w	#bltdmod,28(a6)
	move.w	#0,30(a6)

	move.w	#bltcon0,32(a6)
	move.w	#%1011100111110000,34(a6)
	move.w	#bltcon1,36(a6)
	move.w	#%0000000000000000,38(a6)

	move.w	#bltsize,40(a6)
	move.w	#16*64+25,42(a6)
	move.l	#-2,44(a6)
noscroll:
	rts



scroller2:
;tst	scrolloff2
;beq.w	noscroll2

	subq.w	#1,scrollpoint2
	bne.b	scrollit2
	lea	offsettext,a0
	move.w	textpoint2,d0
	move.w	(a0,d0.w),d1
	bpl.b	notextrestart2
	moveq	#0,d0
	move.w	(a0,d0.w),d1

notextrestart2:
	addq.w	#2,d0
	move.w	d0,textpoint2
	lea	font,a1
	lea	0(a1,d1.w),a1
	move.w	#6,scrollpoint2
	lea	scrollplane+46,a0
	moveq	#15,d0
drawcharloop2:
	move.l	(a1)+,(a0)
	lea	50(a0),a0
	dbf	d0,drawcharloop2
scrollit2:
	lea	$dff000,a5
	jsr	bltwait
	move.l	#scrollplane,d0
	move.l	d0,BLTDPTH(A5)
	addq.l	#2,d0
	move.l	d0,BLTaPTH(A5)
	MOVE.l	#%11111111111111111111111100000000,bltafwm(a5)

	move.w	#0,BLTaMOD(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%10111001111100000000000000000000,BLTCON0(A5);0+1
	move.w	#17*64+25,BLTSIZE(A5)
noscroll2:
	rts

textcalc:
	lea	asciitext,a0
	lea	offsettext,a1
	move.w	#textend-asciitext-1,d0
textcalcloop:
	moveq	#0,d1
	move.b	(a0)+,d1
	moveq	#textcharsend-textchars-1,d2
	lea	textchars+(textcharsend-textchars),a2
asciicodeseek:
	cmp.b	-(a2),d1
	beq.b	gotcode
	dbf	d2,asciicodeseek

gotcode:
	lsl.w	#6,d2
	move.w	d2,(a1)+
	dbf	d0,textcalcloop
	move.w	#-1,(a1)
	rts

DRAW:
	lea	octants(pc),a2
	cmp.w	d1,d3
	bgt.b	drawl1
	exg	D0,D2
	exg	D1,D3
drawl1:	
	SUBQ.W	#1,D3
	SUB.W	D1,D3
	SUB.W	D0,D2
	bpl.b	.OK2
	NEG.W	D2
	ADDQ.L	#8,A2
.OK2:	CMP.W	D2,D3
	BLE.S	.OK3
	ADDQ.L	#4,A2
	EXG	D2,D3
.OK3:
	MOVE.L	(A2),D4
	ROR.L	#3,D0
	LEA	(A0,D0.W),A2
	ROR.L	#1,D0
	AND.L	#$F0000000,D0
	OR.L	D0,D4
	MOVE.W	D1,D0
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2
	LSL.W	#1,D3
	MOVE.W	D3,D0
	SUB.W	D2,D3
	BGE.S	.NOSIGN
	OR.B	#$40,D4
.NOSIGN:
	add.w	d0,d0
	MOVE.W		D0,D1		;d1=lodiff*4
	LSL.W		#2,D2		;d2=hidiff*4
	SUB.W		D2,D1		;d1=(lodiff*4) - (hidiff*4) 
	ADDQ.W		#4,D2		;d2=hidiff*4+4
	LSL.W		#4,D2		;d2=(hidiff*4+4)*16
	ADDQ.W		#2,D2		;d2=(hidiff*4+4)*16+2

	move.w	#bltaptl,(a6)
	move.w	d3,2(a6)
	move.l	a2,d3
	move.w	d3,6(a6)
	move.w	d3,10(a6)
	swap	d3
	move.w	d3,14(a6)
	move.w	d3,18(a6)

	move.w	d0,22(a6)
	move.w	d4,26(a6)
	swap	d4
	move.w	d4,30(a6)
	move.w	d1,34(a6)
	move.w	linemask,38(a6)

	move.w	d2,42(a6)

	lea	52(a6),a6
drawl2:
	RTS


starmove:
	lea	stars,a0
	move.w	#200,d2
	moveq	#9,d0
starmoveloop:
	move.w	(a0),d1
	addq.w	#5,d1
	cmp.w	d2,d1
	ble.b	nor1
	move.w	#-200,d1
nor1:
	move.w	d1,(a0)

	move.w	4(a0),d1
	addq.w	#7,d1
	cmp.w	d2,d1
	ble.b	nor2
	move.w	#-150,d1
nor2:
	move.w	d1,4(a0)

	move.w	8(a0),d1
	addq.w	#3,d1
	cmp.w	d2,d1
	ble.b	nor3
	move.w	#-150,d1
nor3:
	move.w	d1,8(a0)
	lea	12(a0),a0
	dbf	d0,starmoveloop
rts

corrector:
	move.w	turnz,d0
	lsr.w	#1,d0
	lea	corrsin(pc),a0
	move.w	#-200,d2
	sub.w	(a0,d0.w),d2
	moveq	#15,d1
	lea	scrolldatas(pc),a0
corrloop:
	addq.l	#8,a0
	dbf	d1,corrloop
	rts

animator:
	lea	scrolldatas+2(pc),a0
	move.l	scrolldataso,a1

	moveq	#31,d0
animloop:
	move.w	(a0),d1
	move.w	(a1)+,d2
	sub.w	d1,d2
	beq.b	animated
	bpl.b	animadd
	subq.w	#1,(a0)
	bra.b	animated
animadd:
	addq.w	#1,(a0)

animated:
	addq.l	#4,a0
	dbf	d0,animloop
	rts

coppercopy:
	move.l	worklist,a0
	move.l	clearplane,d0
	addq.l	#6,d0

	move.w	#bltdptl,(a0)
	move.w	d0,2(a0)
	swap	d0
	move.w	d0,6(a0)
	rts

copperinit:
	move.l	worklist,a0
;planecls----------------------------
	move.l	clearplane,d0
	addq.l	#6,d0

	move.w	#bltdptl,(a0)
	move.w	d0,2(a0)
	swap	d0
	move.w	#bltdpth,4(a0)
	move.w	d0,6(a0)

	move.w	#bltdmod,8(a0)
	move.w	#$14,10(a0)

	move.w	#bltcon0,12(a0)
	move.w	#%0000000100000000,14(a0)
	move.w	#bltcon1,16(a0)
	move.w	#0,18(a0)

	move.w	#bltsize,20(a0)
	move.w	#276*64+22,22(a0)
;----------------------------
	move.w	#$01b0,24(a0)
	move.w	#$0000,26(a0)
	move.w	#$2001,28(a0)
	move.w	#$7ffe,30(a0)

	move.w	#bltafwm,32(a0)
	move.w	#$ffff,34(a0)
	move.w	#bltalwm,36(a0)
	move.w	#$ffff,38(a0)

	move.w	#bltcmod,40(a0)
	move.w	#64,42(a0)
	move.w	#bltdmod,44(a0)
	move.w	#64,46(a0)

	move.w	#bltbdat,48(a0)
	move.w	#0,50(a0)
	move.w	#bltadat,52(a0)
	move.w	#$8000,54(a0)

	lea	56(a0),a6
	moveq	#15,d5
copperinitloop1:
;----------------------------------------------
	move.w	#bltaptl,(a6)
	move.w	#0,2(a6)
	move.w	#bltcptl,4(a6)
	move.w	#0,6(a6)
	move.w	#bltdptl,8(a6)
	move.w	#0,10(a6)
	move.w	#bltcpth,12(a6)
	move.w	#0,14(a6)
	move.w	#bltdpth,16(a6)
	move.w	#0,18(a6)

	move.w	#bltbmod,20(a6)
	move.w	#0,22(a6)
	move.w	#bltcon1,24(a6)
	move.w	#0,26(a6)
	move.w	#bltcon0,28(a6)
	move.w	#0,30(a6)
	move.w	#bltamod,32(a6)
	move.w	#0,34(a6)

	moveq	#22,d6
	lea	36(a6),a6
copperinitloop2:
	move.w	#bltbdat,(a6)
	move.w	#0,2(a6)
	move.w	#bltsize,4(a6)
	move.w	#$402,6(a6)

	move.w	#$01b0,8(a6)
	move.w	#0,10(a6)
	move.w	#$0001,12(a6)
	move.w	#$7ffe,14(a6)

	lea	16(a6),a6
	dbf	d6,copperinitloop2
	dbf	d5,copperinitloop1
;----------------------
	moveq	#24+4,d6
logoloop:
	move.w	#bltaptl,(a6)
	move.w	#0,2(a6)
	move.w	#bltcptl,4(a6)
	move.w	#0,6(a6)
	move.w	#bltdptl,8(a6)
	move.w	#0,10(a6)
	move.w	#bltcpth,12(a6)
	move.w	#0,14(a6)
	move.w	#bltdpth,16(a6)
	move.w	#0,18(a6)

	move.w	#bltbmod,20(a6)
	move.w	#0,22(a6)
	move.w	#bltcon1,24(a6)
	move.w	#0,26(a6)
	move.w	#bltcon0,28(a6)
	move.w	#0,30(a6)
	move.w	#bltamod,32(a6)
	move.w	#0,34(a6)
	move.w	#bltbdat,36(a6)
	move.w	#0,38(a6)

	move.w	#bltsize,40(a6)
	move.w	#0,42(a6)

	move.w	#$01b0,44(a6)
	move.w	#0,46(a6)
	move.w	#$0001,48(a6)
	move.w	#$7ffe,50(a6)
	lea	52(a6),a6
	dbf	d6,logoloop
	move.l	#-2,(a6)
	RTS
;----------------------------------------------
turner2:	;last optimizing:92-08-26
	move.w	turny2,a2
	add.w	turnaddy2,a2
	cmp.w	#1436,a2
	ble.b nolaufy2
	sub.w	#1440,a2
nolaufy2:
	move.w	a2,turny2

	move.w	turnz2,a0
	add.w	turnaddz2,a0
	cmp.w	#1436,a0
	ble.b nolaufz2
	sub.w	#1440,a0
nolaufz2:
	move.w	a0,turnz2

turner12:
	lea	linekoords0end,a4
	lea	linekoords2,a3
	lea	d3sinus,a6
	move.w	linepoints2,d0
	lsl.w	#3,d0
turnrout12:
	move.l	0(a6,a2.w),d5
	move.w	2(a3,d0.w),d3
	move.w	6(a3,d0.w),d4
	move.w	d3,d6
	move.w	d4,d7
	muls.w	d5,d3
	muls.w	d5,d7
	swap	d5
	muls.w	d5,d4
	muls.w	d5,d6
	add.l	d4,d3
	swap	d3
	rol.l	#1,d3
	sub.l	d7,d6
	swap	d6
	rol.l	#1,d6
	move.w	4(a3,d0.w),d6
	sub.w	#100,d6
	move.w	d6,-(a4)
	move.w	d3,-(a4)
	subq.w	#8,d0
	bpl.b	turnrout12
	rts
;*****

intmark:	dc.w	0
backphase:	dc.w	0
showplane:	dc.l	0
clearplane:	dc.l	0
pointplane:	dc.l	0
workdat:	dc.l	0
cleardat:	dc.l	0
linemask:	dc.w	$ffff
dircommand:	dc.w	0
sinscrolloff:	dc.w	0
escape:		dc.w	0
oldint:		dc.l	0
switchdatmark:	dc.l	0
switchmark:	dc.l	-1

OCTANTS:;        01234567012345670123456701234567	
	DC.L	%00001011110010101111000000010001	;7
	DC.L	%00001011110010101111000000000001	;6
	DC.L	%00001011110010101111000000010101	;4
	DC.L	%00001011110010101111000000001001	;5

	DC.L	%00001011110010101111000000011001	;0
	DC.L	%00001011110010101111000000000101	;1
	DC.L	%00001011110010101111000000011101	;3
	DC.L	%00001011110010101111000000001101	;2

turnaddz:	dc.w	0*4
turnaddx:	dc.w	0*4
comsleep:	dc.w	1
compoint:	dc.w	0
commands:
	dc.w	20,450	;logoplasma on, but all black, except scroll
	dc.w	22,300	;fade logo
	dc.w	23,700	;fade cubes
	dc.w	26,100
	dc.w	24,61100	;3d sin scroll
	dc.w	25,1	;3d sin scroll end code
	dc.w	21,1
	dc.w	5,560	;scroll on
;	dc.w	4,100	;scroll off	abyss

;	dc.w	5,398	;scroll on
;	dc.w	4,1	;scroll off
;	dc.w	10,45	;linedat left small, right big
;	dc.w	11,90	;linedat left big, right small
;	dc.w	10,90	;linedat left small, right big
	dc.w	8,1	;linedat normal

;	dc.w	5,260	;scroll on
;	dc.w	4,100	;scroll off
;	dc.w	5,144	;scroll on
;	dc.w	4,80	;scroll off

	dc.w	2,90	;turn left
	dc.w	3,450	;turn off

;	dc.w	5,300	;scroll on
	dc.w	1,135	;turn right
	dc.w	3,450	;turn off

	dc.w	2,90	;turn left
	dc.w	3,500	;turn off
	dc.w	1,225	;turn right
	dc.w	3,1	;turn off

	dc.w	10,300	;linedat left small, right big
	dc.w	2,180	;turn left
	dc.w	3,1	;turn off
;	dc.w	8,1	;linedat normal

	dc.w	9,300	;linedat turned
	dc.w	8,1	;linedat normal
	dc.w	2,180	;turn left
	dc.w	3,100	;turn off
dc.w	13,214

	dc.w	2,360+200	;turn left
	dc.w	3,1	;turn off
	dc.w	10,400	;linedat left big, right small
	dc.w	2,360	;turn left
	dc.w	3,1	;turn off

	dc.w	8,100	;linedat normal

	dc.w	1,90	;turn right
	dc.w	2,69	;turn left
dc.w	14,1

	dc.w	3,1	;turn off
	dc.w	12,150	;linedat
	dc.w	8,1	;linedat normal
	dc.w	1,120	;turn right
	dc.w	10,1	;linedat left big, right small
	dc.w	1,239	;turn right
	dc.w	3,100	;turn off
	dc.w	8,100	;linedat normal
	dc.w	2,360	;turn left
	dc.w	10,135	;linedat left big, right small
	dc.w	3,1	;turn off
	dc.w	8,225	;linedat normal
	dc.w	1,1	;turn right
	dc.w	13,270
	dc.w	9,270	;linedat turned
	dc.w	10,270	;linedat left big, right small
	dc.w	8,270	;linedat normal
	dc.w	2,1	;turn left
	dc.w	9,270	;linedat turned
	dc.w	10,270	;linedat left big, right small
	dc.w	8,270	;linedat normal

	dc.w	3,1	;turn off
	dc.w	12,150	;linedat
	dc.w	8,1	;linedat normal
	dc.w	1,120	;turn right
	dc.w	10,1	;linedat left big, right small
	dc.w	1,239	;turn right
	dc.w	3,100	;turn off
	dc.w	8,100	;linedat normal
	dc.w	2,360	;turn left
	dc.w	10,135	;linedat left big, right small
	dc.w	3,1	;turn off
	dc.w	8,225	;linedat normal
	dc.w	1,1	;turn right
	dc.w	13,270
	dc.w	9,270	;linedat turned
	dc.w	10,270	;linedat left big, right small
	dc.w	8,270	;linedat normal
	dc.w	2,1	;turn left
	dc.w	9,270	;linedat turned
	dc.w	10,270	;linedat left big, right small
	dc.w	8,270	;linedat normal

	dc.w	3,1	;turn off
	dc.w	12,150	;linedat
	dc.w	8,1	;linedat normal
	dc.w	1,120	;turn right
	dc.w	10,1	;linedat left big, right small
	dc.w	1,239	;turn right
	dc.w	3,100	;turn off
	dc.w	8,100	;linedat normal
	dc.w	2,360	;turn left
	dc.w	10,135	;linedat left big, right small
	dc.w	3,1	;turn off
	dc.w	8,225	;linedat normal
	dc.w	1,1	;turn right
	dc.w	13,270
;	dc.w	9,270	;linedat turned
;	dc.w	10,270	;linedat left big, right small
;	dc.w	8,270	;linedat normal
;	dc.w	2,1	;turn left
;	dc.w	9,270	;linedat turned
;	dc.w	10,270	;linedat left big, right small

	dc.w	8,60270	;linedat normal



	dc.w	100,100	;restart commandosequence

scrolloff:	dc.w	1
scrollpoint:	dc.w	1
textpoint:	dc.w	0
scrollpoint2:	dc.w	1
textpoint2:	dc.w	0
scrolldataso:	dc.l	scrolldatas1
grname:	dc.b	"graphics.library",0
even
turny2:	dc.w	8
turnz2:	dc.w	8
turnaddy2:	dc.w	2*4
turnaddz2:	dc.w	3*4


turn4x:	dc.w	0
turny:	dc.w	0
turnz:	dc.w	0

intwait:	dc.w	0

corrSin:
dc.w	0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20
dc.w	22,23,25,28,30,32,35,38,41,44,47,50,53,57,61,65,69,73,78

dc.w	78,73,69,65,61,57,53,50,47,44,41,38,35,32,30,28,25,23,22
dc.w	20,18,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0,0


dc.w	0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20
dc.w	22,23,25,28,30,32,35,38,41,44,47,50,53,57,61,65,69,73,78

dc.w	78,73,69,65,61,57,53,50,47,44,41,38,35,32,30,28,25,23,22
dc.w	20,18,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0,0


dc.w	0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20
dc.w	22,23,25,28,30,32,35,38,41,44,47,50,53,57,61,65,69,73,78

dc.w	78,73,69,65,61,57,53,50,47,44,41,38,35,32,30,28,25,23,22
dc.w	20,18,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0,0


dc.w	0,0,0,0,0,1,1,1,2,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20
dc.w	22,23,25,28,30,32,35,38,41,44,47,50,53,57,61,65,69,73,78

dc.w	78,73,69,65,61,57,53,50,47,44,41,38,35,32,30,28,25,23,22
dc.w	20,18,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0,0




corrend:

font:
incbin "data/curiousfont1_con"

textchars:
	dc.b	" ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,-:!?."
textcharsend:

asciitext:
dc.b	"  WELCOME TO CURIOUS, A 40 KB INTRO RELEASED ON THE 9TH MAY "
DC.B	"IN THE YEAR OF ABYSS 1993"


DC.B	"                        "
DC.B	"THE CREDITS: 19K ORCHESTRA DIRECTED BY:  NEURODANCER     "
DC.B	"PIXEL SUPERVISING BY:  ARTLINE     ALL OTHER BITS AND BYTES "
DC.B	"MIXED BY:  MOON                                  "  
asciitext2:
dc.b	"    DERFS ABYSSERL MEHR SEIN ????? "
dc.b	"            CONTACT ABYSS FOR ELITE SWAPPING:                            "
dc.b	"SKINDIVER OF ABYSS - PFARRER-ZILLERSTR. 15   W-8051 KRANZBERG"
dc.b	"                                      "
dc.b	"THE DUKE OF ABYSS  - FRITZ-BENDERSTR. 9   W-8051 KRANZBERG"
dc.b	"                                "
dc.b	"TOXIC OF ABYSS - SVEN DEDEK   GRUENWALDSTR. 6   W-8260 MUEHLDORF"
dc.b	"                  "
DC.B	", THATS ALL IN GERMANY, EXCEPT "
DC.B	"MOON OF ABYSS - PO.BOX 162  A-5400 HALLEIN, THATS IN AUSTRIA. "


DC.B	"ABYSS SENDS GREETINGS TO THE FOLLOWING CREWS:  "
DC.B	'ACRID -- '
DC.B	'ADDONIC -- '
DC.B	'AGNOSTIC FRONT -- '
dc.b	'ALCATRAZ -- '
DC.B	'ANALOG -- '
dc.b	"ARISE -- "
DC.B	'ATOMIC -- '
DC.B	'BALANCE -- '
dc.b	'BRONX -- '
DC.B	'CRYPTOBURNERS -- '
dc.b	'CENTURA -- '
DC.B	'DIFFUSION -- '
DC.B	'DUAL CREW -- '
dc.b	'EFFECT -- '
dc.b	'ELYSION -- '
DC.B	'EQUINOX -- '
DC.B	'ESSENCE -- '
dc.b	'HEADWAY -- '
dc.b	'IMPULSE -- '
dc.b	'INFECT -- '
dc.b	'INTERACTIVE -- '
dc.b	'IRIS -- '
dc.b	'JETSET -- '
dc.b	'KEFRENS -- '
dc.b	'LASER DANCE -- '
DC.B	'LEGEND -- '
DC.B	'LSD -- '
dc.b	'MANITOU -- '
DC.B	'MIDWAY -- '
dc.b	'NOXIOUS -- '
DC.B	'NUANCE -- '
dc.b	'ORIENT -- '
dc.b	'PARASITE -- '
DC.B	'PLATIN -- '
dc.b	'PRINCIPES -- '
DC.B    'RAZOR 1911 -- '
DC.B	'SANITY -- '
DC.B	'SCEPTIC -- '
dc.b	'SCOOPEX -- '
dc.b	'SILENTS -- '
dc.b	'SKANDAL -- '
dc.b	'TEK -- '
dc.b	'THE DARK DEMON -- '
DC.B	'THE FACE INC. -- '
DC.B	'THE MOVEMENT -- '
dc.b	'THE SPECIAL BROTHERS -- '
dc.b	'THE SYNDICATE -- '
dc.b	'TRANCE -- '
dc.b	'TRSI -- '
dc.b	'X-TRADE -- '
dc.b	'WIZARDS - '
dc.b	'ZENITH -- '
dc.b	'ZITE -- '
dc.b	'             '
dc.b	'EIN GRUSS AN... TO PUT THIS SOURCECODE ON GITHUB, A PART OF THIS SCROLLTEXTS HAD TO BE CENSORED...     '
DC.B	"              "
dc.b	"HELLO GUYS, NOW MOON HERE! I SEND GREETINGS TO:  NUKE-MANITOU, DONT 4GET "
DC.B	"OUR PROJECT!     ZINKFLOID-ENERGY, THANX FOR YOUR OFFER TO JOIN "
DC.B	"ENERGY, BUT I FEEL FINE IN ABYSS!      "
DC.B	"RIP-MANITOU, I NEVER THOUGHT "
DC.B	"YOU CAN CODE A TRACKMO IN THREE DAYS, BUT YOU MANAGED IT!!      "
DC.B	"ICE CUBE-MANITOU, KEEP ON WORKING, I LIKE YOUR STYLE!       "
DC.B	"DUKE-MANITOU, I THINK, YOU WILL NEVER BREAK YOUR WALL..."
dc.b	"                   "

textend:

even
offsettext:
blk.w	asciitext2-asciitext,0
offsettext2:
blk.w	textend-asciitext2+2,0


ls=-200
le=200
scrolldatas:
dc.w	ls,-14,le,-14
dc.w	ls,-12,le,-12
dc.w	ls,-10,le,-10
dc.w	ls,-8,le,-8
dc.w	ls,-6,le,-6
dc.w	ls,-4,le,-4
dc.w	ls,-2,le,-2
dc.w	ls,0,le,0
dc.w	ls,2,le,2
dc.w	ls,4,le,4
dc.w	ls,6,le,6
dc.w	ls,8,le,8
dc.w	ls,10,le,10
dc.w	ls,12,le,12
dc.w	ls,14,le,14
dc.w	ls,16,le,16

;dc.w	ls,18,le,18 

dc.w	-180,-71,180,-71
;dc.w	-180,129,180,129
dc.w	-180,125,180,125



stars:
dc.w  119,-99+29
dc.w  62,-92+29
dc.w  33,-85+29
dc.w  165,-78+29
dc.w  179,-71+29
dc.w  109,-64+29
dc.w -69,-57+29
dc.w  72,-50+29
dc.w  90,-43+29
dc.w  137,-36+29
dc.w -139,-29+29
dc.w  6,-22+29
dc.w -11,-15+29
dc.w -145,-8+29
dc.w -8,-1+29
dc.w  157, 6+29
dc.w -94, 13+29
dc.w -148, 20+29
dc.w -105, 27+29
dc.w  90, 34+29
dc.w  160, 41+29
dc.w -181, 48+29
dc.w  13, 55+29
dc.w -76, 62+29
dc.w  160, 69+29
dc.w  190, 76+29
dc.w -50, 83+29
dc.w -112, 90+29
dc.w -189, 97+29
dc.w -148, 18+29

linekoords0:
dc.w -45,-27-100
dc.w -27,-23-100
dc.w  6,-20-100
dc.w  43,-15-100
dc.w -27,-13-100
dc.w  78,-11-100
dc.w -27,-9-100
dc.w -73,-8-100
dc.w -9,-5-100
dc.w -36, 0-100
dc.w  9, 0-100
dc.w  28, 0-100
dc.w  42, 3-100
dc.w  61, 3-100
dc.w  44, 5-100
dc.w  62, 5-100
dc.w  78, 7-100
dc.w  96, 7-100
dc.w -27, 9-100
dc.w -97, 16-100
dc.w -49, 16-100
dc.w  27, 18-100
dc.w  6, 20-100
dc.w  62, 23-100
dc.w -45, 27-100
linekoords0end:


dc.w	0,0,0,0,0



scrolldatas1:
dc.w	14,15
dc.w	16,17
dc.w	18,19
dc.w	20,21
dc.w	22,23
dc.w	24,25
dc.w	26,27
dc.w	28,29
dc.w	30,31
dc.w	32,33
dc.w	34,35
dc.w	36,37
dc.w	38,39
dc.w	40,41
dc.w	42,43
dc.w	44,45

scrolldatas2:
dc.w	-2,58
dc.w	2,54
dc.w	6,50
dc.w	10,46
dc.w	14,42
dc.w	18,38
dc.w	22,34
dc.w	26,30
dc.w	30,26
dc.w	34,22
dc.w	38,18
dc.w	42,14
dc.w	46,10
dc.w	50,6
dc.w	54,2
dc.w	58,-2

scrolldatas3:
dc.w	22,-16
dc.w	23,-10
dc.w	24,-4
dc.w	25,2
dc.w	26,8
dc.w	27,14
dc.w	28,20
dc.w	29,26
dc.w	30,32
dc.w	31,38
dc.w	32,44
dc.w	33,50
dc.w	34,56
dc.w	35,62
dc.w	36,68
dc.w	37,74

scrolldatas4:
dc.w	44,74
dc.w	42,68
dc.w	40,62
dc.w	38,56
dc.w	36,50
dc.w	34,44
dc.w	32,38
dc.w	30,32
dc.w	28,26
dc.w	26,20
dc.w	24,14
dc.w	22,8
dc.w	20,2
dc.w	18,-4
dc.w	16,-10
dc.w	14,-16


scrolldatas5:
dc.w	46,-40
dc.w	44,-30
dc.w	42,-20
dc.w	40,-10
dc.w	38,00
dc.w	36,10
dc.w	34,20
dc.w	32,30
dc.w	30,40
dc.w	28,50
dc.w	26,60
dc.w	24,70
dc.w	22,80
dc.w	20,90
dc.w	18,100
dc.w	16,110

showlist:	dc.l	0
worklist:	dc.l	0

linepoints2: dc.w  24
linequant2: dc.w  24*4
linekoords2:
dc.w 0,-45,-27,0
dc.w 0,-27,-23,0
dc.w 0, 6,-20,0
dc.w 0, 43,-15,0
dc.w 0,-27,-13,0
dc.w 0, 78,-11,0
dc.w 0,-27,-9,0
dc.w 0,-73,-8,0
dc.w 0,-9,-5,0
dc.w 0,-36, 0,0
dc.w 0, 9, 0,0
dc.w 0, 28, 0,0
dc.w 0, 42, 3,0
dc.w 0, 61, 3,0
dc.w 0, 44, 5,0
dc.w 0, 62, 5,0
dc.w 0, 78, 7,0
dc.w 0, 96, 7,0
dc.w 0,-27, 9,0
dc.w 0,-97, 16,0
dc.w 0,-49, 16,0
dc.w 0, 27, 18,0
dc.w 0, 6, 20,0
dc.w 0, 62, 23,0
dc.w 0,-45, 27,0
lines2:
dc.w  0, 24
dc.w  0, 6
dc.w  1, 4
dc.w  1, 8
dc.w  2, 22
dc.w  2, 8
dc.w  3, 13
dc.w  3, 11
dc.w  4, 22
dc.w  5, 17
dc.w  5, 15
dc.w  6, 9
dc.w  7, 20
dc.w  7, 19
dc.w  9, 18
dc.w  10, 21
dc.w  10, 11
dc.w  12, 13
dc.w  12, 21
dc.w  14, 23
dc.w  14, 15
dc.w  16, 17
dc.w  16, 23
dc.w  18, 24
dc.w  19, 20


introut2:
	btst.b	#5,$dff01f
	beq.w	intback2
	movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a5
	move.w	#%0110011000000000,bplcon0(a5)
	jsr	switchplanes2

	lea	logo,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl5pth(a5)

	move.l	showplane2,d0

	lea	cubesin,a1
	move.w	cubesinpointx,d1
	addq.w	#4,d1
	cmp.w	#1440,d1
	bne.b	nocubsinxres
	moveq	#0,d1

nocubsinxres:
	move.w	d1,cubesinpointx
	move.w	(a1,d1.w),planeposx

	move.w	cubesinpointy,d1
	addq.w	#2,d1
	cmp.w	#1440,d1
	bne.b	nocubsinyres
	moveq	#0,d1

nocubsinyres:
	move.w	d1,cubesinpointy
	move.w	(a1,d1.w),planeposy

	moveq	#0,d2
	move.w	planeposx,d1
	move.w	d1,d2
	not.b	d1
	and.w	#$f,d1
	lsl.w	#4,d1
	move.w	d1,bplcon1(a5)
	lsr.w	#4,d2
	and.w	#$1,d2
	add.w	d2,d2
	add.l	d2,d0

	moveq	#0,d1
	move.w	planeposy,d1
	and.w	#$1f,d1
	lsl.w	#6,d1
	add.l	d1,d0
	add.w	d1,d1
	add.l	d1,d0


	move.l	d0,bpl2pth(a5)
	add.l	#64,d0
	move.l	d0,bpl4pth(a5)
	add.l	#64,d0
	move.l	d0,bpl6pth(a5)
;-------------------------------------------------------------------

	lea	faded,a0
	lea	$dff180,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0),(a1)

	jsr	colput
	jsr	scroller2
	jsr	copycube1
	jsr	coppercopy2
	jsr	realfade
	jsr	copycube2
	jsr	pr_music
	jsr	commander
;-------------------------------------------------------------------
movem.l	(a7)+,d0-d7/a0-a6
intback2:
	move.w	#%0000000001100000,$dff09c
	rte

coppercopy1:
	lea	copperlist,a0
	move.w	#$4900,d2

	move.w	#163,d1
coppercopy1l1:
	move.b	#$47,d2
	move.w	d2,(a0)+
	move.w	#-2,(a0)+
	add.w	#$0100,d2
	move.w	#bpl2mod,(a0)+
	move.w	#24+64+64-2,(a0)+

	moveq	#15,d0
coppercopy1l2:
	move.l	#$01040fff,(a0)+

	dbf	d0,coppercopy1l2
	dbf	d1,coppercopy1l1
	move.l	#$ffe1fffe,(a0)+
	move.l	#$0901fffe,(a0)+
	move.l	#$01000000,(a0)+

	move.w	#bpl1mod,(a0)+
	move.w	#8,(a0)+
	move.l	#$01820555,(a0)+	;borderscrollcolour

	move.l	#$1301fffe,(a0)+

	move.w	#$0100,(a0)+
	move.w	#%0001001000000000,(a0)+

	move.l	#scrollplane,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	move.w	#bpl1pth,(a0)+
	swap	d0
	move.w	d0,(a0)+

	move.l	#$2301fffe,(a0)+
	move.l	#$01000000,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#24+64+64-2,(a0)+
	move.w	#$0182,(a0)+
	move.w	logocol2,(a0)+
	move.l	#-2,(a0)
	rts

coppercopy3:
	lea	copperlist+6,a0
	moveq	#4,d1
coppercopy3l1:
	moveq	#29,d2
coppercopy3l2:
	move.w	#(24+64+64-2),(a0)
	lea	16*4+8(a0),a0
	dbf	d2,coppercopy3l2
	move.w	#(24+64+64-2)-(192*31),(a0)
	lea	16*4+8(a0),a0
	dbf	d1,coppercopy3l1
	rts

colput:
	lea	$dff000,a5
	moveq	#15,d0
	lea	copperlist+6+4,a4
	lea	sinuss(pc),a1

	move.w	sinuscounta,d3
	add.w	#720-6,d3
	cmp.w	#720,d3
	ble.b	nosinrestarta
	sub.w	#720,d3
nosinrestarta:
	move.w	d3,sinuscounta

	move.w	sinuscountb,d4
	addq.w	#4,d4
	cmp.w	#720,d4
	ble.b	nosinrestartb
	sub.w	#720,d4
nosinrestartb:
	move.w	d4,sinuscountb

	move.w	sinuscountc,d5
	addq.w	#6,d5
	cmp.w	#720,d5
	ble.b	nosinrestartc
	sub.w	#720,d5
nosinrestartc:
	move.w	d5,sinuscountc

	jsr	bltwait

	moveq	#0,d2
	move.w	d2,bltamod(a5)
	move.w	d2,bltbmod(a5)
	move.w	d2,bltcmod(a5)
	move.w	#16*4+6,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#%0000111110000000,bltcon0(a5)
	move.w	d2,bltcon1(a5)
	pea	colour3(pc)
	pea	colour2(pc)
	pea	colour1(pc)
colputl1:
	movem.l	(a7),a0/a2/a3
	move.w	0(a1,d3.w),d2
	lea	(a2,d2.w),a2
	move.w	0(a1,d4.w),d2
	lea	(a3,d2.w),a3
	move.w	0(a1,d5.w),d2
	lea	(a0,d2.w),a0
	add.w	#16,d3
	add.w	#24,d4
	add.w	#30,d5

	jsr	bltwait

	movem.l	a0/a2/a3/a4,bltcpth(a5);	/c/b/a/dpth
	move.w	#64*164+1,bltsize(a5)
	addq.l	#4,a4
	dbf	d0,colputl1
	lea	12(a7),a7
	rts

bltwait:	
	btst	#14,dmaconr(a5)
	bne.b	bltwait
	rts

sin2pos:	dc.w	0
animfin:	dc.w	0
planeposx:	dc.w	0
planeposy:	dc.w	0
cubesinpointx:	dc.w	0
cubesinpointy:	dc.w	360

coppercopy2:
	move.w	sin2pos,d0
	add.w	#12,d0
	cmp.w	#192,d0
	ble.b	nosin2restart
	sub.w	#192,d0
nosin2restart:
	move.w	d0,sin2pos

	lea	copperlist,a0
	lea	sinus2(pc),a1
	lea	(a1,d0.w),a1

	move.w	#99+64,d1
coppercopy2l1:
	moveq	#$3f,d2
	add.w	(a1)+,d2
	move.b	d2,1(a0)
	lea	16*4+8(a0),a0
	dbf	d1,coppercopy2l1
	rts

colour1:
blk.w	76+64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
blk.w	120/2,64

colour2:
blk.w	76+64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
blk.w	120/2,64

colour3:
blk.w	76+64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
blk.w	120/2,64

sinuss:
dc.w  202, 206, 210, 212, 216, 220, 224, 226, 230, 234, 238, 240, 244, 248
dc.w  250, 254, 258, 260, 264, 268, 270, 274, 278, 280, 284, 286, 290, 292
dc.w  296, 298, 302, 304, 308, 310, 314, 316, 320, 322, 324, 328, 330, 332
dc.w  336, 338, 340, 342, 346, 348, 350, 352, 354, 356, 358, 360, 362, 364
dc.w  366, 368, 370, 372, 374, 376, 378, 378, 380, 382, 384, 384, 386, 386
dc.w  388, 390, 390, 392, 392, 394, 394, 394, 396, 396, 396, 398, 398, 398
dc.w  398, 398, 398, 398, 398, 400, 398, 398, 398, 398, 398, 398, 398, 398
dc.w  396, 396, 396, 394, 394, 394, 392, 392, 390, 390, 388, 386, 386, 384
dc.w  384, 382, 380, 378, 378, 376, 374, 372, 370, 368, 366, 364, 362, 360
dc.w  358, 356, 354, 352, 350, 348, 346, 342, 340, 338, 336, 332, 330, 328
dc.w  324, 322, 320, 316, 314, 310, 308, 304, 302, 300, 296, 292, 290, 286
dc.w  284, 280, 278, 274, 270, 268, 264, 260, 258, 254, 250, 248, 244, 240
dc.w  238, 234, 230, 226, 224, 220, 216, 212, 210, 206, 202, 200, 198, 194
dc.w  190, 188, 184, 180, 176, 174, 170, 166, 162, 160, 156, 152, 150, 146
dc.w  142, 140, 136, 132, 130, 126, 122, 120, 116, 114, 110, 108, 104, 102
dc.w  98, 96, 92, 90, 86, 84, 80, 78, 76, 72, 70, 68, 64, 62, 60, 58, 54
dc.w  52, 50, 48, 46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22, 22
dc.w  20, 18, 16, 16, 14, 14, 12, 10, 10, 8, 8, 6, 6, 6, 4, 4, 4, 2, 2
dc.w  2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 6, 6, 6, 8
dc.w  8, 10, 10, 12, 14, 14, 16, 16, 18, 20, 22, 22, 24, 26, 28, 30, 32
dc.w  34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 58, 60, 62, 64, 68, 70
dc.w  72, 76, 78, 80, 84, 86, 90, 92, 96, 98, 100, 104, 108, 110, 114, 116
dc.w  120, 122, 126, 130, 132, 136, 140, 142, 146, 150, 152, 156, 160, 162
dc.w  166, 170, 174, 176, 180, 184, 188, 190, 194, 198, 200

dcb.w	360,0

sinus2:
dc.w  0, 0, 0, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 6, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0,-2,-2,-2,-4,-4
dc.w -4,-4,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -2,-2,-2, 0, 0, 0
dc.w  0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,-2,-2,-2,-2,-2,-2,-2,-2
dc.w  0, 0

dc.w  0, 0, 0, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 6, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0,-2,-2,-2,-4,-4
dc.w -4,-4,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -2,-2,-2, 0, 0, 0
dc.w  0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,-2,-2,-2,-2,-2,-2,-2,-2
dc.w  0, 0

dc.w  0, 0, 0, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 6, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0,-2,-2,-2,-4,-4
dc.w -4,-4,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -2,-2,-2, 0, 0, 0
dc.w  0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,-2,-2,-2,-2,-2,-2,-2,-2
dc.w  0, 0

dc.w  0, 0, 0, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 6, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0, 0, 0, 0, 0,-2,-2,-2,-4,-4
dc.w -4,-4,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -2,-2,-2, 0, 0, 0
dc.w  0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,-2,-2,-2,-2,-2,-2,-2,-2
dc.w  0, 0

sinuscounta:	dc.w	0
sinuscountb:	dc.w	240
sinuscountc:	dc.w	480

coppercopy4:
	lea	maincopperlist,a0
	move.l	#$2a01fffe,d1

	moveq	#0,d0
coppercopy4l1:
	moveq	#29,d2
coppercopy4l2:
	move.l	d1,(a0)+
	add.l	#$01000000,d1
	move.w	#bpl2mod,(a0)+
	move.w	#24+64+64-2,(a0)+
	dbf	d2,coppercopy4l2

	move.l	d1,(a0)+
	add.l	#$01000000,d1
	move.w	#bpl2mod,(a0)+
	move.w	#(24+64+64-2)-(192*31),(a0)+
	dbf	d0,coppercopy4l1
	rts

nocopperlist:	dc.l	-2

maincopperlist:
	blk.l	1*31*2,-2
copperlist:
	dc.l	$700ffffe
	dc.l	$0180000f
	dc.l	$f00ffffe
	dc.l	$01800000
	dc.l	$fffffffe
	blk.b	12000,0

logocol:
dc.w	$0180,$0	;$0455=originalbackground
dc.w	$0182
logocol2:	;to reech second logocol in coppercopy1
dc.w	$09be,$0184,$08ad,$0186,$069c
dc.w	$0188,$058a,$018a,$068b,$018c,$08bd,$018e,$06ac

logo:
incbin	"data/curious_abyss_con"

waitblank:	dc.w	0
waitblankrout:
	btst.b	#5,$01e+1+$dff000
	beq.b	nowaitblankvbi
	tst.w	animfin
	beq.b	nowaitblankvbi
	move.w	#1,waitblank
	move.l	#introut2,$6c
nowaitblankvbi:
	move.w	#%0000000001110000,$dff09c
	rte

emptyintrout:
	btst.b	#5,$01e+1+$dff000
	beq.w	emptyintnovbi
emptyintnovbi:
	move.w	#%0000000001110000,$09c+$dff000
	rte

musicintrout:
	btst.b	#5,$01e+1+$dff000
	beq.b	musicintnovbi
	movem.l	d0-a6,-(a7)
	jsr	pr_music
	jsr	commander
	movem.l	(a7)+,d0-a6

musicintnovbi:
	move.w	#%0000000001110000,$09c+$dff000
	rte

switchmark2:	dc.l	-1

switchplanes2:
	tst.w	switchmark2
	beq.b	do22
	bpl.b	do23
do21:
	addq.w	#1,switchmark2	;=0
	move.l	#plane21,clearplane2
	move.l	#plane22,showplane2
	move.l	#plane23,pointplane2
	rts
do22:
	addq.w	#1,switchmark2	;=1
	move.l	#plane21,pointplane2
	move.l	#plane22,clearplane2
	move.l	#plane23,showplane2
	rts
do23:
	subq.w	#2,switchmark2	;=-1
	move.l	#plane21,showplane2
	move.l	#plane22,pointplane2
	move.l	#plane23,clearplane2
	rts
;--------

showplane2:	dc.l	0
clearplane2:	dc.l	0
pointplane2:	dc.l	0

turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnadd2x:	dc.w	0
turnadd2y:	dc.w	0
turnadd2z:	dc.w	0

animpoint:	dc.l	animpics

copycube1:
	move.l	pointplane2,a3
	move.l	animpoint,a0
	lea	32*3*4(a0),a0
	lea	animpicsend,a1
	cmp.l	a0,a1
	bne.b	noanimrestart
	lea	animpics,a0
noanimrestart:
	move.l	a0,animpoint
	move.l	a3,a1
	lea	4(a1),a2
	moveq	#95,d0
copycube1l1:
	move.l	(a0),(a1)
	move.l	(a0)+,(a2)
	lea	64(a1),a1
	lea	64(a2),a2
	dbf	d0,copycube1l1

	lea	8(a3),a1
	jsr	bltwait
	move.l	a1,bltdpth(a5)
	move.l	a3,bltapth(a5)
	move.l	#$00380038,bltamod(a5)	;a/dmod=56
	move.l	#-1,bltafwm(a5)
	move.l	#%00001001111100000000000000000000,BLTCON0(A5);0+1
	move.w	#96*64+4,bltsize(a5)

	move.l	a3,a0
	lea	16(a0),a1
	lea	40(a0),a2
	moveq	#95,d0
copycube1l2:
	move.l	(a0),(a1)
	move.l	(a0),(a2)
	lea	64(a0),a0
	lea	64(a1),a1
	lea	64(a2),a2
	dbf	d0,copycube1l2

	lea	20(a3),a1
	jsr	bltwait
	move.l	a1,bltdpth(a5)
	move.l	a3,bltapth(a5)
	move.l	#$002c002c,bltamod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	#%00001001111100000000000000000000,BLTCON0(A5);0+1
	move.w	#96*64+10,bltsize(a5)
	rts

copycube2:
	move.l	pointplane2,a0
	lea	64*32*3(a0),a1
	jsr	bltwait
	move.l	a1,bltdpth(a5)
	move.l	a0,bltapth(a5)
	move.l	#$00140014,bltamod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	#%00001001111100000000000000000000,BLTCON0(A5);0+1
	move.w	#96*64+22,bltsize(a5)
	rts

;------------------------------------------------------------------------
turner3:	;last optimizing:92-08-26
	move.w	turn3x,a1
	add.w	turnadd2x,a1
	cmp.w	#1436,a1
	ble.b nolauf3x
	sub.w	#1440,a1
nolauf3x:
	move.w	a1,turn3x

	move.w	turn3y,a2
	add.w	turnadd2y,a2
	cmp.w	#1436,a2
	ble.b nolauf3y
	sub.w	#1440,a2
nolauf3y:
	move.w	a2,turn3y

	move.w	turn3z,a0
	add.w	turnadd2z,a0
	cmp.w	#1436,a0
	ble.b nolauf3z
	sub.w	#1440,a0
nolauf3z:
	move.w	a0,turn3z


turner31:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	d3sinus,a6	;sinus/cosinus
	move.w	turnquant,d0
	lsl.w	#3,d0		;*8 als offset/koord
turnrout31:

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
	swap	d3
	rol.l	#1,d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	swap	d6
	rol.l	#1,d6
	move.w	d3,d1
	move.w	d3,2(a4,d0.w)
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
	swap	d3
	rol.l	#1,d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	swap	d6
	rol.l	#1,d6
	move.w	d3,4(a4,d0.w)

	move.w	d6,6(a4,d0.w)
	subq.w	#8,d0
	bpl.b	turnrout31
	rts

drawline3:
	move.l	turnkoord,a1	;turned koordinates
	lea	areaoffsets,a3	;areas to draw
	move.w	(a3)+,d7	;areacount
	lea	arealines+2,a4	;linecodes for each area
drawloop31:		;mainloop for each area
	move.w	(a3)+,d6	;get offset of area 1
	move.w	(a4,d6.w),d5	;number of lines in this area
	move.w	2(a4,d6.w),-(a7);areacolour of stack
	move.w	#$7fff,d0
	move.w	d0,lox
	move.w	d0,loy
	moveq	#0,d0
	move.l	d0,hix;(+hiy)
	lea	$dff000,a5
	jsr	bltwait
	move.l	#-1,bltafwm(a5)
	move.w	#64,bltcmod(a5)
	move.w	#64,bltdmod(a5)
	move.w	#0,bltbdat(a5)
	move.w	#$8000,bltadat(a5)
drawloop32:
	moveq	#88,d0
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

	bsr.w	draw3

dbf	d5,drawloop32
addq.w	#1,hiy	;highest x +1 coz difference 0-->1 line to blit
add.w	#16,hix
and.w	#%1111111111110000,hix
and.w	#%1111111111110000,lox

move.w	lox,d0		;lowest x	      	PLANEOFFSET CALCULATION
lsr.w	#4,d0		;/16=words
add.w	d0,d0		;*2=bytes from left border

move.w	loy,d1		;lowest y-koord
lsl.w	#6,d1		;*64 (bytes/line)
move.w	d1,d4		;copy for later use
add.w	d0,d1		;x-offset + y-offset...
move.w	d1,planeoffsets	;...=planeoffset for blitterwindow sourcescreen

;move.w	loy,d4		;again lowest y-koord
;lsl.w	#6,d4		;*(64*3) (bytes/line)
move.w	d4,d1
add.w	d4,d1
add.w	d4,d1
add.w	d0,d1
sub.w	#64*330+20,d1

move.w	d1,planeoffsetd	;planeoffset for destination screen


moveq	#64,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix,d1		;highest x...
sub.w	lox,d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source
add.w	#64+64,d0	;modulo+64+64...
move.w	d0,planemodulod	;...=modulo destination


move.w	hiy,d2	;highest y-value...			BLTSIZE CALC
sub.w	loy,d2	;...-lowest y-value
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize2	;planesize for source and destination

add.w	planeoffsets,d2
add.w	#4,d2
move.w	d2,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize2,planesizef
move.w	planemodulos,planemodulof

addq.w	#4,planesizef
subq.w	#8,planemodulof
addq.w	#4,planeoffsetf

move.w	(a7)+,d0;areacolour from stack
	bsr.w	planefillcopycls
dbf	d7,drawloop31

move.l	clearplane2,d1

lea	$dff000,a5
jsr	bltwait
move.l	d1,BLTDPTH(A5)
move.w	#32+8+20,BLTDMOD(A5)
move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
move.w	#32*3*64+16-4-10,BLTSIZE(A5)

rts


turn3x:	dc.w	0
turn3y:	dc.w	0
turn3z:	dc.w	0
d3sinus:
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


DRAW3:
	lea	calcplane,a0
	lea	octants3(pc),a2
	cmp.w	d1,d3
	bgt.b	draw3l1
	beq.w	draw3l2
	exg	D0,D2
	exg	D1,D3

draw3l1:	
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
	SUBQ.W	#1,D3
	SUB.W	D1,D3
	SUB.W	D0,D2
	bpl.b	.OK2
	NEG.W	D2
	ADDQ.L	#8,A2
.OK2:	CMP.W	D2,D3
	BLE.S	.OK3
	ADDQ.L	#4,A2
	EXG	D2,D3
.OK3:
	MOVE.L	(A2),D4
	ROR.L	#3,D0
	LEA	(A0,D0.W),A2
	ROR.L	#1,D0
	AND.L	#$F0000000,D0
	OR.L	D0,D4
	MOVE.W	D1,D0
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2
	LSL.W	#1,D3
	MOVE.W	D3,D0
	SUB.W	D2,D3
	BGE.S	.NOSIGN
	OR.B	#$40,D4
.NOSIGN:
	add.w	d0,d0
	MOVE.W	D0,D1
	LSL.W	#2,D2
	SUB.W	D2,D1
	ADDQ.W	#4,D2
	LSL.W	#4,D2
	ADDQ.W	#2,D2

	lea	$dff000,a6
	jsr	bltwait
	MOVE.w	d3,bltaptl(a6)
	MOVE.l	a2,bltcpth(a6)
	MOVE.l	a2,bltdpth(a6)
	MOVE.w	d0,bltbmod(a6)
	MOVE.l	d4,bltcon0(a6)
	MOVE.w	d1,bltamod(a6)
	MOVE.w	d2,bltsize(a6)
draw3l2:
	RTS


OCTANTS3:
	DC.L	$0B5AF013
	DC.L	$0B5AF003
	DC.L	$0B5AF017
	DC.L	$0B5AF00B


;cube
linepoints1: dc.w  7; 8 Linepoints

linekoord1:	blk.b	64,0
linekoords1:
dc.w 0,-9,-9, 9
dc.w 0,-9, 9, 9
dc.w 0, 9, 9, 9
dc.w 0, 9,-9, 9
dc.w 0,-9,-9,-9
dc.w 0,-9, 9,-9
dc.w 0, 9, 9,-9
dc.w 0, 9,-9,-9


arealines:
dc.w	5	;2 areas exist
dc.w	3,1,(0+0)*8,(1+0)*8,(2+0)*8,(3+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;1
dc.w	3,2,(4+0)*8,(7+0)*8,(6+0)*8,(5+0)*8,(4+0)*8,0,0,0,0,0,0,0,0,0;2
dc.w	3,3,(0+0)*8,(4+0)*8,(5+0)*8,(1+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;3
dc.w	3,4,(3+0)*8,(2+0)*8,(6+0)*8,(7+0)*8,(3+0)*8,0,0,0,0,0,0,0,0,0;4
dc.w	3,5,(1+0)*8,(5+0)*8,(6+0)*8,(2+0)*8,(1+0)*8,0,0,0,0,0,0,0,0,0;5
dc.w	3,6,(0+0)*8,(3+0)*8,(7+0)*8,(4+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;6

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
	lea	$dff000,a6
	moveq	#0,d1
	move.w	planeoffsetf,d1
	add.l	#calcplane,d1
	jsr	bltwait
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a6);0+1 con
	MOVE.l	#-1,bltafwm(a6)

	MOVE.l	d1,bltapth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.w	planemodulof,bltamod(a6)
	MOVE.w	planemodulof,bltdmod(a6)
	MOVE.w	planesizef,bltsize(a6)

	move.w	#%0000110111111100,d3
	move.w	d3,d4
	move.w	d3,d5

	btst.l	#0,d0
	bne.b	settest1
	move.w	#%0000110100001100,d3
settest1:

	btst.l	#1,d0
	bne.b	settest2
	move.w	#%0000110100001100,d4
settest2:

	btst.l	#2,d0
	bne.b	settest3
	move.w	#%0000110100001100,d5
settest3:

	moveq	#0,d2
	moveq	#0,d1
	move.w	planeoffsets,d2
	move.w	planeoffsetd,d1
	add.l	#calcplane,d2
	add.l	pointplane2,d1

	jsr	bltwait

	MOVE.w	#0,bltcon1(a6)
	MOVE.l	#-1,bltafwm(a6)

	MOVE.w	d3,bltcon0(a6)
	MOVE.l	d1,bltbpth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.l	d2,bltapth(a6)
	MOVE.w	planemodulod,bltbmod(a6)
	MOVE.w	planemodulod,bltdmod(a6)
	MOVE.w	planemodulos,bltamod(a6)
	MOVE.w	planesize2,bltsize(a6)

	add.l	#64,d1

	jsr	bltwait

	MOVE.w	d4,bltcon0(a6)
	MOVE.l	d1,bltbpth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.l	d2,bltapth(a6)
	MOVE.w	planemodulod,bltbmod(a6)
	MOVE.w	planemodulod,bltdmod(a6)
	MOVE.w	planemodulos,bltamod(a6)
	MOVE.w	planesize2,bltsize(a6)

	add.l	#64,d1

	jsr	bltwait

	MOVE.w	d5,bltcon0(a6)
	MOVE.l	d1,bltbpth(a6)
	MOVE.l	d1,bltdpth(a6)
	MOVE.l	d2,bltapth(a6)
	MOVE.w	planemodulod,bltbmod(a6)
	MOVE.w	planemodulod,bltdmod(a6)
	MOVE.w	planemodulos,bltamod(a6)
	MOVE.w	planesize2,bltsize(a6)

	moveq	#0,d2
	move.w	planeoffsets,d2
	add.l	#calcplane,d2

	jsr	bltwait
	MOVE.w	#%0000000100000000,bltcon0(a6)
	MOVE.w	#0,bltcon1(a6)

	MOVE.l	d2,bltdpth(a6)
	MOVE.w	planemodulos,bltdmod(a6)
	MOVE.w	planesize2,bltsize(a6)

	rts

hidesort:
	movem.l	d0-d7/a0-a6,-(a7)
	lea	arealines,a0	;basis of all areas
	move.l	turnkoord,a1	;turned koordinates
	lea	areaoffsets+2,a2
	lea	zpositions,a3	;mittelwerte der z-koords
	move.w	(a0)+,d7	;number of all areas
	moveq	#-1,d6		;counter of non-hidden areas
hidel1:
	move.w	d7,d5
	lsl.w	#5,d5
	move.w	4(a0,d5.w),d0	;pointcode1
	move.w	6(a0,d5.w),d2	;pointcode2
	move.w	8(a0,d5.w),d4	;pointcode3
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
	move.w	6(a1,d3.w),d3
	add.l	d3,d1
	dbf	d0,zaddloop
	asl.w	#2,d1
	ext.l	d1
	divs	d4,d1
	move.w	d1,(a3)+
hidden:
	dbf	d7,hidel1
	lea	areaoffsets,a0
	move.w	d6,(a0)
	movem.l	(a7)+,d0-d7/a0-a6
	rts

planeoffsets:	dc.w	0
planeoffsetd:	dc.w	0
planeoffsetf:	dc.w	0
planesizef:	dc.w	0
planesize2:	dc.w	0
planemodulof:	dc.w	0
planemodulos:	dc.w	0
planemodulod:	dc.w	0
lox:	dc.w	0
loy:	dc.w	0
hix:	dc.w	0
hiy:	dc.w	0

animmaker:
	move.l	clearplane2,a2
	moveq	#95,d0
animmakerl3:
	move.l	#-1,(a2)
	lea	64(a2),a2
	dbf	d0,animmakerl3
	jsr	switchplanes2

	moveq	#119,d1
	move.l	animpoint,a1
animmakerl1:
	movem.l	d0-d1/a0-a2,-(a7)
	jsr	turner3
	jsr	hidesort
	jsr	drawline3
	movem.l	(a7)+,d0-d1/a0-a2

	move.l	clearplane2,a2
	move.l	pointplane2,a0
	moveq	#95,d0
animmakerl2:
	move.l	#-1,(a2)
	move.l	(a0),(a1)+
	lea	64(a0),a0
	lea	64(a2),a2
	dbf	d0,animmakerl2
	jsr	switchplanes2
	dbf	d1,animmakerl1
	rts

mainmemcls:
	lea	mainmem+3846*52,a0

	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d1,a1
	move.l	d1,a2
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6

	move.w	#3845,d0
mainmemclsl1:
	movem.l	d1-d7/a1-a6,-(a0)
	dbf	d0,mainmemclsl1
	lea	$dff000,a5
	rts

realfade:
	move.w	fadesleep,d0
	beq.b	fadeit
	subq.w	#1,d0
	move.w	d0,fadesleep
	rts
fadeit:
	move.w	fadecount,fadesleep
	move.w	fadeflag,d0
	cmp.w	#30,d0
	bne.b	fadereal
	rts
fadereal:
	addq.w	#2,d0
	move.w	d0,fadeflag
	subq.w	#2,d0;;
	lea	fadedat,a0
	lea	faded,a1
	moveq	#31,d1
	lea	(a0,d0.w),a0
fadereall1:
	move.w	(a0),(a1)+
	lea	30(a0),a0
	dbf	d1,fadereall1
	rts
;*****


fader:
	lea	tofade,a2
	lea	fadedat,a1
	lea	faded,a0
	moveq	#31,d0
faderloop1:
	moveq	#14,d1
	move.w	(a0)+,d2
	move.w	d2,d3
	move.w	d2,d4
	and.w	#%0000000000001111,d2
	and.w	#%0000000011110000,d3
	and.w	#%0000111100000000,d4
	move.w	(a2)+,d5
	move.w	d5,d6
	move.w	d5,d7
	and.w	#%0000000000001111,d5
	and.w	#%0000000011110000,d6
	and.w	#%0000111100000000,d7
faderloop2:
	cmp.w	d2,d5
	beq.b	nobluefade
	ble.b	blueblack
	addq.w	#%1,d2
	bra.b	nobluefade
blueblack:
	subq.w	#1,d2
nobluefade:
	cmp.w	d3,d6
	beq.b	nogreenfade
	ble.b	greenblack
	add.w	#%10000,d3
	bra.b	nogreenfade
greenblack:
	sub.w	#%10000,d3
nogreenfade:
	cmp.w	d4,d7
	beq.b	noredfade
	ble.b	redblack
	add.w	#%100000000,d4
	bra.b	noredfade
redblack:
	sub.w	#%100000000,d4
noredfade:
	move.w	d2,a3
	or.w	d3,d2
	or.w	d4,d2
	move.w	d2,(a1)+
	move.w	a3,d2
	dbf	d1,faderloop2
	dbf	d0,faderloop1
	move.w	#0,fadeflag
	rts
;*****

fadesleep:	dc.w	1
fadecount:	dc.w	3
tofade:		blk.w	32,$0000
faded:		blk.w	32,$0000
fadedat:	blk.w	32*16,$0000
fadeflag:	dc.w	0

colourtab:
dc.w	$0000,$0f00,$0f10,$0f20,$0f30,$0f40,$0f50,$0f60
dc.w	$0f70,$0f80,$0f90,$0fa0,$0fb0,$0fc0,$0fd0,$0fe0
dc.w	$0ff0,$0ee1,$0dd2,$0cc3,$0bb4,$0aa5,$0996,$0887
dc.w	$0778,$0669,$055a,$044b,$033c,$022d,$011e,$000f


cubesin:;Created with Liberty Design's Sinusmaker
dc.W  0, 5, 10, 16, 21, 26, 31, 37, 42, 47, 52, 57, 62, 68
dc.W  73, 78, 83, 88, 93, 98, 103, 108, 113, 118, 123, 128
dc.W  133, 137, 142, 147, 152, 156, 161, 166, 170, 175, 179
dc.W  184, 188, 193, 197, 201, 205, 210, 214, 218, 222, 226
dc.W  230, 234, 238, 242, 245, 249, 253, 256, 260, 263, 267
dc.W  270, 273, 276, 280, 283, 286, 289, 292, 294, 297, 300
dc.W  303, 305, 308, 310, 313, 315, 317, 319, 321, 324, 326
dc.W  327, 329, 331, 333, 334, 336, 337, 339, 340, 341, 343
dc.W  344, 345, 346, 347, 348, 348, 349, 350, 350, 351, 351
dc.W  351, 352, 352, 352, 352, 352, 352, 352, 352, 351, 351
dc.W  350, 350, 349, 349, 348, 347, 346, 346, 345, 343, 342
dc.W  341, 340, 339, 337, 336, 334, 333, 331, 330, 328, 326
dc.W  324, 322, 321, 319, 316, 314, 312, 310, 308, 305, 303
dc.W  301, 298, 296, 293, 291, 288, 285, 283, 280, 277, 274
dc.W  271, 268, 265, 262, 259, 256, 253, 250, 247, 244, 240
dc.W  237, 234, 231, 227, 224, 221, 217, 214, 210, 207, 203
dc.W  200, 197, 193, 189, 186, 182, 179, 175, 172, 168, 165
dc.W  161, 157, 154, 150, 147, 143, 139, 136, 132, 129, 125
dc.W  121, 118, 114, 111, 107, 104, 100, 97, 93, 90, 86, 83
dc.W  79, 76, 73, 69, 66, 63, 59, 56, 53, 50, 47, 43, 40
dc.W  37, 34, 31, 28, 25, 22, 19, 16, 14, 11, 8, 5, 3, 0
dc.W -3,-5,-8,-10,-13,-15,-17,-20,-22,-24,-26,-28,-30,-33
dc.W -35,-36,-38,-40,-42,-44,-45,-47,-49,-50,-52,-53,-55
dc.W -56,-57,-59,-60,-61,-62,-63,-64,-65,-66,-67,-68,-68
dc.W -69,-70,-70,-71,-71,-72,-72,-73,-73,-73,-73,-74,-74
dc.W -74,-74,-74,-74,-74,-73,-73,-73,-73,-72,-72,-71,-71
dc.W -70,-70,-69,-69,-68,-67,-67,-66,-65,-64,-63,-62,-61
dc.W -60,-59,-58,-57,-56,-55,-53,-52,-51,-50,-48,-47,-46
dc.W -44,-43,-41,-40,-38,-37,-35,-34,-32,-31,-29,-27,-26
dc.W -24,-22,-21,-19,-17,-16,-14,-12,-10,-9,-7,-5,-3,-2, 0
dc.W  2, 3, 5, 7, 9, 10, 12, 14, 16, 17, 19, 21, 22, 24, 26
dc.W  27, 29, 31, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46
dc.W  47, 48, 50, 51, 52, 53, 55, 56, 57, 58, 59, 60, 61
dc.W  62, 63, 64, 65, 66, 67, 67, 68, 69, 69, 70, 70, 71
dc.W  71, 72, 72, 73, 73, 73, 73, 74, 74, 74, 74, 74, 74
dc.W  74, 73, 73, 73, 73, 72, 72, 71, 71, 70, 70, 69, 68
dc.W  68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 57, 56, 55
dc.W  53, 52, 50, 49, 47, 45, 44, 42, 40, 38, 36, 35, 33
dc.W  30, 28, 26, 24, 22, 20, 17, 15, 13, 10, 8, 5, 3, 0
dc.W -3,-5,-8,-11,-14,-16,-19,-22,-25,-28,-31,-34,-37,-40
dc.W -43,-47,-50,-53,-56,-59,-63,-66,-69,-73,-76,-79,-83
dc.W -86,-90,-93,-97,-100,-104,-107,-111,-114,-118,-121,-125
dc.W -129,-132,-136,-139,-143,-147,-150,-154,-157,-161,-165
dc.W -168,-172,-175,-179,-182,-186,-189,-193,-197,-200,-203
dc.W -207,-210,-214,-217,-221,-224,-227,-231,-234,-237,-240
dc.W -244,-247,-250,-253,-256,-259,-262,-265,-268,-271,-274
dc.W -277,-280,-283,-285,-288,-291,-293,-296,-298,-301,-303
dc.W -305,-308,-310,-312,-314,-316,-319,-321,-322,-324,-326
dc.W -328,-330,-331,-333,-334,-336,-337,-339,-340,-341,-342
dc.W -343,-345,-346,-346,-347,-348,-349,-349,-350,-350,-351
dc.W -351,-352,-352,-352,-352,-352,-352,-352,-352,-351,-351
dc.W -351,-350,-350,-349,-348,-348,-347,-346,-345,-344,-343
dc.W -341,-340,-339,-337,-336,-334,-333,-331,-329,-327,-326
dc.W -324,-321,-319,-317,-315,-313,-310,-308,-305,-303,-300
dc.W -297,-294,-292,-289,-286,-283,-280,-276,-273,-270,-267
dc.W -263,-260,-256,-253,-249,-245,-242,-238,-234,-230,-226
dc.W -222,-218,-214,-210,-205,-201,-197,-193,-188,-184,-179
dc.W -175,-170,-166,-161,-156,-152,-147,-142,-137,-133,-128
dc.W -123,-118,-113,-108,-103,-98,-93,-88,-83,-78,-73,-68
dc.W -62,-57,-52,-47,-42,-37,-31,-26,-21,-16,-10,-3

dc.l	0
scrollplane:
blk.b	16*50,0
dc.l	0

;replaycode:
;incbin	"data/replaycode"
;pr_module=replaycode+4288
;pr_init=replaycode
;pr_end=replaycode+574
;pr_music=replaycode+644
*****************************************
*					*
* PRORUNNER V2.0			*
* --------------			*
* CODED BY COSMOS OF SANITY IN 1992	*
*					*
*****************************************
*					*
* Supporting the following effects:	*
*					*
*	- Running with 68010/20/30/40	*
*	- Using VBR-register		*
*	- Packed/Normal PT-Moduleformat	*
*	- Fade Sound in/out		*
*	- Variable Musicfadespeed	*
*	- Variable Interrupt-timing	*
*	- Finetune			*
*	- Normal play or Arpeggio	*
*	- Slide Frequenz up		*
*	- Slide	Frequenz down		*
*	- Tone Portamento		*
*	- Vibrato			*
*	- Tone Portamento+Volume Slide	*
*	- Vibrato + Volume Slide	*
*	- Tremolo			*
*	- Set SampleOffset		*
*	- Volume Slide			*
*	- Position Jump			*
*	- Set Volume			*
*	- Pattern Break			*
*	- Set Speed			*
* - E-Commands:				*
*	- Set Filter			*
*	- Fine Slide Up			*
*	- Fine Slide Down		*
*	- Glissando Control		*
*	- Set Vibrato Waveform		*
*	- Set Finetune			*
*	- Set Loop / Jump to Loop	*
*	- Set Tremolo Waveform		*
*	- Retrig Note			*
*	- Fine VolumeSlide Up		*
*	- Fine VolumeSlide Down		*
*	- NoteCut			*
*	- NoteDelay			*
*	- PatternDelay			*
*	- FunkRepeat			*
*					*
*****************************************

YES				=	1
NO				=	0
INCLUDEFADINGROUTINE		=	no
PACKEDSONGFORMAT		=	yes
FADINGSTEPS			=	6	; ( 0< FADINGSTEPS <9 )
MAXVOLUME			=	2^FADINGSTEPS
INTERRUPTTIME			=	$180

SAMPLELENGTHOFFSET		=	4
SAMPLEVOLUMEOFFSET		=	6
SAMPLEREPEATPOINTOFFSET		=	8
SAMPLEWITHLOOP			=	12
SAMPLEREPEATLENGTHOFFSET	=	14
SAMPLEFINETUNEOFFSET		=	16

* Init-Routine *******************************************************

pr_init:
	lea	pr_framecounter(pc),a6
	move.w	#$7fff,pr_oldledvalue-pr_framecounter(a6)
	move.l	pr_module(pc),a0
	cmp.l	#0,a0
	bne.s	pr_init1
	rts
pr_init1:
	IFEQ	PACKEDSONGFORMAT-YES
	cmp.l	#'SNT!',(a0)
	beq.s	pr_init2
	ELSE
	cmp.l	#'M.K.',1080(a0)
	beq.s	pr_init2
	cmp.l	#'SNT.',1080(a0)
	beq.s	pr_init2
	ENDC
	rts
pr_init2:
	IFEQ	PACKEDSONGFORMAT-YES
	lea	8(a0),a1
	ELSE
	lea	20(a0),a1
	ENDC
	lea	pr_Sampleinfos(pc),a2
	moveq.l	#32,d7
	moveq	#30,d0
pr_init3:
	IFNE	PACKEDSONGFORMAT-YES
	lea	22(a1),a1		; Samplenamen �berspringen
	ENDC
	move.w	(a1)+,SAMPLELENGTHOFFSET(a2)	; Samplelength in Words
	lea	pr_periods(pc),a3
	moveq	#$f,d2
	and.b	(a1)+,d2		; Finetuning
	mulu.w	#36*2,d2
	add.l	d2,a3
	move.l	a3,SAMPLEFINETUNEOFFSET(a2)
	moveq	#0,d1
	move.b	(a1)+,d1
	move.w	d1,SAMPLEVOLUMEOFFSET(a2)	; Volume
	moveq.l	#0,d1
	move.w	(a1)+,d1		; Repeatpoint in Bytes
	add.l	d1,d1
	move.l	d1,SAMPLEREPEATPOINTOFFSET(a2)
	move.w	(a1)+,d1
	clr.w	SAMPLEWITHLOOP(a2)
	cmp.w	#1,d1
	bls.s	pr_init3_2
	addq.w	#1,SAMPLEWITHLOOP(a2)
pr_init3_2:
	move.w	d1,SAMPLEREPEATLENGTHOFFSET(a2)	; Repeatlength
	add.l	d7,a2
	dbf	d0,pr_init3

	moveq	#0,d0
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	256(a0),d0
	ELSE
	move.b	950(a0),d0		; Number of patterns
	ENDC
	subq.w	#1,d0
	move.w	d0,pr_highestpattern-pr_framecounter(a6)
	moveq.l	#0,d1
	lea	pr_Patternpositions(pc),a3
	IFEQ	PACKEDSONGFORMAT-YES
	lea	258(a0),a1		; 1.Patternpos
	lea	770(a0),a2		; 1.Patterndata
	lea	642(a0),a4		; 1.Patternoffset
pr_init4:
	moveq.l	#0,d2
	move.b	(a1)+,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	add.l	a2,d2
	move.l	d2,(a3)+
	dbf	d0,pr_init4
	ELSE
	lea	952(a0),a1		; 1. Patternpos
	lea	1084(a0),a2		; 1. Patterndata
pr_init4:
	move.b	(a1)+,d2		; x. Patternpos
	moveq.l	#0,d3
	move.b	d2,d3
	mulu.w	#1024,d3
	add.l	a2,d3
	move.l	d3,(a3)+
	dbf	d0,pr_init4
	ENDC

	IFEQ	PACKEDSONGFORMAT-YES
	move.l	4(a0),d2
	add.l	a0,d2
	ELSE
	lea	952(a0),a1
	moveq.l	#0,d1
	moveq	#127,d0
pr_init4_1:
	move.b	(a1)+,d2
	cmp.b	d1,d2			; Highest Pattern ?
	bls.s	pr_init4_2
	move.b	d2,d1
pr_init4_2:
	dbf	d0,pr_init4_1
	addq.w	#1,d1
	move.l	a0,d2
	mulu.w	#1024,d1		; Highest Pattern * 1024 Bytes
	add.l	#1084,d2
	add.l	d1,d2
	ENDC
	lea	pr_Sampleinfos(pc),a3
	lea	pr_Sampleinfos+SAMPLELENGTHOFFSET(pc),a2
	moveq.l	#32,d7
	move.l	d2,(a3)
	moveq	#29,d0
pr_init4_3:
	move.l	(a3),d1
	add.l	d7,a3
	moveq.l	#0,d2
	move.w	(a2),d2
	add.l	d7,a2
	add.l	d2,d2
	add.l	d2,d1
	move.l	d1,(a3)
	dbf	d0,pr_init4_3

	lea	pr_Sampleinfos(pc),a2
	lea	pr_Sampleinfos+SAMPLEREPEATPOINTOFFSET(pc),a3
	moveq.l	#32,d7
	moveq	#30,d0
pr_init4_4:
	move.l	(a2),d1
	add.l	d1,(a3)
	add.l	d7,a2
	add.l	d7,a3
	dbf	d0,pr_init4_4
	
	IFNE	PACKEDSONGFORMAT-YES
	
	cmp.l	#'SNT.',1080(a0)
	beq.s	pr_init7
	
	lea	1084(a0),a1
	move.l	pr_Sampleinfos(pc),a2
	move.b	#$f0,d6
	move.w	#$fff,d7
pr_init5:
	move.b	(a1),d0
	move.b	2(a1),d1
	move.w	(a1),d2
	and.w	d7,2(a1)
	and.w	d7,d2
	
	and.b	d6,d0
	lsr.b	#4,d1
	or.b	d1,d0
	move.b	d0,(a1)
	
	tst.w	d2
	beq.s	pr_init5_3
	lea	pr_periods(pc),a4
	moveq	#0,d1
pr_init5_2:
	addq.w	#1,d1
	cmp.w	(a4)+,d2
	bne.s	pr_init5_2
	move.b	d1,1(a1)
pr_init5_3:
	cmp.b	#$d,2(a1)
	bne.s	pr_init5_4

	moveq	#0,d1
	move.b	3(a1),d1
	moveq	#$f,d2
	and.w	d1,d2
	lsr.w	#4,d1
	mulu.w	#10,d1
	add.w	d2,d1
	cmp.b	#63,d1
	bls.s	pr_init5_3_2
	moveq	#63,d1
pr_init5_3_2:
	move.b	d1,3(a1)
pr_init5_4:
	addq.l	#4,a1
	cmp.l	a2,a1
	blt.s	pr_init5	

	move.l	#'SNT.',1080(a0)

	ENDC
	
pr_init7:
	lea	pr_Arpeggiofastlist(pc),a2
	lea	pr_Arpeggiofastlistperiods(pc),a1
	lea	35*2(a1),a1		; to the end of list...
	moveq	#0,d0
	moveq	#35,d1
	move.w	#999,d2
	moveq	#0,d6
pr_init8:
	move.w	-(a1),d7
	addq.w	#1,d6
pr_init8_2:
	cmp.w	d7,d0
	blt.s	pr_init8_4
	subq.w	#1,d1
	tst.b	d1
	bne.s	pr_init8
pr_init8_3:
	move.b	d1,(a2)+
	dbf	d2,pr_init8_3
	bra.s	pr_init8_5	
pr_init8_4:
	move.b	d1,(a2)+
	addq.w	#1,d0
	dbf	d2,pr_init8_2
pr_init8_5:

	lea	pr_Channel0(pc),a1
	move.w	#1,pr_Channel1-pr_Channel0(a1)
	move.w	#1,pr_Channel2-pr_Channel0(a1)
	move.w	#1,pr_Channel3-pr_Channel0(a1)
	move.w	#1,(a1)+
	moveq	#(pr_Channel1-pr_Channel0)/2-2,d0
pr_init9_2:
	clr.w	pr_Channel1-pr_Channel0(a1)
	clr.w	pr_Channel2-pr_Channel0(a1)
	clr.w	pr_Channel3-pr_Channel0(a1)
	clr.w	(a1)+
	dbf	d0,pr_init9_2

	lea	pr_fastperiodlist(pc),a1
	lea	pr_periods(pc),a2
	move.l	a2,(a1)
	moveq.l	#36*2,d1
	moveq	#14,d0
pr_init9_3:
	move.l	(a1)+,d2
	add.l	d1,d2
	move.l	d2,(a1)
	dbf	d0,pr_init9_3
		
	lea	pr_Arpeggiofastdivisionlist(pc),a1
	moveq	#0,d1
	move.w	#$ff,d0
pr_init9_4:
	move.b	d1,(a1)+
	subq.b	#1,d1
	bpl.s	pr_init9_4_2
	moveq	#2,d1
pr_init9_4_2:
	dbf	d0,pr_init9_4
	
	move.w	#6,pr_speed-pr_framecounter(a6)
	move.w	pr_speed(pc),(a6)
	clr.w	pr_Patternct-pr_framecounter(a6)
	move.w	pr_highestpattern(pc),d0
	move.w	pr_startposition(pc),d1
	blt.s	pr_init9_5
	cmp.w	d0,d1
	bls.s	pr_init9_5_2
pr_init9_5:
	clr.w	pr_startposition-pr_framecounter(a6)
pr_init9_5_2:
	move.w	pr_startposition(pc),pr_currentpattern-pr_framecounter(a6)
	
	lea	pr_Patternpositions(pc),a3
	move.l	a3,d0
	moveq.l	#0,d1
	move.w	pr_startposition(pc),d1
	lsl.l	#2,d1
	add.l	d1,d0
	move.l	d0,pr_Patternpt-pr_framecounter(a6)
	move.l	pr_Patternpt(pc),a5
	move.l	(a5),pr_Currentposition-pr_framecounter(a6)
	
	lea	$dff000,a5
	lea	$bfd000,a0
	move.w	#$2000,d0
	move.w	d0,$9a(a5)
	move.w	d0,$9c(a5)
	
	lea	pr_int(pc),a1
	move.l	pr_Vectorbasept(pc),a3
	move.l	a1,$78(a3)

	move.b	#$7f,$d00(a0)
	move.b	#$08,$e00(a0)
	move.w	#INTERRUPTTIME,d0
	move.b	d0,$400(a0)
	lsr.w	#8,d0
	move.b	d0,$500(a0)
pr_init10:
	btst	#0,$bfdd00
	beq.s	pr_init10
	move.b	#$81,$d00(a0)
	move.w	#$2000,$9c(a5)
	move.w	#$a000,$9a(a5)
	move.w	#$f,$96(a5)
	move.w	#$8000,pr_dmacon-pr_framecounter(a6)
	clr.w	$a8(a5)
	clr.w	$b8(a5)
	clr.w	$c8(a5)
	clr.w	$d8(a5)
	moveq	#0,d0
	move.b	$bfe001,d0
	move.w	d0,pr_oldledvalue-pr_framecounter(a6)
	bset	#1,$bfe001
	rts

* End-Routine *********************************************************

pr_end:
	lea	$dff000,a5
	move.w	#$f,$96(a5)
	clr.w	$a8(a5)
	clr.w	$b8(a5)
	clr.w	$c8(a5)
	clr.w	$d8(a5)
	move.w	#$2000,$9a(a5)
	move.w	pr_oldledvalue(pc),d0
	cmp.w	#$7fff,d0
	beq.s	pr_end3
	btst	#1,d0
	beq.s	pr_end2
	bset	#1,$bfe001
	rts
pr_end2:
	bclr	#1,$bfe001
pr_end3:
	rts

* Music-Fading ********************************************************

	IFEQ	INCLUDEFADINGROUTINE-YES
pr_fademusic:	macro
	lea	pr_musicfadect(pc),a0
	move.w	pr_musicfadedirection(pc),d0
	add.w	d0,(a0)
	cmp.w	#MAXVOLUME,(a0)
	bls.s	pr_fademusicend
	bgt.s	pr_fademusictoohigh
	clr.w	(a0)
	clr.w	pr_musicfadedirection-pr_musicfadect(a0)
	rts
pr_fademusictoohigh:
	move.w	#MAXVOLUME,(a0)
	clr.w	pr_musicfadedirection-pr_musicfadect(a0)
pr_fademusicend:
	endm

pr_musicfadect:		dc.w	MAXVOLUME
pr_musicfadedirection:	dc.w	0
	ENDC
	
* MACROS **************************************************************

pr_playchannel:	macro				; do not change: d7,a2-a6
		moveq	#0,d2
		moveq	#0,d0
		moveq	#0,d1
		IFEQ	PACKEDSONGFORMAT-YES
		move.b	(a6),d6
		bpl.s	.pr_playchannel1
		btst	#6,d6
		bne.s	.pr_playchannel0
		subq.l	#2,a6
		clr.w	4(a4)
		bra.s	.pr_playchannelend
.pr_playchannel0:		
		subq.l	#2,a6
		move.b	56(a4),d0
		move.b	57(a4),d1
		move.b	58(a4),d2
		move.w	58(a4),4(a4)
		bra.s	.pr_playchanneljump		
.pr_playchannel1:
		moveq	#$f,d0
		and.b	1(a6),d0
		move.b	d0,4(a4)
		move.b	d0,d2
		move.b	2(a6),5(a4)
		move.w	4(a4),58(a4)
		
		moveq	#1,d0
		and.b	(a6),d0
		move.b	1(a6),d1
		lsr.b	#3,d1
		bclr	#0,d1
		or.b	d1,d0
		move.b	d0,56(a4)		

		move.b	(a6),d1
		lsr.b	#1,d1
		move.b	d1,57(a4)
		ELSE
		move.w	2(a6),4(a4)
		move.b	2(a6),d2
		move.b	(a6),d0
		move.b	1(a6),d1
		ENDC
.pr_playchanneljump:
		add.w	d2,d2
		lea	pr_playchannellist(pc),a0
		move.w	(a0,d2.w),d2
		jsr	(a0,d2.w)
.pr_playchannelend:
		IFEQ	PACKEDSONGFORMAT-YES
		addq.l	#3,a6
		ELSE
		addq.l	#4,a6
		ENDC
		endm

pr_checkchannel:	macro			; do not change: d7,a2-a6
		bsr.w	pr_checkfunkrepeat
		moveq	#0,d0
		move.b	4(a4),d0
		add.b	d0,d0
		lea	pr_Effectchecklist(pc),a0
		move.w	(a0,d0.w),d0
		jsr	(a0,d0.w)
		endm
		
pr_copyplayvalues:	macro
		tst.w	pr_commandnotedelay-pr_framecounter(a2)
		bne.s	.pr_copyplayvalues2
		move.w	2(a4),6(a3)
.pr_copyplayvalues2:
		IFEQ	INCLUDEFADINGROUTINE-YES
		move.w	12(a4),d0
		mulu.w	pr_musicfadect-pr_framecounter(a2),d0
 		lsr.l	#FADINGSTEPS,d0
		move.w	d0,8(a3)
		ELSE
		move.w	12(a4),8(a3)
		ENDC
		endm

* Music-Routine *******************************************************

pr_music:
	IFEQ	INCLUDEFADINGROUTINE-YES
	pr_fademusic
	ENDC
	lea	$dff000,a5

	lea	pr_framecounter(pc),a2
	subq.w	#1,(a2)
	beq.s	pr_music2
	bra.w	pr_checkeffects
pr_music2:
	cmp.b	#1,pr_patterndelaytime-pr_framecounter+1(a2)
	blt.s	pr_music2_2
	bsr.w	pr_checkeffects
	bra.w	pr_music2_9
pr_music2_2:
	move.l	pr_Currentposition(pc),a6
	lea	pr_Channel0(pc),a4
	lea	$a0(a5),a3
	moveq	#1,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_3:	
	lea	pr_Channel1(pc),a4
	lea	$b0(a5),a3
	moveq	#2,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_4:
	lea	pr_Channel2(pc),a4
	lea	$c0(a5),a3
	moveq	#4,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_5:
	lea	pr_Channel3(pc),a4
	lea	$d0(a5),a3
	moveq	#8,d7
	pr_playchannel
	pr_copyplayvalues
	
	lea	pr_int(pc),a0
	move.l	pr_Vectorbasept(pc),a1
	move.l	a0,$78(a1)
	move.b	#$19,$bfde00

pr_music2_9:
	move.w	pr_speed(pc),(a2)
	tst.w	pr_patternhasbeenbreaked-pr_framecounter(a2)
	bne.s	pr_music3
	tst.w	pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	subq.w	#1,pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	bra.s	pr_nonextpattern
pr_music3:
	clr.w	pr_patternhasbeenbreaked-pr_framecounter(a2)
	tst.w	pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	subq.w	#1,pr_patterndelaytime-pr_framecounter(a2)
pr_music3_1:
	lea	pr_Patternct(pc),a1
	tst.w	pr_dontcalcnewposition-pr_framecounter(a2)
	bne.s	pr_music3_2
	move.l	a6,pr_Currentposition-pr_framecounter(a2)
	addq.w	#1,(a1)
pr_music3_2:
	clr.w	pr_dontcalcnewposition-pr_framecounter(a2)
	moveq.l	#64,d1
	cmp.w	(a1),d1
	bgt.s	pr_nonextpattern
	sub.w	d1,(a1)
	lea	pr_currentpattern(pc),a0
	move.w	(a1),d1
	beq.s	pr_music3_3
	IFEQ	PACKEDSONGFORMAT-YES
	move.l	pr_module(pc),a1
	lea	386(a1),a1
	move.w	(a0),d1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	ELSE
	lsl.w	#4,d1
	ENDC
pr_music3_3:
	addq.l	#4,pr_Patternpt-pr_framecounter(a2)
	addq.w	#1,(a0)
	move.w	(a0),d0
	cmp.w	pr_highestpattern-pr_framecounter(a2),d0
	bls.s	pr_nohighestpattern
	lea	pr_Patternpositions(pc),a1
	move.l	a1,pr_Patternpt-pr_framecounter(a2)
	clr.w	(a0)
pr_nohighestpattern:
	move.l	pr_Patternpt-pr_framecounter(a2),a6
	move.l	(a6),d0
	add.l	d1,d0
	move.l	d0,pr_Currentposition-pr_framecounter(a2)
pr_nonextpattern:
	rts

	
pr_int:
	tst.b	$bfdd00
	move.b	#$19,$bfde00
	move.w	pr_dmacon(pc),$dff096
	move.w	#$2000,$dff09c
	move.l	a0,-(sp)
	move.l	pr_Vectorbasept(pc),a0
	add.l	#pr_int2-pr_int,$78(a0)
	move.l	(sp)+,a0
	rte

pr_int2:
	tst.b	$bfdd00
	movem.l	a5-a6,-(sp)
	lea	$dff000,a5
	lea	pr_Channel0+6(pc),a6
	move.l	(a6),$a0(a5)
	move.w	4(a6),$a4(a5)
	move.l	pr_Channel1-pr_Channel0(a6),$b0(a5)
	move.w	4+pr_Channel1-pr_Channel0(a6),$b4(a5)
	move.l	pr_Channel2-pr_Channel0(a6),$c0(a5)
	move.w	4+pr_Channel2-pr_Channel0(a6),$c4(a5)
	move.l	pr_Channel3-pr_Channel0(a6),$d0(a5)
	move.w	4+pr_Channel3-pr_Channel0(a6),$d4(a5)
	move.w	#$2000,$9c(a5)
	move.l	pr_Vectorbasept(pc),a6
	move.l	pr_old78(pc),$78(a6)
	movem.l	(sp)+,a5-a6
	rte
		
pr_playchannellist:
	dc.w	pr_playnormalchannel-pr_playchannellist		; 0
	dc.w	pr_playnormalchannel-pr_playchannellist		; 1
	dc.w	pr_playnormalchannel-pr_playchannellist		; 2
	dc.w	pr_playtpchannel-pr_playchannellist		; 3
	dc.w	pr_playnormalchannel-pr_playchannellist		; 4
	dc.w	pr_playtpchannel-pr_playchannellist		; 5
	dc.w	pr_playnormalchannel-pr_playchannellist		; 6
	dc.w	pr_playnormalchannel-pr_playchannellist		; 7
	dc.w	pr_playnormalchannel-pr_playchannellist		; 8
	dc.w	pr_playsochannel-pr_playchannellist		; 9
	dc.w	pr_playnormalchannel-pr_playchannellist		; A
	dc.w	pr_playnormalchannel-pr_playchannellist		; B
	dc.w	pr_playnormalchannel-pr_playchannellist		; C
	dc.w	pr_playnormalchannel-pr_playchannellist		; D
	dc.w	pr_playnormalchannel-pr_playchannellist		; E
	dc.w	pr_playnormalchannel-pr_playchannellist		; F
	
* KANAL NORMAL SPIELEN ************************************************

pr_playnormalchannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	clr.w	pr_commandnotedelay-pr_framecounter(a2)
	moveq	#-1,d4
	lsl.w	#4,d4
	and.w	4(a4),d4
	cmp.w	#$ed0,d4
	bne.s	pr_playnormalsamplenotedelay
	addq.w	#1,pr_commandnotedelay-pr_framecounter(a2)
pr_playnormalsamplenotedelay:
	tst.b	d0
	beq.b	pr_playnormalnonewsample	; Irgendein Sample ?
	move.w	d0,(a4)				; Trage Samplenummer ein
	tst.b	d1
	bne.s	pr_playnormalsample
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playnormalchannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalchannel2:
	move.w	(a0)+,10(a4)
	bra.w	pr_playnormalnonewperiod
pr_playnormalsample:
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	tst.w	pr_commandnotedelay-pr_framecounter(a2)
	beq.b	pr_playnormalsamplenoedcom
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.w	6(a0),12(a4)
	move.l	8(a0),6(a4)
	move.w	14(a0),10(a4)
	bra.s	pr_playnormalnewperiod
pr_playnormalsamplenoedcom:
	move.w	d7,$96(a5)
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	move.w	(a0)+,12(a4)		; Setze Samplelautst�rke
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playnormalsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.s	pr_playnormalnewperiod
pr_playnormalnonewsample:
	clr.l	14(a4)
	tst.b	d1
	beq.s	pr_playnormalnonewperiod	; Irgend ne neue Frequenz ?
	move.w	(a4),d0			; Alte Samplenummer holen
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	tst.w	pr_commandnotedelay-pr_framecounter(a2)
	bne.s	pr_playnormalnewperiod
	move.w	d7,$96(a5)
pr_playnormalnonewsamplenoedcom:
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playnormalnonewsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalnonewsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
pr_playnormalnewperiod:
	subq.b	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),2(a4)		; Frequenz eintragen
pr_playnormalnonewperiod:
	bra.w	pr_playeffect

* KANAL MIT OFFSET SPIELEN *********************************************

pr_playsochannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	tst.b	d0
	beq.w	pr_playsononewsample	; Irgendein Sample ?
	move.w	d0,(a4)				; Trage Samplenummer ein
	tst.b	d1
	bne.s	pr_playsosample
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsochannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsochannel2:
	move.w	(a0)+,10(a4)
	bra.w	pr_playsononewperiod
pr_playsosample:
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d6
	move.b	5(a4),d6
	lsl.w	#7,d6
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,d2
	move.w	(a0)+,d3
	cmp.w	d3,d6
	bge.s	pr_playsosample2
	sub.w	d6,d3
	add.l	d6,d6
	add.l	d6,d2
	move.l	d2,(a3)			; Setze Samplestart
	move.w	d3,4(a3)		; Setze Audiodatenl�nge
	move.w	(a0)+,12(a4)		; Setze Samplelautst�rke
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playsosample1
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample1:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.w	pr_playsonewperiod
pr_playsosample2:
	move.w	(a0)+,12(a4)
	move.l	(a0),(a3)
	move.w	4(a0),4(a3)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsosample4
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample4:
	move.w	(a0)+,10(a4)
	bra.s	pr_playsonewperiod
pr_playsononewsample:
	clr.l	14(a4)
	tst.b	d1
	beq.b	pr_playsononewperiod	; Irgend ne neue Frequenz ?
	move.w	(a4),d0			; Alte Samplenummer holen
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d6
	move.b	5(a4),d6
	lsl.w	#7,d6
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,d2
	move.w	(a0)+,d3
	cmp.w	d3,d6
	bge.s	pr_playsosample3
	sub.w	d6,d3
	add.l	d6,d6
	add.l	d6,d2
	move.l	d2,(a3)			; Setze Samplestart
	move.w	d3,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playsononewsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsononewsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.s	pr_playsonewperiod
pr_playsosample3:
	addq.l	#2,a0
	move.l	(a0),(a3)
	move.w	4(a0),4(a3)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsosample5
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample5:
	move.w	(a0)+,10(a4)
	bra.w	pr_playsonewperiod
pr_playsonewperiod:
	subq.w	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),2(a4)		; Frequenz eintragen
pr_playsononewperiod:
	bra.b	pr_playeffect

* Kanal spielen mit TONE PORTAMENTO **********************************

pr_playtpchannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	tst.b	d0
	beq.s	pr_playtpnonewsample	; Irgendein Sample ?
	move.w	d0,(a4)			; Trage Samplenummer ein
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)		; Lautst�rke eintragen
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Repeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playtpchannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playtpchannel2:
	move.w	(a0)+,10(a4)		; Repeatlength eintragen
pr_playtpnonewsample:
	tst.b	d1
	beq.s	pr_playtpnonewperiod	; Irgend ne neue Frequenz ?
pr_playtpnewperiod:
	move.w	2(a4),14(a4)
	subq.w	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),d2
	move.w	d2,16(a4)		; Frequenz eintragen
	bra.s	pr_playtpallowed
pr_playtpnonewperiod:
	tst.w	16(a4)
	bne.s	pr_playtpallowed
	clr.w	14(a4)
	clr.l	26(a4)
pr_playtpallowed:
	bra.w	pr_playeffect

pr_playeffect:
	bsr.w	pr_checkfunkrepeat
	moveq	#0,d0
	move.b	4(a4),d0
	add.b	d0,d0
	lea	pr_normaleffectlist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
pr_playnoeffect:
	rts

pr_normaleffectlist:
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 0
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 1
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 2
	dc.w	pr_preptoneportamento-pr_normaleffectlist	; 3
	dc.w	pr_prepvibrato-pr_normaleffectlist		; 4
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 5
	dc.w	pr_prepvibandvolslide-pr_normaleffectlist	; 6
	dc.w	pr_preptremolo-pr_normaleffectlist		; 7
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 8
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 9
	dc.w	pr_playnoeffect-pr_normaleffectlist		; A
	dc.w	pr_jumptopattern-pr_normaleffectlist		; B
	dc.w	pr_newvolume-pr_normaleffectlist		; C
	dc.w	pr_patternbreak-pr_normaleffectlist		; D
	dc.w	pr_play_e_command-pr_normaleffectlist		; E
	dc.w	pr_newspeed-pr_normaleffectlist			; F

pr_play_e_command:
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#3,d0
	bclr	#0,d0
	lea	pr_e_commandeffectlist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
	
pr_e_commandeffectlist:
	dc.w	pr_setfilter-pr_e_commandeffectlist		; 0
	dc.w	pr_fineslideup-pr_e_commandeffectlist		; 1
	dc.w	pr_fineslidedown-pr_e_commandeffectlist		; 2
	dc.w	pr_setglissandocontrol-pr_e_commandeffectlist	; 3
	dc.w	pr_setvibratowaveform-pr_e_commandeffectlist	; 4
	dc.w	pr_playfinetune-pr_e_commandeffectlist		; 5
	dc.w	pr_jumptoloop-pr_e_commandeffectlist		; 6
	dc.w	pr_settremolowaveform-pr_e_commandeffectlist	; 7
	dc.w	pr_playnoeffect-pr_e_commandeffectlist		; 8
	dc.w	pr_prepretrignote-pr_e_commandeffectlist	; 9
	dc.w	pr_finevolumeslideup-pr_e_commandeffectlist	; A
	dc.w	pr_finevolumeslidedown-pr_e_commandeffectlist	; B
	dc.w	pr_prepnotecut-pr_e_commandeffectlist		; C
	dc.w	pr_prepnotedelay-pr_e_commandeffectlist		; D
	dc.w	pr_preppatterndelay-pr_e_commandeffectlist	; E
	dc.w	pr_prepfunkrepeat-pr_e_commandeffectlist	; F

pr_preppatterndelay:
	cmp.b	#1,pr_patterndelaytime-pr_framecounter+1(a2)
	bge.s	pr_preppatterndelayend
	moveq	#$f,d0
	and.b	5(a4),d0
	addq.b	#1,d0
	move.b	d0,pr_patterndelaytime-pr_framecounter+1(a2)
pr_preppatterndelayend:
	rts

pr_setvibratowaveform:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,50(a4)
	rts

pr_settremolowaveform:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,52(a4)
	rts

pr_setglissandocontrol:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,48(a4)
	rts

pr_playfinetune:
	moveq	#$f,d0
	and.b	5(a4),d0
	lsl.w	#2,d0
	lea	pr_fastperiodlist(pc),a0
	move.l	(a0,d0.w),a0
	moveq	#0,d1
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	move.b	1(a6),d1
	ENDC
	beq.s	pr_playfinetuneend
	subq.b	#1,d1
	add.w	d1,d1
	move.w	(a0,d1.w),2(a4)		; Frequenz eintragen
pr_playfinetuneend:
	rts
	
pr_jumptoloop:
	moveq	#$f,d0
	and.b	5(a4),d0
	beq.s	pr_prepjumptoloop
	addq.b	#1,47(a4)
	cmp.b	47(a4),d0
	blt.s	pr_jumptoloopend
	moveq.l	#0,d0
	move.w	44(a4),d0
	move.w	d0,pr_Patternct-pr_framecounter(a2)
	move.l	pr_Patternpt(pc),a0
	move.l	(a0),d5
	IFEQ	PACKEDSONGFORMAT-YES
	moveq.l	#0,d0
	move.w	60(a4),d0
	ELSE
	lsl.l	#4,d0
	ENDIF
	add.l	d0,d5
	move.l	d5,pr_Currentposition-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts
pr_jumptoloopend:
	clr.w	46(a4)
	rts
pr_prepjumptoloop:
	tst.w	46(a4)
	bne.s	pr_prepjumptoloopend
	move.w	pr_Patternct-pr_framecounter(a2),44(a4)
	IFEQ	PACKEDSONGFORMAT-YES
	move.l	pr_Currentposition(pc),d0
	move.l	pr_Patternpt(pc),a1
	sub.l	(a1),d0
	move.w	d0,60(a4)
	ENDC
	clr.w	46(a4)
pr_prepjumptoloopend:
	rts

pr_prepnotedelay:
	IFEQ	PACKEDSONGFORMAT-YES
	tst.b	57(a4)
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepnotedelayend2

	moveq	#$f,d0
	and.b	5(a4),d0
	bne.s	pr_prepnotedelay2
	move.w	#$fff,18(a4)
	bra.w	pr_checknotedelay2
pr_prepnotedelay2:
	move.w	d7,d0
	not.b	d0
	and.b	d0,pr_dmacon-pr_framecounter+1(a2)
	clr.w	18(a4)
	rts
pr_prepnotedelayend2:
	move.w	#$fff,18(a4)
	rts

pr_prepretrignote:
	clr.w	18(a4)
	IFEQ	PACKEDSONGFORMAT-YES
	tst.b	56(a4)
	ELSE
	tst.w	(a6)
	ENDC
	bne.s	pr_prepretrignoteend
	bra.w	pr_checkretrignote2	
pr_prepretrignoteend:
	rts

pr_prepnotecut:
	clr.w	18(a4)
	moveq	#$f,d0
	and.b	5(a4),d0
	tst.b	d0
	bne.s	pr_prepnotecutend
	clr.w	12(a4)
pr_prepnotecutend:
	rts
	
pr_finevolumeslideup:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	12(a4),d1
	add.w	d0,d1
	moveq	#64,d0
	cmp.w	d0,d1
	bls.s	pr_finevolumeslideup2
	move.w	d0,d1
pr_finevolumeslideup2:
	move.w	d1,12(a4)
	rts

pr_finevolumeslidedown:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	12(a4),d1
	sub.w	d0,d1
	bpl.s	pr_finevolumeslidedown2
	moveq	#0,d1
pr_finevolumeslidedown2:
	move.w	d1,12(a4)
	rts

pr_fineslideup:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	2(a4),d1
	sub.w	d0,d1
	cmp.w	#108,d1
	bge.s	pr_fineslideup2
	move.w	#108,d1
pr_fineslideup2:
	move.w	d1,2(a4)
	rts

pr_fineslidedown:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	2(a4),d1
	add.w	d0,d1
	cmp.w	#907,d1
	bls.s	pr_fineslidedown2
	move.w	#907,d1
pr_fineslidedown2:
	move.w	d1,2(a4)
	rts

pr_setfilter:
	btst	#0,5(a4)
	beq.s	pr_setfilteron
pr_setfilteroff:
	bset	#1,$bfe001
	rts
pr_setfilteron:
	bclr	#1,$bfe001
	rts

pr_prepvibandvolslide:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_prepvibandvolslide2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepvibandvolslide2
	clr.w	18(a4)
pr_prepvibandvolslide2:
	rts

pr_preptoneportamento:
	tst.b	5(a4)
	beq.s	pr_preptoneportamento2
	move.w	4(a4),22(a4)
pr_preptoneportamento2:
	rts

pr_prepvibrato:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_prepvibrato2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepvibrato0
	clr.w	18(a4)
pr_prepvibrato0:
	move.b	5(a4),d0
	move.b	d0,d1
	lsr.b	#4,d1
	beq.s	pr_prepvibrato1
	move.b	d1,24(a4)
pr_prepvibrato1:
	and.b	#$f,d0
	beq.s	pr_prepvibrato2
	move.b	d0,25(a4)
pr_prepvibrato2:
	rts

pr_preptremolo:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_preptremolo2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_preptremolo0
	clr.w	18(a4)
pr_preptremolo0:
	move.w	12(a4),20(a4)
	move.b	5(a4),d0
	move.b	d0,d1
	lsr.b	#4,d1
	beq.s	pr_preptremolo1
	move.b	d1,30(a4)
pr_preptremolo1:
	and.b	#$f,d0
	beq.s	pr_preptremolo2
	move.b	d0,31(a4)
pr_preptremolo2:
	rts

pr_newvolume:
	move.b	5(a4),d0
	cmp.b	#64,d0
	bls.s	pr_newvolumeend
	moveq	#64,d0
pr_newvolumeend:
	move.b	d0,13(a4)
	rts

pr_newspeed:
	move.b	5(a4),d0
	tst.b	d0
	bne.s	pr_newspeed2
	moveq	#1,d0
pr_newspeed2:
	move.b	d0,pr_speed-pr_framecounter+1(a2)
	rts

pr_patternbreak:
	moveq	#0,d0
	move.b	5(a4),d0
	add.w	#64,d0
	move.w	d0,pr_Patternct-pr_framecounter(a2)
	addq.w	#1,pr_patternhasbeenbreaked-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts
		
pr_jumptopattern:
	moveq.l	#0,d0
	move.b	5(a4),d0
	subq.b	#1,d0
	bpl.s	pr_playjumptopattern2
	move.w	#128,d0
pr_playjumptopattern2:
	move.b	d0,pr_currentpattern-pr_framecounter+1(a2)
	lsl.l	#2,d0
	lea	pr_Patternpositions(pc),a0
	add.l	a0,d0
	move.l	d0,pr_Patternpt-pr_framecounter(a2)
	move.w	#64,pr_Patternct-pr_framecounter(a2)
	addq.w	#1,pr_patternhasbeenbreaked-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts

* Control FX every frame **********************************************

pr_checkeffects:
	moveq	#1,d7
	lea	$a0(a5),a3
	lea	pr_Channel0(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC
	
	moveq	#2,d7
	lea	$b0(a5),a3
	lea	pr_Channel1(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	moveq	#4,d7
	lea	$c0(a5),a3
	lea	pr_Channel2(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	moveq	#8,d7
	lea	$d0(a5),a3
	lea	pr_Channel3(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	lea	pr_int(pc),a0
	move.l	pr_Vectorbasept(pc),a1
	move.l	a0,$78(a1)
	move.b	#$19,$bfde00
	rts

***********************************************************************

pr_checknotchannel:
	rts

pr_check_e_commands:
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#3,d0
	bclr	#0,d0
	lea	pr_E_Command_checklist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
	
pr_Effectchecklist:
	dc.w	pr_checkarpeggio-pr_Effectchecklist		; 0
	dc.w	pr_checkperiodslideup-pr_Effectchecklist	; 1
	dc.w	pr_checkperiodslidedown-pr_Effectchecklist	; 2
	dc.w	pr_checktoneportamento-pr_Effectchecklist	; 3
	dc.w	pr_checkvibrato-pr_Effectchecklist		; 4
	dc.w	pr_checktpandvolslide-pr_Effectchecklist	; 5
	dc.w	pr_checkvibandvolslide-pr_Effectchecklist	; 6
	dc.w	pr_checktremolo-pr_Effectchecklist		; 7
	dc.w	pr_checknotchannel-pr_Effectchecklist		; 8
	dc.w	pr_checknotchannel-pr_Effectchecklist		; 9
	dc.w	pr_checkvolumeslide-pr_Effectchecklist		; A
	dc.w	pr_checknotchannel-pr_Effectchecklist		; B
	dc.w	pr_checknotchannel-pr_Effectchecklist		; C
	dc.w	pr_checknotchannel-pr_Effectchecklist		; D
	dc.w	pr_check_e_commands-pr_Effectchecklist		; E
	dc.w	pr_checknotchannel-pr_Effectchecklist		; F

pr_E_Command_checklist:
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 0
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 1
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 2
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 3
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 4
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 5
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 6
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 7
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 8
	dc.w	pr_checkretrignote-pr_E_Command_checklist	; 9
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; A
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; B
	dc.w	pr_checknotecut-pr_E_Command_checklist		; C
	dc.w	pr_checknotedelay-pr_E_Command_checklist	; D
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; E
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; F

pr_prepfunkrepeat:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.b	d0,33(a4)
	tst.b	d0
	bne.s	pr_checkfunkrepeat
	rts
pr_checkfunkrepeat:
	move.w	32(a4),d0
	beq.s	pr_checkfunkrepeatend
	lea	pr_FunkTable(pc),a0
	move.b	(a0,d0.w),d0
	move.b	35(a4),d1
	add.b	d0,d1
	bmi.s	pr_checkfunkrepeat2
	move.b	d1,35(a4)
	rts
pr_checkfunkrepeat2:
	clr.b	35(a4)

	move.l	36(a4),d0
	beq.s	pr_checkfunkrepeatend
	move.l	d0,d2
	moveq.l	#0,d1
	move.w	10(a4),d1
	add.l	d1,d0
	add.l	d1,d0
	move.l	40(a4),a0
	addq.l	#1,a0
	cmp.l	d0,a0
	blo.s	pr_checkfunkrepeatok
	move.l	d2,a0
pr_checkfunkrepeatok:
	move.l	a0,40(a4)
	moveq	#-1,d0
	sub.b	(a0),d0
	move.b	d0,(a0)
pr_checkfunkrepeatend:
	rts

pr_checknotedelay:
	move.w	18(a4),d1
	addq.w	#1,d1
	cmp.w	d0,d1
	bne.s	pr_checknotedelayend
pr_checknotedelay2:
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d0
	move.w	(a4),d0
	subq.w	#1,d0
	lsl.w	#5,d0
	lea	pr_Sampleinfos(pc),a0
	add.l	d0,a0
	move.w	2(a4),6(a3)
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_checknotedelay3
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_checknotedelay3:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
pr_checknotedelayend:
	move.w	d1,18(a4)
	rts

pr_checkretrignote:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	18(a4),d1
	addq.w	#1,d1
	cmp.w	d0,d1
	bne.s	pr_checkretrignoteend
pr_checkretrignote2:
	moveq	#0,d1
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	move.w	(a4),d0
	subq.w	#1,d0
	lsl.w	#5,d0
	lea	pr_Sampleinfos(pc),a0
	move.l	(a0,d0.w),(a3)
	move.w	4(a0,d0.w),4(a3)
pr_checkretrignoteend:
	move.w	d1,18(a4)
	rts

pr_checknotecut:
	moveq	#$f,d0
	and.b	5(a4),d0
	addq.w	#1,18(a4)
	move.w	18(a4),d1
	cmp.w	d0,d1
	blt.s	pr_checknotecutend
	clr.w	12(a4)
	clr.w	54(a4)
pr_checknotecutend:
	rts

pr_checkarpeggio:
	tst.b	5(a4)
	bne.s	pr_checkarpeggio0
	rts
pr_checkarpeggio0:
	move.w	(a2),d0
	lea	pr_Arpeggiofastdivisionlist(pc),a1
	move.b	(a1,d0.w),d0
	beq.s	pr_checkarpeggio2
	cmp.b	#2,d0
	beq.s	pr_checkarpeggio1
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#4,d0
	bra.s	pr_checkarpeggio3
pr_checkarpeggio2:
	move.w	2(a4),6(a3)
	rts
pr_checkarpeggio1:
	moveq	#$f,d0
	and.b	5(a4),d0
pr_checkarpeggio3:
	asl.w	#1,d0
	move.w	(a4),d1
	lsl.w	#5,d1
	lea	pr_Sampleinfos+SAMPLEFINETUNEOFFSET(pc),a0
	move.l	(a0,d1.w),a0
	move.w	2(a4),d1
	lea	pr_Arpeggiofastlist(pc),a1
	moveq.l	#0,d2
	move.b	(a1,d1.w),d2
	add.b	d2,d2
	add.l	d2,a0
	moveq	#36,d7
pr_checkarpeggioloop:
	cmp.w	(a0)+,d1
	bhs.s	pr_checkarpeggio4
	dbf	d7,pr_checkarpeggioloop
	rts
pr_checkarpeggio4:
	subq.l	#2,a0
	move.w	(a0,d0.w),6(a3)
	rts

pr_checktpandvolslide:
	bsr.w	pr_checkvolumeslide
	moveq	#0,d2
	move.b	23(a4),d2
	move.w	26(a4),d0
	move.w	28(a4),d1
	bsr.s	pr_checktoneportamento2
	move.w	14(a4),26(a4)
	rts
	
pr_checktoneportamento:
	moveq	#0,d2
	move.b	5(a4),d2
	bne.s	pr_checktoneportamento1
	move.b	23(a4),d2
pr_checktoneportamento1:
	move.w	14(a4),d0
	move.w	16(a4),d1
pr_checktoneportamento2:
	cmp.w	d0,d1
	bgt.s	pr_checktoneportamentoplus
	blt.s	pr_checktoneportamentominus
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentoplus:
	add.w	d2,d0
	cmp.w	d0,d1
	bgt.s	pr_checktoneportamentoend
	move.w	d1,d0
	move.w	d1,14(a4)
	move.w	d1,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d1,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentominus:
	sub.w	d2,d0
	cmp.w	d0,d1
	blt.s	pr_checktoneportamentoend
	move.w	d1,d0
	move.w	d1,14(a4)
	move.w	d1,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d1,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentoend:
	move.w	d0,14(a4)
	move.w	d0,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d0,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts	
pr_savetpvalues:
	move.l	14(a4),26(a4)
	rts
pr_checktoneportamentoglissando:
	move.w	(a4),d1
	lsl.w	#5,d1
	lea	pr_Sampleinfos+SAMPLEFINETUNEOFFSET(pc),a0
	move.l	(a0,d1.w),a0
	lea	pr_Arpeggiofastlist(pc),a1
	moveq.l	#0,d2
	move.b	(a1,d0.w),d2
	add.w	d2,d2
	add.l	d2,a0
	moveq	#0,d3
	moveq	#36*2,d1
pr_checktoneportamentoglissandoloop:
	cmp.w	(a0,d3.w),d0
	bhs.s	pr_checktoneportamentoglissando2
	addq.w	#2,d3
	cmp.w	d1,d3
	blo.b	pr_checktoneportamentoglissandoloop
	moveq	#35*2,d3
pr_checktoneportamentoglissando2:
	move.w	(a0,d3.w),6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts

pr_checkvolumeslide:
	moveq	#0,d0
	move.b	5(a4),d0
	move.w	d0,d1
	lsr.b	#4,d1
	beq.s	pr_checkvolumeslidedown
	move.w	12(a4),d2
	add.w	d1,d2
	bmi.s	pr_checkvolumeslide0
	moveq	#64,d0
	cmp.w	d0,d2
	bgt.s	pr_checkvolumeslide64
	move.w	d2,12(a4)
	move.w	d2,54(a4)
	rts
pr_checkvolumeslidedown:	
	and.b	#$f,d0
	move.w	12(a4),d2
	sub.w	d0,d2
	bmi.s	pr_checkvolumeslide0
	moveq	#64,d0
	cmp.w	d0,d2
	bgt.s	pr_checkvolumeslide64
	move.w	d2,12(a4)
	move.w	d2,54(a4)
	rts
pr_checkvolumeslide64:
	move.w	d0,12(a4)
	move.w	d0,54(a4)
	rts
pr_checkvolumeslide0:
	clr.w	12(a4)
	clr.w	54(a4)
	rts
	
pr_checkperiodslidedown:
	moveq	#0,d0
	move.b	5(a4),d0
	add.w	d0,2(a4)
	cmp.w	#907,2(a4)
	bls.s	pr_checkperiodslidedown2
	move.w	#907,2(a4)
pr_checkperiodslidedown2:
	move.w	2(a4),6(a3)
	rts

pr_checkperiodslideup:
	moveq	#0,d0
	move.b	5(a4),d0
	sub.w	d0,2(a4)
	cmp.w	#108,2(a4)
	bge.s	pr_checkperiodslideup2
	move.w	#108,2(a4)
pr_checkperiodslideup2:
	move.w	2(a4),6(a3)
	rts

pr_checkvibandvolslide:
	bsr.w	pr_checkvolumeslide
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	25(a4),d0
	move.b	24(a4),d1
	bra.s	pr_checkvibrato4

pr_checkvibrato:
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	5(a4),d0	; Tiefe
pr_checkvibrato2:
	move.w	d0,d1		; Geschwindigkeit
	and.w	#$f,d0
	bne.s	pr_checkvibrato3
	move.b	25(a4),d0
pr_checkvibrato3:
	lsr.b	#4,d1
	bne.s	pr_checkvibrato4
	move.b	24(a4),d1
pr_checkvibrato4:
	move.w	18(a4),d2	;Position
	lsr.w	#2,d2
	and.w	#$1f,d2
	move.w	50(a4),d3
	beq.s	pr_checkvibratosine
	btst	#0,d3
	bne.s	pr_checkvibratorampdown
	move.b	#255,d3
	bra.s	pr_checkvibratoset
pr_checkvibratorampdown:
	lsl.b	#3,d2
	tst.b	19(a4)
	bmi.s	pr_checkvibratorampdown2
	move.b	#255,d3
	sub.b	d2,d3
	bra.s	pr_checkvibratoset
pr_checkvibratorampdown2:
	move.b	d2,d3
	bra.s	pr_checkvibratoset
pr_checkvibratosine:
	lea	pr_VibratoTable(pc),a0
	moveq	#0,d3
	move.b	(a0,d2.w),d3
pr_checkvibratoset:
	mulu.w	d0,d3
	lsr.w	#7,d3
	move.w	2(a4),d2
	tst.b	19(a4)
	bpl.s	pr_checkvibratoneg
	add.w	d3,d2
	bra.s	pr_checkvibrato5
pr_checkvibratoneg:
	sub.w	d3,d2
pr_checkvibrato5:
	move.w	d2,6(a3)
	lsl.w	#2,d1
	add.b	d1,19(a4)
	rts

pr_checktremolo:
	moveq	#0,d0
	moveq.l	#0,d1
	move.b	5(a4),d0	; Tiefe
pr_checktremolo2:
	move.w	d0,d1		; Geschwindigkeit
	and.w	#$f,d0
	bne.s	pr_checktremolo3
	move.b	31(a4),d0
pr_checktremolo3:
	lsr.b	#4,d1
	bne.s	pr_checktremolo4
	move.b	30(a4),d1
pr_checktremolo4:
	move.w	18(a4),d2	;Position
	lsr.w	#2,d2
	and.w	#$1f,d2
	move.w	52(a4),d3
	beq.s	pr_checktremolosine
	btst	#0,d3
	bne.s	pr_checktremolorampdown
	move.b	#255,d3
	bra.s	pr_checktremoloset
pr_checktremolorampdown:
	lsl.b	#3,d2
	tst.b	19(a4)
	bmi.s	pr_checktremolorampdown2
	move.b	#255,d3
	sub.b	d2,d3
	bra.s	pr_checktremoloset
pr_checktremolorampdown2:
	move.b	d2,d3
	bra.s	pr_checktremoloset
pr_checktremolosine:
	lea	pr_VibratoTable(pc),a0
	moveq	#0,d3
	move.b	(a0,d2.w),d3
pr_checktremoloset:
	mulu.w	d0,d3
	lsr.w	#6,d3
	move.w	20(a4),d2
	tst.b	19(a4)
	bpl.s	pr_checktremoloneg
	add.w	d3,d2
	moveq	#64,d4
	cmp.w	d4,d2
	bls.s	pr_checktremolo5
	move.w	d4,d2
	bra.s	pr_checktremolo5
pr_checktremoloneg:
	sub.w	d3,d2
	bpl.s	pr_checktremolo5
	moveq	#0,d2
pr_checktremolo5:
	move.w	d2,54(a4)
	lsl.w	#2,d1
	add.b	d1,19(a4)
	rts

pr_VibratoTable:	
	dc.b	0,24,49,74,97,120,141,161
	dc.b	180,197,212,224,235,244,250,253
	dc.b	255,253,250,244,235,224,212,197
	dc.b	180,161,141,120,97,74,49,24
pr_FunkTable:
	dc.b	0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128
	
* Variables ***********************************************************

pr_module:			dc.l	0
pr_startposition:		dc.w	0
pr_speed:			dc.w	6
pr_highestpattern:		dc.w	0
pr_currentpattern:		dc.w	0
pr_framecounter:		dc.w	0
pr_patterndelaytime:		dc.w	0
pr_patternhasbeenbreaked:	dc.w	0
pr_Patternpositions:		ds.l	128
pr_Patternpt:			dc.l	0
pr_Currentposition:		dc.l	0
pr_Patternct:			dc.w	0
pr_oldledvalue:			dc.w	0
pr_dontcalcnewposition:		dc.w	0
pr_commandnotedelay:		dc.w	0
pr_old78:			dc.l	0
pr_Vectorbasept:		dc.l	0
pr_Channel0:			dc.w	1
				ds.w	30
pr_Channel1:			dc.w	1
				ds.w	30
pr_Channel2:			dc.w	1
				ds.w	30
pr_Channel3:			dc.w	1
				ds.w	30
pr_dmacon:			dc.w	$8000

pr_Arpeggiofastlist:		ds.b	1000
pr_Arpeggiofastdivisionlist:	ds.b	$100
pr_fastperiodlist:		ds.l	16
pr_Sampleinfos:			ds.b	32*32

pr_periods:
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
pr_Arpeggiofastlistperiods:
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

* END OF PRORUNNER ***************************************************


pr_data:
incbin	"data/mod.blue socks_p"

sinus32:
dc.w  1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17, 18, 19, 21, 22, 23, 24
dc.w  25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 34, 35, 36, 36, 37, 37, 38
dc.w  38, 39, 39, 39, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 39, 39, 39
dc.w  38, 38, 37, 37, 36, 36, 35, 34, 34, 33, 32, 31, 30, 29, 28, 27, 26
dc.w  25, 24, 23, 22, 21, 19, 18, 17, 16, 14, 13, 12, 10, 9, 8, 6, 5, 3
dc.w  2, 1,-1,-2,-3,-5,-6,-8,-9,-10,-12,-13,-14,-16,-17,-18,-19,-21,-22
dc.w -23,-24,-25,-26,-27,-28,-29,-30,-31,-32,-33,-34,-34,-35,-36,-36,-37
dc.w -37,-38,-38,-39,-39,-39,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-39
dc.w -39,-39,-38,-38,-37,-37,-36,-36,-35,-34,-34,-33,-32,-31,-30,-29,-28
dc.w -27,-26,-25,-24,-23,-22,-21,-19,-18,-17,-16,-14,-13,-12,-10,-9,-8
dc.w -6,-5,-3,-2,-1
blk.b	360*3,0


mainmem:
blk.l	200000/4,0
e:
;------------------------------------------------------------------------
;memory curiousscroller
copperlist1=mainmem
planesize=200*64*2	;*2=wall
wall=1*150*64

copperlistlength=8500
scrollfieldlength=17*50+4
scrolldatatlength=[4*17+4*2+2*30+2*29]*2

copperlist2=copperlist1+copperlistlength
copperlist3=copperlist2+copperlistlength

scrollfield=copperlist3+copperlistlength
scrolldatat1=scrollfield+scrollfieldlength
scrolldatat2=scrolldatat1+scrolldatatlength
scrolldatat3=scrolldatat2+scrolldatatlength

plane1=scrolldatat3+scrolldatatlength+wall
plane2=plane1+planesize*2
plane3=plane2+planesize*2
;------------------------------------------------------------------------
;memory planeplasmaroutine
n1=mainmem


animpics=n1
n2=n1+3*32*4*120

animpicsend=n2
plane21=n2
n3=n2+3*2*32*64

plane22=n3
n4=n3+3*2*32*64

plane23=n4
n5=n4+3*2*32*64

calcplane=n5
n6=n5+256*64

;------------------------------------------------------------------------
;memory sinescroll
n31=mainmem

n32=n31+50*64	;wall
plane31=n32
n33=n32+2*300*64

plane32=n33
n34=n33+2*300*64

plane33=n34
n35=n34+2*300*64+50*64	;+wall


introut3:
movem.l	d0-d7/a0-a6,-(a7)

	lea	$dff000,a5	;planecls
	move.l	showplane3,d0
	move.l	d0,bpl1pth(a5)
	move.w	#%0001001000000000,bplcon0(a5)

;	bsr.w	planecls3
;	jsr	turner4
;	jsr	maskscroller
;	jsr	drawline4
;	bsr.w	switchplanes3
	jsr	realfade
	move.l	faded,$dff180
	jsr	pr_music
	jsr	commander


	movem.l	(a7)+,d0-d7/a0-a6

move.w	#0,intwait3

	move.w	#%0000000001100000,$dff09c
	rte

oldint3:		dc.l	0
switchmark3:	dc.l	-1

switchplanes3:
	tst.w	switchmark3
	beq.b	do32
	bpl.b	do33
do31:
	move.w	#0,switchmark3
	move.l	#plane31,clearplane3
	move.l	#plane32,showplane3
	move.l	#plane33,pointplane3
	rts
do32:
	move.w	#1,switchmark3
	move.l	#plane31,pointplane3
	move.l	#plane32,clearplane3
	move.l	#plane33,showplane3
	rts
do33:
	move.w	#-1,switchmark3
	move.l	#plane31,showplane3
	move.l	#plane32,pointplane3
	move.l	#plane33,clearplane3
	rts
;--------


planecls3:
	lea	$dff000,a5
	move.l	clearplane3,d0
	add.l	#0*64+4,d0
	move.l	d0,BLTDPTH(A5)
	move.w	#28,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#256*64+18,BLTSIZE(A5)

;	lea	$dff000,a5
;	move.l	clearplane,d0
;	add.l	#50*64+12,d0
;	move.l	d0,BLTDPTH(A5)
;	move.w	#28+14,BLTDMOD(A5)
;	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
;	move.w	#156*64+11,BLTSIZE(A5)

rts
moveq	#0,d0
moveq	#0,d1
moveq	#0,d2
moveq	#0,d3
moveq	#0,d4
moveq	#0,d5
moveq	#0,d6
move.l	d0,a0
move.l	d0,a1

moveq	#99,d7			;163+110=273=screen y
move.l	clearplane3,a2
lea	156*64+4(a2),a2

maincls2l1:
	movem.l	d0-d6/a0-a1,(a2)
	lea	64(a2),a2
	dbf	d7,maincls2l1
rts






showplane3:	dc.l	0
clearplane3:	dc.l	0
pointplane3:	dc.l	0





drawline4:
lea	$dff000,a5

move.w	#223,d5
lea	scrolldatat,a1

;lea	maskdata,a3
move.l	maskpoint,a3


bwait2:
btst	#14,dmaconr(a5)
bne.b	bwait2

	MOVE.l	#-1,bltafwm(a5)
	MOVE.w	#64*1,bltcmod(a5)
	MOVE.w	#64*1,bltdmod(a5)
	MOVE.l	#$00008000,bltbdat(a5);b+a dat


draw4loop:

moveq	#90,d0
add.w	d0,d0
move.l	d0,d2
moveq	#127,d1
moveq	#127,d3
add.w	(a1)+,d0
add.w	(a1)+,d1
add.w	(a1)+,d2
add.w	(a1)+,d3
move.w	(a3)+,d6

;------------------------------------------------------------------------
	move.l	pointplane3,a0	;planeadress
	lea	octants4(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	draw4l1		;point 2 is greater--> okay
;	beq	draw4l2		;points equal, dont draw-->exit
;	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

draw4l1:	


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
	MOVE.L	(A2),D4		;get the pussy
	ROR.L	#3,D0		;d0.w=d0-w/8
	LEA	(A0,D0.W),A2	;a2=screenptr+x1-offset
	ROR.L	#1,D0		;d0/2 (d0.w = x1/16
	AND.L	#$F0000000,D0	;bit 12-15 =x1bit 0-3
	OR.L	D0,D4		;d4=octant or x1bits
	MOVE.W	D1,D0		;d0=y1
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
	add.W	d3,D3		;d3=lodiff*2
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
	BGE.S	.NOSIGN		;branch if lodiff*2 >hidiff
	OR.B	#$40,D4		;set bit 6	
.NOSIGN:
	add.w	d0,d0
	MOVE.W	D0,D1		;d1=lodiff*4
	LSL.W	#2,D2		;d2=hidiff*4
	SUB.W	D2,D1		;d1=(lodiff*4) - (hidiff*4) 
	ADDQ.W	#4,D2		;d2=hidiff*4+4
	LSL.W	#4,D2		;d2=(hidiff*4+4)*16
	ADDQ.W	#2,D2		;d2=(hidiff*4+4)*16+2

blitwait4:
btst	#14,dmaconr(a5)
bne.b	blitwait4


	MOVE.w	d6,bltbdat(a5)
	movem.w	d0-d1,bltbmod(a5)

	MOVE.l	a2,bltcpth(a5)
	MOVE.w	d3,bltaptl(a5)
	MOVE.l	a2,bltdpth(a5)
	MOVE.l	d4,bltcon0(a5)
	MOVE.w	d2,bltsize(a5)
draw4l2:

;------------------------------------------------------------------------


dbf	d5,draw4loop

bwait1:	
btst	#14,dmaconr(a5)
bne.b	bwait1


rts



OCTANTS4:;        01234567012345670123456701234567
	DC.L	%00001011110010101111000000010001
	DC.L	%00001011110010101111000000000001
	DC.L	%00001011110010101111000000010101
	DC.L	%00001011110010101111000000001001




turn5x:	dc.w	0
turn5z:	dc.w	0


;***********************************************************




intwait3:	dc.w	0

blk.w	32,0

maskdata:	
blk.w	224,0
blk.w	32,0
maskdataend:
blk.w	224,0
blk.w	32,0

maskpoint:	dc.l	maskdata



scrolldatat:
blk.b	225*8,8
scrolldatatend:
	
turnadd4z:	dc.w	2*4

sin2pos2:	dc.w	0


turner4:
	move.w	turn5z,a0
	add.w	turnadd4z,a0
	cmp.w	#1436,a0
	ble.b nolauf4z
	sub.w	#1440,a0
nolauf4z:
	move.w	a0,turn5z

	move.w	sin2pos2,d0
	addq.w	#6,d0
	cmp.w	#360,d0
	ble.b sin2move
	sub.w	#360,d0
sin2move:
	move.w	d0,sin2pos2

lea	sinus32,a1
lea	(a1,d0.w),a1


turner41:
	lea	scrolldatat,a4	;koordinaten
	lea	d3sinus,a6	;sinus/cosinus
	move.w	#223,d0
	move.w	#-110,d1	;all x1/x2
	moveq	#8,d2		;all y1
	move.w	#-8,a2		;all y2
turnrout41:
;-------------
	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
;	move.l	(a3)+,d3	;d3:hi=x , lo=y

	move.w	d2,d3		;y1
	move.w	d1,d4		;x1
;addsin
add.w	(a1),d3

;	move.w	d3,d4		;d4=y
;	swap	d3		;d3.w=x

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
	move.w	d3,(a4)+
	move.w	d6,(a4)+


;-------------
	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
;	move.l	(a3)+,d3	;d3:hi=x , lo=y
	move.w	a2,d3		;y2
	move.w	d1,d4		;x2

;addsin
add.w	(a1)+,d3

;	move.w	d3,d4		;d4=y
;	swap	d3		;d3.w=x

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
	move.w	d3,(a4)+
	move.w	d6,(a4)+


;-------------

	addq.w	#1,d1

	dbf	d0,turnrout41

;bwait2zz:
;btst	#14,dmaconr(a5)
;bne	bwait2zz
;move.w	#0,$dff180
	rts
;*****




font2:
incbin	"data/curiousfont3_con"

scrollputwait:	dc.w	32
maskscroller:
	move.l	maskpoint,a0
	addq.l	#8,a0
	cmp.l	#maskdataend,a0
	bne.b	nomaskrestart
	lea	maskdata,a0
nomaskrestart:
	move.l	a0,maskpoint
	subq.w	#4,scrollputwait
	bne.b	maskscrollfin
	move.w	#32,scrollputwait
	lea	-32*2(a0),a0

	move.w	textpoint3,d0
	addq.w	#1,textpoint3
	lea	text,a1
	moveq	#0,d1
	move.b	(a1,d0.w),d1
	bpl	no3dscrollend
	move.w	#1,comsleep
	moveq	#64,d1
no3dscrollend:
	sub.b	#64,d1
	lsl.w	#6,d1
	lea	font2+64,a1
	lea	(a1,d1.w),a1

	moveq	#31,d0
maskcopyloop:
	move.w	-(a1),(224+32)*2(a0)
	move.w	(a1),(a0)+
	dbf	d0,maskcopyloop

maskscrollfin:
rts

textpoint3:	dc.w	0
text:	dc.b	"@ABYSS@@@TRAVELLERS@ON@THE@ENDLESS@WASTES@"
	DC.B	"IN@SINGLE@ORBITS@@@@@@@@@@",-1


	
