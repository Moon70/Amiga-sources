;------------------------------------------------------------------------
;-                                                                      -
;-                             INTEL OUTSIDE                            -
;-                            ---------------                           -
;-                                                                      -
;- Abyss Version                                                        -
;-                                                                      -
;- To gain some bytes for the code, i used ABSOLUTE ADRESSES!           -
;- There should be no problem when booting from disc.                   -
;- BUT: When assembling this code, be SURE that there are no OTHER      -
;-  rograms running in the background.                                  -
;-                                                                      -
;- If you are sure, set are_you_sure to 1.                              -
;-                                                                      -
;- To install the bootblock on disc, set write_to_disc to 1             -
;- To start from ASMOne, use j                                          -
;-                                                                      -
;-                                                                      -
;- coded by Moon/ABYSS                                     January 1995 -
;------------------------------------------------------------------------
are_you_sure=0	;set this to 1 for assembling  <----------------------
write_to_disc=0	;seth this to 1 to write bootblock to disc  <---------


findresident=-96
ciaapra=$bfe001
dmacon=$96
dmaconr=$002
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

;spriteoffsets
spr0pth=$120
spr0ptl=$122
spr1pth=$124
spr1ptl=$126
spr2pth=$128
spr2ptl=$12a
spr3pth=$12c
spr3ptl=$12e
spr4pth=$130
spr4ptl=$132
spr5pth=$134
spr5ptl=$136
spr6pth=$138
spr6ptl=$13a
spr7pth=$13c
spr7ptl=$13e
spr0pos=$140
spr0ctl=$142
spr0data=$144
spr0datb=$146
spr1pos=$148
spr1ctl=$14a
spr1data=$14c
spr1datb=$14e
spr2pos=$150
spr2ctl=$152
spr2data=$154
spr2datb=$156
spr3pos=$158
spr3ctl=$15a
spr3data=$15c
spr3datb=$15e
spr4pos=$160
spr4ctl=$162
spr4data=$164
spr4datb=$166
spr5pos=$168
spr5ctl=$16a
spr5data=$16c
spr5datb=$16e
spr6pos=$170
spr6ctl=$172
spr6data=$174
spr6datb=$176
spr7pos=$178
spr7ctl=$17a
spr7data=$17c
spr7datb=$17e

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



ifeq	are_you_sure
printt
printt
printt	"Note:"
printt	"      Source not assembled !"
printt	"      Read text (first page of source) first !"
end
endif

s:
move.l	4.w,a6
bsr.b	start
rts

a:
block:
id:		dc.b	"DOS",0
checksum:	dc.l	0
rootblock:	dc.l	$00000370

start:
movem.l	d0-a6,-(a7)		;store some register
;--------------------------------------------------------------------
	lea	clrbase,a6
;-------------------------
clrmem:
	move.l	a6,a0
	move.w	#16384/4+200,d0
clrmemloop:
	clr.l	(a0)+
	dbf	d0,clrmemloop
;----------------------------
;-------
sprcopy:
	lea	sprite0dat(pc),a0
	lea	sprite0-clrbase(a6),a1
	moveq	#((28+2+2+4)*2)/4-1-1,d7 ;-1 coz last empty lword killed, (spr1dat)
sprcopyloop:
	move.l	(a0)+,(a1)+
	dbf	d7,sprcopyloop
;-----------------------------
drawline:
	lea	Polykoords(pc),a0

	moveq	#polygons-1,d7
drawline_polyloop:
	moveq	#0,d6
	move.b	(a0)+,d6	;points of polygon
	moveq	#80,d0
	add.w	d0,d0
	moveq	#127,d1
	add.b	(a0)+,d0	;start x polygon
	add.b	(a0)+,d1	;start y polygon
	lea	Lineoffsets(pc),a1
	moveq	#0,d2
	move.b	(a0)+,d2
	add.w	d2,a1
	add.w	d2,a1

drawline_pointloop:
	move.b	(a1)+,d2
	ext.w	d2
	add.w	d0,d2

	move.w	d1,d3
	add.b	(a1)+,d3	;take care, no extend for THIS object!!!

