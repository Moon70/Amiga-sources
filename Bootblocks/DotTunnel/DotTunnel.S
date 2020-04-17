;------------------------------------------------------------------------
;-                                                                      -
;-                           Dottunnelboot                              -
;-                          ---------------                             -
;-                                                                      -
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
;- coded by Moon/ABYSS                                   September 1994 -
;------------------------------------------------------------------------
are_you_sure=0	;set this to 1 for assembling  <----------------------
write_to_disc=0	;seth this to 1 to write bootblock to disc  <---------

wave=6
turn_tunnel=0	;turning tunnel costs 2 bytes
speedx=3
speedy=2
col01=$00030058
col23=$007c0fff



OpenFont=-72
oldopenlibrary=-408

findresident=-96
execbase=4
ciaapra=$bfe001
dmacon=$96
dmaconr=$002
openlibrary=-30-522
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

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c

forbid=-132
permit=-138


;-------------------
radius=34/2
circle=36*2
step=4
startrad=70

maxrad=radius*step



ifeq	are_you_sure
printt
printt
printt	"Note:"
printt	"      Source not assembled !"
printt	"      Read text (first page of source) first !"
end
endif

if wave>6
printt	"Note:"
printt	"      Source not assembled !"
printt	"      Illegal wave size!"
end
endif

s:
move.l	4.w,a6
bsr.b	start
rts

a:
block:
kennung:	dc.b	"DOS",0
checksumme:	dc.l	0
rootblock:	dc.l	$00000370

start:
movem.l	d0-a6,-(a7)		;store some register
;--------------------------------------------------------------------
	lea	$dff000,a5
	lea	clrbase,a6
;-------------------------
clrmem:
	move.l	a6,a0
	move.w	#$e3d7,d0
clrmemloop:
	clr.l	(a0)+
	dbf	d0,clrmemloop
;----------------------------
;-------
sprcopy:
	lea	sprite0dat(pc),a0
	lea	sprite0-clrbase(a6),a1
	moveq	#29+3,d7
sprcopyloop:
	move.l	(a0)+,(a1)+
	dbf	d7,sprcopyloop
;-----------------------------
;------------
stretchsinus:
	lea	sinusraw2-clrbase(a6),a0
	lea	sinusraw(pc),a1
;	lea	-90(a0),a1

	moveq	#44,d7
stretchsinusloop:
	move.w	(a1),(a0)+
	move.w	(a1)+,(a0)+
	dbf	d7,stretchsinusloop
;-------------------------------
;------------------------------
expandsinus:
	lea	sinusraw2-clrbase(a6),a0

	lea	sinus-clrbase(a6),a1
	lea	720(a1),a2

	moveq	#89,d7
expandsinusloop:
	moveq	#0,d0
	sub.w	(a0),d0
	move.w	d0,-(a2)	;sector 4.1
	move.w	(a0),-360(a2)	;sector 2.1
	move.w	(a0),720-360(a2);sector 2.2
	move.w	(a0),720(a1)	;sector 1.2
	move.w	d0,720(a2)	;sector 4.2
	move.w	d0,720+360(a1)	;sector 3.2
	move.w	d0,360(a1)	;sector 3.1
	move.w	(a0)+,(a1)+	;sector 1.1
	dbf	d7,expandsinusloop
;-------------------------------
;----------
makestruct:
	lea	struct-clrbase(a6),a0
	moveq	#39,d7
	moveq	#0,d0
makestructloop:
	moveq	#step,d1
	mulu.w	d0,d1
	move.w	d1,(a0)+
	clr.l	(a0)+
	addq.w	#1,d0
	dbf	d7,makestructloop
;--------------------------------
;-----------
sinusxymaker:
	lea	sinus-clrbase(a6),a0
	lea	sinusx-clrbase(a6),a1
	lea	sinusy-clrbase(a6),a2
	move.w	#359,d7
sinusxymakerloop:
	move.w	(a0)+,d0	;sin
	move.w	d0,d1
	muls.w	#150,d0		;sinx=r90
	muls.w	#110,d1		;siny=r80
	swap	d0
	move.w	d0,(a1)+
	swap	d1
	move.w	d1,720(a2)
	move.w	d1,(a2)+
	dbf	d7,sinusxymakerloop
