;------------------------------------------------------------------------
;|                                                                      |
;|                            RedGreenBlue                              |
;|                           --------------                             |
;|                                                                      |
;| code by Moon/ABYSS                                                   |
;------------------------------------------------------------------------
usesection=1

ifne	usesection
section	code,code_c
endif
codec_s:



showtime=0
Program_ID=1
Main_Initcall2=1
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"


f_endprogram:	dc.w	0
f_dream:	dc.w	0
f_colmix:	dc.w	0
f_setpic:	dc.w	0
f_waitfader:	dc.w	1
f_firstinit:	dc.w	0

commands:;;
		dc.l	100,	setint_rgb
		dc.l	1,	clr_waitfader
		dc.l	450,	setdream2
		dc.l	300,	setdream1
		dc.l	200,	setdream2
		dc.l	200,	setdream1
		dc.l	220,	setdream2


		dc.l	1,	dreamoff
		dc.l	70,	setpicon	;skull
		dc.l	150,	setdream2
		dc.l	90,	setdream1
		dc.l	1,	colmixoff

		dc.l	1,	dreamoff
		dc.l	70,	setpicon	;child
		dc.l	150,	setdream1

		dc.l	1,	dreamoff
		dc.l	70,	setpicon	;vulcanman
		dc.l	40,	colmixon
		dc.l	100,	setdream1
		dc.l	1,	colmixoff


		dc.l	1,	dreamoff
		dc.l	1,	colmixoff
		dc.l	50,	setpicon	;skidriver
		dc.l	150,	setdream1

		dc.l	150,	setdream2
		dc.l	144+71,	setdream1
;		dc.l	71,	borderoff
		dc.l	40,	setdream2
		dc.l	40,	setdream1
		dc.l	1,	dreamoff

		dc.l	1,	set_f_endprogram
		dc.l	60000,	nothing
;---------------------------------------------
nothing:	rts

set_f_endprogram:
	move.w	#1,f_endprogram
	rts

clr_waitfader:
	move.w	#0,f_waitfader
	rts

;borderoff:
;	move.w	#$0003,$dff1be
;	rts

dreamon:
	move.w	#1,f_dream
	rts

dreamoff:
	move.w	#0,f_dream
	rts

colmixon:
	move.w	#1,f_colmix
	rts

colmixoff:
	move.w	#0,f_colmix
	rts

setpicon:
	move.w	#1,f_setpic
	rts

commandrestart:
	lea	Commander_Point(pc),a0
	move.w	#0,(a0)
	rts

setdream1:
	move.w	#1,f_dream
	move.l	#rgbdream1,rgbtable
rts

setdream2:
	move.w	#1,f_dream
	move.l	#rgbdream2,rgbtable
rts


screenx=$b1+16
screensize=192+16
x:	set	screenx+screensize-$100
printt	"diwstop"
printv	x
y:	set	((screenx-17)/2)&$fff8
printt	"ddfstrt"
printv	y
z:	set	y+(screensize/2)-8
printt	"ddfstop"
printv	z

setint_rgb:
	move.w	#$29c1,diwstrt(a5)
	move.w	#$2991,diwstop(a5)
	move.w	#$0058,ddfstrt(a5)
	move.w	#$00b8,ddfstop(a5)
	move.w	#68,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#40*4+14,bpl1mod(a5)
	move.w	#40*4+14,bpl2mod(a5)
	move.w	#%0101001000000000,bplcon0(a5)
	move.w	#$0003,$dff180
;	move.w	#$0fff,$dff1be
	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	tst.w	f_firstinit
	bne.b	maininit_secondinit
	move.w	#1,f_firstinit
	bsr.w	precalc1
	bra.b	maininit_exit
maininit_secondinit:
	bsr.w	precalc2

	lea	copperlist1,a0
	bsr.w	coppercopy
	bsr.w	drawblock4
	bsr.w	copperexpand

	lea	copperlist2,a0
	bsr.w	coppercopy
	bsr.w	drawblock4
	bsr.w	copperexpand
;	bsr	copperexpand
	bsr.w	switchcopper
	bsr.w	fader2_xxx
maininit_exit:
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	rts
;----------

Main_program:;;
	lea	Main_VBIVector,a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#-1,(a1)

	bsr.w	Fader2Start_xxx
	lea	col_src,a0
	lea	$180(a5),a1
rept	16
	move.l	(a0)+,(a1)+
endr
waitfader:
	tst.w	f_waitfader
	bne.b	waitfader

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	copperlist,(a1)
	bsr.w	switchcopper


main_loop:
	move.w	#0,intflag
	btst.b	#6,ciaapra
;	beq	mainloop_exit
	tst.w	f_endprogram
	bne.b	mainloop_exit

