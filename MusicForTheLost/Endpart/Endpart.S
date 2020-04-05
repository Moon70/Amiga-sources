execbase=4
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
intena=$09a
startlist=38
openlibrary=-30-522

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c

bplcon0=$100
bplcon1=$102
bplcon2=$104
bpl1pth=$0e0
bpl1ptl=$0e2
bpl2pth=$0e4
bpl2ptl=$0e6
bpl3pth=$0e8
bpl4pth=$0ec
bpl5pth=$0f0
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094
dmaconr=$002

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

a:
start:
	move.l	execbase,a6
	jsr	forbid(a6)
	lea	$dff000,a5
	move.w	#%0000001111100000,dmacon(a5)
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003000d0,ddfstrt(a5)	;strt+stop!
	move.w	#%0000011000000000,bplcon0(a5)
	move.w	#$0000,bplcon1(a5)
	move.w	#%0000000001000000,bplcon2(a5)
	move.l	#$004e0056,bpl1mod(a5)	;1mod+2mod!

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	#3*4,turnaddx
	move.w	#0*4,turnaddy	;disable in turner-routine
	move.w	#1*4,turnaddz

jsr	turner
jsr	nextcol
jsr	nextobj
;	move.w	#0*4,turnaddx
;	move.w	#0*4,turnaddy	;disable in turner-routine
;	move.w	#0*4,turnaddz

;	move.w	#$0000,$180(a5)
;	move.w	#$0f00,$182(a5)
;	move.w	#$00f0,$184(a5)
;	move.w	#$000f,$186(a5)
;	move.w	#$0fff,$188(a5)
;	move.w	#$0f0f,$18a(a5)
;	move.w	#$0ff0,$18c(a5)
;	move.w	#$0888,$18e(a5)
	lea	$dff180,a0
	lea	logo,a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+

jsr	textcalc
	move.l	#pr_data,pr_module
	jsr	pr_init

	move.w	#%0100000001111000,intena(a5)
	bsr.w	switchplanes
	move.l	$6c,oldint
;	move.l	#verticalblank,$6c
	move.l	#waitblankrout,$6c
	move.w	#%1100000000100000,intena(a5)
vertwait:
tst.w	waitblank
beq	vertwait
	move.l	worklist,cop1lch(a5)
	bset.b	#1,copcon(a5)

	move.w	#0,copjmp1(a5)

	move.w	#%1000001111000000,dmacon(a5)
	
	jsr	turner
	jsr	hidesort

	move.l	#0,$dff144
	move.l	#0,$dff14c
	move.l	#0,$dff154
	move.l	#0,$dff15c
	move.l	#0,$dff164
	move.l	#0,$dff16c
	move.l	#0,$dff174
	move.l	#0,$dff17c
wait:
	btst.b	#10,$dff016
	beq	wait

	move.w	#0,intcount
	jsr	scrollup2
	jsr	printline
swapsleep:
	cmp.w	#2,intcount
	blt	swapsleep

	btst	#6,ciaapra
;	bne.w wait
	bra.w wait



back:	move.l	oldint,$6c
	jsr	pr_end
	move.l	execbase,a6
	lea	$dff000,a5
bwait0:	
btst	#14,dmaconr(a5)
bne	bwait0

	lea	grname,a1
	moveq	#0,d0
	jsr	openlibrary(a6)
	move.l	d0,a4
	move.l	startlist(a4),cop1lch(a5)
	clr.w	copjmp1(a5)

	move.w	#%1000001111100000,dmacon(a5)
	move.w	#%1000000000001000,intena(a5)
	jsr	permit(a6)
	moveq	#0,d0
	rts

waitblank:	dc.w	0

waitblankrout:
	btst.b	#5,$01e+1+$dff000
	beq	noverticalblank
	move.w	#1,waitblank
	move.l	#verticalblank,$6c
	move.w	#%0000000001110000,$09c+$dff000
	rte


verticalblank:
	btst.b	#5,$01e+1+$dff000
	beq	noverticalblank

	movem.l	d0-d7/a0-a6,-(a7)

	bsr	switchplanes
	move.l	worklist,d0
	move.l	showlist,d1
	move.l	d1,worklist
	move.l	d1,listpoint
	move.l	d0,showlist

