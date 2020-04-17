;------------------------------------------------------------------------
;|                                                                      |
;|                                 Clown                                |
;|                                -------                               |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                            Jul-94 |
;------------------------------------------------------------------------
usesection=1
;showtime=1
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


;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	jsr	clrchipmem

	move.w	#pictures-1,d7
zoomloop:
	movem.l	d7/a0,-(a7)
	jsr	jameszoom
	subq.w	#1,faktor
	movem.l	(a7)+,d7/a0
	dbf	d7,zoomloop

	move.l	animdatapoint,a1
	lea	james(pc),a0
	move.l	a0,-8(a1)
	move.l	#copperlist_mainpic,-4(a1)

	move.l	#animdata,animdatapoint
	jsr	textcalc
	waitblit
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:	rts
;----------

Main_program:;;
	movem.l	d0-a6,-(a7)
	tst.w	f_secondmaincall
	beq	firstmaincall
	move.l	#0,dircommand
	bra	main_loop

firstmaincall:
	move.w	#1,f_secondmaincall
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)

main_loop:
;	btst.b	#6,ciaapra
;	beq.b	main_exit
	move.l	dircommand,d0
	beq.b	main_loop
	bmi.b	main_exit
	clr.l	dircommand
	move.l	d0,a0
	jsr	(a0)
	bra.b	main_loop

main_exit:
	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	lea	$dff000,a5
;	lea	planeadr,a0
;	move.l	a0,bpl1pth(a5)
	move.w	#1,intflag
	jsr	commander
	rts
;----------

int_james:
	lea	$dff000,a5
	move.w	#%0101001000000000,bplcon0(a5)
	move.l	nextpic,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)

	tst.w	f_copytext
	beq.b	dontcopytext
	jsr	copytext
dontcopytext:

	tst.w	f_showanim
	beq.b	dontshowanim

	subq.w	#1,animsleep
	bne.b	dontshowanim
	move.w	#2,animsleep

	move.l	animdatapoint,a1
	tst.l	8(a1)
	bne.b	noanimrestart
;	lea	animdata(pc),a1
	subq.l	#8,a1
	move.w	#0,f_showanim
noanimrestart:
	move.l	(a1)+,nextpic
	move.l	(a1)+,a0
	move.l	a1,animdatapoint

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	a0,(a1)

;	move.l	animdatapoint,a1
;	tst.l	8(a1)
;	bne	dontshowanim
;	move.w	#300,animsleep

dontshowanim:
	move.w	#1,intflag
	jsr	commander
	waitblit
	rts
;----------

copperlist_mainpic:
	dc.w	bpl1mod,40*4
	dc.w	bpl2mod,40*4
	dc.l	-2



textplanes:	dc.l	textplane1_1,textplane1_2
textplanesize=16*246*2*2

;textplane1_1:	dcb.b	textplanesize,0	;|
;textplane1_2:	dcb.b	textplanesize,0	;|

;textplane2_1:	dcb.b	textplanesize,0	;|
;textplane2_2:	dcb.b	textplanesize,0	;|

;textplane3_1:	dcb.b	textplanesize,0	;|
;textplane3_2:	dcb.b	textplanesize,0	;|


copperlists:	dcb.b	30000,0
james:	incbin	"data/Clown.blt"




codec_e:
datac_s:
datac_e:

;-------------
ifne	usesection
section	memoryc,bss_c
endif
bssc_s:
screens:
dcb.b	238000,0
screens_e:
textplane1_1=screens+80000
textplane1_2=screens+80000+textplanesize
textplane2_1=screens+40000
textplane2_2=screens+40000+textplanesize
textplane3_1=screens
textplane3_2=screens+textplanesize
bssc_e:
;-------------
ifne	usesection
section	pcode,code_p
endif
codep_s:
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
;		dc.l	470-290,	nothing
		dc.l	240,	setint_james
		dc.l	8,	setwriteallpages
		dc.l	350,	text1down
		dc.l	100,	textup
		dc.l	350,	text2down
		dc.l	100,	textup
		dc.l	100,	text3down
		dc.l	250,	copytextoff
		dc.l	240,	endmosaikon
		dc.l	1,	setente
		dc.l	60000,	nothing
