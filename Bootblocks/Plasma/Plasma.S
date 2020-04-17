;------------------------------------------------------------------------
;-                                                                      -
;-                                PLASMA                                -
;-                               --------                               -
;-                                                                      -
;-                                                                      -
;-ASMOne instructions:                                                  -
;- ASMOne start-->you have to allocate chipmem                          -
;- ws	write sector                                                    -
;- a	memory adress                                                   -
;- 0	disc adress                                                     -
;- 2	length                                                          -
;- cc	calculate checksum                                              -
;-                                                                      -
;-                                                                      -
;- coded in june 1993 by Moon, used for Abyss Eternal Terror Packdisc   -
;------------------------------------------------------------------------

col_abyss_rght=$0101
col_abyss_left=$0315
col_abyss_back=$0103

col_teror_rght=$0036
col_teror_left=$0012
col_teror_back=$0024


col_abyss_left_back=col_abyss_left*$10000+col_abyss_back
col_teror_rght_long=col_teror_rght*$10000+col_teror_rght
col_teror_left_long=col_teror_left*$10000+col_teror_left
col_teror_back_long=col_teror_back*$10000+col_teror_back

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


s:
move.l	4,a6
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
	lea	clrbase,a5
;-------------
	move.l	a5,a0
	move.w	#$184b,d0
clrloop:
	clr.l	(a0)+
	dbf	d0,clrloop

;----------
sinuscopy1:
	lea	sinus_1(pc),a0
	lea	sinus-clrbase(a5),a1
	lea	240(a1),a2
	move.l	a1,a3

	moveq	#29,d0
sincopy1l1:
	move.w	#398,d2
	move.w	(a0)+,d1
	sub.w	d1,d2
	move.w	d2,-(a2)
	move.w	d1,-120(a2)
	move.w	d2,120(a1)
	move.w	d1,(a1)+
	dbf	d0,sincopy1l1

	moveq	#119,d0
sinuscopy1l2:
	move.w	(a3)+,240-2(a3)
	dbf	d0,sinuscopy1l2
;----------------------------
;----------
sinuscopy2:
	lea	sinus_2(pc),a0
	lea	sinus2-clrbase(a5),a3
	lea	90(a3),a1
	move.l	a1,a2
	
	moveq	#22,d0
sincopy2l1:
	move.w	(a0)+,d1
	move.w	d1,-90(a1)
	move.w	d1,-(a2)
	neg.w	d1
	move.w	d1,90(a2)
	move.w	d1,(a1)+
	dbf	d0,sincopy2l1

	moveq	#89,d0
sinuscopy2l2:
	move.w	(a3),180*1(a3)
	move.w	(a3),180*2(a3)
	move.w	(a3)+,180*3(a3)
	dbf	d0,sinuscopy2l2
;----------------------------
;-----------
coppercopy1:
	lea	copperlist-clrbase(a5),a0
	move.w	#$2641,d2
	move.l	#$01800000,d3
	move.w	#199+64,d1
	moveq	#-2,d4

coppercopy1l1:
	move.w	d2,(a0)+
	move.w	d4,(a0)+
	add.w	#$0100,d2

	moveq	#47,d0
coppercopy1l2:
	move.l	d3,(a0)+
	dbf	d0,coppercopy1l2
	move.l	d3,(a0)+
	dbf	d1,coppercopy1l1
	move.l	d4,(a0)
;-------------------------------
;----------
makecolour:
	lea	colour1+((76+64)*2)-clrbase(a5),a0
	lea	248(a0),a2
	moveq	#0,d0
	moveq	#15,d7
makecoll1:
	moveq	#3,d6
makecoll2:
	move.w	d0,(a0)+	
	move.w	d0,-(a2)	
	dbf	d6,makecoll2

	add.w	#$0001,d0
	dbf	d7,makecoll1
;---------------------------

	lea	gfxname(pc),a1		;name gfxlib
	jsr	oldopenlibrary(a6)	;openlib
	
	move.l	d0,A6			; Use The GfxBase Pointer
	lea	textattr(pc),A0		; FontStructure Pointer To A0
	lea	fontname(pc),a1
	move.l	a1,(a0)			;insert fontname in textattrlist
	jsr	openfont(A6)
	move.l	d0,a1			;fontpointer
	lea	fontadress(pc),a0
	move.l	34(A1),(a0)		;fontadress

;	lea	plane1adress(pc),a0	;bitplane-adr...