;-------
	tst.w	f_dream
	beq.b	nodream
	bsr.w	switchcopper
	tst.w	f_colmix
	bne.b	yescolmix
	bsr.w	dream
	bra.b	nodream
yescolmix:
	bsr.w	dream0
nodream:
;-------
;-------
	tst.w	f_colmix
	beq.b	nocolmix
;	tst.w	f_dream
;	bne	yesdream
	bsr.w	colmix
	bsr.w	copperexpand
;yesdream:
nocolmix:
;-------
;-------
	tst.w	f_setpic
	beq.b	nosetpic
	bsr.w	setpic
nosetpic:
;-------

	bsr.w	drawblock4
;	bsr	copperexpand

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	copperlist,(a1)
	move.l	copperlist,cop1lch(a5)


move.w	intflag,look
intsleep:
	cmp.w	#2,intflag
	ble.b	intsleep



	bra.w	main_loop

look:	dc.l	0

mainloop_exit:
	rts

main_intuser:;;
	lea	$dff000,a5
	lea	pattern,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)

	addq.w	#1,intflag
	bsr.w	fader2_real
	jsr	commander
	rts
;----------

switchcopper:
	lea	copperlist,a0
	move.l	(a0)+,d0
	move.l	(a0),-(a0)
	move.l	d0,4(a0)
	rts

colreglist:
	dc.w	$182
	dc.w	$184
	dc.w	$186
	dc.w	$188
	dc.w	$18a
	dc.w	$18c
	dc.w	$18e
	dc.w	$190
	dc.w	$192
	dc.w	$194
	dc.w	$196
	dc.w	$198
	dc.w	$19a
	dc.w	$19c
	dc.w	$19e
	dc.w	$1a0
	dc.w	$1a2
	dc.w	$1a4
	dc.w	$1a6
	dc.w	$1a8
	dc.w	$1aa
	dc.w	$1ac
	dc.w	$1ae
	dc.w	$1b0
	dc.w	$1b2
	dc.w	$1b4
	dc.w	$1b6
	dc.w	$1b8
	dc.w	$1ba
	dc.w	$1bc

	dc.w	$182
	dc.w	$184
	dc.w	$186
	dc.w	$188
	dc.w	$18a
	dc.w	$18c
	dc.w	$18e
	dc.w	$190
	dc.w	$192
	dc.w	$194
	dc.w	$196
	dc.w	$198
	dc.w	$19a
	dc.w	$19c
	dc.w	$19e

	dc.w	$182
	dc.w	$184
	dc.w	$186
	dc.w	$188
	dc.w	$18a
	dc.w	$18c
	dc.w	$18e


coppercopy:
;	lea	copperlist(pc),a0
	move.w	#$2451,d0
	move.w	#$24d5-2-2-2-2,d0
	moveq	#ysize-1,d7
coppercopyl1:
	moveq	#3,d6
coppercopyl2:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+

	moveq	#xsize-1,d5
	lea	colreglist(pc),a1
coppercopyl3:
;	move.w	#$180,(a0)+
	move.w	(a1)+,(a0)+
;	move.w	$dff006,(a0)+
	move.w	#0,(a0)+
	dbf	d5,coppercopyl3
;	move.l	#$01800000,(a0)+
	add.w	#$0100,d0
	dbf	d6,coppercopyl2
	dbf	d7,coppercopyl1
	move.l	#-2,(a0)
rts

copperexpand:
	move.l	copperlist(pc),a0
	addq.w	#4+2,a0			;skip first wait
	moveq	#ysize-1,d7
copperexpandl1:
;	moveq	#xsize-1,d6
;copperexpandl2:
rept	48
	move.w	(a0),1*lsize(a0)
	move.w	(a0),2*lsize(a0)
	move.w	(a0),3*lsize(a0)
	addq.w	#4,a0
endr
;	dbf	d6,copperexpandl2
	lea	lsize*3+4(a0),a0
	dbf	d7,copperexpandl1
	rts



dreamsinpoint:	dc.w	0
Dream0:
	lea	turnsin,a0
	move.w	dreamsinpoint(pc),d0
	addq.w	#4,d0
	move.w	(a0,d0.w),d1
	bpl.b	Dream0_noturnsinrestart
	moveq	#0,d0
	move.w	turnsin,d1

Dream0_noturnsinrestart:
	move.w	d0,dreamsinpoint
	lsr.w	#1,d1
	mulu.w	#animpicsize,d1

	move.l	copperlist,a0
	move.l	copperlist+4,a1
	addq.w	#4+2,a0			;skip first wait+$0180
	addq.w	#4+2,a1			;skip first wait+$0180
	lea	30000(a1),a1

	move.l	rgbtable(pc),a2
	add.l	d1,a2

	moveq	#ysize-1,d7
