;------------------------------------------------------------------------
;|                                                                      |
;|                              DIZNEE LAND                             |
;|                             -------------                            |
;|                                                                      |
;|                                Issue 3                               |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                       August 1994 |
;------------------------------------------------------------------------
usesection=1
showtime=0	;shows rastertime
textcheck=0	;flashes red when illegal char in text
firebrake=0	;fast brake, exit without fading

;incdir	"ram:"
incdir	""

mainplanesize=40*256	;40*256*7r
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
intena=$09a
openlibrary=-30-522
FindTask=-294
GetMsg=-372
ReplyMsg=-378
WaitPort=-384
joy0dat=$00a
vposr=$004
loadview=-222
waittof=-270
actiview=34
LVO_Supervisor=-30

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
;this startup is splitted and faked in a short time to...
;  ...run with the stupid >WBVerlauf< (a very senseless tool)
;  ...run CORRECT from workbench for all CLI-shy people
;  ...run with crazy multisync resolution for guys thinking they're
;     tooo coool for standard res. or to boot dizzyland from floppydisc.
;  ...run correct when dizzyland is started just when playing a
;     module with 4example delitracker- for people having big problems
;     to decide if they want to listen to deli or dizzy.
;  ...run (i hope) with execvectors in fastmem (vbr) -->not tested!!

;so dont think this is my version of an organises startup, it really isnt


;--------------------------------------------------------
start:							;
;move.l	#160000,d0	;if you start from assembler, the last key you
;sleep:			;press is RETURN. The system has too less time
;sub.l	#1,d0		;to handle this key correctly, so the key will
;bne	sleep		;also be recognizes from dizney.
			;use this loop ONLY when starting from assembler
			;to wait till the system has sent the handshake
			;to the CIA.
	;please don't tell me that this loop doesn't run same
	;time on different CPU's...

Checkcpu:
	move.l	4.w,a6
	move.w	296(a6),d0
	btst	#0,d0
	beq	mc68000

	lea	getvbr(pc),a5
	jsr	LVO_Supervisor(a6)
	bra	mc68000

getvbr:
	move.l	d0,-(a7)
	dc.l	$4e7a0801	;movec	vbr,d0
	move.l	d0,Vectorbase
	move.l	(a7)+,d0
	rte

mc68000:
	move.l	4.w,a6
	lea	gfxname(pc),a1
	moveq	#0,d0
	jsr	openlibrary(a6)
	move.l	d0,gfxbase
	move.l	d0,a6
	move.l	actiview(a6),oldview
	sub.l	a1,a1
	jsr	loadview(a6)	;standard screen
	jsr	waittof(a6)	;wait top of frame
	jsr	waittof(a6)

;bra	startcli
	;when starting from ASMOne, FINDTASK or WAITPORT doesn't come back

	move.l	4.w,a6
	sub.l	a1,a1
 	jsr	findtask(a6)
	move.l	d0,a4
	tst.l	$ac(a4)
	bne	startcli

	lea	$5c(a4),a0
	jsr	waitport(a6)
	lea	$5c(a4),a0
	jsr	getmsg(a6)
	move.l	d0,sys_message
startcli:
	move.l	4.w,a6					;
	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001101000,intena(a5)		;
	move.l	vectorbase(pc),a0
	move.l	$6c(a0),oldint				;
	move.l	$78(a0),oldexi
	move.l	#main_vbi,$6c(a0)
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%0000001000000000,bplcon0(a5)		;
	move.w	#%1100000000100000,intena(a5)		;


;	bclr.b	#13,$106(a5)
;	bclr.b	#14,$106(a5)
;	bclr.b	#15,$106(a5)

;	bclr.b	#00,$106(a5)
;	bclr.b	#01,$106(a5)
;	bclr.b	#02,$106(a5)
;	bclr.b	#03,$106(a5)
;	bclr.b	#04,$106(a5)
;	bclr.b	#05,$106(a5)
;	bclr.b	#06,$106(a5)
;	bclr.b	#07,$106(a5)
;	bclr.b	#08,$106(a5)
;	bclr.b	#09,$106(a5)
;	bclr.b	#10,$106(a5)
;	bclr.b	#11,$106(a5)
;	bclr.b	#12,$106(a5)

	move.w	#0,$106(a5)


	move.w	#%1000001111000000,dmacon(a5)		;
 	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	bsr	main_init				;
	bsr	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq	back					;
ifne	firebrake
	btst.b	#7,ciaapra				;
	beq	back					;
endif
;	tst.w	f_endprogram				;
;	beq	wait					;
	lea	main_talk,a0				;
	move.l	(a0),a0					;
	tst.w	(a0)					;
	beq	wait					;
back:							;
	move.l	vectorbase(pc),a0
	move.l	oldint,$6c(a0)				;
	move.l	4.w,a6					;
;	lea	gfxname(pc),a1				;
;	moveq	#0,d0					;
;	jsr	openlibrary(a6)				;
;	move.l	d0,a0					;
	move.l	gfxbase(pc),a0
	lea	$dff000,a5				;
	move.l	38(a0),cop1lch(a5)			;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000001000,intena(a5)		;
	move.w	#%1000001111100000,dmacon(a5)		;
	move.l	vectorbase(pc),a0
	move.l	oldexi,$78(a0)

	move.l	gfxbase(pc),a6
	move.l	oldview(pc),a1
	jsr	loadview(a6)

	move.l	4.w,a6					;
	jsr	permit(a6)				;
	move.l	sys_message(pc),d0
	beq	noreply
	move.l	d0,a1
	jsr	replymsg(a6)
noreply:
	moveq	#0,d0					;
	rts						;
;--------------------------------------------------------
dc.b	"$VER:Diznee Land Issue 3",0;i know, the cruncher destroys this..
even
;--------------------------------------------------------
main_vbiuser:		dc.l	0			;
fakemain_vbiuser:	dc.l	0			;
main_copperlist:	dc.l	0			;
fakemain_copperlist:	dc.l	main_emptycopperlist	;
main_talk:		dc.l	0			;
fakemain_talk:		dc.l	0			;
oldint:			dc.l	0			;
oldexi:			dc.l	0
main_emptycopperlist:	dc.l	-2			;
intflag:		dc.w	0			;
f_endprogram:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
gfxbase:		dc.l	0
sys_message:		dc.l	0
oldview:		dc.l	0
vectorbase:		dc.l	0
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

ifne	showtime						;
	move.w	#$0fff,$dff180					;
endif								;
	waitblit
	movem.l	(a7)+,d0-a6					;