;---------------------------------------------
nothing:	rts

commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	move.w	#1,f_endprogram
	move.l	#-1,dircommand
	rts

text1down:
	move.w	#1,f_copytext
	move.l	#textplane1_1,textplanes
	move.l	#textplane1_2,textplanes+4
	move.w	#4,textsinusadd
;	move.l	#writepage,dircommand
rts

text2down:
	move.l	#textplane2_1,textplanes
	move.l	#textplane2_2,textplanes+4
	move.w	#4,textsinusadd
;	move.l	#writepage,dircommand
rts

text3down:
	move.l	#textplane3_1,textplanes
	move.l	#textplane3_2,textplanes+4
	move.w	#4,textsinusadd
;	move.l	#writepage,dircommand
rts

textup:
	move.w	#-4,textsinusadd
rts

setwriteallpages:
	move.l	#writeallpages,dircommand
rts
	
copytextoff:
	move.w	#0,f_copytext
	move.l	#makemosaik2,dircommand
	rts

endmosaikon:
	move.l	#animdata,animdatapoint
	move.w	#1,f_showanim
	rts

setint_james:
	move.l	#$298129c1,diwstrt(a5)
	move.l	#$003800d0,ddfstrt(a5)
	move.l	#0,bplcon1(a5)
	move.w	#160,bpl1mod(a5)
	move.w	#160,bpl2mod(a5)
;	move.w	#%0101001000000000,bplcon0(a5)

	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#int_james,(a0)

;	lea	main_copperlist,a1
;	move.l	(a1),a1
;	move.l	#copperlist,(a1)

	lea	jamescol,a0
	lea	$180(a5),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	#1,f_showanim
	lea	main_copperlist,a0
	move.l	(a0),a0
	move.l	#copperlists,(a0)
	rts

jameszoom:
	moveq	#0,d0
	move.l	d0,readxpos
	move.w	d0,writeypos

	moveq	#0,d0
	move.w	faktor,d0
	swap.w	d0
	move.l	d0,readxadd
	move.l	d0,readyadd

	moveq	#0,d0
	move.w	#320,d0
	moveq	#0,d1
	move.w	#256,d1
	move.w	faktor(pc),d2
	divu	d2,d0
	divu	d2,d1
	move.w	d0,readxqnt
	move.w	d1,readyqnt

	lea	animdatapoint,a6
	move.l	(a6),a0
	move.l	(a0)+,a1		;screen
	move.l	(a0)+,a4		;copperlist
	move.l	a0,(a6)
	lea	multab,a6

	lea	james,a0
	move.l	#$240ffffe,(a4)+
;	move.w	#bplcon0,(a4)+
;	move.w	#%0101001000000000,(a4)+
	move.w	#$220f,d5

	move.l	#0,readypos
	move.w	readyqnt,d7
james_y:

james_calcline:
	move.w	#bpl1mod,(a4)+
	move.w	#40*4,(a4)+
	move.w	#bpl2mod,(a4)+
	move.w	#40*4,(a4)+
	add.w	#$0100,d5
	move.w	d5,(a4)+
	move.w	#-2,(a4)+

	add.l	#40*5,mem

	move.w	readxqnt(pc),d6
	move.l	#0,readxpos
	moveq	#0,d4		;set/clr mode bits for all planes
james_x:
	moveq	#0,d0
	move.w	readxpos(pc),d0
	move.w	readypos(pc),d1
	move.w	d0,d2
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a6,d1.w),d1
	lsr.w	#3,d0
	sub.l	d0,d1
	lea	40(a0,d1.l),a2

;	moveq	#0,d0
;	move.w	readxpos(pc),d0
;	move.w	writeypos(pc),d1
;	move.w	d0,d3
;	add.w	d1,d1
;	add.w	d1,d1
;	move.l	(a6,d1.w),d1
;	lsr.w	#3,d0
;	sub.l	d0,d1
;	lea	40(a1,d1.l),a3

	move.w	writeypos(pc),d1
	move.w	d0,d3
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a6,d1.w),d1
	sub.l	d0,d1
	lea	40(a1,d1.l),a3