Dream0l1:
;	moveq	#xsize-1,d6
;Dream0l2:

rept	3
	movem.l	(a2)+,d0-d6

	move.w	(a1,d0.w),04(a0)
	swap	d0
	move.w	(a1,d0.w),00(a0)

	move.w	(a1,d1.w),12(a0)
	swap	d1
	move.w	(a1,d1.w),08(a0)

	move.w	(a1,d2.w),20(a0)
	swap	d2
	move.w	(a1,d2.w),16(a0)

	move.w	(a1,d3.w),28(a0)
	swap	d3
	move.w	(a1,d3.w),24(a0)

	move.w	(a1,d4.w),36(a0)
	swap	d4
	move.w	(a1,d4.w),32(a0)

	move.w	(a1,d5.w),44(a0)
	swap	d5
	move.w	(a1,d5.w),40(a0)

	move.w	(a1,d6.w),52(a0)
	swap	d6
	move.w	(a1,d6.w),48(a0)

	lea	56(a0),a0
endr
	movem.l	(a2)+,d0-d2

	move.w	(a1,d0.w),04(a0)
	swap	d0
	move.w	(a1,d0.w),00(a0)

	move.w	(a1,d1.w),12(a0)
	swap	d1
	move.w	(a1,d1.w),08(a0)

	move.w	(a1,d2.w),20(a0)
	swap	d2
	move.w	(a1,d2.w),16(a0)
	lea	24(a0),a0

;	dbf	d6,Dream0l2
	add.w	#lsize*3+4,a0
	dbf	d7,Dream0l1
rts


dream:
	lea	turnsin,a0
	move.w	dreamsinpoint(pc),d0
	addq.w	#4,d0
	move.w	(a0,d0.w),d1
	bpl.b	noturnsinrestart
	moveq	#0,d0
	move.w	turnsin,d1

noturnsinrestart:
	move.w	d0,dreamsinpoint
	lsr.w	#1,d1
	mulu.w	#animpicsize,d1

	move.l	copperlist,a0
	move.l	copperlist+4,a1
	addq.w	#4+2,a0			;skip first wait+$0180
	addq.w	#4+2,a1			;skip first wait+$0180
	lea	30000(a1),a1

	move.l	rgbtable(pc),a2
	add.l	d1,a2

	moveq	#ysize-1,d7
dreaml1:
;	moveq	#xsize-1,d6
;dreaml2:

rept	3
	movem.l	(a2)+,d0-d6

	move.w	(a1,d0.w),d0
	move.w	d0,0*lsize+04(a0)
	move.w	d0,1*lsize+04(a0)
	move.w	d0,2*lsize+04(a0)
	move.w	d0,3*lsize+04(a0)
	swap	d0
	move.w	(a1,d0.w),d0
	move.w	d0,0*lsize+00(a0)
	move.w	d0,1*lsize+00(a0)
	move.w	d0,2*lsize+00(a0)
	move.w	d0,3*lsize+00(a0)

	move.w	(a1,d1.w),d1
	move.w	d1,0*lsize+12(a0)
	move.w	d1,1*lsize+12(a0)
	move.w	d1,2*lsize+12(a0)
	move.w	d1,3*lsize+12(a0)
	swap	d1
	move.w	(a1,d1.w),d1
	move.w	d1,0*lsize+08(a0)
	move.w	d1,1*lsize+08(a0)
	move.w	d1,2*lsize+08(a0)
	move.w	d1,3*lsize+08(a0)

	move.w	(a1,d2.w),d2
	move.w	d2,0*lsize+20(a0)
	move.w	d2,1*lsize+20(a0)
	move.w	d2,2*lsize+20(a0)
	move.w	d2,3*lsize+20(a0)
	swap	d2
	move.w	(a1,d2.w),d2
	move.w	d2,0*lsize+16(a0)
	move.w	d2,1*lsize+16(a0)
	move.w	d2,2*lsize+16(a0)
	move.w	d2,3*lsize+16(a0)

	move.w	(a1,d3.w),d3
	move.w	d3,0*lsize+28(a0)
	move.w	d3,1*lsize+28(a0)
	move.w	d3,2*lsize+28(a0)
	move.w	d3,3*lsize+28(a0)
	swap	d3
	move.w	(a1,d3.w),d3
	move.w	d3,0*lsize+24(a0)
	move.w	d3,1*lsize+24(a0)
	move.w	d3,2*lsize+24(a0)
	move.w	d3,3*lsize+24(a0)

	move.w	(a1,d4.w),d4
	move.w	d4,0*lsize+36(a0)
	move.w	d4,1*lsize+36(a0)
	move.w	d4,2*lsize+36(a0)
	move.w	d4,3*lsize+36(a0)
	swap	d4
	move.w	(a1,d4.w),d4
	move.w	d4,0*lsize+32(a0)
	move.w	d4,1*lsize+32(a0)
	move.w	d4,2*lsize+32(a0)
	move.w	d4,3*lsize+32(a0)

	move.w	(a1,d5.w),d5
	move.w	d5,0*lsize+44(a0)
	move.w	d5,1*lsize+44(a0)
	move.w	d5,2*lsize+44(a0)
	move.w	d5,3*lsize+44(a0)
	swap	d5
	move.w	(a1,d5.w),d5
	move.w	d5,0*lsize+40(a0)
	move.w	d5,1*lsize+40(a0)
	move.w	d5,2*lsize+40(a0)
	move.w	d5,3*lsize+40(a0)

	move.w	(a1,d6.w),d6
	move.w	d6,0*lsize+52(a0)
	move.w	d6,1*lsize+52(a0)
	move.w	d6,2*lsize+52(a0)
	move.w	d6,3*lsize+52(a0)
	swap	d6
	move.w	(a1,d6.w),d6
	move.w	d6,0*lsize+48(a0)
	move.w	d6,1*lsize+48(a0)
	move.w	d6,2*lsize+48(a0)
	move.w	d6,3*lsize+48(a0)

	lea	56(a0),a0
