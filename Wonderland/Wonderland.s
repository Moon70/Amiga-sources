findresident=-96
OpenFont=-72
oldopenlibrary=-408


bright=0

UseSection=1
Onlychip=0
showmem=1
Main_Callcommander=0


longcheck=0
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




Onepic=1	;1=set x/y to zero if overflow in junky_set
		;0=sub to get more pics if overflow
	;NOTE! Onepic=1 doesnt work correct any longe, because of
	;      u/o-flow-fasttable  -the speed-gain is it really worth!
;------------------------------------------------------------------------
;---parameter check------------------------------------------------------
;----

;------------------------------------------------------------------------


Main_Joyhold=0

showtime=0
Program_ID=1

Main_SkipWBStartTest=1

Planesize=1*40

TextPlanesize=256*40



ifne	UseSection
ifeq	Onlychip
section	CodeP,code_p
else
section	CodeP,code_c	;onlychip
endif
endif
codep_s:


include	"moon:maininit/Maininit6.2.s"

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

	move.l	4.w,a6
	lea	gfxname(pc),a1		;name gfxlib
	jsr	oldopenlibrary(a6)	;openlib
	
	move.l	d0,A6			; Use The GfxBase Pointer
	lea	textattr(pc),A0		; FontStructure Pointer To A0
	lea	fontname(pc),a1
	move.l	a1,(a0)			;insert fontname in textattrlist
	jsr	openfont(A6)
	move.l	d0,a1			;fontpointer
	move.l	34(A1),fontadress	;fontadress


	bsr.w	makecoltable



;3dsinemaker
	lea	SinCosSector(pc),a0
	lea	SinCos,a1

	move.l	a1,a2		;a1=sector 1
	lea	90*2*4(a2),a2	;a2=sector 2
	move.l	a2,a3		;a3=sector 3
	lea	90*2*4(a3),a4	;a4=sector 4

	moveq	#90-1,d7
d3sinemaker_loop1:
	move.w	(a0)+,d0
	swap	d0
	sub.w	d0,d0
	move.l	d0,(a1)+
	move.l	d0,-(a2)
	neg.l	d0
	sub.w	d0,d0
	move.l	d0,(a3)+
	move.l	d0,-(a4)
	dbf	d7,d3sinemaker_loop1

	lea	SinCos+90*4,a0	;sinus
	lea	2-90*4(a0),a1		;cosinus
	move.w	#360-1,d7
d3sinemaker_loop2:
	move.w	(a0),(a1)
	addq.l	#4,a1
	addq.l	#4,a0
	cmp.l	#SinCosend,a0
	bne.b	noflow
	lea	SinCos,a0
noflow:
	dbf	d7,d3sinemaker_loop2


	moveq	#0,d0
	move.w	d0,turnsinpoint
	move.w	d0,turnsintableoffset
	move.w	d0,sinxpoint

	lea	Sincos,a0
	lea	Turnsin,a1
	lea	sinx,a2
	move.w	#360-1,d7
MakeTurnSin_loop:
	move.w	#359,d0
	sub.w	d7,d0
	lsl.w	#2,d0
	move.w	0(a0,d0.w),d0
	move.w	d0,d1
	move.w	d0,d2
	muls.w	#12,d0
	add.l	d0,d0
	swap	d0
	asl.w	#2,d0
	bpl.b	MakeTurnSin_noneg1
	add.w	#360*4,d0
MakeTurnSin_noneg1:

	muls.w	#141,d1
	add.l	d1,d1
	swap	d1
	asl.w	#2,d1
	bpl.b	MakeTurnSin_noneg2
	add.w	#360*4,d1
MakeTurnSin_noneg2:

	muls.w	#18,d2
	add.l	d2,d2
	swap	d2
	add.l	#53,d2
	add.l	d2,d2
	move.w	d2,(a2)+

	move.w	d1,720(a1)
	move.w	d0,(a1)+
	dbf	d7,MakeTurnSin_loop


	lea	MultabJSX,a0
	moveq	#jsy-1,d7
	moveq	#0,d0