vertcont:
	lea	$dff000,a5
	move.w	#%0101011000000000,bplcon0(a5)

	move.l	clearplane,d0
	moveq	#0,d1
	move.w	vecplanepos,d1

	move.w	d1,d2
	not.b	d2
	lsl.b	#4,d2
	move.b	d2,bplcon1(a5)
	lsr.w	#3,d1
	add.l	d1,d0
	move.l	d0,bpl2pth(a5)
	add.l	#64,d0
	move.l	d0,bpl4pth(a5)

	move.l	#logo+2*8-2,d0
	move.l	d0,bpl1pth(a5)
	add.l	#40,d0
	move.l	d0,bpl3pth(a5)
	add.l	#40,d0
	move.l	d0,bpl5pth(a5)

	lea	$dff190,a0
	lea	objcol,a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+

	jsr	drawline
	jsr	turner
	jsr	hidesort
	jsr	mainplanecls2
	jsr	pr_music

	addq.w	#1,vecplanepos
	cmp.w	#$4f8,vecplanepos
	bne	nonextobj
	move.w	#$340,vecplanepos

	jsr	nextcol
	jsr	nextobj

nonextobj:
	lea	$dff000,a5
	move.l	worklist,cop1lch+$dff000
	movem.l	(a7)+,d0-d7/a0-a6
	move.w	#0,intwait
	addq.w	#1,intcount

intback:
noverticalblank:
	move.w	#%0000000001110000,$09c(a5)
	rte

oldint:		dc.l	0
intcount:	dc.w	0
vecplanepos:	dc.w	$340
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

;plane1:	blk.l	2*256*64/4,$ffffffff
;plane2:	blk.l	2*256*64/4,$ffffffff
;plane3:	blk.l	2*256*64/4,$ffffffff

plane1:	blk.l	2*256*64/4,0
plane2:	blk.l	2*256*64/4,0
plane3:	blk.l	2*256*64/4,0

calcplane:	blk.l	256*64/4,0;$ffffffff


turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0

linemask:	dc.w	$ffff

;------------------------------------------------------------------------
turner:	;last optimizing:92-08-26
	move.w	turnx,a1
	add.w	turnaddx,a1
	cmp.w	#1436,a1
	ble nolaufx
	sub.w	#1440,a1
nolaufx:
	move.w	a1,turnx

	move.w	turny,a2
	add.w	turnaddy,a2
	cmp.w	#1436,a2
	ble nolaufy
	sub.w	#1440,a2
nolaufy:
	move.w	a2,turny

	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz


turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sinus,a6	;sinus/cosinus
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


;********
move.w	d6,6(a4,d0.w)
	subq.w	#8,d0
	bpl	turnrout1
	rts
;********


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
	swap	d3
rol.l	#1,d3
	sub.l	d7,d6		;d6=z*cos y - x*sin y
	swap	d6
rol.l	#1,d6
	move.w	d3,2(a4,d0.w)
	move.w	d6,6(a4,d0.w)

	subq.w	#8,d0
	bpl	turnrout1
	rts
;*****
;------------------------------------------------------------------------



drawline:
	move.l	turnkoord,a1	;turned koordinates
	lea	areaoffsets,a3	;areas to draw
	move.w	(a3)+,d7	;areacount
	lea	arealines+2,a4	;linecodes for each area
drawloop1:		;mainloop for each area
	move.w	(a3)+,d6	;get offset of area 1
	move.w	(a4,d6.w),d5	;number of lines in this area
	move.w	2(a4,d6.w),-(a7);areacolour of stack
	move.w	#$7fff,d0
	move.w	d0,lox
	move.w	d0,loy
	moveq	#0,d0
	move.l	d0,hix;(+hiy)

	move.l	listpoint,a6
move.w	#bltafwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltalwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltcmod,(a6)+
move.w	#64,(a6)+
move.w	#bltdmod,(a6)+
move.w	#64,(a6)+
move.w	#bltbdat,(a6)+
move.w	#0,(a6)+
move.w	#bltadat,(a6)+
move.w	#$8000,(a6)+
	move.l	a6,listpoint

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



moveq	#90,d0
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


bsr	draw

dbf	d5,drawloop2
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
;;;add.w	d4,d1
add.w	d0,d1
move.w	d1,planeoffsetd	;planeoffset for destination screen


moveq	#64,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix,d1		;highest x...
sub.w	lox,d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source
add.w	#64,d0	;modulo+64+64...
move.w	d0,planemodulod	;...=modulo destination


move.w	hiy,d2	;highest y-value...			BLTSIZE CALC
sub.w	loy,d2	;...-lowest y-value
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize	;planesize for source and destination

