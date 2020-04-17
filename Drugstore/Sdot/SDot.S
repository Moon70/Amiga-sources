showtime=0
;------------------------------------------------------------------------
;|                                                                      |
;|                             Sinusdots                                |
;|                            -----------                               |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                           June-94 |
;------------------------------------------------------------------------
;5: 
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
	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	move.w	#%0000001000000000,bplcon0(a5)

	bsr.w	main_init				;
;------------------------------------------------------------------------
	bsr.w	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq.b	back					;
	tst.w	f_endprogram				;
	beq.b	wait					;
back:							;
	move.l	oldint,$6c.w				;
;------------------------------------------------------------------------
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
		dc.l	42,	setint_Sindot
		dc.l	215,	colcopysintomain
	
		dc.l	50,	moveout1
		dc.l	42,	movein
		dc.l	320,	colcopysintomain

		dc.l	50,	moveout2
		dc.l	60000,	setente
;---------------------------------------------
colcopysintomain:
	move.w	sincol+2,maincol+2
	rts

movego:
	move.w	#2,sincomadd
	rts

movestop:
	move.w	#0,sincomadd
	rts

commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

moveout1:
	lea	sincompos(pc),a0
	moveq	#-2,d0
	add.w	d0,(a0)+
	move.w	d0,(a0)
;	move.w	#$0034,maincol+2
	move.w	#$0023,maincol+2
	rts

moveout2:
	lea	sincompos(pc),a0
	moveq	#-2,d0
	add.w	d0,(a0)+
	move.w	d0,(a0)
	move.w	#$0202,maincol+2
	rts

movein:
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#mainint_sindots2,(a0)
	move.w	#16,sin1move
	move.w	#12,sin2move

	lea	sincompos(pc),a0
	moveq	#2,d0
	add.w	d0,(a0)+
	move.w	d0,(a0)

spr2col1=$234
spr2col2=$023
spr2col3=$fff

	move.w	#spr2col1,$01a2(a5)
	move.w	#spr2col2,$01a4(a5)
	move.w	#spr2col3,$01a6(a5)
	move.w	#spr2col1,$01aa(a5)
	move.w	#spr2col2,$01ac(a5)
	move.w	#spr2col3,$01ae(a5)
	move.w	#spr2col1,$01b2(a5)
	move.w	#spr2col2,$01b4(a5)
	move.w	#spr2col3,$01b6(a5)
	move.w	#spr2col1,$01ba(a5)
	move.w	#spr2col2,$01bc(a5)
	move.w	#spr2col3,$01be(a5)
	rts

setente:
	move.w	#1,f_endprogram
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

CopScreen_Sindot:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0;%100100
	dc.w	bpl1mod,0
	dc.w	bpl2mod,0
;	dc.w	bpl2mod,$ff96
	dc.w	bplcon0,%0000001000000000
	dc.l	$100ffffe
maincol:dc.w	$0180,$0101	;background dotpic 101
linehi:	dc.l	$ffe1fffe
linelo:	dc.l	$3a0ffffe
	dc.w	bplcon0,%0100001000000000
sincol:	dc.w	$0180,$0034	;0034
	dc.l	-2

setint_Sindot:
	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#CopScreen_Sindot,(a1)

lea	colour2+2,a0
lea	$180+2(a5),a1
move.w	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
move.l	(a0)+,(a1)+
	move.w	#%1000000000100000,dmacon(a5)
	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	bsr.w	sinxcalc
	bsr.w	sinycalc
	bsr.w	codecalc
	bsr.w	switchplanes
	bsr.w	BSSC_Clear

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
	move.l	#mainint_sindots1,(a0)
;veccol1=$234
;veccol2=$023
;veccol3=$fff

veccol1=$023
veccol2=$000
veccol3=$fff

	move.w	#veccol1,$01a2(a5)
	move.w	#veccol2,$01a4(a5)
	move.w	#veccol3,$01a6(a5)
	move.w	#veccol1,$01aa(a5)
	move.w	#veccol2,$01ac(a5)
	move.w	#veccol3,$01ae(a5)
	move.w	#veccol1,$01b2(a5)
	move.w	#veccol2,$01b4(a5)
	move.w	#veccol3,$01b6(a5)
	move.w	#veccol1,$01ba(a5)
	move.w	#veccol2,$01bc(a5)
	move.w	#veccol3,$01be(a5)

	movem.l	(a7)+,d0-a6
	rts