;---------------------------
;james_p1:
	moveq	#0,d0
	btst.b	d2,40*0(a2)
	beq.b	james_nop1
	btst.l	d0,d4
	bne.b	james_p1done
	bset.l	d0,d4
	bset.b	d2,40*0(a3)
	bra.b	james_p1done
james_nop1:
	btst.l	d0,d4
	beq.b	james_p1done
	bclr.l	d0,d4
	bset.b	d2,40*0(a3)
james_p1done:

;james_p2:
	moveq	#1,d0
	btst.b	d2,40*1(a2)
	beq.b	james_nop2
	btst.l	d0,d4
	bne.b	james_p2done
	bset.l	d0,d4
	bset.b	d2,40*1(a3)
	bra.b	james_p2done
james_nop2:
	btst.l	d0,d4
	beq.b	james_p2done
	bclr.l	d0,d4
	bset.b	d2,40*1(a3)
james_p2done:

;james_p3:
	moveq	#2,d0
	btst.b	d2,40*2(a2)
	beq.b	james_nop3
	btst.l	d0,d4
	bne.b	james_p3done
	bset.l	d0,d4
	bset.b	d2,40*2(a3)
	bra.b	james_p3done
james_nop3:
	btst.l	d0,d4
	beq.b	james_p3done
	bclr.l	d0,d4
	bset.b	d2,40*2(a3)
james_p3done:

;james_p4:
	moveq	#3,d0
	btst.b	d2,40*3(a2)
	beq.b	james_nop4
	btst.l	d0,d4
	bne.b	james_p4done
	bset.l	d0,d4
	bset.b	d2,40*3(a3)
	bra.b	james_p4done
james_nop4:
	btst.l	d0,d4
	beq.b	james_p4done
	bclr.l	d0,d4
	bset.b	d2,40*3(a3)
james_p4done:

;james_p5:
	moveq	#4,d0
	btst.b	d2,40*4(a2)
	beq.b	james_nop5
	btst.l	d0,d4
	bne.b	james_p5done
	bset.l	d0,d4
	bset.b	d2,40*4(a3)
	bra.b	james_p5done
james_nop5:
	btst.l	d0,d4
	beq.b	james_p5done
	bclr.l	d0,d4
	bset.b	d2,40*4(a3)
james_p5done:


;---
	move.l	readxpos(pc),d1
	add.l	readxadd(pc),d1
	move.l	d1,readxpos
	dbf	d6,james_x
	addq.w	#1,writeypos
;-----
	move.w	faktor(pc),d2
	subq.w	#1,d2
	beq.b	james_skipyzoom

	move.w	#bpl1mod,(a4)+
	move.w	#-40*1,(a4)+
	move.w	#bpl2mod,(a4)+
	move.w	#-40*1,(a4)+
;	mulu.w	#$0100,d2
	lsl.w	#8,d2
	add.w	d2,d5
	bcc.b	.noborder
	move.l	#$ffe1fffe,(a4)+
.noborder:
	move.w	d5,(a4)+
	move.w	#-2,(a4)+
;-----

james_skipyzoom:
	move.l	readypos(pc),d1
	add.l	readyadd(pc),d1
	move.l	d1,readypos

james_skipline:
	dbf	d7,james_y

;	move.w	#bplcon0,(a4)+
;	move.w	#%0000001000000000,(a4)+
	move.l	#-2,(a4)+
	bsr.b	fill
	move.l	animdatapoint,a1
	lea	screens,a0
	add.l	mem(pc),a0
	move.l	a0,(a1)+
	move.l	a4,(a1)
rts

fill:
	move.w	writeypos(pc),d1
	move.w	d1,d2

	mulu.w	#5*64,d1
	add.w	#20,d1

	mulu.w	#40*5,d2
	subq.l	#2,d2

	move.l	a1,d0
	add.l	d2,d0
waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#0,bltamod(A5)
	MOVE.w	#0,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000010010,bltcon0(a5);0+1 con
	MOVE.l	#%11111111111111111111111111111111,bltafwm(a5)
	move.w	d1,BLTSIZE(A5)
	rts