add.w	planeoffsets,d2
add.w	#4,d2
move.w	d2,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize,planesizef
move.w	planemodulos,planemodulof

addq.w	#4,planesizef
subq.w	#8,planemodulof
addq.w	#4,planeoffsetf

move.w	(a7)+,d0;areacolour from stack
	bsr	planefillcopycls
dbf	d7,drawloop1




move.l	pointplane,d1
move.l	clearplane,d1
add.l	#45*2*64,d1
add.l	#10,d1

;move.l	d1,BLTDPTH(A5)
;move.w	#32,BLTDMOD(A5)
;move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
;move.w	#253*3*64+16,BLTSIZE(A5)

move.w	#bltdptl,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltdpth,(a6)+
move.w	d1,(a6)+
move.w	#bltdmod,(a6)+
move.w	#32+8,(a6)+
move.w	#bltcon1,(a6)+
move.w	#0,(a6)+
move.w	#bltcon0,(a6)+
move.w	#%0000000100000000,(a6)+
move.w	#bltsize,(a6)+
move.w	#160*2*64+16-4,(a6)+



move.l	a6,listpoint
move.l	#$fffffffe,(a6)
rts





turnx:	dc.w	0
turny:	dc.w	0
turnz:	dc.w	0
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



intwait:	dc.w	0





DMACONRB	=	$002
INTENARB	=	$01C
BLTCON0B	=	$040
BLTCON1B	=	$042
BLTAFWMB	=	$044
BLTALWMB	=	$046
BLTCPTB		=	$048
BLTBPTB		=	$04C
BLTAPTB		=	$050
BLTDPTB		=	$054
BLTSIZEB	=	$058
BLTCMODB	=	$060
BLTBMODB	=	$062
BLTAMODB	=	$064
BLTDMODB	=	$066
BLTBDATB	=	$072
BLTADATB	=	$074
COP1LCB		=	$080
COPJMP1B	=	$088
DMACONB		=	$096
INTENAB		=	$09A

CIAA_PRA	=	$BFE001
CIAB_PRB	=	$BFD100
CIAA_TALO	=	$BFE401
CIAA_TAHI	=	$BFE501
CIAA_ICR	=	$BFED01
CIAA_CRA	=	$BFEE01




DRAW:
;move.l	comwpoint,a6
;move.w	#1,(a6)+	;code for line

	lea	calcplane,a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt	drawl1		;point 2 is greater--> okay
	beq	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y


drawl1:	
;----------searching lowest x/y and highest x/y of polygon
;y-koord alredy sorted:y1 is always lower than y2
	cmp.w	lox,d0
	bhs	nonewlox1
	move.w	d0,lox
nonewlox1:

	cmp.w	lox,d2
	bhs	nonewlox2
	move.w	d2,lox
nonewlox2:

	cmp.w	loy,d1
	bhs	nonewloy
	move.w	d1,loy
nonewloy:

	cmp.w	hix,d0
	bls	nonewhix1
	move.w	d0,hix
nonewhix1:

	cmp.w	hix,d2
	bls	nonewhix2
	move.w	d2,hix
nonewhix2:

	cmp.w	hiy,d3
	bls	nonewhiy
	move.w	d3,hiy
nonewhiy:

;----------
	SUBQ.W	#1,D3		;y2=y2-1   why?? 
	SUB.W	D1,D3		;y2=y2-y1 , d3=ydiff (always positive)
	SUB.W	D0,D2		;x2=x2-x1 , d2=xdiff
	bpl	.OK2		;xdiff positive ?
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


;lea	$dff000,a6
;jsr	bwait
;	MOVE.w	d3,bltaptl(a6)
;	MOVE.l	a2,bltcpth(a6)
;	MOVE.l	a2,bltdpth(a6)

;	MOVE.w	d0,bltbmod(a6)
;	MOVE.l	d4,bltcon0(a6)
;	MOVE.w	d1,bltamod(a6)
;	MOVE.w	d2,bltsize(a6)

move.l	listpoint,a6

move.w	#bltaptl,(a6)+
move.w	d3,(a6)+