MakeMultab_loop:
	move.w	d0,d1
	mulu.w	#jsx,d1
	move.l	d1,(a0)+
	addq.w	#1,d0
	dbf	d7,MakeMultab_loop


	move.l	#coord_d,turnkoord
	move.l	#coord_s,turnkoords

	lea	Copperlist1,a0
	lea	Junkyborder1,a1		;list of invisible colors
	bsr.w	coppercopy
	lea	Copperlist2,a0
	lea	Junkyborder2,a1		;list of invisible colors
	bsr.w	coppercopy


	move.l	#JunkyRGBprec,Junky_Code

	move.w	#3,turnquant

	moveq	#0,d0
	move.w	d0,turnaddz
	move.w	d0,turnz
	moveq	#45-1,d7	;45 pics for table
precalcloop:
	move.l	d7,-(a7)
	bsr.w	turner
	bsr.w	perspective
	bsr.w	Junky_Set
	move.l	(a7)+,d7
	add.w	#8*4,turnz
	move.w	#0,bplcon3(a5)
;	move.w	$6(a5),$180(a5)
	dbf	d7,precalcloop
;	move.w	#0,$180(a5)


	lea	copperlist_work,a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	bsr.w	Junky_Set



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
;	move.w	#%0000000000000011,fmode(a5)
;	move.w	#%1000001100000000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#EmptyVBI,(a0)

	move.w	#%1110000000000000,intena(a5)
rts

Writepage:
	bsr.w	chunkyback
	bsr.w	c2p

	move.l	fontadress(pc),a0
	moveq	#0,d0
	move.l	textpoint(pc),a4
	lea	textscreen,a2

	lea	40*70(a2),a2


	moveq	#6-1,d4
text_lineloopy:

	moveq	#20-1,d5
text_lineloopx:
	move.b	(a4)+,d0		;new char
	lea	-32(a0,d0.w),a1		;fontadress

	moveq	#0,d3	;shadow

	moveq	#8-1,d7
testloop2:
	move.b	(a1),d0

	move.b	d0,d1

	moveq	#7,d6
charzoomloop:
	roxr.b	#1,d0
	roxr.w	#1,d2
	roxr.b	#1,d1
	roxr.w	#1,d2
	dbf	d6,charzoomloop

	move.l	a2,a3

	move.w	d2,d6
	lsr.w	#1,d6
	move.w	d2,d1
	lsl.w	#1,d1
	or.w	d1,d3

	exg.l	d6,d3		;old shadow<-->new shadow

	or.w	d2,d6
	not.w	d6

	and.w	d6,(a2)
	and.w	d6,40(a2)
	or.w	d2,(a2)
	or.w	d2,40(a2)

	exg.l	d2,d6

	moveq	#7-1,d6
chardrawloop:
	lea	textplanesize(a3),a3
	and.w	d2,(a3)
	and.w	d2,40(a3)
	dbf	d6,chardrawloop

	lea	$c0(a1),a1
	lea	80(a2),a2
	lea	80(a3),a3

	dbf	d7,testloop2

	lea	2-80*8(a2),a2

	dbf	d5,text_lineloopx

	lea	80*10-40(a2),a2
	dbf	d4,text_lineloopy

	move.l	a4,textpoint

rts


mainloop:;;
	move.w	#0,f_VBI
waitframe:
	tst.w	f_VBI
	beq.b	waitframe
;----------------
;---------------
	bsr.w	turner
	bsr.w	perspective
	move.l	Code_Setblock(pc),a0
	jsr	(a0)
	bsr.w	Junky_Readtable
;---------------
	lea	copperlist_work,a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
	move.l	Main_Copperlist(pc),a0
	move.l	d0,(a0)

;move.w	framecount,look
;move.w	#0,framecount
mainloop_skip:
	rts
;----------

Code_Setblock:	dc.l	0