endr
	movem.l	(a2)+,d0-d2

	move.w	(a1,d0.w),d0
	move.w	d0,0*lsize+04(a0)
	move.w	d0,1*lsize+04(a0)
	move.w	d0,2*lsize+04(a0)
	move.w	d0,3*lsize+04(a0)
	swap	d0
	move.w	(a1,d0.w),d0
	move.w	d0,0*lsize+00(a0)
	move.w	d0,1*lsize+00(a0)
	move.w	d0,2*lsize+00(a0)
	move.w	d0,3*lsize+00(a0)

	move.w	(a1,d1.w),d1
	move.w	d1,0*lsize+12(a0)
	move.w	d1,1*lsize+12(a0)
	move.w	d1,2*lsize+12(a0)
	move.w	d1,3*lsize+12(a0)
	swap	d1
	move.w	(a1,d1.w),d1
	move.w	d1,0*lsize+08(a0)
	move.w	d1,1*lsize+08(a0)
	move.w	d1,2*lsize+08(a0)
	move.w	d1,3*lsize+08(a0)

	move.w	(a1,d2.w),d2
	move.w	d2,0*lsize+20(a0)
	move.w	d2,1*lsize+20(a0)
	move.w	d2,2*lsize+20(a0)
	move.w	d2,3*lsize+20(a0)
	swap	d2
	move.w	(a1,d2.w),d2
	move.w	d2,0*lsize+16(a0)
	move.w	d2,1*lsize+16(a0)
	move.w	d2,2*lsize+16(a0)
	move.w	d2,3*lsize+16(a0)
	lea	24(a0),a0

;	dbf	d6,dreaml2
	lea	lsize*3+4(a0),a0
	dbf	d7,dreaml1
rts



Colmixrouts:
	dc.l	colmix1
	dc.l	colmix3
	dc.l	colmix2
	dc.l	colmix4

Colmix:
	lea	colmixrouts(pc),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	move.l	d0,a0
	jsr	(a0)
rts	

Colmix1:
	move.l	copperlist(pc),a0
	addq.w	#4+2,a0			;skip first wait+$0180
	moveq	#0,d0
	move.w	#%000000000000111011101110,d6
	moveq	#ysize-1,d7
Colmix1l1:
rept	48-1
	move.w	(a0),d3		;first col RGB
	move.w	4(a0),d0	;second col RGB
	and.w	d6,d0
	and.w	d6,d3
	add.w	d3,d0
	lsr.w	#1,d0
	move.w	d0,(a0)
	addq.w	#4,a0
endr
	lea	lsize*3+4+4(a0),a0
	dbf	d7,Colmix1l1
rts


Colmix2:
	move.l	copperlist(pc),a0
	addq.w	#4+2,a0			;skip first wait+$0180
	moveq	#0,d0
	move.w	#%000000000000111011101110,d6
	moveq	#ysize-1,d7
Colmix2l1:
	lea	(48-1)*4(a0),a0
rept	48-1
	move.w	-4(a0),d3		;first col RGB
	move.w	(a0),d0	;second col RGB
	and.w	d6,d0
	and.w	d6,d3
	add.w	d3,d0
	lsr.w	#1,d0
	move.w	d0,(a0)
	subq.w	#4,a0
endr
	lea	lsize*4(a0),a0
	dbf	d7,Colmix2l1
rts


Colmix3:
	move.l	copperlist(pc),a0
	addq.w	#4+2,a0			;skip first wait+$0180
	moveq	#0,d0
	move.w	#%000000000000111011101110,d6
	moveq	#ysize-1-1,d7
