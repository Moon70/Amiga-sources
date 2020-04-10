;------------------------------------------------------------------------
;|                                                                      |
;|                              DIZNEE LAND                             |
;|                             -------------                            |
;|                                                                      |
;|                                Issue 2                               |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                        April 1994 |
;------------------------------------------------------------------------
;showtime=1
usesection=1
;incdir	"ram:"
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize=64*256
intena=$09a
openlibrary=-30-522
FindTask=-294
GetMsg=-372
WaitPort=-384
joy0dat=$00a

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
ifne	usesection
section	code,code_c
endif
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
	sub.l	a1,a1
	jsr	findtask(a6)
	move.l	d0,a4
	tst.l	$ac(a4)
	bne	startcli

	lea	$5c(a4),a0
	jsr	waitport(a6)
	lea	$5c(a4),a0
	jsr	getmsg(a6)
startcli:

	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001101000,intena(a5)		;
	move.l	$6c.w,oldint				;
	move.l	#main_vbi,$6c.w				;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%0000001000000000,bplcon0(a5)		;
	move.w	#%1100000000100000,intena(a5)		;
	move.w	#%1000001111000000,dmacon(a5)		;
	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	bsr	main_init				;
	bsr	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq	back					;
;	btst.b	#7,ciaapra				;
;	beq	back					;
;	tst.w	f_endprogram				;
;	beq	wait					;
	lea	main_talk,a0				;
	move.l	(a0),a0					;
	tst.w	(a0)					;
	beq	wait					;
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
	move.w	#%1000000000001000,intena(a5)		;
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
	beq	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;

	lea	main_copperlist(pc),a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq	nomain_copperlist				;
	bpl	noempty_copperlist
	lea	main_emptycopperlist(pc),a1
	move.l	a1,cop1lch(a5)					;
	clr.l	(a0)						;
	bra	nomain_copperlist				;
noempty_copperlist:
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
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
;		dc.l	300,	nothing
		dc.l	200,	setint_title
		dc.l	50,	setint_fadetitleout
		dc.l	40,	setint_pinkfade
		dc.l	90,	setint_come1
		dc.l	70,	setint_come2
		dc.l	36,	setint_come3
		dc.l	10,	setint_text
		dc.l	1,	setint_textpage0
		dc.l	40,	setint_getout

		dc.l	100,	setint_abyss
		dc.l	40,	fadetitleout
		dc.l	60000,	setente

;---------------------------------------------
nothing:	rts

setint_pinkfade:
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_pinkfade,(a0)

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#pinklist,(a1)
	bsr	makepinklist
	move.w	#%0000001000000100,bplcon0(a5)
	rts

setente:
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts

setint_title:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#200+240,bpl1mod(a5)
	move.w	#200+240,bpl2mod(a5)
	move.w	#%0110001000000100,bplcon0(a5)
	move.w	#%1000001100000000,dmacon(a5)
	btst.b	#7,$004(a5)
	bne.b	sf_badframe


	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_fadetitlein,(a0)

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#copperlist1,(a1)
	move.w	#%1000001110000000,dmacon(a5)


	lea	$180(a5),a1
	moveq	#15,d0
colcopyloop:
	move.l	#0,(a1)+
	dbf	d0,colcopyloop

	move.l	#fader_table3,fader_pos
	move.w	#64,fader_direct
	move.w	#fadequant1*2,fader_direct
	move.w	#1,fader_slpcount
	move.w	#2,fader_sleep
	rts
sf_badframe:
	subq.w	#8,compoint
	move.w	#1,comsleep
	move.w	#%0000001000000100,bplcon0(a5)
	rts

setint_fadetitleout:
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_fadetitleout,(a0)
	rts

CopScreen_Abyss:
	dc.w	diwstrt,$6981
	dc.w	diwstop,$ebc1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0

	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,$78
	dc.w	bpl2mod,$78
	dc.w	bplcon0,%0100001000000000
	dc.l	-2

setint_abyss:
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intabyss,(a0)
	lea	main_copperlist,a0
	move.l	(a0),a0
	move.l	#copscreen_abyss,(a0)
;	move.w	#$6981,diwstrt(a5)
;	move.w	#$ebc1,diwstop(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$00d0,ddfstop(a5)
;	move.w	#0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)
;	move.w	#$78,bpl1mod(a5)
;	move.w	#$78,bpl2mod(a5)
;	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#fadequant1*2,fader_direct
	move.l	#fader_table,fader_pos
	move.w	#1,fader_slpcount
	rts

fadetitleout:
	move.w	#fadequant1*2,fader_direct
	move.l	#fader_table2,fader_pos
rts


CopScreen_come1:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,$d8
	dc.w	bpl2mod,$d8
	dc.w	bplcon0,%0100001000000000
	dc.l	-2

setint_come1:
;	move.w	#$2981,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$00d0,ddfstop(a5)
;	move.w	#0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)
;	move.w	#$d8,bpl1mod(a5)
;	move.w	#$d8,bpl2mod(a5)
;	move.w	#%0000001000000000,bplcon0(a5)

	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intcome1,(a0)

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#Copscreen_come1,(a1)

	lea	main_emptycopperlist(pc),a0
	move.l	a0,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	lea	colours,a0
	lea	$180(a5),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

	rept	16
	move.w	#$e46,(a1)+	;f57
	endr

	rts

setint_come2:
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intcome2,(a0)
rts

setint_come3:
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intcome3,(a0)
rts

setint_getout:
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intgetout,(a0)
;	move.w	#-2,pr_musicfadedirection
	move.w	#2,fader_sleep

	move.w	#-2,P60_fadestep
rts


Copscreen_text:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,$a0
	dc.w	bpl2mod,$a0
	dc.w	bplcon0,%0101001000000000
	dc.l	-2

setint_text:
;	move.w	#$a0,bpl1mod(a5)
;	move.w	#$a0,bpl2mod(a5)
;	move.w	#%0101001000000000,bplcon0(a5)
	move.l	#conv4to5planes,maincommand
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intcome4,(a0)
rts

setint_textpage0:
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_inttext,(a0)

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#Copscreen_text,(a1)

;	move.w	welcome,actpage
;	move.w	#2,section
;	lea	writepagenofade,a0
;	move.l	a0,maincommand
rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	lea	$dff000,a5
	moveq	#0,d0
	move.w	d0,$1fc(a5)	;kick aga
	move.l	d0,$144(a5)	;sprite 0
	move.l	d0,$14c(a5)	;sprite 1
	move.l	d0,$154(a5)	;sprite 2
	move.l	d0,$15c(a5)	;sprite 3
	move.l	d0,$164(a5)	;sprite 4
	move.l	d0,$16c(a5)	;sprite 5
	move.l	d0,$174(a5)	;sprite 6
	move.l	d0,$17c(a5)	;sprite 7

;------------------------------------------------------------------------
; ������������������������������������������������
; � Call P60_Init to initialize the playroutine	�
; � D0 --> Timer detection (for CIA-version)	�
; � A0 --> Address to the module		�
; � A1 --> Address to samples/0			�
; � A2 --> Address to sample buffer		�
; � D0 <-- 0 if succeeded			�
; � A6 <-- $DFF000				�
; � 		Uses D0-A6			�
; ������������������������������������������������
	move.w	newmodule,d0
	lsl.w	#3,d0
	lea	modules,a1
	add.w	d0,a1
	move.l	(a1)+,a0
	move.l	(a1),a1

;	lea	P60_data,a0	; Module
;	lea	P60_smpl,a1
;	sub.l	a1,a1		; Samples
	lea	samples,a2	; Sample buffer
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5
;------------------------------------------------------------------------

;	bsr	setsong
	jsr	fadetest

	lea	precalc(pc),a0
	move.l	a0,maincommand
;	jsr	precalc

	bsr.w	coppercopy
	jsr	fadetest2
	jsr	switchplanes

	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
;------------------------------------------------------------------------
; ������������������������������������������������
; �     	Call P60_End to stop the music	�
; �   A6 --> Customchip baseaddress ($DFF000)	�
; �		Uses D0/D1/A0/A1/A3		�
; ������������������������������������������������
	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
;------------------------------------------------------------------------
	rts
;----------

Main_program:;;
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_inttitle,(a0)

;	lea	colours,a0
;	lea	$180(a5),a1
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+
;	move.l	(a0)+,(a1)+

;	rept	16
;	move.w	#$e46,(a1)+	;f57
;	endr

;	move.w	#fadequant1*2,fader_direct
;	move.l	#fader_table,fader_pos


main_loop:
;	btst.b	#7,ciaapra
;	beq	main_loopexit
	lea	main_talk,a0
	move.l	(a0),a0
	tst.w	(a0)
	bne	main_loopexit

	tst.l	maincommand
	beq	main_loop
	move.w	#1,askkeyskip

	move.l	maincommand,a0
	move.l	#0,maincommand
	jsr	(a0)
	move.w	#0,askkeyskip
	bra	main_loop


main_loopexit:
	rts

main_inttitle:
	lea	title,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	skip_musictit

;------------------------------------------------------------------------
; ������������������������������������������������
; � Call P60_Music every frame to play the music�
; � A6 --> Customchip baseaddress ($DFF000)	�
; �          	Uses A0-A5/D0-D7		�
; ������������������������������������������������
lea	$dff000,a6
jsr	P60_Music
	lea	$dff000,a5
;------------------------------------------------------------------------
	jsr	fader_real
	bsr	commander
skip_musictit:

rts


pinkpos:	dc.w	$100f

makepinklist:
	lea	pinklist+12,a1
	move.w	pinkpos(pc),d0
	add.w	#$800,d0
	bcc	noflow
	move.l	#$ffd9fffe,-8(a1)
	move.l	#$ffd9fffe,-4(a1)
noflow:
	move.w	d0,(a1)+
	move.w	#-2,(a1)+
	move.w	d0,pinkpos
	move.l	#$01800000,(a1)+

	move.l	#-2,(a1)
	rts

int_pinkfade:
	bsr.w	makepinklist

	bsr.w	commander
	move.w	#1,intflag
rts



Int_fadetitlein:
	lea	$dff000,a5
	jsr	fader_real
	jsr	fader_real
	jsr	fader_real
	bsr	commander
	move.w	#1,intflag
	rts

Int_fadetitleout:
	cmp.w	#-32,fadout_sleeptest
	beq.b	fadefin
	moveq	#0,d0
	lea	fadout_offsets(pc),a1
	lea	fadout_sleep(pc),a2

	moveq	#15,d6
fadeoutloop2:
	move.l	(a1)+,a0
	add.l	#drugpic,a0
	subq.w	#1,(a2)+
	bpl.b	skipline
	add.l	#240,-4(a1)
	
	moveq	#59,d7
fadeoutloop1:
	move.l	d0,(a0)+
	dbf	d7,fadeoutloop1
skipline:
	dbf	d6,fadeoutloop2
fadefin:
	bsr.w	commander
	move.w	#1,intflag
	rts

fadout_offsets:
	dc.l	00*32*240
	dc.l	01*32*240
	dc.l	02*32*240
	dc.l	03*32*240
	dc.l	04*32*240
	dc.l	05*32*240
	dc.l	06*32*240
	dc.l	07*32*240
	dc.l	08*32*240
	dc.l	09*32*240
	dc.l	10*32*240
	dc.l	11*32*240
	dc.l	12*32*240
	dc.l	13*32*240
	dc.l	14*32*240
	dc.l	15*32*240

fadout_sleep:
	dc.w	00
	dc.w	01
	dc.w	02
	dc.w	03
	dc.w	04
	dc.w	05
	dc.w	06
	dc.w	07
	dc.w	08
	dc.w	09
	dc.w	10
	dc.w	11
	dc.w	12
	dc.w	13
	dc.w	14
fadout_sleeptest:
	dc.w	15


main_intabyss:
	lea	title,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	skip_musicaby

