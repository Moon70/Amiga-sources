section	maincode,code_c
codec_s:

showtime=0
;------------------------------------------------------------------------
;|                                                                      |
;|                           DRUGSTORE-PDNote                           |
;|                          ------------------                          |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                       November 93 |
;------------------------------------------------------------------------

AttnFlags=296	;struct ExecBase
ThisTask=276	;struct ExecBase
Copinit=38	;struct GfxBase

mainplanesize=40*256	;40*256*7r
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$096
intena=$09a
OpenLibrary=-552
CloseLibrary=-414
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
	jmp	Main_Start
	jmp	Main_Init
	jmp	Main_Program
	jmp	Main_Back

Main_Start:
	move.l	4.w,a6
	move.w	AttnFlags(a6),d0
	btst.l	#0,d0
	beq.b	Main_Vectorsokay
	lea	Main_GetVBR(pc),a5
	jsr	LVO_Supervisor(a6)
	bra.b	Main_Vectorsokay

Main_GetVBR:
	move.l	d0,-(a7)
	dc.l	$4e7a0801
	move.l	d0,Main_VBR
	move.l	(a7)+,d0
	rte

Main_Vectorsokay:
	move.l	4.w,a6
	lea	Main_GraphicsName(pc),a1
	moveq	#0,d0
	jsr	OpenLibrary(a6)
	move.l	d0,Main_GraphicsBase
	move.l	d0,a6
	move.l	ActiView(a6),Main_OldView
	sub.l	a1,a1	
	jsr	Loadview(a6)
	jsr	WaitTOF(a6)
	jsr	WaitTOF(a6)
;bra.b	Main_StartCLI
;	move.l	4.w,a6
;	move.l	ThisTask(a6),a4
;	tst.l	$ac(a4)
;	bne.b	Main_StartCLI
;	lea	$5c(a4),a0
;	jsr	WaitPort(a6)
;	lea	$5c(a4),a0
;	jsr	GetMSG(a6)
;	move.l	d0,Main_Message

Main_StartCLI:
	move.l	4.w,a6
	jsr	Forbid(a6)

	lea	$dff000,a5
	move.w	#%0000001111100000,dmacon(a5)
	move.w	#%0000000001101000,intena(a5)
	move.l	Main_VBR(pc),a0
	move.l	$6c(a0),Main_OldVBIVector
	move.l	$78(a0),Main_OldExIVector
	move.l	#Main_VBI,$6c(a0)
	lea	Main_EmptyCopperlist(pc),a1
	move.l	a1,Cop1lch(a5)
	move.w	#0,Copjmp1(a5)

	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#%1100000000100000,Intena(a5)

	move.w	#0,$1fc(a5)
	move.w	#%0000110000000000,$106(a5)
	move.w	#%0000000011110000,$10c(a5)

	move.w	#%1000001111000000,dmacon(a5)

 	lea	Main_FakeVBI(pc),a0
	lea	Main_FakeCopperList(pc),a1
	lea	Main_FakeTalk(pc),a2
	bsr.w	Main_Init
	bsr.w	Main_Program
Main_Wait:
;#############################################
	btst	#10,$dff016
	bne.b	nozoomfake
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#2,(a0)
nozoomfake:
;	btst.b	#6,ciaapra				;
;	beq.b	back					;
;	tst.w	f_endprogram				;
;	beq.b	wait					;
;#############################################
	btst.b	#6,ciaapra
	bne.b	Main_Wait

;Main_Back:
	move.l	Main_VBR(pc),a0
	move.l	Main_OldVBIVector(pc),$6c(a0)
	move.l	Main_OldExIVector(pc),$78(a0)

	move.l	4.w,a6
	move.l	Main_GraphicsBase(pc),a1
	lea	$dff000,a5
	move.l	Copinit(a1),Cop1lch(a5)
	move.w	#0,Copjmp1(a5)
	jsr	CloseLibrary(a6)

	lea	$dff000,a5
	move.w	#%1100000000001000,Intena(a5)
	move.w	#%1000001111100000,Dmacon(a5)

	move.l	Main_GraphicsBase(pc),a6
	move.l	Main_Oldview(pc),a1
	jsr	LoadView(a6)

	move.l	4.w,a6
	jsr	Permit(a6)
	move.l	Main_Message(pc),d0
	beq.b	Main_NoReply
	move.l	d0,a1
	jsr	ReplyMsg(a6)
Main_Noreply:
	moveq	#0,d0
	rts

;--------------------------------------------------------
;--------------------------------------------------------
Main_Message:		dc.l	0
Main_VBR:		dc.l	0
Main_GraphicsBase:	dc.l	0
Main_OldView:		dc.l	0
Main_OldVBIVector:	dc.l	0
Main_OldExIVector:	dc.l	0
Main_VBIVector:		dc.l	0
Main_Copperlist:	dc.l	0
Main_Talk:		dc.l	0
Main_FakeVBI:		dc.l	0
Main_FakeCopperlist:	dc.l	Main_EmptyCopperlist
Main_FakeTalk:		dc.l	0

Main_GraphicsName:	dc.b	"graphics.library",0,0

Main_EmptyCopperlist:	dc.l	-2