ifne	showtime						;
	move.w	#$0f57,$dff180					;
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
;		dc.l	50,	nothing
		dc.l	200,	setint_title
		dc.l	50,	setint_fadetitleout
		dc.l	40,	setint_pinkfade
		dc.l	90,	setint_come1
		dc.l	70,	setint_come2
		dc.l	36,	setint_come3
		dc.l	4,	setint_text
		dc.l	1,	setint_textpage0
		dc.l	40,	setint_getout

		dc.l	100,	setint_abyssprod
		dc.l	40,	fadeabyssprodout
		dc.l	60000,	setente
;---------------------------------------------
nothing:	rts

setint_title:
	move.l	#$298129c1,diwstrt(a5)
	move.l	#$003800d0,ddfstrt(a5)
	move.l	#$00000000,bplcon1(a5)
	move.w	#160+200,bpl1mod(a5)
	move.w	#160+200,bpl2mod(a5)
	move.w	#%0101001000000100,bplcon0(a5)
	btst.b	#7,vposr(a5)
	bne.b	sf_badframe

	move.l	main_vbiuser(pc),a0
	lea	int_fadetitlein(pc),a1
	move.l	a1,(a0)
	move.l	main_copperlist(pc),a0
	move.l	#copperlist1,(a0)

	move.l	#fader_table3,fader_pos
	move.w	#fadequant1*2,fader_direct
	move.w	#1,fader_slpcount
	move.w	#1,fader_sleep
	bsr	fader_real
	rts
sf_badframe:
	subq.w	#8,compoint
	move.w	#1,comsleep
	move.w	#%0000001000000100,bplcon0(a5)
	rts

setint_fadetitleout:
	move.l	main_vbiuser(pc),a0
	lea	int_fadetitleout,a1
	move.l	a1,(a0)
	rts

setint_pinkfade:
	move.l	main_vbiuser(pc),a0
	lea	int_pinkfade(pc),a1
	move.l	a1,(a0)
	move.l	main_copperlist(pc),a0
	lea	pinklist(pc),a1
	move.l	a1,(a0)

	bsr	makepinklist
	move.w	#%0000000000000100,bplcon0(a5)	;interlace off
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
	move.l	main_vbiuser(pc),a0
	lea	main_intcome1(pc),a1
	move.l	a1,(a0)
	move.l	main_copperlist(pc),a0
	lea	Copscreen_come1(pc),a1
	move.l	a1,(a0)

	lea	main_emptycopperlist(pc),a0
	move.l	a0,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	lea	colours(pc),a0
	lea	$180(a5),a1
rept	16
	move.l	(a0)+,(a1)+
endr
	rts

setint_come2:
	move.l	main_vbiuser(pc),a0
	lea	main_intcome2(pc),a1
	move.l	a1,(a0)
	rts

setint_come3:
	move.l	main_vbiuser(pc),a0
	lea	main_intcome3(pc),a1
	move.l	a1,(a0)
	rts

Copscreen_text:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,$0
	dc.w	bpl2mod,$0
	dc.w	bplcon0,%0101001000000000

	dc.l	$01900e46	;colour textfadeeffect
	dc.l	$01920e46
	dc.l	$01940e46
	dc.l	$01b00d35
	dc.l	$01b20d35
	dc.l	$01b40d35

	dc.l	$c40ffffe
	dc.l	$0190000f	;colmark1
	dc.l	$01920fcd
	dc.l	$01940fee
	dc.l	$01b0000e
	dc.l	$01b20ebc
	dc.l	$01b40edd

	dc.l	-2

setint_text:
	lea	maincommand(pc),a0
	lea	Convmenugfx(pc),a1
	move.l	a1,(a0)
	move.l	main_vbiuser(pc),a0
	lea	main_intcome4(pc),a1
	move.l	a1,(a0)
	rts

setint_textpage0:
	move.l	main_vbiuser(pc),a0
	lea	main_inttext(pc),a1
	move.l	a1,(a0)
	move.l	main_copperlist(pc),a0
	move.l	(a1),a1
	lea	Copscreen_text(pc),a1
	move.l	a1,(a0)
	rts

setint_getout:
	move.l	main_vbiuser(pc),a0
	lea	main_intgetout(pc),a1
	move.l	a1,(a0)
	move.w	#2,fader_sleep
	move.w	#-2,P60_fadestep
	rts

CopScreen_Abyssprod:
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

setint_abyssprod:
	move.l	main_vbiuser(pc),a0
	lea	main_intabyssprod(pc),a1
	move.l	a1,(a0)
	move.l	main_copperlist(pc),a0
	lea	copscreen_abyssprod(pc),a1
	move.l	a1,(a0)

	move.w	#fadequant1*2,fader_direct
	move.l	#fader_table1,fader_pos
	move.w	#1,fader_slpcount
	rts

fadeabyssprodout:
	move.w	#fadequant1*2,fader_direct
	move.l	#fader_table2,fader_pos
	rts

setente:
	move.l	main_talk(pc),a0
	move.w	#1,(a0)
	rts
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	lea	playercode,a0
	lea	player,a1
	move.w	#(playerend-player)/4-1,d7
playerback:
	move.l	(a1)+,(a0)+
	dbf	d7,playerback

	move.w	newmodule(pc),d0
	lsl.w	#3,d0
	lea	modules(pc),a1
	add.w	d0,a1
	move.l	(a1)+,a0
	move.l	(a1),a1
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5

	bsr	fadetest
	bsr	coppercopy
	bsr	fadetest2
	bsr	switchplanes

	lea	maincommand(pc),a0
	lea	precalc(pc),a1
	move.l	a1,(a0)
	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
main_back:
;-------------------------
	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
	move.l	main_vbiuser(pc),a0
	lea	main_inttitle(pc),a1
	move.l	a1,(a0)
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

main_loop:
ifne	firebrake
	btst.b	#7,ciaapra
	beq	main_loopexit
endif
	lea	main_talk,a0
	move.l	(a0),a0
	tst.w	(a0)
	bne	main_loopexit

	lea	maincommand(pc),a0
	tst.l	(a0)
	beq	main_loop
	move.w	#1,askkeyskip

	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	move.w	#0,askkeyskip
	bra	main_loop

main_loopexit:
	rts
;----------
;------------------------------------------------------------------------
;-------------
main_inttitle:
	lea	production,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	skip_musictit

	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

	bsr	fader_real
	bsr	commander
skip_musictit:
	rts
;----------
;------------
int_pinkfade:
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

	bsr	makepinklist
	bsr	commander
	move.w	#1,intflag
	rts
;----------
;---------------
Int_fadetitlein:
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

	bsr	fader_real
;	bsr	fader_real
;	bsr	fader_real
	bsr	commander
	move.w	#1,intflag
	rts
;----------
;----------------
Int_fadetitleout:
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5

	cmp.w	#-32,fadout_sleeptest
	beq.b	fadefin
	moveq	#0,d0
	lea	fadout_offsets(pc),a1
	lea	fadout_sleep(pc),a2

	moveq	#15,d6