movem.l	d0-a6,-(a7)
;/-----------------------------
	cmp.w	d1,d3
	beq.b	noline
	bgt.b	nochange
	exg.l	d0,d2
	exg.l	d1,d3

nochange:
	sub.w	d0,d2	;delta x
	asl.w	#4,d0	;float x
	asl.w	#4,d2	;float delta x
	
	sub.w	d1,d3	;delta y

	move.w	d3,d7	;loopcount = delta y = number of points
	bpl.b	noneg	;delta y may be negative...
	neg.w	d7	;---but not loopcounter!!
noneg:
	ext.l	d2
	ext.l	d3

	divs	d7,d2	;delta point x
	divs	d7,d3	;delty point y (just 1 or -1)

	subq.w	#1,d7
lineloop:
	move.w	d0,d5	;copy float x
	addq.w	#7,d5	;NO! integer
	asr.w	#4,d5	;float x to x
	move.w	d1,d6	;copy y

	lsl.w	#6,d6
	move.w	d5,d4
	lsr.w	#3,d5
	sub.w	d5,d6
	lea	40+plane1-clrbase(a6,d6.w),a0

	bchg	d4,(a0)

	add.w	d2,d0
	add.w	d3,d1
	dbf	d7,lineloop

noline:
;/-----------------------------
	movem.l	(a7)+,d0-a6

	move.l	d2,d0
	move.l	d3,d1
	dbf	d6,drawline_pointloop
	dbf	d7,drawline_polyloop

;----------------------------
;----------------------------
fill:
	lea	256*64+((20)*2)+plane1-clrbase(a6),a0

	lea	$dff000+dmacon,a5
	move.w	#%0000000000101000,intena-dmacon(a5)

blitwait:
	btst	#14,dmaconr-dmacon(a5)
	bne.b	blitwait

	MOVE.l	a0,bltapth-dmacon(A5)
	MOVE.l	a0,bltdpth-dmacon(A5)
	moveq	#24,d0
	MOVE.w	d0,bltamod-dmacon(A5)
	MOVE.w	d0,bltdmod-dmacon(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0-dmacon(a5);0+1 con
	moveq	#-1,d0
	MOVE.l	d0,bltafwm-dmacon(a5)
	move.w	#256*64+20,BLTSIZE-dmacon(A5)
;----------------------------

	move.w	#%1000000100100000,(a5)	;4sprite
	move.w	#%0000000010000000,(a5)

	move.l	#$298129c1,diwstrt-dmacon(a5)
	move.l	#$003800d0,ddfstrt-dmacon(a5)

	move.w	#%0001001000000000,bplcon0-dmacon(a5)
	clr.l	bplcon1-dmacon(a5)

	move.w	#$0018,bpl1mod-dmacon(a5)	;1mod (just one plane used!!)
	move.l	#$0fff0000,$180-dmacon(a5)

	move.w	#$0fee,$1a2-dmacon(a5)
	move.l	#$0cbb0544,$1a4-dmacon(a5)

;------------------------------------------

l:

wait:
	btst.b	#5,$01f-dmacon(a5)
	beq	wait
	move.w	#%0000000001100000,$09c-dmacon(a5)

;---
	lea	(spr0pth+8*4)-dmacon(a5),a4

	move.l	#plane1,bpl1pth-dmacon(a5)

	lea	sprite0-clrbase(a6),a0

	lea	sprite1-clrbase(a6),a1
	moveq	#3,d7
spriteset_loop:
	movem.l	a0-a1,-(a4)
	dbf	d7,spriteset_loop

;----------
;---
	btst	#6,ciaapra
	bne.b	wait

	move.w	#%1000000000101000,intena-dmacon(a5)

back:
	move.w	#%1000000010000000,(a5)
	movem.l	(a7)+,d0-a6

	lea	dosname(pc),a1
	jsr	findresident(a6)
	move.l	d0,a0
	move.l	22(a0),a0
	moveq	#$00,d0
	rts



;intel-outside-logo, vectorized with one of my AMOS-tools :)