;###############################################################
	lea	zoom(pc),a3
	lea	print(pc),a4

	lea	text1(pc),a0

	moveq	#6,d0
	lea	plane1adress+44*16+0-clrbase(a5),a1	;planeadress
	jsr	(a4)	;print

	lea	text2(pc),a0
	moveq	#5,d0
	lea	plane1adress+44*38+4-clrbase(a5),a1	;planeadress
	jsr	(a4)	;print

	jsr	(a3)	;zoom
	jsr	(a3)	;zoom

	lea	plane1adress-clrbase(a5),a0
	lea	plane2adress-clrbase(a5),a1
	move.w	#2815,d0
planecopyloop:
	move.l	(a0)+,(a1)+
	dbf	d0,planecopyloop

	lea	text4(pc),a0
	moveq	#4,d0
	lea	plane1adress+44*2-clrbase(a5),a1	;planeadress
	jsr	(a4);	print
	jsr	(a3)
	jsr	(a3)
	jsr	(a3)
;------------------
movem.l	d0-a6,-(a7)
	lea	plane1adress+[71*44]-clrbase(a5),a0	;bitplane-adr...
	lea	plane1adress+[239*44]-clrbase(a5),a1
	moveq	#55,d1
yzooml1:
	movem.l	(a0),d2-d7/a2-a6
	moveq	#3,d0
yzooml2:
	movem.l	d2-d7/a2-a6,(a1)
	lea	-44(a1),a1
	dbf	d0,yzooml2
	lea	-44(a0),a0
	dbf	d1,yzooml1

movem.l	(a7)+,d0-a6
;------------------
	lea	$dff000,a4	;basic custom chips

	move.l	#$42000034,bplcon0(a4)
	clr.w	bplcon2(a4)

	lea	diwstrt(a4),a0
	move.l	#$2a812ac9,(a0)+	;diwstrt/diwstop
	move.l	#$003800d9,(a0)+	;ddfstrt/ddfstop
	;move.w	#%0000000000100000,(a0)	;dmacon
	move.w	#%1000001111000000,(a0)	;dmacon

	move.l	#$00020002,bpl1mod(a4)
	move.l	copperlist-clrbase(a5),$80(a4)

;--------
	lea	$182(a4),a0
	move.w	#col_abyss_rght,(a0)+
	move.l	#col_abyss_left_back,(a0)+

	move.l	#col_teror_rght_long,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+

	move.l	#col_teror_left_long,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+

	move.l	#col_teror_back_long,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
;-----------
	lea	copperlist-clrbase(a5),a0
	move.l	a0,cop1lch(a4)
	move.w	d0,copjmp1(a4)
	move.l	$6c.w,-(a7)
	lea	introut(pc),a0
	move.l	a0,$6c.w

	movem.l	d0-a6,-(a7)

;---------------------------------
plasma:
wait:
	lea	sleep-clrbase(a5),a1
	move.w	#1,(a1)	;now a1=sinus
wait2:
	tst.w	(a1)
	bne.b	wait2
;------
colput:
	addq.l	#2,a1	;now a1=sinus
	moveq	#47,d0
	lea	copperlist+6-clrbase(a5),a3
	lea	sinuscounta-clrbase(a5),a0
	move.w	(a0),d3
	addq.w	#2,d3
	cmp.w	#240,d3
	ble.b	nosinrestarta
	sub.w	#240,d3
nosinrestarta:
	move.w	d3,(a0)

	bsr.w	blitwait

	moveq	#99,d2
	add.w	d2,d2
	move.l	d2,bltamod(a4)	;amod=0,dmod=48*4+6

	move.w	#%0000100111110000,bltcon0(a4)
	moveq	#-1,d2
	move.l	d2,bltafwm(a4)	;=-1
	addq.l	#1,d2
	move.w	d2,bltcon1(a4)	;=0
colputl1:
	lea	colour1-clrbase(a5),a2
	move.w	0(a1,d3.w),d2
	add.l	d2,a2
	addq.l	#4,d3

	bsr.w	blitwait

	movem.l	a2/a3,bltapth(a4)	;a+d
	move.w	#64*264+1,bltsize(a4)
	addq.l	#4,a3
	dbf	d0,colputl1
;--------------------------
;-----------
coppercopy2:
	moveq	#0,d0
	lea	sin2pos-clrbase(a5),a0
	move.w	(a0),d0
	add.w	#12,d0
	cmp.w	#180,d0
	ble.b	nosin2restart
	sub.w	#180,d0
nosin2restart:
	move.w	d0,(a0)

	lea	copperlist-clrbase(a5),a0
	lea	sinus2-clrbase(a5),a1
	add.l	d0,a1

	move.w	#199+64,d1
