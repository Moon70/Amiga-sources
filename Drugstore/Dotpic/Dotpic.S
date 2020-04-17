;------------------------------------------------------------------------
;|                                                                      |
;|                              DotPicture                              |
;|                             ------------                             |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                         29-Jan-94 |
;------------------------------------------------------------------------
blink=0
comequant=40
showtime=0
;4:	spritebug-->spriteoff moved to chipmem
;   	sprite x -koordinate in datalist set to 0
;	precalc-speedoptimizing
;44444: init recoded


forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize=40*256
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

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c

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
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
section	code,code_p
codep_s:
;--------------------------------
	jmp	start		;
	jmp	main_init	;
	jmp	main_program	;
	jmp	main_back	;
	rts			;
;--------------------------------
;------------------------------------------------
start:						;
	move.l	4.w,a6				;
	jsr	forbid(a6)			;
	lea	$dff000,a5			;
	move.w	#%0000011111100000,dmacon(a5)	;
	move.w	#%0000000001100000,intena(a5)	;
	move.l	$6c.w,oldint			;
	move.l	#main_vbi,$6c.w			;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000100000,intena(a5)	;
	move.w	#%1000001111000000,dmacon(a5)	;
	lea	fakemain_vbiuser,a0		;
	lea	fakemain_copperlist,a1		;
	lea	fakemain_talk,a2		;
	move.w	#%0000001000000000,bplcon0(a5)
	moveq	#0,d0
	bsr	main_init			;
	moveq	#1,d0
	bsr	main_init			;
	moveq	#2,d0
	bsr	main_init			;
	bsr.w	main_program			;
wait:						;
	btst.b	#6,ciaapra			;
	beq.b	back				;
	lea	main_talk,a0			;
	move.l	(a0),a0				;
	tst.w	(a0)				;
	beq.b	wait				;
back:						;
	move.l	oldint,$6c.w			;
	waitblit
	move.l	4.w,a6				;
	lea	gfxname,a1			;
	moveq	#0,d0				;
	jsr	openlibrary(a6)			;
	move.l	d0,a0				;
	lea	$dff000,a5			;
	move.l	38(a0),cop1lch(a5)		;
	move.w	#0,copjmp1(a5)			;
	move.w	#%1000001111100000,dmacon(a5)	;
	move.l	4.w,a6				;
	jsr	permit(a6)			;
	moveq	#0,d0				;
	rts					;
;-----------------------------------------------;
;--------------------------------------------------------
main_vbiuser:		dc.l	0			;
fakemain_vbiuser:	dc.l	0			;
main_copperlist:	dc.l	0			;
fakemain_copperlist:	dc.l	main_emptycopperlist	;
main_talk:		dc.l	0			;
fakemain_talk:		dc.l	0			;
oldint:			dc.l	0			;
intflag:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
;--------------------------------------------------------
;----------------------------------------------------------------
main_vbi:							;
	btst.b	#5,$dff01f					;
	beq.b	main_vbiback					;
	movem.l	d0-a6,-(a7)					;
;--------------------------					;
	lea	$dff000,a5					;
	lea	main_vbiuser,a0	;adress of UserVbiAdress	;
	move.l	(a0),a0		;adress of UserVbi		;
	tst.l	(a0)						;
	beq.b	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;
	lea	main_copperlist,a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq.b	nomain_copperlist				;
	move.l	(a0),a1						;
	move.l	#0,(a0)						;
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
		dc.l	1,	setint_dotpiccome

rept	40-1
		dc.l	1,switchtablescome
endr

		dc.l	135,	setint_dotpic
		dc.l	451,	set_moveball
rept	33
	dc.l	1,	ballright
endr
	dc.l	60,	ballright
	dc.l	1,	spritesoff
;rept	70
rept	40-5-10
	dc.l	1,	dotdown
endr

		dc.l	60000,	setente
;---------------------------------------------
spritesoff:
	move.w	#%0000000000100000,dmacon(a5)
	rts
	
setint_dotpiccome:
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	lea	mainint_come(pc),a1
	move.l	a1,(a0)

	lea	$dff1a0,a1
	lea	spritescol(pc),a0
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

	rts