fadeoutloop2:
	move.l	(a1)+,a0
	add.l	#titlepic,a0
	subq.w	#1,(a2)+
	bpl.b	skipline
	add.l	#200,-4(a1)
	
	moveq	#49,d7
fadeoutloop1:
	move.l	d0,(a0)+
	dbf	d7,fadeoutloop1
skipline:
	dbf	d6,fadeoutloop2
fadefin:
	bsr	commander
	move.w	#1,intflag
	rts

fadout_offsets:
value:	set	00
rept	16
	dc.l	value*32*200
value:	set	value+1
endr

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
;-----------------
;-----------------
main_intabyssprod:
	lea	production,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	tst.w	skipmusic
	bne	skip_musicaby
;-------------------------
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
;-------------------------
	bsr	fader_real
	bsr	commander
skip_musicaby:
	rts
;----------
;-------------
main_intcome1:
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)

	tst.w	skipmusic
	bne	skip_music
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
skip_music:

	bsr	putpic
	move.w	#1,intflag
	bsr	commander
	rts
;----------
;-------------
main_intcome2:
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
	move.w	#1,intflag
	jsr	commander
	rts
;----------
;-------------
main_intcome3:
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

	bsr	drawissue
	move.w	#1,intflag
	jsr	commander
	rts
;----------
;-------------
main_intcome4:
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
;--------------
main_intgetout:
	lea	mainplanes,a0
	move.l	a0,bpl1pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl4pth(a5)
	move.l	showplane(pc),a0
	move.l	a0,bpl5pth(a5)

	tst.w	skipmusic
	bne	intgetout_skipmusic
	bsr	P60_fader
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
intgetout_skipmusic:

	bsr	curtain
	move.w	#1,intflag
	bsr	commander
	rts
;----------
;------------
main_inttext:
	lea	mainplanes,a0
	move.l	a0,bpl1pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	mainplanesize(a0),a0
	move.l	a0,bpl4pth(a5)

	move.l	showplane,a0
	move.l	a0,bpl5pth(a5)

	tst.w	skipmusic
	bne	main_inttext_skipmusic
	bsr	P60_fader
	lea	$dff000,a6
	jsr	P60_Music
	lea	$dff000,a5
main_inttext_skipmusic:

	bsr	fadetext
	jsr	fill
	bsr	askkey
	bsr	askmouse
	jsr	planeclscpu
	jsr	spiral
	jsr	switchplanes
	waitblit

	move.w	#1,intflag
	lea	comsleep(pc),a0
	addq.w	#1,(a0)
	bsr	commander
	rts
;----------
;------------------------------------------------------------------------
;-------
precalc:	;blitter not used
	bsr	planecls1
	bsr	calcanim
	bsr	textcalc
	rts
;----------
;----------
coppercopy:
	lea	copperlist1,a0
	move.l	#titlepic,d0
	move.l	#copperlist2,d1
	bsr.b	putlist

	lea	copperlist2,a0
	move.l	#titlepic+200,d0
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
;----------
;------------
P60_fadestep:	dc.w	0
P60_fader:
	lea	P60_fadestep(pc),a0
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
;----------
;--------
fadebobs:
rept	50
	dc.l	-1	;pos
	dc.w	0	;animpoint
endr

fadetextskip:		dc.w	1
fadetextnewbobs:	dc.w	1
fieldspoint:		dc.w	0
fieldterms:		dc.w	0


actmasc:	dc.l	masc1
actpattern:	dc.l	pattern1

fadetext:
	tst.w	fadetextskip
	bne	fadetext_skip
	move.w	#2,fadetextnewbobs

	lea	mainplanes+12+11*40+mainplanesize*3,a0
	move.l	actpattern(pc),a1
	lea	fadebobs(pc),a2

	moveq	#0,d6	;flag, if any bob will be drawed this frame,...
			;...this flag turns to -1.l
	moveq	#29,d7	;maximal number of bobs, =size of boblist
fadetextl1:
	move.l	(a2),d0			;pos
	bmi	fadetext_skipbob	;bob not active
	move.w	4(a2),d1		;animpoint
	cmp.w	#15*2*24,d1		;last animpic?
	bne	fadetext_notlastanimpic	;no signore
	move.l	#-1,(a2)		;yes-switch bob off

fadetext_notlastanimpic:
	add.w	#2*24,4(a2)		;next animpic for next frame
;	mulu	#2*24,d1		;animpicnumber to animpicoffset

	lea	(a0,d0.l),a3		;plane position
	lea	(a1,d1.w),a4		;bob data position

	moveq	#-1,d6	;set bobflag (also used 2 set afwm/alwm
	moveq	#0,d0
	moveq	#1*40-2,d1
	waitblit			;blit the bob...
	move.l	a4,bltapth(a5)
	move.l	a3,bltbpth(a5)
	move.l	a3,bltdpth(a5)
	move.w	d0,bltamod(a5)
	move.w	d1,bltbmod(a5)
	move.w	d1,bltdmod(a5)
	move.w	d0,bltcon1(a5)
	move.w	fieldterms(pc),bltcon0(a5)
	move.l	d6,bltafwm(a5)
	move.w	#1+12*2*64,bltsize(a5)
	bra	fadetext_skipinsert

fadetext_skipbob:
	tst.w	fadetextnewbobs		;counter how many bobs to add...
	beq	fadetext_skipinsert	;...this frame
	subq.w	#1,fadetextnewbobs
	move.l	actmasc(pc),a3
	moveq	#0,d0
	moveq	#0,d1
	move.w	fieldspoint(pc),d0	;point in actual masctable
	cmp.w	#168,d0			;no more bobs to draw?-->back
	beq	fadetext_skipinsert
	addq.w	#2,fieldspoint		;increase masctablepoint
	move.w	(a3,d0.w),d0		;get code of bobposition

;	divu	#14,d0			;14 words/line
;	swap	d0
;	move.w	d0,d1
;	move.w	#0,d0
;	swap	d0
;	mulu.w	#24*40,d0
;	add.w	d1,d1
;	add.l	d1,d0

	divu	#14,d0			;14 words/line
	move.w	d0,d1
	mulu.w	#24*40,d1
	swap	d0
	add.w	d0,d1
	add.w	d0,d1


	move.l	d1,(a2)			;screenposition
	move.w	#0,4(a2)		;animpoint=start

fadetext_skipinsert:
	addq.w	#6,a2			;next position in bob-table
	dbf	d7,fadetextl1		;next bobby

	tst.w	d6			;any bob drawed this frame
	bne	fadetext_skip		;yes-->back to the roots
	move.w	fieldspoint(pc),d0	;all fields drawed?
	cmp.w	#168,d0			;no-->back 2 the roots
	bne	fadetext_skip
	move.w	#1,fadetextskip		;switch fadetext off
	move.w	#0,fieldspoint		;reset fieldcounter