maincommand:		dc.l	-1

;----------------------------------------------------------------
Main_VBI:
	btst.b	#5,$dff01f
	beq.b	main_vbiback
	movem.l	d0-a6,-(a7)

	lea	$dff000,a5
	move.l	Main_VBIVector(pc),a0
	tst.l	(a0)
	beq.b	Main_NoNewVBI
	move.l	(a0),a0
	jsr	(a0)
Main_NoNewVBI:
	move.l	Main_Copperlist(pc),a0
	tst.l	(a0)
	beq.b	Main_NoCopperlist
	bpl.b	Main_NoEmptyCopperlist
	lea	Main_EmptyCopperlist(pc),a1
	move.l	a1,Cop1lch(a5)
	clr.l	(a0)
	bra.b	Main_NoCopperlist
Main_NoEmptyCopperlist:
	move.l	(a0),Cop1lch(a5)
	clr.l	(a0)
Main_NoCopperlist:

ifne	showtime
	move.w	#$0fff,$180(a5)
endif
	movem.l	(a7)+,d0-a6
ifne	showtime
	move.w	#$0000,$dff180
endif
main_vbiback:
	move.w	#%0000000001100000,$dff09c
	rte

;------------------------------------------------------------------------
Commander:
	lea	Commander_Sleep(pc),a0
	subq.w	#1,(a0)+
	beq.b	Commander_NewCommand
	rts
Commander_NewCommand:
	move.w	(a0),d0
	addq.w	#8,(a0)
	lea	Commands+2(pc),a1
	add.w	d0,a1
	move.w	(a1)+,-(a0)
	move.l	(a1),a0
	jmp	(a0)
Commander_Sleep:	dc.w	1	;|
Commander_Point:	dc.w	0	;|
;------------------------------------------------------------------------




hide=0
;5: textwrite recoded
;6: dotcursor and writer running, but not optimized (flicker...)
;7: raw restructured
;8: background in dotpart, textpartscreensize expandet to 64 bytes/line
;9: vectorcursor implemented
;a: optimizing work
;b-e: interfacing
;f: backgroundscrolling

dmaconr=$2
planesize=64*256

;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------

f_endprogram:	dc.w	0
f_drawdots:	dc.w	1
;------------------------------------------------------------------------
commands:;;
		dc.l	10,	setscreen_scrollbackground
		dc.l	62,	scrollbackground
		dc.l	255,	dotcurson
		dc.l	1,	set_drawdotsoff
		dc.l	1,	clsplane1
		dc.l	1,	clsplane2
		dc.l	1,	clsplane3
		dc.l	1,	clsplane4
		dc.l	1,	copybackground
		dc.l	733+200+60000,	writeron

;		dc.l	61550,	nothing

		dc.l	50,	veccurson
		dc.l	61000,	setente
;---------------------------------------------
nothing:	rts

set_drawdotsoff:
	move.w	#0,f_drawdots
	rts

setente:
;	move.w	#1,f_endprogram

	move.l	main_talk(pc),a0
	move.w	#1,(a0)

	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)

	rts

CopScreen_Scrollbackground:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0030
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,$0000
	dc.w	bplcon2,$0000
	dc.w	bpl1mod,$0016
	dc.w	bpl2mod,$0016
	dc.l	$01800102
	dc.l	$01980202
	dc.l	-2

CopScreen_Writer:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,24
	dc.w	bpl2mod,24
	dc.w	bplcon0,%0100001000000000
CopScreen_Writer_Colpoint:
	dcb.l	100,0
	dc.l	-2

setscreen_scrollbackground:
	lea	CopScreen_Scrollbackground(pc),a1
	move.l	main_copperlist(pc),a0
	move.l	a1,(a0)
rts

scrollbackground:
	move.l	main_copperlist(pc),a0
	move.l	#-2,(a0)
	move.l	main_vbivector(pc),a0
	move.l	#introut_scrollback,(a0)

	bsr.w	switchplanes	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	rts

dotcurson:
	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1(pc),turnquant
	move.w	#5*4,turnaddz

	move.w	#$0fff,d0
	move.w	d0,$186(a5)			;00011
	move.w	d0,$18a(a5)			;00101
	move.w	d0,$18c(a5)			;00110
	move.w	d0,$18e(a5)			;00111
	move.w	d0,$190(a5)			;01000
	move.w	d0,$196(a5)			;01011
	move.w	d0,$19e(a5)			;01111

	move.w	#fadequant1*2,fader_direct
	bsr.w	switchplanes
	bsr.w	switchplanes
	bsr.w	switchplanes
	bsr.w	switchplanes
	bsr.w	switchplanes

	move.l	main_vbivector(pc),a0	;adress of UserVbiAdress
	move.l	#introut_dots,(a0)
	rts

clsplane1:
	lea	planeadr,a0
	move.w	#(planeadrend-planeadr)/16-1,d7
	moveq	#0,d0
clsplane1loop:
	move.l	d0,(a0)+
	dbf	d7,clsplane1loop
	rts

clsplane2:
	lea	planeadr+1*(planeadrend-planeadr)/4,a0
	move.w	#(planeadrend-planeadr)/16-1,d7
	moveq	#0,d0