coppercopy2l1:
	moveq	#$2f,d2
	add.w	(a1)+,d2
	move.b	d2,1(a0)
	lea	48*4+8(a0),a0
	dbf	d1,coppercopy2l1
;-------------------------------

	btst	#6,ciaapra	;mouse
	bne.w wait
;---------------------------------
	movem.l	(a7)+,d0-a6

	move.l	(a7)+,$6c.w	;alter verticalvector
;	move.w	#%1000001111100000,dmacon(a4)

	move.l	$26(a6),$80(a4)		;systemcopperlist
	move.w	#%1000000001001000,intena(a4)

;--------------------------------------------------------------------
	movem.l	(a7)+,d0-a6		;restore some register

	lea	gfxname+5(pc),a1	;change graphics.library
	move.w	#"do",(a1)		;to          dos.library

	jsr	findresident(a6)
	move.l	d0,a0
	move.l	22(a0),a0
	moveq	#$00,d0
rts
;..................................................................
blitwait:
	btst	#14,dmaconr(a4)
	bne.b	blitwait
rts

print:

printloop:
	moveq	#0,d1			;clear register
	move.b	(a0)+,d1		;next char
	move.l	fontadress(pc),a2		;fontadress
	lea	-32(a2,d1.w),a2		;charadress

	moveq	#7,d1
charputloop:
	move.b	(a2),(a1)
	lea	$c0(a2),a2
	lea	44(a1),a1
	dbf	d1,charputloop
	lea	1-8*44(a1),a1
	dbf	d0,printloop
	rts

zoom:
	lea	plane1adress+[127*44]+20-clrbase(a5),a0	;bitplane-adr...
	lea	[255*44]+40-[[127*44]+20](a0),a1
	moveq	#126,d1
yloop:
	moveq	#9,d0
xloop:
	move.w	-(a0),d3
	move.w	d3,d4
	moveq	#15,d2
bitloop:
	roxl.w	#1,d3
	roxl.l	#1,d5
	roxl.w	#1,d4
	roxl.l	#1,d5
	dbf	d2,bitloop

	move.l	d5,-(a1)
	move.l	d5,-44(a1)

	dbf	d0,xloop
	lea	-[44-20](a0),a0
	lea	-[4+44](a1),a1
	dbf	d1,yloop
rts
;..................................................................

textstart:
text1:
dc.b	"ETERNAL"
text2:
dc.b	"TERROR"
text4:
dc.b	"ABYSS"

textattr:	DC.L	0
		DC.W	8
		DC.B	0
		DC.B	0
fontname:	DC.B	"topaz.font",0,0


dc.b	0
gfxname:	dc.b	"graphics.library",0
textend:

;----------------------------------------------------------------------

introut:
;	btst.b	#5,$01f(a4)
;	beq.b	intback
	movem.l	d0-d7/a0-a6,-(a7)

	lea	sleep-clrbase(a5),a0
	clr.w	(a0)

	lea	bpl1pth(a4),a0
	moveq	#$2c,d0

	lea	plane1adress-clrbase(a5),a1
	move.l	a1,(a0)+

	add.l	d0,a1
	move.l	a1,(a0)+

	lea	plane2adress-clrbase(a5),a1
	move.l	a1,(a0)+

	add.l	d0,a1
	move.l	a1,(a0)

	
	movem.l	(a7)+,d0-d7/a0-a6
intback:
	move.w	#%0000000001001000,intena(a4)
	move.w	#%0000000001100000,$09c(a4)
	rte


sinus_1:
dc.w  202,212, 224, 234, 244, 254, 264, 274, 284, 292, 302, 310, 320, 328
dc.w  336,342, 350, 356, 362, 368, 374, 378, 384, 386, 390, 394, 396, 398
dc.w  398,398

sinus_2:
dc.w  0, 0, 2, 4, 6, 6, 8, 10, 10, 12, 14, 14, 16, 16, 18, 18, 18, 20, 20
dc.w  20, 20, 20, 20
;dc.b	"MOON"
dc.l	$68b6e3b3
b:
fontadress:	dc.l	0

rsset	$50000
clrbase:	rs.b	0
sinuscounta:	rs.w	1
sin2pos:	rs.w	1
sleep:		rs.w	0
sinus:		rs.b	240*2
sinus2:		rs.b	180*4
colour1:	rs.b	1056
plane1adress:	rs.b	$2c2c
plane2adress:	rs.b	$2c2c
copperlist:	rs.b	53000