Commands:;;
;	dc.l	60000,	nothing
	dc.l	20,	alloff
	dc.l	20,	Set_Writepage
	dc.l	300,	settextscreen

	dc.l	20,	alloff
	dc.l	700,	setthreesquaresin0
	dc.l	5,	alloff
	dc.l	20,	Set_Writepage
	dc.l	300,	settextscreen
	dc.l	20,	alloff
	dc.l	700,	setthreesquaresin1

	dc.l	64,	exit




;	dc.l	1,	Command_Loop,	8*6
;Command_Loop:
;	move.l	(a1),d0
;	sub.w	d0,Commander_Point
;	rts

exit:
	moveq	#Program_ID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	move.l	d0,(a0)
	rts


setthreesquaresin0:
	move.l	#Draw_threesquares,Code_Setblock
	move.w	#0,turnsintableoffset
	bra.b	setwaterscreen

setthreesquaresin1:
	move.l	#Draw_threesquares,Code_Setblock
	move.w	#turnsinend-turnsin,turnsintableoffset
	bra.b	setwaterscreen


AllOff:
	move.l	Main_Copperlist(pc),a0
	move.l	#-2,(a0)

	move.l	Main_MasterCommand(pc),a0
	move.l	#0,4(a0)		;second priority mastercommand

	move.l	Main_VBIVector(pc),a0
	move.l	#EmptyVBI,(a0)
rts

Set_Writepage:
	move.l	Main_MasterCommand(pc),a0
	move.l	#Writepage,(a0)		;first priority mastercommand
rts


Setwaterscreen:
	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist1,(a0)
	move.l	Main_MasterCommand(pc),a0
	move.l	#MainLoop,4(a0)		;second priority mastercommand

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)


	move.l	#$298129c1,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
	move.l	#$003800b6,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)
	move.w	#%0111001000000000,bplcon0(a5)
	moveq	#0,d0
	move.l	d0,bplcon1(a5)
;	move.w	#0,bplcon2(a5)

	move.w	#%0111001000000000,bplcon0(a5)
	moveq	#-40,d0
	move.w	d0,bpl1mod(a5)
	move.w	d0,bpl2mod(a5)


;move.w	#0,bplcon3(a5)
;move.w	#0,$180(a5)

	lea	colbuffer,a4
	moveq	#128-1,d7
	moveq	#0,d0
colclr:
	move.l	d0,(a4)+
	move.l	d0,(a4)+
	dbf	d7,colclr
	bsr.w	colregset
rts


Settextscreen:
	move.l	Main_Copperlist(pc),a0
	move.l	#-2,(a0)
	move.l	Main_MasterCommand(pc),a0
	move.l	#0,4(a0)		;second priority mastercommand


	move.l	Main_VBIVector(pc),a0
	move.l	#VBI_text,(a0)

	move.l	#$298129c1,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
	move.l	#$003800b6,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)

	move.w	#%0000001000010000,bplcon0(a5)
	moveq	#0,d0
	move.l	d0,bplcon1(a5)
	move.l	d0,bpl1mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)


rts


nothing:	rts





;------------------------------------------------------------------------
JunkyRGBprec:
	lea	Scaledata,a3

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
;	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	2*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#Jsx,d0
	move.l	d0,dpx(a3)

	moveq	#0,d0
;	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	2*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#Jsy,d0
	move.l	d0,dpy(a3)

	move.l	precalcpos(pc),a0
	cmp.l	#junkytableend,a0
	beq.b	JunkyRGBprec_error_tablewriteoflow

	lea	MultabJSX,a1
	lea	Coplist_Offset,a4

	move.l	dpx(a3),d0
	move.l	dpy(a3),d1
	moveq	#Jsy-1,d7	;quick
JunkyRGBprec_Sety:
	move.l	mpx(a3),d4
	move.l	mpy(a3),d5


	moveq	#Jsx-1,d6	;quick
JunkyRGBprec_Setx:
	move.l	d4,d2
	move.l	d5,d3

;	sub.w	d2,d2
	swap	d2
;	sub.w	d3,d3
	swap	d3