fadetext_skip:
	rts
;----------
;----------
curtainpoint:	dc.w	0
curtain:
	lea	mainplanes+3*mainplanesize,a0
	lea	39+16*40(a0),a1
	move.w	curtainpoint(pc),d0
	addq.w	#1,curtainpoint
	add.w	d0,a0
	sub.w	d0,a1

	moveq	#7,d6
curtainl2:
	moveq	#15,d7		;16 lines/bar
curtainl1:
	move.b	#0,(0-3)*mainplanesize(a0)
	move.b	#0,(1-3)*mainplanesize(a0)
	move.b	#0,(2-3)*mainplanesize(a0)
	move.b	#0,(3-3)*mainplanesize(a0)
	move.b	#0,(4-3)*mainplanesize(a0)
	move.b	#0,(5-3)*mainplanesize(a0)
	move.b	#0,(6-3)*mainplanesize(a0)

	move.b	#0,(0-3)*mainplanesize(a1)
	move.b	#0,(1-3)*mainplanesize(a1)
	move.b	#0,(2-3)*mainplanesize(a1)
	move.b	#0,(3-3)*mainplanesize(a1)
	move.b	#0,(4-3)*mainplanesize(a1)
	move.b	#0,(5-3)*mainplanesize(a1)
	move.b	#0,(6-3)*mainplanesize(a1)
	lea	40(a0),a0
	lea	40(a1),a1
	dbf	d7,curtainl1
	lea	16*40(a0),a0
	lea	16*40(a1),a1
	dbf	d6,curtainl2
	rts
;----------
;---------
animpoint:	dc.w	0
putpic:
	move.w	animpoint(pc),d4
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

linepos:	set	0
rept 404
	move.w (a2)+,linepos(a3)
linepos:	set	linepos+64
endr

	addq.w	#8,d4
	cmp.w	#animwaveend-animwave,d4
	blt	putpicl2
	sub.w	#animwaveend-animwave,d4
putpicl2:
	move.l	(a4,d4.w),a0

	add.w	#101*4*2,d5
	add.w	d5,a0

	addq.l	#2,a1
	dbf	d6,putpicloopx
	rts
;----------
;--------
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
;----------
;-----------
Convmenugfx:
	lea	planeadr,a0	;64*256*4b, coming-planes
	lea	mainplanes,a1	;memory not clear

	moveq	#3,d7		;4 planes from source
Convmenugfxl1:
	move.w	#255,d6		;256 lines
Convmenugfxl2:
	moveq	#9,d5		;40 bytes/line for destination
Convmenugfxl3:
	move.l	(a0)+,(a1)+
	dbf	d5,Convmenugfxl3
	add.w	#64-40+64*3,a0	;skip source offset and other planes
	dbf	d6,Convmenugfxl2
	sub.l	#64*256*4-64,a0
	dbf	d7,Convmenugfxl1

	move.w	#(40*256*3/4)-1,d7	;3 planes for effect to clear
	moveq	#0,d6
Convmenugfxl4:
	move.l	d6,(a1)+
	dbf	d7,Convmenugfxl4

	move.w	welcome,actpage
	move.w	#2,section
	lea	writepagenofade(pc),a0
	move.l	a0,maincommand
	rts
;----------
;-------
sinusxpos:	dc.w	0
drawmenu:
	lea	sinusx(pc),a2
	move.w	sinusxpos(pc),d0
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
	moveq	#35,d1

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
	rts
;----------
;------
issuex:	dc.w	4*512-39
issuey:	dc.w	0
drawissue:
	lea	issuex(pc),a0
	move.w	(a0),d0
	addq.w	#1,(a0)+
	move.w	(a0),d1
	addq.w	#1,(a0)

	lea	issue,a0
	lea	planeborder,a1

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
	move.l	a1,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#64-14,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	d3,bltcon0(a5)
	move.w	#0,bltcon1(a5)

	move.w	#64*4*(40-4)+7,bltsize(a5)
	rts
;----------
;---
key:		dc.w	0
askkeyskip:	dc.w	0
askkey:
	tst.w	askkeyskip
	bne	askkey_skip

	move.b	$bfed01,d0		;irq-interrupt-control
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

	move.b	key(pc),d0

	cmp.b	#$d0,d0
	blt	nofkey
	cmp.b	#$d9,d0
	bgt	nofkey

	sub.w	#$d0,d0
	move.w	newmodule(pc),lastmodule
	move.w	d0,newmodule
	lsl.w	#3,d0
	lea	modules(pc),a0
	add.w	d0,a0
	move.l	(a0)+,newmod_data
	move.l	(a0)+,newmod_smpl

	lea	maincommand(pc),a0
	lea	changemusic(pc),a1
	move.l	a1,(a0)

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

	cmp.b	#$cf,d0		;left
	beq	key_left

	cmp.b	#$ce,d0		;right
	beq	key_right

	cmp.b	#$cd,d0		;down
	beq	key_down

	cmp.b	#$cc,d0		;up
	beq	key_up

	cmp.b	#$c4,d0		;return
	beq	key_return

	cmp.b	#$df,d0		;HELP
	beq	key_help
	rts

key_exit:
	lea	maincommand(pc),a0
	lea	doescape(pc),a1
	move.l	a1,(a0)
	rts

doescape:
	lea	comsleep(pc),a0
	subq.w	#1,(a0)
	rts

