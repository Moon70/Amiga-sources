UseSection=1
Onlychip=0



Main_Joyhold=0

showtime=0
Program_ID=3

Main_SkipWBStartTest=1

Planesize=1*40

ifne	UseSection
section	CodeC,code_c
endif
codec_s:

include	"include/maininit/Maininit6.2.s"

bpl7pth=bpl6pth+4
bpl8pth=bpl7pth+4
bplcon3=$106
bplcon4=$10c
FMODE=$1fc

;------------------------------------------------------------------------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand

	jsr	Fader3_Helmi

	lea	Junky1,a0
	lea	JunkyS,a1
	moveq	#15,d7
	moveq	#0,d0
junkbordclr:
	move.l	d0,-(a0)
	move.l	d0,-(a1)
	dbf	d7,junkbordclr

SineAdd:
	lea	wavesin,a0
	lea	wavesin2,a1
	move.w	#(WavesinE-Wavesin)/2-1,d7
SineAdd_loop:
	add.w	#256*3,(a0)+
	add.w	#256*3,(a1)+
	dbf	d7,SineAdd_loop

move.l	#0,colours

	lea	turnsin,a0
	move.w	#(turnsinend-turnsin)/2-1,d7
turnsincorr_loop:
	move.w	(a0),d0
	bpl.b	turnsincorr_noneg
	add.w	#360*4,d0
turnsincorr_noneg:
	move.w	d0,(a0)+
	dbf	d7,turnsincorr_loop

	move.l	#coord_d,turnkoord
	move.l	#coord_s,turnkoords
	move.w	#3,turnquant
	move.w	#4*0,turnaddz

	jsr	ColConvert
	jsr	MakeJunkyColTable

	lea	Copperlist1,a0
	jsr	coppercopy
	lea	Copperlist2,a0
	jsr	coppercopy

	jsr	Coplist_makedelta

jsr	turner
jsr	perspective
jsr	Junky_Set

lea	copperlist_work,a0
move.l	(a0),d0
move.l	4(a0),(a0)+
move.l	d0,(a0)

jsr	Junky_Set

	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0000001000010000,bplcon0(a5)
	move.w	#%0111001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#00,bpl1mod(a5)
	move.w	#00,bpl2mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI_Pic,(a0)


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

bra	sepp

	lea	colours,a0
	moveq	#7,d6
colcopyloop2:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)
	move.w	d2,d3
	bset.l	#9,d3


	lea	$180(a5),a1
	moveq	#31,d7
colcopyloop1:
;	move.l	(a0)+,d0
	move.l	#0,d0
	move.l	d0,d1

	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	swap	d1
	lsr.w	#4,d1

	lsr.l	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	swap	d0
	lsr.w	#4,d0

	move.w	d1,(a1)
	move.w	d2,bplcon3(a5)
	move.w	d0,(a1)+
	move.w	d3,bplcon3(a5)

	dbf	d7,colcopyloop1
	dbf	d6,colcopyloop2

sepp:

	move.w	#0,bplcon3(a5)
	move.w	#0,$180(a5)

	move.l	Main_Copperlist(pc),a0
;	move.l	#copperlist1,(a0)
	move.l	Main_MasterCommand(pc),a0
;	move.l	#MainLoop,4(a0)		;second priority mastercommand


rts



mainloop:;;
	move.w	#0,f_VBI
waitframe:
	tst.w	f_VBI
	beq.b	waitframe

;----- zoom -----
lea	focus,a0
move.w	(a0)+,d0
add.w	(a0),d0
cmp.w	#26,d0
bne.b	nounderflow
neg.w	(a0)

nounderflow:
cmp.w	#200,d0
bne.b	nooverflow
neg	(a0)

nooverflow:

tst.w	f_zoom
beq.b	skipzoom
move.w	d0,-(a0)
move.w	zoom_dest,d1
cmp.w	d1,d0
bne	skipzoom
move.w	#0,f_zoom

skipzoom:

;----------------

	jsr	turner
	jsr	perspective

	jsr	Junky_Set

	lea	copperlist_work,a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	move.l	Main_Copperlist(pc),a0
	move.l	d0,(a0)

move.w	framecount,look
move.w	#0,framecount
mainloop_skip:
	rts
;----------