move.l	a2,d3
move.w	#bltcptl,(a6)+
move.w	d3,(a6)+
move.w	#bltdptl,(a6)+
move.w	d3,(a6)+
swap	d3
move.w	#bltcpth,(a6)+
move.w	d3,(a6)+
move.w	#bltdpth,(a6)+
move.w	d3,(a6)+
move.w	#bltbmod,(a6)+
move.w	d0,(a6)+
move.w	#bltcon1,(a6)+
move.w	d4,(a6)+
swap	d4
move.w	#bltcon0,(a6)+
move.w	d4,(a6)+
move.w	#bltamod,(a6)+
move.w	d1,(a6)+
move.w	#bltsize,(a6)+
move.w	d2,(a6)+

move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	a6,listpoint


drawl2:
	RTS


OCTANTS:	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
	DC.L	$0B5AF017;-2		; BIT/LINE.
	DC.L	$0B5AF00B;-2

hidetest:
sub.w	d0,d2	;delta x1 x2
sub.w	d1,d3	;delta y1 y2

sub.w	d0,d4	;delta x1 x3
sub.w	d1,d5	;delta y1 y3

muls	d2,d5	;delta x1 x2  *  delta y1 y3
muls	d3,d4	;delta y1 y2  *  delta x1 x3

move.w	#0,d0
sub.l	d4,d5
bmi	hidetestl1
move.w	#1,d0

hidetestl1:
move.w	d0,hideflag
rts


nextobj:
move.l	objpoint,a0
move.l	(a0)+,d0
tst.l	d0
bne	noobjrestart
lea	objects,a0
move.l	(a0)+,d0


noobjrestart:
move.l	a0,objpoint
move.l	d0,turnkoords
rts

objpoint:	dc.l	objects
objects:
	dc.l	linekoords1
	dc.l	linekoords2
	dc.l	linekoords3
	dc.l	linekoords4
	dc.l	linekoords5
	dc.l	0





;cube
linepoints1: dc.w  7; 8 Linepoints

linekoord1:	blk.b	64,0
linekoords1:
dc.w 0,-40,-40, 40
dc.w 0,-40, 40, 40
dc.w 0, 40, 40, 40
dc.w 0, 40,-40, 40

dc.w 0,-40,-40,-40
dc.w 0,-40, 40,-40
dc.w 0, 40, 40,-40
dc.w 0, 40,-40,-40


linekoords2:
dc.w 0,-15,-40, 40
dc.w 0,-15, 40, 40
dc.w 0, 15, 40, 40
dc.w 0, 15,-40, 40

dc.w 0,-40,-15,-40
dc.w 0,-40, 15,-40
dc.w 0, 40, 15,-40
dc.w 0, 40,-15,-40


linekoords3:
dc.w 0,-15,-15, 40
dc.w 0,-15, 15, 40
dc.w 0, 15, 15, 40
dc.w 0, 15,-15, 40

dc.w 0,-40,-40,-40
dc.w 0,-40, 40,-40
dc.w 0, 40, 40,-40
dc.w 0, 40,-40,-40


linekoords4:
dc.w 0,-40,-20, 40
dc.w 0,-40, 20, 40
dc.w 0, 40, 40, 40
dc.w 0, 40,-40, 40

dc.w 0,-40,-20,-40
dc.w 0,-40, 20,-40
dc.w 0, 40, 40,-40
dc.w 0, 40,-40,-40

linekoords5:
dc.w 0,-20,-20, 40
dc.w 0,-20, 20, 40
dc.w 0, 20, 20, 40
dc.w 0, 20,-20, 40

dc.w 0,-20,-40,-40
dc.w 0,-20, 40,-40
dc.w 0, 20, 40,-40
dc.w 0, 20,-40,-40


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
blk.w	100,0


planefillcopycls:
;planefill:
	moveq	#0,d1
	move.w	planeoffsetf,d1
	add.l	#calcplane,d1

;lea	$dff000,a6
;jsr	bwait

;	MOVE.l	#%00001001111100000000000000001010,bltcon0(a6);0+1 con
;	MOVE.l	#-1,bltafwm(a6)

;	MOVE.l	d1,bltapth(a6)
;	MOVE.l	d1,bltdpth(a6)
;	MOVE.w	planemodulos,bltamod(a6)
;	MOVE.w	planemodulos,bltdmod(a6)
;	MOVE.w	planesize,bltsize(a6)