mainint_sindots1:;;
	bsr.w	planecls
;	lea	$dff000,a5	;planecls
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)
;	add.l	#64*255,d0

	move.l	shadowplane11,d0
	move.l	d0,bpl2pth(a5)

	move.l	shadowplane12,d0
	move.l	d0,bpl3pth(a5)
	move.l	shadowplane13,d0
	move.l	d0,bpl4pth(a5)

	move.l	#sprite10,spr0pth(a5)
	move.l	#sprite11,spr1pth(a5)
	move.l	#sprite12,spr2pth(a5)
	move.l	#sprite13,spr3pth(a5)
	move.l	#sprite14,spr4pth(a5)
	move.l	#sprite15,spr5pth(a5)
	move.l	#sprite16,spr6pth(a5)
	move.l	#spritee,spr7pth(a5)

	bsr.w	moveline
	bsr.w	point
	bsr.w	switchplanes
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------

mainint_sindots2:;;
	bsr.w	planecls
;	lea	$dff000,a5	;planecls
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)
;	add.l	#64*255,d0

	move.l	shadowplane21,d0
	move.l	d0,bpl2pth(a5)

	move.l	shadowplane22,d0
	move.l	d0,bpl3pth(a5)
	move.l	shadowplane23,d0
	move.l	d0,bpl4pth(a5)

	move.l	#sprite20,spr0pth(a5)
	move.l	#sprite21,spr1pth(a5)
	move.l	#sprite22,spr2pth(a5)
	move.l	#sprite23,spr3pth(a5)
	move.l	#sprite24,spr4pth(a5)
	move.l	#sprite25,spr5pth(a5)
	move.l	#sprite26,spr6pth(a5)
	move.l	#spritee,spr7pth(a5)

	bsr.b	moveline
	bsr.w	point
	bsr.w	switchplanes
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------

BSSC_Clear:
	lea	planes_end,a0
	move.w	#256*40*9/52/4-1+1,d7
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
BSSC_Clearloop:
	movem.l	d0-d6/a1-a6,-(a0)
	movem.l	d0-d6/a1-a6,-(a0)
	movem.l	d0-d6/a1-a6,-(a0)
	movem.l	d0-d6/a1-a6,-(a0)
	dbf	d7,BSSC_Clearloop
	lea	$dff000,a5
	rts

sincompos:		dc.w	0	;|
sincomadd:		dc.w	2	;|
moveline:
	lea	sincompos(pc),a0
	move.w	(a0),d0
	lea	sinuscome,a1
	move.w	0(a1,d0.w),d1
	bmi.b	moveline_fin
	add.w	2(a0),d0
	move.w	d0,(a0)

	addq.w	#4,d1
	move.b	#0,linehi
	move.b	d1,linelo
	sub.w	#$100,d1
	bmi.b	moveline_fin
	move.b	#$ff,linehi
	

moveline_fin:
	rts

planecls:
	lea	$dff000,a5
	move.l	clearplane,d0
;	addq.l	#0*64+2,d0
	move.l	d0,BLTDPTH(A5)
	move.w	#0,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#256*64+20,BLTSIZE(A5)
	rts


codea:
movem.l	(a2)+,d1/d3/d5/d7
movem.l	(a1)+,d0/d2/d4/d6

	sub.l	(a3)+,d1
	bset.b  d0,44(a0,d1.w)

	sub.l	(a3)+,d3
	bset.b  d2,44(a0,d3.w)

	sub.l	(a3)+,d5
	bset.b  d4,44(a0,d5.w)

	sub.l	(a3)+,d7
	bset.b  d6,44(a0,d7.w)