Colmix3l1:
rept	48
	move.w	(a0),d3		;first col RGB
	move.w	lsize*4(a0),d0	;second col RGB
	and.w	d6,d0
	and.w	d6,d3
	add.w	d3,d0
	lsr.w	#1,d0
	move.w	d0,(a0)
	addq.w	#4,a0
endr
	lea	lsize*3+4(a0),a0
	dbf	d7,Colmix3l1
rts

Colmix4:
	move.l	copperlist(pc),a0
	addq.w	#4+2,a0			;skip first wait+$0180
	moveq	#0,d0
	move.w	#%000000000000111011101110,d6
	moveq	#ysize-1-1,d7
	add.l	#(lsize*4)*(ysize-1),a0
Colmix4l1:
rept	48
	move.w	(a0),d3		;first col RGB
	move.w	lsize*4(a0),d0	;second col RGB
	and.w	d6,d0
	and.w	d6,d3
	add.w	d3,d0
	lsr.w	#1,d0
	move.w	d0,lsize*4(a0)
	addq.w	#4,a0
endr
	lea	lsize*3+4-(2*(lsize*4))(a0),a0
	dbf	d7,Colmix4l1
rts


picpos:	dc.w	0

setpic:
	move.w	#0,f_setpic
	move.l	copperlist,a0
	addq.w	#4+2,a0			;skip first wait+$0180

	lea	pictab,a1
	move.w	picpos,d0
	add.w	#6144,d0
	cmp.w	#6144*4,d0
	bne.b	noabyssrestart
	moveq	#0,d0

noabyssrestart:
	move.w	d0,picpos
	add.w	d0,a1

	moveq	#0,d0
	moveq	#ysize-1,d7
setpicl1:

;	moveq	#xsize-1,d6
;setpicl2:
rept	3
	movem.l	(a1)+,d0-d6

	or.w	d0,04(a0)
	swap	d0
	or.w	d0,00(a0)

	or.w	d1,12(a0)
	swap	d1
	or.w	d1,08(a0)

	or.w	d2,20(a0)
	swap	d2
	or.w	d2,16(a0)

	or.w	d3,28(a0)
	swap	d3
	or.w	d3,24(a0)

	or.w	d4,36(a0)
	swap	d4
	or.w	d4,32(a0)

	or.w	d5,44(a0)
	swap	d5
	or.w	d5,40(a0)

	or.w	d6,52(a0)
	swap	d6
	or.w	d6,48(a0)

	lea	56(a0),a0
endr
	movem.l	(a1)+,d0-d2

	or.w	d0,04(a0)
	swap	d0
	or.w	d0,00(a0)

	or.w	d1,12(a0)
	swap	d1
	or.w	d1,08(a0)

	or.w	d2,20(a0)
	swap	d2
	or.w	d2,16(a0)
	lea	24(a0),a0


;	move.w	(a1)+,d0
;	or.w	d0,(a0)

;	addq.w	#4,a0
;	dbf	d6,setpicl2
	lea	lsize*3+4(a0),a0
	dbf	d7,setpicl1
	bsr.w	copperexpand
rts


xsize=48	;32+16+8+4+2
ysize=64
asize=25
lsize=xsize*4+4	;linesize=xsize*4+wait+col0black+col0black

animpicsize=ysize*xsize*2

xoff=(xsize/2)-1
yoff=(ysize/2)-1

colpoint:	dc.w	0

drawblock4:
	lea	coltab(pc),a0
	move.w	colpoint(pc),d0
	addq.w	#2,d0
	move.w	(a0,d0.w),d1
	bpl.b	nocolrestart
	cmp.w	#-2,d1
	bne.b	noborderoff
	move.w	#$0003,$dff1be
	addq.w	#2,d0
	move.w	(a0,d0.w),d1
	bra.b	nocolrestart

noborderoff:
	moveq	#0,d0
	move.w	coltab(pc),d1
nocolrestart:
	move.w	d0,colpoint

	move.w	d1,bordercode1
	move.w	d1,bordercode2
rts


turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0

turnaddz:	dc.w	0
turnz:		dc.w	0



Precalc1:
	lea	rgbdream1,a0
	lea	d3sinus,a1	;sinus/cosinus
	moveq	#asize-1,d7	;animsize
Precalc1_la:
	moveq	#ysize-1,d6
	moveq	#-(ysize/2),d1
Precalc1_ly:
	moveq	#xsize-1,d5
	moveq	#-(xsize/2),d0
Precalc1_lx:
	movem.l	d0-d1/d5-d7,-(a7)
	
	sub.w	#(asize/2),d7
	bpl.b	Precalc1_noangleflow
	add.w	#360,d7