move.l	listpoint,a6
move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.w	#bltcon0,(a6)+
move.w	#%0000100111110000,(a6)+
move.w	#bltcon1,(a6)+
move.w	#%0000000000010010,(a6)+
move.w	#bltafwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltalwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltaptl,(a6)+
move.w	d1,(a6)+
move.w	#bltdptl,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltapth,(a6)+
move.w	d1,(a6)+
move.w	#bltdpth,(a6)+
move.w	d1,(a6)+
move.w	#bltamod,(a6)+
move.w	planemodulof,(a6)+
move.w	#bltdmod,(a6)+
move.w	planemodulof,(a6)+
move.w	#bltsize,(a6)+
move.w	planesizef,(a6)+

move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.l	a6,listpoint
skip:

move.l	listpoint,a6



;planecopy:
move.w	#%0000110111111100,d3
move.w	d3,d4
move.w	d3,d5

btst.l	#0,d0
bne	settest1
move.w	#%0000110100001100,d3
settest1:

btst.l	#1,d0
bne	settest2
move.w	#%0000110100001100,d4
settest2:



	moveq	#0,d2
	moveq	#0,d1
	move.w	planeoffsets,d2
	move.w	planeoffsetd,d1
	add.l	#calcplane,d2
	add.l	pointplane,d1


;jsr	bwait

;	MOVE.w	#0,bltcon1(a6)
;	MOVE.l	#-1,bltafwm(a6)

;	MOVE.w	d3,bltcon0(a6)
;	MOVE.l	d1,bltbpth(a6)
;	MOVE.l	d1,bltdpth(a6)
;	MOVE.l	d2,bltapth(a6)
;	MOVE.w	planemodulod,bltbmod(a6)
;	MOVE.w	planemodulod,bltdmod(a6)
;	MOVE.w	planemodulos,bltamod(a6)
;	MOVE.w	planesize,bltsize(a6)

move.w	#bltcon1,(a6)+
move.w	#0,(a6)+
move.w	#bltafwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltalwm,(a6)+
move.w	#-1,(a6)+

move.w	#bltcon0,(a6)+
move.w	d3,(a6)+
move.w	#bltbptl,(a6)+
move.w	d1,(a6)+
move.w	#bltdptl,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltbpth,(a6)+
move.w	d1,(a6)+
move.w	#bltdpth,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltaptl,(a6)+
move.w	d2,(a6)+
swap	d2
move.w	#bltapth,(a6)+
move.w	d2,(a6)+
swap	d2
move.w	#bltbmod,(a6)+
move.w	planemodulod,(a6)+
move.w	#bltdmod,(a6)+
move.w	planemodulod,(a6)+
move.w	#bltamod,(a6)+
move.w	planemodulos,(a6)+
move.w	#bltsize,(a6)+
move.w	planesize,(a6)+

move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.l	a6,listpoint
move.l	listpoint,a6

;-----

	add.l	#64,d1

;jsr	bwait

;	MOVE.w	d4,bltcon0(a6)
;	MOVE.l	d1,bltbpth(a6)
;	MOVE.l	d1,bltdpth(a6)
;	MOVE.l	d2,bltapth(a6)
;	MOVE.w	planemodulod,bltbmod(a6)
;	MOVE.w	planemodulod,bltdmod(a6)
;	MOVE.w	planemodulos,bltamod(a6)
;	MOVE.w	planesize,bltsize(a6)


move.w	#bltcon1,(a6)+
move.w	#0,(a6)+
move.w	#bltafwm,(a6)+
move.w	#-1,(a6)+
move.w	#bltalwm,(a6)+
move.w	#-1,(a6)+

move.w	#bltcon0,(a6)+
move.w	d4,(a6)+
move.w	#bltbptl,(a6)+
move.w	d1,(a6)+
move.w	#bltdptl,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltbpth,(a6)+
move.w	d1,(a6)+
move.w	#bltdpth,(a6)+
move.w	d1,(a6)+
swap	d1
move.w	#bltaptl,(a6)+
move.w	d2,(a6)+
swap	d2
move.w	#bltapth,(a6)+
move.w	d2,(a6)+
swap	d2
move.w	#bltbmod,(a6)+
move.w	planemodulod,(a6)+
move.w	#bltdmod,(a6)+
move.w	planemodulod,(a6)+
move.w	#bltamod,(a6)+
move.w	planemodulos,(a6)+
move.w	#bltsize,(a6)+
move.w	planesize,(a6)+

move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.l	a6,listpoint
move.l	listpoint,a6

;-----
	add.l	#64,d1

;jsr	bwait


;planecls:
	moveq	#0,d2
	move.w	planeoffsets,d2
	add.l	#calcplane,d2


