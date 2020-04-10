;------------------------------------------------------------------------
;|                                                                      |
;|                              DIZNEE LAND                             |
;|                             -------------                            |
;|                                                                      |
;|                                Issue 1                               |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                        April 1994 |
;------------------------------------------------------------------------
incdir	""
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
;--------------------------------
	jmp	start_		;
	jsr	main_init	;
	jsr	main_program	;
	jsr	main_back	;
	rts			;
;--------------------------------
;------------------------------------------------
start_:						;
	move.l	4.w,a6				;
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
	jsr	forbid(a6)			;
	lea	$dff000,a5			;
	move.w	#%0000001111100000,dmacon(a5)	;
	move.w	#%0000000001101000,intena(a5)	;
	move.w	#%0000001000000000,bplcon0(a5)
	move.l	$6c.w,oldint			;
	move.l	#main_vbi,$6c.w			;
	move.w	#%1100000000100000,intena(a5)	;
	move.w	#%1000001101000000,dmacon(a5)	;
	lea	fakemain_vbiuser,a0		;
	lea	fakemain_copperlist,a1		;
	lea	fakemain_talk,a2		;
	jsr	main_init			;
	bsr	main_program			;
wait:						;
	btst.b	#6,ciaapra			;
;	beq	back				;
	lea	main_talk,a0			;
	move.l	(a0),a0				;
	tst.w	(a0)				;
	beq	wait				;
back:						;
	move.l	oldint,$6c.w			;
	waitblit				;
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
	move.l	4.w,a6				;
	lea	gfxname,a1			;
	moveq	#0,d0				;
	jsr	openlibrary(a6)			;
	move.l	d0,a0				;
	lea	$dff000,a5			;
	move.l	38(a0),cop1lch(a5)		;
	move.w	#%1000000000001000,intena(a5)	;
	move.w	#%1000001111100000,dmacon(a5)	;
	move.w	#0,copjmp1(a5)			;
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
main_emptycopperlist:	dc.l	-2			;
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
	beq	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;
	lea	main_copperlist,a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq	nomain_copperlist				;
	move.l	(a0),a1						;
	move.l	#0,(a0)						;
	move.l	a1,cop1lch(a5)					;
	move.w	#0,copjmp1(a5); should be removed!!		;
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
		dc.l	200,	setint_title
		dc.l	40,	fadetitleout
		dc.l	90,	setint_come1
		dc.l	70,	setint_come2
		dc.l	36,	setint_come3
		dc.l	2,	setint_text
		dc.l	1,	setint_textpage0
		dc.l	40,	setint_getout
		dc.l	1,	setente

		dc.l	60000,	commandrestart
;---------------------------------------------
commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts

setint_title:
	move.w	#$6981,diwstrt(a5)
	move.w	#$ebc1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#$78,bpl1mod(a5)
	move.w	#$78,bpl2mod(a5)
	move.w	#%0100001000000000,bplcon0(a5)
	rts

fadetitleout:
	move.w	#fadequant1*2,fader_direct
	move.l	#fader_table2,fader_pos

rts

setint_come1:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#$d8,bpl1mod(a5)
	move.w	#$d8,bpl2mod(a5)
	move.w	#%0000001000000000,bplcon0(a5)

	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intcome1,(a0)

;	lea	main_copperlist,a1
;	move.l	(a1),a1
;	move.l	#copperlist,(a1)

	lea	colours(pc),a0
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

	move.w	#-2,P60_fadestep
rts

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
	bsr	fadetest
	lea	precalc(pc),a0
	move.l	a0,maincommand

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
bra	skip
	lea	colours(pc),a0
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

skip:
move.w	#fadequant1*2,fader_direct


main_loop:
	btst.b	#6,ciaapra
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
	move.w	#%0100001000000000,bplcon0(a5)

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
	move.w	#$a0,bpl1mod(a5)
	move.w	#$a0,bpl2mod(a5)
	move.w	#%0101001000000000,bplcon0(a5)
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
	bne	main_inttext_skipmusic

	jsr	P60_fader
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
main_inttext_skipmusic:


	bsr	fadetext
	bsr	askkey
;	bsr	drawmenu
;	bsr	writepage

	move.w	#1,intflag
	lea	comsleep(pc),a0
	addq.w	#1,(a0)+

	jsr	commander

	rts
;----------


precalc:
	jsr	planecls1
	bsr	calcanim
	bsr	textcalc
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


logosize=40*101*4


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
	lea	animwave(pc),a4
	move.l	(a4,d4.w),d0
	moveq	#0,d5

	move.l	d0,a0
	lea	planeadr+64*155*4,a1

	moveq	#19,d6
putpicloopx:
	move.l	a0,a2
	move.l	a1,a3