dotdown:
	add.w	#$0300*2,downlistpoint
	move.w	#0,dotsinusgo
	rts
ballright:
	addq.w	#3,ballhpos
	rts

commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	move.w	#%0000000000100000,dmacon(a5)
	lea	main_talk(pc),a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts

Setint_dotpic:
;	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
;	move.l	#$003800d0,ddfstrt(a5)	;strt+stop!
;	move.w	#%0100001000000000,bplcon0(a5)
;	move.w	#$0000,bplcon1(a5)	;col1+col2!
;	move.l	#$00780078,bpl1mod(a5)	;1mod+2mod!
	move.w	#%0000000000100100,bplcon2(a5)
	move.w	#%1000000000100000,dmacon(a5)

	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	lea	mainint_dotpic(pc),a1
	move.l	a1,(a0)

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#leavecopperlist,(a1)

	rts

set_moveball:
	move.w	#1,f_moveball
	rts


;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	tst.w	d0
	bne.w	main_init_part23

	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	lea	dotscol1,a0
	lea	dotpic1,a1
	bsr	dotscolinit
	lea	dotscol2,a0
	lea	dotpic2,a1
	bsr	dotscolinit
	lea	dotscol3,a0
	lea	dotpic3,a1
	bsr	dotscolinit
	lea	dotscol4,a0
	lea	dotpic4,a1
	bsr	dotscolinit



move.w	#fieldsizex*fieldsizey-1,turnquant
move.l	#dotposdest,turnkoord
move.l	#dotpossrc,turnkoords
move.w	#0*4,turnaddx
move.w	#0*4,turnaddy
move.w	#5*4,turnaddz

move.w	#65*4,turnx

moveq	#17,d7
precalcloop:
	move.l	d7,-(a7)
	bsr	turner
;	bsr	perspective

	move.l	dotspostabpoint(pc),a0
	lea	dotsposbyte-dotsposword(a0),a1
	bsr	dotsposconv

	bsr	switchtables
	move.l	(a7)+,d7
	dbf	d7,precalcloop

	bsr	switchplanes
	movem.l	(a7)+,d0-a6
	rts

main_init_part23:
	cmp.w	#1,d0
	bne.b	main_init_part3

	bsr	precalc_come
	movem.l	(a7)+,d0-a6
	rts


;###############################################################
main_init_part3:
	lea	planes,a0
	moveq	#0,d0
	move.w	#(planesend-planes)/16-1,d7
main_init_clsloop:
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	dbf	d7,main_init_clsloop

	lea	drawdots_code1,a0		;adress of the code
	lea	dotscol1,a1			;colours
	bsr	precalc_code
	lea	drawdots_code2,a0		;adress of the code
	lea	dotscol2,a1			;colours
	bsr	precalc_code
	lea	drawdots_code3,a0		;adress of the code
	lea	dotscol3,a1			;colours
	bsr	precalc_code
	lea	drawdots_code4,a0		;adress of the code
	lea	dotscol4,a1			;colours
	bsr	precalc_code
	bsr	ballmove
	movem.l	(a7)+,d0-a6
	rts
;###############################################################
;----------
;---------
main_back:
	rts
;----------

Main_program:;;
	move.l	dotspostabcomepoint(pc),a1
	lea	dotsposcomebyte-dotsposcomeword(a1),a2
	bsr	drawdots
	bsr	switchplanes
;	bsr	switchtablescome


	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#CopScreen_Dotpic,(a1)
	move.l	#CopScreen_Dotpic,cop1lch(a5)

;	lea	main_vbiuser(pc),a0
;	move.l	(a0),a0
;	lea	int_commander(pc),a1
;	move.l	a1,(a0)
	bsr	commander
	rts



