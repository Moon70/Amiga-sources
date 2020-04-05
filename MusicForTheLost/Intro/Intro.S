;------------------------------------------------------------------------
;-                                                                      -
;-                     Music for the Lost - Intropart                   -
;-                    --------------------------------                  -
;-                                                                      -
;-                                                                      -
;- code by Moon, graphics by Artline, music by Neurodancer              -
;-                                                                      -
;-                                                                      -
;-                                                                      -
;-                                                                      -
;-                            (c) 1993 by ABYSS                         -
;-                                                                      -
;------------------------------------------------------------------------


execbase=4
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96

startlist=38
oldopenlibrary=-408

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
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094

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
	move.w	#$03e0,dmacon(a5)
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0000001000000000,bplcon0(a5)
	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
;	move.w	#120,bpl1mod(a5)
;	move.w	#120,bpl2mod(a5)
;	move.w	#160,bpl1mod(a5)
;	move.w	#160,bpl2mod(a5)
	move.w	#%1000001100000000,dmacon(a5)

move.l	#pr_data,pr_module
jsr	pr_init

	move.w	#%0000000001100000,$dff09a
	move.l	$6c,oldint
	move.l	#introut,$6c
	move.w	#%1100000000100000,$dff09a

move.l	#copperlistend,cop1lch(a5)
	move.w	#%1000001111000000,dmacon(a5)
move.w	#0,copjmp1(a5)


	move.l	#0,pic_credits+48
	move.l	#0,pic_credits+52
	move.w	#0,pic_credits+56
wait:
	tst.w	ente
	bne	back
	btst	#6,ciaapra
bne.b wait

back:	move.l	oldint,$6c	;alter verticalvector
	jsr	pr_end
	move.l	execbase,a6
	lea	$dff000,a5
	lea	grname,a1
	moveq	#0,d0
	jsr	oldopenlibrary(a6)
	move.l	d0,a4
	move.l	startlist(a4),cop1lch(a5)
	clr.w	copjmp1(a5)

	move.w	#%1000001111100000,dmacon(a5)
	jsr	permit(a6)
	clr.l	d0
	rts

intcounter:	dc.w	0
ente:		dc.w	0


introut:
	btst.b	#5,$dff01f
	beq.b	intback

movem.l	d0-d7/a0-a6,-(a7)

	subq.w	#1,intcounter
	lea	$dff000,a5
	move.l	pic_bpl,d0
	move.l	d0,bpl1pth(a5)
	add.l	#40,d0
	move.l	d0,bpl2pth(a5)
	add.l	#40,d0
	move.l	d0,bpl3pth(a5)
	add.l	#40,d0
	move.l	d0,bpl4pth(a5)
	add.l	#40,d0
	move.l	d0,bpl5pth(a5)

jsr	realfade
	lea	faded,a0
	lea	$dff180,a1
	move.w	#15,d0
colfadloop1:
	move.l	(a0)+,(a1)+
	dbf	d0,colfadloop1
	jsr	commander

jsr	pr_music
movem.l	(a7)+,d0-d7/a0-a6

intback:
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption


introut2:
	btst.b	#5,$dff01f
	beq.w	intback2

movem.l	d0-d7/a0-a6,-(a7)

	subq.w	#1,intcounter
	lea	$dff000,a5
	move.l	pic_bpl,d0
	move.l	d0,bpl1pth(a5)
	add.l	#40,d0
	move.l	d0,bpl2pth(a5)
	add.l	#40,d0
	move.l	d0,bpl3pth(a5)
	add.l	#40,d0
	move.l	d0,bpl4pth(a5)
	add.l	#40,d0
	move.l	d0,bpl5pth(a5)

jsr	realfade

	lea	faded,a0
	move.l	firstzone,a1
	move.l	secondzone,a2
	move.l	thirdzone,a3


	move.w	#15,d0
colfadloop11:
	move.w	(a0),2(a1)
	move.w	(a0),2(a2)
	move.w	(a0)+,2(a3)
	addq.l	#4,a1
	addq.l	#4,a2
	addq.l	#4,a3
	dbf	d0,colfadloop11

	move.w	#7,d0
	lea	$dff1a0,a1
colfadloop12:
	move.l	(a0)+,(a1)+
	dbf	d0,colfadloop12

jsr	dotline
jsr	dotline
jsr	dotline
jsr	dotline

	jsr	commander

jsr	pr_music
movem.l	(a7)+,d0-d7/a0-a6