clsplane2loop:
	move.l	d0,(a0)+
	dbf	d7,clsplane2loop
	rts

clsplane3:
	lea	planeadr+2*(planeadrend-planeadr)/4,a0
	move.w	#(planeadrend-planeadr)/16-1,d7
	moveq	#0,d0
clsplane3loop:
	move.l	d0,(a0)+
	dbf	d7,clsplane3loop
	rts

clsplane4:
	lea	planeadr+3*(planeadrend-planeadr)/4,a0
	move.w	#(planeadrend-planeadr)/16-1,d7
	moveq	#0,d0
clsplane4loop:
	move.l	d0,(a0)+
	dbf	d7,clsplane4loop
	rts


writeron:
	bsr.w	cursdraw
	bsr.w	cursclr
	move.l	main_vbivector(pc),a0	;adress of UserVbiAdress
	move.l	#introut_writer,(a0)

	lea	fontcol(pc),a0
	lea	CopScreen_Writer_Colpoint(pc),a1
	move.w	#$180,d0
	moveq	#14,d7
fontcolcopy:
	move.w	d0,(a1)+
	move.w	(a0)+,(a1)+
	addq.w	#2,d0
	dbf	d7,fontcolcopy

	move.w	#$1a0,d0
	moveq	#14,d7
whitecolcopy:
	move.w	d0,(a1)+
	move.w	#$0fff,(a1)+
	addq.w	#2,d0
	dbf	d7,whitecolcopy
	move.l	#-2,(a1)

	
	lea	CopScreen_Writer(pc),a1
	move.l	main_copperlist(pc),a0
	move.l	a1,(a0)
	rts

copybackground:
	lea	planeadrend,a0
	lea	background,a1
	move.w	#(backgroundend-background)/16-1,d7
backgroundcopy:
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	dbf	d7,backgroundcopy
	rts

veccurson:;;
	move.l	#linekoordd,turnkoord
	move.l	#linekoords,turnkoords
	move.w	linepoints2(pc),turnquant
	move.w	linequant1(pc),linequant
	move.l	#lines1,lines

	move.w	#3*4,turnaddz
	move.w	#0,turnz

	bsr.w	planecls2
	bsr.w	switchplanes2
	bsr.w	planecls2
	bsr.w	switchplanes2
	bsr.w	cursclr
	move.l	main_vbivector(pc),a0	;adress of UserVbiAdress
	move.l	#introut_veccurs,(a0)
	rts


;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbivector
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	bsr.w	textcalc
	bsr.w	makeobject
	bsr.w	memorycls
	move.w	linequant1(pc),linequant
	move.l	#lines1,lines
	lea	fadedesttab(pc),a0
;	move.w	backgroundcol,(a0)+	;00000
	move.w	#$0fff,(a0)+		;00001
	move.w	#$0ddd,(a0)+		;00010
	move.w	#$0aaa,(a0)+		;00100
	move.w	#$0777,(a0)+		;01001
	move.w	#$0444,(a0)+		;01010
;	move.w	backgroundcol+2,(a0)+	;01100
	move.w	#$0777,(a0)+		;01101
	move.w	#$0444,(a0)+		;01110
	bsr.w	fader
	bsr.w	fontcodecalc

	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
;	movem.l	d0-a6,-(a7)
;---
;---
;	movem.l	(a7)+,d0-a6
	rts
;----------

Main_program:;;
	movem.l	d0-a6,-(a7)
	move.l	main_vbivector(pc),a0
	lea	main_intuser(pc),a1
	move.l	a1,(a0)
	movem.l	(a7)+,d0-a6
	rts

;DANGER-->BIG FAKE OF MAININIT
;wait2:							;
;	btst	#10,$dff016
;	bne.w	nozoomfake
;	lea	main_talk,a0
;	move.l	(a0),a0
;	move.w	#2,(a0)
;nozoomfake:
;	btst.b	#6,ciaapra				;
;	beq.b	back2					;
;	tst.w	f_endprogram				;
;	beq.b	wait2					;
;back2:
;	movem.l	(a7)+,d0-a6
;	rts

main_intuser:;;
	lea	$dff000,a5
	bsr.w	commander
	rts
;----------

;--------------
introut_writer:
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl4pth(a5)

	bsr.w	print
	bsr.w	cursblank

	move.l	main_talk(pc),a0
	cmp.w	#2,(a0)
	bne.b	noexitstart
	move.w	#1,commander_sleep
noexitstart:
	bsr.w	commander
	rts
;------------------


;--------------
introut_veccurs:
	move.w	#%0101001000000000,bplcon0(a5)
	lea	planeadr,a0
	move.l	a0,bpl1pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	move.l	showplane2(pc),bpl5pth(a5)

;	bsr.w	print

;	bsr.w	movep
	bsr.w	turner
	bsr.w	perspective2
	bsr.w	planecls2
	bsr.w	drawline
	bsr.w	fill
	bsr.w	switchplanes2
	bsr.w	commander
	waitblit
	rts
;----------

;------------------------------------------------------------------------
;		 0000000000111111111122222222223333333333444444444455
;                0123456789012345678901234567890123456789012345678901
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz.,!?[]/\-'#+:1234567890§|"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|