Commands:;;
	dc.l	288,	nothing
	dc.l	96,	setscreencopy
	dc.l	1,	setwater
	dc.l	1,	setwaterscreen
	dc.l	94,	setzoom,	50
	dc.l	192,	shade_off
	dc.l	96,	turn_on
	dc.l	192,	setzoom,	150
	dc.l	192,	setzoom,	70
	dc.l	96,	setzoom,	150
	dc.l	192,	shade_on
	dc.l	192,	setzoom,	100
	dc.l	96,	setzoom,	50
	dc.l	192,	setzoom,	120



	dc.l	50,	getout
	dc.l	60000,	exit
	dc.l	60000,	nothing


	dc.l	100,	turn_off




	dc.l	5000,	turn_off
;	dc.l	500,	nothing
	dc.l	50,	turn_on
;	dc.l	500,	turn_off
	dc.l	500,	shade_on

	dc.l	60000,	nothing
	

getout:
	move.w	#1,f_clrscreen
	rts

setscreencopy:
	move.w	#1,f_screencopy
	rts


setzoom:
	move.l	(a1)+,d0
	move.w	d0,zoom_dest
	addq.w	#4,Commander_Point
	move.w	#1,f_zoom
	move.w	focus,d1
	cmp.w	d0,d1
	bhi	setzoom_lower
	move.w	#2,focus+2
	rts

setzoom_lower:
	move.w	#-2,focus+2
	rts


setwater:
	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist1,(a0)
	move.l	Main_MasterCommand(pc),a0
	move.l	#MainLoop,4(a0)		;second priority mastercommand

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)
	rts

Setwaterscreen:
;	move.w	#$2981,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0000001000010000,bplcon0(a5)
	move.w	#%0111001000000000,bplcon0(a5)
;	move.w	#0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)
	move.w	#-40,bpl1mod(a5)
	move.w	#-40,bpl2mod(a5)
;	move.w	#%0000000000000011,fmode(a5)
;	move.w	#%1000001100000000,dmacon(a5)

	lea	Screen,a0
	move.l	a0,bpl1pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl7pth(a5)

	moveq	#0,d0
	moveq	#7,d6
colclrloop3:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)
	move.w	d2,d3
	bset.l	#9,d3

	lea	$180(a5),a1
	move.w	d2,bplcon3(a5)
	moveq	#15,d7
colclrloop1:
	move.l	d0,(a1)+
	dbf	d7,colclrloop1

	lea	$180(a5),a1
	move.w	d3,bplcon3(a5)
	moveq	#15,d7
colclrloop2:
	move.l	d0,(a1)+
	dbf	d7,colclrloop2
	dbf	d6,colclrloop3

	rts

turn_on:
	move.w	#1,f_turn
	rts

turn_off:
	moveq	#0,d0
	move.w	d0,f_turn
	move.w	d0,turnaddz
	rts

shade_on:
	move.l	#JunkyWS,Junky_Code
	rts

shade_off:
	move.l	#JunkyW,Junky_Code
	rts



nothing:	rts

exit:
	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	move.l	d0,(a0)
	rts

codec_e:


ifne	UseSection
section	DataC,data_c
endif
datac_s:
Screen:
	incbin	"data/JunkyGrid_3.blt1"

Title:
	incbin	"data/Helmi_Text.blt"
TitleCol:
	incbin	"data/Helmi_Text.blt.pal"

;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
include	"Include/Fader3/Fade.s"
include	"Include/Fader3/Calc.s"
include	"Include/Fader3/Start.s"
;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

Fader3_Helmi:
	lea	col_white,a0			;colour source
	lea	col_Helmi,a1			;colour dest
	lea	col_Fade_Helmi,a2		;colour fading list
	lea	Fader3_table_Helmi,a3		;fader calc table
	move.w	#Fader3_Colquant_Helmi,d7	;number of cols
	move.w	#40,d0			;fadesteps
	bsr	Fader3_Calc

	lea	Fader3_table_Helmi,a0	;point in fader-table
	moveq	#0,d0
	bsr	Fader3_Start
rts

Fader3_Colquant_Helmi=256			;number of colours in this calculation
Fader3_Table_Helmi:	
	dcb.l	Fader3_Colquant_Helmi*6+3
Fader3_Tableend_Helmi:


;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII


Col_White:		dcb.l	256,$00ffffff
Col_Fade_Helmi:	dcb.l	256,0

datac_e:



ifne	UseSection
ifeq	Onlychip
section	CodeP,code_p
else
section	CodeP,code_c	;onlychip
endif
endif
codep_s:

VBI:
	lea	Screen,a0
	move.l	a0,bpl1pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl7pth(a5)

	jsr	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount

tst.w	f_clrscreen
beq	noclrscreen

bsr	clrscreen
noclrscreen:
rts

clrsleep:	dc.w	1
f_clrscreen:	dc.w	0

clrscreen:
subq.w	#1,clrsleep
bne	clrscreen_skip
move.w	#3,clrsleep
	lea	screen,a0
	moveq	#7-1,d7
clrscreen_planeloop:
	moveq	#20-1,d6
clrscreen_wordloop:
	move.w	(a0),d0
	lsr.w	#1,d0
	move.w	d0,(a0)+
	dbf	d6,clrscreen_wordloop
	lea	planesize-40(a0),a0
	dbf	d7,clrscreen_planeloop

clrscreen_skip:
	rts


VBI_Pic:
	lea	Title,a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl7pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl8pth(a5)

	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
	move.w	#%0000001000010000,bplcon0(a5)
;	move.w	#%0111001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#280,bpl1mod(a5)
	move.w	#280,bpl2mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)


;---
	jsr	Fader3_Fade

	lea	Col_Fade_Helmi,a0
	moveq	#7,d6
colcopyloop22:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)
	move.w	d2,d3
	bset.l	#9,d3

	lea	$180(a5),a1
	moveq	#31,d7
colcopyloop11:
	move.l	(a0)+,d0
	move.l	d0,d1

	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	swap	d1
	lsr.w	#4,d1

	lsr.l	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	swap	d0
	lsr.w	#4,d0

	move.w	d0,(a1)
	move.w	d3,bplcon3(a5)
	move.w	d1,(a1)+
	move.w	d2,bplcon3(a5)

	dbf	d7,colcopyloop11
	dbf	d6,colcopyloop22
;---

tst.w	f_screencopy
beq	noscrreencopy
	bsr	screencopy
noscrreencopy:

	jsr	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount
rts


Screencopy_pos:	dc.w	0

Screencopy:
	lea	Screencopy_pos(pc),a0
	moveq	#0,d0
	move.w	(a0),d0
	cmp.w	#255,d0
	beq	Screencopy_skip
	addq.w	#3,d0
	move.w	d0,(a0)
	move.l	d0,d1
	mulu.w	#320,d0		;40*8=320
	lsl.l	#8,d1		;32*8=256
	lea	Title,a0
	add.l	d0,a0
	lea	Picture,a1
	add.l	d1,a1

	move.l	#%00100100100100100100100100100100,d3
	moveq	#7,d7
Screencopy_loopP:
	moveq	#0,d0
	move.l	d0,2*40*8(a0)
	move.l	d0,1*40*8(a0)
	move.l	d0,(a0)+
	moveq	#15,d6
Screencopy_loopX:
	move.l	(a1),d0
	and.l	d3,d0
	move.l	d0,d1
	add.l	d1,d1
	or.l	d1,d0
	add.l	d1,d1
	or.l	d1,d0
	swap	d0
	move.w	d0,2*40*8(a0)
	move.w	d0,1*40*8(a0)
	move.w	d0,(a0)+

addq.w	#2,a1
	dbf	d6,Screencopy_loopX
	moveq	#0,d0
	move.l	d0,2*40*8(a0)
	move.l	d0,1*40*8(a0)
	move.l	d0,(a0)+
	dbf	d7,Screencopy_loopp


Screencopy_skip:
	rts

Coppercopy:
;--> a0  ;address of copperlist
	move.l	a0,d3		;copadr to calc offsets
	move.w	#$2701,d0

	lea	Coplist_Offset,a2
	move.w	#bplcon0,(a0)+
	move.w	#%0111001000000000,(a0)+

	moveq	#jy-1,d5
Coppercopy_Blockloop:
	moveq	#3,d1		;bank number 3 (calc col 0-127)

	move.w	palswap(pc),d2	;bank offset (0 or 128)
	bchg	#15,d2		;offset 0<-->128
	beq.b	Coppercopy_Lowline
	moveq	#7,d1		;now lowshow=now highcalc, (col 128-255) 

Coppercopy_Lowline:
	move.w	d2,palswap
	move.w	#bplcon4,(a0)+
	move.w	d2,(a0)+	;set pal offset

	ror.w	#3,d1
	move.w	d0,(a0)+	;set rasterline
	move.w	#-2,(a0)+

	moveq	#2,d7