;---------------------------------
;-------------
tunnelprecalc:
	lea	dots-clrbase(a6),a0
	lea	sinus+90-clrbase(a6),a1
	move.l	showplane-clrbase(a6),a2
	
	moveq	#0,d0	;rs#
	moveq	#1,d1	;dr#
	swap	d1
	moveq	#0,d3	;s#

	move.w	#239,d7
rsloop:
	moveq	#20,d2	;r=25...
	swap	d1
	add.w	d1,d2	;...+dr#
	swap	d1

	move.w	#359,d6	;w#
wloop:
	move.w	d3,d4	;d4=s#
	add.w	d6,d4	;d4=s#+w#
	add.w	d4,d4

	move.w	90(a1,d4.w),d5	;sin.w
	move.w	-90(a1,d4.w),d4	;cos.w

	muls	d2,d4
	add.l	d4,d4
;	add.l	#32768,d4
	swap	d4
	muls	d2,d5
	add.l	d5,d5
;	add.l	#32768,d5
	swap	d5
	add.w	#160+120,d4
	add.w	#126+128,d5

	tst.w	d4
	bmi.b	badpoint
	cmp.w	#512,d4
	bge.b	badpoint
	tst.w	d5
	bmi.b	badpoint
	cmp.w	#512,d5
	ble.b	goodpoint
badpoint:
	moveq	#0,d4
	moveq	#0,d5
goodpoint:
	move.w	d4,(a0)+
	move.w	d5,(a0)+

	subq.w	#5,d6
	bpl.b	wloop

	move.w	d1,d4	;d4=lo
	swap	d1
	mulu	#33868,d4
	mulu	#33868,d1

	add.l	d4,d4
	addx.l	d1,d1
	sub.w	d4,d4
	swap	d4
	add.l	d4,d1

ifne	turn_tunnel
	addq.w	#1,d3
else
	nop
endif
	dbf	d7,rsloop
;------------------------

	move.w	#%0000000010000000,dmacon(a5)
	move.w	#%1000001101100000,dmacon(a5)
	move.w	#%0000000001001000,intena(a5)
;	move.w	#$7fff,intena(a5)

	move.l	#$298129c1,diwstrt(a5)
	move.l	#$003800d0,ddfstrt(a5)
	move.l	#%00100010000000000000000000001111,bplcon0(a5)
	clr.w	bplcon2(a5)
	move.l	#$00180018,bpl1mod(a5)	;1mod+2mod!
	move.w	#%1000001101100000,dmacon(a5)

	lea	pointplane-clrbase(a6),a0
	move.l	#plane2-plane1,d0

	lea	plane1,a1
	move.l	a1,(a0)+
	add.l	d0,a1
	move.l	a1,(a0)+
	add.l	d0,a1
	move.l	a1,(a0)+

	move.l	#col01,$180(a5)
	move.l	#col23,$184(a5)


	move.w	#$0499,$1a2(a5)
	move.l	#$026607aa,$1a4(a5)

	move.w	#$0499,$1aa(a5)
	move.l	#$026607aa,$1ac(a5)



;------------------------------------------


;------------------------------------------
	move.l	$6c.w,-(a7)
	lea	introut(pc),a0
	move.l	a0,$6c.w

wait:
	btst	#6,ciaapra
	bne.b wait

back:
	move.l	(a7)+,$6c.w
	move.w	#%1000000010000000,dmacon(a5)
	move.w	#%1000000001001000,intena(a5)
	movem.l	(a7)+,d0-a6

	lea	dosname(pc),a1
	jsr	findresident(a6)
	move.l	d0,a0
	move.l	22(a0),a0
	moveq	#$00,d0
	rts

blitwait:
	btst	#14,$dff002
;	btst	#14,dmaconr(a5)
	bne.b	blitwait
	rts
;----------
;-------
introut:
	move.w	#%0000000001001000,intena(a5)
	move.w	#%0000000001100000,$09c(a5)

	movem.l	d0-a6,-(a7)
	move.l	showplane-clrbase(a6),d0
	add.l	#10+64*128,d0
	move.l	d0,bpl1pth(a5)
	add.l	#64*1,d0
	move.l	d0,bpl2pth(a5)

;	move.l	#plane1adress,bpl2pth(a5)




	lea	sprite0-clrbase(a6),a0
	lea	spr0pth+8*4(a5),a4

	lea	spritee-sprite0(a0),a1
	move.l	a0,-(a4)
	move.l	a0,-(a4)
	move.l	a0,-(a4)
	move.l	a0,-(a4)
	move.l	a0,-(a4)

	lea	sprite1-sprite0(a0),a1
	lea	sprite2-sprite0(a0),a2

	movem.l	a0-a2,-(a4)