intback2:
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption



introut3:
	btst.b	#5,$dff01f
	beq.w	intback3

movem.l	d0-d7/a0-a6,-(a7)

	subq.w	#1,intcounter
	lea	$dff000,a5
	move.l	#pic_credits,d0
	add.l	#32*2,d0
	move.l	d0,bpl1pth(a5)
	add.l	#40,d0
	move.l	d0,bpl2pth(a5)
	add.l	#40,d0
	move.l	d0,bpl3pth(a5)
	add.l	#40,d0
	move.l	d0,bpl4pth(a5)
	add.l	#40,d0
	move.l	d0,bpl5pth(a5)

;jsr	realfade
	lea	faded,a0
	lea	pic_credits,a0
	lea	$dff180,a1
	move.w	#15,d0
colfadloop123:
	move.l	(a0)+,(a1)+
	dbf	d0,colfadloop123




	lea	$dff180,a1
	move.w	#7,d0
depp:
	move.l	#0,(a1)+
	dbf	d0,depp

	lea	$dff1b0,a1
	move.w	#3,d0
depp2:
	move.l	#0,(a1)+
	dbf	d0,depp2


;	jsr	commander

jsr	dotline
jsr	dotline
jsr	dotline
jsr	dotline
jsr	dotline
jsr	pr_music
movem.l	(a7)+,d0-d7/a0-a6

intback3:
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption



oldint:		dc.l	0
planeadr:	blk.l	2*256*40/4,0

pic_col:	dc.l	0
pic_bpl:	dc.l	0



;coder:		blk.b	35600,0
;graphician:	blk.b	35600,0
;musician:	blk.b	35600,0

;>extern "coderpic",coder
;>extern "graphicianpic",graphician
;>extern "musicianpic",musician

pic_abyss:	incbin	"data/1_abyss.con"
pic_presents:	incbin	"data/2_presents.con"
pic_production:	incbin	"data/3_production.con"
pic_credits:	incbin	"data/4_credits2.con"
pic_mftl:	incbin	"data/5_mftl.con"



;codcol:
dc.w	$0000,$0ddd,$0aaa,$0666
dc.w	$0333,$0d97,$0b65,$0843
dc.w	$0622,$0411,$0521,$0732
dc.w	$077e,$044b,$0217,$0104
dc.w	$0355,$0567,$0788,$089a
dc.w	$0850,$0961,$0a72,$0b82
dc.w	$0c94,$0da5,$0ec6,$0016
dc.w	$0128,$034a,$056c,$089e

;gracol:
dc.w	$0000,$03a6,$0aaa,$0666
dc.w	$0333,$0db4,$0b65,$0843
dc.w	$0622,$0411,$0521,$0732
dc.w	$0b02,$0318,$0206,$0104
dc.w	$0355,$0567,$0788,$089a
dc.w	$0850,$0961,$0a72,$0b82
dc.w	$0c94,$0da5,$0ec6,$0016
dc.w	$0128,$034a,$056c,$089e

;muscol:
dc.w	$0000,$0ddd,$0aaa,$0666
dc.w	$0333,$0d97,$0b65,$0843
dc.w	$0622,$0411,$0521,$0732
dc.w	$077e,$044b,$0217,$0104
dc.w	$0355,$0567,$0788,$089a
dc.w	$0850,$0961,$0a72,$0b82
dc.w	$0c94,$0da5,$0ec6,$0016
dc.w	$0128,$034a,$056c,$089e


;0,36			left	inc x
;0,216			left	inc x
;319,122		right	dec x

;289,0			down	inc y
;200,255		up	dec y

dotlx:	dc.w	319

dotly:	dc.w	122

dotlxy:
	dc.w	0,36
	dc.w	0,216
	dc.w	319,122

	dc.w	289,0
	dc.w	200,255

dotladdcode:	dc.w	319,1,0,0
		dc.w	319,1,0,0
		dc.w	0,-1,0,0
		dc.w	0,0,255,1
		dc.w	0,0,0,-1
dotline:

	lea	pic_credits+32*2,a0
	lea	4*40(a0),a4
	lea	3*40(a0),a3

	lea	dotlxy,a1
	moveq	#4,d7

dotlloop:
	moveq	#0,d1

	move.w	(a1)+,d1
	move.w	(a1)+,d0

	mulu.w	#200,d0

	move.w	d1,d2
	lsr.w	#3,d1
	sub.l	d1,d0

	btst.b	d2,39(a4,d0.l)
	beq	skipdotdraw

	bclr.b	d2,39(a3,d0.l)