Coppercopy_Lineloop:
	move.w	#$1c0,d2	;highest colreg
	move.w	#bplcon3,(a0)+
	move.w	d1,(a0)+	;set colbank  number

	moveq	#31,d6
Coppercopy_Regloop:
	subq.w	#2,d2		;colreg adr decrement
	move.w	d2,(a0)+	;colreg adr

	move.l	a0,d4		;copperlist position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset

	move.w	#$0,(a0)+
	dbf	d6,Coppercopy_regloop

	rol.w	#3,d1
	subq.w	#1,d1
	ror.w	#3,d1
	dbf	d7,Coppercopy_lineloop

	move.w	#$1c0,d2
	move.w	#bplcon3,(a0)+
	move.w	d1,(a0)+
	moveq	#9,d6		;4 bonus moves (5 possible)
Coppercopy_Regloop2:
	subq.w	#2,d2		;colreg adr decrement
	move.w	d2,(a0)+	;colreg adr

	move.l	a0,d4		;copperlist position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset

	move.w	#$0,(a0)+
	dbf	d6,Coppercopy_regloop2

	add.w	#$0300,d0	;rasterpos

	dbf	d5,Coppercopy_blockloop

	move.w	palswap(pc),d2
	bchg.l	#15,d2
	move.w	#bplcon4,(a0)+
	move.w	d2,(a0)+

	move.l	#-2,(a0)

	add.w	#$0200,d0	;rasterpos
	move.w	d0,(a0)+	;set rasterline
	move.w	#-2,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
rts

Coplist_makedelta:
	lea	Coplist_Offset,a0
	move.w	#jx*jy-1-1,d7	;-loop-first value (first is NO delta)
	move.w	(a0)+,d0	;start value
Coplist_makedelta_loop:
	move.w	(a0),d1		;new offset
	sub.w	d1,d0		;act pos-new offset
	neg.w	d0
	move.w	d0,(a0)+	;write new delta
	move.w	d1,d0		;new offset = akt pos
	dbf	d7,Coplist_makedelta_loop

rts



palswap:	dc.w	0

jx=106;93		;junky resolution x
jy=85;128		;junky resolution y

;got 4 coordinates:



Junky_Code:	dc.l	Junky

Junky_Set:
	move.l	Junky_Code(pc),a0
	jmp	(a0)


;***********************************************************************
;***********************************************************************
JunkyW:
	lea	Scaledata,a3

	lea	wavepointx1,a6
	move.w	(a6),d2
	add.w	#18,d2
	cmp.w	#WavesinE-Wavesin-4*360*2,d2
	bne.b	JunkyW_nowavesinxflow1
	sub.w	#720,d2
JunkyW_nowavesinxflow1:
	move.w	d2,(a6)+
	move.w	d2,2(a6)

	move.w	(a6),d2
	add.w	#12,d2
	cmp.w	#Wavesin2E-Wavesin2-4*360*2,d2
	bne.b	JunkyW_nowavesinyflow1
	sub.w	#720,d2
JunkyW_nowavesinyflow1:
	move.w	d2,(a6)+
	move.w	d2,2(a6)

	lea	Coord_d,a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+2(a0),d0	;cx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;cx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,(a3)	;mdx
	swap	d1
	move.l	d1,mdpx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+4(a0),d0	;cy
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;cy-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,mdy(a3)
	swap	d1
	move.l	d1,mdpy(a3)



	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,ldx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,ldy(a3)

	move.l	Copperlist_work,a0
	lea	Coplist_Offset,a1
	lea	Junky1-64,a2
	move.l	ldx(a3),d0
	move.l	ldy(a3),d1

nop
	moveq	#jy-1,d7
JunkyW_Sety:
	move.l	mdpx(a3),d4
	move.l	mdpy(a3),d5


	lea	wavepointx2(pc),a6
	lea	wavesin2(pc),a5
	move.w	(a6),d2
	addq.w	#6,d2
	move.w	d2,(a6)+

	add.w	d2,a5

	move.w	(a6),d2
	addq.w	#8,d2
	move.w	d2,(a6)+

	add.w	d2,a6


	moveq	#jx-1,d6
JunkyW_Setx:
	move.l	d4,d2
	move.l	d5,d3