;----------------------------------------
;--------------------------------
planecls:
	move.l	clearplane-clrbase(a6),a0
	lea	10+64*128(a0),a0
	move.l	a0,BLTDPTH(A5)
	move.w	#24,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#(257)*64+20,BLTSIZE(A5)
;-------------------------------------------
;-------------------------------------------
;--------
drawdots:
	move.l	pointplane-clrbase(a6),a0
	lea	struct-clrbase(a6),a2
;struct dc.w	radius,x pos screen,y pos screen

	moveq	#radius-1,d7
flagloop2:
	move.w	(a2),d0		;get radius from struct
	addq.w	#1,d0		;increase
	cmp.w	#maxrad,d0	;maximum size?
	bne.b	noradflow	;no->continue
	moveq	#0,d0		;yes->restart with zero

				;now set new screenpos for newborn circle
	lea	sinusx-clrbase(a6),a1	;sinus x table
	lea	sinxpos-clrbase(a6),a4
	move.w	(a4),d3	;sinus x position
	sub.w	#speedx*4,d3		;move left/right
	bpl.b	nosinxflow	;overflow
	add.w	#720,d3
nosinxflow:
	move.w	d3,(a4)	;write new sinusxpoint back
	move.w	(a1,d3.w),2(a2)	;write new x-screenpos

;	add.w	#720+180,d3		;sinus x table length is 720 bytes
;	move.w	(a1,d3.w),4(a2)	;write new	y-screenpos

	lea	sinusy-clrbase(a6),a1	;sinus x table
	lea	sinypos-clrbase(a6),a4
	move.w	(a4),d3	;sinus y position
	sub.w	#speedy*4,d3		;move up/down
	bpl.b	nosinyflow	;overflow
	add.w	#720,d3
nosinyflow:
	move.w	d3,(a4)	;write new sinusxpoint back
	move.w	(a1,d3.w),4(a2)	;write new x-screenpos
	
noradflow:
	move.w	d0,(a2)+	;write increased radius back
	mulu	#2*circle*4,d0
	lea	dots-clrbase(a6),a1
				;dots (dc.w x,y)*circle
	lea	72*4*startrad(a1),a1
	add.l	d0,a1
	move.w	(a2)+,d3	;x-offset
	move.w	(a2)+,d4	;y-offset


	moveq	#(circle)-1,d6
flagloop1:
	move.w	(a1)+,d0	;get x
	move.w	(a1)+,d1	;get y
	add.w	d3,d0
	add.w	d4,d1

	lsl.w	#6,d1
	move.w	d0,d2
	lsr.w	#3,d0
	sub.w	d0,d1

	bset.b	d2,64(a0,d1.w)

	dbf	d6,flagloop1
	dbf	d7,flagloop2	
;---------------------------
;------------
switchplanes:
	lea	pointplane-clrbase(a6),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
;-------------------------------------------
	bsr.w	blitwait
	movem.l	(a7)+,d0-a6
intback:
	rte
;----------

dosname:	dc.b	"dos.library",0

even

sprite0dat:
	dc.w	$1dc8,$2700+6
	incbin	"data/Micrologo1_0.spr"
	dc.l	0

sprite1dat:
	dc.w	$1dd0,$2700+6
	incbin	"data/Micrologo1_1.spr"
	dc.l	0

sprite2dat:
	dc.w	$1dd8,$2700+6
	incbin	"data/Micrologo1_2.spr"
	dc.l	0


sinusraw:
if	wave=0
dc.w  0, 1144, 2286, 3425, 4560, 5690, 6813, 7927, 9032, 10126, 11207, 12275
dc.w  13328, 14365, 15384, 16384, 17364, 18324, 19261, 20174, 21063, 21926
dc.w  22763, 23571, 24351, 25102, 25822, 26510, 27166, 27789, 28378, 28932
dc.w  29452, 29935, 30382, 30792, 31164, 31499, 31795, 32052, 32270, 32449
dc.w  32588, 32688, 32748
endif