cmp.w	#Jsx-1,d2
bgt.b	JunkyRGBprec_oflowx
tst.w	d2
bmi.b	JunkyRGBprec_uflowx

JunkyRGBprec_xflowtested:	;backjump if x if over/under flow

cmp.w	#Jsy-1,d3
bgt.b	JunkyRGBprec_oflowy
tst.w	d3
bmi.b	JunkyRGBprec_uflowy

JunkyRGBprec_yflowtested:	;backjump if x if over/under flow

	add.l	d0,d4	;dpx

	;mulu.w	#Jsx,d3
	move.l	(a1,d3.w*4),d3

	add.l	d1,d5	;dpy

	add.w	d2,d3
	add.w	d3,d3
	move.w	(a4,d3.w),d3	;next(right) coplist offset ;phase 2!!!!
	move.w	d3,(a0)+

	dbf	d6,JunkyRGBprec_Setx

	move.l	(a3),d2	;mdx
	add.l	d2,mpx(a3)
	move.l	mdy(a3),d2
	add.l	d2,mpy(a3)

	dbf	d7,JunkyRGBprec_Sety

	move.l	a0,precalcpos

JunkyRGBprec_error_tablewriteoflow:
	rts


JunkyRGBprec_oflowx:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
sub.w	#jsx-1,d2
endif
bra.b	JunkyRGBprec_xflowtested

JunkyRGBprec_uflowx:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
add.w	#jsx-1,d2
endif
bra.b	JunkyRGBprec_xflowtested


JunkyRGBprec_oflowy:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
sub.w	#jsy-1,d3
endif
bra.b	JunkyRGBprec_yflowtested

JunkyRGBprec_uflowy:
ifne	onepic
moveq	#0,d2
moveq	#0,d3
else
add.w	#jsy-1,d3
endif
bra.b	JunkyRGBprec_yflowtested





;***********************************************************************
;***********************************************************************
precalcpos:	dc.l	junkytable	;only coz no addreg free

;------------------------------------------------------------------------

VBI:
	lea	Screen,a0
	lea	planesize,a1
	move.l	a0,bpl1pth(a5)
	add.l	a1,a0
	move.l	a0,bpl2pth(a5)
	add.l	a1,a0
	move.l	a0,bpl3pth(a5)
	add.l	a1,a0
	move.l	a0,bpl4pth(a5)
	add.l	a1,a0
	move.l	a0,bpl5pth(a5)
	add.l	a1,a0
	move.l	a0,bpl6pth(a5)
	add.l	a1,a0
	move.l	a0,bpl7pth(a5)

	bsr.w	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount

rts

EmptyVBI:
	move.w	#%0000001000000000,bplcon0(a5)
	bsr.w	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount
rts

VBI_text:
	move.w	#%0000001000010000,bplcon0(a5)

	move.l	#$298129c1,diwstrt(a5)
;	move.w	#$29c1,diwstop(a5)
	move.l	#$003800b6,ddfstrt(a5)
;	move.w	#$00b6,ddfstop(a5)

	move.w	#%0000001000010000,bplcon0(a5)
	moveq	#0,d0
	move.l	d0,bplcon1(a5)
	move.l	d0,bpl1mod(a5)

	move.w	d0,bplcon4(a5)

	lea	TextScreen,a0
	lea	TextPlanesize,a1
	move.l	a0,bpl1pth(a5)
	add.l	a1,a0
	move.l	a0,bpl2pth(a5)
	add.l	a1,a0
	move.l	a0,bpl3pth(a5)
	add.l	a1,a0
	move.l	a0,bpl4pth(a5)
	add.l	a1,a0
	move.l	a0,bpl5pth(a5)
	add.l	a1,a0
	move.l	a0,bpl6pth(a5)
	add.l	a1,a0
	move.l	a0,bpl7pth(a5)
	add.l	a1,a0
	move.l	a0,bpl8pth(a5)


	bsr.w	commander
	move.w	#1,f_VBI
	addq.w	#1,framecount

	bsr.w	colregset

	move.w	#0,bplcon3(a5)
	move.w	#$0000,$180(a5)
	move.w	#0,bplcon3(a5)
	move.w	#$0fff,$182(a5)



	move.w	colours1_pos,d0
	addq.w	#4,d0
	cmp.w	#2*256*4,d0
	bne.b	.noflow
	moveq	#0,d0