;	sub.w	d2,d2
	swap	d2
	sub.w	d3,d3
	swap	d3


	add.w	(a6)+,d2
	add.w	(a5)+,d3

	lsl.w	#8,d3
	move.b	d2,d3		;this is real megafast coding
	add.w	(a1)+,a0	;copperlist position
	add.l	d3,d3

	move.w	(a2,d3.l),d2
	move.w	d2,(a0)

	add.l	d0,d4	;ldx
	add.l	d1,d5	;ldy

	dbf	d6,JunkyW_Setx

	move.l	(a3),d3	;mdx
	add.l	d3,mdpx(a3)
	move.l	mdy(a3),d3
	add.l	d3,mdpy(a3)

	dbf	d7,JunkyW_Sety
	lea	$dff000,a5
rts

;***********************************************************************
;***********************************************************************
dcb.b	4,0

JunkyWS:
	lea	Scaledata,a3

	lea	wavepointx1,a6
	move.w	(a6),d2
	add.w	#18,d2
	cmp.w	#WavesinE-Wavesin-4*360*2,d2
	bne.b	JunkyWS_nowavesinxflow1
	sub.w	#720,d2
JunkyWS_nowavesinxflow1:
	move.w	d2,(a6)+
	move.w	d2,2(a6)

	move.w	(a6),d2
	add.w	#12,d2
	cmp.w	#WavesinE-Wavesin-4*360*2,d2
	bne.b	JunkyWS_nowavesinyflow1
	sub.w	#720,d2
JunkyWS_nowavesinyflow1:
	move.w	d2,(a6)+
	move.w	d2,2(a6)


	lea	Coord_d,a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+2(a0),d0	;cx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;cx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,(a3)	;mdx
	swap	d1
	move.l	d1,mdpx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+4(a0),d0	;cy
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;cy-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,mdy(a3)
	swap	d1
	move.l	d1,mdpy(a3)



	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,ldx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,ldy(a3)

	move.l	Copperlist_work,a0
	lea	Coplist_Offset,a1
	lea	JunkyS-64,a2
	move.l	ldx(a3),d0
	move.l	ldy(a3),d1
	moveq	#jy-1,d7
nop
JunkyWS_Sety:
	move.l	mdpx(a3),d4
	move.l	mdpy(a3),d5

	lea	wavepointx2(pc),a6
	lea	wavesin2(pc),a5
	move.w	(a6),d2
	addq.w	#6,d2
	move.w	d2,(a6)+

	add.w	d2,a5

	move.w	(a6),d2
	addq.w	#8,d2
	move.w	d2,(a6)+

	add.w	d2,a6

	moveq	#jx-1,d6
JunkyWS_Setx:
	move.l	d4,d2
	move.l	d5,d3

;	sub.w	d2,d2
	swap	d2
	sub.w	d3,d3
	swap	d3


	add.w	(a6)+,d2
	add.w	(a5)+,d3

	lsl.w	#8,d3
	move.b	d2,d3		;this is real megafast coding
	add.w	(a1)+,a0	;copperlist position
	add.l	d3,d3

	move.w	(a2,d3.l),d2	;col from Helmi

	move.w	(a0),d3	;col shadow 2
	and.w	#%0000111011101110,d3
	add.w	d3,d2
	lsr.w	#1,d2

	move.w	d2,(a0)

	add.l	d0,d4	;ldx
	add.l	d1,d5	;ldy

	dbf	d6,JunkyWS_Setx

	move.l	(a3),d2	;mdx
	add.l	d2,mdpx(a3)
	move.l	mdy(a3),d2
	add.l	d2,mdpy(a3)

	dbf	d7,JunkyWS_Sety
	lea	$dff000,a5
rts


;***********************************************************************
;***********************************************************************

Junky:
	lea	Scaledata,a3

	lea	Coord_d,a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+2(a0),d0	;cx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;cx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,(a3)	;mdx
	swap	d1
	move.l	d1,mdpx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+4(a0),d0	;cy
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;cy-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,mdy(a3)
	swap	d1
	move.l	d1,mdpy(a3)



	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#jx,d0
	move.l	d0,ldx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#jy,d0
	move.l	d0,ldy(a3)

	move.l	Copperlist_work,a0
	lea	Coplist_Offset,a1
	lea	Junky1-64,a2
	move.l	ldx(a3),d0
	move.l	ldy(a3),d1

nop
	moveq	#jy-1,d7
Junky_Sety:
	move.l	mdpx(a3),d4
	move.l	mdpy(a3),d5


	moveq	#jx-1,d6
Junky_Setx:
	move.l	d4,d2
	move.l	d5,d3

;	sub.w	d2,d2
	swap	d2
	sub.w	d3,d3
	swap	d3


	lsl.w	#8,d3
	move.b	d2,d3		;this is real megafast coding
	add.w	(a1)+,a0	;copperlist position
	add.l	d3,d3

	move.w	(a2,d3.l),d2
	move.w	d2,(a0)

	add.l	d0,d4	;ldx
	add.l	d1,d5	;ldy

	dbf	d6,Junky_Setx

	move.l	(a3),d3	;mdx
	add.l	d3,mdpx(a3)
	move.l	mdy(a3),d3
	add.l	d3,mdpy(a3)

	dbf	d7,Junky_Sety
	lea	$dff000,a5
rts



;***********************************************************************
;***********************************************************************





turner:	;last optimizing:93-09-05
	lea	turnsinpoint,a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#turnsinend-turnsin,d0
	bne.b	noturnsinflow
	moveq	#0,d0
noturnsinflow:
	move.w	d0,(a0)+
	move.w	(a0,d0.w),d0

	tst.w	f_turn
	beq.b	no_turn
	move.w	d0,turnaddz
no_turn:

	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz

turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sinus,a6	;sinus/cosinus
	move.w	turnquant,d0
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

	subq.w	#8,d0
	bpl.b	turnrout1
	rts
;*****

perspective:
	move.l	turnkoord,a3
	move.l	turnkoord,a4
	move.w	turnquant,d7

perspectiveloop:

move.w	2(a3),d0
move.w	4(a3),d1
move.w	6(a3),d2
neg.w	d2
asr.w	#1,d2
add.w	#100,d2

;---
move.w	focus,d3
muls.w	d3,d0
muls.w	d3,d1
divs	d2,d0
divs	d2,d1

;---
add.w	#160,d0
add.w	#128,d1

move.w	d0,2(a4)
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop
rts


focus:	dc.w	100
	dc.w	-2






ColConvert:
	lea	Colours,a0
	move.l	a0,a1
	move.w	#255,d7
ColConvert_loop:
	move.l	(a0)+,d0
	lsr.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	swap	d0
	move.w	d0,(a1)+
	dbf	d7,ColConvert_loop
	rts

MakeJunkyColTable:
	lea	picture+31,a0
	lea	colours,a2
	lea	Junky1,a3
	lea	JunkyS,a4

	move.w	#255,d7
MakeJunkyColTable_y:
	move.w	#255,d6
MakeJunkyColTable_x:
	moveq	#0,d0
	move.w	d6,d0
	move.w	d7,d1

	move.w	d0,d2
;	not.w	d2
	lsr.w	#3,d0
	mulu.w	#32*8,d1
	sub.l	d0,d1
	move.l	a0,a1
	add.l	d1,a1

	moveq	#0,d3

	btst.b	d2,7*32(a1)
	beq.b	MakeJunkyColTable_no7
	add.w	#128,d3

MakeJunkyColTable_no7:
	btst.b	d2,6*32(a1)
	beq.b	MakeJunkyColTable_no6
	add.w	#64,d3

MakeJunkyColTable_no6:
	btst.b	d2,5*32(a1)
	beq.b	MakeJunkyColTable_no5
	add.w	#32,d3

MakeJunkyColTable_no5:
	btst.b	d2,4*32(a1)
	beq.b	MakeJunkyColTable_no4
	add.w	#16,d3

MakeJunkyColTable_no4:
	btst.b	d2,3*32(a1)
	beq.b	MakeJunkyColTable_no3
	addq.w	#8,d3

MakeJunkyColTable_no3:
	btst.b	d2,2*32(a1)
	beq.b	MakeJunkyColTable_no2
	addq.w	#4,d3

MakeJunkyColTable_no2:
	btst.b	d2,1*32(a1)
	beq.b	MakeJunkyColTable_no1
	addq.w	#2,d3

MakeJunkyColTable_no1:
	btst.b	d2,0*32(a1)
	beq.b	MakeJunkyColTable_no0
	addq.w	#1,d3

MakeJunkyColTable_no0:

	add.w	d3,d3
	move.w	(a2,d3.w),d0
	move.w	d0,(a3)+
	and.w	#%0000111011101110,d0
	move.w	d0,(a4)+
	dbf	d6,MakeJunkyColTable_x
	dbf	d7,MakeJunkyColTable_y

rts



wavepointx1:	dc.w	0
wavepointy1:	dc.w	0
wavepointx2:	dc.w	0
wavepointy2:	dc.w	0

Wavesin:
;rept	6
	incbin	"data/wavesinxx.bin"
;endr
WavesinE:

Wavesin2:
;rept	6
	incbin	"data/wavesinyy.bin"
;	incbin	"data/wavesiny.bin"
;endr
Wavesin2E:




f_screencopy:	dc.w	0
f_VBI:	dc.w	0
framecount:	dc.w	0
look:
codep_e:


ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
Copperlist1:	dcb.b	38504,0
Copperlist2:	dcb.b	38504,0
bssc_e:



ifne	UseSection
ifeq	Onlychip
section	DataP,data_p
else
section	DataP,data_c	;onlychip
endif
endif
datap_s:
Multab640:
value:	set	0
rept	256
;dc.l	value*640
dc.l	value*512
value:	set	value+1
endr


Scaledata:	rsreset
dcb.l	8,0

mdx:	rs.l	1
mdy:	rs.l	1
ldx:	rs.l	1
ldy:	rs.l	1

mdpx:	rs.l	1
mdpy:	rs.l	1

sizex=160
sizey=128
Coord_s:
	dc.w	0,-sizex,+sizey,0
	dc.w	0,+sizex,+sizey,0
	dc.w	0,-sizex,-sizey,0
	dc.w	0,+sizex,+sizey,0

Coord_d:
	dc.w	0,000,000,0
	dc.w	0,320,000,0
	dc.w	0,000,256,0
	dc.w	0,320,256,0

Copperlist_work:	dc.l	copperlist1
Copperlist_show:	dc.l	copperlist2


turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddz:	dc.w	0
turnz:		dc.w	0
f_turn:		dc.w	0
f_zoom:		dc.w	0
zoom_dest:	dc.w	0
dc.l	0
col_Helmi:
colours:	incbin	"data/helmi.blt.pal"
Picture:	incbin	"data/helmi.blt32"

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

turnsinpoint:	dc.w	0	;|
Turnsin:			;|
dc.W  0, 0, 0, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 12, 12, 12
dc.W  12, 12, 12, 12, 16, 16, 16, 16, 16, 16, 16, 16, 16
dc.W  16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
dc.W  20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
dc.W  20, 20, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
dc.W  16, 16, 16, 16, 16, 12, 12, 12, 12, 12, 12, 12, 12
dc.W  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12
dc.W  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 16
dc.W  16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16
dc.W  16, 16, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
dc.W  20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
dc.W  20, 20, 20, 20, 16, 16, 16, 16, 16, 16, 16, 16, 16
dc.W  12, 12, 12, 12, 12, 12, 12, 8, 8, 8, 8, 8, 8, 4, 4
dc.W  4, 4, 4, 0, 0, 0, 0, 0,-4,-4,-4,-4,-4,-8,-8,-8,-8,-8
dc.W -8,-12,-12,-12,-12,-12,-12,-12,-16,-16,-16,-16,-16,-16
dc.W -16,-16,-16,-16,-20,-20,-20,-20,-20,-20,-20,-20,-20
dc.W -20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20
dc.W -20,-20,-20,-20,-20,-16,-16,-16,-16,-16,-16,-16,-16
dc.W -16,-16,-16,-16,-16,-16,-16,-16,-12,-12,-12,-12,-12
dc.W -12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12
dc.W -12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12
dc.W -12,-12,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.W -16,-16,-16,-16,-16,-20,-20,-20,-20,-20,-20,-20,-20
dc.W -20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20
dc.W -20,-20,-20,-20,-20,-20,-20,-16,-16,-16,-16,-16,-16
dc.W -16,-16,-16,-12,-12,-12,-12,-12,-12,-12,-8,-8,-8,-8
dc.W -8,-8,-4,-4,-4,-4,-4, 0, 0
Turnsinend:


datap_e:

ifne	UseSection
ifeq	Onlychip
section	BSSP,bss_p
else
section	BSSP,bss_c	;onlychip
endif
endif
bssp_s:
	ds.w	32
Junky1:	ds.w	320*256
	ds.w	32
JunkyS:	ds.w	320*256
Coplist_Offset:	ds.w	jx*jy		;junky x * junky y
		ds.l	1

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
printt	"Object Memory:"
printv	codec_e-codec_s+datac_e-datac_s+codep_e-codep_s+datap_e-datap_s
printt	"Total Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s+codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s