;------------------------------------------------------------------------
; ������������������������������������������������
; � Call P60_Music every frame to play the music�
; � A6 --> Customchip baseaddress ($DFF000)	�
; �          	Uses A0-A5/D0-D7		�
; ������������������������������������������������
lea	$dff000,a6
jsr	P60_Music
	lea	$dff000,a5
;------------------------------------------------------------------------
	jsr	fader_real
	bsr	commander
skip_musicaby:

rts

main_intcome1:
	lea	$dff000,a5
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)
;	move.w	#%0100001000000000,bplcon0(a5)

	tst.w	skipmusic
	bne	skip_music

	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

skip_music:
	bsr	putpic

	move.w	#1,intflag
	jsr	commander
nop
nop
nop
nop
nop
nop
nop

	rts
;----------

main_intcome2:
	lea	$dff000,a5
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	intcome2_skipmusic

	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

intcome2_skipmusic:


	bsr	drawmenu
;	bsr	drawissue
;	bsr	writepage

	move.w	#1,intflag
	jsr	commander

	rts
;----------

main_intcome3:
	lea	$dff000,a5
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	intcome3_skipmusic

	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

intcome3_skipmusic:


;	bsr	drawmenu
	bsr	drawissue
;	bsr	writepage

	move.w	#1,intflag
	jsr	commander

	rts
;----------

main_intcome4:
	lea	$dff000,a5
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	intcome4_skipmusic

	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

intcome4_skipmusic:

	move.w	#1,intflag
	jsr	commander

	rts
;----------

main_intgetout:
	lea	$dff000,a5
	lea	planes5,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)

	tst.w	skipmusic
	bne	intgetout_skipmusic

	jsr	P60_fader
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

intgetout_skipmusic:

	bsr	curtain
	move.w	#1,intflag
	jsr	commander

	rts
;----------

main_inttext:
	lea	$dff000,a5
;	move.w	#$a0,bpl1mod(a5)
;	move.w	#$a0,bpl2mod(a5)
;	move.w	#%0101001000000000,bplcon0(a5)
;	lea	planes5,a0
	move.l	showplane,a0
	sub.w	#1*40,a0

	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)

	tst.w	skipmusic
	bne	main_inttext_skipmusic

	jsr	P60_fader
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
main_inttext_skipmusic:




	jsr	planecls
	jsr	spiral
	jsr	fill
	jsr	switchplanes



	bsr	fadetext
	bsr	askkey
	bsr	askmouse
;	bsr	drawmenu
;	bsr	writepage


	waitblit

	move.w	#1,intflag
	lea	comsleep(pc),a0
	addq.w	#1,(a0)+

	jsr	commander

	rts
;----------



precalc:	;no blitter used
	jsr	planecls1
	bsr	calcanim
	jsr	textcalc
rts

planes5copy:
	move.w	#51200/4-1,d7
	lea	planes5,a0
	lea	planes5_2,a1
planes5copyloop:
	move.l	(a0)+,(a1)+
	dbf	d7,planes5copyloop
	rts
	

coppercopy:
	lea	copperlist1,a0
	move.l	#drugpic,d0
	move.l	#copperlist2,d1
	bsr.b	putlist

	lea	copperlist2,a0
	move.l	#drugpic+240,d0
	move.l	#copperlist1,d1
	bsr.b	putlist
	rts


putlist:
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl5ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl5pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl6ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl6pth,(a0)+
	move.w	d0,(a0)+
	swap	d0


	move.w	#cop1lcl,(a0)+
	move.w	d1,(a0)+
	swap	d1
	move.w	#cop1lch,(a0)+
	move.w	d1,(a0)+

	move.l	#-2,(a0)+
	rts


;------------------------------
P60_fadestep:	dc.w	0
P60_fader:
	lea	P60_fadestep,a0
	move.w	(a0),d0
	beq	P60_fader_skip

	lea	p60_master,a1
	add.w	d0,(a1)
	move.w	(a1),d0
	beq	P60_fader_fin
	cmp.w	#64,d0
	beq	P60_fader_fin

P60_fader_skip:
	rts

P60_fader_fin:
	move.w	#0,(a0)
	rts
;------------------------------
fadebobs:
rept	50
dc.l	-1	;pos
dc.w	0	;animpoint
endr

fadetextskip:		dc.w	1
fadetextnewbobs:	dc.w	1
fieldspoint:		dc.w	0
fieldterms:		dc.w	%0000110111111100


actmasc:	dc.l	masc1
actpattern:	dc.l	pattern1

fadetext:
	tst.w	fadetextskip
	bne	fadetext_skip
	addq.w	#2,fadetextnewbobs

	lea	planes5+12+11*40*5+40*4,a0
	lea	planes5_2+12+11*40*5+40*4,a6
;	lea	fieldsmasc+24*4*16*3,a1
	move.l	actpattern,a1
	lea	fadebobs,a2

	moveq	#0,d6
	moveq	#49,d7
fadetextl1:
	move.l	(a2),d0
	bmi	fadetext_skipbob
	move.w	4(a2),d1
	cmp.w	#15,d1
	bne	fadetext_notlastanimpic
	move.l	#-1,(a2)