;jsr	bwait
;	MOVE.w	#%0000000100000000,bltcon0(a6)
;	MOVE.w	#0,bltcon1(a6)

;	MOVE.l	d2,bltdpth(a6)
;	MOVE.w	planemodulos,bltdmod(a6)
;	MOVE.w	planesize,bltsize(a6)

move.w	#bltcon0,(a6)+
move.w	#%0000000100000000,(a6)+
move.w	#bltcon1,(a6)+
move.w	#0,(a6)+
move.w	#bltdptl,(a6)+
move.w	d2,(a6)+
swap	d2
move.w	#bltdpth,(a6)+
move.w	d2,(a6)+
move.w	#bltdmod,(a6)+
move.w	planemodulos,(a6)+
move.w	#bltsize,(a6)+
move.w	planesize,(a6)+

move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.l	a6,listpoint

	rts








mainplanecls:
rts

nextcol:
add.w	#32,objcolpos
cmp.w	#7*32,objcolpos
bne	noresnextcol
move.w	#0,objcolpos
noresnextcol:
rts

objcolpos:	dc.w	0


glenzcol:
dc.w	$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
dc.w	$777,$666,$555,$444,$333,$222,$111,$000

dc.w	$0ff,$0ee,$0dd,$0cc,$0bb,$0aa,$099,$088
dc.w	$077,$066,$055,$044,$033,$022,$011,$000

dc.w	$0f0,$0e0,$0d0,$0c0,$0b0,$0a0,$090,$080
dc.w	$070,$060,$050,$040,$030,$020,$010,$000

dc.w	$f00,$e00,$d00,$c00,$b00,$a00,$900,$800
dc.w	$700,$600,$500,$400,$300,$200,$100,$000

dc.w	$ff0,$ee0,$dd0,$cc0,$bb0,$aa0,$990,$880
dc.w	$770,$660,$550,$440,$330,$220,$110,$000

dc.w	$f0f,$e0e,$d0d,$c0c,$b0b,$a0a,$909,$808
dc.w	$707,$606,$505,$404,$303,$202,$101,$000

dc.w	$00f,$00e,$00d,$00c,$00b,$00a,$009,$008
dc.w	$007,$006,$005,$004,$003,$00a,$001,$000



objcol:	dc.w	0,0,0,0


hideflag:	dc.w	0


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

cmp.l	d5,d4
bpl	hidden
addq.w	#1,d6		;one more
move.w	d7,d5		;loopcounter
lsl.w	#5,d5		;*32
move.w	d5,(a2)+	;=offset


move.w	(a0,d5.w),d0	;number of points in area
move.w	2(a0,d5.w),-(a7);colour of area

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


move.w	d1,-(a7)
;lsl.l	#2,d1
;muls	#4,d1
asl.w	#2,d1
ext.l	d1
divs	d4,d1
move.w	d1,(a3)+


move.w	(a7)+,d0
add.w	#200,d0
lsr.w	#5,d0
add.w	d0,d0

move.w	(a7)+,d5
add.w	d5,d5
and.w	#$000f,d0
add.w	d0,d0
lea	glenzcol,a4
add.w	objcolpos,d0
lea	(a4,d0.w),a4
move.w	(a4),d0

;lea	$dff190,a4
lea	objcol,a4
lea	(a4,d5.w),a4
move.w	d0,(a4)


hidden:
dbf	d7,hidel1
lea	areaoffsets,a0
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




mainplanecls2:
rts
moveq	#0,d0
move.l	d0,d1
move.l	d0,d2
move.l	d0,d3
move.l	d0,d4
move.l	d0,d5
move.l	d0,d6
move.l	d0,a0

move.w	#118*3,d7
			add.w	#20*3,d7
move.l	clearplane,a1
move.l	pointplane,a1
add.l	#0*64+14,a1
add.l	#64*68*3,a1
			sub.l	#64*10*3,a1
maincls2l1:
movem.l	d0-d3,(a1)
lea	64(a1),a1
dbf	d7,maincls2l1
rts




bwait:	
btst	#14,dmaconr(a6)
bne	bwait
rts

grname:	dc.b	"graphics.library",0
even

copperlist1:
dc.l	-2
blk.b	2500,0

copperlist2:
dc.l	-2
blk.b	2500,0

worklist:	dc.l	copperlist1
showlist:	dc.l	copperlist2

listpoint:	dc.l	0

coppercopy:
move.l	worklist,a0
move.l	#$01800fff,(a0)+
move.l	#$500ffffe,(a0)+