Precalc1_noangleflow:
	lsl.w	#2,d7

	move.l	0(a1,d7.w),d5	;d5:hiword=sin z ,loword=cos z 14
	move.w	d5,d6		;cos				4
	swap	d5		;sin				4

	move.w	d0,d2		;x
	move.w	d1,d3		;y
	muls.w	d6,d0		;cos*x
	muls.w	d5,d1		;sin*y
	muls.w	d5,d2		;sin*x
	muls.w	d6,d3		;cos*y
	sub.l	d1,d0		;cos*x - sin*y
	add.l	d3,d2		;sin*x + cos*y

;	add.l	d0,d0
;	swap	d0
;	add.l	d2,d2
;	swap	d2

;-------
;	divs	#32768-1,d0
;	divs	#32768-1,d2
	divs	#16768-1-2000,d0
	divs	#16768-1-2000,d2
	swap	d0
	swap	d2
	move.w	#0,d0
	move.w	#0,d2
	swap	d0
	swap	d2
	ext.l	d0
	ext.l	d2
	asr.l	#1,d0
	asr.l	#1,d2
;-------
	move.w	d2,d1

	addq.w	#2,d0
	addq.w	#2,d1

	add.w	#(xsize/2),d0
	bmi.b	Precalc1_pointflow
	cmp.w	#xsize-1,d0
	bhi.b	Precalc1_pointflow

	add.w	#(ysize/2),d1
	bmi.b	Precalc1_pointflow
	cmp.w	#ysize-1,d1
	bhi.b	Precalc1_pointflow
	bra.b	Precalc1_setpoint


Precalc1_pointflow:
;	movem.l	(a7),d0-d1
;	add.w	#(xsize/2),d0
;	add.w	#(ysize/2),d1
	moveq	#5,d0
	moveq	#ysize,d1

Precalc1_setpoint:
	lsl.w	#2,d0
	mulu.w	#lsize*4,d1
	add.w	d0,d1
	sub.w	#30000,d1
	move.w	d1,(a0)+

	movem.l	(a7)+,d0-d1/d5-d7
	addq.w	#1,d0
	dbf	d5,Precalc1_lx
	addq.w	#1,d1
	dbf	d6,Precalc1_ly
	dbf	d7,Precalc1_la
rts




Precalc2:
	lea	rgbdream2,a0
	lea	d3sinus,a1	;sinus/cosinus
	moveq	#asize-1,d7	;animsize
Precalc2_la:
	moveq	#ysize-1,d6
	moveq	#-(ysize/2),d1
Precalc2_ly:
	moveq	#xsize-1,d5
	moveq	#-(xsize/2),d0
Precalc2_lx:
	movem.l	d0-d1/d5-d7,-(a7)
	
	sub.w	#(asize/2),d7
	bpl.b	Precalc2_noangleflow
	add.w	#360,d7
Precalc2_noangleflow:
	lsl.w	#2,d7

	move.l	0(a1,d7.w),d5	;d5:hiword=sin z ,loword=cos z 14
	move.w	d5,d6		;cos				4
	swap	d5		;sin				4

	move.w	d0,d2		;x
	move.w	d1,d3		;y
	muls.w	d6,d0		;cos*x
	muls.w	d5,d1		;sin*y
	muls.w	d5,d2		;sin*x
	muls.w	d6,d3		;cos*y
	sub.l	d1,d0		;cos*x - sin*y
	add.l	d3,d2		;sin*x + cos*y

;	add.l	d0,d0
;	swap	d0
;	add.l	d2,d2
;	swap	d2

;-------
	divs	#32768-1,d0
	divs	#32768-1,d2
;-------
	move.w	d2,d1

	addq.w	#2,d0
	addq.w	#2,d1

	add.w	#(xsize/2),d0
	bmi.b	Precalc2_pointflow
	cmp.w	#xsize-1,d0
	bhi.b	Precalc2_pointflow

	add.w	#(ysize/2),d1
	bmi.b	Precalc2_pointflow
	cmp.w	#ysize-1,d1
	bhi.b	Precalc2_pointflow
	bra.b	Precalc2_setpoint


Precalc2_pointflow:
;	movem.l	(a7),d0-d1
;	add.w	#(xsize/2),d0
;	add.w	#(ysize/2),d1
	moveq	#5,d0
	moveq	#ysize,d1

Precalc2_setpoint:
	lsl.w	#2,d0
	mulu.w	#lsize*4,d1
	add.w	d0,d1
	sub.w	#30000,d1
	move.w	d1,(a0)+

	movem.l	(a7)+,d0-d1/d5-d7
	addq.w	#1,d0
	dbf	d5,Precalc2_lx
	addq.w	#1,d1
	dbf	d6,Precalc2_ly
	dbf	d7,Precalc2_la