writeallpages:
	move.l	#textplane1_1,textplanes
	move.l	#textplane1_2,textplanes+4
	bsr	clrtextscreen
	bsr	writepage

	move.l	#textplane2_1,textplanes
	move.l	#textplane2_2,textplanes+4
	bsr	clrtextscreen
	bsr	writepage

	move.l	#textplane3_1,textplanes
	move.l	#textplane3_2,textplanes+4
	bsr	clrtextscreen
	bsr	writepage
	move.l	#-1,dircommand
rts


clrtextscreen:
	move.l	textplanes,a0
	move.w	#textplanesize*2/4-1,d7
	moveq	#0,d0
clrtextscreenloop:
	move.l	d0,(a0)+
	dbf	d7,clrtextscreenloop
	rts

writepage:
	move.l	textpoint,a1
	lea	clownfont,a2
	lea	james,a0
	add.w	#40*5*19+18,a0
	move.l	textplanes,a0
	moveq	#14,d5
writey:
	moveq	#7,d6
writex:
	move.w	(a1)+,d0
	lea	(a2,d0.w),a3
	moveq	#13,d7
writechar1:
	move.b	(a3)+,(a0) 
	move.b	(a3)+,16(a0) 
	lea	16*2(a0),a0
	dbf	d7,writechar1
	lea	1-14*16*2(a0),a0


	move.w	(a1)+,d0
	lea	(a2,d0.w),a3
	moveq	#13,d7
writechar2:
	move.b	(a3)+,textplanesize(a0) 
	move.b	(a3)+,textplanesize+16(a0) 
	lea	16*2(a0),a0
	dbf	d7,writechar2
	lea	1-14*16*2(a0),a0

	dbf	d6,writex
	lea	16*2*15-16(a0),a0
	dbf	d5,writey
	move.l	a1,textpoint
	rts


charsize=1*14*2
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
	beq.b	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------

copytext:
	lea	textsinuspoint,a2
	move.w	(a2)+,d0
	move.w	(a2)+,d1
	add.w	d1,d0
	move.w	126(a2,d0.w),d2
	bpl.b	.noflow
	sub.w	d1,d0
	move.w	126(a2,d0.w),d2
.noflow:
	move.w	d0,-4(a2)
	add.w	d1,d1

	lea	james+8*40*5+18,a0
	move.l	textplanes,a1
	move.l	textplanes+4,a4

	moveq	#7,d7
copyloop:
	sub.w	d1,d0
	move.w	126(a2,d0.w),d2
	bpl.b	.noflow1
	add.w	d1,d0
	move.w	126(a2,d0.w),d2
.noflow1:
	lea	(a1,d2.w),a3
	sub.w	d1,d0
	move.w	126(a2,d0.w),d2
	bpl.b	.noflow2
	add.w	d1,d0
	move.w	126(a2,d0.w),d2