swap	d0
swap	d1
swap	d2
swap	d3
swap	d4
swap	d5
swap	d6
swap	d7
	bset.b  d0,44(a0,d1.w)
	bset.b  d2,44(a0,d3.w)
	bset.b  d4,44(a0,d5.w)
	bset.b  d6,44(a0,d7.w)
codeb:


sin1move:	dc.w	2
sin2move:	dc.w	4

point:
	moveq	#0,d4
	move.w	sinpos1,d4
	sub.w	sin1move,d4
	bpl.b	norestart
	add.w	#sinxlen,d4
norestart:
	move.w	d4,sinpos1				

	moveq	#0,d5
	move.w	sinpos2,d5
	sub.w	sin2move,d5
	bpl.s	norestart2
	add.w	#sinylen,d5
norestart2:
	move.w	d5,sinpos2


	move.l	workplane,a0	;a0 = planeadr
	lea	40-2(a0),a0
	lea	sinusxb,a1
	lea	sinusxo,a3
	lea	sinusy,a2
	add.l	d4,a1
	add.l	d4,a3
	add.l	d5,a2

dots=3384-64-64

sinedotcode:	blk.b	dots/8*(codeb-codea),0

rts




codecalc:
	move.w	#(dots/8)-1,d7
	lea	sinedotcode,a0
codecalcl1:
	lea	codea,a1
rept	(codeb-codea)/4
	move.l	(a1)+,(a0)+
endr
	dbf	d7,codecalcl1
	rts


sinxcalc:
	lea	sinusxraw,a0
	lea	sinusxo,a1
	lea	sinusxb,a2
	move.w	#(sinxlen/2)-1,d7
sinxcalcl1:
	moveq	#91,d0
	add.w	d0,d0
	add.w	(a0)+,d0
;	move.w	d0,sinxlen*4(a2)
	move.w	d0,sinxlen*3(a2)
	move.w	d0,sinxlen*2(a2)
	move.w	d0,sinxlen*1(a2)
	move.w	d0,(a2)+

	lsr.w	#3,d0
;	move.w	d0,sinxlen*4(a1)
	move.w	d0,sinxlen*3(a1)
	move.w	d0,sinxlen*2(a1)
	move.w	d0,sinxlen*1(a1)
	move.w	d0,(a1)+
	dbf	d7,sinxcalcl1

rts


sinycalc:
	lea	sinusyraw,a0
	lea	sinusy,a1
	move.w	#(sinylen/2)-1,d7
sinycalcl1:
	moveq	#127,d0
	add.w	(a0)+,d0
	mulu.w	#40,d0
	move.w	d0,(a1)+
	dbf	d7,sinycalcl1


	move.w	#(sinylen/2)-1,d7
	lea	sinusy,a0
	lea	sinylen(a0),a1
sinycopyl1:
	move.w	(a0),sinylen*3(a1)
	move.w	(a0),sinylen*2(a1)
	move.w	(a0),sinylen*1(a1)
	move.w	(a0)+,(a1)+

	dbf	d7,sinycopyl1
rts

sinpos1:	dc.w	0
sinpos2:	dc.w	0




planeslist:
	dc.l	plane_1
	dc.l	plane_2
	dc.l	plane_3
	dc.l	plane_4
	dc.l	plane_5
	dc.l	plane_6
	dc.l	plane_7
	dc.l	plane_8
	dc.l	plane_9
	dc.l	plane_1
	dc.l	plane_2
	dc.l	plane_3
	dc.l	plane_4
	dc.l	plane_5
	dc.l	plane_6
	dc.l	plane_7
	dc.l	plane_8
	dc.l	plane_9

planes:
showplane:
plane1:	dc.l	0
workplane:
plane2:	dc.l	0
clearplane:
plane3:	dc.l	0
shadowplane23:
plane4:	dc.l	0
plane5:	dc.l	0
shadowplane22:
plane6:	dc.l	0
shadowplane13:
plane7:	dc.l	0
shadowplane21:
shadowplane12:
plane8:	dc.l	0
shadowplane11:
plane9:	dc.l	0


switchmark:	dc.w	0