Polygons= 19
Polykoords:
;Polygon 1
dc.b  80
dc.b -56,-94
dc.b	0/2
;Polygon 2
dc.b  6
dc.b -27,-69
dc.b	162/2
;Polygon 3
dc.b  16
dc.b  34,-54
dc.b	176/2
;Polygon 4
dc.b  19
dc.b -3,-44
dc.b	210/2
;Polygon 5
dc.b  4
dc.b -1,-40
dc.b	250/2
;Polygon 6
dc.b  10
dc.b  66,-29
dc.b	260/2
;Polygon 7
dc.b  4
dc.b  89,-27
dc.b	282/2
;Polygon 8
dc.b  15
dc.b -72,-16
dc.b	292/2
;Polygon 9
dc.b  5
dc.b  87,-15
dc.b	324/2
;Polygon 10
dc.b  19
dc.b -99,-4
dc.b	210/2
;Polygon 11
dc.b  4
dc.b -35,-2
dc.b	282/2
;Polygon 12
dc.b  4
dc.b -98, 0
dc.b	250/2
;Polygon 13
dc.b  16
dc.b  13, 0
dc.b	176/2
;Polygon 14
dc.b  13
dc.b -23, 9
dc.b	336/2
;Polygon 15
dc.b  5
dc.b -37, 10
dc.b	324/2
;Polygon 16
dc.b  4
dc.b -63, 12
dc.b	364/2
;Polygon 17
dc.b  15
dc.b  21, 28
dc.b	374/2
;Polygon 18
dc.b  9
dc.b  70, 35
dc.b	406/2
;Polygon 19
dc.b  6
dc.b  64, 42
dc.b	426/2


