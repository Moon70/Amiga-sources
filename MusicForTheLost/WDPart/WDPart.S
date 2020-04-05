;------------------------------------------------------------------------
;|                                                                      |
;|                                                                      |
;|                 Music for the Lost 'WRONG-DISK-PART'                 |
;|                --------------------------------------                |
;|                                                                      |
;|                  coded in summer 1993 by Moon/ABYSS                  |
;|                                                                      |
;------------------------------------------------------------------------

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


start:
	move.l	execbase,a6
	jsr	forbid(a6)
	lea	$dff000,a5
	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#%0000001111100000,dmacon(a5)
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003800d0,ddfstrt(a5)	;strt+stop!
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.w	#%1000001101000000,dmacon(a5)

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	linequant1,linequant
	move.l	#lines1,lines
	move.w	#5,turnaddx
	move.w	#3,turnaddy
	move.w	#2,turnaddz

	bsr	turner
	bsr	veccolinit

	move.l	#pr_data,pr_module
	jsr	pr_init

	move.w	#%0000000001101000,intena(a5)
	move.l	$6c,oldint
	move.l	#introut,$6c
	move.w	#%1100000000100000,intena(a5)
	move.l	#0,$dff144

wait:
	bra.b	wait
	btst	#6,ciaapra
	beq.b back

	bra.b	wait

back:	move.l	oldint,$6c
	jsr	pr_end
	move.l	execbase,a6
	lea	$dff000,a5
	move.w	#%1000001111100000,dmacon(a5)
	move.w	#%1000000000001000,intena(a5)
	jsr	permit(a6)
	moveq	#0,d0
	rts

introut:
	btst.b	#5,$dff01f
	beq.w	intback
	movem.l	d0-d7/a0-a6,-(a7)
	move.w	#%0101001000000000,bplcon0(a5)
	move.l	#$00180018,bpl1mod(a5)	;1mod+2mod!

	lea	$dff000,a5	;planecls
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)

	move.l	storeplane1,d0
	move.l	d0,bpl2pth(a5)

	move.l	storeplane2,d0
	move.l	d0,bpl3pth(a5)

	move.l	storeplane3,d0
	move.l	d0,bpl4pth(a5)

	move.l	storeplane4,d0
	move.l	d0,bpl5pth(a5)


	bsr.w	planecls
	bsr	turner
	bsr	zoom
	bsr	drawline
	bsr	fill
	bsr.w	switchplanes2

	jsr	pr_music
	bsr	commander

bwait:
	btst	#14,$dff002
	bne.b	bwait
	movem.l	(a7)+,d0-d7/a0-a6

	move.w	#0,intwait

intback:
	move.w	#%0000000001100000,$dff09c
	rte

introut2:
	btst.b	#5,$dff01f
	beq.b	intback2
movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a5	;planecls
	move.w	#%0100001000000000,bplcon0(a5)
	move.l	#$00780078,bpl1mod(a5)	;1mod+2mod!

	lea	logo+2*16(pc),a0

	move.l	a0,bpl1pth(a5)

	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)

	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)

	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)

	bsr	realfade

	lea	faded(pc),a0
	lea	$dff180,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	bsr	commander

	tst.w	musicflag
	beq.b	nomusic
	jsr	pr_music

nomusic:
	movem.l	(a7)+,d0-d7/a0-a6

	move.w	#0,intwait

intback2:
	move.w	#%0000000001100000,$dff09c
	rte

oldint:		dc.l	0
ente:	dc.w	0

planecls:
	lea	$dff000,a5
	move.l	clearplane,d0
bwait4:
	btst	#14,dmaconr(a5)
	bne.b	bwait4

	move.l	d0,BLTDPTH(A5)
	move.w	#24,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#256*64*1+20,BLTSIZE(A5)
	rts

fill:
	lea	$dff000,a5
	move.l	pointplane,d0
	addq.l	#0*64+2,d0
	add.l	#256*64*1+(20*2),d0

bwait2:	
	btst	#14,dmaconr(a5)
	bne.b	bwait2

	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#24,bltamod(A5)
	MOVE.w	#24,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#256*64*1+20,BLTSIZE(A5)
	rts