fadetext_notlastanimpic:
	addq.w	#1,4(a2)
	mulu	#4*24,d1

	lea	(a0,d0.l),a3
	lea	(a1,d1.w),a4


	moveq	#1,d6
	waitblit
	move.l	a4,bltapth(a5)
	move.l	a3,bltbpth(a5)
	move.l	a3,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#5*40-4,bltbmod(a5)
	move.w	#5*40-4,bltdmod(a5)
	move.w	#0,bltcon1(a5)
	move.w	fieldterms,bltcon0(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#2+24*64,bltsize(a5)
	waitblit
	lea	(a6,d0.l),a3

	move.l	a4,bltapth(a5)
	move.l	a3,bltbpth(a5)
	move.l	a3,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#5*40-4,bltbmod(a5)
	move.w	#5*40-4,bltdmod(a5)
	move.w	#0,bltcon1(a5)
	move.w	fieldterms,bltcon0(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#2+24*64,bltsize(a5)

	bra	fadetext_skipinsert


fadetext_skipbob:
	tst.w	fadetextnewbobs
	beq	fadetext_skipinsert
	subq.w	#1,fadetextnewbobs
;	lea	fields,a3
	move.l	actmasc,a3
	moveq	#0,d0
	moveq	#0,d1
	move.w	fieldspoint,d0
	cmp.w	#168,d0
	beq	fadetext_skipinsert
	addq.w	#2,fieldspoint
	move.w	(a3,d0.w),d0
	divu	#14,d0
	swap	d0
	move.w	d0,d1
	move.w	#0,d0
	swap	d0
	mulu.w	#24*5*40,d0
	add.w	d1,d1
	add.l	d1,d0
	move.l	d0,(a2)
	move.w	#0,4(a2)


fadetext_skipinsert:
	addq.w	#6,a2
	dbf	d7,fadetextl1

	tst.w	d6
	bne	fadetext_skip
	move.w	fieldspoint,d0
	cmp.w	#168,d0
	bne	fadetext_skip
	move.w	#1,fadetextskip
	move.w	#0,fieldspoint
fadetext_skip:
rts


curtainpoint:	dc.w	0
curtain:
	lea	planes5,a0
	move.w	curtainpoint,d0
	addq.w	#1,curtainpoint
	lea	39+16*5*40(a0),a1
	add.w	d0,a0
	sub.w	d0,a1

	moveq	#7,d6
curtainl2:

	moveq	#15,d7		;16 lines/bar
curtainl1:
	move.b	#0,0*40(a0)
	move.b	#0,1*40(a0)
	move.b	#0,2*40(a0)
	move.b	#0,3*40(a0)
	move.b	#0,0*40(a1)
	move.b	#0,1*40(a1)
	move.b	#0,2*40(a1)
	move.b	#0,3*40(a1)
	lea	5*40(a0),a0
	lea	5*40(a1),a1
	dbf	d7,curtainl1

	lea	16*5*40(a0),a0
	lea	16*5*40(a1),a1
	dbf	d6,curtainl2
	
rts




;sizey=50

animpoint:	dc.w	0
putpic:
	move.w	animpoint,d4
	addq.w	#4,d4
	cmp.w	#animwaveend-animwave,d4
	bne	putpicl1

	moveq	#0,d4
putpicl1:
	move.w	d4,animpoint
	lea	animwave,a4
	move.l	(a4,d4.w),d0
	moveq	#0,d5

	move.l	d0,a0
	lea	planeadr+64*155*4,a1

	moveq	#19,d6
putpicloopx:
	move.l	a0,a2
	move.l	a1,a3
putpicloopy:

linepos:	set	0;

rept 404
	move.w (a2)+,linepos(a3)
linepos:	set	linepos+64
endr

;	add.l	d0,a3
;	dbf	d7,putpicloopy

	add.w	#8,d4
	cmp.w	#animwaveend-animwave,d4
	blt	putpicl2
	sub.w	#animwaveend-animwave,d4
putpicl2:
	move.l	(a4,d4.w),a0

	add.l	#101*4*2,d5
	add.l	d5,a0

	addq.l	#2,a1
	dbf	d6,putpicloopx
	
	rts
	
calcanim:
	lea	abyss,a0
	lea	animstart,a1

	move.w	#19,d7

calcaniml1:

	move.w	#101*4-1,d6
calcaniml2:

	moveq	#16,d5
	move.w	(a0),d0
calcaniml3:
	move.w	d0,(a1)
	lea	logosize(a1),a1
	lsr.w	#1,d0
	dbf	d5,calcaniml3

	sub.l	#logosize*17-2,a1
	lea	40(a0),a0
	dbf	d6,calcaniml2

	lea	-40*101*4+2(a0),a0
	dbf	d7,calcaniml1
	rts

conv4to5planes:
	lea	planes5,a0
	lea	planeadr,a1
	move.w	#255,d7		;256 lines
conv4to5planesl1:
	moveq	#3,d6		;4 planes from source
conv4to5planesl2:
	moveq	#9,d5		;40 bytes/line for destination
conv4to5planesl3:
	move.l	(a1)+,(a0)+
	dbf	d5,conv4to5planesl3
	add.w	#64-40,a1	;skip source offset
	dbf	d6,conv4to5planesl2
	moveq	#9,d6
conv4to5planesl4:
	move.l	#0,(a0)+	;write 5th plane for destination
	dbf	d6,conv4to5planesl4
	dbf	d7,conv4to5planesl1

	move.w	welcome,actpage
	move.w	#2,section
	lea	writepagenofade,a0
	move.l	a0,maincommand

	jsr	planes5copy
rts



menupos:	dc.w	320

sinusxpos:	dc.w	0

drawmenu:
	lea	sinusx(pc),a2
	move.w	sinusxpos,d0
	add.w	d0,a2
	move.w	(a2)+,d0
;	move.w	(a2)+,d1
	tst.w	(a2)
	bmi	min
	add.w	#1*2,sinusxpos
min:
	lea	menu,a0
	lea	planeadr+0*64*4,a1
	lea	skyline+35*40*4,a2
;move.w	menupos,d0
	moveq	#35,d1
;add.w	(a3)+,d0

	move.w	d0,d2
	lsr.w	#4,d0			;x/16=wordoffset
	and.w	#%0000000000001111,d2	;scrollbits...
	ror.w	#4,d2			;...rotate to highbits...
	move.w	d2,d3			;...copy...
	or.w	#%0000111110111000,d3	;...set miniterms...
	swap	d3			;...word on highword...
	move.w	d2,d3			;...and word!!!

	mulu	#64*4,d1
	add.l	d1,a1

	add.w	d0,d0
	add.w	d0,a1
	add.w	d0,a2

	waitblit
	move.l	a0,bltapth(a5)
	move.l	a2,bltbpth(a5)
	move.l	a1,bltcpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#40-14,bltbmod(a5)
	move.w	#64-14,bltcmod(a5)
	move.w	#64-14,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	d3,bltcon0(a5)
	move.w	#0,bltcon1(a5)

	move.w	#64*4*160+7,bltsize(a5)










nop
nop
nop
nop
nop
waitblit
rts





issuex:	dc.w	4*512-39
issuey:	dc.w	0
drawissue:
;	lea	sinusx(pc),a2
;	move.w	sinusxpos,d0
;	add.w	d0,a2
;	move.w	(a2)+,d0
;;	move.w	(a2)+,d1
;	tst.w	(a2)
;	bmi	min
;	add.w	#1*2,sinusxpos
;min:
	lea	issuex(pc),a0
	move.w	(a0),d0
	addq.w	#1,(a0)+
	move.w	(a0),d1
	addq.w	#1,(a0)

	lea	issue,a0
	lea	planeadr+0*64*4,a1
	lea	planeborder,a1

;	moveq	#35,d0
;	moveq	#35,d1

	move.w	d0,d2
	lsr.w	#4,d0			;x/16=wordoffset
	and.w	#%0000000000001111,d2	;scrollbits...
	ror.w	#4,d2			;...rotate to highbits...
	move.w	d2,d3			;...copy...
	or.w	#%0000100111110000,d3	;...set miniterms...
	swap	d3			;...word on highword...
	move.w	d2,d3			;...and word!!!

	mulu	#64*4,d1
	add.l	d1,a1

	add.w	d0,d0
	add.w	d0,a1

	waitblit
	move.l	a0,bltapth(a5)
;	move.l	a2,bltbpth(a5)
;	move.l	a1,bltcpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
;	move.w	#40-14,bltbmod(a5)
;	move.w	#64-14,bltcmod(a5)
	move.w	#64-14,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	d3,bltcon0(a5)
	move.w	#0,bltcon1(a5)

	move.w	#64*4*(40-4)+7,bltsize(a5)
nop
nop
nop
nop
nop
waitblit
rts



key:		dc.w	0
askkeyskip:	dc.w	0

askkey:
	tst.w	askkeyskip
	bne	askkey_skip

	move.b	$bfed01,d0		;irc-interrupt-control
	btst.l	#3,d0			;bit 3=serial data full
	beq	askkey_skip		;not full, irq not from keyboard!


	move.b	$bfec01,d0		;store keycode
	and.w	#$00ff,d0		;kill hibyte of this word
	not.b	d0			;do the keycode...
	ror.b	#1,d0			;...decoding
	move.b	d0,key			;store decoded key
	bset.b	#6,$bfee01		;serial port to output-mode(hehe)
	move.b	#%11111111,$bfec01	;handshake-signal low
	bsr	waitawhile
	move.b	#%00000000,$bfec01	;handshake-signal hi
	bclr.b	#6,$bfee01		;serial port to input-mode

	move.b	key,d0

	cmp.b	#$d0,d0
	blt	nofkey
	cmp.b	#$d9,d0
	bgt	nofkey

	sub.w	#$d0,d0
	move.w	newmodule,lastmodule
	move.w	d0,newmodule
	lsl.w	#3,d0
	lea	modules,a0
	add.w	d0,a0
	move.l	(a0)+,newmod_data
	move.l	(a0)+,newmod_smpl

	lea	changemusic(pc),a0
	move.l	a0,maincommand
askkey_skip:
rts


nofkey:
;	cmp.b	#$92,d0		;E
;	beq	key_exit
	cmp.b	#$c5,d0		;ESC
	beq	key_exit

	cmp.b	#$94,d0		;T
	beq	key_text

	cmp.b	#$a0,d0		;A
	beq	key_adverts

	cmp.b	#$a4,d0		;G
	beq	key_greets

	cmp.b	#$b7,d0		;M
	beq	key_musica

	cmp.b	#$b3,d0		;C
	beq	key_credits

	cmp.b	#$cf,d0		;<-
	beq	key_left

	cmp.b	#$ce,d0		;->
	beq	key_right

	cmp.b	#$df,d0		;HELP
	beq	key_help
rts


key_exit:
;	lea	main_talk,a0
;	move.l	(a0),a0
;	move.w	#1,(a0)

	lea	doescape,a0
	move.l	a0,maincommand
rts

doescape:
	lea	comsleep(pc),a0
	subq.w	#1,(a0)+
rts

;; 0=musica, 2=welcome, 4=help, 6=credits, 8=adverts, 10=texts,  12=greets
key_musica:
	move.w	musica,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#0,section
rts

key_help:
	move.w	help,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#4,section
rts

key_credits:
	move.w	credits,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#6,section
rts

key_adverts:
	move.w	advert,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#8,section
rts


key_text:
	move.w	texts,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#10,section
rts

key_greets:
	move.w	greets,actpage
	lea	writepage,a0
	move.l	a0,maincommand
	move.w	#12,section
rts


key_left:
	lea	contents(pc),a0
	move.w	section,d0
	add.w	d0,a0
	move.w	actpage,d0
	cmp.w	(a0),d0
	beq	key_leftback
	subq.w	#1,d0
	move.w	d0,actpage
	lea	writepage,a0
	move.l	a0,maincommand
key_leftback:
rts

key_right:
	lea	contents(pc),a0
	move.w	section,d0
	add.w	d0,a0
	move.w	actpage,d0
	addq.w	#1,d0
	cmp.w	2(a0),d0
	beq	key_rightback
	move.w	d0,actpage
	lea	writepage,a0
	move.l	a0,maincommand
key_rightback:
rts

mousemem:	dc.w	0
mouscurs:	dc.w	0

askmouse:
	tst.w	askkeyskip
	bne	askmouse_skip
	lea	mousemem(pc),a0
	moveq	#0,d3
	move.b	(a0),d0		;mousemem
	move.b	joy0dat(a5),d1
	sub.b	d1,d0
	roxr.b	#1,d3
	bpl.b	mouse_positiv
	neg.b	d0
mouse_positiv:
	cmp.b	#$0f,d0
	ble.w	notmoved	;moved, but not enough
	cmp.b	#$20,d0
	bge.w	notmoved	;(overflow)
	move.b	d1,(a0)		;mousemem
	tst.b	d3
	beq.b	mouse_up

;mouse_down
	cmp.w	#4,mouscurs
	beq	notmoved
	bsr	clrcurs
	addq.w	#1,mouscurs
	bsr	setcurs
	bra	notmoved
mouse_up:
	tst.w	mouscurs
	beq	notmoved
	bsr	clrcurs
	subq.w	#1,mouscurs
	bsr	setcurs
notmoved:
	btst.b	#6,ciaapra
	beq	mouse_leftbut
	btst.b	#10,$dff016
	beq	mouse_rightbut
	rts

mouse_leftbut:
	btst.b	#10,$dff016
	beq	mouse_bothbut

	move.w	mouscurs,d0
 	beq	key_musica
	cmp.w	#1,d0
	beq	key_adverts
	cmp.w	#2,d0
	beq	key_credits
	cmp.w	#3,d0
	beq	key_greets
	cmp.w	#4,d0
	beq	key_text
askmouse_skip:
	rts

mouse_rightbut:
	bra	key_right
	rts

mouse_bothbut:
	bra	key_exit

setcurs:
	lea	ballon,a0
	lea	planes5+0+50*40*5,a1
	move.w	mouscurs(pc),d0
	mulu.w	#40*5*21,d0
	add.w	d0,a1
	waitblit
	move.l	a0,bltapth(a5)
	move.l	a1,bltbpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#40-4,bltbmod(a5)
	move.w	#40-4,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#5*21*64+2,bltsize(a5)
	waitblit

	lea	ballon,a0
	lea	planes5_2+0+50*40*5,a1
	move.w	mouscurs(pc),d0
	mulu.w	#40*5*21,d0
	add.w	d0,a1
	waitblit
	move.l	a0,bltapth(a5)
	move.l	a1,bltbpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#40-4,bltbmod(a5)
	move.w	#40-4,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#5*21*64+2,bltsize(a5)
	waitblit

	rts

clrcurs:
	lea	balloff,a0
	lea	planes5+0+50*40*5,a1
	move.w	mouscurs(pc),d0
	mulu.w	#40*5*21,d0
	add.w	d0,a1
	waitblit
	move.l	a0,bltapth(a5)
	move.l	a1,bltbpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#40-4,bltbmod(a5)
	move.w	#40-4,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#5*21*64+2,bltsize(a5)
	waitblit

	lea	balloff,a0
	lea	planes5_2+0+50*40*5,a1
	move.w	mouscurs(pc),d0
	mulu.w	#40*5*21,d0
	add.w	d0,a1
	waitblit
	move.l	a0,bltapth(a5)
	move.l	a1,bltbpth(a5)
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#40-4,bltbmod(a5)
	move.w	#40-4,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#5*21*64+2,bltsize(a5)
	waitblit

	rts


waitawhile:
	movem.l	d6-d7,-(a7)
	moveq	#3,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
	cmp.b	$dff007,d6
	beq	waitawhileloop2
	dbf	d7,waitawhileloop1
	movem.l	(a7)+,d6-d7
	rts

changemusic:
	move.w	#-1,P60_fadestep

lea	text+28*2*2+2*2,a0
move.w	lastmodule,d0
mulu.w	#28*2,d0
move.w	#0,(a0,d0.w)

	tst.w	actpage
	bne	noactpage
	bsr	writepagenofade
	noactpage:

	waitmusicout:
	tst.w	P60_master
	bne	waitmusicout

	move.w	#1,skipmusic

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5



lea	playercode,a0
lea	player,a1
move.w	#(playercodeend-playercode)/4-1,d7
playercopy:
move.l	(a0)+,(a1)+
dbf	d7,playercopy

;move.w	#0,intflag
;waitoneframe:
;tst.w	intflag
;beq	waitoneframe

;------------------------------------------------------------------------
; ������������������������������������������������
; � Call P60_Init to initialize the playroutine	�
; � D0 --> Timer detection (for CIA-version)	�
; � A0 --> Address to the module		�
; � A1 --> Address to samples/0			�
; � A2 --> Address to sample buffer		�
; � D0 <-- 0 if succeeded			�
; � A6 <-- $DFF000				�
; � 		Uses D0-A6			�
; ������������������������������������������������
	move.w	newmodule,d0
	lsl.w	#3,d0
	lea	modules,a1
	add.w	d0,a1
	move.l	(a1)+,a0
	move.l	(a1),a1
	move.w	#64,p60_master

move.l	newmod_data,a0
move.l	newmod_smpl,a1

;	lea	P60_data,a0	; Module
;	lea	P60_smpl,a1
;	sub.l	a1,a1		; Samples
	lea	samples,a2	; Sample buffer
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5

;------------------------------------------------------------------------
;moveq	#10,d7
;sleep:
;move.w	#0,intflag
;waitoneframe2:
;tst.w	intflag
;beq	waitoneframe2

;dbf	d7,sleep

	move.w	#0,skipmusic


	lea	text+28*2*2+2*2,a0
	move.w	newmodule,d0
	mulu.w	#28*2,d0
	move.w	#$7e8,(a0,d0.w)

	tst.w	actpage
	bne	noactpage2
	bsr	writepagenofade
	noactpage2:
rts

;code:	dc.w	0
maincommand:	dc.l	0
actpage:	dc.w	0
skipmusic:	dc.w	0
newmod_data:	dc.l	0
newmod_smpl:	dc.l	0
newmodule:	dc.w	0
lastmodule:	dc.w	0
section:	dc.w	0
;; 0=musica, 2=welcome, 4=help, 6=credits, 8=adverts, 10=texts,  12=greets






sinusx:;359/1.5/180/269
dc.W  359, 350, 340, 331, 321, 312, 303, 294, 284, 275, 266
dc.W  257, 248, 239, 230, 222, 213, 204, 196, 188, 180, 171
dc.W  163, 156, 148, 140, 133, 126, 119, 112, 105, 99, 92
dc.W  86, 80, 74, 69, 63, 58, 53, 48, 44, 39, 35, 31, 27
dc.W  24, 21, 18, 15, 12, 10, 8, 6, 4, 3, 2, 1, 0, 0
dc.w	-1


;; 0=musica, 2=welcome, 4=help, 6=credits, 8=adverts, 10=texts,  12=greets

contents:
musica:	dc.w	0	;+1
welcome:dc.w	1	;+1
help:	dc.w	2	;+1
credits:dc.w	3	;+5
advert:	dc.w	8	;+19
texts:	dc.w	27	;+5
greets:	dc.w	32	;+10
	dc.w	42


;------------------------------------------------------------------------
;							  "         '

charsize=4*11
textcalc:
	lea	textoffsetend,a0
	lea	textend,a1
	lea	charsend,a2
	move.w	#textend-text-1,d7
textcalcl1:
	move.l	a2,a3
	move.b	-(a1),d0
	moveq	#charsend-chars-1,d6
textcalcl2:
	cmp.b	-(a3),d0	
	beq	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------


writepage:
	bsr	nextmascpatt
	bsr	fadepageout
	bsr	drawpage
	bsr	nextmascpatt
	bsr	fadepagein
rts

writepagenofade:
	bsr	drawpage
rts


nextmascpatt:
	move.l	actmasc,d0
	add.l	#168,d0
	cmp.l	#lastmasc,d0
	bne	nomascrestart
	move.l	#firstmasc,d0
nomascrestart:
	move.l	d0,actmasc

	move.l	actpattern,d0
	add.l	#24*4*16,d0
	cmp.l	#lastpattern,d0
	bne	nopatternrestart
	move.l	#firstpattern,d0
nopatternrestart:
	move.l	d0,actpattern
rts


fadepageout:
	move.w	#%0000110111111100,fieldterms
	move.w	#0,fadetextskip
fadepageout_wait:
	tst.w	fadetextskip
	beq	fadepageout_wait
rts

fadepagein:
	move.w	#%0000110100001100,fieldterms
	move.w	#0,fadetextskip
fadepagein_wait:
	tst.w	fadetextskip
	beq	fadepagein_wait
rts




drawpage:
	lea	planeadr+12+11*64*4,a0
	lea	planes5+12+11*40*5,a0
	lea	planes5_2+12+11*40*5,a4
	lea	font,a1
	lea	text,a2
	move.w	actpage,d0
	mulu	#28*12*2,d0
	add.l	d0,a2	

	moveq	#11,d5
drawpagel3:
	moveq	#27,d6
drawpagel2:
	move.w	(a2)+,d0
	lea	(a1,d0.w),a3

	moveq	#11-1,d7
drawpagel1:

;	moveq	#4-1,d4
;writepagel4:
	move.b	(a3),0*40(a4)
	move.b	(a3)+,0*40(a0)
	move.b	(a3),1*40(a4)
	move.b	(a3)+,1*40(a0)
	move.b	(a3),2*40(a4)
	move.b	(a3)+,2*40(a0)
	move.b	(a3),3*40(a4)
	move.b	(a3)+,3*40(a0)

;	lea	40(a0),a0
;	dbf	d4,writepagel4



	lea	40*5(a0),a0
	lea	40*5(a4),a4
	dbf	d7,drawpagel1

	lea	-40*11*5+1(a0),a0
	lea	-40*11*5+1(a4),a4
	dbf	d6,drawpagel2
	lea	-28+40*12*5(a0),a0
	lea	-28+40*12*5(a4),a4
	dbf	d5,drawpagel3
rts

colours:
dc.w $F57,$FFF,$FEE,$FCD,$FBC,$F9B,$F89,$F68
dc.w $F57,$D67,$C67,$A67,$967,$766,$655,$444

black:;source
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000

pink:;source
dc.w $f57,$f57,$f57,$f57,$f57,$f57,$f57,$f57
dc.w $f57,$f57,$f57,$f57,$f57,$f57,$f57,$f57




fadetest:
;	lea	spraycolgray,a0
;	moveq	#fadequant1,d7	;number of colours
;	jsr	fader_makegrey

fadequant1=32	;number of colours in this calculation

;	lea	black,a0	;source-colourstable
	lea	pink,a0	;source-colourstable
	lea	colours,a1	;destination-colourtable
	lea	fader_table,a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr	fader_calc

	lea	fader_table,a2
	move.w	#-1,16*fadequant1*2(a2)	;set endmark in colourlist


	lea	colours,a0	;source-colourstable
	lea	pink,a1	;destination-colourtable
	lea	fader_table2,a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr	fader_calc

	lea	fader_table2,a2
	move.w	#-1,16*fadequant1*2(a2)	;set endmark in colourlist



rts




fader_real:
	move.w	fader_direct,d0
	beq	fader_skip
	subq.w	#1,fader_slpcount
	bne	fader_skip
	move.w	fader_sleep,fader_slpcount

	move.l	fader_pos,a0
	tst.w	(a0)
	bmi	fader_end

	moveq	#31,d0
	lea	$dff180,a1
fader_copy:
	move.w	(a0)+,(a1)+
	dbf	d0,fader_copy
	move.l	a0,fader_pos
	rts
fader_end:
	neg.w	d0
	add.w	d0,a0
	move.l	a0,fader_pos
	move.w	#0,fader_direct
fader_skip:
	rts

fader_calc:;V2.0
	move.w	d7,d0
	subq.w	#1,d7	;colour counter
	add.w	d0,d0	;table offset
	move.w	d1,-(a7)

fader_l1:
	move.w	#0,(a2)	;clear colour
	move.w	(a7),d1
	roxr.w	#1,d1
	bcc	fader_skipblue
;blue:
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4	;startpos/solution
	move.w	(a1),d3	;rgb-col dest
	and.w	#15,d3	;b-col dest
	swap	d3
	move.w	(a0),d4
	and.w	#15,d4	;b-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl	fader_noblueflow
	sub.l	d3,d4
fader_noblueflow:
	
	moveq	#15,d6	;rgb counter
fader_calcblue:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcblue
fader_skipblue:

	roxr.w	#1,d1
	bcc	fader_skipgreen
;green
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3	;rgb-col dest
	lsr.w	#4,d3	;rg-col dest
	and.w	#15,d3	;g-col dest
	swap	d3
	move.w	(a0),d4	;g-col src
	lsr.w	#4,d4
	and.w	#15,d4	;g-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl	fader_nogreenflow
	sub.l	d3,d4
fader_nogreenflow:
	moveq	#15,d6	;rgb counter
fader_calcgreen:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#4,d5	;shift green-value to green bit-position
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcgreen
fader_skipgreen:
	roxr.w	#1,d1
	bcc	fader_skipred
;red
	
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3	;rgb-col dest
	lsr.w	#8,d3	;r-col dest
	swap	d3
	move.w	(a0),d4	;rgb-col src
	lsr.w	#8,d4	;r-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl	fader_noredflow	
	sub.l	d3,d4
fader_noredflow:
	moveq	#15,d6	;rgb counter
fader_calcred:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#8,d5	;shift red-value to red bit-position
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcred
fader_skipred:
	addq.l	#2,a0
	addq.l	#2,a1
	addq.l	#2,a2
	dbf	d7,fader_l1

	move.w	(a7)+,d1
rts

fader_makegrey:
	subq.w	#1,d7
fader_makegreyloop:
	moveq	#0,d0
	move.w	(a0),d0
	move.w	d0,d1
	move.w	d0,d2
	and.w	#%1111,d0	;red
	lsr.w	#4,d1
	and.w	#%1111,d1	;green
	lsr.w	#8,d2		;blue
	add.w	d1,d0
	add.w	d2,d0
	divu	#3,d0
	move.w	d0,d1
	lsl.w	#4,d0
	or.w	d1,d0
	lsl.w	#4,d0
	or.w	d1,d0
	move.w	d0,(a0)+
	dbf	d7,fader_makegreyloop
	rts







firstpattern:
pattern1:
incbin	"data/fieldsmasc1.raw"
incbin	"data/fieldsmasc2.raw"
lastpattern:

abyss:		incbin	"data/abyss.blt"

samples:
planes5:
menu:		incbin	"data/menu.blt"
issue:		incbin	"data/issue.blt"

skyline:	incbin	"data/skyline.clc"
title:		incbin	"data/title.blt"



planecls1:
	lea	planeborder,a0
	moveq	#0,d0
	move.w	#(75776/4)-1,d7
planecls1l1:
	move.l	d0,(a0)+
	dbf	d7,planecls1l1
	rts


modules:
	dc.l	mod_data1,mod_smpl1
	dc.l	mod_data2,mod_smpl2
	dc.l	mod_data3,mod_smpl3
	dc.l	mod_data4,mod_smpl4
	dc.l	mod_data5,mod_smpl5
	dc.l	mod_data6,mod_smpl6
	dc.l	mod_data7,mod_smpl7
	dc.l	mod_data8,mod_smpl8
	dc.l	mod_data9,mod_smpl9
	dc.l	mod_data10,mod_smpl10



mod_smpl1:
incbin	"data/modules/SMP.1_amaretto_allergy"
mod_smpl2:
incbin	"data/modules/SMP.2_january_'64"
mod_smpl3:
incbin	"data/modules/SMP.3_patience"
mod_smpl4:
incbin	"data/modules/SMP.4_soundz_like_fuck"
mod_smpl5:
incbin	"data/modules/SMP.5_trip_to_mars"
mod_smpl6:
incbin	"data/modules/SMP.6_alf-theme"
mod_smpl7:
incbin	"data/modules/SMP.7_hysterical"
mod_smpl8:
incbin	"data/modules/SMP.8_journey"
mod_smpl9:
incbin	"data/modules/SMP.9_the_real_world"
mod_smpl10:
incbin	"data/modules/SMP.a_wario_is_missing"

ballon:	incbin	"data/ballon5.blt"
balloff:	incbin	"data/balloff5.blt"


drugframe1:	dc.l	drugpic
drugframe2:	dc.l	drugpic+240


copperlist1:
	dcb.b	64,0
	dc.l	-2

copperlist2:
	dcb.b	64,0
	dc.l	-2

drugpic:	incbin	"data/Spray.blt"
drugpicend:



fadetest2:
	lea	spraycolgray,a0
	moveq	#fadequant1,d7	;number of colours
	jsr	fader_makegrey

fadequant2=32	;number of colours in this calculation

	lea	drugcol2,a0	;source-colourstable
;	lea	drugcol3,a1	;destination-colourtable
	lea	spraycolgray,a1	;destination-colourtable
	lea	fader_table3,a2	;point in fader-table
	moveq	#%101,d1	;RGB filter
	moveq	#fadequant2,d7	;number of colours
	jsr	fader_calc


	lea	fader_table3+15*fadequant2*2,a0
	lea	drugcol3,a1
	lea	fader_table3+16*fadequant2*2,a2
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant2,d7	;number of colours
	jsr	fader_calc

	lea	fader_table3,a2
	move.w	#-1,2*16*fadequant2*2(a2)	;set endmark in colourlist

rts

showplane:	dc.l	0
workplane:	dc.l	0

switchmark:	dc.w	0
switchplanes:
	not.w	switchmark
	beq	do2
do1:
	move.l	#planes5,d0
	add.l	#1*40,d0
	move.l	#planes5_2,d1
	add.l	#1*40,d1

	move.l	d0,workplane
	move.l	d1,showplane
	rts
do2:
	move.l	#planes5,d0
	add.l	#1*40,d0
	move.l	#planes5_2,d1
	add.l	#1*40,d1

	move.l	d1,workplane
	move.l	d0,showplane
	rts

startangle:	dc.w	0
startrad=70
spiral:
	lea	turnsinpoint,a2
	move.w	(a2),d0
	addq.w	#2,d0
	cmp.w	#1440,d0
	bne	.turnsinok
	moveq	#0,d0
.turnsinok:
	move.w	d0,(a2)+
	add.w	d0,a2

	lea	sinus,a1
	
	move.l	workplane(pc),a0
	move.l	#startrad,d6	;radius
	swap	d6
	move.w	startangle(pc),d5		;angle
	addq.w	#2,d5
	cmp.w	#360,d5
	blt	.angleok
	moveq	#0,d5
.angleok:
	move.w	d5,startangle

	move.w	#12,d7
spirall1:
	move.w	d5,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	2(a1,d0.w),d1	;cosinus angle
	move.w	(a1,d0.w),d0	;sinus angle
	move.w	d0,d2
	move.w	d1,d3

	swap	d6
	muls.w	d6,d0
	muls.w	d6,d1
	sub.w	#5,d6
	muls.w	d6,d2
	muls.w	d6,d3
	add.w	#5,d6
	swap	d6

	add.l	d0,d0
	swap	d0
	add.l	d1,d1
	swap	d1

	add.l	d2,d2
	swap	d2
	add.l	d3,d3
	swap	d3


	add.w	#210,d0
	add.w	#85,d1
	add.w	#210,d2
	add.w	#85,d3


;move.l	#10,d2
;move.l	#18,d3

and.l	#$ffff,d0
and.l	#$ffff,d1
and.l	#$ffff,d2
and.l	#$ffff,d3

tst.w	lastx1
bmi	first
movem.l	d0-a6,-(a7)

move.w	lastx1,d2
move.w	lasty1,d3
bsr	line
movem.l	(a7),d0-a6
move.w	lastx2,d0
move.w	lasty2,d1
bsr	line

movem.l	(a7)+,d0-a6

move.w	d0,lastx1
move.w	d1,lasty1
move.w	d2,lastx2
move.w	d3,lasty2



;	tst.w	d0
;	bmi	skipdot
;	tst.w	d1
;	bmi	skipdot
;	cmp.w	#319,d0
;	bge	skipdot
;	cmp.w	#255,d1
;	bge	skipdot

;	move.w	d0,d2
;	lsr.w	#3,d0
;	mulu.w	#40,d1
;	sub.w	d0,d1
;	bset	d2,40(a0,d1.w)



skipdot:
;	add.w	#50,d5	;inc angle
	add.w	(a2)+,d5
	bpl	.noneg
	add.w	#360,d5
.noneg:
	cmp.w	#360,d5
	blt	.noflow
	sub.w	#360,d5
.noflow:

	sub.l	#130000,d6	;;inc radius
	dbf	d7,spirall1

move.w	lastx1,d0
move.w	lasty1,d1
move.w	lastx2,d2
move.w	lasty2,d3
movem.l	d0-a6,-(a7)
bsr	line
movem.l	(a7)+,d0-a6

	move.w	#-1,lastx1

rts

first:
move.w	d0,lastx1
move.w	d1,lasty1
move.w	d2,lastx2
move.w	d3,lasty2
movem.l	d0-a6,-(a7)
bsr	line
movem.l	(a7)+,d0-a6
bra	skipdot

lastx1:	dc.w	-1
lasty1:	dc.w	50

lastx2:	dc.w	50
lasty2:	dc.w	50



planecls:
	lea	$dff000,a5
	move.l	workplane,d0
	add.l	#12*40*5+16,d0

waitblit
	move.l	d0,BLTDPTH(A5)
	move.w	#20+4*40,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#156*64*1+10,BLTSIZE(A5)
	rts

fill:
	lea	$dff000,a5
	move.l	workplane(pc),d0
	add.l	#(12+156)*40*5+6+(15*2)-2,d0

waitblit

	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#20+4*40,bltamod(A5)
	MOVE.w	#20+4*40,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)

	move.w	#156*64*1+10,BLTSIZE(A5)

	rts

line:
	move.l	workplane(pc),a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt	drawl1		;point 2 is greater--> okay
	beq	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
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

	MULU.W	#40*5,D0		;d0=y1*screen offset
;	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
	LSL.W	#1,D3		;d3=lodiff*2
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.W	.NOSIGN		;branch if lodiff*2 >hidiff
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

waitblit
	MOVE.l	#-1,bltafwm(a5)
	MOVE.w	#40*5,bltcmod(a5)
	MOVE.w	#40*5,bltdmod(a5)
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
ifd fulllines
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


logosize=40*101*4
animwave:
	dcb.l	40,animstart+16*logosize
	dc.l	animstart+16*logosize
	dc.l	animstart+15*logosize
	dc.l	animstart+14*logosize
	dc.l	animstart+13*logosize
	dc.l	animstart+12*logosize
	dc.l	animstart+11*logosize
	dc.l	animstart+10*logosize
	dc.l	animstart+9*logosize
	dc.l	animstart+8*logosize
	dc.l	animstart+7*logosize
	dc.l	animstart+6*logosize
	dc.l	animstart+5*logosize
	dc.l	animstart+4*logosize
	dc.l	animstart+3*logosize
	dc.l	animstart+2*logosize
	dc.l	animstart+1*logosize
	dc.l	animstart+0*logosize

	dc.l	animstart+0*logosize
	dc.l	animstart+1*logosize
	dc.l	animstart+2*logosize
	dc.l	animstart+3*logosize
	dc.l	animstart+4*logosize
	dc.l	animstart+5*logosize
	dc.l	animstart+6*logosize
	dc.l	animstart+7*logosize
	dc.l	animstart+8*logosize
	dc.l	animstart+9*logosize
	dc.l	animstart+10*logosize
	dc.l	animstart+11*logosize
	dc.l	animstart+12*logosize
	dc.l	animstart+13*logosize
	dc.l	animstart+14*logosize
	dc.l	animstart+15*logosize
	dc.l	animstart+16*logosize



	dc.l	animstart+16*logosize
	dc.l	animstart+15*logosize
	dc.l	animstart+14*logosize
	dc.l	animstart+13*logosize
	dc.l	animstart+12*logosize
	dc.l	animstart+11*logosize
	dc.l	animstart+10*logosize
	dc.l	animstart+9*logosize
	dc.l	animstart+8*logosize
	dc.l	animstart+7*logosize
	dc.l	animstart+6*logosize
	dc.l	animstart+5*logosize
	dc.l	animstart+4*logosize
	dc.l	animstart+3*logosize
	dc.l	animstart+2*logosize
	dc.l	animstart+1*logosize
	dc.l	animstart+0*logosize

	dcb.l	100,animstart+0*logosize
animwaveend:




fader_maxnum=32*3;;	maximal number of colours in program!!

;fader_colnum:	dc.w	0

dc.w	-1
fader_table3:	dcb.w	fader_maxnum*16
dc.w	-1
;fader_pos:	dc.l	fader_table
;fader_direct:	dc.w	0
;fader_sleep:	dc.w	2
;fader_slpcount:	dc.w	1

pinklist:
	dc.l	$01800F57
	dc.l	$10e1fffe
	dc.l	$10e1fffe
	dcb.l	8,0
	dc.l	-2




codec_e:
;------------------------------------------------------------------------
ifne	usesection
section	data,data_p
endif
datap_s:

mod_data1:
	incbin	"data/modules/P60.1_amaretto_allergy"
mod_data2:
	incbin	"data/modules/P60.2_january_'64"
mod_data3:
	incbin	"data/modules/P60.3_patience"
mod_data4:
	incbin	"data/modules/P60.4_soundz_like_fuck"
mod_data5:
	incbin	"data/modules/P60.5_trip_to_mars"
mod_data6:
	incbin	"data/modules/P60.6_alf-theme"
mod_data7:
	incbin	"data/modules/P60.7_hysterical"
mod_data8:
	incbin	"data/modules/P60.8_journey"
mod_data9:
	incbin	"data/modules/P60.9_the_real_world"
mod_data10:
	incbin	"data/modules/P60.a_wario_is_missing"

font:	incbin	"data/font.blt"

firstmasc:
masc1:	incbin	"data/masc/spiral.masc"
masc2:	incbin	"data/masc/ball1.masc"
masc3:	incbin	"data/masc/snake.masc"
masc4:	incbin	"data/masc/chess.masc"
masc5:	incbin	"data/masc/ball2.masc"
masc6:	incbin	"data/masc/lines1.masc"
masc7:	incbin	"data/masc/lines2.masc"
masc8:	incbin	"data/masc/random.masc"
masc9:	incbin	"data/masc/grow.masc"
lastmasc:

turnsinpoint:	dc.w	0
turnSinus:;Created with Liberty Design's Sinusmaker
;a:
dc.W  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16
dc.W  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
dc.W  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42
dc.W  43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 54
dc.W  55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 64, 65, 66
dc.W  67, 68, 69, 70, 71, 71, 72, 73, 74, 75, 76, 76, 77
dc.W  78, 79, 80, 80, 81, 82, 83, 83, 84, 85, 86, 86, 87
dc.W  88, 88, 89, 90, 91, 91, 92, 93, 93, 94, 95, 95, 96
dc.W  96, 97, 98, 98, 99, 99, 100, 101, 101, 102, 102, 103
dc.W  103, 104, 104, 105, 105, 106, 106, 107, 107, 108, 108
dc.W  109, 109, 110, 110, 110, 111, 111, 112, 112, 112, 113
dc.W  113, 113, 114, 114, 114, 115, 115, 115, 116, 116, 116
dc.W  116, 117, 117, 117, 117, 118, 118, 118, 118, 118, 119
dc.W  119, 119, 119, 119, 119, 119, 119, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 119, 119, 119, 119, 119
dc.W  119, 119, 119, 118, 118, 118, 118, 118, 117, 117, 117
dc.W  117, 116, 116, 116, 116, 115, 115, 115, 114, 114, 114
dc.W  113, 113, 113, 112, 112, 112, 111, 111, 110, 110, 110
dc.W  109, 109, 108, 108, 107, 107, 106, 106, 105, 105, 104
dc.W  104, 103, 103, 102, 102, 101, 101, 100, 99, 99, 98
dc.W  98, 97, 96, 96, 95, 95, 94, 93, 93, 92, 91, 91, 90
dc.W  89, 88, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 80
dc.W  80, 79, 78, 77, 76, 76, 75, 74, 73, 72, 71, 71, 70
dc.W  69, 68, 67, 66, 65, 64, 64, 63, 62, 61, 60, 59, 58
dc.W  57, 56, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46
dc.W  45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33
dc.W  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20
dc.W  19, 18, 17, 16, 15, 14, 13, 12, 10, 9, 8, 7, 6, 5, 4
dc.W  3, 2, 1, 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-12,-13,-14
dc.W -15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27
dc.W -28,-29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40
dc.W -41,-42,-43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53
dc.W -54,-54,-55,-56,-57,-58,-59,-60,-61,-62,-63,-64,-64
dc.W -65,-66,-67,-68,-69,-70,-71,-71,-72,-73,-74,-75,-76
dc.W -76,-77,-78,-79,-80,-80,-81,-82,-83,-83,-84,-85,-86
dc.W -86,-87,-88,-88,-89,-90,-91,-91,-92,-93,-93,-94,-95
dc.W -95,-96,-96,-97,-98,-98,-99,-99,-100,-101,-101,-102
dc.W -102,-103,-103,-104,-104,-105,-105,-106,-106,-107,-107
dc.W -108,-108,-109,-109,-110,-110,-110,-111,-111,-112,-112
dc.W -112,-113,-113,-113,-114,-114,-114,-115,-115,-115,-116
dc.W -116,-116,-116,-117,-117,-117,-117,-118,-118,-118,-118
dc.W -118,-119,-119,-119,-119,-119,-119,-119,-119,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-120,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-119,-119,-119
dc.W -119,-119,-119,-119,-119,-118,-118,-118,-118,-118,-117
dc.W -117,-117,-117,-116,-116,-116,-116,-115,-115,-115,-114
dc.W -114,-114,-113,-113,-113,-112,-112,-112,-111,-111,-110
dc.W -110,-110,-109,-109,-108,-108,-107,-107,-106,-106,-105
dc.W -105,-104,-104,-103,-103,-102,-102,-101,-101,-100,-99
dc.W -99,-98,-98,-97,-96,-96,-95,-95,-94,-93,-93,-92,-91
dc.W -91,-90,-89,-88,-88,-87,-86,-86,-85,-84,-83,-83,-82
dc.W -81,-80,-80,-79,-78,-77,-76,-76,-75,-74,-73,-72,-71
dc.W -71,-70,-69,-68,-67,-66,-65,-64,-64,-63,-62,-61,-60
dc.W -59,-58,-57,-56,-55,-54,-54,-53,-52,-51,-50,-49,-48
dc.W -47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35
dc.W -34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22
dc.W -21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-10,-9,-8,-7
dc.W -6,-5,-4,-3,-2, 0
;b:
dc.W  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16
dc.W  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
dc.W  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42
dc.W  43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 54
dc.W  55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 64, 65, 66
dc.W  67, 68, 69, 70, 71, 71, 72, 73, 74, 75, 76, 76, 77
dc.W  78, 79, 80, 80, 81, 82, 83, 83, 84, 85, 86, 86, 87
dc.W  88, 88, 89, 90, 91, 91, 92, 93, 93, 94, 95, 95, 96
dc.W  96, 97, 98, 98, 99, 99, 100, 101, 101, 102, 102, 103
dc.W  103, 104, 104, 105, 105, 106, 106, 107, 107, 108, 108
dc.W  109, 109, 110, 110, 110, 111, 111, 112, 112, 112, 113
dc.W  113, 113, 114, 114, 114, 115, 115, 115, 116, 116, 116
dc.W  116, 117, 117, 117, 117, 118, 118, 118, 118, 118, 119
dc.W  119, 119, 119, 119, 119, 119, 119, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 119, 119, 119, 119, 119
dc.W  119, 119, 119, 118, 118, 118, 118, 118, 117, 117, 117
dc.W  117, 116, 116, 116, 116, 115, 115, 115, 114, 114, 114
dc.W  113, 113, 113, 112, 112, 112, 111, 111, 110, 110, 110
dc.W  109, 109, 108, 108, 107, 107, 106, 106, 105, 105, 104
dc.W  104, 103, 103, 102, 102, 101, 101, 100, 99, 99, 98
dc.W  98, 97, 96, 96, 95, 95, 94, 93, 93, 92, 91, 91, 90
dc.W  89, 88, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 80
dc.W  80, 79, 78, 77, 76, 76, 75, 74, 73, 72, 71, 71, 70
dc.W  69, 68, 67, 66, 65, 64, 64, 63, 62, 61, 60, 59, 58
dc.W  57, 56, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46
dc.W  45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33
dc.W  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20
dc.W  19, 18, 17, 16, 15, 14, 13, 12, 10, 9, 8, 7, 6, 5, 4
dc.W  3, 2, 1, 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-12,-13,-14
dc.W -15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27
dc.W -28,-29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40
dc.W -41,-42,-43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53
dc.W -54,-54,-55,-56,-57,-58,-59,-60,-61,-62,-63,-64,-64
dc.W -65,-66,-67,-68,-69,-70,-71,-71,-72,-73,-74,-75,-76
dc.W -76,-77,-78,-79,-80,-80,-81,-82,-83,-83,-84,-85,-86
dc.W -86,-87,-88,-88,-89,-90,-91,-91,-92,-93,-93,-94,-95
dc.W -95,-96,-96,-97,-98,-98,-99,-99,-100,-101,-101,-102
dc.W -102,-103,-103,-104,-104,-105,-105,-106,-106,-107,-107
dc.W -108,-108,-109,-109,-110,-110,-110,-111,-111,-112,-112
dc.W -112,-113,-113,-113,-114,-114,-114,-115,-115,-115,-116
dc.W -116,-116,-116,-117,-117,-117,-117,-118,-118,-118,-118
dc.W -118,-119,-119,-119,-119,-119,-119,-119,-119,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-120,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-119,-119,-119
dc.W -119,-119,-119,-119,-119,-118,-118,-118,-118,-118,-117
dc.W -117,-117,-117,-116,-116,-116,-116,-115,-115,-115,-114
dc.W -114,-114,-113,-113,-113,-112,-112,-112,-111,-111,-110
dc.W -110,-110,-109,-109,-108,-108,-107,-107,-106,-106,-105
dc.W -105,-104,-104,-103,-103,-102,-102,-101,-101,-100,-99
dc.W -99,-98,-98,-97,-96,-96,-95,-95,-94,-93,-93,-92,-91
dc.W -91,-90,-89,-88,-88,-87,-86,-86,-85,-84,-83,-83,-82
dc.W -81,-80,-80,-79,-78,-77,-76,-76,-75,-74,-73,-72,-71
dc.W -71,-70,-69,-68,-67,-66,-65,-64,-64,-63,-62,-61,-60
dc.W -59,-58,-57,-56,-55,-54,-54,-53,-52,-51,-50,-49,-48
dc.W -47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35
dc.W -34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22
dc.W -21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-10,-9,-8,-7
dc.W -6,-5,-4,-3,-2, 0

dc.W  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16
dc.W  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
dc.W  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42
dc.W  43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 54
dc.W  55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 64, 65, 66
dc.W  67, 68, 69, 70, 71, 71, 72, 73, 74, 75, 76, 76, 77
dc.W  78, 79, 80, 80, 81, 82, 83, 83, 84, 85, 86, 86, 87
dc.W  88, 88, 89, 90, 91, 91, 92, 93, 93, 94, 95, 95, 96
dc.W  96, 97, 98, 98, 99, 99, 100, 101, 101, 102, 102, 103
dc.W  103, 104, 104, 105, 105, 106, 106, 107, 107, 108, 108
dc.W  109, 109, 110, 110, 110, 111, 111, 112, 112, 112, 113
dc.W  113, 113, 114, 114, 114, 115, 115, 115, 116, 116, 116
dc.W  116, 117, 117, 117, 117, 118, 118, 118, 118, 118, 119
dc.W  119, 119, 119, 119, 119, 119, 119, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 119, 119, 119, 119, 119
dc.W  119, 119, 119, 118, 118, 118, 118, 118, 117, 117, 117
dc.W  117, 116, 116, 116, 116, 115, 115, 115, 114, 114, 114
dc.W  113, 113, 113, 112, 112, 112, 111, 111, 110, 110, 110
dc.W  109, 109, 108, 108, 107, 107, 106, 106, 105, 105, 104
dc.W  104, 103, 103, 102, 102, 101, 101, 100, 99, 99, 98
dc.W  98, 97, 96, 96, 95, 95, 94, 93, 93, 92, 91, 91, 90
dc.W  89, 88, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 80
dc.W  80, 79, 78, 77, 76, 76, 75, 74, 73, 72, 71, 71, 70
dc.W  69, 68, 67, 66, 65, 64, 64, 63, 62, 61, 60, 59, 58
dc.W  57, 56, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46
dc.W  45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33
dc.W  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20
dc.W  19, 18, 17, 16, 15, 14, 13, 12, 10, 9, 8, 7, 6, 5, 4
dc.W  3, 2, 1, 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-12,-13,-14
dc.W -15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27
dc.W -28,-29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40
dc.W -41,-42,-43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53
dc.W -54,-54,-55,-56,-57,-58,-59,-60,-61,-62,-63,-64,-64
dc.W -65,-66,-67,-68,-69,-70,-71,-71,-72,-73,-74,-75,-76
dc.W -76,-77,-78,-79,-80,-80,-81,-82,-83,-83,-84,-85,-86
dc.W -86,-87,-88,-88,-89,-90,-91,-91,-92,-93,-93,-94,-95
dc.W -95,-96,-96,-97,-98,-98,-99,-99,-100,-101,-101,-102
dc.W -102,-103,-103,-104,-104,-105,-105,-106,-106,-107,-107
dc.W -108,-108,-109,-109,-110,-110,-110,-111,-111,-112,-112
dc.W -112,-113,-113,-113,-114,-114,-114,-115,-115,-115,-116
dc.W -116,-116,-116,-117,-117,-117,-117,-118,-118,-118,-118
dc.W -118,-119,-119,-119,-119,-119,-119,-119,-119,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-120,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-119,-119,-119
dc.W -119,-119,-119,-119,-119,-118,-118,-118,-118,-118,-117
dc.W -117,-117,-117,-116,-116,-116,-116,-115,-115,-115,-114
dc.W -114,-114,-113,-113,-113,-112,-112,-112,-111,-111,-110
dc.W -110,-110,-109,-109,-108,-108,-107,-107,-106,-106,-105
dc.W -105,-104,-104,-103,-103,-102,-102,-101,-101,-100,-99
dc.W -99,-98,-98,-97,-96,-96,-95,-95,-94,-93,-93,-92,-91
dc.W -91,-90,-89,-88,-88,-87,-86,-86,-85,-84,-83,-83,-82
dc.W -81,-80,-80,-79,-78,-77,-76,-76,-75,-74,-73,-72,-71
dc.W -71,-70,-69,-68,-67,-66,-65,-64,-64,-63,-62,-61,-60
dc.W -59,-58,-57,-56,-55,-54,-54,-53,-52,-51,-50,-49,-48
dc.W -47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35
dc.W -34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22
dc.W -21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-10,-9,-8,-7
dc.W -6,-5,-4,-3,-2, 0

dc.W  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16
dc.W  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
dc.W  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42
dc.W  43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 54
dc.W  55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 64, 65, 66
dc.W  67, 68, 69, 70, 71, 71, 72, 73, 74, 75, 76, 76, 77
dc.W  78, 79, 80, 80, 81, 82, 83, 83, 84, 85, 86, 86, 87
dc.W  88, 88, 89, 90, 91, 91, 92, 93, 93, 94, 95, 95, 96
dc.W  96, 97, 98, 98, 99, 99, 100, 101, 101, 102, 102, 103
dc.W  103, 104, 104, 105, 105, 106, 106, 107, 107, 108, 108
dc.W  109, 109, 110, 110, 110, 111, 111, 112, 112, 112, 113
dc.W  113, 113, 114, 114, 114, 115, 115, 115, 116, 116, 116
dc.W  116, 117, 117, 117, 117, 118, 118, 118, 118, 118, 119
dc.W  119, 119, 119, 119, 119, 119, 119, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120
dc.W  120, 120, 120, 120, 120, 120, 119, 119, 119, 119, 119
dc.W  119, 119, 119, 118, 118, 118, 118, 118, 117, 117, 117
dc.W  117, 116, 116, 116, 116, 115, 115, 115, 114, 114, 114
dc.W  113, 113, 113, 112, 112, 112, 111, 111, 110, 110, 110
dc.W  109, 109, 108, 108, 107, 107, 106, 106, 105, 105, 104
dc.W  104, 103, 103, 102, 102, 101, 101, 100, 99, 99, 98
dc.W  98, 97, 96, 96, 95, 95, 94, 93, 93, 92, 91, 91, 90
dc.W  89, 88, 88, 87, 86, 86, 85, 84, 83, 83, 82, 81, 80
dc.W  80, 79, 78, 77, 76, 76, 75, 74, 73, 72, 71, 71, 70
dc.W  69, 68, 67, 66, 65, 64, 64, 63, 62, 61, 60, 59, 58
dc.W  57, 56, 55, 54, 54, 53, 52, 51, 50, 49, 48, 47, 46
dc.W  45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33
dc.W  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20
dc.W  19, 18, 17, 16, 15, 14, 13, 12, 10, 9, 8, 7, 6, 5, 4
dc.W  3, 2, 1, 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-12,-13,-14
dc.W -15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27
dc.W -28,-29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40
dc.W -41,-42,-43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53
dc.W -54,-54,-55,-56,-57,-58,-59,-60,-61,-62,-63,-64,-64
dc.W -65,-66,-67,-68,-69,-70,-71,-71,-72,-73,-74,-75,-76
dc.W -76,-77,-78,-79,-80,-80,-81,-82,-83,-83,-84,-85,-86
dc.W -86,-87,-88,-88,-89,-90,-91,-91,-92,-93,-93,-94,-95
dc.W -95,-96,-96,-97,-98,-98,-99,-99,-100,-101,-101,-102
dc.W -102,-103,-103,-104,-104,-105,-105,-106,-106,-107,-107
dc.W -108,-108,-109,-109,-110,-110,-110,-111,-111,-112,-112
dc.W -112,-113,-113,-113,-114,-114,-114,-115,-115,-115,-116
dc.W -116,-116,-116,-117,-117,-117,-117,-118,-118,-118,-118
dc.W -118,-119,-119,-119,-119,-119,-119,-119,-119,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-120,-120,-120
dc.W -120,-120,-120,-120,-120,-120,-120,-120,-119,-119,-119
dc.W -119,-119,-119,-119,-119,-118,-118,-118,-118,-118,-117
dc.W -117,-117,-117,-116,-116,-116,-116,-115,-115,-115,-114
dc.W -114,-114,-113,-113,-113,-112,-112,-112,-111,-111,-110
dc.W -110,-110,-109,-109,-108,-108,-107,-107,-106,-106,-105
dc.W -105,-104,-104,-103,-103,-102,-102,-101,-101,-100,-99
dc.W -99,-98,-98,-97,-96,-96,-95,-95,-94,-93,-93,-92,-91
dc.W -91,-90,-89,-88,-88,-87,-86,-86,-85,-84,-83,-83,-82
dc.W -81,-80,-80,-79,-78,-77,-76,-76,-75,-74,-73,-72,-71
dc.W -71,-70,-69,-68,-67,-66,-65,-64,-64,-63,-62,-61,-60
dc.W -59,-58,-57,-56,-55,-54,-54,-53,-52,-51,-50,-49,-48
dc.W -47,-46,-45,-44,-43,-42,-41,-40,-39,-38,-37,-36,-35
dc.W -34,-33,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22
dc.W -21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-10,-9,-8,-7
dc.W -6,-5,-4,-3,-2, 0


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

chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789!?-:|.,()*#/=+�><"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
;music
;	 1234567890123456789012345678
dc.b	"          musica            "	; 0
dc.b	"   name               length"	; 1
dc.b	"f1*amaretto allergy   32922b"	; 2
dc.b	"f2 january�64         29998b"	; 3
dc.b	"f3 patience           23378b"	; 4
dc.b	"f4 soundz like fuck   12300b"	; 5
dc.b	"f5 trip to mars       26810b"	; 6
dc.b	"f6 alf theme           7998b"	; 7
dc.b	"f7 hysterical         17500b"	; 8
dc.b	"f8 journey            27070b"	; 9
dc.b	"f9 the real world     16270b"	;10
dc.b	"f0 wario is missing   14754b"	;11

;welcome
dc.b	"############################"	; 0
dc.b	"#                          #"	; 1
dc.b	"#  diznee land issue two   #"	; 2
dc.b	"#                          #"	; 3
dc.b	"#         released         #"	; 4
dc.b	"#                          #"	; 5
dc.b	"#    at the assembly 94    #"	; 6
dc.b	"#                          #"	; 7
dc.b	"#                          #"	; 8
dc.b	"#    press help 4 help     #"	; 9
dc.b	"#                          #"	;10
dc.b	"############################"	;11

;help
dc.b	"     f1-f10 to select tunes "
dc.b	"use mouse or press:         "
dc.b	"     m...music menu         "
dc.b	"     a...advertisments      "
dc.b	"     c...credits            "
dc.b	"     g...greetings          "
dc.b	"     t...texts              "
dc.b	"     lmb...select item      "
dc.b	" csr right/rmb....next page "
dc.b	"    csr left...prev page    "
dc.b	"    both mousebuttons or    "
dc.b	"      esc to leave...       "

;credits
dc.b	"        the credits         "
dc.b	"                            "
dc.b	" code and additional design "
dc.b	"             by             "
dc.b	"            moon            "
dc.b	"                            "
dc.b	"           music:           "
dc.b	"                            "
dc.b	"     f1-f5 by mem�o ree     "
dc.b	"     f6-f0 by pink          "
dc.b	"                            "
dc.b	"                          ->"

dc.b	"                            "
dc.b	"             gfx:           "
dc.b	"                            "
dc.b	"    main gfx by mem�o ree   "
dc.b	"                            "
dc.b	"          title pic:        "
dc.b	"                            "
dc.b	"    paintcan by tyshdomos   "
dc.b	"                            "
dc.b	" logo by mem�o ree and toxic"
dc.b	"                            "
dc.b	"                          ->"

dc.b	"          write 2           "	; 0
dc.b	"mem�o ree                   "	; 1
dc.b	"gregory engelhardt          "	; 2
dc.b	"am weiherbach 6             "	; 3
dc.b	"89361 landensberg           "	; 4
dc.b	"germany                     "	; 5
dc.b	"                            "	; 6
dc.b	"toxic                       "	; 7
dc.b	"sven dedek                  "	; 8
dc.b	"grunewaldstrasse 6          "	; 9
dc.b	"84453 muehldorf             "	;10
dc.b	"germany                   ->"	;11

dc.b	"moon                        "	; 0
dc.b	"po box 162                  "	; 1
dc.b	"5400 hallein                "	; 2
dc.b	"austria                     "	; 3
dc.b	"                            "	; 4
dc.b	"skindiver                   "	; 5
dc.b	"andreas schwarz             "	; 6
dc.b	"pfarrer-ziller-strasse 15   "	; 7
dc.b	"85402 kranzberg             "	; 8
dc.b	"germany                     "	; 9
dc.b	"                            "	;10
dc.b	"                          ->"	;11

dc.b	"the duke                    "	; 0
dc.b	"markus knauer               "	; 1
dc.b	"fritz-bender-strasse 9      "	; 2
dc.b	"85402 kranzberg             "	; 3
dc.b	"germany                     "	; 4
dc.b	"                            "	; 7
dc.b	"----------------------------"	; 7
dc.b	"         abyss whq          "	; 8
dc.b	"      floodland  bbs        "	; 9
dc.b	"      +49-8621-64260        "	; 7
dc.b	"----------------------------"	; 7
dc.b	"                            "	;11


;adverts
dc.b	"                            "	; 3
dc.b	"                            "	;11
dc.b	"send your adverts to        "	; 4
dc.b	"mem�o ree, toxic or moon    "	; 5
dc.b	"size: 28*12                 "	; 6
dc.b	"                            "	; 7
dc.b	"                            "	;11
dc.b	"dont forget to vote for     "	; 8
dc.b	"the swap�n�dance charts     "	; 9
dc.b	"send to skindiver or duke   "	;10
dc.b	"                            "	;11
dc.b	"                            "	;11

dc.b "hello guyz ! if you want get"
dc.b "a new nice contact, then you"
dc.b "    should try this one!    "
dc.b "                            "
dc.b "        action/energy       "
dc.b "     ------------------     "
dc.b "        przemek wozny       "
dc.b "      h.sawickiej 37/27     "
dc.b "        62-800 kalisz       "
dc.b "           poland           "
dc.b "    voice: +48 062 538-98   "
dc.b "                            "

dc.b "                            "
dc.b "                            "
dc.b "    skindiver ofz .abyss.   "
dc.b "- -- --- -------------------"
dc.b "    pfarrer-ziller-str.15   "
dc.b "       85402 kranzberg      "
dc.b "           germany          "
dc.b "------------------- --- -- -"
dc.b "    skindiver ofz .abyss.   "
dc.b "                            "
dc.b "                            "
dc.b "                            "

dc.b "                            "
dc.b "                            "
dc.b "         klf / fate         "
dc.b "       marcin kaminski      "
dc.b "        sloneczna 6/1       "
dc.b "         64-920 pila        "
dc.b "           poland           "
dc.b "                            "
dc.b "       fast + friendly      "
dc.b "          swapping          "
dc.b "                            "
dc.b "                            "

dc.b "  for swapping the latest!  "
dc.b "  or tekkkno tapes sticker  "
dc.b "  sweets coasters and       "
dc.b "  others crasy things!!     "
dc.b "                            "
dc.b "        write now!!         "
dc.b "                            "
dc.b "    mogul of ram jam(fhq)   "
dc.b "    16 bis rue j.jugan      "
dc.b "     35590 l�hermitage      "
dc.b "         -france-           "
dc.b "                            "

dc.b "                            "
dc.b " i�m out searching for some "
dc.b " cool,friendly,fast contacts"
dc.b "      you want to swap      "
dc.b "    0-5  days stuff plus    "
dc.b "   >>>> long letters <<<<   "
dc.b "      r e a l  f a s t      "
dc.b "     magne p. zachrisen     "
dc.b "     aschehougsgt. 19       "
dc.b "     3183 horten            "
dc.b "     norway                 "
dc.b "                            "

dc.b "                            "
dc.b " if you are a gfx artist who"
dc.b " looks for cool and friendly"
dc.b "  gfx contacts all over the "
dc.b " world feel free to contact "
dc.b "          me under:         "
dc.b "      distortion/storm      "
dc.b "   ul. koszalinska 32i/20   "
dc.b "      78-105 kolobrzeg      "
dc.b "          poland.           "
dc.b "                            "
dc.b "                            "

dc.b "  flower child of iris is   "
dc.b "searching for more contacts "
dc.b "so if you want a friendship "
dc.b "contact write today!        "
dc.b "                            "
dc.b "       jens back            "
dc.b "       jydekrogen 2         "
dc.b "       5580 nr. aaby        "
dc.b "       denmark              "
dc.b "                            "
dc.b "   iris - pure energy!      "
dc.b "                            "

dc.b "          hades             "
dc.b "      (independent)         "
dc.b "                            "
dc.b "    want contacts with      "
dc.b "  musicians of all kinds!   "
dc.b "i�ll answer all your letters"
dc.b "                            "
dc.b "      my address is:        "
dc.b "  marcus |hades| blomberg   "
dc.b "       linerovagen 53       "
dc.b "       s-224 75  lund       "
dc.b "          sweden            "

dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "       lasol 1911 whq       "
dc.b "           pl  27           "
dc.b "      41160 tikkakoski      "
dc.b "          finland!          "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "

dc.b "       qba                  "
dc.b "          of                "
dc.b "            illusion        "
dc.b "                            "
dc.b "      addy:                 "
dc.b "         qba/illusion       "
dc.b "         p.o. box 105       "
dc.b "       12-100  szczytno     "
dc.b "            poland          "
dc.b "                            "
dc.b "       support my pack      "
dc.b "                            "

dc.b "                            "
dc.b " for fast and friendly swap "
dc.b "          write to:         "
dc.b "                            "
dc.b "    warhawk of obsession    "
dc.b "       przemyslaw jez       "
dc.b "     ul. korfantego 9/1     "
dc.b "       43200 pszczyna       "
dc.b "           poland           "
dc.b "                            "
dc.b "    ! friendship rulez !    "
dc.b "                            "

dc.b "                            "
dc.b " for everything about music "
dc.b "                            "
dc.b "                            "
dc.b "         write to:          "
dc.b "                            "
dc.b "        pink/abyss          "
dc.b "     manfred linzner        "
dc.b "    rupert-mayer-str.2      "
dc.b "     81379  muenchen        "
dc.b "                            "
dc.b "                            "

dc.b "ya are searching for hq-gfx "
dc.b "    for yar productions?    "
dc.b "         no problem!        "
dc.b "     i paint it for you!    "
dc.b "                            "
dc.b "        write to me:        "
dc.b "                            "
dc.b "       toxic of abyss       "
dc.b "         sven dedek         "
dc.b "      gruenewaldstr. 6      "
dc.b "      84453  muehldorf      "
dc.b "          germoney          "

dc.b "                            "
dc.b "                            "
dc.b "  for friendly swapping     "
dc.b "        + rave tape trading "
dc.b "                            "
dc.b "     duke of abyss          "
dc.b "     fr. bender str. 9      "
dc.b "     85402 kranzberg        "
dc.b "     germany                "
dc.b "                            "
dc.b "  hardcore will never die   "
dc.b "                            "

dc.b "                            "
dc.b "  andy of nuance is still   "
dc.b "searching for more friendly "
dc.b "   mailtrading-contacts.    "
dc.b "                            "
dc.b "      andreas dubois        "
dc.b "       starenweg  9         "
dc.b "      89584  ehingen        "
dc.b "      g e r m a n y         "
dc.b "                            "
dc.b "       only elite           "
dc.b "                            "

dc.b "                            "
dc.b "tristar and red sector inc. "
dc.b "            for fast�n�elite"
dc.b "    swapping write to:      "
dc.b "                            "
dc.b "         norby of trsi      "
dc.b "          p.o. box 20       "
dc.b "         56-300 milicz      "
dc.b "            poland          "
dc.b "                            "
dc.b "  cool stuff�n�letter       "
dc.b "                            "

dc.b "                            "
dc.b "      contact scope at:     "
dc.b "                            "
dc.b "         qwerty/scp         "
dc.b "        adrian dolny        "
dc.b "       62-850  liskow       "
dc.b "        woj.kaliskie        "
dc.b "           poland           "
dc.b "                            "
dc.b "   scope-scene too small?   "
dc.b "                            "
dc.b "                            "

dc.b "    read da kewlest mag     "
dc.b "       in da scene!!!       "
dc.b "                            "
dc.b "        oepir risti         "
dc.b "                            "
dc.b "    c/o alvar andersson     "
dc.b "         halliden 2         "
dc.b "        436 39 askim        "
dc.b "           sweden           "
dc.b "                            "
dc.b "     all we want is your    "
dc.b "      support and ideas     "







;texts
dc.b	"  message to all guys, who  "
dc.b	"   sent us advertisments:   "
dc.b	"                            "
dc.b	"  please note that we have  "
dc.b	"  not the time to reformat  "
dc.b	"  any advertisments in the  "
dc.b	"  future                    "
dc.b	"                            "
dc.b	"  please send us only the   "
dc.b	"      right format of       "
dc.b	"                            "
dc.b	"          28 x 12         ->"

dc.b	"                            "	; 0
dc.b	" the first thing we want to "	; 0
dc.b	" show is our new memberlist "	; 0
dc.b	"                            "	; 3
dc.b	" tyshdomos, dexter, bartman "	; 7
dc.b	" smc, neurodancer, the duke "	; 7
dc.b	" moon, toxic, memoree, pink "	; 7
dc.b	" jumping pixel, cazal, poet "  ; 7
dc.b	"         skindiver          "	;11
dc.b	"                            "	;11
dc.b	"   our abyss pet is alloy   "	;11
dc.b	"                          ->"	;11

dc.b	" now som messies from toxic:"	;11
dc.b	"                            "	;11
dc.b	" to astro:                  "	;11
dc.b	" thx, for always nice       "	;11
dc.b	" sendings, mate.            "	;11
dc.b	"                            "	;11
dc.b	" to magz:                   "	;11
dc.b	" sorry, but we dont need    "	;11
dc.b	" any new member.            "	;11
dc.b	"                            "	;11
dc.b	" to sting:                  "	;11
dc.b	" du scheena bua du!       ->"	;11

dc.b	" to ragman:                 "	;11
dc.b	" please call me again!      "	;11
dc.b	"                            "	;11
dc.b	" to core:                   "	;11
dc.b	" send more releases of      "	;11
dc.b	" your group.                "	;11
dc.b	"                            "	;11
dc.b	" to dose:                   "	;11
dc.b	" continue this good         "	;11
dc.b	" work and support           "	;11
dc.b	" for swap and dance.        "	;11
dc.b	"                          ->"	;11

dc.b	" to all rebels members:     "	;11
dc.b	" und tschuess...            "	;11
dc.b	"                            "	;11
dc.b	" to all members of shrimps  "	;11
dc.b	" design:                    "	;11
dc.b	" hope that we have soon an  "	;11
dc.b	" coop!                      "	;11
dc.b	"                            "	;11
dc.b	" to the rest:               "	;11
dc.b	"                            "	;11
dc.b	" i love ya all...           "	;11
dc.b	"                            "	;11

;greets
dc.b	"2fast of trsi               "                  
dc.b	"ace of trance inc.          "                      
dc.b	"action of energy            "
dc.b	"al bundy of jewels          "
dc.b	"andy of nuance              "
dc.b	"antex of control            "
dc.b	"astro of movement           "
dc.b	"apeman of anaheim           "
dc.b	"avenger of mad elks         "
dc.b	"axel f. of retire           "
dc.b	"backfire of applause        "
dc.b	"bbx of orion              ->"

dc.b	"boozio of the edge          "
dc.b	"candyman of sardonyx        "
dc.b	"celtic of mellow            "
dc.b	"cesium of balance           "
dc.b	"cetrix of freezers          "
dc.b	"chaos of desire             "
dc.b	"chitin of orion             "
dc.b	"chmiel of status o.k.       "
dc.b	"chris of iris               "
dc.b	"clever of tfd               "
dc.b	"colorbird of razor 1911     "
dc.b	"coma of dual format       ->"

dc.b	"condor of jewels            "                    
dc.b	"core of disaster            "
dc.b	"crazy-d of c-lous           "
dc.b	"crusader of depth           "
dc.b	"d-mage of vitual dreams     "
dc.b	"darkside of samba           "
dc.b	"distortion of strom         "
dc.b	"dose of trance              "
dc.b	"double r of intense         "
dc.b	"duffy of iris               "
dc.b	"facets pussy of desire      "
dc.b	"fake of equinox           ->"

dc.b	"felix of speedy             "
dc.b	"fiction of intense          "
dc.b	"flynn of outlaws            "
dc.b	"eightball of s!p            "
dc.b	"gart of bronx               "
dc.b	"ghandy of rebels            "
dc.b	"gold dragon of unlimited    "
dc.b	"grand duke of diffusion     "
dc.b	"hazel of absolute!          "
dc.b	"hacksaw of chrome           "
dc.b	"howie of essence            "
dc.b	"izerman of s!p            ->"

dc.b	"ice cube of manitou         "
dc.b	"javair of tmg               "
dc.b	"kazz of bronx               "
dc.b	"killraven of dcs            "
dc.b	"klf of fate                 "
dc.b	"limbo of razor 1911         "
dc.b	"loony of divine             "
dc.b	"lord of absolute            "
dc.b	"magz(ind.)                  "
dc.b	"m.a.s.e of ram jam          "
dc.b	"malarky(ind.)               "
dc.b	"maniac of cadaver         ->"

dc.b	"manik of dual format        "
dc.b	"melvin of scandal           "
dc.b	"mephi of damage             "
dc.b	"mephisto of retire          "
dc.b	"messerschmitt of s!p        "
dc.b	"messiah of eqiunox          "
dc.b	"mike of defiance            "
dc.b	"mop of essence              "
dc.b	"mr.keel of nova             "
dc.b	"mr.king of scoopex          "
dc.b	"napoleon of dreamdealers    "
dc.b	"nick of offence           ->"

dc.b	"norby of trsi               "
dc.b	"nuke of manitou             "
dc.b	"onix of illegal             "
dc.b	"oxstone of spasm            "
dc.b	"paperboy of simplex         "
dc.b	"paze of rebels              "
dc.b	"peace of solitude           "
dc.b	"phuture of saints           "
dc.b	"poke of accession           "
dc.b	"purple haze                 "
dc.b	"python of trsi              "
dc.b	"qba of illusion           ->"

dc.b	"qwerty of scope             "
dc.b	"ravana of sepultura         "
dc.b	"rave of manitou             "
dc.b	"raze of fanatic             "
dc.b	"reactor of mystic           "
dc.b	"redman of mad elks          "
dc.b	"rip of manitou              "
dc.b	"sascha of applause          "
dc.b	"saturn of virtual           "
dc.b	"sir jinx of neoplasia       "
dc.b	"sonic flash of pulse        "
dc.b	"spacehawk of iris         ->"

dc.b	"spoky of analog             "
dc.b	"squirrel of progress        "
dc.b	"stc of hemoroids            "
dc.b	"sting of alcatraz           "
dc.b	"steffen of speedy           "
dc.b	"stratus of quick design     "
dc.b	"the hitcher of diffusion    "
dc.b	"the trader of fear          "
dc.b	"thor of nuance              "
dc.b	"tom of manitou              "
dc.b	"tos of silicon              "
dc.b	"trasher of sanity         ->"

dc.b	"tyrant of cadaver           "
dc.b	"ultra sur of metro          "
dc.b	"vitrue of legacy            "
dc.b	"virus of arise              "
dc.b	"vodka of saturne            "
dc.b	"wea(ind.)                   "
dc.b	"wildcat of scania           "
dc.b	"wizard of infect            "
dc.b	"wotw of essence             "
dc.b	"yahoo of old bulls          "
dc.b	"zinkfloid of trsi           "
dc.b	"zinko of polka brothers     "

textend:	dcb.b	textend-text,0
textoffsetend:	dc.w	-1

drugcol2:;source
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000

drugcol3:;destination
dc.w $000,$666,$F9C,$904,$401,$601,$643,$300
dc.w $702,$865,$803,$89E,$ABF,$FA5,$DDD,$D49
dc.w $A05,$B27,$C39,$D5A,$E6A,$A80,$974,$D93
dc.w $FC6,$888,$AAA,$B71,$F7C,$CCC,$DDF,$EEE
dc.w $214,$666,$F9C,$904,$401,$601,$643,$300
dc.w $702,$865,$803,$89E,$ABF,$FA5,$DDD,$D49
dc.w $A05,$B27,$C39,$D5A,$E6A,$A80,$974,$D93
dc.w $FC6,$888,$AAA,$B71,$F7C,$CCC,$DDF,$EEE

spraycolgray:;destination
dc.w $000,$666,$F9C,$904,$401,$601,$643,$300
dc.w $702,$865,$803,$89E,$ABF,$FA5,$DDD,$D49
dc.w $A05,$B27,$C39,$D5A,$E6A,$A80,$974,$D93
dc.w $FC6,$888,$AAA,$B71,$F7C,$CCC,$DDF,$EEE
dc.w $214,$666,$F9C,$904,$401,$601,$643,$300
dc.w $702,$865,$803,$89E,$ABF,$FA5,$DDD,$D49
dc.w $A05,$B27,$C39,$D5A,$E6A,$A80,$974,$D93
dc.w $FC6,$888,$AAA,$B71,$F7C,$CCC,$DDF,$EEE

playercode:	incbin	"data/player60.code"
playercodeend:


player:	incbin	"data/player60.code"
P60_init=player+40
P60_music=player+738
P60_end=player+626
P60_master=player+16

;fader_maxnum=32*1;;	maximal number of colours in program!!
;fader_maxnum=32*3;;	maximal number of colours in program!!

fader_colnum:	dc.w	0

dc.w	-1
fader_table:	dcb.w	fader_maxnum*16
dc.w	-1

dc.w	-1
fader_table2:	dcb.w	fader_maxnum*16
dc.w	-1

fader_pos:	dc.l	fader_table
fader_direct:	dc.w	0
fader_sleep:	dc.w	2
fader_slpcount:	dc.w	1

datap_e:
;------------------------------------------------------------------------
ifne	usesection
section	memory,bss_p
endif
bssp_s:
animstart:
		ds.b	40*101*4*17
animend:
bssp_e:
;------------------------------------------------------------------------
ifne	usesection
section	chipmemory,bss_c
endif
bssc_s:
planeborder:	ds.b	4*40*64
planeadr:	ds.b	4*planesize
planes5_2:	ds.b	51200
bssc_e:

;----------------
datac_s:
datac_e:
;----------------

codep_s:
codep_e:

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