move.l	#$01800fff,(a0)+
move.l	#$900ffffe,(a0)+

move.l	#$01800fff,(a0)+
move.l	#$fffffffe,(a0)+
rts





textpos:	dc.l	text
printsleep:	dc.w	1
textlineadr:	dc.l	textline

printline:
	lea	logo+2*8+3*40*100,a0
	move.l	textlineadr,a1
	add.l	#3*40,textlineadr
	moveq	#2,d7
scrollup3l1:
movem.l	(a1),d0-d6
movem.l	d0-d6,(a0)
lea	40(a0),a0
lea	40(a1),a1
dbf	d7,scrollup3l1



	subq.w	#1,printsleep
	bne	printlinel4
	move.l	#textline,textlineadr
	move.w	#15,printsleep
;	lea	logo+2*8,a0
;	lea	3*40*89(a0),a0
	lea	textline,a0
	move.l	textpos,a2

	tst.w	(a2)
	bpl	printlinel3
	lea	text(pc),a2

printlinel3:

	moveq	#25,d7
printlinel1:
	lea	font,a1
	moveq	#0,d0
	move.w	(a2)+,d0
	lea	(a1,d0.w),a1

	moveq	#32,d1
printlinel2:
	move.b	(a1)+,(a0)
	add.l	#40,a0
	dbf	d1,printlinel2
	lea	-40*33+1(a0),a0
	dbf	d7,printlinel1
	move.l	a2,textpos
printlinel4:
	rts


scrollup:
	lea	$dff000,a5
	
move.l	listpoint,a6
move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+

move.l	#logo+2*8,d0
move.w	#bltdptl,(a6)+
move.w	d0,(a6)+
swap	d0
move.w	#bltdpth,(a6)+
move.w	d0,(a6)+

swap	d0
add.l	#40*3,d0
move.w	#bltaptl,(a6)+
move.w	d0,(a6)+
swap	d0
move.w	#bltapth,(a6)+
move.w	d0,(a6)+

move.w	#bltdmod,(a6)+
move.w	#$000e,(a6)+
move.w	#bltamod,(a6)+
move.w	#$000e,(a6)+

move.w	#bltcon0,(a6)+
move.w	#%0000100111110000,(a6)+

move.w	#bltcon1,(a6)+
move.w	#%0000000000000000,(a6)+

move.w	#bltsize,(a6)+
move.w	#64*3*101+13,(a6)+



move.l	#$01800fff,(a6)+
move.l	#$00017ffe,(a6)+
move.l	#$00017ffe,(a6)+
move.l	a6,listpoint

;	lea	logo+2*8,a0
;	move.l	a0,bltdpth(a5)
;	lea	40*3(a0),a0
;	move.l	a0,bltapth(a5)
;	move.l	#$000e000e,bltamod(a5)	;a+d mod
;	move.w	#%0000100111110000,bltcon0(a5)
;	move.w	#%0000000000000000,bltcon1(a5)
;	move.w	#64*3*101+13,bltsize(a5)
rts





textcalc:
	lea	asciitextend(pc),a0
	lea	textend(pc),a1
	move.w	#asciitextend-text-1,d7
textcalcl1:
	lea	charsend(pc),a2
	moveq	#charsend-chars-1,d6
	move.b	-(a0),d5
textcalcl2:
	cmp.b	-(a2),d5
	beq.s	textcalcl3
	dbf	d6,textcalcl2
	move.l	#200000,d6
textcalcl4:
	move.w	#$0f00,$dff180
	move.w	#$0000,$dff180
	subq.l	#1,d6
	bne.s	textcalcl4

textcalcl3:
	mulu.w	#3*11,d6
	move.w	d6,-(a1)

;	move.w	$dff006,$dff180
	dbf	d7,textcalcl1
	rts

chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789/'.()!?-,+:"
charsend:
text:
;	 0123456789012345678901234567890123456789
;	 01234567890123456789012345

dc.b	"well, ya want to see the  "
dc.b	"detailed credits,         "
dc.b	"so here they are:         "
dc.b	"                          "
dc.b	"all codings by...         "
dc.b	"                      moon"
dc.b	"                          "
dc.b	"all fantasic tunes by...  "
dc.b	"               neurodancer"
dc.b	"                          "
dc.b	"all intropart gfx by...   "
dc.b	"                   artline"
dc.b	"                          "
dc.b	"second disksymbol by...   "
dc.b	"                   artline"
dc.b	"                          "
dc.b	"soundmenugfx by...        "
dc.b	"                     toxic"
dc.b	"                          "
dc.b	"little musicpictures by..."
dc.b	"                     toxic"
dc.b	"                          "
dc.b	"all endpartgfx by...      "
dc.b	"                     toxic"
dc.b	"                          "
dc.b	"design by...              "
dc.b	" neurodancer,artline,toxic"
dc.b	"                          "