dc.b	"§"
dc.b	"this abyss production shall not§"
dc.b	"be sold in any form without our§"
dc.b	"written permission.§"
dc.b	"§§|"
dc.b	"for any reason write to:§"
dc.b	"§|"
dc.b	"moon/abyss          toxic/abyss§"
dc.b	"p.o.box 162     gruenewaldstr.6§"
dc.b	"5400 hallein    84453 muehldorf§"
dc.b	"austria                 germany§"
dc.b	"§|"


;dc.b	"§"
;dc.b	"note to all pd distributors:§"
;dc.b	"§"
;dc.b	"this abyss production shall not§"
;dc.b	"be sold in any form without our§"
;dc.b	"written permission.§"
;dc.b	"§"
;dc.b	"you find our contact address in the§"
;dc.b	"credits part.§"
;dc.b	"§"
;dc.b	"we are so scheee, we are best§"
;dc.b	"in da world...§§"



textend:	dcb.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=4*8
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
	beq.b	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------
cursxbord:	dc.w	3
cursx:		dc.w	3
cursy:		dc.w	7

lastcurs:dc.l	planeadr
print_sleep:	dc.w	1
print:
	subq.w	#1,print_sleep
	bne.w	print_skip
	move.w	#3,print_sleep	;3
	lea	text(pc),a1
	lea	textpoint(pc),a2
	add.w	(a2),a1
	move.w	(a1),d1
	bmi.w	print_skip
	addq.w	#2,(a2)
	cmp.w	#charsize*51,d1
	bne.b	nolongsleep
	move.w	#70,print_sleep
	bra.w	print_skip


nolongsleep:
	move.w	#0,cursor

	bsr.w	cursclr

	cmp.w	#charsize*50,d1
	bne.b	print_char

	addq.w	#1,cursy
	move.w	cursxbord(pc),cursx

	lea	planeadr,a0
	move.w	cursy(pc),d0
	mulu	#1*64*10,d0
	add.l	d0,a0

	add.w	cursx(pc),a0
;	add.w	d0,a0

	move.l	a0,lastcurs
	bsr.b	cursdraw

	bra.b	print_skip

print_char:
	lea	font(pc),a1
	add.w	d1,a1

	move.l	lastcurs(pc),a0
	move.l	a0,a3
	add.l	#planesize*2,a3

	lea	1(a0),a2
	move.l	a2,lastcurs
	moveq	#7,d7
print_loop:
	move.b	(a1)+,(a0)
	move.b	(a1)+,planesize(a0)
	move.b	(a1)+,(a3)
;	move.b	(a1)+,planesize(a3)

	move.b	planesize(a3),d0	;background
	and.b	4*8*50(a1),d0		;chardatacode plane 4
	or.b	(a1)+,d0		;chardata plane 4
	move.b	d0,planesize(a3)

	lea	64(a0),a0
	lea	64(a3),a3
	dbf	d7,print_loop
	addq.w	#1,cursx

	bsr.b	cursdraw

print_skip:
	rts

cursdraw:
	move.l	lastcurs(pc),a0
	move.l	a0,a3
	add.l	#planesize*2,a3
	lea	cursback(pc),a4
	moveq	#-1,d0
	moveq	#7,d7
print_cursdraw:
	move.b	(a0),(a4)+
	move.b	planesize(a0),(a4)+
	move.b	(a3),(a4)+
	move.b	planesize(a3),(a4)+

	move.b	d0,(a0)
	move.b	d0,planesize(a0)
	move.b	d0,(a3)
	move.b	d0,planesize(a3)
	lea	64(a0),a0
	lea	64(a3),a3
	dbf	d7,print_cursdraw
rts

cursclr:
	move.l	lastcurs(pc),a0
	move.l	a0,a3
	add.l	#planesize*2,a3
	lea	cursback(pc),a4

	moveq	#7,d7
print_cursclr:
	move.b	(a4)+,(a0)
	move.b	(a4)+,planesize(a0)
	move.b	(a4)+,(a3)
	move.b	(a4)+,planesize(a3)
	lea	64(a0),a0
	lea	64(a3),a3
	dbf	d7,print_cursclr
rts

cursblankwait:	dc.w	1
cursblank:
	subq.w	#1,cursblankwait
	bne.b	nocursblank
	move.w	#6,cursblankwait
	move.w	#$0fff,d0
	sub.w	cursor(pc),d0
	move.w	d0,cursor
	move.w	d0,$19e(a5)
nocursblank:
rts


cursor:	dc.w	$0fff


cursback:	dcb.b	32,0

fontcol:
	dc.w $102,$FFF,$DCC,$C9A,$A68,$946,$825,$613
	dc.w $202,$769,$0f0,$547,$436,$435,$324,$fff
;              |                                  |
;         background                            cursor


font:	incbin	"data/PDNoteFont.blt"
fontcode:	dcb.b	1600,0

fontcodecalc:
	lea	font(pc),a0
	lea	fontcode(pc),a1
	move.w	#319,d7