allplanes:
showplane:	dc.l	plane1
storeplane1:	dc.l	plane2
storeplane2:	dc.l	plane3
storeplane3:	dc.l	plane4
storeplane4:	dc.l	plane5
clearplane:	dc.l	plane6
pointplane:	dc.l	plane7

switchplanes2:
	lea	allplanes+7*4(pc),a0
	move.l	-(a0),d0
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	d0,(a0)
	rts

linequant:	dc.w	0
lines:		dc.l	0
turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0

linemask:	dc.w	$ffff

zoom:
	cmp.w	#32000,zoomval
	beq.b	skipzoomadd
	add.w	#250,zoomval
skipzoomadd:
	move.l	turnkoord,a0	;koordinaten
	move.w	turnquant,d0
zoomrout1:
	move.w	d0,d1		;schleifenzaehler in d1
	lsl.w	#3,d1		;*8 als offset/koord
	move.w	d1,a2

	move.w	2(a0,a2.w),d3	;d3=x
	move.w	4(a0,a2.w),d4	;d4=y

	move.w	zoomval,d1

	muls.w	d1,d3
	muls.w	d1,d4

	add.l	d3,d3
	add.l	d4,d4

	swap	d3
	swap	d4

	move.w	d3,2(a0,a2.w)	;d3=x
	move.w	d4,4(a0,a2.w)	;d4=y

	dbf	d0,zoomrout1

	cmp.w	#32000,zoomval
	bne.b	depp

	move.w	#0,turnaddx
	move.w	#0,turnaddy
	move.w	#0,turnaddz
;	move.w	#1,comsleep
depp:

rts

zoomval:	dc.w	0

turner:
	move.w	turnx,d0
	add.w	turnaddx,d0
	cmp.w	#359,d0
	ble.b nolaufx
	sub.w	#360,d0
nolaufx:
	move.w	d0,turnx

	move.w	turny,d0
	add.w	turnaddy,d0
	cmp.w	#359,d0
	ble.b nolaufy
	sub.w	#360,d0
nolaufy:
	move.w	d0,turny

	move.w	turnz,d0
	add.w	turnaddz,d0
	cmp.w	#359,d0
	ble.b nolaufz
	sub.w	#360,d0
nolaufz:
	move.w	d0,turnz


turner1:
	move.l	turnkoord,a0	;koordinaten
	move.l	turnkoords,a3
	lea	sinus(pc),a1	;sinus/cosinus
	moveq	#0,d0
	move.w	turnquant,d0
