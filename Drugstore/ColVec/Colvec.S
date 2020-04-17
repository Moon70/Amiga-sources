;------------------------------------------------------------------------
;|                                                                      |
;|                       Plasmavector + Colorvector                     |
;|                      ----------------------------                    |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                         12-May-94 |
;------------------------------------------------------------------------
;showtime=1
incdir	""
codeskip=0
;changes from 5.2 to 5.3:
; double; at: Commands:, main_init:, Main_program: and Main_intuser:
; all possible jsr to bsr, lea to lea(pc),--> relocs from 168 to 96
; offset JSR changed to JMP
; commander not longer uses main_talk to exit program, now f_endprogram
; does this job
; main_init/program/end now are saving all registers, easier to jump in

forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize2=40*256
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

execbase=4
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
section	code,code_c
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
	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001100000,intena(a5)		;
	move.l	$6c.w,oldint				;
	move.l	#main_vbi,$6c.w				;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000100000,intena(a5)		;
	move.w	#%1000001111000000,dmacon(a5)		;
	move.w	#%0000001000000000,bplcon0(a5)

	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	bsr.w	main_init				;
	bsr.w	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq.b	back					;
	tst.w	f_endprogram				;
	beq.b	wait					;
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
	beq.b	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;

	lea	main_copperlist(pc),a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq.b	nomain_copperlist				;
	bpl.b	noempty_copperlist
	lea	main_emptycopperlist(pc),a1
	move.l	a1,cop1lch(a5)					;
	clr.l	(a0)						;
	bra.b	nomain_copperlist				;
noempty_copperlist:
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
;	move.w	#0,copjmp1(a5); should be removed!!		;
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
dircommand:	dc.l	0
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
		dc.l	1,	setcopscreen_eagleplasma
		dc.l	50,	setint_eagleplasmafadein
		dc.l	1,	setint_eagleplasma
rept 90-1
dc.l	1,zoomin
endr
dc.l	50,zoomin

;191
		dc.l	100,	adddoubrubdiff
		dc.l	100,	adddoubrubdiff
		dc.l	100,	adddoubrubdiff
		dc.l	80,	adddoubrubdiff
		dc.l	80,	adddoubrubdiff
		dc.l	80,	adddoubrubdiff
		dc.l	180,	adddoubrubdiff
;911
		dc.l	50,	fadeeagleout
		dc.l	1,	setint_gridplasma
		dc.l	30,	fadegridin
	
		dc.l	80,	subdoubrubdiff
		dc.l	80,	subdoubrubdiff
		dc.l	80,	subdoubrubdiff
		dc.l	80,	subdoubrubdiff
		dc.l	100,	subdoubrubdiff
		dc.l	100,	subdoubrubdiff
		dc.l	100,	subdoubrubdiff
;1612
rept 45
dc.l	1,zoomout
endr


		dc.l	50,	vecoff
		dc.l	1,	setint_gridcolvec
rept 90-1+4
dc.l	1,zoomin
endr
;1801
		dc.l	150,	zoomin
		dc.l	230,	colvecmorph
		dc.l	230,	colvecmorph
		dc.l	231,	colvecmorph
		dc.l	1,	fadegridout
		dc.l	1,	dircommanderoff
rept	45
		dc.l	1,zoomout
endr
		dc.l	1,	spritesoff
		dc.l	60000,	setente
;---------------------------------------------
nothing:	rts

dircommanderoff:
	move.l	#-1,dircommand
rts

spritesoff:
	move.w	#%0000000000100000,dmacon(a5)
	moveq	#0,d0
	move.l	d0,spr0data(a5)
	move.l	d0,spr1data(a5)
	move.l	d0,spr2data(a5)
	move.l	d0,spr3data(a5)
	move.l	d0,spr4data(a5)
	move.l	d0,spr5data(a5)
	move.l	d0,spr6data(a5)
	move.l	d0,spr7data(a5)
	move.w	d0,spr0pos(a5)
	move.w	d0,spr1pos(a5)
	move.w	d0,spr2pos(a5)
	move.w	d0,spr3pos(a5)
	move.w	d0,spr4pos(a5)
	move.w	d0,spr5pos(a5)
	move.w	d0,spr6pos(a5)
	move.w	d0,spr7pos(a5)
rts

zoomin:
	addq.w	#1,focus
rts

zoomout:
	subq.w	#2,focus
rts

colvecmorph:
	move.w	#1,cubeadd
rts

vecoff:
	move.w	#1,f_vectoroff
rts


CopScreen_eagleplasma:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
;	dc.w	bplcon0,%0100001000000000
	dc.w	bplcon1,$0000
	dc.w	bplcon2,$003f
	dc.w	bpl1mod,$78
	dc.w	bpl2mod,$78
	dc.l	-2

setcopscreen_eagleplasma:
	lea	CopScreen_eagleplasma,a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)
rts

setint_eagleplasmafadein:
	lea	copperlist,a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	lea	int_eagleplasmafadein,a1
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	move.l	#fadcaleagleout,dircommand
rts

setint_eagleplasma:
	lea	int_eagleplasma,a1
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	move.w	#%1000010000100000,dmacon(a5)
rts

setint_gridplasma:
	lea	copperlist,a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	lea	int_gridplasma,a1
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	lea	normal,a0
	move.w	(a0)+,diwstrt(a5)
	move.w	(a0)+,ddfstrt(a5)
	move.w	(a0)+,diwstop(a5)
	move.w	(a0),bpl1mod(a5)
	move.w	(a0),bpl2mod(a5)

;	move.w	#$2991,diwstrt(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$29b1,diwstop(a5)

	move.w	#%0100011000000000,bplcon0(a5)
	move.w	#%0000000000100000,bplcon2(a5)
;	move.w	#88,bpl1mod(a5)
;	move.w	#88,bpl2mod(a5)
	rts


setint_gridcolvec:
	lea	copperlist,a1
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)

	lea	int_gridcolvec,a1
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	a1,(a0)
	move.w	#%1000000000100000,dmacon(a5)


	lea	normal,a0
	move.w	(a0)+,diwstrt(a5)
	move.w	(a0)+,ddfstrt(a5)
	move.w	(a0)+,diwstop(a5)
	move.w	(a0),bpl1mod(a5)
	move.w	(a0),bpl2mod(a5)

;	move.w	#$2991,diwstrt(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$29b1,diwstop(a5)

	move.w	#%0100011000000000,bplcon0(a5)
	move.w	#%0000000000100000,bplcon2(a5)
;	move.w	#88,bpl1mod(a5)
;	move.w	#88,bpl2mod(a5)

	move.w	#0,f_vectoroff
rts

fadeeagleout:
	move.w	#1,fadecount
	move.w	#0,fadeflag
rts

fadegridin:
	lea	gridcol,a0
	lea	tofade,a1
	moveq	#7,d0