fontcodecalcloop:
	move.b	(a0)+,d0
	or.b	(a0)+,d0
	or.b	(a0)+,d0
	or.b	(a0)+,d0
	not.b	d0
	move.b	d0,(a1)+
	move.b	d0,(a1)+
	move.b	d0,(a1)+
	move.b	d0,(a1)+
	dbf	d7,fontcodecalcloop
	rts
	

introut_scrollback:
	move.w	#%0110011000000000,bplcon0(a5)
	move.l	showplane(pc),bpl1pth(a5)
	move.l	shadowplane1(pc),bpl3pth(a5)
	move.l	shadowplane2(pc),bpl5pth(a5)
	move.l	shadowplane3(pc),bpl2pth(a5)
	move.l	shadowplane4(pc),bpl4pth(a5)

	moveq	#0,d1
	lea	background-2,a0
	lea	bssinus(pc),a1
	move.w	backpoint(pc),d0
	cmp.w	#98,d0
	beq.b	skipsub
	move.w	(a1,d0.w),d0
	addq.w	#2,backpoint

	addq.w	#2,a0
	move.w	d0,d1
	lsr.w	#4,d0
	add.w	d0,d0
	add.w	d0,a0

	not.w	d1
	and.w	#15,d1
	lsl.w	#4,d1
skipsub:
	move.w	d1,bplcon1(a5)
	move.l	a0,bpl6pth(a5)


	bsr.b	planecls
	bsr.w	switchplanes

	bsr.w	commander

	rts
;----------

backpoint:	dc.w	0

introut_dots:
	move.w	#%0110011000000000,bplcon0(a5)
	move.l	#background-2,bpl6pth(a5)
	move.l	showplane,d0
	move.l	d0,bpl1pth(a5)
	move.l	d0,bpl3pth(a5)
	move.l	d0,bpl5pth(a5)
	move.l	d0,bpl2pth(a5)
	move.l	d0,bpl4pth(a5)

	tst.w	f_drawdots
	beq.b	skip_drawdots
	move.l	shadowplane1(pc),bpl3pth(a5)
	move.l	shadowplane2(pc),bpl5pth(a5)
	move.l	shadowplane3(pc),bpl2pth(a5)
	move.l	shadowplane4(pc),bpl4pth(a5)
	bsr.b	planecls
	bsr.w	fader_real
	bsr.w	turner
	bsr.w	perspective
	bsr.w	drawdots
	bsr.b	switchplanes
skip_drawdots:

	bsr.w	commander

	rts


planecls:
	lea	$dff000,a5
	move.l	clearplane(pc),d0
	addq.l	#0*64+2,d0
	move.l	d0,BLTDPTH(A5)
	move.w	#24,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#256*64*1+20,BLTSIZE(A5)
	rts


showplane:	dc.l	plane1
shadowplane1:	dc.l	plane2
shadowplane2:	dc.l	plane3
shadowplane3:	dc.l	plane4
shadowplane4:	dc.l	plane5
clearplane:	dc.l	plane6
pointplane:	dc.l	plane7

switchplanes:
	lea	pointplane(pc),a0
	move.l	(a0),d0
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	d0,(a0)
	rts
;--------
turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0

turnaddz:	dc.w	0
turnz:		dc.w	0

turner:	;last optimizing:93-09-05
	move.w	turnz(pc),a0
	add.w	turnaddz,a0
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

	move.w	d3,2(a4,d0.w)
	move.w	d6,4(a4,d0.w)
	move.w	6(a3,d0.w),6(a4,d0.w)

	subq.w	#8,d0
	bpl.b	turnrout1
	rts
;*****

perspective:
	move.l	turnkoord(pc),a3
	move.w	turnquant(pc),d7

perspectiveloop:
	move.w	2(a3),d0
	move.w	4(a3),d1
	move.w	6(a3),d2
	asr.w	#1,d2
	add.w	#80,d2
	move.w	focus,d3
	muls.w	d3,d0
	muls.w	d3,d1
	divs	d2,d0
	divs	d2,d1
	move.w	d0,2(a3)
	move.w	d1,4(a3)
	addq.l	#8,a3
	dbf	d7,perspectiveloop
	cmp.w	#2,focus
	bne.b	zoom
	move.w	#0,turnaddz
	move.w	#0,turnz
rts

zoom:
	subq.w	#1,focus
	subq.w	#1,dcx
	bne.b	dcxskip
	move.w	#2,dcx
	addq.w	#1,dotcursx
dcxskip:
	subq.w	#1,dcy
	bne.b	dcyskip
	move.w	#5,dcy
	subq.w	#1,dotcursy
dcyskip:
	rts


focus:	dc.w	250

dcx:	dc.w	2
dcy:	dc.w	5
dotcursx:	dc.w	157+3
dotcursy:	dc.w	125+7


perspective2:
	lea	veccursxoffset(pc),a4
	addq.w	#1,(a4)
	lea	wave(pc),a3
	move.w	wavepoint(pc),d7
	move.w	0(a3,d7.w),d3
	bpl.b	focus2ok
	subq.w	#1,(a4)
	subq.w	#2,d7
	move.w	0(a3,d7.w),d3
	move.w	#0*4,turnaddz