rts


include	"/include/Fader2/Calc1.2.i"

Fader2_Colquant_xxx=32			;number of colours in this calculation
Fader2_Tablequant_xxx=2;	maximal number of colours in program!!
Fader2_Table_xxx:	dcb.w	Fader2_Tablequant_xxx*Fader2_Colquant_xxx*16
Fader2_Tableend_xxx:

Fader2_xxx:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_xxx,d7	;number of colours

	lea	col_src,a0		;colour source
	lea	col_wht,a1		;colour dest
	lea	fader2_table_xxx,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	col_dst,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
rts


Fader2Start_xxx:
	move.w	#Fader2_Colquant_xxx,fader2_quant
	move.w	#fader2_Tablequant_xxx*16,fader2_step
	move.w	#2,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_xxx,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_xxx,Fader2_pos	;...fade backward
rts

Fader2_real:
	tst.w	Fader2_step			;fading finished?
	beq.b	Fader2_skip			;yes-->exit

	subq.w	#1,Fader2_slpcount		;fader sleeping?
	bne.b	Fader2_skip			;yes-->exit
	move.w	Fader2_sleep,Fader2_slpcount	;new sleepcounter
	subq.w	#1,Fader2_step
	move.w	Fader2_quant(pc),d0
	move.w	d0,d1
	add.w	d1,d1
	move.l	Fader2_pos(pc),a0
	move.l	a0,a1

	tst.w	Fader2_direct
	bpl.b	Fader2_forward
	neg.w	d1
	lea	(a0,d1.w),a0
Fader2_forward:
	lea	(a1,d1.w),a1
	move.l	a1,Fader2_pos

	subq.w	#1,d0
;-------
	lea	$dff180,a1
Fader2_copy:
	move.w	(a0)+,(a1)+
	dbf	d0,Fader2_copy
;-------
Fader2_skip:
	rts


col_src:
	dc.w $004,$015,$015,$015,$015,$015,$015,$015
	dc.w $015,$015,$015,$015,$015,$015,$015,$015
	dc.w $015,$015,$015,$015,$015,$015,$015,$015
	dc.w $015,$015,$015,$015,$015,$015,$015,$015

col_wht:
	dc.w $004,$fff,$fff,$fff,$fff,$fff,$fff,$fff
	dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
	dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
	dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
col_dst:
	dc.w $003,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$000
	dc.w $000,$000,$000,$000,$000,$000,$000,$FFF


depp=6

coltab:
rept	2
dc.w $000,$000,$200,$300,$500,$700,$500,$200
dc.w $000,$000,$112,$333,$445,$667,$445,$222
dc.w $000,$210,$420,$630,$840,$530,$310,$000
dc.w $000,$011,$021,$022,$032,$043,$032,$021
dc.w $011,$000,$101,$212,$423,$524,$423,$312
dc.w $101,$000,$110,$221,$331,$442,$331,$111
dc.w $000,$011,$122,$133,$244,$133,$111,$000
dc.w $101,$202,$302,$402,$502,$502,$602,$701
dc.w $800,$910,$A20,$B40,$B60,$C70,$DA0,$EC0
dc.w $FF0,$ED0,$DC0,$CB0,$BA0,$B90,$A80,$970
dc.w $860,$750,$640,$530,$530,$420,$310,$210
dc.w $101,$303,$414,$626,$848,$A6A,$B9B,$DBD
dc.w $FFF,$DCC,$CA9,$A87,$965,$843,$631,$521
dc.w $310,$420,$631,$752,$973,$A94,$CB6,$DD8
dc.w $FFA,$DC8,$B97,$966,$845,$634,$423,$212
dc.w $201,$312,$412,$512,$612,$712,$823,$934
dc.w $A45,$B55,$C65,$D76,$E87,$FA9,$FCB,$FED
dc.w $FED,$FEC,$FEC,$EDA,$DD9,$BC7,$AB6,$8A5
dc.w $694,$483,$372,$262,$152,$032,$022,$011
dc.w $011,$022,$033,$134,$145,$155,$256,$367
dc.w $378,$489,$58A,$69B,$7AB,$9BC,$ACD,$BDE
dc.w $DEF,$BCE,$AAD,$99D,$87C,$86B,$85A,$849
dc.w $839,$838,$726,$615,$513,$512,$401,$300
dcb.w	20,0
endr

;dc.w	-1


dcb.w	60+400-160,0

rept	8
dc.w $000,$023,$046,$07A,$09D,$07A,$068,$045,$023
endr

dcb.w	72,$fff
dc.w	-2	;signal for borderoff
dcb.w	90,$003

dc.w	-1




rgbtable:	dc.l	rgbdream1