putpicloopy:

linepos:	set	0

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

;	cmp.b	#$94,d0		;T	no texts yet
;	beq	key_text

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

;key_text:
;	move.w	advert,actpage
;	lea	writepage,a0
;	move.l	a0,maincommand
;	move.w	#8,section
;rts

key_adverts:
	move.w	advert,actpage
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

lea	text+28*2*2+2*2(pc),a0
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


	lea	text+28*2*2+2*2(pc),a0
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
;2=welcome, 0=musica, 4=help, 6=credits, 8=text, 10=adress, 12=greets






sinusx:;359/1.5/180/269
dc.W  359, 350, 340, 331, 321, 312, 303, 294, 284, 275, 266
dc.W  257, 248, 239, 230, 222, 213, 204, 196, 188, 180, 171
dc.W  163, 156, 148, 140, 133, 126, 119, 112, 105, 99, 92
dc.W  86, 80, 74, 69, 63, 58, 53, 48, 44, 39, 35, 31, 27
dc.W  24, 21, 18, 15, 12, 10, 8, 6, 4, 3, 2, 1, 0, 0
dc.w	-1


contents:
musica:	dc.w	0	;+1
welcome:dc.w	1	;+1
help:	dc.w	2	;+1
credits:dc.w	3	;+1
advert:	dc.w	7	;+1
texts:	dc.w	7	;+3
greets:	dc.w	8	;+3
exit:	dc.w	11


;------------------------------------------------------------------------
;							  "         '
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789!?-:|.,()*#/=+�><"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
;music
dc.b	"          musica            "	; 0
dc.b	"   name               length"	; 1
dc.b	"f1*hard 2 chooz       17252b"	; 2
dc.b	"f2 jello coat         10746b"	; 3
dc.b	"f3 pass the plugs     11812b"	; 4
dc.b	"f4 chipmaniax         11812b"	; 5
dc.b	"f5 black heart        20700b"	; 6
dc.b	"f6 heavenz tearz      12686b"	; 7
dc.b	"f7 my voice           13834b"	; 8
dc.b	"f8 pink noise         12756b"	; 9
dc.b	"f9 the dark xperience 21416b"	;10
dc.b	"f0 acidity            11698b"	;11

;welcome
dc.b	"****************************"	; 0
dc.b	"*                          *"	; 1
dc.b	"*        welcome to        *"	; 2
dc.b	"*                          *"	; 3
dc.b	"*  diznee land issue one   *"	; 4
dc.b	"*                          *"	; 5
dc.b	"*         may 1994         *"	; 6
dc.b	"*                          *"	; 7
dc.b	"*                          *"	; 8
dc.b	"*    press help 4 help     *"	; 9
dc.b	"*                          *"	;10
dc.b	"****************************"	;11

;help
dc.b	"     diznee land manual     "
dc.b	"                            "
dc.b	"     f1-f10 to select tunes "
dc.b	"     m...music menu         "
dc.b	"     a...advertisments      "
dc.b	"     g...greetings          "
dc.b	"     c...credits            "
dc.b	"    esc..oh no, dont do it! "
dc.b	"                            "
dc.b	"   csr left....page down    "
dc.b	"   csr right...page up      "
dc.b	"                            "

;credits
dc.b	"        the credits         "	; 0
dc.b	"                            "	; 1
dc.b	" music, grafix, and design  "	; 2
dc.b	"             by             "	; 3
dc.b	"         mem�o ree          "	; 6
dc.b	"                            "	; 4
dc.b	" code and additional design "	; 5
dc.b	"             by             "	;11
dc.b	"            moon            "	; 7
dc.b	"                            "	; 8
dc.b	"                            "	; 8
dc.b	"                          ->"	; 8

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
dc.b	"      sanitarium  bbs       "	; 9
dc.b	"      +49-8165-elite        "	; 7
dc.b	"         3 nodes            "	;10
dc.b	"----------------------------"	; 7
;dc.b	"                            "	;11


;adverts
dc.b	"                            "	; 0
dc.b	"its the first issue, man,   "	; 1
dc.b	"therefore no advs diz time! "	; 2
dc.b	"                            "	; 3
dc.b	"send your adverts to        "	; 4
dc.b	"mem�o ree, toxic or moon    "	; 5
dc.b	"size: 28*12                 "	; 6
dc.b	"                            "	; 7
dc.b	"dont forget to vote for     "	; 8
dc.b	"the swap�n�dance charts     "	; 9
dc.b	"send to skindiver or duke   "	;10
dc.b	"                            "	;11


;texts