focus2ok:
	addq.w	#2,d7
	move.w	d7,wavepoint

	move.l	turnkoord(pc),a3
	move.l	turnkoord(pc),a4
	move.w	turnquant(pc),d7


perspectiveloop2:

move.w	2(a3),d0
move.w	4(a3),d1
move.w	6(a3),d2

;move.w	focus2(pc),d3
muls.w	d3,d0
muls.w	d3,d1
moveq	#9,d4
asr.l	d4,d0
asr.l	d4,d1

move.w	d0,2(a4)
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop2
rts


focus2:	dc.w	16;*1024



drawdots:
	move.l	turnkoord(pc),a0
	move.l	pointplane(pc),a1	;planeadress
	move.w	turnquant(pc),d7
	move.w	dotcursx(pc),d3
	move.w	dotcursy(pc),d4
drawdotsloop:
	move.w	d3,d0
	move.w	d4,d1

	add.w	2(a0),d0
	bmi.b	skipdot
	cmp.w	#340,d0
	bge.b	skipdot

	add.w	4(a0),d1
	bmi.b	skipdot
	cmp.w	#255,d1
	bge.b	skipdot

	lsl.w	#6,d1
	move.w	d0,d2
	lsr.w	#3,d0
	sub.w	d0,d1
	bset	d2,40(a1,d1.w)
skipdot:
	addq.w	#8,a0
	dbf	d7,drawdotsloop
	rts

makeobject:
	lea	linekoords1(pc),a0
	moveq	#7,d6
yloop:
	moveq	#7,d7
xloop:
	move.w	d7,d0
	move.w	d6,d1
	lsl.w	#6,d0
	lsl.w	#6,d1
	sub.w	#64*4-32,d0
	sub.w	#64*4-32,d1
	move.w	#0,(a0)+
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	#32*4,(a0)+
	dbf	d7,xloop
	dbf	d6,yloop
rts

;backgroundcol:	dc.w $102,$202

bsSinus:;Created with Liberty Design's Sinusmaker
dc.W  192, 186, 180, 174, 168, 162, 156, 150, 144, 138, 133
dc.W  127, 121, 116, 110, 105, 100, 94, 89, 84, 79, 74, 70
dc.W  65, 61, 56, 52, 48, 44, 40, 37, 33, 30, 27, 24, 21
dc.W  18, 16, 13, 11, 9, 8, 6, 5, 3, 2, 2, 1, 0
x:
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
sinusend:

planecls2:
	lea	$dff000,a5
	move.l	clearplane2(pc),d0
;	add.l	#45*64+0,d0
waitblit
	move.l	d0,BLTDPTH(A5)
	move.w	#24,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#256*64+20,BLTSIZE(A5)
	rts

fill:
	lea	$dff000,a5
	move.l	pointplane2(pc),d0
	add.l	#255*64+((20-0)*2)-2,d0
waitblit
	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#24,bltamod(A5)
	MOVE.w	#24,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)
	move.w	#256*64+20,BLTSIZE(A5)
	rts


linequant:	dc.w	0
lines:		dc.l	0


veccursxoffset:	dc.w	28

drawline:
lea	$dff000,a5

move.l	turnkoord(pc),a0
move.l	lines(pc),a1
move.w	linequant(pc),d7

drawloop:
moveq	#0,d0
moveq	#0,d1
moveq	#0,d2
moveq	#0,d3

move.w	veccursxoffset(pc),d0
move.w	#174+30,d1
move.w	veccursxoffset(pc),d2
move.w	#174+30,d3