.noflow2:

	lea	(a4,d2.w),a6

	waitblit
	move.l	a3,bltapth(a5)
	move.l	a6,bltbpth(a5)
	move.l	a0,bltdpth(a5)
	move.w	#32-2,bltamod(a5)
	move.w	#32-2,bltbmod(a5)
	move.w	#(40-2)+4*40,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000110111111100,bltcon0(a5)
	move.w	#246*1*64+1,bltsize(a5)

	lea	40(a0),a0
	lea	16(a3),a3
	lea	16(a6),a6
	waitblit
	move.l	a3,bltapth(a5)
	move.l	a6,bltbpth(a5)
	move.l	a0,bltdpth(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000110111111100,bltcon0(a5)
	move.w	#246*1*64+1,bltsize(a5)

	lea	2-40(a0),a0
	addq.l	#2,a1
	addq.l	#2,a4

	dbf	d7,copyloop
rts


clrchipmem:
	lea	screens,a0
	move.w	#(screens_e-screens)/4-1,d7
screenclr:
	move.l	#0,(a0)+
	dbf	d7,screenclr
	rts

makemosaik2:
	bsr.b	clrchipmem

	addq.w	#1,faktor

	move.l	#animdata,animdatapoint
	move.l	#0,mem
	move.w	#pictures-1,d7
zoomloop2:
	movem.l	d7/a0,-(a7)
	bsr.w	jameszoom
	addq.w	#1,faktor
	movem.l	(a7)+,d7/a0
	dbf	d7,zoomloop2

	move.l	animdatapoint,a1
	moveq	#0,d0
	move.l	d0,-8(a1)
	move.l	d0,-4(a1)
waitblit
rts




f_showanim:	dc.w	0
f_copytext:	dc.w	0
f_secondmaincall:	dc.w	0

Clownfont:	incbin	"data/clownfont.blt"

mulpoint:	set	0
multab:
rept	256
	dc.l	mulpoint*40*5
mulpoint:	set	mulpoint+1
endr

animsleep:	dc.w	1
nextpic:	dc.l	screens

zoomx:		dc.l	0
zoomy:		dc.l	0

screenx:	dc.w	0
screeny:	dc.w	0


mem:		dc.l	0
pics:		dc.l	0


faktor:	dc.w	pictures+1

readxpos:	dc.l	0
readxadd:	dc.l	0	;65536*faktor

readypos:	dc.l	0
readyadd:	dc.l	0	;65536*faktor

writeypos:	dc.w	0

readxqnt:	dc.w	0	;320/faktor
readyqnt:	dc.w	0	;256/faktor

;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789:.-()"
charsend:
even
textpoint:	dc.l	text
text:;
;dc.b	"1234567890123456"

dc.b	"                "
dc.b	"                "
dc.b	"for swapping    "
dc.b	"contact us at:  "
dc.b	"(only legal)    "
dc.b	"                "
dc.b	"                "
dc.b	"                "
dc.b	"           toxic"
dc.b	"      sven dedek"
dc.b	" gruenewaldstr.6"
dc.b	" 84453 muehldorf"
dc.b	"         germany"
dc.b	"                "
dc.b	"                "


dc.b	"                "
dc.b	"          qwerty"
dc.b	"    adrian dolny"
dc.b	"   woj. kaliskie"
dc.b	"    62850 liskow"
dc.b	"          poland"
dc.b	"                "
dc.b	"                "
dc.b	"                "
dc.b	"pink            "
dc.b	"manfred linzner "
dc.b	"rpt. mayer str.2"
dc.b	"81379 muenchen  "
dc.b	"germany         "
dc.b	"                "


dc.b	"                "
dc.b	"                "
dc.b	"                "
dc.b	"not for swapping"
dc.b	"but pure        "
dc.b	"friendship      "
dc.b	"write to:       "
dc.b	"                "
dc.b	"            moon"
dc.b	"      po.box 162"
dc.b	"  a-5400 hallein"
dc.b	"         austria"
dc.b	"                "
dc.b	"                "
dc.b	"                "


textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

jamescol:
	dc.w $000,$555,$666,$777,$030,$999,$CCC,$FFF
	dc.w $111,$AAA,$BBB,$222,$DDD,$EEE,$333,$200
	dc.w $400,$601,$811,$A22,$C43,$D64,$F86,$444
	dc.w $110,$330,$551,$762,$884,$AA6,$CC8,$EEB


textsinuspoint:	dc.w	0	;|
textsinusadd:	dc.w	0	;|
dcb.w	63,-1			;|
textsinus:			;|
dcb.w	63,7872
dc.W  7872, 7744, 7584, 7456, 7328, 7200, 7040, 6912, 6784
dc.W  6656, 6496, 6368, 6240, 6112, 5952, 5824, 5696, 5568
dc.W  5440, 5312, 5184, 5056, 4928, 4800, 4672, 4544, 4416
dc.W  4288, 4192, 4064, 3936, 3808, 3712, 3584, 3456, 3360
dc.W  3232, 3136, 3040, 2912, 2816, 2720, 2592, 2496, 2400
dc.W  2304, 2208, 2112, 2016, 1920, 1856, 1760, 1664, 1600
dc.W  1504, 1408, 1344, 1280, 1184, 1120, 1056, 992, 928
dc.W  864, 800, 736, 672, 640, 576, 512, 480, 416, 384, 352
dc.W  320, 256, 224, 192, 160, 160, 128, 96, 64, 64, 32, 32
dc.W  32, 0, 0, 0
dcb.w	63,0
dcb.w	64,-1

pictures=120

animdatapoint:	dc.l	animdata
animdata:	
dc.l	screens
dc.l	copperlists
dcb.l	(pictures+1)*4,0


codep_e:
;-------------
datap_s:
datap_e:
bssp_s:
bssp_e:

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