;greets
dc.b	"       the greetings:       "
dc.b	"                            "
dc.b	"absolute      delirium      "
dc.b	"addonic       destiny       "
dc.b	"andromeda     dreamdealers  "
dc.b	"anthrox       essence       "
dc.b	"arise         equinox       "
dc.b	"balance       fairlight     "
dc.b	"complex       faith         "
dc.b	"crystal       god           "
dc.b	"dcs           hodlum        "
dc.b	"decnite       interactive ->"

dc.b	"iris          progress      "
dc.b	"kefrens       pyrodex       "
dc.b	"logic         quick design  "
dc.b	"loons         rage          "
dc.b	"lsd           ram jam       "
dc.b	"mad elks      romkids       "
dc.b	"manitou       s!p           "
dc.b	"mirage        sanity        "
dc.b	"mystic        scontrax      "
dc.b	"nuance        scoopex       "
dc.b	"paradox       silents       "
dc.b	"peace         skid row    ->"

dc.b	"                            "
dc.b	"                            "
dc.b	"       spaceballs           "
dc.b	"       status ok            "
dc.b	"       teklords             "
dc.b	"       trance               "
dc.b	"       trsi                 "
dc.b	"       virtual dreams       "
dc.b	"       zenith               "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "

textend:	dcb.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=4*11
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
	lea	font,a1
	lea	text(pc),a2
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
	move.b	(a3)+,0*40(a0)
	move.b	(a3)+,1*40(a0)
	move.b	(a3)+,2*40(a0)
	move.b	(a3)+,3*40(a0)

;	lea	40(a0),a0
;	dbf	d4,writepagel4



	lea	40*5(a0),a0
	dbf	d7,drawpagel1

	lea	-40*11*5+1(a0),a0
	dbf	d6,drawpagel2
	lea	-28+40*12*5(a0),a0
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
;	lea	drugcol4,a0
;	moveq	#fadequant1,d7	;number of colours
;	jsr	fader_makegrey

fadequant1=32	;number of colours in this calculation

	lea	black,a0	;source-colourstable
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

depp:	dc.l	0

fader_maxnum=32*1;;	maximal number of colours in program!!

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
pattern1:	incbin	"data/fieldsmasc.raw"
lastpattern:

samples:
planes5:
abyss:		incbin	"data/abyss.blt"
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
incbin	"data/modules/SMP.hard 2 chooz"
mod_smpl2:
incbin	"data/modules/SMP.jello coat #4"
mod_smpl3:
incbin	"data/modules/SMP.pass the plugs"
mod_smpl4:
incbin	"data/modules/SMP.n@w!!.chipmaniax"
mod_smpl5:
incbin	"data/modules/SMP.black#heart!"
mod_smpl6:
incbin	"data/modules/SMP.heavenz tearz.."
mod_smpl7:
incbin	"data/modules/SMP.my voice .."
mod_smpl8:
incbin	"data/modules/SMP.pink noise...2"
mod_smpl9:
incbin	"data/modules/SMP.the dark xperience"
mod_smpl10:
incbin	"data/modules/SMP.!!acidity"


playercode:	incbin	"data/player60.code"
playercodeend:




player:	incbin	"data/player60.code"
P60_init=player+40
P60_music=player+738
P60_end=player+626
P60_master=player+16


;------------------------------------------------------------------------
section	data,data_p
mod_data1:
	incbin	"data/modules/P60.hard 2 chooz"
mod_data2:
	incbin	"data/modules/P60.jello coat #4"
mod_data3:
	incbin	"data/modules/P60.pass the plugs"
mod_data4:
	incbin	"data/modules/P60.n@w!!.chipmaniax"
mod_data5:
	incbin	"data/modules/P60.black#heart!"
mod_data6:
	incbin	"data/modules/P60.heavenz tearz.."
mod_data7:
	incbin	"data/modules/P60.my voice .."
mod_data8:
	incbin	"data/modules/P60.pink noise...2"
mod_data9:
	incbin	"data/modules/P60.the dark xperience"
mod_data10:
	incbin	"data/modules/P60.!!acidity"

font:	incbin	"data/font.blt"

firstmasc:
masc1:	incbin	"data/spiral.masc"
masc2:	incbin	"data/ball1.masc"
masc3:	incbin	"data/snake.masc"
masc4:	incbin	"data/chess.masc"
masc5:	incbin	"data/ball2.masc"
masc6:	incbin	"data/lines1.masc"
masc7:	incbin	"data/lines2.masc"
masc8:	incbin	"data/random.masc"
masc9:	incbin	"data/grow.masc"
lastmasc:

;------------------------------------------------------------------------
section	memory,bss_p

animstart:
		ds.b	40*101*4*17
animend:

;------------------------------------------------------------------------
section	chipmemory,bss_c
planeborder:	ds.b	4*40*64
planeadr:	ds.b	4*planesize