copperlist:	dc.l	copperlist1,copperlist2


copperlist1:
	dcb.b	50180,0
	dc.w	$f,$f,$f,$f,$f,$f,$f,$f,$f,$f,$f
bordercode1:
	dcb.w	lsize/2,$00f0

copperlist2:
	dcb.b	50180,0
	dc.w	$f,$f,$f,$f,$f,$f,$f,$f,$f,$f,$f
bordercode2:
	dcb.w	lsize/2,$0f00



pattern:
	incbin	"data/pattern5.blt"



codec_e:
datac_s:
datac_e:
bssc_s:
bssc_e:
codep_s:
codep_e:
;-------
ifne	usesection
section	data,data_p
endif
datap_s:
pictab:
	incbin	"data/skidriver.calc"
	incbin	"data/skull.calc"
	incbin	"data/Child2.calc"
	incbin	"data/Vulcanman.calc"




Sinus:;Created with Liberty Design's Sinusmaker
dc.W  12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14, 14, 15
dc.W  15, 15, 15, 15, 16, 16, 16, 16, 16, 17, 17, 17, 17
dc.W  17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 20, 20
dc.W  20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 22, 22
dc.W  22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23
dc.W  23, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24
dc.W  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25
dc.W  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24
dc.W  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 23, 23, 23
dc.W  23, 23, 23, 23, 23, 23, 22, 22, 22, 22, 22, 22, 22
dc.W  22, 21, 21, 21, 21, 21, 21, 21, 20, 20, 20, 20, 20
dc.W  20, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 17, 17
dc.W  17, 17, 17, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15
dc.W  14, 14, 14, 14, 14, 13, 13, 13, 13, 12, 12, 12, 12
dc.W  12, 11, 11, 11, 11, 10, 10, 10, 10, 10, 9, 9, 9, 9
dc.W  9, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 5, 5
dc.W  5, 5, 5, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 2, 2
dc.W  2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0
dc.W  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
dc.W  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
dc.W  0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
dc.W  2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4
dc.W  4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8
dc.W  8, 8, 8, 8, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11
dc.W  11, 11, 12, 12
dc.w	-2



turnsin:
dc.W  24, 24, 25, 25, 26, 26, 27, 27, 27, 28, 28, 29, 29
dc.W  29, 30, 30, 31, 31, 31, 32, 32, 33, 33, 33, 34, 34
dc.W  35, 35, 35, 36, 36, 36, 37, 37, 37, 38, 38, 38, 39
dc.W  39, 39, 40, 40, 40, 41, 41, 41, 42, 42, 42, 42, 43
dc.W  43, 43, 43, 44, 44, 44, 44, 45, 45, 45, 45, 45, 46
dc.W  46, 46, 46, 46, 46, 47, 47, 47, 47, 47, 47, 47, 47
dc.W  47, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48
dc.W  48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 47, 47
dc.W  47, 47, 47, 47, 47, 47, 47, 46, 46, 46, 46, 46, 46
dc.W  45, 45, 45, 45, 45, 44, 44, 44, 44, 43, 43, 43, 43
dc.W  42, 42, 42, 42, 41, 41, 41, 40, 40, 40, 39, 39, 39
dc.W  38, 38, 38, 37, 37, 37, 36, 36, 36, 35, 35, 35, 34
dc.W  34, 33, 33, 33, 32, 32, 31, 31, 31, 30, 30, 29, 29
dc.W  29, 28, 28, 27, 27, 27, 26, 26, 25, 25, 24, 24, 24
dc.W  23, 23, 22, 22, 21, 21, 21, 20, 20, 19, 19, 19, 18
dc.W  18, 17, 17, 17, 16, 16, 15, 15, 15, 14, 14, 13, 13
dc.W  13, 12, 12, 12, 11, 11, 11, 10, 10, 10, 9, 9, 9, 8
dc.W  8, 8, 7, 7, 7, 6, 6, 6, 6, 5, 5, 5, 5, 4, 4, 4, 4, 3
dc.W  3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1
dc.W  1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
dc.W  0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2
dc.W  2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6
dc.W  6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10, 11, 11
dc.W  11, 12, 12, 12, 13, 13, 13, 14, 14, 15, 15, 15, 16
dc.W  16, 17, 17, 17, 18, 18, 19, 19, 19, 20, 20, 21, 21
dc.W  21, 22, 22, 23, 23, 24
dc.w	-1


d3sinus:
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
datap_e:
;-------
;-------------------
ifne	usesection
section	memory,bss_p
endif
bssp_s:
rgbdream1:
	ds.b	153600
rgbdream2:
	ds.b	153600
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


;>extern	"dh0:precalc1.dat",rgbdream1
;>extern	"dh0:precalc2.dat",rgbdream2
;auto e\