fadeinit3:
	move.l	(a0)+,(a1)+
	dbf	d0,fadeinit3
;	jsr	fader
	move.l	#exefader,dircommand

	move.w	#4,fadecount
rts


fadegridout:
	lea	tofade,a1
	move.l	#$04130413,d1
	moveq	#7,d0
fadeinit4:
	move.l	d1,(a1)+
	dbf	d0,fadeinit4
;	jsr	fader
	move.l	#exefader,dircommand
	move.w	#3,fadecount
rts

exefader:
	bsr.w	fader
rts

fadcaleagleout:
	lea	backpiccol,a0
	lea	backpicout,a3
	lea	faded,a1
	lea	tofade,a2
	moveq	#7,d0
fadeinit1:
	move.l	(a0)+,(a1)+
	move.l	(a3)+,(a2)+
	dbf	d0,fadeinit1
	jsr	fader
	move.w	#30,fadeflag
	move.w	#2,fadecount
rts


setente:
	move.w	#1,f_endprogram
	rts

;----------


;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk


move.l	4.w,a0
cmp.w	#34,20(a0)
bhs	skiptoxicderdepp

	lea	normal,a0
	lea	toxicdeppfake,a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
skiptoxicderdepp:


	lea	bssc_s,a0
	move.w	#(bssc_e-bssc_s)/4-1,d7
	moveq	#0,d0
clrbss:
	move.l	d0,(a0)+
	dbf	d7,clrbss

	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	#2*4,turnaddx
	move.w	#1*4,turnaddy	;disabled in turner-routine
	move.w	#4*4,turnaddz
	bsr.w	turner
	bsr.w	perspective
	bsr.w	hidesort2
	bsr.w	coppercopy
;	move.w	#%0100000001111000,intena(a5)
	bsr.w	switchplanes
;	bsr	clrsprites
	bsr.w	setsprites
	bsr.w	switchplanes
;	bsr	clrsprites
	bsr.w	setsprites


	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	movem.l	d0-a6,-(a7)
;---
;---
	movem.l	(a7)+,d0-a6
	rts
;----------

Main_program:;;
	movem.l	d0-a6,-(a7)
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)

main_loop:
;	btst.b	#6,ciaapra
;	beq.b	mainloop_exit
	tst.l	dircommand
	bmi.b	mainloop_exit
	beq.b	main_loop

	lea	dircommand(pc),a0
	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	bra.b	main_loop


mainloop_exit:
	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	lea	$dff000,a5
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------


int_eagleplasma:
	bsr.w	switchplanes
	lea	backpic,a0

	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)

	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)

;------------------
	move.l	showsprites,a0
	move.l	a0,spr0pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr2pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr4pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr6pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr1pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr3pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr5pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr7pth(a5)

lea	objcol,a0
lea	$1a0(a5),a1
move.l	(a0),8(a1)
move.l	(a0),16(a1)
move.l	(a0),24(a1)
move.l	(a0)+,(a1)+

move.l	(a0),8(a1)
move.l	(a0),16(a1)
move.l	(a0),24(a1)
move.l	(a0)+,(a1)+

	bsr.w	spriteclsb
	bsr.w	spriteclsp
	bsr.w	planecls	;blit
bsr.w	setsinus
	bsr.w	setsprites
	bsr.w	turner
	bsr.w	hidesort2
	bsr.w	perspective

	bsr.w	drawline	;blit
	bsr.w	commander
	bsr.w	spritecopy2	;blit
	bsr.w	coppercopy1


bsr.w	addsindiff
jsr	realfade

lea	faded,a0
lea	$180(a5),a1
lea	$dff180,a1
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+

rts

int_eagleplasmafadein:
	move.w	#%0100001000000000,bplcon0(a5)
	lea	backpic,a0

	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)

	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)

	bsr.w	commander

jsr	realfade2

lea	faded,a0
lea	$180(a5),a1
lea	$dff180,a1
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+

rts
;--------------------------------------------------------------------

int_gridplasma:
	jsr	switchplanes
	bsr.w	calcgrid

;------------------
	move.l	showsprites,a0
	move.l	a0,spr0pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr2pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr4pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr6pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr1pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr3pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr5pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr7pth(a5)

lea	objcol,a0
lea	$1a0(a5),a1
move.l	(a0),8(a1)
move.l	(a0),16(a1)
move.l	(a0),24(a1)
move.l	(a0)+,(a1)+

move.l	(a0),8(a1)
move.l	(a0),16(a1)
move.l	(a0),24(a1)
move.l	(a0)+,(a1)+

	bsr.w	spriteclsb
	bsr.w	spriteclsp
	bsr.w	planecls	;blit
bsr.w	setsinus
	bsr.w	setsprites
	bsr.w	turner

	bsr.w	hidesort2
	bsr.w	perspective
	bsr.w	drawline	;blit
	bsr.w	commander
	bsr.w	spritecopy2	;blit
	bsr.w	coppercopy1


bsr.w	addsindiff
jsr	realfade

lea	faded,a0
lea	$180(a5),a1
lea	$dff180,a1
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
;---------------------------------
rts
;--------------------------------------------------------------------


int_gridcolvec:
	bsr.w	switchplanes
	bsr.w	calcgrid

	move.l	showsprites,a0

	move.l	a0,spr0pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr2pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr4pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr6pth(a5)
	lea	(256*4+8)(a0),a0

	move.l	a0,spr1pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr3pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr5pth(a5)
	lea	(256*4+8)(a0),a0
	move.l	a0,spr7pth(a5)


	bsr.w	spriteclsb
	bsr.w	spriteclsp
	bsr.w	planecls	;blit
	bsr.w	setsprites
	bsr.w	turner
	bsr.w	perspective
	bsr.w	hidesort2
	bsr.w	drawline	;blit
	bsr.w	commander
	bsr.w	spritecopy	;blit
	bsr.w	coppercopy
jsr	realfade

lea	faded,a0
lea	$180(a5),a1
lea	$dff180,a1
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+

	move.w	#0,intwait
rts