if	wave=1	;tunnelwave1
dc.W  0, 1600, 3196, 4780, 6349, 7897, 9419, 10910, 12365
dc.W  13779, 15149, 16470, 17737, 18947, 20096, 21181, 22199
dc.W  23146, 24021, 24821, 25545, 26190, 26756, 27241, 27645
dc.W  27968, 28210, 28371, 28451, 28453, 28377, 28225, 27999
dc.W  27701, 27333, 26899, 26402, 25844, 25229, 24562, 23844
dc.W  23082, 22278, 21436, 20563
endif

if	wave=2	;tunnelwave2
dc.W  0, 1827, 3635, 5406, 7121, 8764, 10320, 11775, 13116
dc.W  14333, 15419, 16369, 17180, 17850, 18383, 18782, 19055
dc.W  19211, 19260, 19215, 19091, 18903, 18667, 18399, 18118
dc.W  17839, 17580, 17355, 17180, 17066, 17026, 17069, 17202
dc.W  17430, 17755, 18179, 18698, 19308, 20002, 20771, 21603
dc.W  22486, 23404, 24343, 25286
endif

if	wave=3	;tunnelwave3 (octagon)
dc.W  0, 1588, 3163, 4712, 6225, 7688, 9093, 10428, 11686
dc.W  12860, 13945, 14936, 15831, 16630, 17333, 17943, 18463
dc.W  18900, 19260, 19551, 19781, 19961, 20100, 20209, 20299
dc.W  20381, 20464, 20559, 20675, 20819, 20999, 21221, 21489
dc.W  21806, 22174, 22593, 23061, 23574, 24129, 24719, 25336
dc.W  25973, 26619, 27264, 27897
endif

if	wave=4
dc.W  0, 1574, 3093, 4507, 5772, 6858, 7746, 8433, 8932, 9268
dc.W  9481, 9616, 9726, 9864, 10080, 10418, 10909, 11573
dc.W  12416, 13425, 14578, 15837, 17155, 18478, 19752, 20924
dc.W  21947, 22784, 23410, 23816, 24006, 24001, 23833, 23545
dc.W  23189, 22818, 22485, 22238, 22115, 22143, 22335, 22690
dc.W  23189, 23803, 24490
endif

if	wave=5	;tunelwave5
dc.W  0, 1696, 3341, 4890, 6303, 7550, 8617, 9499, 10207
dc.W  10765, 11207, 11576, 11918, 12282, 12713, 13250, 13923
dc.W  14748, 15730, 16860, 18114, 19458, 20849, 22240, 23579
dc.W  24818, 25915, 26835, 27556, 28068, 28377, 28500, 28466
dc.W  28316, 28094, 27851, 27634, 27485, 27441, 27526, 27752
dc.W  28115, 28602, 29184, 29823
endif

if	wave=6
dc.W  0, 2362, 4492, 6199, 7363, 7959, 8057, 7816, 7447, 7187
dc.W  7249, 7789, 8878, 10493, 12512, 14745, 16960, 18926
dc.W  20450, 21415, 21794, 21659, 21167, 20532, 19990, 19753
dc.W  19980, 20742, 22014, 23676, 25539, 27371, 28941, 30057
dc.W  30602, 30550, 29973, 29029, 27933, 26920, 26205, 25945
dc.W  26212, 26983, 28140
endif


dcb.b	4,0
dc.l	$f8142db9
;dc.b	"MooN"
b:




rsset	$45000
clrbase:	rs.b	0
sinuscounta:	rs.w	1
sin2pos:	rs.w	1
sleep:		rs.w	1
sinxpos:	rs.w	1
sinypos:	rs.w	1
pointplane:	rs.l	1
clearplane:	rs.l	1
showplane:	rs.l	1
struct:		rs.w	3*40
sinus:		rs.b	1440
		rs.b	1440

sinusx:		rs.w	360
sinusy:		rs.w	360
		rs.w	360
sprite0:	rs.b	40+4
sprite1:	rs.b	40+4
sprite2:	rs.b	40+4
sinusraw2:	rs.b	180

spritee:	rs.l	1

plane1adress:	rs.b	$2c2c
;plane2adress:	rs.b	$2c2c
dots:		rs.b	69120
dotsend:

	rs.b	1*512*64
plane1:	rs.b	1*256*64
	rs.b	1*256*64
plane2:	rs.b	1*256*64
	rs.b	1*256*64
plane3:	rs.b	1*256*64
	rs.b	1*512*64
last:	rs.b	2


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