.noflow:
	move.w	d0,colours1_pos


	move.w	colours2_pos,d1
	addq.w	#8,d1
	cmp.w	#2*256*4,d1
	bne.b	.noflow2
	moveq	#0,d1
.noflow2:
	move.w	d1,colours2_pos

	move.w	colours3_pos,d2
	sub.w	#8,d2
	bpl.b	.noflow3
	add.w	#2*256*4,d2
.noflow3:
	move.w	d2,colours3_pos

;-------------------------------------------------------------
	lea	colours1,a0
	add.w	d0,a0
	lea	colours2,a2
	add.w	d1,a2
	lea	colours3,a3
	add.w	d2,a3

	lea	colbuffer,a4

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
	move.l	(a0)+,d0
	or.l	(a2)+,d0
	or.l	(a3)+,d0
	move.l	d0,d1

	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	lsr.w	#4,d1
	rol.l	#8,d1

	lsr.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	swap	d0

;	move.w	d0,(a1)
;	move.w	d3,bplcon3(a5)
;	move.w	d1,(a1)+
;	move.w	d2,bplcon3(a5)

	move.w	d1,256*2(a4)
	move.w	d0,(a4)+

	dbf	d7,colcopyloop1
	dbf	d6,colcopyloop2

rts


colregset:
	lea	colbuffer,a4
	lea	256*2(a4),a2

	moveq	#7,d6
colcopyloop22:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,d3
	bset.l	#9,d3

	move.w	d2,bplcon3(a5)
	lea	$180(a5),a1
	moveq	#32/2-1,d7
colcopyloop12:
	move.l	(a4)+,(a1)+
	dbf	d7,colcopyloop12

	move.w	d3,bplcon3(a5)
	lea	$180(a5),a1
	moveq	#32/2-1,d7
colcopyloop13:
	move.l	(a2)+,(a1)+
	dbf	d7,colcopyloop13

	dbf	d6,colcopyloop22
rts

Coppercopy:
;--> a0  ;address of copperlist
;--> a1  ;addrsss of Junkyborder

	move.l	a0,d3			;copadr to calc offsets
	add.l	#32700,d3
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
rts



 
Junky_Code:	dc.l	0;Junkyrgbprec

Junky_Set:
	move.l	Junky_Code(pc),a0
	jmp	(a0)


;#####################################################################
;#####################################################################
Junkytable_readpos:	dc.l	junkytable

Junky_Readtable:
	move.l	Copperlist_work,a0
	move.l	Copperlist_show,a6
	lea	32700(a0),a0
	lea	32700(a6),a6

	lea	Coplist_Offset,a1	;destination counter, increasing
	move.l	a1,a2			;source pointer, for colmix

	move.l	junkytable_readpos(pc),a3
	move.w	#Jsy*Jsx/4-1-1,d7	;quick
	moveq	#0,d0

	move.w	(a3)+,d0	;get precalculated offset
;	move.w	(a2,d0.w),d0	;coplist offset
	move.w	(a6,d0.w),d0	;copperlist pos (peek color of lpx;lpy)
	and.w	#%0000111011101110,d0

JRTcolmix1_Set:
	movem.w	(a3),d1-d4
	addq.l	#8,a3

	move.w	(a6,d1.w),d1	;copperlist pos (peek color of lpx;lpy)
	and.w	#%0000111011101110,d1
	add.w	d1,d0
	lsr.w	#1,d0
	move.w	(a1)+,d6
	move.w	d0,(a0,d6.w)	;8 16 write colorcode in copperlist
	move.w	d1,d0

	move.w	(a6,d2.w),d1	;copperlist pos (peek color of lpx;lpy)
	and.w	#%0000111011101110,d1
	add.w	d1,d0
	lsr.w	#1,d0
	move.w	(a1)+,d6
	move.w	d0,(a0,d6.w)	;8 16 write colorcode in copperlist
	move.w	d1,d0

	move.w	(a6,d3.w),d1	;copperlist pos (peek color of lpx;lpy)
	and.w	#%0000111011101110,d1
	add.w	d1,d0
	lsr.w	#1,d0
	move.w	(a1)+,d6
	move.w	d0,(a0,d6.w)	;8 16 write colorcode in copperlist
	move.w	d1,d0

	move.w	(a6,d4.w),d1	;copperlist pos (peek color of lpx;lpy)
	and.w	#%0000111011101110,d1
	add.w	d1,d0
	lsr.w	#1,d0
	move.w	(a1)+,d6
	move.w	d0,(a0,d6.w)	;8 16 write colorcode in copperlist
	move.w	d1,d0


	dbf	d7,JRTcolmix1_Set
	rts
Junky_Readtableend:


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
	lea	coltabpos,a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#coltabend-coltab,d0
	bne.b	DrawThreeSquares_nocoltabflow
	moveq	#0,d0
DrawThreeSquares_nocoltabflow:
	move.w	d0,(a0)+
	lea	(a0,d0.w),a3

	move.l	Copperlist_show,a6
	lea	32700(a6),a6

	lea	sinx,a1
	moveq	#3,d7
	lea	DrawThreesquares_sinpoints(pc),a0
DrawThreeSquares_blockloop:

	lea	Coplist_Offset,a2

	move.w	2(a0),d0
	add.w	(a0)+,d0
	cmp.w	#sinxend-sinx,d0
	bne.b	DrawThreeSquares_nosinxflow
	moveq	#0,d0
DrawThreeSquares_nosinxflow:
	move.w	d0,(a0)+
	add.w	(a1,d0.w),a2

	move.w	(a1,d0.w),d0
	mulu.w	#jsx,d0
	and.w	#-2,d0
	add.w	d0,a2

	moveq	#0,d1
	move.w	(a3),d3
	lea	40(a3),a3

	moveq	#7,d6
DrawThreeSquares_yloop:
	moveq	#8-1,d5
DrawThreeSquares_copyloop:
	move.w	(a2)+,d1
	move.w	d3,(a6,d1.w)
	dbf	d5,DrawThreeSquares_copyloop
	add.w	#(jsx-8)*2,a2
	dbf	d6,DrawThreeSquares_yloop
	dbf	d7,DrawThreeSquares_blockloop
	rts
;-------------------------
;***********************************************************************

blockposx:	dc.w	60*2
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

	lsr.w	#2,d0	;angle range 0-359
	lsr.w	#3,d0	;angle range 0-44

	mulu.w	#coplist_offsetsize*2,d0
	move.l	#junkytable,d1
	add.l	d0,d1
	move.l	d1,Junkytable_readpos

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
	dc.w	-1



f_screencopy:	dc.w	0
f_VBI:		dc.w	0
framecount:	dc.w	0
palswap:	dc.w	0
colours1_pos:	dc.w	0
colours2_pos:	dc.w	0
colours3_pos:	dc.w	0

Coord_d:
	dc.w	0,0,0,0
	dc.w	0,0,0,0
	dc.w	0,0,0,0
	dc.w	0,0,0,0

turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddz:	dc.w	0
turnz:		dc.w	0
f_zoom:		dc.w	0
zoom_dest:	dc.w	0
dc.l	0




RGBpal:
Coltabpos:	ds.w	1	;|
Coltab:		;|
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
Coltabend:	;|
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



sizexb=320
sizeyb=256


ChunkyBack:
	lea	chunky,a0
	move.w	#SizeYB-1,d7		;b-loop
loopy:
	move.w	#SizeXB-1,d6		;a-loop
loopx:
	move.w	d6,d0

	eor.b	d7,d0
	add.b	d0,d0
	eor.b	d7,d0