dc.b	"hope ya liked this        "
dc.b	"production by abyss and   "
dc.b	"feel free to vote for this"
dc.b	"production in any charts.."
dc.b	"                          "
dc.b	"once again a messy to all "
dc.b	"         pd-guyz:         "
dc.b	"ya are not allowed to sell"
dc.b	"this product without our  "
dc.b	"written permission...     "   
dc.b	"write to:                 "
dc.b	"                          "
dc.b	"toxic of abyss            "
dc.b    "sven dedek                "
dc.b	"gruenewaldstr. 6          "
dc.b	"84453 muehldorf am inn    "
dc.b	"germany                   "
dc.b	"                          "
dc.b	"write also to this        "
dc.b	"address for joining       "
dc.b	"                          "
dc.b	"to have a friendly swap   "
dc.b	"with abyss write to one of"
dc.b	"our swappers in spermany: "
dc.b	"                          "
dc.b	"skindiver of abyss        "
dc.b	"andreas schwarz           "
dc.b	"pfarrer-ziller-str. 15    "
dc.b	"85402 kranzberg           "
dc.b	"                          "
dc.b	"or to:                    "
dc.b	"                          "
dc.b	"the duke of abyss         "
dc.b	"markus knauer             "
dc.b	"fritz-bender-str. 9       "
dc.b	"85402 kranzberg           "
dc.b	"                          "
dc.b	"wanna swap nice letters?  "
dc.b	"then try:                 "
dc.b	"                          "
dc.b	"moon of abyss             "
dc.b	"po.box 162                "
dc.b	"a-5400 hallein            "
dc.b	"austria                   "
dc.b	"                          "

dc.b	"our salem aleikums now to."
dc.b    "                          "

dc.b	"acrid                     "
dc.b	"agnostic front            "
dc.b	"alcatraz                  "
dc.b	"analog                    "
dc.b	"arise                     "
dc.b	"atomic                    "
dc.b	"balance                   "
dc.b	"bronx                     "
dc.b	"centura                   "
dc.b	"cryptoburners             "
dc.b	"dcs                       "
dc.b	"deffusion                 "
dc.b	"destiny                   "
dc.b	"effect                    "
dc.b	"elysion                   "
dc.b	"equinox                   "
dc.b	"essence                   "
dc.b	"headway                   "
dc.b	"hemoroids                 "
dc.b	"impulse                   "
dc.b	"infect                    "
dc.b	"interactive               "
dc.b	"iris                      "
dc.b	"jetset                    "
dc.b	"laser dance               "
dc.b	"legend                    "
dc.b	"lost aid                  "
dc.b	"lsd                       "
dc.b	"manitou                   "
dc.b	"midway                    "
dc.b	"noxious                   "
dc.b	"nuance                    "
dc.b	"orient                    "
dc.b	"principes                 "
dc.b	"s!p                       "
dc.b	"sanity                    "
dc.b	"scoopex                   "
dc.b	"submission                "
dc.b	"tek                       "
dc.b	"the dark demon            "
dc.b	"the face inc.             "
dc.b	"the movement              "
dc.b	"the special brothers      "
dc.b	"trsi                      "
dc.b	"t.o.c                     "
dc.b	"urban design              "
dc.b	"zenith                    "
dc.b	"zite                      "
asciitextend:

blk.b	asciitextend-text
textend:	dc.w	-1


logo:	incbin	"data/logo2.con"
;logo2:	incbin	"data/logo2.con"

textline:	blk.b	3*40*20,0

font:	incbin	"data/font"



scrollup2:


	lea	logo+2*8,a0
	lea	40*3(a0),a1

	move.w	#3*100-1,d7
scrollup2l1:

movem.l	(a1),d0-d6
movem.l	d0-d6,(a0)
lea	40(a0),a0
lea	40(a1),a1
dbf	d7,scrollup2l1

rts

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
PACKEDSONGFORMAT		=	no
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
;incbin	"data/mod.guitar_p"
incbin	"data/mod.guitar"
b:
