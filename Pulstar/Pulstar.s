;--------------------------------------------
;-                                          -
;-                 Pulstar                  -
;-                ---------                 -
;-                                          -
;-    code by Moon                          -
;-    music by Substance/Avocado/Massive    -
;-    logo by Celtic/Axis                   -
;-                                          -
;-                                          -
;--------------------------------------------
allocmem=-30-168
freemem=-30-180
determ_flash=0
UseSection=1
Onlychip=0
showmem=1
Main_Callcommander=1
precalc=1
music=1

;---parameter setup------------------------------------------------------
Jx=106		;junky resolution x
Jy=85		;junky resolution y
Jbxl=0		;junky border x left
Jbxr=1		;junky border x right
Jbyt=10		;junky border y top
Jbyb=10		;junky border y bottom

Jsx=Jbxl+Jx+Jbxr
Jsy=Jbyt+Jy+Jbyb
Coplist_OffsetSize=Jsx*Jsy		;junky x * junky y
;Coplist_OffsetSize=128*jy		;to avoid mulu ;fakemulx
;whole area for calculating (visible+invisible part!)

Junkybordersize=(Jsx*Jsy)-(jx*jy)
OnelineGrid=1
Onepic=1	;1=set x/y to zero if overflow in junky_set
		;0=sub to get more pics if overflow
;------------------------------------------------------------------------
;---parameter check------------------------------------------------------
;----

;------------------------------------------------------------------------

white=0
fadedown=0
colmix=1
colmix2=0


Main_Joyhold=0

showtime=0
Program_ID=3

Main_SkipWBStartTest=0

ifne	onelinegrid
Planesize=1*40
else
Planesize=256*40
endif

ifne	UseSection
section	CodeC,code_c
endif
codec_s:

include	"include/maininit/Maininit6.2.s"

dc.b	"$VER: Pulstar by Moon/ABYSS + Substance/AVOCADO + Celtic/AXIS",0
even
dcb.b	2,0

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

	jsr	textcalc

	move.l	#400000,d0
	moveq	#4,d1	;fast! memory
	move.l	4.w,a6
	jsr	allocmem(a6)
	move.l	d0,fastmem

	lea	Code,a0
	lea	Code_AbyssHAM8,a1
	lea	MoonLib,a6
	jsr	(a6)

	lea	code,a0
	move.l	a0,a1
	sub.l	a2,a2
	jsr	4(a6)

	lea	code,a4
	move.l	Main_VBIVector,a0
	move.l	Main_Copperlist,a1
	move.l	Main_Talk,a2
	move.l	Main_MasterCommand,a3
	jsr	1*6(a4)


	jsr	Convert_Squarecoords

	lea	turnsin,a0
	move.w	#(allturnsinend-turnsin)/2-1,d7
turnsincorr_loop:
	move.w	(a0),d0

	bpl.b	turnsincorr_noneg
	add.w	#360*4,d0
turnsincorr_noneg:
	move.w	d0,(a0)+
	dbf	d7,turnsincorr_loop


CalcBlurTab:;calculates table for megafast-blur-fakeing-routine
	lea	BlurTab,a0
	move.w	#$1000-1,d7
	moveq	#0,d0
CalcBlurTab_loop:
	move.w	d0,d1		;r
	lsr.w	#8,d1

	move.w	d0,d2		;g
	lsr.w	#4,d2
	and.w	#%1111,d2

	move.w	d0,d3		;b
	and.w	#%1111,d3

	subq.w	#1,d1
	bpl	CalcBlurTab_noRflow
	moveq	#0,d1
CalcBlurTab_noRflow:

	subq.w	#1,d2
	bpl	CalcBlurTab_noGflow
	moveq	#0,d2
CalcBlurTab_noGflow:

	subq.w	#1,d3
	bpl	CalcBlurTab_noBflow
	moveq	#0,d3
CalcBlurTab_noBflow:

	lsl.w	#4,d1
	or.w	d2,d1
	lsl.w	#4,d1
	or.w	d3,d1

	move.w	d0,d2
	and.w	#%0000111011101110,d2
	lsr.w	#1,d2

	move.w	d2,4096*2(a0)
	move.w	d1,(a0)+
	addq.w	#1,d0
	dbf	d7,CalcBlurTab_loop


	move.l	#coord_d,turnkoord
	move.l	#coord_s,turnkoords
	move.w	#3,turnquant
	move.w	#4*0,turnaddz


	lea	Copperlist1,a0
	lea	Junkyborder1,a1		;list of invisible colors
	jsr	coppercopy
	lea	Copperlist2,a0
	lea	Junkyborder2,a1		;list of invisible colors
	jsr	coppercopy

	jsr	Coplist_makedelta

ifne	precalc
	move.w	#0,turnaddz
	move.w	#0,turnz
	moveq	#45-1,d7	;45 pics for table
precalcloop:
	move.l	d7,-(a7)
	jsr	turner
	jsr	perspective
	jsr	Junky_Set
	move.l	(a7)+,d7
	add.w	#8*4,turnz
	move.w	#0,bplcon3(a5)
	dbf	d7,precalcloop

else
	jsr	turner
	jsr	perspective
	jsr	Junky_Set
endif
	lea	copperlist_work,a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	jsr	Junky_Set

ifne	music
	lea	module,a0
	sub.l	a1,a1
	move.l	a5,a6
	jsr	P60_Init
endif
	move.w	#1,commander_sleep
	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
main_Back:
	movem.l	d0-a6,-(a7)
ifne	music
	move.l	a5,a6
	jsr	P60_end
endif
	move.l	FastMem,d0
	beq	nofastmem
	move.l	d0,a1
	move.l	#400000,d0
	move.l	4.w,a6
	jsr	freemem(a6)

nofastmem:
	move.w	#%0000000000001111,dmacon(a5)
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
;	move.w	#$2981,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)
;:	move.w	#%0000001000010000,bplcon0(a5)
;	move.w	#%0111001000000000,bplcon0(a5)
;	move.w	#0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)
;	move.w	#00,bpl1mod(a5)
;	move.w	#00,bpl2mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)


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


	move.w	#0,bplcon3(a5)
	move.w	#0,$180(a5)

;	move.l	Main_Copperlist(pc),a0
;	move.l	#copperlist1,(a0)
;	move.l	Main_MasterCommand(pc),a0
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
;---------------
ifne	precalc
	jsr	turner
	jsr	perspective
;if	setblockcode=1
	move.l	Code_Setblock(pc),a0
	jsr	(a0)
;	jsr	Setblock
;else
;	jsr	Setblock2
;endif
	jsr	Junky_Readtable
else;-----
	jsr	turner
	jsr	perspective
;if	setblockcode=1
	move.l	Code_Setblock(pc),a0
	jsr	(a0)
;	jsr	Setblock
;else
;	jsr	Setblock2
;endif
	jsr	Junky_Set
endif
;---------------
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

;Code_Setblock:	dc.l	Setblock
;Code_Setblock:	dc.l	Setblock2
;Code_Setblock:	dc.l	Draw_Square
Code_Setblock:	dc.l	0

FastMem:	dc.l	0

Commands:;;
	dc.l	60000,	nothing
	dc.l	1600,	execute_abyss

	dc.l	1,	setsquare
	dc.l	1,	setwater
	dc.l	700,	setwaterscreen

rept	3
;dc.l	60000,	nothing
endr

	dc.l	1,	setthreesquaresin0
	dc.l	1,	setwater
	dc.l	1000,	setwaterscreen

;	dc.l	1,	killemall
	dc.l	62100,	Set_ExecuteAbyssBlur
	dc.l	2100,	cacheson
;	dc.l	1,	killemall

	dc.l	1,	setthreesquaresin0
	dc.l	1,	setwater
	dc.l	600,	setwaterscreen


	dc.l	800,	setthreesquaresin1
	dc.l	700,	setthreesquaresin0

;	dc.l	400,	setthreesquaresin1
;	dc.l	600,	setthreesquaresin0
;	dc.l	1,	setwater
;	dc.l	1500,	setwaterscreen

;	dc.l	1,	killemall
	dc.l	62100,	Set_ExecuteWaterJames
	dc.l	2100,	cacheson
;	dc.l	1,	killemall



	dc.l	1,	setthreesquaresin0
	dc.l	1,	setwaterANDinitscroll
	dc.l	700,	setwaterscreen
	dc.l	1000,	setthreesquaresin1
	dc.l	330,	setthreesquaresin0

;	dc.l	1,	Init_Scroller
	dc.l	700,	Set_Scroller
	dc.l	1000,	setthreesquaresin1


	dc.l	60000,	exit

	dc.l	1,	setsquare
	dc.l	1,	setwater
	dc.l	1000,	setwaterscreen




dc.l	60000,	nothing
dc.l	60000,	nothing
dc.l	60000,	nothing


KillEmAll:
	move.l	Main_MasterCommand(pc),a0
	move.l	#0,4(a0)		;second priority mastercommand

	move.l	Main_Copperlist(pc),a0
	move.l	#-2,(a0)

	move.l	Main_VBIVector(pc),a0
	move.l	#vbi_planesoff,(a0)+
	move.l	#0,(a0)

	rts

vbi_planesoff:
	move.w	#%0000001000000000,bplcon0(a5)
	rts

Execute_Abyss:
	lea	code,a4
	jsr	2*6(a4)
	rts

setsquare:
;	move.l	#Junkyrgb,Junky_Code	;only for precalc!!!
	move.l	#Draw_Square,Code_Setblock
;	move.w	#turnsinend-turnsin,turnsintableoffset
	move.w	#0,turnsintableoffset
	rts

setthreesquaresin0:
	move.l	#Draw_threesquares,Code_Setblock
	move.w	#0,turnsintableoffset
	rts

setthreesquaresin1:
	move.l	#Draw_threesquares,Code_Setblock
	move.w	#turnsinend-turnsin,turnsintableoffset
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


init_scroller:
	move.l	Main_MasterCommand(pc),a0
	move.l	#Setscroller,(a0)	;second priority mastercommand
	rts

set_scroller:
	move.l	Main_VBIVector(pc),a0
	move.l	#VBIScroller,(a0)
	rts

Setscroller:
	lea	code,a0
	move.w	#16+256*2+16-1,d7
	moveq	#0,d0
;	move.l	#$aaaaaaaa,d0
makescrollscreen_lineloop:
	moveq	#(40*7)/4-1,d6
	lea	Screen,a1
makescrollscreen_byteloop:
	move.l	(a1)+,(a0)+
	dbf	d6,makescrollscreen_byteloop

;	moveq	#(40*1)/4-1,d6
;makescrollscreen_clearloop:
;	move.l	d0,(a0)+
;	dbf	d6,makescrollscreen_clearloop

	dbf	d7,makescrollscreen_lineloop


move.w	#%0000000010000000,dmacon(a5)
nop
bra	skipwhite
	move.l	#$0fff0fff,d0
	moveq	#7,d6
colwhiteloop3:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)
	move.w	d2,d3
	bset.l	#9,d3

	lea	$180(a5),a1
	move.w	d2,bplcon3(a5)
	moveq	#15,d7
colwhiteloop1:
	move.l	d0,(a1)+
	dbf	d7,colwhiteloop1

	lea	$180(a5),a1
	move.w	d3,bplcon3(a5)
	moveq	#15,d7
colwhiteloop2:
	move.l	d0,(a1)+
	dbf	d7,colwhiteloop2
	dbf	d6,colwhiteloop3

skipwhite:
	move.w	#0,bplcon3(a5)
	move.w	#$0000,$180(a5)
	move.w	#$0fff,$182(a5)
	move.w	#%1000000000000000,bplcon3(a5)
	move.w	#$0000,$180(a5)
	move.w	#$0fff,$182(a5)
	move.w	#%0010000000000000,bplcon3(a5)

move.w	#%1000000010000000,dmacon(a5)

	rts


setwater:
	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist1,(a0)
	move.l	Main_MasterCommand(pc),a0
	move.l	#MainLoop,4(a0)		;second priority mastercommand
;	bsr	killemall

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)
	rts

setwaterANDinitscroll:
	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist1,(a0)
	move.l	Main_MasterCommand(pc),a0
	move.l	#setscroller,(a0)	;first priority mastercommand
	move.l	#MainLoop,4(a0)		;second priority mastercommand
;	bsr	killemall

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)
	rts


Setwaterscreen:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
	move.w	#%0111001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)

;	move.w	#$2981,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
;	move.w	#$0038,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0000001000010000,bplcon0(a5)
	move.w	#%0111001000000000,bplcon0(a5)
;	move.w	#0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)
ifne	onelinegrid
	move.w	#-40,bpl1mod(a5)
	move.w	#-40,bpl2mod(a5)
else
	move.w	#0,bpl1mod(a5)
	move.w	#0,bpl2mod(a5)
endif
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

Set_ExecuteAbyssBlur:
	move.l	Main_MasterCommand(pc),a0
	move.l	#ExecuteAbyssBlur,(a0)		;second priority mastercommand
	bsr	cachesoff
	rts


ExecuteAbyssBlur:
	bsr	killemall
	lea	code+150000,a0
	lea	Code_AbyssBlur,a1
movem.l	d0-a6,-(a7)
	jsr	STCdecrunch
movem.l	(a7)+,d0-a6

	lea	Code,a0
;	lea	Code_AbyssBlur,a1
	lea	Code+150000,a1
	lea	MoonLib,a6
	jsr	(a6)

	lea	code,a0
	move.l	a0,a1
;	move.l	a1,a2
;	add.l	#250000,a2
;	sub.l	a2,a2
	move.l	fastmem,a2
	jsr	4(a6)

	lea	code,a4
	move.l	Main_VBIVector,a0
	move.l	Main_Copperlist,a1
	move.l	Main_Talk,a2
	move.l	Main_MasterCommand,a3
	jsr	1*6(a4)
	jsr	2*6(a4)
	move.w	#5,commander_sleep
	rts


Set_ExecuteWaterJames:
	move.l	Main_MasterCommand(pc),a0
	move.l	#ExecuteWaterJames,(a0)		;second priority mastercommand
	bsr	cachesoff
	rts


ExecuteWaterJames:
	bsr	killemall
	lea	code+150000,a0
	lea	Code_WaterJames,a1
movem.l	d0-a6,-(a7)
	jsr	STCdecrunch
movem.l	(a7)+,d0-a6


	lea	Code,a0
;	lea	Code_WaterJames,a1
	lea	Code+150000,a1
	lea	MoonLib,a6
	jsr	(a6)

	lea	code,a0
	move.l	a0,a1
;	move.l	a1,a2
;	add.l	#250000,a2
;	sub.l	a2,a2
	move.l	fastmem,a2
	jsr	4(a6)

	lea	code,a4
	move.l	Main_VBIVector,a0
	move.l	Main_Copperlist,a1
	move.l	Main_Talk,a2
	move.l	Main_MasterCommand,a3
	jsr	1*6(a4)
	jsr	2*6(a4)
	move.w	#5,commander_sleep
	rts


cachesoff:
	dc.l	$4e7a0002		;movec	CACR,d0
	bclr	#0,d0			;disable instruction cache
	bclr	#8,d0			;disable data cache
	bclr	#4,d0			;disable instruction burst
	bclr	#12,d0			;disable data burst
	nop
	dc.l	$4e7b0002		;movec	d0,CACR
	rts


cacheson:
	bset	#0,d0			;enable instruction cache
	bclr	#8,d0			;enable data cache
	bclr	#4,d0			;disable instruction burst
	bclr	#12,d0			;disable data burst
	nop
	dc.l	$4e7b0002		;movec	d0,CACR
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
ifne	onelinegrid
	incbin	"data/JunkyGrid_3.blt1"
else
	incbin	"/junky/data/JunkyGrid_3.raw"
;	incbin	"/junky/data/JunkyGrid_3+1.raw"
;	incbin	"/junky/data/JunkyGrid_3_3d.raw"
;	incbin	"/junky/data/JunkyGrid_3_ball.raw"
;	incbin	"/junky/data/JunkyGrid_3_bars.raw"
;	incbin	"/junky/data/JunkyGrid_3_depp.raw"
;	incbin	"/junky/data/JunkyGrid_3_smear.raw"
endif
Screenend:

ifne	music
module:	incbin	"data/p60.satellite_sleepwalk"
;module:	incbin	"data/p60.nature"
endif

dcb.b	4,0

code:
;dcb.b	440000+(Code_AbyssHAM8-Code_AbyssHAM8end),0
dcb.b	440000-195090,0
Code_AbyssHAM8:		incbin	"data/AbyssHAM8.term"
Code_AbyssHAM8end:
even
;ds.b	500000
Scrollscreen=code+(40*7)*16
;Code_AbyssBlur:		incbin	"data/AbyssBlur.term"
Code_AbyssBlur:			incbin	"data/AbyssBlur.term.stc"
even
datac_e:



ifne	UseSection
ifeq	Onlychip
section	CodeP,code_p
else
section	CodeP,code_c	;onlychip
endif
endif
codep_s:
;------------------------------------------------------------------------

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

;	jsr	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount

rts

VBIScroller:
	lea	scrollScreen,a0
	add.l	scrolloffset,a0

	move.l	a0,bpl1pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	40*1(a0),a0
	move.l	a0,bpl7pth(a5)

	move.w	#40*6,bpl1mod(a5)
	move.w	#40*6,bpl2mod(a5)

;	jsr	commander
	bsr	scroller
	move.w	#1,f_VBI
	addq.w	#1,framecount

;move.w	#%0000000010000000,dmacon(a5)
;	move.w	#0,bplcon3(a5)
;	move.w	#$00f0,$180(a5)
;	move.w	#$0f00,$182(a5)
;	move.w	#%1000000000000000,bplcon3(a5)
;	move.w	#$00f0,$180(a5)
;	move.w	#$0f00,$182(a5)
;	move.w	#%0010000000000000,bplcon3(a5)
;move.w	#%1000000010000000,dmacon(a5)

rts


Coppercopy:
;--> a0  ;address of copperlist
;--> a1  ;addrsss of Junkyborder

	move.l	a0,d3			;copadr to calc offsets
	move.w	#$2701,d0
	lea	Coplist_Offset,a2
	move.w	#bplcon0,(a0)+
	move.w	#%0111001000000000,(a0)+

;---------------------------------
ifne	jbyt
printt	"Top border recognized!"
	moveq	#jbyt-1,d7
Coppercopy_TopBorderLoopy:
	move.w	#Jsx-1,d6	;quick
Coppercopy_TopBorderLoopx:
	move.l	a1,d4		;Junkyborder position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset
	addq.w	#2,a1
	dbf	d6,Coppercopy_TopBorderLoopx
	dbf	d7,Coppercopy_TopBorderLoopy
endif
;---------------------------------

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


;---------------------------------
ifne	jbxl
printt	"Left border recognized!"
	moveq	#jbxl-1,d7
Coppercopy_LeftBorderLoop:
	move.l	a1,d4		;Junkyborder position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset
	addq.w	#2,a1
	dbf	d7,Coppercopy_LeftBorderLoop
endif
;---------------------------------

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

	move.w	#$0,(a0)+	;color code
	dbf	d6,Coppercopy_regloop

	rol.w	#3,d1
	subq.w	#1,d1
	ror.w	#3,d1
	dbf	d7,Coppercopy_lineloop

	move.w	#$1c0,d2
	move.w	#bplcon3,(a0)+
	move.w	d1,(a0)+
	moveq	#9,d6		;bonus moves
Coppercopy_Regloop2:
	subq.w	#2,d2		;colreg adr decrement
	move.w	d2,(a0)+	;colreg adr

	move.l	a0,d4		;copperlist position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset

	move.w	#$0,(a0)+
	dbf	d6,Coppercopy_regloop2

;---------------------------------
ifne	jbxr
printt	"Right border recognized!"
	moveq	#jbxr-1,d7
Coppercopy_RightBorderLoop:
	move.l	a1,d4		;Junkyborder position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset
	addq.w	#2,a1
	dbf	d7,Coppercopy_RightBorderLoop
endif
;---------------------------------


	add.w	#$0300,d0	;rasterpos

;add.w	#256-jx*2,a2	;fakemulx
	dbf	d5,Coppercopy_blockloop

;---------------------------------
ifne	jbyb
printt	"Bottom border recognized!"
	moveq	#jbyb-1,d7
Coppercopy_BotBorderLoopy:
	move.w	#Jsx-1,d6	;quick
Coppercopy_BotBorderLoopx:
	move.l	a1,d4		;Junkyborder position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset
	addq.w	#2,a1
	dbf	d6,Coppercopy_BotBorderLoopx
	dbf	d7,Coppercopy_BotBorderLoopy
endif
;---------------------------------


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
	move.l	a1,junkborcheck
	move.l	a2,offsetcheck
rts

junkborcheck:	dc.l	0	;junkyborder2end
offsetcheck:	dc.l	0	;Coplist_Offsetend

Coplist_makedelta:
rts
	lea	Coplist_Offset,a0
	lea	Coplist_OffsetDelta,a1
	moveq	#0,d0
	moveq	#0,d1

	move.w	#Jsy-1,d7	;-loop-first value (first is NO delta)
Coplist_makedelta_loopy:
	move.w	#Jsx-1,d6	;-loop-first value (first is NO delta)
Coplist_makedelta_loopx:
	move.w	(a0)+,d1	;new offset
	sub.w	d1,d0		;act pos-new offset
	neg.w	d0
	move.w	d0,(a1)+	;write new delta
	move.w	d1,d0		;new offset = akt pos
	dbf	d6,Coplist_makedelta_loopx
;	add.w	#256-jx*2,a0	;fakemulx
;	add.w	#256-jx*2,a1	;fakemulx
	dbf	d7,Coplist_makedelta_loopy
move.l	a0,depp
rts

depp:	dc.l	0

palswap:	dc.w	0

 
;got 4 coordinates:





Junky_Code:	dc.l	Junkyrgb

Junky_Set:
	move.l	Junky_Code(pc),a0
	jmp	(a0)


;***********************************************************************
;***********************************************************************
ifne	precalc
precalcpos:	dc.l	junkytable	;only coz no addreg free
endif

JunkyRGB:
	lea	Scaledata,a3
	lea	blurtab,a4

	lea	Coord_d,a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+2(a0),d0	;cx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;dxac=cx-ax   (delta x ac)
	swap	d0
	divs.l	#Jsx,d0
	move.l	d0,(a3)	;mdx
	swap	d1
	move.l	d1,mpx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+4(a0),d0	;cy
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;cy-ay
	swap	d0
	divs.l	#Jsy,d0
	move.l	d0,mdy(a3)
	swap	d1
	move.l	d1,mpy(a3)



	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	2*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#Jsx,d0
	move.l	d0,dpx(a3)

	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	2*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#Jsy,d0
	move.l	d0,dpy(a3)

;---
	lea	linedelta(pc),a2
	moveq	#0,d0
	moveq	#0,d1
	move.l	dpx(a3),d2
	move.l	dpy(a3),d3
	
	move.w	#Jsx-1,d6	;quick
JunkyRGB_PrecDeltax:
	swap	d0
	move.w	d0,(a2)+
	sub.w	d0,d0
	swap	d0

	swap	d1
	move.w	d1,(a2)+
	sub.w	d1,d1
	swap	d1

	add.l	d2,d0
	add.l	d3,d1
	dbf	d6,JunkyRGB_PrecDeltax

;---
	move.l	Copperlist_work,a0
	move.l	Copperlist_show,a6

;	lea	Coplist_OffsetDelta,a1
	lea	Coplist_Offset,a1
	lea	Coplist_Offset,a5
	move.l	dpx(a3),d0
	move.l	dpy(a3),d1
	move.w	#Jsy-1,d7	;quick
nop
JunkyRGB_Sety:
	move.l	mpx(a3),d4
	move.l	mpy(a3),d5



	move.w	#Jsx-1,d6	;quick
JunkyRGB_Setx:
	move.l	d4,d2
	move.l	d5,d3

;	sub.w	d2,d2
	swap	d2
	sub.w	d3,d3
	swap	d3

;	lsl.w	#8,d3
;	move.b	d2,d3		;this is real megafast coding
;	add.l	d3,d3

cmp.w	#Jsx-1,d2
bgt	overflowx
;bhi	overflowx

tst.w	d2
bmi	underflowx

xflowtested:	;backjump if x if over/under flow


cmp.w	#Jsy-1,d3
bgt	overflowy
;bhi	overflowy
tst.w	d3
bmi	underflowy

yflowtested:	;backjump if x if over/under flow

;lsl.w	#7,d3	;fakemulx
mulu.w	#Jsx,d3

add.w	d2,d3
;add.w	d3,d3

;add.l	d3,d3
;sub.w	#(128-42)*jx*2,d3
;sub.w	#(160-53+20)*2,d3

move.w	d3,mixtest


ifne	precalc
	move.l	precalcpos,a0
	cmp.l	#junkytableend,a0
	beq	error_tablewriteoverflow
	add.w	d3,d3
	move.w	d3,(a0)+
	lsr.w	#1,d3
	move.l	a0,precalcpos
error_tablewriteoverflow:
endif

move.w	(a5,d3.w*2),d3	;coplist offset

move.w	(a6,d3.l),d2	;copperlist pos (peek color of lpx;lpy)

;;	move.l	Copperlist_work,a0
;;	move.l	Copperlist_show,a6


move.l	Copperlist_work,a0
;	add.w	(a1)+,a0	;copperlist position
moveq	#0,d3
move.w	(a1)+,d3
add.l	d3,a0
move.l	a1,tom

;	add.w	(a1)+,a0	;copperlist position

ifne	fadedown
	move.w	(a4,d2.w*2),d2	;fade color down
endif


ifne	colmix
	move.w	mixtest(pc),d3
	move.w	2(a5,d3.w*2),d3	;next(right) coplist offset
	move.w	(a6,d3.l),d3	;copperlist pos (peek color of lpx;lpy)

	and.w	#%0000111011101110,d2
	and.w	#%0000111011101110,d3
	add.w	d3,d2
	lsr.w	#1,d2
endif

ifne	colmix2
	move.w	mixtest(pc),d3
	move.w	2(a5,d3.w*2),d3	;next(right) coplist offset
	move.w	(a6,d3.l),d3	;copperlist pos (peek color of lpx;lpy)
	beq	oki
	tst.w	d2
	beq	oki
	and.w	#%0000111011101110,d2
	and.w	#%0000111011101110,d3
	add.w	d3,d2
	lsr.w	#1,d2
oki:
endif


	move.w	d2,(a0)		;write colorcode in copperlist

	add.l	d0,d4	;dpx
	add.l	d1,d5	;dpy

	dbf	d6,JunkyRGB_Setx

	move.l	(a3),d2	;mdx
	add.l	d2,mpx(a3)
	move.l	mdy(a3),d2
	add.l	d2,mpy(a3)
;	add.w	#256-jx*2,a1	;fakemulx

;	add.w	#256-jx*2,a5

	dbf	d7,JunkyRGB_Sety
	lea	$dff000,a5
	nop
rts

tom:	dc.l	0

overflowx:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
sub.w	#jsx-1,d2
endif
bra	xflowtested

underflowx:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
add.w	#jsx-1,d2
endif
bra	xflowtested


overflowy:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
sub.w	#jsy-1,d3
endif
bra	yflowtested

underflowy:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
add.w	#jsy-1,d3
endif
bra	yflowtested


linedelta:	dcb.w	Jsx*2,0
mixtest:	dc.w	0
;#####################################################################
;#####################################################################
ifne	precalc
Junkytable_readpos:	dc.l	junkytable


Junky_Readtable:
;ifne	colmix
	move.l	Copperlist_work,a0
	move.l	Copperlist_show,a6

	lea	Coplist_Offset,a1	;destination counter, increasing
	move.l	a1,a2			;source pointer, for colmix

	move.l	junkytable_readpos(pc),a3
	move.w	#Jsy*Jsx-1,d7	;quick
	moveq	#0,d0
nop
JRTcolmix1_Set:
	move.w	(a3)+,d0	;get precalculated offset
	move.w	(a2,d0.w),d0	;coplist offset
	move.w	(a6,d0.l),d1	;copperlist pos (peek color of lpx;lpy)

	move.w	(a3),d0
	move.w	(a2,d0.w),d0	;next(right) coplist offset
	move.w	(a6,d0.l),d0	;copperlist pos (peek color of lpx;lpy)


	and.w	#%0000111011101110,d1
	and.w	#%0000111011101110,d0
	add.w	d0,d1
	lsr.w	#1,d1
	move.w	(a1)+,d0
	move.w	d1,(a0,d0.l)	;8 16 write colorcode in copperlist


	dbf	d7,JRTcolmix1_Set
;endif
	rts
Junky_Readtableend:

;---------------------------------------
;d0d1d2d3d4d5d6d7a0a1a2a3a4a5a6a7
;---------------------------------------


;---whole junkyread code-----
;Junky_Readtable:
;	move.l	#junkytable,junkytable_readpos
	move.l	junkytable_readpos,d0
	cmp.l	#junkytableend,d0
	bne	JunkyReadTable_norestart
	move.l	#junkytable,junkytable_readpos
JunkyReadTable_norestart:

	lea	blurtab,a4

	move.l	Copperlist_work,a0
	move.l	Copperlist_show,a6

	lea	Coplist_Offset,a1
	lea	Coplist_Offset,a2

	move.l	junkytable_readpos,a3
	move.w	#Jsy*Jsx-1,d7	;quick
	moveq	#0,d3
	move.l	Copperlist_work,d1
nop
JunkyReadTable_Set:
	move.w	(a3)+,d3	;get precalculated offset
	move.w	(a2,d3.w*2),d3	;coplist offset

	move.w	(a6,d3.l),d2	;copperlist pos (peek color of lpx;lpy)

	move.l	d1,a0	;copperlist_work:
	move.w	(a1)+,d3
	add.l	d3,a0

;---
ifne	fadedown
	move.w	(a4,d2.w*2),d2	;fade color down
endif
;---
;---
ifne	colmix
;	move.w	mixtest(pc),d3
	move.w	(a3),d3
	move.w	2(a2,d3.w*2),d3	;next(right) coplist offset

	move.w	(a6,d3.l),d3	;copperlist pos (peek color of lpx;lpy)

	and.w	#%0000111011101110,d2
	and.w	#%0000111011101110,d3
	add.w	d3,d2
	lsr.w	#1,d2
endif
;---
;---
ifne	colmix2
	move.w	mixtest(pc),d3
	move.w	2(a2,d3.w*2),d3	;next(right) coplist offset
	move.w	(a6,d3.l),d3	;copperlist pos (peek color of lpx;lpy)
	beq	JunkyReadTable_oki
	tst.w	d2
	beq	JunkyReadTable_oki
	and.w	#%0000111011101110,d2
	and.w	#%0000111011101110,d3
	add.w	d3,d2
	lsr.w	#1,d2
JunkyReadTable_oki:
endif
;---
;---
	move.w	d2,(a0)		;write colorcode in copperlist

	dbf	d7,JunkyReadTable_Set
	move.l	a3,junkytable_readpos
	rts
;Junky_Readtableend:



endif




;------------------------------------------------------------------------
;begin Junky draw routines-----------------------------------------------
;-------------------------
Brushx=2
Brushy=2

Draw_Square:
	lea	coltabpos(pc),a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#coltabend-coltab,d0
	bne	DrawSquare_nocoltabflow
	moveq	#0,d0
DrawSquare_nocoltabflow:
	move.w	d0,(a0)+
	move.w	(a0,d0.w),d3


	bsr	sinemove

	lea	Squarecoordpos+2,a3
	move.w	(a3),d0
	add.w	#10,d0
	cmp.w	#Squarecoordend-Squarecoord,d0
	bne	DrawSquare_nosqquarerestart
	moveq	#0,d0
DrawSquare_nosqquarerestart:
	move.w	d0,(a3)+
	add.w	d0,a3

;	moveq	#(Squarecoordend-Squarecoord)/2-1,d5
	moveq	#29,d5

	move.l	Copperlist_work,a1
	move.l	Copperlist_show,a6
	lea	Coplist_Offset,a2

	add.w	Squareposy,a2
	add.w	Squareposx,a2

	moveq	#0,d1

DrawSquare_ploop:

;	add.w	(a3)+,a2
	move.w	(a3)+,d0

	moveq	#Brushy-1,d7
DrawSquare_yloop:
	moveq	#Brushx-1,d6
DrawSquare_xloop:

	move.w	(a2,d0.w),d1
	addq.w	#2,a2

;move.w	#$0fff,d3

	move.w	d3,(a6,d1.l)

	dbf	d6,DrawSquare_xloop
	add.w	#(jsx-Brushx)*2,a2
	dbf	d7,DrawSquare_yloop
	sub.w	#jsx*2*Brushy,a2
	dbf	d5,DrawSquare_ploop
	rts
;-------------------------
DrawThreesquares_sinpoints:
	dc.w	10
	dc.w	0*64
	dc.w	4
	dc.w	1*64
	dc.w	2
	dc.w	2*64
	dc.w	8
	dc.w	3*64

Draw_ThreeSquares:
	lea	coltabpos(pc),a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#coltabend-coltab,d0
	bne	DrawThreeSquares_nocoltabflow
	moveq	#0,d0
DrawThreeSquares_nocoltabflow:
	move.w	d0,(a0)+
	lea	(a0,d0.w),a3

;	move.w	(a0,d0.w),d3
;	move.w	20(a0,d0.w),d4
;	move.w	40(a0,d0.w),d5


	move.l	Copperlist_show,a6
	lea	sinx,a1
	moveq	#3,d7
	lea	DrawThreesquares_sinpoints(pc),a0
DrawThreeSquares_blockloop:

	lea	Coplist_Offset,a2

	move.w	2(a0),d0
	add.w	(a0)+,d0
	cmp.w	#sinxend-sinx,d0
	bne	DrawThreeSquares_nosinxflow
	moveq	#0,d0
DrawThreeSquares_nosinxflow:
	move.w	d0,(a0)+
	add.w	(a1,d0.w),a2

	add.w	#siny-sinx,d0
	move.w	(a1,d0.w),d0
	lsr.w	#7,d0
	mulu.w	#jsx,d0
	and.w	#-2,d0
	add.w	d0,a2


	moveq	#0,d1
	move.w	(a3),d3
	lea	40(a3),a3

	moveq	#7,d6
DrawThreeSquares_yloop:
rept	8
	move.w	(a2)+,d1
	move.w	d3,(a6,d1.l)
endr
	add.w	#(jsx-8)*2,a2
	dbf	d6,DrawThreeSquares_yloop
	dbf	d7,DrawThreeSquares_blockloop
	rts
;-------------------------
;-------------------------
;end   Junky draw routines-----------------------------------------------
;------------------------------------------------------------------------
Convert_Squarecoords:
	lea	squarecoord(pc),a0
	move.w	#(squarecoordend-squarecoord)/2*2-1,d7
	moveq	#0,d0
ConvertSquarecoords_loop:
	add.w	(a0),d0
	move.w	d0,(a0)+
	dbf	d7,ConvertSquarecoords_loop
	rts

Squarecoordpos:	dc.w	0,0	;|
Squarecoord:			;|
rept	25
	dc.w	2+0		;right
endr
rept	25
	dc.w	0+Jsx*2		;down
endr
rept	25
	dc.w	-2+0		;left
endr
rept	25
	dc.w	0-Jsx*2		;up
endr
Squarecoordend:
rept	25
	dc.w	2+0		;right
endr
rept	25
	dc.w	0+Jsx*2		;down
endr
rept	25
	dc.w	-2+0		;left
endr
rept	25
	dc.w	0-Jsx*2		;up
endr

Squareposx:	dc.w	40*2
Squareposy:	dc.w	40*Jsx*2


blockposx:	dc.w	60*2
;blockposy:	dc.w	20*256	;fakemulx
blockposy:	dc.w	50*Jsx*2




turner:	;last optimizing:93-09-05
	lea	turnsinpoint,a0
	move.w	(a0),d0
	addq.w	#4,d0
	cmp.w	#turnsinend-turnsin,d0
	bne.b	noturnsinflow
	moveq	#0,d0
noturnsinflow:
	move.w	d0,(a0)+
	add.w	(a0)+,d0	;table offset
	move.w	(a0,d0.w),d0

ifeq	precalc
	and.w	#%1111111111100000,d0
	move.w	d0,turnz	;turnaddz
endif


ifne	precalc
	lsr.w	#2,d0	;angle range 0-359
	lsr.w	#3,d0	;angle range 0-44

	mulu.w	#coplist_offsetsize*2,d0
	move.l	#junkytable,d1
	add.l	d0,d1
	move.l	d1,Junkytable_readpos
endif

	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz

;sub.l	a0,a0
;move.l	#48,a0
turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sincos,a6	;sinus/cosinus
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

;add.w	#jx/2,d3
;add.w	#jy/2,d6
;add.w	#160,d3
;add.w	#128,d6

;add.w	#200,d3
;add.w	#200,d6

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
;add.w	#160,d0
;add.w	#128,d1
add.w	#Jsx/2,d0
add.w	#Jsy/2,d1

move.w	d0,2(a4)
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop
rts


focus:	dc.w	96
	dc.w	-2




Joystic1:
;move.l	#$005e2c00,blockposx
	moveq	#0,d0
	moveq	#0,d1

	move.w	$00c(a5),d0
	btst	#1,d0
	bne	rechts
	btst	#9,d0
	bne	links
	move.w	d0,d1
	lsr.w	#1,d1
	eor.w	d0,d1
	btst	#0,d1
	bne	hinten
	btst	#8,d1
	bne vorne
	rts
rechts:
	add.w	#2,blockposx
	rts
links:
	sub.w	#2,blockposx
	rts
vorne:
	sub.w	#256,blockposy
	rts
hinten:
	add.w	#256,blockposy
	rts



sinemove:
	lea	sinxpoint(pc),a0
	move.w	(a0),d0
	addq.w	#8,d0
	cmp.w	#sinxend-sinx,d0
	bne	nosinxflow
	moveq	#0,d0
nosinxflow:
	move.w	d0,(a0)+
	add.w	d0,a0
	move.w	(a0),blockposx
	move.w	siny-sinx(a0),d0
	lsr.w	#7,d0
	mulu	#jsx,d0
	and.w	#-2,d0
	move.w	d0,blockposy

	move.w	blockposx,squareposx
	move.w	blockposy,squareposy
rts



;rgb_dat:	incbin	"data/rgb.dat"


f_screencopy:	dc.w	0
f_VBI:	dc.w	0
framecount:	dc.w	0
look:	dc.w	0


sinxpoint:	dc.w	0	;|
sinx:				;|
dc.W  106, 108, 110, 110, 112, 114, 116, 116, 118, 120, 122
dc.W  122, 124, 126, 126, 128, 130, 130, 132, 132, 134, 134
dc.W  136, 136, 138, 138, 138, 140, 140, 140, 142, 142, 142
dc.W  142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142
dc.W  142, 142, 140, 140, 140, 140, 138, 138, 138, 138, 136
dc.W  136, 136, 134, 134, 132, 132, 132, 130, 130, 128, 128
dc.W  128, 126, 126, 124, 124, 124, 122, 122, 122, 120, 120
dc.W  120, 120, 118, 118, 118, 118, 118, 116, 116, 116, 116
dc.W  116, 116, 116, 116, 116, 116, 116, 116, 116, 118, 118
dc.W  118, 118, 118, 120, 120, 120, 120, 122, 122, 122, 124
dc.W  124, 124, 126, 126, 128, 128, 128, 130, 130, 132, 132
dc.W  132, 134, 134, 136, 136, 136, 138, 138, 138, 138, 140
dc.W  140, 140, 140, 142, 142, 142, 142, 142, 142, 142, 142
dc.W  142, 142, 142, 142, 142, 142, 142, 142, 140, 140, 140
dc.W  138, 138, 138, 136, 136, 134, 134, 132, 132, 130, 130
dc.W  128, 126, 126, 124, 122, 122, 120, 118, 116, 116, 114
dc.W  112, 110, 110, 108, 106, 104, 102, 102, 100, 98, 96
dc.W  96, 94, 92, 90, 90, 88, 86, 86, 84, 82, 82, 80, 80
dc.W  78, 78, 76, 76, 74, 74, 74, 72, 72, 72, 72, 70, 70
dc.W  70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70
dc.W  72, 72, 72, 72, 74, 74, 74, 74, 76, 76, 76, 78, 78
dc.W  80, 80, 80, 82, 82, 84, 84, 84, 86, 86, 88, 88, 88
dc.W  90, 90, 90, 92, 92, 92, 92, 94, 94, 94, 94, 94, 96
dc.W  96, 96, 96, 96, 96, 96, 96, 96, 96, 96, 96, 96, 94
dc.W  94, 94, 94, 94, 92, 92, 92, 92, 90, 90, 90, 88, 88
dc.W  88, 86, 86, 84, 84, 84, 82, 82, 80, 80, 80, 78, 78
dc.W  76, 76, 76, 74, 74, 74, 74, 72, 72, 72, 72, 70, 70
dc.W  70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70
dc.W  70, 72, 72, 72, 74, 74, 74, 76, 76, 78, 78, 80, 80
dc.W  82, 82, 84, 86, 86, 88, 90, 90, 92, 94, 96, 96, 98
dc.W  100, 102, 102, 104
sinxend:


siny:
rept	2
dc.W  10752, 11008, 11008, 11264, 11264, 11520, 11520, 11776
dc.W  11776, 12032, 12032, 12288, 12288, 12544, 12544, 12800
dc.W  12800, 13056, 13056, 13056, 13312, 13312, 13568, 13568
dc.W  13568, 13824, 13824, 14080, 14080, 14080, 14336, 14336
dc.W  14336, 14592, 14592, 14592, 14592, 14848, 14848, 14848
dc.W  14848, 14848, 15104, 15104, 15104, 15104, 15104, 15104
dc.W  15104, 15104, 15360, 15360, 15360, 15360, 15360, 15360
dc.W  15360, 15360, 15104, 15104, 15104, 15104, 15104, 15104
dc.W  15104, 15104, 15104, 14848, 14848, 14848, 14848, 14848
dc.W  14592, 14592, 14592, 14592, 14336, 14336, 14336, 14336
dc.W  14080, 14080, 14080, 13824, 13824, 13824, 13568, 13568
dc.W  13568, 13312, 13312, 13312, 13056, 13056, 13056, 12800
dc.W  12800, 12800, 12544, 12544, 12288, 12288, 12288, 12032
dc.W  12032, 12032, 11776, 11776, 11776, 11520, 11520, 11520
dc.W  11264, 11264, 11264, 11008, 11008, 11008, 11008, 10752
dc.W  10752, 10752, 10496, 10496, 10496, 10496, 10496, 10240
dc.W  10240, 10240, 10240, 10240, 9984, 9984, 9984, 9984
dc.W  9984, 9984, 9984, 9984, 9984, 9984, 9728, 9728, 9728
dc.W  9728, 9728, 9728, 9728, 9728, 9728, 9728, 9728, 9728
dc.W  9984, 9984, 9984, 9984, 9984, 9984, 9984, 9984, 9984
dc.W  9984, 9984, 10240, 10240, 10240, 10240, 10240, 10240
dc.W  10240, 10496, 10496, 10496, 10496, 10496, 10496, 10752
dc.W  10752, 10752, 10752, 10752, 11008, 11008, 11008, 11008
dc.W  11008, 11008, 11264, 11264, 11264, 11264, 11264, 11264
dc.W  11264, 11520, 11520, 11520, 11520, 11520, 11520, 11520
dc.W  11520, 11520, 11520, 11520, 11776, 11776, 11776, 11776
dc.W  11776, 11776, 11776, 11776, 11776, 11776, 11776, 11776
dc.W  11520, 11520, 11520, 11520, 11520, 11520, 11520, 11520
dc.W  11520, 11520, 11264, 11264, 11264, 11264, 11264, 11008
dc.W  11008, 11008, 11008, 11008, 10752, 10752, 10752, 10496
dc.W  10496, 10496, 10496, 10240, 10240, 10240, 9984, 9984
dc.W  9984, 9728, 9728, 9728, 9472, 9472, 9472, 9216, 9216
dc.W  9216, 8960, 8960, 8704, 8704, 8704, 8448, 8448, 8448
dc.W  8192, 8192, 8192, 7936, 7936, 7936, 7680, 7680, 7680
dc.W  7424, 7424, 7424, 7168, 7168, 7168, 7168, 6912, 6912
dc.W  6912, 6912, 6656, 6656, 6656, 6656, 6656, 6400, 6400
dc.W  6400, 6400, 6400, 6400, 6400, 6400, 6400, 6144, 6144
dc.W  6144, 6144, 6144, 6144, 6144, 6144, 6400, 6400, 6400
dc.W  6400, 6400, 6400, 6400, 6400, 6656, 6656, 6656, 6656
dc.W  6656, 6912, 6912, 6912, 6912, 7168, 7168, 7168, 7424
dc.W  7424, 7424, 7680, 7680, 7936, 7936, 7936, 8192, 8192
dc.W  8448, 8448, 8448, 8704, 8704, 8960, 8960, 9216, 9216
dc.W  9472, 9472, 9728, 9728, 9984, 9984, 10240, 10240, 10496
dc.W  10496
endr
sinyend:



turnsinpoint:		dc.w	0	;|
turnsintableoffset:	dc.w	0	;|
Turnsin:				;|
dc.W  0, 0, 0, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 12, 12, 12, 12
dc.W  16, 16, 16, 16, 16, 16, 20, 20, 20, 20, 20, 24, 24
dc.W  24, 24, 24, 28, 28, 28, 28, 28, 28, 32, 32, 32, 32
dc.W  32, 32, 32, 36, 36, 36, 36, 36, 36, 36, 40, 40, 40
dc.W  40, 40, 40, 40, 40, 40, 44, 44, 44, 44, 44, 44, 44
dc.W  44, 44, 44, 44, 44, 48, 48, 48, 48, 48, 48, 48, 48
dc.W  48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48
dc.W  48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 44
dc.W  44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 44, 40, 40
dc.W  40, 40, 40, 40, 40, 40, 40, 36, 36, 36, 36, 36, 36
dc.W  36, 32, 32, 32, 32, 32, 32, 32, 28, 28, 28, 28, 28
dc.W  28, 24, 24, 24, 24, 24, 20, 20, 20, 20, 20, 16, 16
dc.W  16, 16, 16, 16, 12, 12, 12, 12, 8, 8, 8, 8, 8, 4, 4
dc.W  4, 4, 4, 0, 0, 0, 0, 0,-4,-4,-4,-4,-4,-8,-8,-8,-8,-8
dc.W -12,-12,-12,-12,-16,-16,-16,-16,-16,-16,-20,-20,-20
dc.W -20,-20,-24,-24,-24,-24,-24,-28,-28,-28,-28,-28,-28
dc.W -32,-32,-32,-32,-32,-32,-32,-36,-36,-36,-36,-36,-36
dc.W -36,-40,-40,-40,-40,-40,-40,-40,-40,-40,-44,-44,-44
dc.W -44,-44,-44,-44,-44,-44,-44,-44,-44,-48,-48,-48,-48
dc.W -48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48
dc.W -48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48,-48
dc.W -48,-48,-48,-44,-44,-44,-44,-44,-44,-44,-44,-44,-44
dc.W -44,-44,-40,-40,-40,-40,-40,-40,-40,-40,-40,-36,-36
dc.W -36,-36,-36,-36,-36,-32,-32,-32,-32,-32,-32,-32,-28
dc.W -28,-28,-28,-28,-28,-24,-24,-24,-24,-24,-20,-20,-20
dc.W -20,-20,-16,-16,-16,-16,-16,-16,-12,-12,-12,-12,-8,-8
dc.W -8,-8,-8,-4,-4,-4,-4,-4, 0, 0
turnsinend:


dc.W  0, 20, 44, 64, 88, 108, 132, 152, 172, 192, 216, 236
dc.W  252, 272, 292, 312, 328, 344, 364, 380, 396, 408, 424
dc.W  440, 452, 464, 476, 488, 496, 508, 516, 524, 532, 540
dc.W  544, 548, 552, 556, 560, 564, 564, 564, 564, 564, 564
dc.W  560, 560, 556, 552, 548, 544, 536, 532, 524, 520, 512
dc.W  504, 496, 484, 476, 468, 460, 448, 440, 428, 416, 408
dc.W  396, 384, 376, 364, 352, 344, 332, 320, 312, 300, 288
dc.W  280, 268, 260, 252, 240, 232, 224, 216, 208, 200, 192
dc.W  188, 180, 172, 168, 164, 160, 152, 148, 144, 144, 140
dc.W  136, 136, 132, 132, 132, 132, 132, 132, 132, 132, 132
dc.W  132, 136, 136, 140, 140, 144, 148, 148, 152, 156, 160
dc.W  164, 164, 168, 172, 176, 180, 184, 184, 188, 192, 196
dc.W  196, 200, 200, 204, 204, 208, 208, 212, 212, 212, 212
dc.W  212, 212, 212, 208, 208, 208, 204, 200, 200, 196, 192
dc.W  188, 184, 180, 176, 168, 164, 156, 152, 144, 136, 132
dc.W  124, 116, 108, 100, 92, 84, 72, 64, 56, 48, 36, 28
dc.W  20, 8, 0,-8,-20,-28,-36,-48,-56,-64,-72,-84,-92,-100
dc.W -108,-116,-124,-132,-136,-144,-152,-156,-164,-168,-176
dc.W -180,-184,-188,-192,-196,-200,-200,-204,-208,-208,-208
dc.W -212,-212,-212,-212,-212,-212,-212,-208,-208,-204,-204
dc.W -200,-200,-196,-196,-192,-188,-184,-184,-180,-176,-172
dc.W -168,-164,-164,-160,-156,-152,-148,-148,-144,-140,-140
dc.W -136,-136,-132,-132,-132,-132,-132,-132,-132,-132,-132
dc.W -132,-136,-136,-140,-144,-144,-148,-152,-160,-164,-168
dc.W -172,-180,-188,-192,-200,-208,-216,-224,-232,-240,-252
dc.W -260,-268,-280,-288,-300,-312,-320,-332,-344,-352,-364
dc.W -376,-384,-396,-408,-416,-428,-440,-448,-460,-468,-476
dc.W -484,-496,-504,-512,-520,-524,-532,-536,-544,-548,-552
dc.W -556,-560,-560,-564,-564,-564,-564,-564,-564,-560,-556
dc.W -552,-548,-544,-540,-532,-524,-516,-508,-496,-488,-476
dc.W -464,-452,-440,-424,-408,-396,-380,-364,-344,-328,-312
dc.W -292,-272,-252,-236,-216,-192,-172,-152,-132,-108,-88
dc.W -64,-44,-20
AllTurnsinend:


Coltabpos:	dc.w	0	;|
Coltab:				;|
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
endr

rept	8
dc.w $000,$023,$046,$07A,$09D,$07A,$068,$045,$023
endr

Coltabend:
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


;player:	incbin	"data/player60.code"
;P60_init=player+40
;P60_music=player+738
;P60_end=player+626
;P60_master=player+16
player:	incbin	"data/player60a_c1.code"
playerend:	;look to !playersize! when changing there
P60_init=player+80
P60_end=player+774


Moonlib:
incdir	"include/moonlib/"
include	"Moonlib1.1.s"
incdir	""

include	"include/STCdecrunch.s"

;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz1234567890.!(),-:/'@"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
dc.b "                            "
dc.b "       p u l s t a r        "
dc.b "                            "
dc.b "            b y             "
dc.b "                            "
dc.b "         a b y s s          "
dc.b "                            "
dc.b "                            "
dc.b "  released at the party v   "
dc.b "     in december  1995      "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "   credits and addresses:   "
dc.b "                            "
dc.b "!! no handle on envelope !! "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "code by moon                "
dc.b "                            "
dc.b "thomas mattel               "
dc.b "langgasse 195               "
dc.b "a-5400 vigaun               "
dc.b "austria                     "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "music by                    "
dc.b "   substance/avocado/massive"
dc.b "                            "
dc.b "joonas vahamaki             "
dc.b "urheilijanplk. 6 as13       "
dc.b "33720 tampere               "
dc.b "finland                     "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "logo by celtic/axis         "
dc.b "                            "
dc.b "niels jansson               "
dc.b "sandifortstraat 3           "
dc.b "2035 rh haarlem             "
dc.b "holland                     "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "        abyss  whq          "
dc.b "                            "
dc.b "        the ambush          "
dc.b "      49-08621-64260        "
dc.b "    sysop: neurodancer      "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "        abyss  ghq          "
dc.b "(also gods and syndrome ghq)"
dc.b "                            "
dc.b "        los  endos          "
dc.b "      49-02103-52440        "
dc.b "     sysop: exon/riot       "
dc.b "            ghandy/gods     "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "moon sends greets to..      "
dc.b "                            "
dc.b "                            "
dc.b "bad cat/italian bad boys    "
dc.b "chris meland                "
dc.b "celtic/axis                 "
dc.b "devistator/eltech           "
dc.b "enzyme/neo                  "
dc.b "felix/massive/avocado       "
dc.b "ghandy/gods                 "
dc.b "kev and rich/mon-pd england "
dc.b "miko63/iris                 "
dc.b "mj/iris                     "
dc.b "substance/avocado/massive   "
dc.b "uyanik/trsi                 "
dc.b "wind/tnc                    "
dc.b "wizball/maniacs             "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "        - the end -         "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "

textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=1*15
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



Font:	incbin	"data/Font.raw"
even

scrolloffset:	dc.l	0

scrollwait:	dc.w	17

scrollsleep:	dc.w	1
scroller:
	lea	scrollsleep(pc),a0
	subq.w	#1,(a0)
;	bne.b	scroller_back
	move.w	#2,(a0)

	lea	scrolloffset,a0
	move.l	(a0),d0
	add.l	#40*7,d0
	cmp.l	#256*(40*7)+(40*7)*16,d0
	bne.b	noscrollrestart
	moveq	#0,d0
noscrollrestart:
	move.l	d0,(a0)

	subq.w	#1,scrollwait
	bne.b	scroller_back
	move.w	#17,scrollwait
	bsr.b	writeline


scroller_back:
rts


writeline:
	lea	scrollscreen-(40*7)*16+6,a0
	lea	screen+6,a2
	add.l	scrolloffset,a0
	lea	textpoint(pc),a3
	move.w	(a3),d7
	add.w	#28*2,(a3)+
	add.w	d7,a3
	tst.w	(a3)
	bpl.b	notextrestart
	sub.w	d7,a3
	move.w	#28*2,-2(a3)


notextrestart:
	move.l	a0,a4
	add.l	#(40*7)*256+(40*7)*16,a4
	moveq	#27,d6
	moveq	#0,d0
writeline_x:
	lea	font(pc),a1
	move.w	(a3)+,d1
	add.w	d1,a1

value:	set	0
rept	15
	move.b	(a1)+,d1
	move.b	d1,d2
	not.b	d2

	move.b	0*40(a2),d5
	and.b	d2,d5
	or.b	d1,d5
	move.b	d5,value*(40*7)+40*0(a4)
	move.b	d5,value*(40*7)+40*0(a0)

	move.b	1*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*1(a4)
	move.b	d5,value*(40*7)+40*1(a0)

	move.b	2*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*2(a4)
	move.b	d5,value*(40*7)+40*2(a0)

	move.b	3*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*3(a4)
	move.b	d5,value*(40*7)+40*3(a0)

	move.b	4*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*4(a4)
	move.b	d5,value*(40*7)+40*4(a0)

	move.b	5*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*5(a4)
	move.b	d5,value*(40*7)+40*5(a0)

	move.b	6*40(a2),d5
	and.b	d2,d5
	move.b	d5,value*(40*7)+40*6(a4)
	move.b	d5,value*(40*7)+40*6(a0)

value:	set	value+1
endr

	addq.w	#1,a0
	addq.w	#1,a4
	addq.w	#1,a2
	dbf	d6,writeline_x
	rts


codep_e:


ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:

Copperlist1:	ds.b	38504
JunkyBorder1:	ds.w	Junkybordersize
Junkyborder1end:
Copperlist2:	ds.b	38504
JunkyBorder2:	ds.w	Junkybordersize
Junkyborder2end:

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
dpx:	rs.l	1
dpy:	rs.l	1

mpx:	rs.l	1
mpy:	rs.l	1

sizex=Jsx/2
sizey=Jsy/2
;sizex=160
;sizey=128
Coord_s:
	dc.w	0,-sizex,-sizey,0
	dc.w	0,+sizex,+sizey,0
	dc.w	0,-sizex,+sizey,0

	dc.w	0,+sizex,-sizey,0


Coord_d:
	dc.w	0,0,0,0
	dc.w	0,0,0,0
	dc.w	0,0,0,0
	dc.w	0,0,0,0

Copperlist_work:	dc.l	copperlist1
Copperlist_show:	dc.l	copperlist2


turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddz:	dc.w	0
turnz:		dc.w	0
f_zoom:		dc.w	0
zoom_dest:	dc.w	0
dc.l	0


include	"include/sincos.s"


;Code_WaterJames:		incbin	"data/WaterJames.term"
Code_WaterJames:		incbin	"data/WaterJames.term.stc"
even
datap_e:

ifne	UseSection
ifeq	Onlychip
section	BSSP,bss_p
else
section	BSSP,bss_c	;onlychip
endif
endif
bssp_s:
BlurTab:	ds.w	4096	;rgb step -1
;BlurTab2:	ds.w	4096	;rgb halfe




Coplist_Offset:			ds.w	Coplist_Offsetsize
Coplist_Offsetend:

		ds.l	1
Coplist_OffsetDelta:		ds.w	Coplist_Offsetsize
		ds.l	1


ifne	precalc
junkytable:	ds.w	coplist_offsetsize*45
junkytableend:
endif

bssp_e:


ifne	showmem
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
endif

printt
printt	"Jx:"
printv	jx
printt	"Jy:"
printv	jy
printt	"Jsx:"
printv	jsx
printt	"Jsy:"
printv	jsy

printt	"Offsetsize:"
printv	Coplist_offsetsize*2
printt	"Junkybordersize:"
printv	Junkybordersize*2
ifne	junkybordersize
printt	"Calculating speed slowdown caused by the border in %:"
printv	(Jsx*Jsy)*100/(jx*jy)-100
endif
printt	"Calcmem-range:"
printv	38504+junkybordersize*2
ifd	junkytable
printt	"Junkytable size:"
printv	junkytableend-junkytable
endif

ifne	precalc
printt	"Junky_readtablecodesize:"
printv	Junky_Readtableend-JRTcolmix1_set
endif