;	mulu.w	d7,d0
;	ror.w	d0,d0
;ror.b	d0,d0

	or.b	#2,d0
	move.b	d0,(a0)+

	dbf	d6,loopx
	dbf	d7,loopy
rts


C2P:
	lea	TextScreen,a0
	lea	Chunky,a1

	move.l	a0,a2
	add.l	#textplanesize*2,a2
	move.l	a2,a3
	add.l	#textplanesize*2,a3
	move.l	a3,a4
	add.l	#textplanesize*2,a4

	lea	C2P_Data(pc),a6
	move.w	#320*256/8/2/2,C2P_Counter(a6)

C2P_Loop:
	move.w	#2,C2P_2Count(a6)
C2P_Loop2:
	move.w	#8,(a6)

C2P_8Loop:
	move.w	(a1)+,d0	;get chunkyword (=2 pixel)
	add.w	d0,d0		;pix1plane7
	addx.l	d7,d7

	add.w	d0,d0		;pix1plane6
	addx.l	d6,d6

	add.w	d0,d0
	addx.l	d5,d5

	add.w	d0,d0
	addx.l	d4,d4

	add.w	d0,d0
	addx.l	d3,d3

	add.w	d0,d0
	addx.l	d2,d2

	add.w	d0,d0
	addx.l	d1,d1

	add.w	d0,d0
	swap	d0		;wahh, need more register...
	addx.w	d0,d0
	swap	d0

	add.w	d0,d0		;pix2plane7
	addx.l	d7,d7

	add.w	d0,d0		;pix2plane6
	addx.l	d6,d6

	add.w	d0,d0
	addx.l	d5,d5

	add.w	d0,d0
	addx.l	d4,d4

	add.w	d0,d0
	addx.l	d3,d3

	add.w	d0,d0
	addx.l	d2,d2

	add.w	d0,d0
	addx.l	d1,d1

	add.w	d0,d0
	swap	d0		;wahh, need more register...
	addx.w	d0,d0
	swap	d0

subq.w	#1,(a6)
bne.b	C2P_8Loop
	swap	d0
	move.w	d0,(a0)+
	swap	d0

	subq.w	#1,2(a6)
	bne.b	C2P_Loop2

	move.l	d7,textplanesize(a4)
	move.l	d6,(a4)+
	move.l	d5,textplanesize(a3)
	move.l	d4,(a3)+
	move.l	d3,textplanesize(a2)
	move.l	d2,(a2)+
	move.l	d1,textplanesize-4(a0)
;	move.w	d0,(a0)+

	subq.w	#1,C2P_Counter(a6)
	bne.b	C2P_Loop

	rts

C2P_Data:	rsreset
		dcb.w	3,0
C2P_8Count:	rs.w	1
C2P_2Count:	rs.w	1
C2P_Counter:	rs.w	1


makecoltable:
	lea	colours1,a0
	lea	colours2,a1
	lea	colours3,a2

ifne	bright
	move.w	#256-1,d7
else
	move.w	#128-1,d7
endif
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
makecoltable_loop1:
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
ifeq	bright
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
endif
	addq.l	#$00000001,d0
	add.l	#$00000100,d1
	add.l	#$00010000,d2
	dbf	d7,makecoltable_loop1

ifne	bright
	move.w	#256-1,d7
else
	move.w	#128-1,d7
endif
makecoltable_loop2:
	subq.l	#$00000001,d0
	sub.l	#$00000100,d1
	sub.l	#$00010000,d2

	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
ifeq	bright
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
endif
	dbf	d7,makecoltable_loop2

	rts



Scaledata:	rsreset
dcb.l	6,0

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



Copperlist_work:	dc.l	copperlist1
Copperlist_show:	dc.l	copperlist2