calcgrid:
	lea	grid1xpos(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	move.w	(a1),d0
	addq.w	#2,d0
	cmp.w	#sinus1end-sinus1,d0
	bne.b	qnog1xflow
	moveq	#0,d0
qnog1xflow:
	move.w	d0,(a1)+

	move.w	(a1),d1
	addq.w	#4,d1
	cmp.w	#sinus1end-sinus1,d1
	bne.b	qnog1yflow
	moveq	#0,d1
qnog1yflow:
	move.w	d1,(a1)+

	lea	sinus1,a0
	move.w	(a0,d0.w),d0
	move.w	(a0,d1.w),d1
divu	#89,d0
swap	d0
divu	#89,d1
swap	d1

	lsl.w	#7,d1
	move.w	d0,d2
	lsr.w	#4,d2
	add.w	d2,d2
	add.w	d2,d1
	not.w	d0
	and.w	#%0000000000001111,d0
	;lsl.w	#4,d0
;	move.w	d0,bplcon1(a5)
move.w	d0,d3

	lea	grid1,a0
	lea	(a0,d1.w),a0
	move.l	a0,bpl1pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl3pth(a5)

	lea	grid2xpos(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	move.w	(a1),d0
	addq.w	#2,d0
	cmp.w	#sinus2end-sinus2,d0
	bne.b	qnog2xflow
	moveq	#0,d0
qnog2xflow:
	move.w	d0,(a1)+

	move.w	(a1),d1
	addq.w	#4,d1
	cmp.w	#sinus2end-sinus2,d1
	bne.b	qnog2yflow
	moveq	#0,d1
qnog2yflow:
	move.w	d1,(a1)+

	lea	sinus2,a0
	move.w	(a0,d0.w),d0
	move.w	(a0,d1.w),d1
divu	#52,d0
swap	d0
divu	#53,d1
swap	d1

	lsl.w	#7,d1
	move.w	d0,d2
	lsr.w	#4,d2
	add.w	d2,d2
	add.w	d2,d1
	not.w	d0
	and.w	#%0000000000001111,d0
	lsl.w	#4,d0
	or.w	d0,d3
	move.w	d3,bplcon1(a5)

	lea	grid2,a0
	lea	(a0,d1.w),a0
	move.l	a0,bpl2pth(a5)
	lea	64(a0),a0
	move.l	a0,bpl4pth(a5)
rts



normal:
	dc.w	$2981
	dc.w	$0030
	dc.w	$29c1
	dc.w	86

toxicdeppfake:
	dc.w	$2991
	dc.w	$0038
	dc.w	$29b1
	dc.w	88
































f_vectoroff:	dc.w	0


;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------
switchplanes:
	lea	showsprites(pc),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)
	move.l	d0,4(a0)
	rts
;----------
;--------------------------------
turner:	;last optimizing:93-09-05
	move.w	turnx(pc),a1
	add.w	turnaddx(pc),a1
	cmp.w	#1436,a1
	ble.b nolaufx
	lea	-1440(a1),a1
nolaufx:
	move.w	a1,turnx

	move.w	turny(pc),a2
	add.w	turnaddy(pc),a2
	cmp.w	#1436,a2
	ble.b nolaufy
	lea	-1440(a2),a2
nolaufy:
	move.w	a2,turny

	move.w	turnz(pc),a0
	add.w	turnaddz(pc),a0
	cmp.w	#1436,a0
	ble.b nolaufz
	lea	-1440(a0),a0
nolaufz:
	move.w	a0,turnz


turner1:
	move.l	turnkoord(pc),a4	;koordinaten
	move.l	turnkoords(pc),a3
	lea	sinus(pc),a6	;sinus/cosinus
	move.w	turnquant(pc),d0
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
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	swap	d6

move.w	d3,d1
;	move.w	d3,2(a4,d0.w)
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
	add.l	d3,d3
	swap	d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	add.l	d6,d6
	swap	d6
	move.w	d3,4(a4,d0.w)
;move.w	d6,6(a4,d0.w)

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
	add.l	d3,d3
	swap	d3
	sub.l	d7,d6		;d6=z*cos y - x*sin y
	add.l	d6,d6
	swap	d6
	move.w	d3,2(a4,d0.w)
	move.w	d6,6(a4,d0.w)

	subq.w	#8,d0
	bpl.b	turnrout1
	rts
;*****

perspective:
	move.l	turnkoord(pc),a3
	move.l	turnkoord(pc),a4
	move.w	turnquant(pc),d7

perspectiveloop:
	move.w	2(a3),d0
	move.w	4(a3),d1
	move.w	6(a3),d2
	neg.w	d2
	asr.w	#2,d2
	add.w	#110,d2

;---
	move.w	focus,d3
	muls.w	d3,d0
	muls.w	d3,d1
	divs	d2,d0
	divs	d2,d1

;---

	move.w	d0,2(a4)
	move.w	d1,4(a4)
	move.w	6(a3),6(a4)
	addq.l	#8,a3
	addq.l	#8,a4

	dbf	d7,perspectiveloop
	rts


focus:	dc.w	10


;----------
planecls:
	lea	workplanes,a0
	lea	64*126+12(a0),a0
	waitblit
	move.l	a0,BLTDPTH(A5)
	move.w	#32+16,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#128*2*64+16-8,BLTSIZE(A5)
	rts
;----------
;----------
spritecopy:
	lea	workplanes,a2
	lea	64*126+12(a2),a2
	move.l	worksprites(pc),a1
	addq.l	#4,a1

	moveq	#62,d3
	swap	d3

	move.l	#%00001001111100000000000000000000,a0
	move.w	#16*2*64+1,a4

	moveq	#16*4,d0
	move.w	#16*2*64,d1
	moveq	#16,d2
	add.w	cubediff(pc),d2

	moveq	#7,d7
sprcopyl1:
	moveq	#128-16*4,d5		;midscreen - 4*box
	move.w	cubediff(pc),d4
	sub.w	d4,d5			;three full spaces between...
	sub.w	d4,d5			;...four cubes..
	sub.w	d4,d5
	lsr.w	#1,d4			;...and a halve...
	sub.w	d4,d5			;...to the midscreenborder
	moveq	#7,d6
sprcopyl2:
	tst.w	d5
	bmi.b	skipcube
	cmp.w	#255-16,d5
	bhi.b	skipcube

	move.w	d5,d4
	lsl.w	#2,d4
	lea	(a1,d4.w),a3

waitblit

;	move.l	a2,bltapth(a5)		;50
;	move.l	a3,BLTDPTH(A5)		;54
	movem.l	a2/a3,bltapth(a5)	;50

;	move.w	#62,bltamod(a5)		;64
;	move.w	#0,BLTDMOD(A5)		;66
	move.l	d3,bltamod(a5)

;	move.l	#%00001001111100000000000000000000,BLTCON0(A5);0+1
;	move.w	#16*2*64+1,BLTSIZE(A5)
	move.l	a0,BLTCON0(A5);0+1
	move.w	a4,BLTSIZE(A5)

skipcube:
	add.w	d0,a3
	add.w	d1,a2
	add.w	d2,d5
	dbf	d6,sprcopyl2
	
	lea	8+128*4(a3),a3	;skip spritecontrolwords + endlongword
	lea	-(8*16*2*64-2)(a2),a2	;skip source
	lea	8+256*4(a1),a1	;skip spritecontrolwords + endlongword

	dbf	d7,sprcopyl1
	rts
;----------
;----------
spritecopy2:
	move.l	worksprites(pc),a1
	addq.l	#4,a1
	lea	spritefieldy(pc),a4
	lea	workplanes,a2
	lea	64*126+12(a2),a2
	moveq	#62,d3
	swap	d3
	moveq	#7,d7
sprcopy2l1:

	moveq	#7,d6
sprcopy2l2:
	move.w	(a4)+,d4
;	lsl.w	#2,d4
	lea	(a1,d4.w),a3
waitblit
	movem.l	a2/a3,bltapth(a5)	;50
	move.l	d3,bltamod(a5)
	move.l	#%00001001111100000000000000000000,BLTCON0(A5);0+1
	move.w	#16*2*64+1,BLTSIZE(A5)
skipcube2:
	add.w	#16*4,a3
	add.w	#16*2*64,a2
	dbf	d6,sprcopy2l2
	
	lea	8+128*4(a3),a3	;skip spritecontrolwords + endlongword
	lea	-(8*16*2*64-2)(a2),a2	;skip source
	lea	8+256*4(a1),a1	;skip spritecontrolwords + endlongword

	dbf	d7,sprcopy2l1
	rts
;----------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;--------
drawline:
	move.l	turnkoord(pc),a1	;turned koordinates
	lea	areaoffsets(pc),a3	;areas to draw
	move.w	(a3)+,d7		;areacount
	lea	arealines+2(pc),a4	;linecodes for each area
drawloop1:				;mainloop for each area

	move.w	(a3)+,d6		;get offset of area 1
	move.w	(a4,d6.w),d5		;number of lines in this area
	move.w	2(a4,d6.w),-(a7)	;areacolour of stack
	move.w	#$7fff,d0
	move.w	d0,lox
	move.w	d0,loy
	moveq	#0,d0
	moveq	#-1,d1
	moveq	#64,d2
	move.l	d0,hix;(+hiy)
	waitblit
	move.w	d0,bltbdat(a5)
	move.l	d1,bltafwm(a5)
	move.w	d2,bltcmod(a5)
	move.w	d2,bltdmod(a5)
	move.w	#$8000,bltadat(a5)

drawloop2:
	moveq	#80,d0
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

	bsr.w	draw

	dbf	d5,drawloop2

addq.w	#1,hiy	;highest x +1 coz difference 0-->1 line to blit
add.w	#16,hix
and.w	#%1111111111110000,hix
and.w	#%1111111111110000,lox

move.w	lox(pc),d0		;lowest x	      	PLANEOFFSET CALCULATION
lsr.w	#4,d0		;/16=words
add.w	d0,d0		;*2=bytes from left border

move.w	loy(pc),d1		;lowest y-koord
lsl.w	#6,d1		;*64 (bytes/line)
move.w	d1,d4		;copy for later use
add.w	d0,d1		;x-offset + y-offset...
move.w	d1,planeoffsets	;...=planeoffset for blitterwindow sourcescreen

;move.w	loy,d4		;again lowest y-koord
;lsl.w	#6,d4		;*(64*3) (bytes/line)
move.w	d4,d1
add.w	d4,d1
add.w	d0,d1

;sub.w	#64*220+20,d1
move.w	d1,planeoffsetd	;planeoffset for destination screen


moveq	#64,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix(pc),d1		;highest x...
sub.w	lox(pc),d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source
add.w	#64,d0	;modulo+64+64...
move.w	d0,planemodulod	;...=modulo destination


move.w	hiy(pc),d2	;highest y-value...			BLTSIZE CALC
sub.w	loy(pc),d2	;...-lowest y-value
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize	;planesize for source and destination

add.w	planeoffsets(pc),d2
add.w	#4,d2
move.w	d2,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize(pc),planesizef
move.w	planemodulos(pc),planemodulof

addq.w	#4,planesizef
subq.w	#8,planemodulof
addq.w	#4,planeoffsetf

move.w	(a7)+,d0;areacolour from stack

;	move.w	#%1000010000000000,dmacon(a5)

	bsr.w	planefillcopycls
dbf	d7,drawloop1


rts


;----------
spriteclsb:
	move.l	worksprites(pc),a0
	lea	70*48(a0),a0
	waitblit
	move.l	a0,BLTDPTH(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#153*64+16,BLTSIZE(A5)	;8256-(60*48)=4896; /32=153
	rts
;----------
;----------
spriteclsp:
	move.l	worksprites,a0

	move.w	#(172-102)-1,d7	;8256/48
	movem.l	d0-a6,-(a7)

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	move.l	d0,a5
	move.l	d0,a6

sprcls:
	movem.l	d1-d6/a1-a6,(a0)
	lea	48(a0),a0
	dbf	d7,sprcls
	movem.l	(a7)+,d0-a6
	rts
;----------
;----------
setsprites:
	move.l	worksprites(pc),a0
	move.w	#$70*2,d0

	move.w	cubediff(pc),d4
	sub.w	d4,d0
	sub.w	d4,d0
	sub.w	d4,d0
	lsr.w	#1,d4
	sub.w	d4,d0

	moveq	#16,d3
	add.w	cubediff(pc),d3

	moveq	#7,d7
sprxsetl1:
	tst.w	d5
	bmi.b	skipsprite
	move.w	d0,d1
	moveq	#0,d2
	roxr.w	#1,d1
	roxl.w	#1,d2
	or.w	#$2900,d1
	or.w	#$2902,d2
	move.w	d1,(a0)		;8
	move.w	d2,2(a0)	;12

skipsprite:
	add.w	d3,d0
	lea	256*4+8(a0),a0
	dbf	d7,sprxsetl1


;btst	#10,$dff016
;bne.b	skipzoom
;move.w	#1,cubeadd

skipzoom:

lea	cubediff(pc),a0
move.w	(a0),d0

add.w	cubeadd(pc),d0
bpl.b	zoomok1
neg.w	cubeadd
moveq	#0,d0
move.w	d0,cubeadd

zoomok1:
cmp.w	#80,d0
blo.b	zoomok2
neg.w	cubeadd

add.l	#64,turnkoords
move.l	turnkoords(pc),d1
cmp.l	#linekoordsend,d1
bne.b	zoomok2
	move.l	#linekoords1,turnkoords

zoomok2:
move.w	d0,(a0)
rts

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
DRAW:
	lea	calcplane,a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
	beq.w	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y


drawl1:	
;----------searching lowest x/y and highest x/y of polygon
;y-koord alredy sorted:y1 is always lower than y2
	cmp.w	lox,d0
	bhs.b	nonewlox1
	move.w	d0,lox
nonewlox1:

	cmp.w	lox,d2
	bhs.b	nonewlox2
	move.w	d2,lox
nonewlox2:

	cmp.w	loy,d1
	bhs.b	nonewloy
	move.w	d1,loy
nonewloy:

	cmp.w	hix,d0
	bls.b	nonewhix1
	move.w	d0,hix
nonewhix1:

	cmp.w	hix,d2
	bls.b	nonewhix2
	move.w	d2,hix
nonewhix2:

	cmp.w	hiy,d3
	bls.b	nonewhiy
	move.w	d3,hiy
nonewhiy:

;----------
	SUBQ.W	#1,D3		;y2=y2-1
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

waitblit

	MOVE.w	d3,bltaptl(a5)
	MOVE.l	a2,bltcpth(a5)
	MOVE.l	a2,bltdpth(a5)

	MOVE.w	d0,bltbmod(a5)
	MOVE.l	d4,bltcon0(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)

drawl2:
	RTS


;----------------
planefillcopycls:
	tst.w	f_vectoroff
	bne.w	skip_planefillcopycls
;planefill:
	lea	calcplane,a0
	add.w	planeoffsetf(pc),a0
	moveq	#-1,d1
	MOVE.w	planemodulof,d3

waitblit

	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	d1,bltafwm(a5)

	MOVE.l	a0,bltapth(a5)
	MOVE.l	a0,bltdpth(a5)
	MOVE.w	d3,bltamod(a5)
	MOVE.w	d3,bltdmod(a5)
	MOVE.w	planesizef,bltsize(a5)

;planecopy:
move.w	#%0000110111111100,d3
move.w	d3,d4

btst.l	#0,d0
bne.b	settest1
move.w	#%0000110100001100,d3
settest1:

btst.l	#1,d0
bne.b	settest2
move.w	#%0000110100001100,d4
settest2:

	move.w	planemodulod(pc),d0
	move.w	planemodulos(pc),d1
	move.w	planesize(pc),d2

	lea calcplane,a2
	add.w	planeoffsets(pc),a2
	lea	workplanes,a0
	add.w	planeoffsetd(pc),a0
waitblit

	MOVE.w	#0,bltcon1(a5)
	MOVE.w	d3,bltcon0(a5)
	MOVE.l	a0,bltbpth(a5)
	MOVE.l	a0,bltdpth(a5)
	MOVE.l	a2,bltapth(a5)
	MOVE.w	d0,bltbmod(a5)
	MOVE.w	d0,bltdmod(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)
;-----
	lea	64(a0),a0
waitblit
	MOVE.w	d4,bltcon0(a5)
	MOVE.l	a0,bltbpth(a5)
	MOVE.l	a0,bltdpth(a5)
	MOVE.l	a2,bltapth(a5)
	MOVE.w	d0,bltbmod(a5)
	MOVE.w	d0,bltdmod(a5)
	MOVE.w	d1,bltamod(a5)
	MOVE.w	d2,bltsize(a5)
;-----
;planecls:
	lea	calcplane,a2
	add.w	planeoffsets(pc),a2
waitblit
	MOVE.w	#%0000000100000000,bltcon0(a5)
	moveq	#0,d0
	MOVE.w	d0,bltcon1(a5)
	MOVE.l	a2,bltdpth(a5)
	MOVE.w	d1,bltdmod(a5)
	MOVE.w	d2,bltsize(a5)
skip_planefillcopycls:
	rts
;----------


hidesort2:
movem.l	d0-d7/a0-a6,-(a7)
lea	arealines,a0	;basis of all areas
move.l	turnkoord,a1	;turned koordinates
lea	areaoffsets+2,a2
lea	zpositions,a3	;mittelwerte der z-koords
move.w	(a0)+,d7	;number of all areas
moveq	#-1,d6		;counter of non-hidden areas

hide2l1:
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
bpl.b	hidden2
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

zaddloop2:
move.w	(a4)+,d3
;lsl.w	#3,d3
move.w	6(a1,d3.w),d3
add.l	d3,d1
dbf	d0,zaddloop2


move.w	d1,-(a7)
;lsl.l	#2,d1
;muls	#4,d1
asl.w	#2,d1
ext.l	d1
divs	d4,d1
move.w	d1,(a3)+

move.w	(a7)+,d0
bpl.b	notnegativ
neg.w	d0
notnegativ:


lsr.w	#4,d0
add.w	#5,d0

;add.w	d0,d0

move.w	(a7)+,d5
add.w	d5,d5

;moveq	#10,d0
not.w	d0
and.w	#$000f,d0
add.w	d0,d0
lea	glenzcol,a4
lea	(a4,d0.w),a4
move.w	d5,d0
lsl.w	#4,d0
move.w	-32(a4,d0.w),d0


lea	objcol,a4
lea	(a4,d5.w),a4
move.w	d0,(a4)

hidden2:
dbf	d7,hide2l1
lea	areaoffsets(pc),a0
move.w	d6,(a0)

movem.l	(a7)+,d0-d7/a0-a6

rts




coppercopy:
	lea	cyclepos(pc),a0
	move.w	(a0),d7
	addq.w	#2,d7
	cmp.w	#64,d7
	blo.b	nocycrestart
	sub.w	#64,d7
nocycrestart:
	move.w	d7,(a0)

;	lea	col1(pc),a1
;	lea	col2(pc),a2
;	lea	col3(pc),a3
;	lea	(a1,d7.w),a1
;	lea	(a2,d7.w),a2
;	lea	(a3,d7.w),a3

	lea	col1(pc),a1
	lea	(a1,d7.w),a1
	lea	col2-col1(a1),a2
	lea	col2-col1(a2),a3

	lea	copperlist,a0

;	move.w	#$ae,d0		;start is middle screen
	moveq	#$a9-16*4,d0		;start is middle screen
;	sub.w	#16*4,d0	;-4*box (go up = 4 cubes...
	move.w	cubediff(pc),d1	;...and three spaces (betw.cubes)..
	move.w	d1,d6
	add.w	d1,d6
	add.w	d1,d6
	lsr.w	#1,d1		;...and a halve one! 
	add.w	d1,d6
moveq	#7,d7
sub.w	d6,d0
bcc.b	nocolkill

moveq	#$10,d6
add.w	cubediff(pc),d6

again:
	subq.w	#1,d7
	addq.l	#6,a1
	addq.l	#6,a2
	addq.l	#6,a3
	add.w	d6,d0
bcc.b	again

nocolkill:

	lsl.w	#8,d0		;calc it to a...
	move.b	#5,d0		;coppercomand

	move.w	cubediff(pc),d1
	lsl.w	#8,d1
	move.w	d1,cubediffc
	move.w	#$01a2,d1

	moveq	#7,d7
coppercopyl1:

	move.w	d0,(a0)+
	move.w	#-2,(a0)+

	moveq	#3,d6
	move.w	d1,d2
coppercopyl2:
	move.w	d2,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d2

	move.w	d2,(a0)+
	move.w	(a2)+,(a0)+
	addq.w	#2,d2

	move.w	d2,(a0)+
	move.w	(a3)+,(a0)+
 	addq.w	#4,d2

	dbf	d6,coppercopyl2

;not.w	depp
;move.w	#$0180,(a0)+
;move.w	depp,(a0)+
;move.w	#$0110,(a0)+
	move.w	#$1000,d3
	add.w	cubediffc(pc),d3

	add.w	d3,d0
	bcc.b	nocopborder
move.l	#$ffe1fffe,(a0)+

nocopborder:
;	lea	-1*2(a1),a1
;	lea	-1*2(a2),a2
;	lea	-1*2(a3),a3
	subq.l	#2,a1
	subq.l	#2,a2
	subq.l	#2,a3

	dbf	d7,coppercopyl1
	move.l	#-2,(a0)
	rts


addsinsleep:	dc.w	20
addsindiff:
	subq.w	#1,addsinsleep
	bne.b	addsinback
	move.w	#20,addsinsleep
	lea	sinxdiffs(pc),a0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.w	2(a0),(a0)+

	lea	sinydiffs(pc),a0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.w	2(a0),(a0)+
addsinback:
	rts

coppercopy1:
	lea	sinxdiffs(pc),a2
	lea	sinusxpoint(pc),a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#360,d0
	bne.b	nosinxflow
	moveq	#0,d0
nosinxflow:
	move.w	d0,(a0)
	lea	sinusx(pc),a1
	add.w	d0,a1

	lea	copperlist,a0
	move.w	#$400f,d0
	moveq	#-2,d1

	moveq	#13,d7
coppercopy1l1:
	move.w	d0,(a0)+
	move.w	d1,(a0)+
;	move.w	#$0180,(a0)+
;	move.w	test,(a0)+
;	not.w	test
;move.w	#$29d8,(a0)+	;$2940	$29d8	64	216

move.w	#$2900,d2

move.w	d2,d3
add.w	(a1),d3
;lea	14(a1),a1
add.w	(a2)+,a1

move.w	#spr0pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr2pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr4pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr6pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr1pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr3pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr5pos,(a0)+
move.w	d3,(a0)+

add.w	#8,d3
move.w	#spr7pos,(a0)+
move.w	d3,(a0)+


	add.w	#$1000,d0
	bcc.b	nocopborder2
move.l	#$ffe1fffe,(a0)+

nocopborder2:
	dbf	d7,coppercopy1l1

	move.l	#-2,(a0)
	rts

;----------
adddoubrubdiff:
	lea	sinxdiffs(pc),a0
	addq.w	#2,13*2(a0)
	lea	sinydiffs(pc),a0
	addq.w	#2,7*2(a0)
	rts
;----------
subdoubrubdiff:
	lea	sinxdiffs(pc),a0
	subq.w	#2,13*2(a0)
	lea	sinydiffs(pc),a0
	subq.w	#2,7*2(a0)
	rts
;----------

fadesleep:	dc.w	0
fadecount:	dc.w	3
tofade:		blk.w	68,$0000
faded:		blk.w	68,$0000
fadedat:	blk.w	68*16,$0000
fadeflag:	dc.w	0


realfade:
	move.w	fadesleep(pc),d0
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

fadeflag2:	dc.w	30

realfade2:
	move.w	fadesleep(pc),d0
	beq.b	fadeit2
	subq.w	#1,d0
	move.w	d0,fadesleep
	rts
fadeit2:
	move.w	fadecount,fadesleep
	move.w	fadeflag2,d0
	bne.b	fadereal2
	rts
fadereal2:
	subq.w	#2,d0
	move.w	d0,fadeflag2
;	subq.w	#2,d0;;
	lea	fadedat,a0
	lea	faded,a1
	moveq	#35,d1
fadereal2l1:
	move.w	0(a0,d0.w),(a1)+
	add.l	#30,d0
	dbf	d1,fadereal2l1
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
;move.w	$dff006,$dff180
	dbf	d1,faderloop2
	dbf	d0,faderloop1
	move.w	#0,fadeflag
	rts
;*****







grid1xpos:	dc.w	$130
grid1ypos:	dc.w	$260
grid2xpos:	dc.w	$130
grid2ypos:	dc.w	$260

turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0
cubeadd:	dc.w	0
cubediff:	dc.w	0
cubediffc:	dc.w	0
turnx:	dc.w	0
turny:	dc.w	0
turnz:	dc.w	0
intwait:	dc.w	0

hideflag:	dc.w	0
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
cyclepos:	dc.w	0
objcol:	dc.w	0,0,0,0

showsprites:	dc.l	sprites1
worksprites:	dc.l	sprites2

OCTANTS:	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
		DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
		DC.L	$0B5AF017;-2		; BIT/LINE.
		DC.L	$0B5AF00B;-2

;cube
side=34-2
linepoints1: 	dc.w  7; 8 Linepoints
linekoord1:	dcb.b	64,0
linekoords1:
dc.w 0,-side,-side, side
dc.w 0,-side, side, side
dc.w 0, side, side, side
dc.w 0, side,-side, side
dc.w 0,-side,-side,-side
dc.w 0,-side, side,-side
dc.w 0, side, side,-side
dc.w 0, side,-side,-side

dc.w 0,-15,-side, side+8
dc.w 0,-15, side, side+8
dc.w 0, 15, side, side+8
dc.w 0, 15,-side, side+8
dc.w 0,-side,-15,-side-8
dc.w 0,-side, 15,-side-8
dc.w 0, side, 15,-side-8
dc.w 0, side,-15,-side-8

dc.w 0,-14,-14, side
dc.w 0,-14, 14, side
dc.w 0, 14, 14, side
dc.w 0, 14,-14, side
dc.w 0,-35,-35,-side
dc.w 0,-35, 35,-side
dc.w 0, 35, 35,-side
dc.w 0, 35,-35,-side

dc.w 0,-20,-20, side
dc.w 0,-20, 20, side
dc.w 0, 20, 20, side
dc.w 0, 20,-20, side
dc.w 0,-20,-side,-side
dc.w 0,-20, side,-side
dc.w 0, 20, side,-side
dc.w 0, 20,-side,-side


linekoordsend:

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
dcb.w	10,0

col1:
dc.w	$0000,$0111,$0222,$0333,$0444,$0555,$0666,$0777
dc.w	$0888,$0999,$0aaa,$0bbb,$0ccc,$0ddd,$0eee,$0fff
dc.w	$0fff,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999,$0888
dc.w	$0777,$0666,$0555,$0444,$0333,$0222,$0111,$0000

dc.w	$0000,$0111,$0222,$0333,$0444,$0555,$0666,$0777
dc.w	$0888,$0999,$0aaa,$0bbb,$0ccc,$0ddd,$0eee,$0fff
dc.w	$0fff,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999,$0888
dc.w	$0777,$0666,$0555,$0444,$0333,$0222,$0111,$0000

col2:
dc.w	$0002,$0003,$0014,$0125,$0236,$0347,$0458,$0568
dc.w	$0678,$0789,$089a,$09ab,$0abc,$0bcd,$0cde,$0eef
dc.w	$0eef,$0cde,$0bcd,$0abc,$09ab,$089a,$0789,$0678
dc.w	$0568,$0458,$0347,$0236,$0125,$0014,$0003,$0002

dc.w	$0002,$0003,$0014,$0125,$0236,$0347,$0458,$0568
dc.w	$0678,$0789,$089a,$09ab,$0abc,$0bcd,$0cde,$0eef
dc.w	$0eef,$0cde,$0bcd,$0abc,$09ab,$089a,$0789,$0678
dc.w	$0568,$0458,$0347,$0236,$0125,$0014,$0003,$0002

col3:
dc.w 	$FFF,$fec,$ed9,$ec7,$eb5,$da2,$d90,$c80
dc.w	$b70,$a60,$950,$840,$730,$620,$520,$410
dc.w	$410,$520,$620,$730,$840,$950,$a60,$b70
dc.w	$c80,$d90,$da2,$eb5,$ec7,$ed9,$fec,$fff

dc.w 	$fff,$fec,$ed9,$ec7,$eb5,$da2,$d90,$c80
dc.w	$b70,$a60,$950,$840,$730,$620,$520,$410
dc.w	$410,$520,$620,$730,$840,$950,$a60,$b70
dc.w	$c80,$d90,$da2,$eb5,$ec7,$ed9,$fec,$fff


glenzcol:
dc.w	$efe,$efd,$dec,$cdb,$bca,$ab9,$9a8,$897
dc.w	$786,$675,$675,$675,$675,$675,$675,$675

dc.w	$fed,$edc,$dcb,$dba,$ca9,$b98,$a87,$976
dc.w	$865,$754,$754,$754,$754,$754,$754,$754

dc.w	$eef,$def,$cde,$bcd,$abc,$9ab,$89a,$789
dc.w	$678,$567,$567,$567,$567,$567,$567,$567

spritefieldy:	dcb.w	8*8

setsinus:
	lea	sinydiffs(pc),a2
	lea	sinusypoint(pc),a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#360,d0
	bne.b	nosinyflow
	moveq	#0,d0
nosinyflow:
	move.w	d0,(a0)

	lea	spritefieldy(pc),a0
	lea	sinusy(pc,d0.w),a1

	moveq	#7,d7
setsinusl1:
	move.w	(a1),d0
	lsl.w	#2,d0
	add.w	(a2)+,a1

	moveq	#7,d6
setsinusl2:
	move.w	d0,(a0)+
	add.w	#16*4,d0
	dbf	d6,setsinusl2
	dbf	d7,setsinusl1

rts
sinusypoint:	dc.w	20

Sinusy:;Created with Liberty Design's Sinusmaker
dc.W  70, 74, 79, 83, 87, 90, 94, 97, 99, 102, 103, 104, 105
dc.W  105, 105, 104, 103, 101, 99, 97, 95, 92, 89, 86, 83
dc.W  81, 78, 76, 73, 72, 70, 69, 68, 68, 68, 69, 70, 72
dc.W  74, 76, 79, 82, 85, 88, 92, 95, 98, 102, 105, 108, 111
dc.W  113, 115, 117, 118, 118, 118, 118, 117, 115, 113, 111
dc.W  108, 105, 101, 98, 94, 90, 86, 82, 78, 74, 70, 67, 64
dc.W  61, 59, 57, 55, 54, 54, 54, 54, 55, 57, 58, 60, 62
dc.W  65, 67, 70, 73, 75, 78, 80, 82, 83, 85, 86, 86, 86
dc.W  86, 85, 83, 81, 79, 76, 73, 70, 66, 62, 58, 54, 50
dc.W  46, 42, 39, 35, 32, 29, 27, 25, 23, 22, 22, 22, 22
dc.W  23, 25, 27, 29, 32, 35, 38, 42, 45, 48, 52, 55, 58
dc.W  61, 64, 66, 68, 70, 71, 72, 72, 72, 71, 70, 68, 67
dc.W  64, 62, 59, 57, 54, 51, 48, 45, 43, 41, 39, 37, 36
dc.W  35, 35, 35, 36, 37, 38, 41, 43, 46, 50, 53, 57, 61
dc.W  66

dc.W  70, 74, 79, 83, 87, 90, 94, 97, 99, 102, 103, 104, 105
dc.W  105, 105, 104, 103, 101, 99, 97, 95, 92, 89, 86, 83
dc.W  81, 78, 76, 73, 72, 70, 69, 68, 68, 68, 69, 70, 72
dc.W  74, 76, 79, 82, 85, 88, 92, 95, 98, 102, 105, 108, 111
dc.W  113, 115, 117, 118, 118, 118, 118, 117, 115, 113, 111
dc.W  108, 105, 101, 98, 94, 90, 86, 82, 78, 74, 70, 67, 64
dc.W  61, 59, 57, 55, 54, 54, 54, 54, 55, 57, 58, 60, 62
dc.W  65, 67, 70, 73, 75, 78, 80, 82, 83, 85, 86, 86, 86
dc.W  86, 85, 83, 81, 79, 76, 73, 70, 66, 62, 58, 54, 50
dc.W  46, 42, 39, 35, 32, 29, 27, 25, 23, 22, 22, 22, 22
dc.W  23, 25, 27, 29, 32, 35, 38, 42, 45, 48, 52, 55, 58
dc.W  61, 64, 66, 68, 70, 71, 72, 72, 72, 71, 70, 68, 67
dc.W  64, 62, 59, 57, 54, 51, 48, 45, 43, 41, 39, 37, 36
dc.W  35, 35, 35, 36, 37, 38, 41, 43, 46, 50, 53, 57, 61
dc.W  66

dc.W  70, 74, 79, 83, 87, 90, 94, 97, 99, 102, 103, 104, 105
dc.W  105, 105, 104, 103, 101, 99, 97, 95, 92, 89, 86, 83
dc.W  81, 78, 76, 73, 72, 70, 69, 68, 68, 68, 69, 70, 72
dc.W  74, 76, 79, 82, 85, 88, 92, 95, 98, 102, 105, 108, 111
dc.W  113, 115, 117, 118, 118, 118, 118, 117, 115, 113, 111
dc.W  108, 105, 101, 98, 94, 90, 86, 82, 78, 74, 70, 67, 64
dc.W  61, 59, 57, 55, 54, 54, 54, 54, 55, 57, 58, 60, 62
dc.W  65, 67, 70, 73, 75, 78, 80, 82, 83, 85, 86, 86, 86
dc.W  86, 85, 83, 81, 79, 76, 73, 70, 66, 62, 58, 54, 50
dc.W  46, 42, 39, 35, 32, 29, 27, 25, 23, 22, 22, 22, 22
dc.W  23, 25, 27, 29, 32, 35, 38, 42, 45, 48, 52, 55, 58
dc.W  61, 64, 66, 68, 70, 71, 72, 72, 72, 71, 70, 68, 67
dc.W  64, 62, 59, 57, 54, 51, 48, 45, 43, 41, 39, 37, 36
dc.W  35, 35, 35, 36, 37, 38, 41, 43, 46, 50, 53, 57, 61
dc.W  66

sinusxpoint:	dc.w	20
Sinusx:;Created with Liberty Design's Sinusmaker
dc.W  108, 110, 113, 115, 117, 119, 122, 124, 126, 128, 130
dc.W  132, 133, 135, 137, 138, 139, 141, 142, 143, 144, 145
dc.W  145, 146, 146, 147, 147, 147, 147, 146, 146, 146, 145
dc.W  144, 144, 143, 142, 141, 140, 138, 137, 136, 134, 133
dc.W  132, 130, 128, 127, 125, 124, 122, 121, 119, 117, 116
dc.W  115, 113, 112, 110, 109, 108, 107, 106, 105, 104, 103
dc.W  102, 102, 101, 101, 100, 100, 100, 100, 100, 100, 100
dc.W  100, 101, 101, 101, 102, 102, 103, 104, 104, 105, 106
dc.W  106, 107, 108, 109, 110, 110, 111, 112, 112, 113, 114
dc.W  114, 115, 115, 115, 116, 116, 116, 116, 116, 116, 116
dc.W  116, 115, 115, 114, 114, 113, 112, 111, 110, 109, 108
dc.W  107, 106, 104, 103, 101, 100, 99, 97, 95, 94, 92, 91
dc.W  89, 88, 86, 84, 83, 82, 80, 79, 78, 76, 75, 74, 73
dc.W  72, 72, 71, 70, 70, 70, 69, 69, 69, 69, 70, 70, 71
dc.W  71, 72, 73, 74, 75, 77, 78, 79, 81, 83, 84, 86, 88
dc.W  90, 92, 94, 97, 99, 101, 103, 106

dc.W  108, 110, 113, 115, 117, 119, 122, 124, 126, 128, 130
dc.W  132, 133, 135, 137, 138, 139, 141, 142, 143, 144, 145
dc.W  145, 146, 146, 147, 147, 147, 147, 146, 146, 146, 145
dc.W  144, 144, 143, 142, 141, 140, 138, 137, 136, 134, 133
dc.W  132, 130, 128, 127, 125, 124, 122, 121, 119, 117, 116
dc.W  115, 113, 112, 110, 109, 108, 107, 106, 105, 104, 103
dc.W  102, 102, 101, 101, 100, 100, 100, 100, 100, 100, 100
dc.W  100, 101, 101, 101, 102, 102, 103, 104, 104, 105, 106
dc.W  106, 107, 108, 109, 110, 110, 111, 112, 112, 113, 114
dc.W  114, 115, 115, 115, 116, 116, 116, 116, 116, 116, 116
dc.W  116, 115, 115, 114, 114, 113, 112, 111, 110, 109, 108
dc.W  107, 106, 104, 103, 101, 100, 99, 97, 95, 94, 92, 91
dc.W  89, 88, 86, 84, 83, 82, 80, 79, 78, 76, 75, 74, 73
dc.W  72, 72, 71, 70, 70, 70, 69, 69, 69, 69, 70, 70, 71
dc.W  71, 72, 73, 74, 75, 77, 78, 79, 81, 83, 84, 86, 88
dc.W  90, 92, 94, 97, 99, 101, 103, 106

dc.W  108, 110, 113, 115, 117, 119, 122, 124, 126, 128, 130
dc.W  132, 133, 135, 137, 138, 139, 141, 142, 143, 144, 145
dc.W  145, 146, 146, 147, 147, 147, 147, 146, 146, 146, 145
dc.W  144, 144, 143, 142, 141, 140, 138, 137, 136, 134, 133
dc.W  132, 130, 128, 127, 125, 124, 122, 121, 119, 117, 116
dc.W  115, 113, 112, 110, 109, 108, 107, 106, 105, 104, 103
dc.W  102, 102, 101, 101, 100, 100, 100, 100, 100, 100, 100
dc.W  100, 101, 101, 101, 102, 102, 103, 104, 104, 105, 106
dc.W  106, 107, 108, 109, 110, 110, 111, 112, 112, 113, 114
dc.W  114, 115, 115, 115, 116, 116, 116, 116, 116, 116, 116
dc.W  116, 115, 115, 114, 114, 113, 112, 111, 110, 109, 108
dc.W  107, 106, 104, 103, 101, 100, 99, 97, 95, 94, 92, 91
dc.W  89, 88, 86, 84, 83, 82, 80, 79, 78, 76, 75, 74, 73
dc.W  72, 72, 71, 70, 70, 70, 69, 69, 69, 69, 70, 70, 71
dc.W  71, 72, 73, 74, 75, 77, 78, 79, 81, 83, 84, 86, 88
dc.W  90, 92, 94, 97, 99, 101, 103, 106


sinxdiffs:	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0
sinydiffs:	dc.w	0,0,0,0,0,0,0,0


backpic:	incbin	"data/eagle.con"
backpiccol:
	dc.w $312,$FEE,$ECD,$DBB,$DAA,$C99,$B88,$A78
	dc.w $967,$956,$846,$735,$635,$624,$514,$413

backpicout:
	dc.w	$312,$312,$312,$312,$312,$312,$312,$312
	dc.w	$312,$312,$312,$312,$312,$312,$312,$312

gridcol:
	dc.w	$0413,$0c9b,$0635,$0968,0,0,0,0
	dc.w	$0413,$0967,$0534,$0746,0,0,0,0


grid1:	incbin	"data/grid89.con"
grid2:	incbin	"data/grid52x53.con"

Sinus1:;Created with Liberty Design's Sinusmaker
	incbin	"data/gridsin1.bin"
sinus1end:

Sinus2:;Created with Liberty Design's Sinusmaker
	incbin	"data/gridsin2.bin"
sinus2end:




b:

codec_e:
section	data,bss_c
bssc_s:
workplanes:	ds.b	2*256*64
calcplane:	ds.b	256*64
copperlist:	ds.b	600
sprites2:	ds.b	8*(256*4+8)

sprites1:
sprite0:	ds.b	1024+8
sprite2:	ds.b	1024+8
sprite4:	ds.b	1024+8
sprite6:	ds.b	1024+8
sprite1:	ds.b	1024+8
sprite3:	ds.b	1024+8
sprite5:	ds.b	1024+8
sprite7:	ds.b	1024+8

bssc_e:




printt	"Section Code Chip:"
printv	codec_e-codec_s
printt	"Section BSS Chip:"
printv	bssc_e-bssc_s

printt	"Chipmem needed:"
printv	codec_e-codec_s+bssc_e-bssc_s