skipdotdraw:

	dbf	d7,dotlloop



	lea	dotlxy,a1
	lea	dotladdcode,a0
	moveq	#9,d7
dotladdloop:	
	move.w	(a0),d0
	cmp.w	(a1)+,d0
	beq	skipdotladd
	move.w	2(a0),d0
	add.w	d0,-2(a1)

skipdotladd:
	addq.l	#4,a0
	dbf	d7,dotladdloop
move.w	#$0fff,$dff180
move.w	#$0,$dff180
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
	moveq	#35,d1
fadereall1:
	move.w	0(a0,d0.w),(a1)+
	add.l	#30,d0
	dbf	d1,fadereall1
	rts
;*****


fader:
	lea	tofade,a2	;scr-farbdaten
	lea	fadedat,a1	;obj-farbdaten
	lea	faded,a0	;akt-farbdaten
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

colourtab:
dc.w	$0000,$0500,$0311,$0800,$0532,$0d00,$0445,$0557
dc.w	$0a34,$0f44,$0a86,$0889,$0f77,$0aaa,$0bbc,$0fff


;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------


;---------
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
comsleep:	dc.w	1	;|
compoint:	dc.w	0	;|

commands:
;a=150
;b=74
		dc.l	16*6,	firstfade16black

		dc.l	1,	pic1on	;abyss
		dc.l	16*6,	fadecolourtab
		dc.l	16*6,	fade16black

		dc.l	1,	pic2on	;presents
		dc.l	8*6,	fadecolourtab
		dc.l	8*6,	fade16black

		dc.l	1,	pic3on	;production
		dc.l	16*6,	fadecolourtab
		dc.l	16*6,	fade16black

		dc.l	1+16*6,	pic4on
;		dc.l	16*6,	fadecolourtab32
		dc.l	6*6,	fadezone1
		dc.l	6*6,	fadezone2
		dc.l	4*6,	fadezone3

		dc.l	32*6,	fadezone123

		dc.l	1+16*6,	fade32black

		dc.l	1,	pic5on
		dc.l	32*6,	fadecolourtab
		dc.l	32*6,	fade16blackslow


;	dc.l	50,fade31white
;	dc.l	140,fade32white
;	dc.l	140,	fade16blackslow

		dc.l	5,	setente
		dc.l	1,	commandrestart

;---------

commandrestart:
	move.w	#0,compoint
	rts

setente:
	move.w	#1,ente
	rts

fade16black:
	lea	tofade,a1
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#2,fadecount	;coder off
	jsr	fader
	rts

fade32black:
	lea	tofade,a1
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#2,fadecount	;coder off
	jsr	fader
	rts

fade16blackslow:
	lea	tofade,a1
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#6,fadecount	;coder off
	jsr	fader
	rts

firstfade16black:
	lea	tofade,a1
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#5,fadecount	;coder off
	jsr	fader
	rts


fade31white:
	lea	tofade,a1
	moveq	#-1,d0
	move.w	#0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.w	d0,(a1)
	move.w	#1,fadecount	;coder off
	jsr	fader
	rts

fade32white:
	lea	tofade,a1
	moveq	#-1,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#4,fadecount	;coder off
	jsr	fader
	rts


fadecolourtab:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#7,d0
fadecolourtabl1:
	move.l	(a0)+,(a1)+
	move.l	d1,(a2)+
	dbf	d0,fadecolourtabl1
	move.w	#0,faded	;background black
	move.w	#1,fadecount
	jsr	fader
	rts

fadecolourtab32:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#15,d0
fadecolourtabl321:
	move.l	(a0)+,(a1)+
	move.l	d1,(a2)+
	dbf	d0,fadecolourtabl321
	move.w	#0,faded
	move.w	#1,fadecount
	jsr	fader
	rts

fadezone1:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#15,d0
fadezone1l1:
	move.w	(a0)+,(a1)+
	move.w	d1,(a2)+
	dbf	d0,fadezone1l1
	move.w	#0,faded
	move.w	#1,fadecount
	jsr	fader
	move.l	#colzone1,firstzone
	move.l	#colzone1,secondzone
	move.l	#colzone1,thirdzone
	rts