Lineoffsets:
;1 (egg)
dc.b  20, 0
dc.b  22, 2
dc.b  19, 3
dc.b  16, 3
dc.b  21, 6
dc.b  19, 7
dc.b  16, 8
dc.b  18, 11
dc.b  12, 11
dc.b  10, 10
dc.b  9, 13
dc.b  7, 15
dc.b  2, 12
dc.b  2, 10
dc.b -3, 12
dc.b -3, 11
dc.b -7, 11
dc.b -7, 8
dc.b -16, 13
dc.b -26, 13
dc.b -28, 7
dc.b -17, 2
dc.b -36,-1
dc.b -22,-3
dc.b -19,-5
dc.b -17,-6
dc.b -24,-12
dc.b -18,-11
dc.b -14,-14
dc.b -10,-16
dc.b -6,-14
dc.b -1,-19
dc.b  3,-12
dc.b  7,-11
dc.b  13,-13
dc.b  15,-10
dc.b  17,-7
dc.b  23,-6
dc.b  10,-1
dc.b -1, 17
dc.b -9, 1
dc.b -16, 3
dc.b -16, 5
dc.b -17, 9
dc.b -9, 10
dc.b -9, 16
dc.b  1, 18
dc.b  9, 21
dc.b  15, 15
dc.b  15, 10
dc.b  22, 10
dc.b  21, 7
dc.b  18, 4
dc.b  26, 3
dc.b  34, 0
dc.b  14,-2
dc.b  25,-6
dc.b  23,-11
dc.b  12,-8
dc.b  10,-10
dc.b  8,-16
dc.b  1,-12
dc.b -2,-11
dc.b -5,-14
dc.b -7,-12
dc.b -11,-12
dc.b -8,-7
dc.b -11,-7
dc.b -15,-8
dc.b -17,-8
dc.b -15,-5
dc.b -15,-4
dc.b -20,-4
dc.b -20,-3
dc.b -25, 0
dc.b -24, 2
dc.b -15, 3
dc.b -15, 4
dc.b -2,-21
dc.b  19,-3
dc.b  24,-1
;2 (l)
dc.b  12, 1
dc.b -2, 26
dc.b -3, 32
dc.b -6, 0
dc.b -2,-10
dc.b  0,-26
dc.b  1,-23
;3 (t)
dc.b  1, 9
dc.b  9, 4
dc.b  9, 2
dc.b -1, 3
dc.b -4, 3
dc.b -11,-3
dc.b -2, 5
dc.b -1, 27
dc.b -2, 7
dc.b -8,-1
dc.b -1,-5
dc.b -1,-37
dc.b -11,-4
dc.b  0,-5
dc.b  11, 2
dc.b  2,-5
dc.b  10,-2
;4 (e)
dc.b  7, 0
dc.b  4, 3
dc.b  4, 5
dc.b  3, 8
dc.b  0, 12
dc.b -7, 8
dc.b -11,-1
dc.b -8,-7
dc.b  1,-4
dc.b  4, 0
dc.b  4, 3
dc.b  4, 4
dc.b  4,-2
dc.b -1,-9
dc.b -9,-3
dc.b -4,-2
dc.b -2,-4
dc.b -1,-6
dc.b  4,-3
dc.b  4,-2
;5 (e-hole)
dc.b  4, 7
dc.b  2, 5
dc.b -6,-2
dc.b -4,-6
dc.b  4,-4
;6 (n)
dc.b  8, 2
dc.b -1, 35
dc.b -8, 0
dc.b -2,-20
dc.b -8,-5
dc.b -6, 25
dc.b -7, 1
dc.b  1,-31
dc.b  7,-5
dc.b  12, 3
dc.b  4,-5
;7 (i-point)
dc.b  3, 3
dc.b -3, 4
dc.b -6,-1
dc.b -1,-4
dc.b  7,-2
;8 (d)
dc.b  6, 2
dc.b  1, 18
dc.b  5, 1
dc.b  7, 6
dc.b  5, 6
dc.b  2, 9
dc.b -2, 12
dc.b -9, 2
dc.b -5,-3
dc.b -6,-5
dc.b  0, 9
dc.b -7, 1
dc.b -2,-2
dc.b  1,-37
dc.b -2,-16
dc.b  6,-3
;9 (i)
dc.b  6, 2
dc.b -2, 31
dc.b -8, 1
dc.b -2,-18
dc.b -1,-13
dc.b  7,-3
dc.b  11, 4
dc.b  8, 10
dc.b -2, 7
dc.b -9, 6
dc.b  1, 7
dc.b  8, 8
dc.b -6, 5
dc.b -8,-6
dc.b -6,-8
dc.b  1,-6
dc.b  11,-8
dc.b -1,-5
dc.b -10,-5
dc.b  2,-9
dc.b  6, 10
dc.b  0, 9
dc.b -7,-3
dc.b -3,-7
dc.b  4,-9
;17 (u)
dc.b -1, 15
dc.b -1, 16
dc.b  6, 2
dc.b  2,-3
dc.b  4, 3
dc.b  9, 2
dc.b  4,-2
dc.b  4,-7
dc.b  2,-13
dc.b  0,-9
dc.b -7,-1
dc.b -4, 21
dc.b -8, 0
dc.b -3,-5
dc.b  2,-19
dc.b -9, 0
;18 (o)
dc.b -10, 1
dc.b -6, 6
dc.b -2, 18
dc.b  4, 7
dc.b  4, 3
dc.b  9,-1
dc.b  6,-5
dc.b  3,-8
dc.b -1,-14
dc.b -7,-7
;19 (o-hole)
dc.b  5, 2
dc.b  2, 5
dc.b -2, 10
dc.b -6, 3
dc.b -4,-4
dc.b  1,-10
dc.b  4,-6









dosname:	dc.b	"dos.library",0
even

sprite0dat:
	dc.w	$1dc8,$2400+6
	incbin	"data/Abyss_0.spr"
	dc.l	0

sprite1dat:
	dc.w	$1dd0,$2400+6
	incbin	"data/Abyss_1.spr"
;	dc.l	0


dc.b	"*Moon greets Felix,Celtic,Miko63,Sbc,Mj*"
b:




rsset	$45000
clrbase:	rs.b	0
plane1:		rs.b	1*256*64
		rs.b	100
sprite0:	rs.b	28+2+2+4
sprite1:	rs.b	28+2+2+4
spritee:	rs.l	1


printt
printt	"Codesize:"
printv	b-a
printt



if write_to_disc=1
if (b-a)=1024
auto	ws\a\0\2\cc\
else
printt
printt	"Cannot write to disc, Codesize must be 1024 bytes"
endif
else
if (b-a)<>1024
printt	"Note: Codesize must be 1024 bytes!"
endif
endif