move.w	0(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d0
add.w	4(a0,a2.w),d1
ifne	hide
tst.w	6(a0,a2.w)
bpl	samepoint
endif
move.w	2(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d2
add.w	4(a0,a2.w),d3

ifne	hide
tst.w	6(a0,a2.w)
bpl	samepoint
endif
cmp.w	d0,d2
bne.b	notsamepoint
cmp.w	d1,d3
bne.b	notsamepoint
bra.w	samepoint


notsamepoint:
movem.l	d4-d7/a0/a2/a6,-(a7)
winx1=0
winy1=0
winx2=319
winy2=255
;checktop
	cmp.w	#winy1,d1
	bge.b	notop1flow
	cmp.w	#winy1,d3
	blt.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy1,d7
	sub.w	d3,d7		;d7=winy1-y2	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DXS
	bra.b	checkbot
notop1flow:
	cmp.w	#winy1,d3
	bge.b	checkbot
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy1,d7
	sub.w	d1,d7		;d7=winy1-y1	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkbot:
	cmp.w	#winy2,d1
	blt.b	nobot1flow
	cmp.w	#winy2,d3
	bge.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy2,d7
	sub.w	d3,d7		;d7=winy2-y2	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DXS
	bra.b	checklef
nobot1flow:
	cmp.w	#winy2,d3
	blt.b	checklef
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winy2,d7
	sub.w	d1,d7		;d7=winy2-y1	DYS
	move.w	d4,d6
	muls	d7,d6
	divs	d5,d6		;d6=DX*DYS/DY
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS


checklef:
	cmp.w	#winx1,d0
	bge.b	nolef1flow
	cmp.w	#winx1,d2
	blt.w	line_skip	;both points out of range
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx1,d6
	sub.w	d2,d6		;d6=winx1-x2	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DYS
	bra.b	checkrig
nolef1flow:
	cmp.w	#winx1,d2
	bge.b	checkrig
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx1,d6
	sub.w	d0,d6		;d6=winx1-x1	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkrig:
	cmp.w	#winx2,d0
	blt.b	norig1flow
	cmp.w	#winx2,d2
	bge.b	line_borderline1	;both points out of range-->draw border
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx2,d6
	sub.w	d2,d6		;d6=winx1-x2	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
movem.l	d0-d6,-(a7)
move.w	#winx2,d0
move.w	d0,d2
add.w	d7,d3
bsr.b	line
movem.l	(a7)+,d0-d6
	move.w	d2,d0
	add.w	d6,d0		;x1=x2+DXS
	move.w	d3,d1
	add.w	d7,d1		;y1=y2+DYS

	bra.b	checkfin
norig1flow:
	cmp.w	#winx2,d2
	blt.b	checkfin
	move.w	d0,d4		;d4=x1
	sub.w	d2,d4		;d4=x1-x2	DX
	move.w	d1,d5		;d5=y1
	sub.w	d3,d5		;d5=y1-y2	DY
	move.w	#winx2,d6
	sub.w	d0,d6		;d6=winx1-x1	DXS
	move.w	d5,d7
	muls	d6,d7
	divs	d4,d7		;d7=DY*DXS/DX
movem.l	d0-d6,-(a7)
move.w	#winx2,d0
move.w	d0,d2
add.w	d7,d1
bsr.b	line
movem.l	(a7)+,d0-d6
	move.w	d0,d2
	add.w	d6,d2		;x2=x1+DXS
	move.w	d1,d3
	add.w	d7,d3		;y2=y1+DXS

checkfin:

bsr.b	line
line_skip:
movem.l	(a7)+,d4-d7/a0/a2/a6

samepoint:
subq.w	#4,d7
bpl.w	drawloop

bwait1:	
btst	#14,dmaconr(a5)
bne.b	bwait1
rts

line_borderline1:
move.w	#winx2,d0
move.w	d0,d2
bsr.b	line
bra.b	line_skip



line:
	move.l	pointplane2(pc),a0	;planeadress
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
	beq.w	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
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
	MOVE.l	#-1,bltafwm(a5)
	MOVE.w	#64,bltcmod(a5)
	MOVE.w	#64,bltdmod(a5)
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
	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
	DC.L	$0B5AF017;-2		; BIT/LINE.
	DC.L	$0B5AF00B;-2


memorycls:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	move.l	d0,a0
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	move.l	d0,a5
	lea	memory+2307*52,a6
	move.w	#2306,d7
memoryclsloop:
	movem.l	d0-d6/a0-a5,-(a6)
	dbf	d7,memoryclsloop
	lea	$dff000,a5
	rts

switchplanes2:
	lea	allplanes+3*4(pc),a0
	move.l	-(a0),d0
	move.l	-(a0),4(a0)
	move.l	-(a0),4(a0)
	move.l	d0,(a0)
	rts

fadescrtab:
		dc.w	0
;		dcb.w	9-2-1,$f02
		dcb.w	9-2-1,$102
fadedesttab:	dcb.w	9-2,0


fader:
;	lea	drugcol4,a0
;	moveq	#fadequant1,d7	;number of colours
;	jsr	fader_makegrey

fadequant1=9-2	;number of colours in this calculation

	lea	fadescrtab,a0	;source-colourstable
	lea	fadedesttab,a1	;destination-colourtable
	lea	fader_table,a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr.w	fader_calc

;	lea	fader_table+15*fadequant1*2,a0	;source-colourstable
;	lea	fadedesttab,a1	;destination-colourtable
;	lea	fader_table+16*fadequant1*2,a2	;point in fader-table
;	moveq	#%111,d1	;RGB filter
;	moveq	#fadequant1,d7	;number of colours
;	bsr	fader_calc


	lea	fader_table,a2
	move.w	#-1,1*16*fadequant1*2(a2)	;set endmark in colourlist

rts


fader_maxnum=32*3;;	maximal number of colours in program!!

fader_colnum:	dc.w	0

dc.w	-1
fader_table:	dcb.w	fader_maxnum*16
dc.w	-1
fader_pos:	dc.l	fader_table
fader_direct:	dc.w	0
fader_sleep:	dc.w	10
fader_slpcount:	dc.w	1



fader_real:
	move.w	fader_direct,d0
	beq.b	fader_skip
	subq.w	#1,fader_slpcount
	bne.b	fader_skip
	move.w	fader_sleep,fader_slpcount

	move.l	fader_pos,a0
	tst.w	(a0)
	bmi.b	fader_end

;	move.w	(a0)+,$180(a5)
	move.w	(a0)+,$182(a5)
	move.w	(a0)+,$184(a5)
	move.w	(a0)+,$188(a5)
	move.w	(a0)+,$192(a5)
	move.w	(a0)+,$194(a5)
;	move.w	(a0)+,$198(a5)
	move.w	(a0)+,$19a(a5)
	move.w	(a0)+,$19c(a5)

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
	bcc.b	fader_skipblue
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
	bpl.b	fader_noblueflow
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
	bcc.b	fader_skipgreen
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
	bpl.b	fader_nogreenflow
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
	bcc.b	fader_skipred
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
	bpl.b	fader_noredflow	
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




;;
linepoints1: dc.w  63

linepoints2: dc.w  3
linequant1: dc.w  3*4

linekoords:
dc.w	0,-4*32,-4*32,0
dc.w	0,+4*32,-4*32,0
dc.w	0,+4*32,+4*32,0
dc.w	0,-4*32,+4*32,0

dc.w	0,-134+0,43+0,0
dc.w	0,-134+8,43+0,0
dc.w	0,-134+8,43+8,0
dc.w	0,-134+0,43+8,0

;linekoordm:
dc.w	0,-160,-127,0
dc.w	0,+159,-127,0
dc.w	0,+159,+130,0
dc.w	0,-160,+130,0

linekoordd:
dc.w	0,0,0,0
dc.w	0,0,0,0
dc.w	0,0,0,0
dc.w	0,0,0,0



lines1:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 0

mettab:		dcb.b	8*4,0
metdiff:	dcb.b	8*4,0

wavepoint:	dc.w	0
Wave:
dc.w  17
dc.w  17
dc.w  17
dc.w  17
dc.w  17
dc.w  17
dc.w  17
dc.w  17
dc.w  18
dc.w  18
dc.w  18
dc.w  18
dc.w  18
dc.w  18
dc.w  19
dc.w  19
dc.w  19
dc.w  20
dc.w  20
dc.w  20
dc.w  21
dc.w  21
dc.w  21
dc.w  22
dc.w  23
dc.w  23
dc.w  24
dc.w  24
dc.w  25
dc.w  26
dc.w  27
dc.w  28
dc.w  29
dc.w  30
dc.w  31
dc.w  32
dc.w  33
dc.w  35
dc.w  36
dc.w  38
dc.w  40
dc.w  42
dc.w  44
dc.w  46
dc.w  49
dc.w  51
dc.w  54
dc.w  58
dc.w  61
dc.w  65
dc.w  69
dc.w  73
dc.w  78
dc.w  83
dc.w  88
dc.w  94
dc.w  100
dc.w  107
dc.w  115
dc.w  123
dc.w  131
dc.w  141
dc.w  151
dc.w  162
dc.w  174
dc.w  186
dc.w  200
dc.w  215
dc.w  231
dc.w  249
dc.w  268
dc.w  288
dc.w  310
dc.w  334
dc.w  360
dc.w  388
dc.w  418
dc.w  450
dc.w  486
dc.w  524
dc.w  565
dc.w  609
dc.w  657
dc.w  709
dc.w  766
dc.w  826
dc.w  892
dc.w  963
dc.w  1040

dc.w	-1

allplanes:
showplane2:	dc.l	plane12
clearplane2:	dc.l	plane22
pointplane2:	dc.l	plane32


background:	incbin	"data/background.con"
backgroundend:

linekoords1:
dcb.w	4*8*8,0
linekoord1:
dcb.w	4*8*8,0

codec_e:


section	memory,bss_c
bssc_s:
memory:	ds.b	120000
bssc_e:


;-----dotcursor--------------------------------------------------------
mp:		set memory

plane1=mp
mp:		set mp+1*256*64

plane2=mp
mp:		set mp+1*256*64

plane3=mp
mp:		set mp+1*256*64

plane4=mp
mp:		set mp+1*256*64

plane5=mp
mp:		set mp+1*256*64

plane6=mp
mp:		set mp+1*256*64

plane7=mp
mp:		set mp+1*256*64

printt	"Memory, first block:"
printv	mp-memory

;plane1:	blk.l	1*256*64/4,0
;plane2:	blk.l	1*256*64/4,0
;plane3:	blk.l	1*256*64/4,0
;plane4:	blk.l	1*256*64/4,0
;plane5:	blk.l	1*256*64/4,0
;plane6:	blk.l	1*256*64/4,0
;plane7:	blk.l	1*256*64/4,0
;----------------------------------------------------------------------
;-----veccursor--------------------------------------------------------
mp:		set memory+65538

plane12=mp
mp:		set mp+1*256*64

plane22=mp
mp:		set mp+1*256*64

plane32=mp
mp:		set mp+1*256*64
printt	"Memory, second block:"
printv	mp-memory

;plane12:	blk.l	256*64/4,0
;plane22:	blk.l	256*64/4,0
;plane32:	blk.l	256*64/4,0
;----------------------------------------------------------------------
;-----writerplane------------------------------------------------------
mp:		set memory+2	;(bad cls from dotroutine)

planeadr=mp
mp:		set mp+planesize*3
planeadrend=mp

;space for background
mp:		set mp+16384

printt	"Memory, third block:"
printv	mp-memory

;----------------------------------------------------------------------

printt	"Chipmemory needed:"
printv	codec_e-codec_s+bssc_e-bssc_s

printt
printt	"Section Code_C:"
printv	codec_e-codec_s

printt	"Section BSS_C:"
printv	bssc_e-bssc_s