mainint_dotpic:;;
	lea	$dff000,a5

	move.l	showplane(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	move.l	#sprite0,spr0pth(a5)
	move.l	#sprite1,spr1pth(a5)
	move.l	#sprite2,spr2pth(a5)
	move.l	#sprite3,spr3pth(a5)
	lea	spriteoff,a0
	move.l	a0,spr4pth(a5)
	move.l	a0,spr5pth(a5)
	move.l	a0,spr6pth(a5)
	move.l	a0,spr7pth(a5)

	bsr	planecls
	bsr	switchtables

	move.l	dotspostabpoint(pc),a1
	lea	dotsposbyte-dotsposword(a1),a2
	bsr	drawdots

	bsr	dotsinusmove
	bsr	ballmove
waitblit

	bsr	switchplanes
	move.w	#1,intflag
	bsr	commander
	rts
;----------

int_commander:
	bsr	commander
	rts

mainint_come:;;
	lea	$dff000,a5

	move.l	showplane,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	move.l	#sprite0,spr0pth(a5)
	move.l	#sprite1,spr1pth(a5)
	move.l	#sprite2,spr2pth(a5)
	move.l	#sprite3,spr3pth(a5)
	lea	spriteoff,a0
	move.l	a0,spr4pth(a5)
	move.l	a0,spr5pth(a5)
	move.l	a0,spr6pth(a5)
	move.l	a0,spr7pth(a5)

	bsr	planecls

	move.l	dotspostabcomepoint(pc),a1
	lea	dotsposcomebyte-dotsposcomeword(a1),a2
	bsr	drawdots

waitblit

	bsr	switchplanes
	move.w	#1,intflag
	bsr	commander
	rts
;----------



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
ifne	blink
move.w	$dff006,$dff180
endif
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
	move.l	#$00008000,d1
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
	add.l	d1,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	add.l	d1,d6
	swap	d6
	move.w	d3,2(a4,d0.w)
	move.w	d6,4(a4,d0.w)


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
	add.l	d1,d3
	swap	d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	add.l	d6,d6
	add.l	d1,d6
	swap	d6
;	move.w	d3,4(a4,d0.w)	;y
;	move.w	d6,6(a4,d0.w)	;z

	move.w	2(a4,d0.w),d2	;x


;	move.w	d6,d4	;to write back later
	neg.w	d6
	asr.w	#1,d6
	add.w	#150,d6
	move.w	focus(pc),d5
	muls.w	d5,d2
	muls.w	d5,d3
	divs	d6,d2
	divs	d6,d3

	move.w	d2,2(a4,d0.w)	;x
	move.w	d3,4(a4,d0.w)	;y
;	move.w	d4,6(a4,d0.w)	;z
	subq.w	#8,d0
	bpl.w	turnrout1
	rts
;*****

;perspective:
;rts
;	move.l	turnkoord(pc),a3
;	move.l	turnkoord(pc),a4
;	move.w	#150,d5
;	move.w	turnquant(pc),d7
;perspectiveloop:
;	movem.w	2(a3),d0-d2
;	move.w	d2,d4	;to write back later
;	neg.w	d2
;	asr.w	#1,d2
;	add.w	d5,d2

;	move.w	focus(pc),d3
;	muls.w	d3,d0
;	muls.w	d3,d1
;	divs	d2,d0
;	divs	d2,d1

;	movem.w	d0/d1/d4,2(a3)

;	addq.l	#8,a3
;	dbf	d7,perspectiveloop
;rts


focus:	dc.w	110



setdot_code1:	macro
;0000
;	bclr.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+16,0

;0001
	bset.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+12,0

;0010
;	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+12,0

;0011
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;0100
;	bclr.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+12,0

;0101
	bset.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;0110
;	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;0111
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
;	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+4,0

;1000
;	bclr.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+12,0

;1001
	bset.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;1010
;	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;1011
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
;	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+4,0

;1100
;	bclr.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+8,0

;1101
	bset.b	d0,(a0,\1)
;	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+4,0

;1110
;	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14+4,0

;1111
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0
endm






setdot_code2:	macro
;0000
	bclr.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0001
	bset.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0010
	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0011
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0100
	bclr.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0101
	bset.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0110
	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;0111
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bclr.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1000
	bclr.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1001
	bset.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1010
	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1011
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bclr.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1100
	bclr.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1101
	bset.b	d0,(a0,\1)
	bclr.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1110
	bclr.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0

;1111
	bset.b	d0,(a0,\1)
	bset.b	d0,40*1(a0,\1)
	bset.b	d0,40*2(a0,\1)
	bset.b	d0,40*3(a0,\1)
	dc.w	-2
	dcb.b	14,0
endm





fieldsizex=45
fieldsizey=45


precalc_code_setdot:
	setdot_code1 d7.w
	setdot_code1 d6.w
	setdot_code1 d5.w
	setdot_code1 d4.w
	setdot_code1 d3.w
	setdot_code1 d2.w
	setdot_code1 d1.w

precalc_code_movem:	movem.w	(a1)+,d1-d7
precalc_code_bitpos:	move.b	(a2)+,d0
precalc_code_rts:	rts
precalc_code_setplane:	add.w	(a3)+,a0

precalc_code:
;	lea	drawdots_code1,a0			;adress of the code
;	lea	dotscol,a1			;colours
;a0 and a1 from calling routine

	lea	dotsquant(pc),a3			;dots per circle
	moveq	#0,d3
	move.w	#(fieldsizex*fieldsizey)-1,d7	;number of dots
	moveq	#0,d6				;dotcounter (for movem)
precalc_codel1:
	subq.w	#1,d6
	bpl.b	precalc_codel2			;no movem needed
	move.l	precalc_code_movem(pc),(a0)+	;write the movem command
	moveq	#6,d6				;new dotcounter

precalc_codel2:
	subq.w	#1,d3
	bpl.b	precalc_codel5			;no new circle
	move.w	precalc_code_setplane(pc),(a0)+
	move.w	(a3)+,d3

precalc_codel5:
	move.w	precalc_code_bitpos(pc),(a0)+
	move.w	(a1)+,d0			;next dot
	lea	precalc_code_setdot(pc),a2
	move.w	d6,d1
;	mulu.w	#512,d1
	lsl.w	#8,d1
	add.w	d1,d1
	add.w	d1,d0
	lea	(a2,d0.w),a2
precalc_codel3:
	move.w	(a2)+,d0
	bmi.b	precalc_codel4
	move.w	d0,(a0)+
	bra.b	precalc_codel3

precalc_codel4:

	dbf	d7,precalc_codel1
	move.w	precalc_code_rts(pc),(a0)
rts



planecls:
	lea	$dff000,a5
	move.l	clearplane(pc),d0
;	addq.l	#0*64+2,d0
	move.l	d0,BLTDPTH(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#4*255*64+20,BLTSIZE(A5)
	rts

switchplanes:
	tst.w	switchmark
	beq.b	switch1
	bmi.b	switch2
	move.l	planes1pt(pc),showplane
	move.l	planes2pt(pc),clearplane
	move.l	planes3pt(pc),pointplane
	move.w	#0,switchmark
	rts
switch1:
	move.l	planes3pt(pc),showplane
	move.l	planes1pt(pc),clearplane
	move.l	planes2pt(pc),pointplane
	move.w	#-1,switchmark
	rts
switch2:
	move.l	planes2pt(pc),showplane
	move.l	planes3pt(pc),clearplane
	move.l	planes1pt(pc),pointplane
	move.w	#1,switchmark
	rts



dotsposinitcome:
	lea	dotpossrc(pc),a0
;	lea	dotpossrc(pc),a1

	moveq	#0,d2
	moveq	#5,d3
	moveq	#110,d4
	moveq	#21,d5

	moveq	#fieldsizey-1,d7
dpinitcomely:
	moveq	#fieldsizex-1,d6
dpinitcomelx:
	moveq	#0,d0
	moveq	#0,d1
	move.w	2(a0),d0
	move.w	4(a0),d1
;	addq.w	#8,a0

	add.w	d4,d0	;110
	divu	d3,d0	;5
	add.w	d4,d1	;110
	divu	d3,d1	;5

	sub.w	d5,d0	;21
	sub.w	#43,d1

	move.w	d2,(a0)+	;0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+	;0
	dbf	d6,dpinitcomelx
	dbf	d7,dpinitcomely
	rts



;dotsposinit:
;	lea	dotpossrc,a0
	lea	dotposdest,a1

	move.w	#-110,d1		;y koord

	moveq	#fieldsizey-1,d7
dpinitly:
	move.w	#-110,d0		;x koord
	moveq	#fieldsizex-1,d6
dpinitlx:
;	move.w	#0,(a0)+
;	move.w	d0,(a0)+
;	move.w	d1,(a0)+
;	move.w	#0,(a0)+

	move.w	#0,(a1)+
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.w	#0,(a1)+
	addq.w	#2,d0
	dbf	d6,dpinitlx
	addq.w	#2,d1
	dbf	d7,dpinitly
	rts



dotsposconv:
;	move.l	dotspostabpoint,a0
;	lea	dotsposbyte-dotsposword(a0),a1
;from calling routine
	lea	dotposdest,a2

;	move.w	#160,d4
;	move.w	#145,d5
	move.l	#$009e0091,d4
	move.w	#40*4,d5
	move.w	#2*256*40,d6
	lea	mulutab160,a3

	move.w	#fieldsizex*fieldsizey-1,d7
dotposconvl1:
;	move.w	2(a2),d0
;	move.w	4(a2),d1
;	add.w	d4,d0
;	add.w	d5,d1
	move.l	2(a2),d0
	add.l	d4,d0
	move.w	d0,d3
	swap	d0

	move.w	d0,d2
	not.w	d2
	and.w	#%111,d2
	move.b	d2,(a1)+

	move.w	d0,d2
	lsr.w	#3,d2
;	move.w	d1,d3

;	mulu	d5,d3
add.w	d3,d3
add.w	(a3,d3.w),d2

;	add.w	d3,d2
	sub.w	d6,d2
	move.w	d2,(a0)+

	addq.w	#8,a2
	dbf	d7,dotposconvl1
rts


Mulutab160:
value:	set	0
rept	240
dc.w	value*160
value:	set	value+1
endr


dotscolinit:
;	lea	dotscol1,a0	;got regs from calling routine
;	lea	dotpic1,a1
	lea	dotpossrc(pc),a2

	moveq	#0,d5			;offsetcode
	moveq	#fieldsizey-1,d7
dcinitly:
	moveq	#fieldsizex-1,d6
dcinitlx:
	moveq	#0,d0
	moveq	#0,d1
	move.w	2(a2),d0
	move.w	4(a2),d1
	addq.w	#8,a2

	add.w	#110,d0
	divu	#5,d0
	add.w	#110,d1
	divu	#5,d1


	move.w	d0,d2
	not.w	d2
	and.w	#%111,d2

	move.w	d0,d3
	lsr.w	#3,d3
	move.w	d1,d4
	mulu	#6*4,d4
	add.w	d4,d3

	moveq	#0,d4

dcp1:
	btst.b	d2,(a1,d3.w)
	beq.b	dcp2
	addq.w	#1,d4
dcp2:
	btst.b	d2,6*1(a1,d3.w)
	beq.b	dcp3
	addq.w	#2,d4
dcp3:
	btst.b	d2,6*2(a1,d3.w)
	beq.b	dcp4
	addq.w	#4,d4
dcp4:
	btst.b	d2,6*3(a1,d3.w)
	beq.b	dcp5
	addq.w	#8,d4
dcp5:

	lsl.w	#5,d4
;	move.w	d4,d2
;	sub.w	d5,d4
;	move.w	d2,d5
	move.w	d4,(a0)+


	dbf	d6,dcinitlx
	dbf	d7,dcinitly
rts

switchtables:
	lea	dotspostabpoint(pc),a0
	move.l	(a0),d0
	add.l	#firsttableend-firsttablestrt,d0
	cmp.l	#tableend,d0
	bne.b	switchtablesl1
	move.l	#firsttablestrt,d0
	bsr	symetryswap
switchtablesl1:
	move.l	d0,(a0)
	rts

switchtablescome:
	lea	dotspostabcomepoint(pc),a0
	move.l	(a0),d0
	add.l	#firsttablecomeend-firsttablecomestrt,d0
	cmp.l	#tablecomeend,d0
	bne.b	switchtablescomel1
	move.l	#firsttablecomestrt,d0
switchtablescomel1:
	move.l	d0,(a0)
rts


dotsinusmove:
	lea	dotsinuspoint(pc),a0
	move.l	(a0),a1
	tst.w	dotsinusgo
	beq.b	dotsinusmovel1
	lea	58(a1),a1
	cmp.w	#-1,(a1)
	bne.b	dotsinusmovel1
	lea	dotsinus,a1
	move.w	#0,dotsinusgo
dotsinusmovel1:
	move.l	a1,(a0)
rts

f_moveball:	dc.w	0
ballhpos:	dc.w	138
ballmove:
	lea	ballsinuspoint(pc),a0
	move.w	(a0),d0
	tst.w	f_moveball
	beq.b	ballmoveskip
	addq.w	#2,d0
	cmp.w	#270,d0
	bne.b	ballmovel2
	moveq	#0,d0
ballmovel2:
	move.w	d0,(a0)
	lea	ballsinus(pc),a0
	move.w	(a0,d0.w),d0
	cmp.w	#160,d0
	blt.b	nodotsinon
	move.w	#1,dotsinusgo
nodotsinon:
	move.w	d0,d1

	move.w	ballhpos(pc),d2
	lsl.w	#8,d0
	move.b	d2,d0

	add.w	#30,d1

	lea	sprite0,a0
	move.w	d0,(a0)
	move.b	d1,2(a0)

	lea	sprite1,a0
	move.w	d0,(a0)
	move.b	d1,2(a0)

	addq.w	#8,d0

	lea	sprite2,a0
	move.w	d0,(a0)
	move.b	d1,2(a0)

	lea	sprite3,a0
	move.w	d0,(a0)
	move.b	d1,2(a0)
ballmoveskip:

rts

symetryswap:
	lea	drawdots_codetable(pc),a1
	move.l	(a1),d1
	move.l	4(a1),(a1)+
	move.l	4(a1),(a1)+
	move.l	4(a1),(a1)+
	move.l	d1,(a1)
rts



drawdots:
	move.l	pointplane(pc),a0
	lea	2*256*40(a0),a0

;	move.l	dotspostabpoint,a1
;	lea	dotsposbyte-dotsposword(a1),a2
;from calling routine

	move.l	dotsinuspoint(pc),a3
	lea	drawdots_codetable(pc),a4
	move.l	(a4),a4
	jmp	(a4)
	

dotsinusgo:	dc.w	0
pointplane:	dc.l	0
clearplane:	dc.l	0
showplane:	dc.l	0
switchmark:	dc.l	0
ballsinuspoint:	dc.w	-28

dotspostabpoint:	dc.l	firsttablestrt
dotspostabcomepoint:	dc.l	firsttablecomestrt
planes1pt:	dc.l	planes1
planes2pt:	dc.l	planes2
planes3pt:	dc.l	planes3
dotsinuspoint:	dc.l	dotsinus+6612
drawdots_codetable:
	dc.l	drawdots_code1
	dc.l	drawdots_code2
	dc.l	drawdots_code3
	dc.l	drawdots_code4



spritescol:
	dc.w $421,$FFF,$EED,$ECC,$DBB,$CA9,$B98,$B87
	dc.w $A76,$965,$954,$843,$743,$632,$621,$521

aa:
dc.w	26,28,30,32,34,36,38,40,42,44,46,48,50,52
bb:
ballsinus:
dc.w  54, 56, 58, 60, 63
dc.W  66, 69, 72, 76, 80, 84, 88, 93, 97, 102, 108, 113, 118
dc.W  124, 130, 136, 142, 148, 155, 161, 168, 175, 181, 188
dc.W  195, 202, 209
;---
dc.W  216, 209, 202, 195, 188, 181, 175, 168, 161, 155, 148
dc.W  142, 136, 130, 124, 118, 113, 108, 102, 97, 93, 88
dc.W  84, 80, 76, 72, 69, 66, 63, 60, 58, 56, 54, 53, 52
dc.W  51, 50, 50
;---
dc.W  50, 50, 50, 51, 52, 53, 54, 55, 57, 58, 60, 62, 64
dc.W  66, 68, 70, 72, 74, 77, 78, 80, 82, 84, 85, 86, 87
dc.W  88, 89, 90, 90, 90, 90, 89, 89, 88, 87, 86, 85, 83
dc.W  81, 80, 78, 76, 74, 72, 70, 68, 66, 63, 62, 60, 58
dc.W  56, 55, 54, 53, 52, 51, 50, 50,50,50,51,52,53



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


;-----------------------------------------------------------------
;data chip memory

;-----------------------------------------------------------------
;data public memory
dotpossrc:	incbin	"data/dotpos"
dotsquant:
dc.w  4
dc.w  15
dc.w  15
dc.w  31
dc.w  27
dc.w  39
dc.w  39
dc.w  47
dc.w  67
dc.w  55
dc.w  71
dc.w  155
dc.w  87
dc.w  87
dc.w  107
dc.w  111
dc.w  111
dc.w  115
dc.w  119
dc.w  135
dc.w  143
dc.w  103
dc.w  75
dc.w  75
dc.w  47
dc.w  43
dc.w  35
dc.w  15
dc.w  23
dc.w -1

;-----------------------------------------------------------------
;-----------------------------------------------------------------
initoffsettable:
	lea	dotpossrc(pc),a0
	lea	dotposdest,a1
	lea	dotposoffsettable,a2
	lea	dotposcounttable,a3
	moveq	#comequant,d4

	moveq	#fieldsizey-1,d7
initoffsetly:
	moveq	#fieldsizex-1,d6
initoffsetlx:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3

	move.w	2(a0),d0
	move.w	4(a0),d1
	addq.w	#8,a0
	move.w	2(a1),d2
	move.w	4(a1),d3
	addq.w	#8,a1

	ext.l	d0
	ext.l	d1
	ext.l	d2
	ext.l	d3
	asl.l	#8,d0
	asl.l	#8,d1
	asl.l	#8,d2
	asl.l	#8,d3

	move.l	d0,(a3)+
	move.l	d1,(a3)+
	sub.l	d0,d2
	sub.l	d1,d3
	divs	d4,d2	;comequant
	divs	d4,d3	;comequant
	move.w	d2,(a2)+
	move.w	d3,(a2)+
	dbf	d6,initoffsetlx
	dbf	d7,initoffsetly
	rts


precalc_come:
	move.w	#0*4,turnz
	bsr	turner
;	bsr	perspective

	bsr	dotsposinitcome		;put small field in dotspossource
	bsr	initoffsettable

	moveq	#comequant-1,d7	;pictures
precalccomel1:
	lea	dotposdest,a1
	lea	dotposoffsettable,a2
	lea	dotposcounttable,a3
	moveq	#0,d2

	move.w	#(fieldsizex*fieldsizey)/2-1,d6
precalccomel2:
rept	2
	move.l	(a3),d0
	move.w	(a2)+,d1
	ext.l	d1
	add.l	d1,d0
	move.l	d0,(a3)+
	asr.l	#8,d0
	move.w	d2,(a1)+	;0
	move.w	d0,(a1)+

	move.l	(a3),d0
	move.w	(a2)+,d1
	ext.l	d1
	add.l	d1,d0
	move.l	d0,(a3)+
	asr.l	#8,d0
	move.w	d0,(a1)+
	move.w	d2,(a1)+	;0
endr
	dbf	d6,precalccomel2

	move.l	d7,-(a7)

	move.l	dotspostabcomepoint(pc),a0
	lea	dotsposcomebyte-dotsposcomeword(a0),a1
	bsr	dotsposconv
	bsr	switchtablescome

	move.l	(a7)+,d7
	dbf	d7,precalccomel1
rts





codep_e:

section	memoryc,code_c
codec_s:
sprite0:	dc.w	$a000,$bd00
		incbin	"data/ball01_p01.spr"
		dc.l	0
		dc.l	0

sprite1:	dc.w	$a000,$bd00+2^7
		incbin	"data/ball01_p23.spr"
		dc.l	0
		dc.l	0

sprite2:	dc.w	$a000,$bd00
		incbin	"data/ball23_p01.spr"
		dc.l	0
		dc.l	0

sprite3:	dc.w	$a000,$bd00+2^7
		incbin	"data/ball23_p23.spr"
		dc.l	0
		dc.l	0
dotsinus:
		incbin	"data/dotsinus"
		dc.w	-1
dotpic1:	incbin	"data/dotpic4.2.4.blt"
dotpic2:	incbin	"data/dotpic4.2.1.blt"
dotpic3:	incbin	"data/dotpic4.2.2.blt"
dotpic4:	incbin	"data/dotpic4.2.3.blt"
CopScreen_Dotpic:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,$0000
	dc.w	bplcon2,$0024
	dc.w	bpl1mod,$0078
	dc.w	bpl2mod,$0078
	dc.w	bplcon0,%0100001000000000
	dc.w	$180,$101
	dc.w	$182,$531
	dc.w	$184,$422
	dc.w	$186,$999
	dc.w	$188,$753
	dc.w	$18a,$310
	dc.w	$18c,$B97
	dc.w	$18e,$047
	dc.w	$190,$110
	dc.w	$192,$876
	dc.w	$194,$654
	dc.w	$196,$035
	dc.w	$198,$024
	dc.w	$19a,$06A
	dc.w	$19c,$B20
	dc.w	$19e,$FFF

	dc.l	-2
main_emptycopperlist:	dc.l	-2
spriteoff:	dc.l	0

leavecopperlist:
		dc.l	$230ffffe
		dc.w	bplcon0,%0000001000000000
downlistpoint:	dc.l	$230ffffe
		dc.w	bplcon0,%0100001000000000
		dc.l	-2

codec_e:

section	bsschip,bss_c
bssc_s:;-----------------------------------------------
planes:
planes1:		ds.b	4*planesize
planes2:		ds.b	4*planesize
planes3:		ds.b	4*planesize
planesend:
drawdots_code1:		ds.b	20000	;16966
drawdots_code2:		ds.b	20000
drawdots_code3:		ds.b	20000
drawdots_code4:		ds.b	20000
bssc_e:;-----------------------------------------------

section	bsspublic,bss_p
bssp_s:
dotposoffsettable:	ds.l	2*fieldsizex*fieldsizey
dotposcounttable:	ds.l	2*fieldsizex*fieldsizey
dotposdest:		ds.w	4*fieldsizex*fieldsizey

dotscol1:	ds.w	fieldsizex*(fieldsizey)
dotscol2:	ds.w	fieldsizex*(fieldsizey)
dotscol3:	ds.w	fieldsizex*(fieldsizey)
dotscol4:	ds.w	fieldsizex*(fieldsizey)

firsttablestrt:							;|
dotsposword:	ds.w	fieldsizex*(fieldsizey)			;|
dotsposbyte:	ds.b	fieldsizex*(fieldsizey)			;|
even								;|
firsttableend:	ds.b	(firsttableend-firsttablestrt)*(18-1)	;|
tableend:							;|


firsttablecomestrt:							;|
dotsposcomeword:ds.w	fieldsizex*(fieldsizey)		;|
dotsposcomebyte:ds.b	fieldsizex*(fieldsizey)		;|
even								;|
firsttablecomeend:	ds.b	(firsttableend-firsttablestrt)*(comequant-1)	;|
tablecomeend:							;|
bssp_e:




printt	"Code Chip:"
printv	codec_e-codec_s

printt	"BSS Chip:"
printv	bssc_e-bssc_s

printt	"Code Public:"
printv	codep_e-codep_s

printt	"BSS Public:"
printv	bssp_e-bssp_s

printt
printt	"Chipmem needed:"
printv	codec_e-codec_s+bssc_e-bssc_s

printt	"Publicmem needed:"
printv	codep_e-codep_s+bssp_e-bssp_s

printt	"File length: (without relocs!!!)"
printv	codec_e-codec_s+codep_e-codep_s

printt
;printt	"Chipmem needed on 