fadezone2:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#15,d0
fadezone2l1:
	move.w	(a0)+,(a1)+
	move.w	d1,(a2)+
	dbf	d0,fadezone2l1
	move.w	#0,faded
	move.w	#1,fadecount
	jsr	fader
	move.l	#colzone2,firstzone
	move.l	#colzone2,secondzone
	move.l	#colzone2,thirdzone
	rts

fadezone3:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#15,d0
fadezone3l1:
	move.w	(a0)+,(a1)+
	move.w	d1,(a2)+
	dbf	d0,fadezone3l1
	move.w	#0,faded
	move.w	#1,fadecount
	jsr	fader
	move.l	#colzone3,firstzone
	move.l	#colzone3,secondzone
	move.l	#colzone3,thirdzone
	rts

fadezone123:
	move.l	pic_col,a0
	lea	tofade,a1
	lea	faded,a2
	moveq	#-1,d1
	move.w	#15,d0
fadezone123l1:
	move.l	(a0)+,(a1)+
	move.l	d1,(a2)+
	dbf	d0,fadezone123l1
	move.w	#0,faded
	move.w	#1,fadecount
	jsr	fader
	move.l	#colzone1,firstzone
	move.l	#colzone2,secondzone
	move.l	#colzone3,thirdzone
	rts




pic1on:
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#120,bpl1mod(a5)
	move.w	#120,bpl2mod(a5)
	move.l	#pic_abyss,pic_col
	move.l	#pic_abyss+16*2,pic_bpl
	rts

pic2on:
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#120,bpl1mod(a5)
	move.w	#120,bpl2mod(a5)
	move.l	#pic_presents,pic_col
	move.l	#pic_presents+16*2,pic_bpl
	rts

pic3on:
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#120,bpl1mod(a5)
	move.w	#120,bpl2mod(a5)
	move.l	#pic_production,pic_col
	move.l	#pic_production+16*2,pic_bpl
	rts

pic4on:
	move.w	#%0101001000000000,bplcon0(a5)
	move.w	#160,bpl1mod(a5)
	move.w	#160,bpl2mod(a5)
	move.l	#pic_credits,pic_col
	move.l	#pic_credits+32*2,pic_bpl
	move.l	#copperlist,cop1lch(a5)
	move.l	#introut2,$6c


	move.l	pic_col,a0
	lea	16*2(a0),a0
	lea	tofade+16*2,a1
	lea	faded+16*2,a2
	move.w	#7,d0
pic4onl1:
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,pic4onl1
	rts

pic5on:
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#120,bpl1mod(a5)
	move.w	#120,bpl2mod(a5)
	move.l	#pic_mftl,pic_col
	move.l	#pic_mftl+16*2,pic_bpl
	rts


replaycode:
incbin	"data/replaycode"
pr_init=replaycode
pr_music=replaycode+644
pr_end=replaycode+574
pr_module=replaycode+4288

pr_data:
incbin	"data/mod.MFTLintro_p"


grname:	dc.b	"graphics.library",0
even

firstzone:	dc.l	nozone
secondzone:	dc.l	nozone
thirdzone:	dc.l	nozone

nozone:	blk.b	64,0

copperlist:
dc.l	$300ffffe
;------
colzone1:
dc.w	$0180,$0,$0182,$0,$0184,$0,$0186,$0
dc.w	$0188,$0,$018a,$0,$018c,$0,$018e,$0
dc.w	$0190,$0,$0192,$0,$0194,$0,$0196,$0
dc.w	$0198,$0,$019a,$0,$019c,$0,$019e,$0
;------

dc.l	$800ffffe
;------
colzone2:
dc.w	$0180,$0,$0182,$0,$0184,$0,$0186,$0
dc.w	$0188,$0,$018a,$0,$018c,$0,$018e,$0
dc.w	$0190,$0,$0192,$0,$0194,$0,$0196,$0
dc.w	$0198,$0,$019a,$0,$019c,$0,$019e,$0
;------

dc.l	$c00ffffe
;------
colzone3:
dc.w	$0180,$0,$0182,$0,$0184,$0,$0186,$0
dc.w	$0188,$0,$018a,$0,$018c,$0,$018e,$0
dc.w	$0190,$0,$0192,$0,$0194,$0,$0196,$0
dc.w	$0198,$0,$019a,$0,$019c,$0,$019e,$0
;------



dc.l	$ffddfffe
dc.l	$100ffffe
dc.l	$01800000

copperlistend:
dc.l	$fffffffe