SinCosSector:
dc.W  0, 572, 1144, 1715, 2286, 2856, 3425, 3993, 4560, 5126
dc.W  5690, 6252, 6813, 7371, 7927, 8481, 9032, 9580, 10126
dc.W  10668, 11207, 11743, 12275, 12803, 13328, 13848, 14364
dc.W  14876, 15383, 15886, 16383, 16876, 17364, 17846, 18323
dc.W  18794, 19260, 19720, 20173, 20621, 21062, 21497, 21925
dc.W  22347, 22762, 23170, 23571, 23964, 24351, 24730, 25101
dc.W  25465, 25821, 26169, 26509, 26841, 27165, 27481, 27788
dc.W  28087, 28377, 28659, 28932, 29196, 29451, 29697, 29934
dc.W  30162, 30381, 30591, 30791, 30982, 31163, 31335, 31498
dc.W  31650, 31794, 31927, 32051, 32165, 32269, 32364, 32448
dc.W  32523, 32588, 32642, 32687, 32722, 32747, 32762



gfxname:	dc.b	"graphics.library",0
even

fontadress:	dc.l	0

textattr:	DC.L	0
		DC.W	8
		DC.B	0
		DC.B	0
fontname:	DC.B	"topaz.font",0,0
even

TextPoint:	dc.l	text


text:;		 1234567890123456789012345678901234567890
	dc.b	"ABYSS IN WONDERLAND "
	dc.b	"                    "
	dc.b	"                    "
	dc.b	"made for Symposium97"
	dc.b	"                    "
	dc.b	"    code by Moon    "

	dc.b	"GREETINGS: Celtic-Mj"
	dc.b	"Lousy-Darkhawk-Felix"
	dc.b	"Blunt-Substance-Mare"
	dc.b	"Sixpack-Dafix-Uyanik"
	dc.b	"Ghandy-Ten-Mink-Raze"
	dc.b	" Miko63-Defcat-Nork "


codep_e:

ifne	UseSection
section	DataC,data_c
endif
datac_s:
Screen:
	incbin	"data/JunkyGrid_3.blt1"
Screenend:


datac_e:



ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
TextScreen:
	ds.b	8*80*256
TextScreen_end:

Copperlist1:	ds.b	38504
JunkyBorder1:	ds.w	Junkybordersize
Junkyborder1end:
Copperlist2:	ds.b	38504
JunkyBorder2:	ds.w	Junkybordersize
Junkyborder2end:

bssc_e:



ifne	UseSection
ifeq	Onlychip
;section	DataP,data_p
else
;section	DataP,data_c	;onlychip
endif
endif
datap_s:
datap_e:

ifne	UseSection
ifeq	Onlychip
section	BSSP,bss_p
else
section	BSSP,bss_c	;onlychip
endif
endif
bssp_s:

Coplist_Offset:			ds.w	Coplist_Offsetsize
Coplist_Offsetend:

		ds.l	1
Coplist_OffsetDelta:		ds.w	Coplist_Offsetsize
		ds.l	1


junkytable:	ds.w	coplist_offsetsize*45
junkytableend:


turnsinpoint:		ds.w	1	;|
turnsintableoffset:	ds.w	1	;|
Turnsin:		ds.w	360	;|
turnsinend:				;|
			ds.w	360	;|
AllTurnsinend:				;|


sinxpoint:		ds.w	1	;|
sinx:			ds.w	360	;|
sinxend:

MultabJSX:		ds.l	jsy

SinCos:			ds.l	360
SinCosend:


Chunky:		ds.b	320*256


	colours1:	ds.l	4*256
	colours2:	ds.l	4*256
	colours3:	ds.l	4*256

	colbuffer:	ds.l	256

;Coltabpos:	ds.w	1	;|
;Coltab:		ds.w	368	;|
;Coltabend:	ds.w	368	;|

bssp_e:

ifne	UseSection
;section	CodeC,code_c
endif
codec_s:
codec_e:


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


ifnd	a
a:
b:
endif

printt	"b-a="
printv	b-a
end

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

printt	"Junky_readtablecodesize:"
printv	Junky_Readtableend-JRTcolmix1_set


ifne	longcheck
printt	"Longcheckpoints:"
printv	checkpoint1
printv	checkpoint2
printv	scaledata
printv	junkyrgbcm
printv	junkyrgbprec
endif