key_musica:
	move.w	musica(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#0,section

	bsr	clrcurs
	move.w	#0,ballcurs
	bsr	setcurs
	rts

key_help:
	tst.w	menulevel
	bne	key_helplevel2
	move.w	help(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#4,section
	bra	key_helpback
key_helplevel2:
	bsr	key_right
	bra	key_help
key_helpback:
	rts

key_credits:
	tst.w	menulevel
	bne	key_creditslevel2
	move.w	credits(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#6,section
	bsr	clrcurs
	move.w	#2,ballcurs
	bsr	setcurs
	bra	key_creditsback
key_creditslevel2:
	bsr	key_right
	bra	key_credits
key_creditsback:
	rts

key_adverts:
	tst.w	menulevel
	bne	key_advertslevel2
	move.w	advert(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#8,section
	bsr	clrcurs
	move.w	#1,ballcurs
	bsr	setcurs
	bra	key_advertsback
key_advertslevel2:
	bsr	key_right
	bra	key_adverts
key_advertsback:
	rts

key_text:
	tst.w	menulevel
	bne	key_textlevel2
	move.w	texts(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#10,section
	bsr	clrcurs
	move.w	#4,ballcurs
	bsr	setcurs
	bra	key_textback
key_textlevel2:
	bsr	key_right
	bra	key_text
key_textback:
	rts

key_greets:
	tst.w	menulevel
	bne	key_greetslevel2
	move.w	greets(pc),actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
	move.w	#12,section
	bsr	clrcurs
	move.w	#3,ballcurs
	bsr	setcurs
	bra	key_greetsback
key_greetslevel2:
	bsr	key_right
	bra	key_greets
key_greetsback:
	rts


key_left:
	lea	contents(pc),a0
	move.w	section(pc),d0
	add.w	d0,a0
	move.w	actpage(pc),d0
	cmp.w	(a0),d0
	beq	key_leftback
	subq.w	#1,d0
	move.w	d0,actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand
key_leftback:
	rts

key_right:
	tst.w	actpage
	bne	nomusicmenu
;when showing music menu, right mouse doesn't switch to next page, but
;switches musicselector on/off
	moveq	#1,d0
	sub.w	menulevel(pc),d0
	move.w	d0,menulevel
	tst.w	d0
	bne	switched2level1
	bsr	setcurs
	bsr	clrcurs2
	bra	key_rightback

switched2level1:
	bsr	clrcurs
	bsr	setcurs2

	bra	key_rightback

nomusicmenu:
	lea	contents(pc),a0
	move.w	section(pc),d0
	add.w	d0,a0
	move.w	actpage(pc),d0
	addq.w	#1,d0
	cmp.w	2(a0),d0
	beq	key_rightback
	move.w	d0,actpage
	lea	writepage(pc),a0
	move.l	a0,maincommand

key_rightback:
	rts

key_down:
	tst.w	menulevel
	bne	key_downlevel2

	cmp.w	#4,ballcurs
	beq	key_downback
	bsr	clrcurs
	addq.w	#1,ballcurs
	bsr	setcurs
	bra	key_downback
key_downlevel2:
	cmp.w	#9,ballcurs2
	beq	key_downback
	bsr	clrcurs2
	addq.w	#1,ballcurs2
	bsr	setcurs2

key_downback:
	rts

key_up:
	tst.w	menulevel
	bne	key_uplevel2

	tst.w	ballcurs
	beq	key_upback
	bsr	clrcurs
	subq.w	#1,ballcurs
	bsr	setcurs
	bra	key_upback
key_uplevel2:
	tst.w	ballcurs2
	beq	key_upback
	bsr	clrcurs2
	subq.w	#1,ballcurs2
	bsr	setcurs2

key_upback:
	rts

key_return:
	tst.w	menulevel
	bne	key_returnlevel2

	move.w	ballcurs(pc),d0
 	beq	key_musica
	cmp.w	#1,d0
	beq	key_adverts
	cmp.w	#2,d0
	beq	key_credits
	cmp.w	#3,d0
	beq	key_greets
	cmp.w	#4,d0
	beq	key_text
	bra	key_returnback
key_returnlevel2:
	move.w	newmodule(pc),lastmodule
	move.w	ballcurs2(pc),d0
	move.w	d0,newmodule
	lsl.w	#3,d0
	lea	modules(pc),a0
	add.w	d0,a0
	move.l	(a0)+,newmod_data
	move.l	(a0)+,newmod_smpl

	lea	maincommand(pc),a0
	lea	changemusic(pc),a1
	move.l	a1,(a0)
	move.w	#$3f4,saveballcurs2	;code for * , (fontoffset for *)

key_returnback:
	rts
;----------
;--------
mousemem:	dc.w	0
ballcurs:	dc.w	0
ballcurs2:	dc.w	0
saveballcurs2:	dc.w	0	;save char under ballcurs2
menulevel:	dc.w	0
f_buttonskip:	dc.w	0
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
	move.b	d1,(a0)		;mousemem
	cmp.b	#$20,d0
	bge.w	notmoved	;(overflow)
	tst.b	d3
	beq.b	mouse_up

;mouse_down
	bsr	key_down
	bra	notmoved
mouse_up:
	bsr	key_up
notmoved:
	btst.b	#6,ciaapra
	beq	mouse_leftbut
	btst.b	#10,$dff016
	beq	mouse_rightbut
	move.w	#0,f_buttonskip
	rts

mouse_leftbut:
	btst.b	#10,$dff016;both buttons allowed when buttons disabled
	beq	mouse_bothbut

	tst.w	f_buttonskip
	bne	askmouse_skip

	move.w	#1,f_buttonskip

	bsr	key_return
askmouse_skip:
	rts

mouse_rightbut:
	tst.w	f_buttonskip
	bne	askmouse_skip
	move.w	#2,f_buttonskip
	bra	key_right
	rts

mouse_bothbut:
	move.w	#3,f_buttonskip
	bra	key_exit
;-----------------------
;-------
setcurs:
	lea	ballon,a0
	lea	mainplanes+0+50*40,a1
	move.w	ballcurs(pc),d0
	mulu.w	#40*21,d0
	add.w	d0,a1
	moveq	#21-1,d7
setcursloop:
	move.l	(a0)+,0*mainplanesize(a1)
	move.l	(a0)+,1*mainplanesize(a1)
	move.l	(a0)+,2*mainplanesize(a1)
	move.l	(a0)+,3*mainplanesize(a1)
	lea	40(a1),a1
	dbf	d7,setcursloop
	rts
;----------
;-------
clrcurs:
	lea	balloff,a0
	lea	mainplanes+0+50*40,a1
	move.w	ballcurs(pc),d0
	mulu.w	#40*21,d0
	add.w	d0,a1
	moveq	#21-1,d7
clrcursloop:
	move.l	(a0)+,0*mainplanesize(a1)
	move.l	(a0)+,1*mainplanesize(a1)
	move.l	(a0)+,2*mainplanesize(a1)
	move.l	(a0)+,3*mainplanesize(a1)
	lea	40(a1),a1
	dbf	d7,clrcursloop
	rts
;----------
;--------
setcurs2:
	lea	text+28*2*2+2*2,a0
	move.w	ballcurs2(pc),d0
	mulu.w	#28*2,d0
	move.w	(a0,d0.w),saveballcurs2
	move.w	#55*22,(a0,d0.w)
;	move.w	#46*22,(a0,d0.w)
	lea	maincommand(pc),a0
	lea	drawpage2(pc),a1
	move.l	a1,(a0)
	rts
;----------
;--------
clrcurs2:
	lea	text+28*2*2+2*2,a0
	move.w	ballcurs2(pc),d0
	mulu.w	#28*2,d0
	move.w	saveballcurs2(pc),(a0,d0.w)
	lea	maincommand(pc),a0
	lea	drawpage2(pc),a1
	move.l	a1,(a0)
	rts
;----------
;----------
waitawhile:
	moveq	#3,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
	cmp.b	$dff007,d6
	beq	waitawhileloop2
	dbf	d7,waitawhileloop1
	rts
;----------
;-----------
changemusic:
	move.w	#-1,P60_fadestep

	lea	text+28*2*2+2*2,a0
	move.w	lastmodule(pc),d0
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
	move.w	#(playerend-player)/4-1,d7
playercopy:
	move.l	(a0)+,(a1)+
	dbf	d7,playercopy

	move.w	newmodule(pc),d0
	lsl.w	#3,d0
	lea	modules(pc),a1
	add.w	d0,a1
	move.l	(a1)+,a0
	move.l	(a1),a1
	move.w	#64,p60_master

	move.l	newmod_data(pc),a0
	move.l	newmod_smpl(pc),a1
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5

	move.w	#0,skipmusic

	lea	text+28*2*2+2*2,a0
	move.w	newmodule(pc),d0
	mulu.w	#28*2,d0	;position of the *-mark
	move.w	#$3f4,(a0,d0.w)	;code for * , (fontoffset for *)

	tst.w	actpage
	bne	noactpage2
	bsr	writepagenofade
	noactpage2:
	rts
;----------
;------------
charsize=2*11
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
ifne	textcheck
	move.b	d0,badchar
	move.w	#30000,d1
textcheck_flash:
	move.w	#$0f00,$180(a5)
	move.w	#$0000,$180(a5)
	dbf	d1,textcheck_flash
	bra	textcalcl3
badchar:	dc.b	0,0
endif
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------
;---------
writepage:
	bsr	nextmascpatt
	bsr	fadepageout
	bsr	drawpage
	bsr	nextmascpatt
	bsr	fadepagein
	rts
;----------
;---------------
writepagenofade:
	bsr	drawpage
	rts
;----------
;------------
nextmascpatt:
	move.l	actmasc(pc),d0
	add.l	#168,d0
	cmp.l	#lastmasc,d0
	bne	nomascrestart
	move.l	#firstmasc,d0
nomascrestart:
	move.l	d0,actmasc

	move.l	actpattern(pc),d0
	add.l	#24*2*16,d0
	cmp.l	#lastpattern,d0
	bne	nopatternrestart
	move.l	#firstpattern,d0
nopatternrestart:
	move.l	d0,actpattern
	rts
;----------
;----------
fadepageout:
	move.w	#%0000100111110000,fieldterms
	move.w	#0,fadetextskip
fadepageout_wait:
	tst.w	fadetextskip
	beq	fadepageout_wait
	rts
;----------
;----------
fadepagein:
	move.w	#%0000100100001111,fieldterms
	move.w	#0,fadetextskip
fadepagein_wait:
	tst.w	fadetextskip
	beq	fadepagein_wait
	rts
;----------
;--------
drawpage:
	lea	mainplanes+12+11*40,a0
	lea	font,a1
	lea	text,a2
	move.w	actpage(pc),d0
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
	move.b	(a3)+,0*mainplanesize(a0)
	move.b	(a3)+,1*mainplanesize(a0)

	lea	40(a0),a0
	dbf	d7,drawpagel1

	lea	-40*11+1(a0),a0
	dbf	d6,drawpagel2
	lea	-28+40*12(a0),a0
	dbf	d5,drawpagel3
	rts
;----------
;--------
drawpage2:
	lea	mainplanes+12+11*40,a0
	lea	font,a1
	lea	text,a2
	move.w	actpage(pc),d0
	mulu	#28*12*2,d0
	add.l	d0,a2	

	addq.w	#2*2,a2
	addq.w	#2,a0
	moveq	#11,d5
drawpage2l3:

	move.w	(a2)+,d0
	lea	(a1,d0.w),a3

	moveq	#11-1,d7
drawpage2l1:
	move.b	(a3)+,0*mainplanesize(a0)
	move.b	(a3)+,1*mainplanesize(a0)

	lea	40(a0),a0
	dbf	d7,drawpage2l1

	lea	-40*11+1(a0),a0
	add.w	#27*2,a2	;chars
	lea	-1+40*12(a0),a0
	dbf	d5,drawpage2l3
	rts
;----------
;----------
maincommand:	dc.l	0
actpage:	dc.w	0
skipmusic:	dc.w	0
newmod_data:	dc.l	0
newmod_smpl:	dc.l	0
newmodule:	dc.w	0
lastmodule:	dc.w	0
section:	dc.w	0
;; 0=musica, 2=welcome, 4=help, 6=credits, 8=adverts, 10=texts,  12=greets

contents:
musica:	dc.w	0	;+1
welcome:dc.w	1	;+1
help:	dc.w	2	;+2
credits:dc.w	4	;+5
advert:	dc.w	9	;+27
texts:	dc.w	36	;+6
greets:	dc.w	42	;+11
	dc.w	53

sinusx:;359/1.5/180/269
dc.W  359, 350, 340, 331, 321, 312, 303, 294, 284, 275, 266
dc.W  257, 248, 239, 230, 222, 213, 204, 196, 188, 180, 171
dc.W  163, 156, 148, 140, 133, 126, 119, 112, 105, 99, 92
dc.W  86, 80, 74, 69, 63, 58, 53, 48, 44, 39, 35, 31, 27
dc.W  24, 21, 18, 15, 12, 10, 8, 6, 4, 3, 2, 1, 0, 0
dc.w	-1

colours:
dc.w $F57,$FFF,$967,$C67,$444,$F9B,$F89,$F68
dc.w $00F,$FCD,$FEE,$A67,$D67,$766,$655,$FBC
;    !!!! !!!! !!!! look at ;colmark1

dc.w $e46,$eeF,$856,$b56,$333,$e8a,$e78,$e57
dc.w $00e,$ebc,$edd,$956,$e56,$655,$544,$eab
;    !!!! !!!! !!!! look at ;colmark1

pink:;source
dc.w $f57,$f57,$f57,$f57,$f57,$f57,$f57,$f57
dc.w $f57,$f57,$f57,$f57,$f57,$f57,$f57,$f57

;--------
fadetest:
fadequant1=32
	lea	pink(pc),a0	;source-colourstable
	lea	colours(pc),a1	;destination-colourtable
	lea	fader_table1,a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr	fader_calc
	lea	fader_table1,a2
	move.w	#-1,16*fadequant1*2(a2)	;set endmark in colourlist

fadequant2=32
	lea	colours(pc),a0	;source-colourstable
	lea	pink(pc),a1	;destination-colourtable
	lea	fader_table2,a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant2,d7	;number of colours
	bsr	fader_calc
	lea	fader_table2,a2
	move.w	#-1,16*fadequant2*2(a2)	;set endmark in colourlist
	rts

fader_maxnum1=32*1
fader_maxnum2=32*1
fader_maxnum3=32*2
fader_colnum:	dc.w	0

dc.w	-1
fader_table1:	dcb.w	fader_maxnum1*16
dc.w	-1

dc.w	-1
fader_table2:	dcb.w	fader_maxnum2*16
dc.w	-1

dc.w	-1
fader_table3:	dcb.w	fader_maxnum3*16
dc.w	-1

fader_pos:	dc.l	fader_table1
fader_direct:	dc.w	0
fader_sleep:	dc.w	2
fader_slpcount:	dc.w	1

fader_real:
	move.w	fader_direct(pc),d0
	beq	fader_skip
	subq.w	#1,fader_slpcount
	bne	fader_skip
	move.w	fader_sleep(pc),fader_slpcount

	move.l	fader_pos(pc),a0
	tst.w	(a0)
	bmi	fader_end

	moveq	#31,d0
	lea	$180(a5),a1
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

planecls1:
	lea	planeborder,a0
	moveq	#0,d0
	move.w	#((4*64*256+4*40*64)/4)-1,d7
planecls1l1:
	move.l	d0,(a0)+
	dbf	d7,planecls1l1
	rts


blackcol32:;source
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$000

titlecol:;destination
	dc.w $D46,$FFF,$FEE,$EDE,$ECD,$DBC,$DAC,$D9B
	dc.w $C9B,$C8A,$C7A,$B79,$B68,$B58,$A58,$A47
	dc.w $FFF,$FEE,$EDD,$ECC,$EBC,$EAB,$D9A,$D99
	dc.w $D88,$D78,$C67,$C67,$C56,$B45,$B45,$B34

titlecolgrey:;destination
	dc.w $D46,$FFF,$FEE,$EDE,$ECD,$DBC,$DAC,$D9B
	dc.w $C9B,$C8A,$C7A,$B79,$B68,$B58,$A58,$A47
	dc.w $FFF,$FEE,$EDD,$ECC,$EBC,$EAB,$D9A,$D99
	dc.w $D88,$D78,$C67,$C67,$C56,$B45,$B45,$B34

fadetest2:
fadequant3=32	;number of colours in this calculation
	lea	titlecolgrey,a0
	moveq	#fadequant3,d7	;number of colours
	bsr	fader_makegrey

	lea	blackcol32(pc),a0	;source-colourstable
	lea	titlecolgrey(pc),a1	;destination-colourtable
	lea	fader_table3,a2	;point in fader-table
	moveq	#%100,d1	;RGB filter
	moveq	#fadequant3,d7	;number of colours
	bsr	fader_calc

	lea	fader_table3+15*fadequant2*2,a0
	lea	titlecol(pc),a1
	lea	fader_table3+16*fadequant2*2,a2
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant3,d7	;number of colours
	bsr	fader_calc

	lea	fader_table3,a2
	move.w	#-1,2*16*fadequant3*2(a2)	;set endmark in colourlist
	rts
;----------
;---------
showplane:	dc.l	plane1	;|
workplane:	dc.l	plane2	;|
clearplane:	dc.l	plane3	;|
switchplanes:
	lea	showplane(pc),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	rts
;----------
;-------
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
	move.l	#$01800d46,(a1)+

	move.l	#-2,(a1)
	rts
pinklist:
	dc.l	$01800F57
	dc.l	$10e1fffe
	dc.l	$10e1fffe
	dcb.b	32,0
;-------------------
;----------------
logosize=40*101*4
animwave:
	dcb.l	40,animstart+16*logosize

value:	set	16
rept	17
	dc.l	animstart+value*logosize
value:	set	value-1
endr

value:	set	0
rept	17
	dc.l	animstart+value*logosize
value:	set	value+1
endr

value:	set	16
rept	17
	dc.l	animstart+value*logosize
value:	set	value-1
endr

	dcb.l	100,animstart+0*logosize
animwaveend:

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
	incbin	"data/modules/SMP.1_afternoon_voyage"
mod_smpl2:
	incbin	"data/modules/SMP.2_dna_warrior"
mod_smpl3:
	incbin	"data/modules/SMP.3_hawkeye-highscore"
mod_smpl4:
	incbin	"data/modules/SMP.4_summertime"
mod_smpl5:
	incbin	"data/modules/SMP.5_the_last_remix"
mod_smpl6:
	incbin	"data/modules/SMP.6_chippy story #1"
mod_smpl7:
	incbin	"data/modules/SMP.7_chippy story #2"
mod_smpl8:
	incbin	"data/modules/SMP.8_slow it down"
mod_smpl9:
	incbin	"data/modules/SMP.9_in 5 minutes"
mod_smpl10:
	incbin	"data/modules/SMP.a_still alive?"

firstpattern:
pattern1:
	incbin	"data/fieldsmasc1.raw"
	incbin	"data/fieldsmasc2.raw"
lastpattern:

mainplanes:
mpa:
menu:		incbin	"data/menu.blt"
issue:		incbin	"data/issue.blt"
skyline:	incbin	"data/skyline.clc"
abyss:		incbin	"data/abyss.blt"
mpb:	dcb.b	40*256*7-(mpb-mpa)
mpc:

plane1=mainplanes+4*mainplanesize
plane2=mainplanes+5*mainplanesize
plane3=mainplanes+6*mainplanesize

production:		incbin	"data/production.blt"

titlepic:	incbin	"data/Titlepic.blt"

codec_e:
;------------------------------------------------------------------------
ifne	usesection
section	data,data_c	;public faked to chip!!!!!!!!!
endif
datap_s:

ballon:	incbin	"data/ballon.blt"
balloff:	incbin	"data/balloff.blt"

mod_data1:
	incbin	"data/modules/P60.1_afternoon_voyage"
mod_data2:				
	incbin	"data/modules/P60.2_dna_warrior"
mod_data3:				
	incbin	"data/modules/P60.3_hawkeye-highscore"
mod_data4:				
	incbin	"data/modules/P60.4_summertime"
mod_data5:				
	incbin	"data/modules/P60.5_the_last_remix"
mod_data6:				
	incbin	"data/modules/P60.6_chippy story #1"
mod_data7:				
	incbin	"data/modules/P60.7_chippy story #2"
mod_data8:				
	incbin	"data/modules/P60.8_slow it down"
mod_data9:				
	incbin	"data/modules/P60.9_in 5 minutes"
mod_data10:				
	incbin	"data/modules/P60.a_still alive?"

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
masca:	incbin	"data/masc/spiralupdown.masc"
mascb:	incbin	"data/masc/lefttop2rightbot.masc"
mascv:	incbin	"data/masc/doublespiral.masc"
mascd:	incbin	"data/masc/breakout.masc"
masce:	incbin	"data/masc/mid2corner.masc"
mascf:	incbin	"data/masc/drivein.masc"
mascg:	incbin	"data/masc/closedoor.masc"
masch:	incbin	"data/masc/2balls.masc"
lastmasc:

sinus:	incbin	"data/3dsine.bin"

turnsinpoint:	dc.w	0
turnSinus:
	incbin	"data/turnsinus.bin"
	incbin	"data/turnsinus.bin"
	incbin	"data/turnsinus.bin"
	incbin	"data/turnsinus.bin"

;------------------------------------------------------------------------
include	"data/text.i"
textend:	dcb.b	textend-text,0
textoffsetend:	dc.w	-1
datap_e:
;------------------------------------------------------------------------
ifne	usesection
section	memory,bss_p
endif
bssp_s:

animstart:
		ds.b	40*101*4*17
animend:

playercode:	dcb.b	6360;	playerend-player

bssp_e:
;------------------------------------------------------------------------
ifne	usesection
section	chipmemory,bss_c
endif
bssc_s:
planesize=64*256
planeborder:	ds.b	4*40*64		;(for issue comin')
planeadr:	ds.b	4*planesize

copperlist1:	ds.b	64
copperlist2:	ds.b	64
bssc_e:

;----------------
datac_s:
datac_e:
;----------------

ifne	usesection
section	CodePublic,code_c	;public faked to chip!!!!!!!!
endif
codep_s:
player:	incbin	"data/player60.code"
playerend:
P60_init=player+40
P60_music=player+738
P60_end=player+626
P60_master=player+16

line:	;uses d0-d4,a0,a2,a5
;	move.l	workplane(pc),a0	;planeadress
	move.l	clearplane,a0	;planeadress
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

	MULU.W	#40,D0		;d0=y1*screen offset
;	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
;	LSL.W	#1,D3		;d3=lodiff*2
	add.w	d3,d3
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.W	.NOSIGN		;branch if lodiff*2 >hidiff
	OR.B	#$40,D4		;set bit 6	
;d4 waits
.NOSIGN:
;	LSL.W		#1,D0		;d0=lodiff*4
	add.w	d0,d0
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
	MOVE.w	#40,bltcmod(a5)
	MOVE.w	#40,bltdmod(a5)
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
ifd fulllines
;--------ssssccccmmmmmmmm
DC.w	%0000101111111010,$F013-2
DC.w	%0000101111111010,$F003-2
DC.w	%0000101111111010,$F017-2
DC.w	%0000101111111010,$F00B-2
endif
DC.w	%0000101101011010,$F013;-2
DC.w	%0000101101011010,$F003;-2
DC.w	%0000101101011010,$F017;-2
DC.w	%0000101101011010,$F00B;-2


;------------------------
startangle:	dc.w	0
startrad=126
corners=14
spiral:
	move.w	#%1000010000000000,dmacon(a5)
	lea	turnsinpoint,a3
	move.w	(a3),d0
	addq.w	#2,d0
	cmp.w	#1440,d0
	bne	.turnsinok
	moveq	#0,d0
.turnsinok:
	move.w	d0,(a3)+
	add.w	d0,a3

	moveq	#startrad,d6		;radius
	swap	d6
	move.w	startangle(pc),d5	;angle
	addq.w	#2,d5			;spiral turn speed
	cmp.w	#360,d5
	blt	.angleok
	moveq	#0,d5
.angleok:
	move.w	d5,startangle

	lea	sinus,a1
	lea	koordstore(pc),a4

	;line uses d0-d4,a0,a2,a5
	moveq	#corners,d7		;number of corners
spirall1:
	move.w	d5,d0			;angle
	add.w	d0,d0
	add.w	d0,d0
	move.w	2(a1,d0.w),d1		;cosinus angle
	move.w	(a1,d0.w),d0		;sinus angle
	move.w	d0,d2
	move.w	d1,d3

	swap	d6			;int radius
	muls.w	d6,d0			;radius*sin(angle)
	muls.w	d6,d1			;radius*cos(angle)
	sub.w	#15,d6			;inner circle
	muls.w	d6,d2			;radius*sin(angle)
	muls.w	d6,d3			;radius*cos(angle)
	add.w	#15,d6			;back 2 big circle
	swap	d6

	add.l	d0,d0
	sub.w	d0,d0
	swap	d0			;int x1
	add.l	d1,d1
	swap	d1			;int y1

	add.l	d2,d2
	sub.w	d2,d2
	swap	d2			;int x2
	add.l	d3,d3
	swap	d3			;int y2

	add.w	#160,d0
	add.w	#128,d1
	add.w	#160,d2
	add.w	#128,d3

	cmp.w	#corners,d7
	beq	spiral_first

	movem.l	d0-d3,-(a7)
	movem.w	4(a4),d0-d1
	bsr	line
	movem.l	(a7),d0-d2	;d2 to clear hiword!
	movem.w	(a4),d2-d3
	bsr	line
	movem.l	(a7)+,d0-d3
	movem.w	d0-d3,(a4)

spiral_nextcorner:
;skipdot:
	add.w	(a3)+,d5
	bpl	.noneg
	add.w	#360,d5
.noneg:
	cmp.w	#360,d5
	blt	.noflow
	sub.w	#360,d5
.noflow:
	sub.l	#380000,d6	;;inc radius
	dbf	d7,spirall1

	movem.w	(a4),d0-d3
	bsr	line	;uses d0-d4,a0,a2,a5
	move.w	#%0000010000000000,dmacon(a5)
	rts

spiral_first:
	movem.w	d0-d3,(a4)
	bsr	line	;uses d0-d4,a0,a2,a5
	bra	spiral_nextcorner


koordstore:
lastx1:	dc.w	50
lasty1:	dc.w	50
lastx2:	dc.w	50
lasty2:	dc.w	50


;--------
;--------
;planecls:
;	move.l	clearplane,d0
;waitblit
;	move.l	d0,BLTDPTH(A5)
;	move.w	#0,BLTDMOD(A5)
;	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
;	move.w	#256*64*1+20,BLTSIZE(A5)
;	rts
;----------
;-----------
planeclscpu:
	move.l	clearplane,a6
	lea	256*40(a6),a6
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	move.l	d0,a0
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	move.l	d0,a5

rept 182	;(40*256)/(14*4)
	movem.l	d0-a5,-(a6)
endr
	movem.l	d0-a3,-(a6)
	lea	$dff000,a5
	rts
;----------
;----
fill:
	move.l	workplane,d0
	add.l	#256*40-2,d0
waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#0,bltamod(A5)
	MOVE.w	#0,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#256*64+20,BLTSIZE(A5)
	rts
;----------
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
printt	"Total Memory:"
printv	codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s+codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s
printt	"Total Memory without BSS hunks"
printv	codep_e-codep_s+datap_e-datap_s+codec_e-codec_s+datac_e-datac_s

printt	"!!!!!!!!!!  NOTE !!!!!!!!!!"
printt	"hunk code public and hunk data public faked to chipmem"
printt	"-->to free enough fastmem to use imploder on 1MB machines"