turnrout1:
	move.w	d0,d1		;schleifenzaehler in d1
	lsl.w	#3,d1		;*8 als offset/koord
	move.w	d1,a2

	move.w	turnz,d2	;drehwinkel z laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	move.w	0(a1,d2.w),d6	;d6 = sin z
	move.w	2(a1,d2.w),d5	;d5 = cos z
	move.w	2(a3,a2.w),d3	;d3=x
	move.w	4(a3,a2.w),d4	;d4=y
	move.w	d3,d2		;d2=x
	muls.w	d5,d2		;d2=x*cos z
	move.w	d4,d1		;d1=y
	muls.w	d6,d1		;d1=y*sin z
	sub.l	d1,d2		;d2=x*cos z - y*sin z  ->new  x-koord
	swap	d2
	rol.l	#1,d2
	move.w	d2,2(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=x
	muls.w	d6,d2		;d2=x*sin z
	move.w	d4,d1		;d1=y
	muls.w	d5,d1		;d1=y*cos z
	add.l	d1,d2		;d2=x*sin z + y*cos z  ->new  y-koord
	swap	d2
	rol.l	#1,d2
	move.w	d2,4(a0,a2.w)	;in liste eintragen

	move.w	turnx,d2	;drehwinkel x laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	move.w	0(a1,d2.w),d6	;d6 = sin x
	move.w	2(a1,d2.w),d5	;d5 = cos x
	move.w	4(a0,a2.w),d3	;d3=y
	move.w	6(a3,a2.w),d4	;d4=z
	move.w	d3,d2		;d2=y
	muls.w	d5,d2		;d2=y*cos x
	move.w	d4,d1		;d1=z
	muls.w	d6,d1		;d1=z*sin x
	sub.l	d1,d2		;d2=y*cos x - z*sin x ->new y-koord
	swap	d2
	rol.l	#1,d2
	move.w	d2,4(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=y
	muls.w	d6,d2		;d2=y*sin x
	move.w	d4,d1		;d1=z
	muls.w	d5,d1		;d1=z*cos x
	add.l	d1,d2		;d2=y*sin x + z*cos x
	swap	d2
	rol.l	#1,d2
	move.w	d2,6(a0,a2.w)	;in liste eintragen

	move.w	turny,d2	;drehwinkel y laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	move.w	0(a1,d2.w),d6	;d6 = sin y
	move.w	2(a1,d2.w),d5	;d5 = cos y
	move.w	2(a0,a2.w),d3	;d3=x
	move.w	6(a0,a2.w),d4	;d4=z
	move.w	d3,d2		;d2=x
	muls.w	d5,d2		;d2=x*cos y
	move.w	d4,d1		;d1=z
	muls.w	d6,d1		;d1=z*sin y
	add.l	d1,d2		;d2=x*cos y + z*sin y
	swap	d2
	rol.l	#1,d2
	move.w	d2,2(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=x
	muls.w	d6,d2		;d2=x*sin y
	move.w	d4,d1		;d1=z
	muls.w	d5,d1		;d1=z*cos y
	sub.l	d1,d2		;d2=z*cos y - x*sin y
	swap	d2
	rol.l	#1,d2
	move.w	d2,6(a0,a2.w)	;in liste eintragen

	dbf	d0,turnrout1
	rts
;*****

drawline:
lea	$dff000,a5

move.l	turnkoord,a0
move.l	lines,a1
move.w	linequant,d7

drawloop:
moveq	#0,d0
moveq	#0,d2
moveq	#0,d1
moveq	#0,d3

move.w	#166,d0
move.w	#130,d1
move.w	#166,d2
move.w	#130,d3

move.w	0(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d0
add.w	4(a0,a2.w),d1

move.w	2(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d2
add.w	4(a0,a2.w),d3

cmp.w	d0,d2
bne.b	notsamepoint
cmp.w	d1,d3
bne.b	notsamepoint
bra.b	samepoint

notsamepoint:
movem.l	d4/a0/a2/a6,-(a7)
bsr.b	line
movem.l	(a7)+,d4/a0/a2/a6

samepoint:
subq.w	#4,d7
bpl.b	drawloop

bwait1:	
btst	#14,dmaconr(a5)
bne.b	bwait1
rts


line:
	move.l	pointplane,a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
	beq.w	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
	SUBQ.W	#1,D3		;y2=y2-1   why?? 
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
	DC.L	$0B5AF013
	DC.L	$0B5AF003
	DC.L	$0B5AF017
	DC.L	$0B5AF00B

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
	lea	fadedat(pc),a0
	lea	faded(pc),a1
	moveq	#35,d1
fadereall1:
	move.w	0(a0,d0.w),(a1)+
	add.l	#30,d0
	dbf	d1,fadereall1
	rts
;*****


fader:
	lea	tofade(pc),a2	;scr-farbdaten
	lea	fadedat(pc),a1	;obj-farbdaten
	lea	faded(pc),a0	;akt-farbdaten
	moveq	#35,d0		;anzahl farben
faderloop1:
	moveq	#14,d1		;anzahl faderschritte
	move.w	(a0)+,d2	;farbcode
	move.w	d2,d3
	move.w	d2,d4
	and.w	#%0000000000001111,d2	;blauanteil akt
	and.w	#%0000000011110000,d3	;gruenanteil akt
	and.w	#%0000111100000000,d4	;rotanteil akt
	move.w	(a2)+,d5		;momentaner code fuer farbe d0
	move.w	d5,d6
	move.w	d5,d7
	and.w	#%0000000000001111,d5	;blauanteil scr
	and.w	#%0000000011110000,d6	;gruenanteil scr
	and.w	#%0000111100000000,d7	;rotanteil scr
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
tofade:		blk.w	68,$0000
faded:		blk.w	68,$0fff
fadedat:	blk.w	68*16,$0000
fadeflag:	dc.w	0


commander:	;last optimizing: 93-05-16
	lea	comsleep(pc),a0		;  8
	subq.w	#1,(a0)			; 12
	beq.b	commanderl1		; 10 (true), 8 (false)
	rts				; 16
commanderl1:
	lea	2(a0),a1		;  8
	move.w	(a1),d0			;  8
	addq.w	#8,(a1)			; 12
	lea	commands(pc,d0.w),a1	; 12
	move.l	(a1)+,d0		; 12
	move.w	d0,(a0)			;  8
	move.l	(a1),a0			; 12
	jmp	(a0)			;  8

;---------
musicflag:	dc.w	1
comsleep:	dc.w	1	;|
compoint:	dc.w	0	;|


commands:
	dc.l	125,vector
	dc.l	1,showlogo
	dc.l	5,whitetocolfast
	dc.l	5,whitetocolfast
	dc.l	440,whitetocol
	dc.l	65535,musicoff
	
		dc.l	5,	setente
		dc.l	1,	commandrestart

;---------
musicoff:
move.w	#0,musicflag
rts


commandrestart:
	move.w	#0,compoint
	rts

setente:
	move.w	#1,ente
	rts

vector:
	move.l	#introut,$6c
rts

showlogo:
	move.l	#introut2,$6c
rts

whitetocol:
	lea	logo(pc),a0
	lea	tofade(pc),a1
	lea	faded(pc),a2
	move.l	#$0fff0fff,d1
	moveq	#7,d0
whitetocoll1:	
	move.l	d1,(a2)+
	move.l	(a0)+,(a1)+
	dbf	d0,whitetocoll1
	move.w	#5,fadecount	;coder off
	bsr	fader
	rts

whitetocolfast:
	lea	logo(pc),a0
	lea	tofade(pc),a1
	lea	faded(pc),a2
	move.l	#$0fff0fff,d1
	moveq	#7,d0
whitetocoll1fast:	
	move.l	d1,(a2)+
	move.l	(a0)+,(a1)+
	dbf	d0,whitetocoll1fast
	move.w	#0,fadecount	;coder off
	bsr	fader
	rts


turnx:	dc.w	79+1
turny:	dc.w	335+1
turnz:	dc.w	103+1

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

intwait:	dc.w	0

linekoord1:	blk.b	64,0

linepoints1: dc.w  7
linequant1: dc.w  7*4
linekoords1:
dc.w 0,-77,-125,0
dc.w 0, 72,-125,0
dc.w 0,-126,-76,0
dc.w 0, 121,-76,0
dc.w 0,-126, 74,0
dc.w 0, 121, 74,0
dc.w 0,-77, 123,0
dc.w 0, 72, 123,0
lines1:
dc.w  0, 1
dc.w  0, 2
dc.w  1, 3
dc.w  2, 4
dc.w  3, 5
dc.w  4, 6
dc.w  5, 7
dc.w  6, 7

veccol:
dc.w	$0180,$0000,$0182,$0555,$0184,$0655,$0186,$0666
dc.w	$0188,$0766,$018a,$0877,$018c,$0877,$018e,$0977
dc.w	$0190,$0a88,$0192,$0a88,$0194,$0b88,$0196,$0c88
dc.w	$0198,$0c88,$019a,$0d88,$019c,$0e88,$019e,$0e88
dc.w	$01a0,$0f88,$01a2,$0e77,$01a4,$0e66,$01a6,$0e66
dc.w	$01a8,$0d55,$01aa,$0d44,$01ac,$0c44,$01ae,$0c33
dc.w	$01b0,$0b33,$01b2,$0b22,$01b4,$0a22,$01b6,$0a11
dc.w	$01b8,$0911,$01ba,$0911,$01bc,$0800,$01be,$0800

veccolinit:
	lea	$dff180,a0
	lea	veccol(pc),a1
	moveq	#31,d0
veccolinitl1:
	move.w	2(a1),(a0)+
	addq.l	#4,a1
	dbf	d0,veccolinitl1
	rts

logo:
incbin	"data/disk2.con"
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
incbin	"data/mod.disk2_p"


plane1:	blk.l	256*64/4,0
plane2:	blk.l	256*64/4,0
plane3:	blk.l	256*64/4,0

plane4:	blk.l	256*64/4,0
plane5:	blk.l	256*64/4,0
plane6:	blk.l	256*64/4,0
plane7:	blk.l	256*64/4,0

blk.l	2*64/4,0