switchplanes:
	lea	switchmark(pc),a0
	move.w	(a0),d0
	addq.w	#4,d0
	cmp.w	#4*9,d0
	bne.b	switchplanesl1
	moveq	#0,d0
switchplanesl1:
	move.w	d0,(a0)
	lea	planeslist,a0
	lea	(a0,d0.w),a0
	lea	planes,a1
	movem.l	(a0),d0-d7/a2
	movem.l	d0-d7/a2,(a1)
	rts
;--------


sinusxraw:
incbin	"data/sinus1.bin"
sinusxrawend:
sinxlen=sinusxrawend-sinusxraw

sinusyraw:
incbin	"data/sinus2.bin"
sinusyrawend:
sinylen=sinusyrawend-sinusyraw

		dc.w	-2			;|
sinuscome:	incbin	"data/sindotcome.bin"	;|
		dc.w	-2			;|




colour1:
dc.w $145,$6AB,$589,$999,$478,$478,$678,$888
dc.w $256,$256,$378,$589,$7AA,$9BC,$CDD,$FFF


colour2:
dc.w $034,$378,$266,$7BC,$155,$7BC,$7BC,$DEF
dc.w $044,$7BC,$7BC,$DEF,$7BC,$DEF,$DEF,$FFF


spritepos1=$7e48
spritepos2=$29a0

sprite10:
dc.w	spritepos1,$1b00+2
	incbin	"data/bar2_0.spr"
	dc.l	0
sprite11:
dc.w	spritepos1+8,$1b00+2
	incbin	"data/bar2_1.spr"
	dc.l	0
sprite12:
dc.w	spritepos1+16,$1b00+2
	incbin	"data/bar2_2.spr"
	dc.l	0
sprite13:
dc.w	spritepos1+24,$1b00+2
	incbin	"data/bar2_3.spr"
	dc.l	0

sprite14:
dc.w	spritepos1+32,$1b00+2
	incbin	"data/bar2_4.spr"
	dc.l	0

sprite15:
dc.w	spritepos1+40,$1b00+2
	incbin	"data/bar2_5.spr"
	dc.l	0

sprite16:
dc.w	spritepos1+48,$1b00+2
	incbin	"data/bar2_6.spr"
	dc.l	0



sprite20:
dc.w	spritepos2,$2900+2
	incbin	"data/alfred2_0.spr"
	dc.l	0
sprite21:
dc.w	spritepos2+8,$2900+2
	incbin	"data/alfred2_1.spr"
	dc.l	0
sprite22:
dc.w	spritepos2+16,$2900+2
	incbin	"data/alfred2_2.spr"
	dc.l	0
sprite23:
dc.w	spritepos2+24,$2900+2
	incbin	"data/alfred2_3.spr"
	dc.l	0

sprite24:
dc.w	spritepos2+32,$2900+2
	incbin	"data/alfred2_4.spr"
	dc.l	0

sprite25:
dc.w	spritepos2+40,$2900+2
	incbin	"data/alfred2_5.spr"
	dc.l	0

sprite26:
dc.w	spritepos2+48,$2900+2
	incbin	"data/alfred2_6.spr"
	dc.l	0


spritee:	dc.l	0


codec_e:

section	chipmem,bss_c
bssc_s:
ds.b	52*4	;buffer for bssc_clear
plane_1:	ds.b	1*256*40
plane_2:	ds.b	1*256*40
plane_3:	ds.b	1*256*40
plane_4:	ds.b	1*256*40
plane_5:	ds.b	1*256*40
plane_6:	ds.b	1*256*40
plane_7:	ds.b	1*256*40
plane_8:	ds.b	1*256*40
plane_9:	ds.b	1*256*40
planes_end:
sinusxo:	ds.b	sinxlen*5
sinusxb:	ds.b	sinxlen*5
sinusy:		ds.b	sinylen*5
bssc_e:

printt	"Section Code Chip:"
printv	codec_e-codec_s
printt	"Section Bss Chip:"
printv	bssc_e-bssc_s
printt
printt	"Chipmem needed:"
printv	codec_e-codec_s+bssc_e-bssc_s
