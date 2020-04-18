;------------------------------------------------------------------------
;|									|
;|				MIRACLE 1				|
;|			       -----------				|
;|									|
;|									|
;| This is not the real 'Issue 1-source', as this one went lost.	|
;| This version contains some changes (for issue 2), it is the last	|
;| update (it's unfinished) as issue 2 was canceled.			|
;|									|
;| But Miracle01.exe is the 'real' release-version.			|
;|									|
;|									|
;|						code by Moon/Abyss	|
;------------------------------------------------------------------------


UseSection=1

ifeq	Usesection
section	Code,code_c
endif

a:
incdir	"ram:"
q:

showtrace=1

Main_ShowParameter=0
Main_Status=0
Main_Exitrmb=1
Main_Exitlmb=0
Main_SkipWBStartTest=1


Streamcode_Return=0
Streamcode_Button=5



ifne	UseSection
section	CodeP,code_p
endif
;------------------------------------------------------------------------
codep_s:;----------------------------------------------------------------
include	"data/maininit/MainInit6.2.s"
dc.b "$VER: Miracle Issue 1 by IRIS",0
even

;------------------------------------------------------------------------
Commands:;;
;	dc.l	1,	nothing
	dc.l	1,	Setup_Iris
	dc.l	200,	nothing
	dc.l	80,	FadeIrisOut
	dc.l	1,	Setup_Title
	dc.l	200,	Order_Screen012CLR
	dc.l	100,	TitleJaulStart
	dc.l	1,	Setup_Miracle
	dc.l	65000,	nothing

nothing:	rts

TitleJaulStart:
	move.w	#0,TitleJaul_F_Skip
	rts

FadeIrisOut:
	move.w	#Fader2_Colquant_Iris,fader2_quant
	move.w	#fader2_Tablequant_Iris*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

;	move.w	#1,fader2_direct		;this combination to...
;	move.l	#fader2_table_Iris,Fader2_pos	;...fade forward

	move.w	#-1,fader2_direct		;this combination to...
	move.l	#fader2_tableend_Iris,Fader2_pos	;...fade backward
rts


Order_Screen012CLR:
	move.l	Main_Mastercommand(pc),a0
	lea	Screen012CLR(pc),a1
	move.l	a1,(a0)
	rts

Screen012CLR:
	bsr	Screen1_CLS		;now clear 01(2)
	bsr	Screen2_CLS		;now clear 01(2)
	bsr	Screen3_CLS		;now clear 01(2)
	rts
;---------
Main_Init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand

	lea	playercode,a0
	lea	player,a1
	move.w	#(playerend-player)/4-1,d7
playerback:
	move.l	(a1)+,(a0)+
	dbf	d7,playerback

	bsr	Fader2_Iris

;---
	move.w	#0,p60_master
	bsr	set_module1
	move.w	#0,p60_fadestep
;---
	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
Main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)
	move.l	Main_VBIVector(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5

	move.w	#%0000000000001111,dmacon(a5)
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_Program:;;
;	bsr	Setup_Title

	bsr	Commander

	rts
;----------
Setup_Iris:
	bsr	coppercopy_Iris
	move.w	#%0000000010000000,dmacon(a5)
	nop
	move.w	#%1000001100100000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	lea	vbi_Iris(pc),a1
	move.l	a1,(a0)

	move.l	Main_Mastercommand(pc),a0
	lea	Mainloop(pc),a1
	move.l	a1,4(a0)

	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#200+240,bpl1mod(a5)
	move.w	#200+240,bpl2mod(a5)
	move.w	#%0110001000000100,bplcon0(a5)
;	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#%1000001100000000,dmacon(a5)
	btst.b	#7,$004(a5)
	bne.b	sf_badframe

	bsr	Fader2start_Iris
	move.l	Main_Copperlist(pc),a0
	lea	Copperlist1,a1
	move.l	a1,(a0)

	move.l	#-2,copperlist
	move.l	#copperlist,cop1lch(a5)
	nop
	move.w	#0,copjmp1(a5)
	nop
	move.w	#%1000001110000000,dmacon(a5)

	lea	pal_Iris,a0
	lea	$180(a5),a1
	moveq	#32-1,d7
SetIrisCol_Loop:
;	move.w	(a0)+,(a1)+
	move.w	#$0,(a1)+
	dbf	d7,SetIrisCol_Loop
;	move.w	#64,fader_direct
;	move.w	#fadequant1*2,fader_direct
	rts

sf_badframe:
	subq.w	#8,Commander_Point
	move.w	#1,Commander_Sleep
	move.w	#%0000001000000100,bplcon0(a5)
;---------------------------------
	rts
;----------
;----------
Setup_Title:
	bsr	coppercopy_title
	move.l	Main_Copperlist(pc),a0
	lea	Copperlist,a1
	move.l	a1,(a0)
	move.w	#%1000001110100000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	lea	vbi_title(pc),a1
	move.l	a1,(a0)

;	lea	pal_title,a0
;	lea	$180(a5),a1
;	moveq	#32-1,d7
;SetTitleCol_Loop:
;	move.w	(a0)+,(a1)+
;	dbf	d7,SetTitleCol_Loop

	bsr	Fader2_Title
	bsr	Fader2start_Title

	move.l	Main_Mastercommand(pc),a0
	lea	Mainloop(pc),a1
	move.l	a1,4(a0)

	rts
;----------
Setup_Miracle:
	bsr	coppercopy
	move.l	Main_Copperlist(pc),a0
	lea	Copperlist,a1
	move.l	a1,(a0)
	move.w	#%1000001110100000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	lea	vbi(pc),a1
	move.l	a1,(a0)

	lea	pal_mouse,a0
	lea	$1a0(a5),a1
	moveq	#(16/2)-1,d7
SetMouseCol_Loop:
	move.l	(a0)+,(a1)+
	dbf	d7,SetMouseCol_Loop

	move.l	Main_Mastercommand(pc),a0
	lea	Set_Article0(pc),a1
	move.l	a1,(a0)
	lea	Mainloop(pc),a1
	move.l	a1,4(a0)
	move.w	#1,Button_F_Skip
	move.w	#1,Click_F_Skip
	move.w	#1,MainInputRK_F_Skip

	rts
;----------
Set_Article0:
	move.w	#0,d0
	bra	Set_Article


Mainloop:;;
tst.w	VBI_Flag
;beq	Mainloop_skip
beq	Mainloop
move.w	#0,VBI_Flag

Mainloop_skip:
rts


MoveLeft:
	lea	Article_Page,a0
	move.w	(a0),d0
	cmp.w	Article_PageQuant,d0
	beq	MoveLeft_Skip		;actpage=lastpage -> no move left
	addq.w	#1,d0
	move.w	d0,(a0)

	lea	screen_scrolloffsetadd(pc),a0
	move.w	#2,(a0)			;start scrolling

	move.w	Article_Page(pc),d0
	cmp.w	Article_PageQuant,d0
	beq	MoveLeft_NoPreWrite	;showpage=lastpage -> no next2prewrite

	addq.w	#1,d0
	lsl.w	#2,d0
	lea	Article_Pages,a0
	lea	Streampos,a1
	move.l	0(a0,d0.w),(a1)

	bsr	Screen_BufferCls
	bsr	writepage		;write page
MoveLeft_NoPreWrite:


	lea	screen_scrolloffsetadd(pc),a0
MoveLeft_Wait:
;move.w	6(a5),$180(a5)
	tst.w	(a0)			;scrolling finished?
	bne	MoveLeft_Wait		;no, then wait (optimize this later)

	bsr	Screen_Copyleft		;copy screenplanes
	move.l	#80,screen_scrolloffset	;jump with offset to have 0[1]2 pos
	bsr	WaitNextFrame		;wait till copper has set new planeaddress

	move.l	#160,d0			;offset to write in page 01(2)
	bsr	Screen_BufferCopy

;	bsr	Screen3_CLS		;now clear 01(2)
	bsr	CopyButtonData
MoveLeft_Skip:
	move.w	#0,Button_F_Skip
	move.w	#0,Click_F_Skip
	move.w	#0,MainInputRK_F_Skip
	rts


MoveRight:
	lea	Article_Page,a0
	move.w	(a0),d0
	beq	MoveLeft_Skip		;actpage=page0 -> no move right
	subq.w	#1,d0
	move.w	d0,(a0)

	lea	screen_scrolloffsetadd(pc),a0
	move.w	#-2,(a0)		;start scrolling


	move.w	Article_Page(pc),d0
	beq	MoveRight_NoPreWrite	;showpage=page0 -> no next2prewrite

	subq.w	#1,d0
	lsl.w	#2,d0
	lea	Article_Pages,a0
	lea	Streampos,a1
	move.l	0(a0,d0.w),(a1)

	bsr	Screen_BufferCls
	bsr	writepage		;write page

MoveRight_NoPreWrite:


	lea	screen_scrolloffsetadd(pc),a0
MoveRight_Wait:
;move.w	6(a5),$180(a5)
	tst.w	(a0)			;scrolling finished?
	bne	MoveRight_Wait		;no, then wait (optimize this later)
;bsr	flash
	bsr	Screen_CopyRight	;copy screenplanes
	move.l	#80,screen_scrolloffset	;jump with offset to have 0[1]2 pos
	bsr	WaitNextFrame		;wait till copper has set new planeaddress

	move.l	#0,d0			;offset to write in page (0)12
	bsr	Screen_BufferCopy

;	bsr	Screen1_CLS		;now clear (0)12
	bsr	CopyButtonData

MoveRight_Skip:
	move.w	#0,Button_F_Skip
	move.w	#0,Click_F_Skip
	move.w	#0,MainInputRK_F_Skip
	rts

;MoveRight_Skipdraw:
;	move.w	#1,F_NoMoveRight
	rts

SeekPageLeft:
	moveq	#0,d0
	moveq	#18-1,d7
SeekPageLeft_Yloop:
	moveq	#80-1,d6
SeekPageLeft_Xloop:
SeekPageLeft_NoVisCom:
	move.b	-(a0),d0	;get byte
	cmp.b	#-1,d0		;command-code?
	bne	SeekPageLeft_NoCommand	;no command
	move.b	-(a0),d0	;get commandstring-length
	sub.w	d0,a0		;now stream-pointer skipped the c-string
	move.b	2(a0),d0	;get command
	bmi	SeekPageLeft_NoVisCom	;no visible command
	cmp.b	#1,d0		;csr right temp
	bne	SeekPageLeft_NoCommand	;ERROR-bad command!!!!!



SeekPageLeft_NoCommand:
;	move.w	$6(a5),$180(a5)
	dbf	d6,SeekPageLeft_Xloop
	dbf	d7,SeekPageLeft_Yloop
;page finished, check if there's a command BEFORE the first char!!!!!!
	move.l	a0,a1
SeekPageLeft_CommandStartScan:
	move.b	-(a0),d0
	cmp.b	#-1,d0
	bne	SeekPageLeft_NoCommandStart
	move.b	-(a0),d0	;get commandstring-length
	sub.w	d0,a0		;now stream-pointer skipped the c-string
	move.b	2(a0),d0	;get command
	bpl	SeekPageLeft_NoCommandStart	;visible command
	move.l	a0,a1
	bra	SeekPageLeft_CommandStartScan


SeekPageLeft_NoCommandStart:
	move.l	a1,a0
	rts


Seekpage_Buttondata:	dc.l	0

SeekPageRight:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#18-1,d7
SeekPageRight_Yloop:
	moveq	#80-1,d6
SeekPageRight_Xloop:
SeekPageRight_NoVisCom:
	move.b	(a0)+,d0	;get byte
	cmp.b	#-1,d0		;command-code?
	bne	SeekPageRight_NoCommand	;no command
	move.b	(a0)+,d1	;get commandstring-length
	move.b	(a0),d0		;get command
	add.w	d1,a0		;now stream-pointer skipped the c-string
	tst.b	d0
	bmi	SeekPageRight_NoVisCom	;no visible command
	cmp.b	#1,d0		;csr right temp
	beq	SeekPageRight_NoCommand	;handle CSR-right as normal char
;---
SeekPageRight_CodeReturn:
;	move.b	#Streamcode_Return,look1
;	move.b	d0,look2
	cmp.b	#Streamcode_Return,d0
tst.b	d0
	bne	SeekPageRight_NoReturn
	moveq	#0,d6
	bra	SeekPageRight_NextLine
;---
SeekPageRight_NoReturn:

;SeekPageRight_CodeButton:
	cmp.b	#Streamcode_Button,d0
	bne	SeekPageRight_NoButton
	move.l	a0,-(a7)
	sub.w	d1,a0
	addq.w	#1,a0
	move.l	a0,Seekpage_Buttondata
	move.l	(a7)+,a0
	bra	SeekPageRight_NoVisCom	;no visible command
	

SeekPageRight_NoButton:



addq.w	#1,error
move.b	d0,look1
move.b	#-1,(a0)
move.b	#-1,1(a0)
rts

;ERROR!!!


SeekPageRight_NoCommand:
	dbf	d6,SeekPageRight_Xloop
SeekPageRight_NextLine:
;	move.w	$6(a5),$180(a5)
	dbf	d7,SeekPageRight_Yloop

	rts


WaitNextFrame:
	move.w	#0,VBI_Flag
WaitNextFrame_Loop:
	tst.w	VBI_Flag
	beq	WaitNextFrame_Loop
	rts

sleep:	dc.w	0
error:	dc.l	0
look1:	dc.l	-1
look2:	dc.l	-1

NextModule:	dc.l	0

Set_Module1:
	move.l	#Module1,NextModule
	bra	Set_ModuleX

Set_Module2:
	move.l	#Module2,NextModule
	bra	Set_ModuleX


Set_ModuleX:
	move.w	#-1,P60_fadestep

waitmusicout:
	tst.w	P60_master
	bne.b	waitmusicout

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
	move.w	#%0000000000001111,dmacon(a5)

	move.w	#64,p60_master

	lea	playercode,a0
	lea	player,a1
	move.w	#(playerend-player)/4-1,d7
playercopy:
	move.l	(a0)+,(a1)+
	dbf	d7,playercopy

	lea	ModuleX,a0
	move.l	NextModule(pc),a1
	movem.l	d0-a6,-(a7)
	jsr	STCdecrunch
	movem.l	(a7)+,d0-a6


	lea	ModuleX,a0
	sub.l	a1,a1
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
;	bset.b	#7,7(a0)
	jsr	P60_Init
	lea	$dff000,a5

	move.w	#0,Button_F_Skip
	move.w	#0,Click_F_Skip
	move.w	#0,MainInputRK_F_Skip

	rts


;------------
P60_fadestep:	dc.w	0
P60_fader:
	lea	P60_fadestep(pc),a0
	move.w	(a0),d0
	beq.b	P60_fader_skip

	lea	p60_master,a1
	add.w	(a1),d0
	move.w	d0,(a1)

	beq.b	P60_fader_fin
	cmp.w	#64,d0
	beq.b	P60_fader_fin

P60_fader_skip:
	rts

P60_fader_fin:
	move.w	#0,(a0)
	rts
;----------



VBI_Flag:	dc.w	0

VBI_Iris:
	move.l	#endoflist,spr0pth(a5)
	move.l	#endoflist,spr1pth(a5)
	move.l	#endoflist,spr2pth(a5)
	move.l	#endoflist,spr3pth(a5)
	move.l	#endoflist,spr4pth(a5)
	move.l	#endoflist,spr5pth(a5)
	move.l	#endoflist,spr6pth(a5)
	move.l	#endoflist,spr7pth(a5)

	bsr	Fader2_Real

;VBIIris_skip:
	bsr	Commander
	move.w	#1,VBI_Flag
	rts

VBI_Title:
	move.l	#endoflist,spr0pth(a5)
	move.l	#endoflist,spr1pth(a5)
	move.l	#endoflist,spr2pth(a5)
	move.l	#endoflist,spr3pth(a5)
	move.l	#endoflist,spr4pth(a5)
	move.l	#endoflist,spr5pth(a5)
	move.l	#endoflist,spr6pth(a5)
	move.l	#endoflist,spr7pth(a5)
	bsr	Fader2_Real
	jsr	Title_Jaul

	move.l	Main_Copperlist(pc),a0
	lea	Copperlist,a1
	move.l	a1,(a0)

;VBITitle_skip:
	bsr	Commander
	move.w	#1,VBI_Flag
	rts

VBI:
	move.w	screen_scrolloffsetadd(pc),d0
	beq	VBI_noscroll
	lea	screen_scrolloffset(pc),a0
	move.l	(a0),d1
	add.w	d0,d1
	beq	VBI_stopscroll
	cmp.w	#80,d1
	beq	VBI_stopscroll
	cmp.w	#160,d1
	bne	VBI_nostopscroll
VBI_stopscroll:
	move.w	#0,-2(a0)
VBI_nostopscroll:
	move.l	d1,(a0)
VBI_noscroll:

;-------
	move.l	#MouseSprite0,spr0pth(a5)
	move.l	#MouseSprite1,spr1pth(a5)
	move.l	#endoflist,spr2pth(a5)
	move.l	#endoflist,spr3pth(a5)
	move.l	#endoflist,spr4pth(a5)
	move.l	#endoflist,spr5pth(a5)
	move.l	#endoflist,spr6pth(a5)
	move.l	#endoflist,spr7pth(a5)
;-------

;-;tst.w	click_f_skip
;-;bne	vbi_skip

bsr	Sprite0Calc
bsr	coppercopy
bsr	Screen2_Jaul


jsr	Main_Input



;bsr	snail
bsr	Button

	bsr.w	P60_fader

ifne	showtrace
bsr	trace
endif

bsr	Click

VBI_skip:
	move.w	#1,VBI_Flag
rts



;------------------------
include	"data/Fader2/Calc1.2.i"
include	"data/Fader2/Makegrey1.1.i"

Fader2_Colquant_Iris=32			;number of colours in this calculation
Fader2_Tablequant_Iris=1;	maximal number of colours in program!!
Fader2_Table_Iris:	dcb.w	Fader2_Tablequant_Iris*Fader2_Colquant_Iris*16
Fader2_Tableend_Iris:

Fader2_Iris:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_Iris,d7	;number of colours

	lea	col_black,a0		;colour source
	lea	col_Iris,a1		;colour dest
	lea	fader2_table_Iris,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr	Fader2_calc
rts


Fader2Start_Iris:
	move.w	#Fader2_Colquant_Iris,fader2_quant
	move.w	#fader2_Tablequant_Iris*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Iris,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Iris,Fader2_pos	;...fade backward
rts
;------------------------


Fader2_Colquant_Title=32			;number of colours in this calculation
Fader2_Tablequant_Title=1;	maximal number of colours in program!!
Fader2_Table_Title:	dcb.w	Fader2_Tablequant_Title*Fader2_Colquant_Title*16
Fader2_Tableend_Title:

Fader2_Title:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_Title,d7	;number of colours


	lea	col_black,a0		;colour source
	lea	col_Title,a1		;colour dest
	lea	fader2_table_Title,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr	Fader2_calc

;	lea	col_Title,a1		;colour dest
;	moveq	#%101010,d1		;RGB filter
;	bsr	fader2_calc
rts


Fader2Start_Title:
	move.w	#Fader2_Colquant_Title,fader2_quant
	move.w	#fader2_Tablequant_Title*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Title,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Title,Fader2_pos	;...fade backward
rts


Fader2_real:
	tst.w	Fader2_step			;fading finished?
	beq	Fader2_skip			;yes-->exit

	subq.w	#1,Fader2_slpcount		;fader sleeping?
	bne	Fader2_skip			;yes-->exit
	move.w	Fader2_sleep,Fader2_slpcount	;new sleepcounter
	subq.w	#1,Fader2_step
	move.w	Fader2_quant(pc),d0
	move.w	d0,d1
	add.w	d1,d1
	move.l	Fader2_pos(pc),a0
	move.l	a0,a1

	tst.w	Fader2_direct
	bpl	Fader2_forward
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


Col_Black:	dcb.w	32,0


Click_F_Skip:		dc.w	0
Click_F_Release:	dc.w	0
Click:
	move.w	Data_Input(pc),d0
	btst.l	#B_Input_But1,d0
	beq	Click_Released
	tst.w	Click_F_Release
	bne	Click_Skip

	tst.w	Click_F_Skip
	bne	Click_Skip

;	move.w	ButtonCode(pc),d0
	move.l	ActiveButton(pc),d0
	beq	Click_NoButton
	move.l	d0,a0
	bsr	Button_OffSkip
	move.w	14(a0),d0
	lsr.w	#8,d0
	move.w	16(a0),d1	;code
	lea	Button_CodeTable,a0
	subq.w	#1,d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a0,d1.w),a0
;	move.l	d0,a0
;	move.w	ButtonData(pc),d0
;;;	move.w	#1,Button_F_Skip
	jmp	(a0)

Click_NoButton:
	move.w	SpriteX(pc),d0
	move.w	SpriteY(pc),d1
	lea	Gadgets,a0
Click_Loop:
	move.w	(a0)+,d2	;x1
	bmi	Click_Skip
	move.w	(a0)+,d3	;y1
	addq.l	#8,a0
	cmp.w	d2,d0
	blt	Click_Loop
	cmp.w	d3,d1
	blt	Click_Loop
	move.w	-8(a0),d2
	cmp.w	d2,d0
	bhi	Click_Loop
	move.w	-6(a0),d3
	cmp.w	d3,d1
	bhi	Click_Loop
	move.l	-(a0),a0
	move.w	#1,Click_F_Release
	jsr	(a0)
	rts

Click_Released:
	move.w	#0,Click_F_Release
	rts
Click_Skip:
	rts


snail:
	move.l	#1700,d0
snail_loop:
	sub.l	#1,d0
	bne	snail_loop
	rts

trace:
	lea	miracle,a0
	lea	font1+120*9,a1

moveq	#0,d0

;mouseX
	move.w	spritex(pc),d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber

	addq.l	#1,a0

;mouseY
	move.w	spritey(pc),d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber

	lea	-7+4*80*9(a0),a0

;articles
	move.w	Articles,d1
	subq.w	#1,d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber

	addq.l	#1,a0

;article screen (actual)
	move.w	Article_Screen,d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber

	lea	-7+4*80*9(a0),a0

;article pagequant
	move.w	Article_Pagequant(pc),d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber

	addq.l	#1,a0

;page
	move.w	Article_Page(pc),d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber
	lea	-7+4*80*9(a0),a0


;keycode
	moveq	#0,d1
	move.b	Key(pc),d1

	move.w	d1,d0
	divu.w	#100,d0
	bsr	drawnumber
	mulu.w	#100,d0
	sub.w	d0,d1

	move.w	d1,d0
	divu.w	#10,d0
	bsr	drawnumber
	mulu.w	#10,d0
	sub.w	d0,d1

	move.w	d1,d0
	bsr	drawnumber


rts


drawnumber:
	move.l	d0,-(a7)
	mulu	#9,d0
	lea	(a1,d0.w),a2
	moveq	#8,d7
mousepos_charloop:
	move.b	(a2)+,d0
	move.b	d0,0*80(a0)
	move.b	d0,1*80(a0)
	move.b	d0,2*80(a0)
	move.b	d0,3*80(a0)
	lea	4*80(a0),a0
	dbf	d7,mousepos_charloop
	lea	1-4*80*9(a0),a0
	move.l	(a7)+,d0
	rts



Screen_CLS:
	lea	Screen,a0
	move.l	#4*(18*9)*80*3/4,d7
	moveq	#0,d0
ScreenCLS_Loop:
	move.l	d0,(a0)+
	dbf	d7,ScreenCLS_Loop
rts


Screen1_CLS:
	lea	Screen,a0
	bra	Screenx_CLS
	;rts

Screen2_CLS:
	lea	Screen+80,a0
	bra	Screenx_CLS
	;rts

Screen3_CLS:
	lea	Screen+160,a0
	bra	Screenx_CLS
	;rts

Screenx_CLS:
	move.l	#4*(18*9)-1,d7
	moveq	#0,d0

ScreenxCLS_Loop2:
	moveq	#(80/4)-1,d6
ScreenxCLS_Loop1:
	move.l	d0,(a0)+
	dbf	d6,ScreenxCLS_Loop1
	lea	160(a0),a0
	dbf	d7,ScreenxCLS_Loop2
	rts

Screen_BufferCopy:
	movem.l	d0-a6,-(a7)
	lea	Screen,a0
	add.l	d0,a0	;screen offset (0-1-2)
	lea	WriteBuffer,a1

	move.l	#4*(18*9)/4-1,d7

ScreenBufferCopy_Loop2:
;	moveq	#(80/4)-1,d6
;ScreenBufferCopy_Loop1:
;	move.l	(a1)+,(a0)+
;	dbf	d6,ScreenBufferCopy_Loop1
;	lea	160(a0),a0


	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,(a0)
	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,40(a0)

	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*1(a0)
	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*1+40(a0)

	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*2(a0)
	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*2+40(a0)

	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*3(a0)
	movem.l	(a1)+,d0-d6/a2-a4
	movem.l	d0-d6/a2-a4,240*3+40(a0)


	lea	240*4(a0),a0
	dbf	d7,ScreenBufferCopy_Loop2

	movem.l	(a7)+,d0-a6
	rts

Screen_BufferCls:
	lea	WriteBuffer,a1

	moveq	#0,d0
	move.l	#4*(18*9)-1,d7
ScreenBufferCls_Loop2:
	moveq	#(80/4)-1,d6
ScreenBufferCls_Loop1:
	move.l	d0,(a1)+
	dbf	d6,ScreenBufferCls_Loop1
	dbf	d7,ScreenBufferCls_Loop2
	rts

Screen_CopyLeft:
	lea	Screen,a0
	move.l	#4*(18*9)-1,d7
ScreenCopyLeft_Loop2:
	moveq	#(160/4)-1,d6
	lea	80(a0),a1
ScreenCopyLeft_Loop1:
	move.l	(a1)+,(a0)+
	dbf	d6,ScreenCopyLeft_Loop1
	lea	80(a0),a0
	dbf	d7,ScreenCopyLeft_Loop2
	rts

Screen_CopyRight:
	lea	Screen+240,a0
	move.l	#4*(18*9)-1,d7
ScreenCopyRight_Loop2:
	moveq	#(160/4)-1,d6
	lea	-80(a0),a1
ScreenCopyRight_Loop1:
	move.l	-(a1),-(a0)
	dbf	d6,ScreenCopyRight_Loop1
	lea	240+160(a0),a0
	dbf	d7,ScreenCopyRight_Loop2
	rts


Screen_StartArticle:
	move.w	#0,Article_Page
	move.w	#0,Article_PageQuant

	move.l	#Stream,Streampos

	bsr	Screen_BufferCls

ScreenStartArticle_JaulWait:
	tst.w	Screen2Jaul_F_Skip
	beq	ScreenStartArticle_JaulWait

	bsr	Screen1_CLS
	move.l	#0,screen_scrolloffset
	bsr	WaitNextFrame
;	bsr	Screen2_CLS
	bsr	writepage
	moveq	#80,d0
	bsr	Screen_BufferCopy
	bsr	Screen_BufferCls
	move.w	#2,Screen_ScrolloffsetAdd
	bsr	Screen3_CLS
	bsr	writepage
	move.l	#160,d0
	bsr	Screen_BufferCopy
	bsr	Screen_BufferCls

	bsr	Article_Pagecount
	bsr	CopyButtonData

ScreenStartArticle_WaitScroll:
	tst.w	Screen_ScrolloffsetAdd
	bne	ScreenStartArticle_WaitScroll
	rts

flash:
	move.l	d7,-(a7)
	move.l	#20000,d7
flashloop:
	move.w	#$0f00,$180(a5)
	move.w	#$0000,$180(a5)
	subq.l	#1,d7
	bne	flashloop
	move.l	(a7)+,d7
	rts

testcode:	rts


Screen2Jaul_F_Skip:	dc.w	1
Screen2Jaul_F_nofin:	dc.w	0
Screen2_Jaul:
movem.l	d0-a6,-(a7)
	tst.w	Screen2Jaul_F_Skip
	bne	Screen2Jaul_Skip
	move.w	#0,Screen2Jaul_F_nofin
	lea	Screen,a0
	moveq	#0,d1
	move.l	d1,d2
	move.l	d1,d3
	move.l	d1,d4
	move.l	d1,d5
	move.l	d1,d6
	move.l	d1,a3
	move.l	d1,a4
	move.l	d1,a5
	move.l	d1,a6

	lea	JaulTable,a1

	moveq	#18-1,d7
Screen2Jaul_Loop:
	move.w	(a1),d0
	addq.w	#1,d0
	move.w	d0,(a1)
	bmi	Screen2Jaul_NextLine
	cmp.w	#8,d0
	bne	Screen2Jaul_NoLineFin
	move.w	#-1000,(a1)

Screen2Jaul_NoLineFin:

	move.w	#1,Screen2Jaul_F_nofin
	move.l	a0,a2
	add.l	2(a1),a2
	sub.l	#4*240,2(a1)

	lea	-80(a2),a2
	movem.l	d1-d6/a3-a6,-(a2)
	movem.l	d1-d6/a3-a6,-(a2)
	lea	80-240(a2),a2
	movem.l	d1-d6/a3-a6,-(a2)
	movem.l	d1-d6/a3-a6,-(a2)
	lea	80-240(a2),a2
	movem.l	d1-d6/a3-a6,-(a2)
	movem.l	d1-d6/a3-a6,-(a2)
	lea	80-240(a2),a2
	movem.l	d1-d6/a3-a6,-(a2)
	movem.l	d1-d6/a3-a6,-(a2)

	
Screen2Jaul_NextLine:
	addq.w	#6,a1
	dbf	d7,Screen2Jaul_Loop
	lea	$dff000,a5
	tst.w	Screen2Jaul_F_nofin
	bne	Screen2Jaul_Skip
	move.w	#1,Screen2Jaul_F_Skip
	lea	JaulTable,a0
	moveq	#18-1,d7
	moveq	#-1,d0
	move.l	#18*9*4*240,d1
Screen2Jaul_PrepNextLoop:
	move.w	d0,(a0)+
	move.l	d1,(a0)+
	subq.w	#1,d0
	sub.l	#9*4*240,d1
	dbf	d7,Screen2Jaul_PrepNextLoop

Screen2Jaul_Skip:
movem.l	(a7)+,d0-a6
	rts

JaulTable:
value1:	set	-1
value2:	set	18*9*4*240
rept	18
dc.w	value1
dc.l	value2
value1:	set	value1-1
value2:	set	value2-(9*4*240)
endr





TitleJaul_F_Skip:	dc.w	1
TitleJaul_F_nofin:	dc.w	0
Title_Jaul:
movem.l	d0-a6,-(a7)
	tst.w	TitleJaul_F_Skip
	bne	TitleJaul_Skip
	move.w	#0,TitleJaul_F_nofin

	lea	TitleJaulTable,a1

	moveq	#16-1,d7
TitleJaul_Loop:
	move.w	(a1),d0
	addq.w	#1,d0
	move.w	d0,(a1)
	bmi	TitleJaul_NextLine2
	cmp.w	#15,d0
	bne	TitleJaul_NoLineFin
	move.w	#-1000,(a1)

TitleJaul_NoLineFin:

	move.w	#1,TitleJaul_F_nofin

	lea	Title,a0
	add.l	2(a1),a0
	sub.l	#5*40,2(a1)

	lea	TitleMasc,a2
	add.l	6(a1),a2
	sub.l	#40,6(a1)


	moveq	#10-1,d6
TitleJaul_LineLoop:
	move.l	-(a2),d1
	not.l	d1

	and.l	d1,-(a0)
	and.l	d1,-1*40(a0)
	and.l	d1,-2*40(a0)
	and.l	d1,-3*40(a0)
	and.l	d1,-4*40(a0)

	dbf	d6,TitleJaul_LineLoop
	lea	-4*40(a0),a0


TitleJaul_NextLine2:
	move.w	10(a1),d0
	addq.w	#1,d0
	move.w	d0,10(a1)
	bmi	TitleJaul_NextLine
	cmp.w	#15,d0
	bne	TitleJaul_NoLineFin2
	move.w	#-1000,10(a1)

TitleJaul_NoLineFin2:

	move.w	#1,TitleJaul_F_nofin

	lea	Title,a0
	add.l	12(a1),a0
	add.l	#5*40,12(a1)

	lea	TitleMasc,a2
	add.l	16(a1),a2
	add.l	#40,16(a1)


	moveq	#10-1,d6
TitleJaul_LineLoop2:
	move.l	(a2)+,d1
;	not.l	d1

	and.l	d1,1*40(a0)
	and.l	d1,2*40(a0)
	and.l	d1,3*40(a0)
	and.l	d1,4*40(a0)
	and.l	d1,(a0)+

	dbf	d6,TitleJaul_LineLoop2
	lea	4*40(a0),a0


	
TitleJaul_NextLine:
	lea	20(a1),a1
	dbf	d7,TitleJaul_Loop
	lea	$dff000,a5
	tst.w	TitleJaul_F_nofin
	bne	TitleJaul_Skip
	move.w	#1,TitleJaul_F_Skip
	lea	TitleJaulTable,a0
	moveq	#16-1,d7
	moveq	#-1,d0
	move.l	#16*16*5*40,d1
	move.l	#16*16*40,d2
TitleJaul_PrepNextLoop:
	move.w	d0,(a0)+
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	subq.w	#1,d0
	sub.l	#16*5*40,d1
	sub.l	#16*40,d2
	dbf	d7,TitleJaul_PrepNextLoop

TitleJaul_Skip:
movem.l	(a7)+,d0-a6
	rts

TitleJaulTable:
value1:	set	-1
value2:	set	16*16*5*40
value3:	set	16*16*40
value4:	set	-1
value5:	set	0*16*5*40
value6:	set	0*16*40
rept	16
dc.w	value1
dc.l	value2
dc.l	value3
dc.w	value4
dc.l	value5
dc.l	value6
value1:	set	value1-1
value2:	set	value2-(16*5*40)
value3:	set	value3-(16*40)
value4:	set	value4-1
value5:	set	value5+(16*5*40)
value6:	set	value6+(16*40)
endr

flash2:
	move.l	d7,-(a7)
	move.l	#20000,d7
flash2loop:
	move.w	#$00f0,$180(a5)
	move.w	#$0000,$180(a5)
	subq.l	#1,d7
	bne	flash2loop
	move.l	(a7)+,d7
	rts
flash4:
	move.l	d7,-(a7)
	move.l	#80,d7
flash4loop:
	move.w	#$00ff,$180(a5)
	move.w	#$0000,$180(a5)
	subq.l	#1,d7
	bne	flash4loop
	move.l	(a7)+,d7
	rts

;----------------------------------------------------------
JoyMoveQuant:		dc.w	5
Data_Joystic1raw:	dc.w	0 ;|joystic raw
Data_Joystic1rawdec:	dc.w	0 ;|joystic raw decoded
Data_Joystic:		dc.w	0 ;|.......-Button.-Down-Up-Right-Left
Data_Mouse:		dc.w	0 ;|Button2-Button1-Down-Up-Right-Left
Data_Key:		dc.w	0 ;|ESC....-RETURN.-Down-Up-Right-Left
Data_Input:		dc.w	0 ;|
Data_Work:		dc.w	0 ;|
Data_MoveQuantX:	dc.w	0
Data_MoveQuantY:	dc.w	0
B_Input_Left=0
B_Input_Right=1
B_Input_Up=2
B_Input_Down=3
B_Input_But1=4
B_Input_But2=5

F_Input_ReadKeyboard=1
F_Input_ReadPort1=1
F_Input_ReadPort2=1

Main_Input:
ifne	F_Input_ReadKeyboard=1
bsr	MainInput_ReadKeyboard
endif

ifne	F_Input_ReadPort1=1
bsr	MainInput_ReadPort1
endif

ifne	F_Input_ReadPort2=1
bsr	MainInput_ReadPort2
endif

lea	Data_Joystic(pc),a0
move.w	(a0)+,d0
or.w	(a0)+,d0
or.w	(a0)+,d0
move.w	d0,(a0)+

rts

MainInputRK_f_Skip:	dc.w	0

MainInput_ReadKeyboard:
	move.b	$bfed01,d0		;irq-interrupt-control
	btst.l	#3,d0			;bit 3=serial data full
	beq.w	MainInput_RK_Skip	;not full, irq not from keyboard!

	move.b	$bfec01,d0		;store keycode
	and.w	#$00ff,d0		;kill hibyte of this word
	not.b	d0			;do the keycode...
	ror.b	#1,d0			;...decoding
	move.b	d0,key			;store decoded key
	bset.b	#6,$bfee01		;serial port to output-mode(hehe)
	move.b	#%11111111,$bfec01	;handshake-signal low
	bsr.w	waitawhile
	move.b	#%00000000,$bfec01	;handshake-signal hi
	bclr.b	#6,$bfee01		;serial port to input-mode


	tst.w	MainInputRK_f_Skip
	bne	MainInput_RK_Skip

	moveq	#0,d0
	move.b	key(pc),d0
	lea	Key_CodeTable-6(pc),a0
MainInput_RK_Check:
	addq.w	#6,a0
	move.w	(a0),d1
	bmi	MainInput_RK_Skip
	cmp.w	d1,d0
	bne	MainInput_RK_Check
	move.l	2(a0),a0
	move.l	a0,-(a7)

	move.l	ActiveButton(pc),d0
	beq	MainInput_NoButton
	move.l	d0,a0
	bsr	Button_OffSkip
MainInput_NoButton:

	move.l	(a7)+,a0
	jmp	(a0)

MainInput_RK_Skip:
rts

Key:	dc.w	0

Key_CodeTable:
	dc.w	79	;79/207/CSR left
	dc.l	Action_Left

	dc.w	77	;77/205/CSR down
	dc.l	Action_Down

	dc.w	76	;76/204/CSR up
	dc.l	Action_Up

	dc.w	78	;78/206/CSR right
	dc.l	Action_Right

	dc.w	16	;16/144/q
	dc.l	Action_Quit

	dc.w	69	;69/197/ESC
	dc.l	Action_Quit

	dc.w	23	;23/197/i
	dc.l	Action_Index

	dc.w	80	;80/197/F1
	dc.l	TestCode


dc.w	-1	;end of keys
;----------
waitawhile:
	moveq	#3,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
	cmp.b	$dff007,d6
	beq.b	waitawhileloop2
	dbf	d7,waitawhileloop1
	rts
;----------

MouseRead_LastX:	dc.w	0
MouseRead_LastY:	dc.w	0
MainInput_ReadPort1:	;mouse-read
	moveq	#0,d2
	move.w	d2,Data_MoveQuantX
	move.w	d2,Data_MoveQuantY

	lea	MouseRead_LastX(pc),a0
;bra	skip2
	moveq	#0,d3
	move.b	(a0),d0		;last value
	move.b	$a(a5),d1	;new value

	sub.b	d1,d0		
	roxr.b	#1,d3
	bpl.b	mouse_positiv
	neg.b	d0		;delta values (move length)
mouse_positiv:
	move.b	d1,(a0)		;mousemem
	cmp.b	#$00,d0		;delta lo
	ble.b	MouseRead_NotVertMoved	;moved, but not enough
	cmp.b	#$50,d0		;delta hi
	bge.b	MouseRead_NotVertMoved	;(overflow)
	tst.b	d3
	beq.b	mouse_up

;mouse_down:
	bset.l	#B_Input_Down,d2
	bra	MouseRead_VertMoved
mouse_up:
	bset.l	#B_Input_Up,d2

MouseRead_VertMoved:
;	lsr.w	#4,d0
	move.b	d0,Data_MoveQuantY+1


MouseRead_NotVertMoved:
;bra	skip
skip2:
	moveq	#0,d3
	move.b	2(a0),d0	;last value
	move.b	$b(a5),d1	;new value

	sub.b	d1,d0		
	roxr.b	#1,d3
	bpl.b	mouse_positivX
	neg.b	d0		;delta values (move length)
mouse_positivX:
	move.b	d1,2(a0)		;mousemem
	cmp.b	#$00,d0		;delta lo
	ble.b	MouseRead_NotHorMoved	;moved, but not enough
	cmp.b	#$50,d0		;delta hi
	bge.b	MouseRead_NotHorMoved	;(overflow)
	tst.b	d3
	beq.b	mouse_left

;mouse_right:
	bset.l	#B_Input_Right,d2
	bra	MouseRead_HorMoved
mouse_left:
	bset.l	#B_Input_Left,d2

MouseRead_HorMoved:
;	lsr.w	#4,d0
	move.b	d0,Data_MoveQuantX+1


MouseRead_NotHorMoved:



skip:
	btst.b	#6,ciaapra
	bne	MouseRead_NoLeftButton
	bset.l	#B_Input_But1,d2
MouseRead_NoLeftButton:
	btst.b	#10,$dff016
	bne	MouseRead_NoRightButton
	bset.l	#B_Input_But2,d2
MouseRead_NoRightButton:


	move.w	d2,Data_Mouse


	rts



MainInput_ReadPort2:	;joystic-read
moveq	#0,d2
lea	Data_Joystic1raw(pc),a0
move.w	$c(a5),d0
move.w	d0,(a0)+	;joysticraw
btst.l	#9,d0
beq	joyread_noleft
bset.l	#B_Input_Left,d2
joyread_noleft:
btst.l	#1,d0
beq	joyread_noright
bset.l	#B_Input_Right,d2
joyread_noright:
move.w	d0,d1
lsr.w	#1,d1
eor.w	d0,d1
move.w	d1,(a0)+	;joysticrawdec

btst.l	#0,d1
beq	joyread_noback
bset.l	#B_Input_Down,d2
joyread_noback:
btst.l	#8,d1
beq	joyread_noforw
bset.l	#B_Input_Up,d2
joyread_noforw:

tst.w	d2
beq	joyread_joynotmoved
move.w	joymovequant,d0
move.w	d0,Data_MoveQuantX
move.w	d0,Data_MoveQuantY
joyread_joynotmoved:

	btst.b	#7,ciaapra
	bne	JoyRead_NoButton
	bset.l	#B_Input_But1,d2
JoyRead_NoButton:
move.w	d2,(a0)+

rts



;speed1:		dc.w	80*4*1
;speed2:		dc.w	1

;upswap=80*4*9*23
;doswap=80*4*9*0

;upset=80*4*9*0
;doset=80*4*9*23



SpriteX:	dc.w	0
SpriteY:	dc.w	0

Sprite0Calc:
	lea	spritex(pc),a0
	move.w	(a0),d1
	move.w	2(a0),d2

	move.w	Data_Input(pc),d0
	btst.l	#B_Input_Left,d0
	beq	Sprite0Calc_NoLeft
	sub.w	Data_MoveQuantX(pc),d1
	bpl	Sprite0Calc_NoLeft	;mo left border
	moveq	#0,d1

Sprite0Calc_NoLeft:
	btst.l	#B_Input_Right,d0
	beq	Sprite0Calc_NoRight
	add.w	Data_MoveQuantX(pc),d1
	cmp.w	#319,d1
	ble	Sprite0Calc_NoRight	;no right border
	move.w	#319,d1

Sprite0Calc_NoRight:
	btst.l	#B_Input_Up,d0
	beq	Sprite0Calc_NoUp
	sub.w	Data_MoveQuantY(pc),d2
	bpl	Sprite0Calc_NoUp		;no top border
	moveq	#0,d2

Sprite0Calc_NoUp:
	btst.l	#B_Input_Down,d0
	beq	Sprite0Calc_NoDown
	add.w	Data_MoveQuantY(pc),d2
	cmp.w	#255,d2
	ble	Sprite0Calc_NoDown	;no bottom border
	move.w	#255,d2

Sprite0Calc_NoDown:

	move.w	d1,(a0)+
	move.w	d2,(a0)

;	move.w	spritey(pc),d0
;	move.w	spritex(pc),d1
	move.w	d2,d0

;	lsr.w	#1,d1
	moveq	#0,d2
add.w	#$29,d0
add.w	#$80,d1
	roxl.w	#8,d0
;	lsl.w	#8,d0
	roxl.w	#1,d2	;E8
	move.w	d2,d3
	roxr.w	#1,d3
	roxl.w	#1,d2	;E8L8 (L8=E8)

	add.w	d0,d2
	add.w	#$1000,d2
	bcc	Sprite0Calc_noL8
	bset.l	#0,d2
Sprite0Calc_noL8:
	roxr.w	#1,d1
	roxl.b	#1,d2
	move.b	d1,d0

swap	d0
move.w	d2,d0

move.l	d0,MouseSprite0
bset.l	#7,d0
move.l	d0,MouseSprite1

rts
;MouseSprite0:
;	dc.w	$505a,$6000
;	dc.w	$505a,$6000+2^7


screen_scrolloffsetadd:	dc.w	0	;|
screen_scrolloffset:	dc.l	0	;|

;Coppercopy_Iris:
	lea	copperlist,a0
	move.l	#diwstrt*$10000+$2981,(a0)+
	move.l	#diwstop*$10000+$29c1,(a0)+
	move.l	#ddfstrt*$10000+$0038,(a0)+
	move.l	#ddfstop*$10000+$00d0,(a0)+

	move.l	#bpl1mod*$10000+$00a0,(a0)+
	move.l	#bpl2mod*$10000+$00a0,(a0)+
	move.l	#bplcon1*$10000+$0000,(a0)+
	move.l	#bplcon2*$10000+$0024,(a0)+
	move.l	#bplcon0*$10000+%0101001000000000,(a0)+

value:	set	bpl1pth
	move.l	#Iris,d0
rept	5
	move.w	#value+2,(a0)+	;bplxptl
	move.w	d0,(a0)+
	swap	d0
	move.w	#value,(a0)+	;bplxpth
	move.w	d0,(a0)+
	swap	d0
	add.l	#40,d0
value:	set	value+4
endr

	move.l	#-2,(a0)
rts

Coppercopy_Title:
	lea	copperlist,a0
	move.l	#diwstrt*$10000+$2981,(a0)+
	move.l	#diwstop*$10000+$29c1,(a0)+
	move.l	#ddfstrt*$10000+$0038,(a0)+
	move.l	#ddfstop*$10000+$00d0,(a0)+

	move.l	#bpl1mod*$10000+$00a0,(a0)+
	move.l	#bpl2mod*$10000+$00a0,(a0)+
	move.l	#bplcon1*$10000+$0000,(a0)+
	move.l	#bplcon2*$10000+$0024,(a0)+
	move.l	#bplcon0*$10000+%0101001000000000,(a0)+

value:	set	bpl1pth
	move.l	#title,d0
rept	5
	move.w	#value+2,(a0)+	;bplxptl
	move.w	d0,(a0)+
	swap	d0
	move.w	#value,(a0)+	;bplxpth
	move.w	d0,(a0)+
	swap	d0
	add.l	#40,d0
value:	set	value+4
endr

	move.l	#-2,(a0)
rts


PanelScrollAdd:	dc.w	80*4		;|
PanelScrollPos:	dc.w	0		;|


Coppercopy:
	lea	PanelScrollPos(pc),a0
	move.w	-2(a0),d0
	beq	Panel_noscroll
	move.w	(a0),d1
	add.w	d0,d1
	beq	Panel_stopscroll
	cmp.w	#80*4*45,d1
	bne	Panel_nostopscroll
Panel_stopscroll:
	move.w	#0,-2(a0)
Panel_nostopscroll:
	move.w	d1,(a0)
Panel_noscroll:



	lea	copperlist,a0
	move.l	#diwstrt*$10000+$2981,(a0)+
	move.l	#diwstop*$10000+$29c1,(a0)+
	move.l	#ddfstrt*$10000+$003c,(a0)+
	move.l	#ddfstop*$10000+$00d4,(a0)+

	move.l	#bpl1mod*$10000+$00f0,(a0)+
	move.l	#bpl2mod*$10000+$00f0,(a0)+
	move.l	#bplcon1*$10000+$0000,(a0)+
	move.l	#bplcon2*$10000+$0024,(a0)+
	move.l	#bplcon0*$10000+%1100001000000000,(a0)+

	lea	pal_miracle,a1
	move.w	#$0180,d0
	moveq	#15,d7
coppercopy_MirColSetLoop:
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d0
	dbf	d7,coppercopy_MirColSetLoop

	move.l	#miracle+80*4*45,d0
	moveq	#0,d7
	move.w	PanelScrollPos(pc),d7
	sub.l	d7,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
;---screen---
	move.l	#$5601fffe,(a0)+	;;;
;	move.l	#bplcon0*$10000+%0000001000000000,(a0)+
	bsr	Coppercopy_1bpl

	move.l	#bpl2mod*$10000+80*4*3-80,(a0)+
;	move.l	#bpl2mod*$10000+80*4-80,(a0)+

	lea	Pal_Screen,a1
	move.w	#$0180,d0
	moveq	#15,d7
coppercopy_ScrColSetLoop:
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d0
	dbf	d7,coppercopy_ScrColSetLoop

	move.l	#$5a01fffe,(a0)+
	move.l	#bplcon0*$10000+%1100001000000000,(a0)+


	move.l	#bpl1mod*$10000+80*4*3-80,(a0)+
;	move.l	#bpl1mod*$10000+80*4-80,(a0)+



	move.l	#screen,d0
	add.l	screen_scrolloffset,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#3*80,d0

	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#3*80,d0

	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#3*80,d0

	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+

;---menu---
;move.l	#$5601fffe,(a0)+	;;;
;move.l	#$01800fff,(a0)+	;;;
;move.l	#$5701fffe,(a0)+	;;;
;move.l	#$01800000,(a0)+	;;;

;move.l	#$ffe1fffe,(a0)+	;;;
;move.l	#$0101fffe,(a0)+	;;;
;move.l	#$01800fff,(a0)+	;;;
;move.l	#$0201fffe,(a0)+	;;;
;move.l	#$01800000,(a0)+	;;;

;move.l	#-2,(a0)+	;;;


	move.l	#$fbe1fffe,(a0)+
;	move.l	#bplcon0*$10000+%0000001000000000,(a0)+
	bsr	Coppercopy_1bpl

	move.l	#bpl2mod*$10000+$00f0,(a0)+

	lea	Pal_Menu,a1
	move.w	#$0180,d0
	moveq	#15,d7
coppercopy_MenColSetLoop:
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d0
	dbf	d7,coppercopy_MenColSetLoop

	move.l	#$ffe1fffe,(a0)+
	move.l	#$0101fffe,(a0)+
	move.l	#bplcon0*$10000+%1100001000000000,(a0)+


	move.l	#bpl1mod*$10000+$00f0,(a0)+
	move.l	#Menu,d0
	moveq	#0,d7
	move.w	PanelScrollPos(pc),d7
	add.l	d7,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#80,d0

	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+


	move.l	#-2,(a0)
	rts


Coppercopy_1bpl:
	move.l	#bplcon0*$10000+%0001001000000000,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#-40,(a0)+

	move.l	#EmptyScreenLine,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+

	rts


coppercopy_iris:
	lea	copperlist1,a0
	move.l	#Iris,d0
	move.l	#copperlist2,d1
	bsr.b	putlist

	lea	copperlist2,a0
	move.l	#Iris+240,d0
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


CopyButtonData:
	move.w	#1,Button_F_Skip
	movem.l	d0-a6,-(a7)
	lea	ButtonTable,a0
	moveq	#-1,d7
	move.w	d7,(a0)
	lea	Article_buttons,a1
	move.w	Article_Page,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	(a1,d0.w),d0
	beq	CopyButtonData_skip
	move.l	d0,a1

	moveq	#0,d7
	move.b	-2(a1),d7	;get buttondatalength
	subq.w	#1,d7		;-1 (command-byte)
	lsr.w	#3,d7		;/8 (8 bytes/button)
	subq.w	#1,d7		;-1 (loop)
Buttondata_copyloop:
;	move.b	(a1)+,(a0)+
	move.b	(a1)+,d0
	lsl.w	#8,d0
	move.b	(a1)+,d0	;d0=p1
	move.b	(a1)+,d1
	lsl.w	#8,d1
	move.b	(a1)+,d1	;d1=p2
;now converting p1;p2 to x1;y1;x2;y2;markp;len
	move.w	d0,d2
	divu.w	#80,d2
	swap	d2
	move.w	d2,d3	;to calc MarkP later
	move.w	d2,d5	;to calc len later
	add.w	d2,d2
	add.w	d2,d2
	ror.w	#8,d2
	move.b	d2,(a0)+	;x1
	ror.w	#8,d2
	move.b	d2,(a0)+	;x1
	swap	d2
	move.w	d2,d4	;to calc MarkP later
	mulu.w	#9,d2
	add.w	#49,d2
	ror.w	#8,d2
	move.b	d2,(a0)+	;y1
	ror.w	#8,d2
	move.b	d2,(a0)+	;y1

	move.w	d1,d2
	divu.w	#80,d2
	swap	d2
	move.w	d2,d6	;to calc len later
	add.w	d2,d2
	add.w	d2,d2
	subq.w	#1,d2
	ror.w	#8,d2
	move.b	d2,(a0)+	;x2
	ror.w	#8,d2
	move.b	d2,(a0)+	;x2
	swap	d2
	mulu.w	#9,d2
	add.w	#49-1,d2
	ror.w	#8,d2
	move.b	d2,(a0)+	;y2
	ror.w	#8,d2
	move.b	d2,(a0)+	;y2

	subq.w	#1,d3
	ext.l	d3
	mulu.w	#4*240*9,d4
	add.l	d3,d4
	rol.l	#8,d4
	move.b	d4,(a0)+	;MarkP
	rol.l	#8,d4
	move.b	d4,(a0)+	;MarkP
	rol.l	#8,d4
	move.b	d4,(a0)+	;MarkP
	rol.l	#8,d4
	move.b	d4,(a0)+	;MarkP

	sub.w	d5,d6
	addq.w	#1+2-1-1,d6
	ror.w	#8,d6
	move.b	d6,(a0)+	;Len
	ror.w	#8,d6
	move.b	d6,(a0)+	;Len

	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+	;data
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+	;code


	dbf	d7,Buttondata_copyloop
	move.w	#-1,(a0)	;endmark 
	move.w	#0,Button_F_Skip
CopyButtonData_skip:
	movem.l	(a7)+,d0-a6
	rts



Streampos:	dc.l	stream

Write_Font:	dc.l	Font1_CodeTable
Write_Pen:	dc.w	0*4
writepage:
;	movem.l	d0-a6,-(a7)
;	bsr	Screen_BufferCls
;	movem.l	(a7)+,d0-a6

	move.l	Write_Font(pc),a6
	add.w	Write_Pen(pc),a6
	move.l	(a6),a6

;	lea	screen+3*4*2*80,a0
;	lea	screen,a0
;	add.l	d0,a0	;screen offset (0-1-2)

	lea	WriteBuffer,a0
	


;	lea	stream,a1
	move.l	Streampos(pc),a1
	lea	font1,a2

PageX=80
PageY=18

	moveq	#PageY-1,d5
writepage_drawyloop:

	moveq	#PageX-1,d6
writepage_drawxloop:

	moveq	#0,d0
	move.b	(a1)+,d0
	cmp.b	#-1,d0
	beq	writepage_gotcode

	jsr	(a6)	;write char

writepage_gotcurscode:

	dbf	d6,writepage_drawxloop
;	lea	3*4*9*80-80(a0),a0
	lea	1*4*9*80-80(a0),a0
	dbf	d5,writepage_drawyloop
	move.l	a1,Streampos
	rts

Writepage_gotcode:
	addq.l	#1,a1		;override codesequenz-length
	move.b	(a1)+,d0	;get command
	cmp.b	#-2,d0
	bne	nocoden2

	move.b	(a1)+,d0	;get font# and col#
	move.w	d0,d1
	and.b	#%00001111,d1	;kill color-bits
	lsl.w	#3,d1		;*8 = FontTable Offset
	lea	Font_FontsTable(pc),a6	;base fontstable
	move.l	4(a6,d1.w),a2	;base choosed fontdata
	move.l	(a6,d1.w),a6	;base choosed fontcode
	move.l	a6,Write_Font
	

	and.b	#%11110000,d0
	lsr.w	#2,d0
	move.w	d0,Write_Pen

	addq.l	#1,a1	;override font-style
	addq.l	#2,a1	;override codesequenz-length+code (-1)

	move.l	Write_Font(pc),a6
	add.w	Write_Pen(pc),a6
	move.l	(a6),a6

	bra	writepage_drawxloop


Nocoden2:
	cmp.b	#Streamcode_Return,d0
	bne	nocodep0
	addq.w	#1,d6
	add.w	d6,a0	;gfx curs x times left, x=chars left (this line)
	moveq	#0,d6
	bra	writepage_gotcurscode

Nocodep0:
	cmp.b	#1,d0
	bne	nocodep1
	
	addq.l	#2,a1	;override codesequenz-length+code (-1)
	addq.l	#1,a0	;gfx curs right
	bra	writepage_gotcurscode

Nocodep1:
	cmp.b	#2,d0
	bne	nocodep2
;code 2 (curs right temp) not supported yet
	addq.l	#2,a1	;override codesequenz-length+code (-1)
	addq.l	#1,a0	;gfx curs left
	bra	writepage_gotcurscode

Nocodep2:
	cmp.b	#Streamcode_Button,d0
	bne	NotCode_Button

;	move.l	a1,Write_ButtonDataPos
	moveq	#0,d0
	move.b	-2(a1),d0	;get codelength
	subq.w	#1,d0		;command-byte-length was already added
	add.w	d0,a1		;skip ButtonData

;	movem.l	d0-a6,-(a7)
;	moveq	#0,d7
;	move.b	-2(a1),d7	;code length
;	subq.w	#1,d7
;	lea	ButtonTable,a0
;Buttondata_copyloop:
;	move.b	(a1)+,(a0)+
;	dbf	Buttondata_copyloop
;	move.w	#-1,(a0)	;endmark 
;	movem.l	(a7)+,d0-a6
	bra	writepage_drawxloop

NotCode_Button:



;!!! illegal code !!!
rts

include	"data/Draw_Font1.s"
include	"data/Draw_Font2.s"


;------------------------------------------------------------------------

Font_FontsTable:
	dc.l	Font1_CodeTable
	dc.l	Font1
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2
	dc.l	Font2_CodeTable
	dc.l	Font2


Action_Left:
	move.w	#3,Button_F_Skip
	move.w	#3,Click_F_Skip
	move.w	#3,MainInputRK_F_Skip
	move.l	Main_Mastercommand(pc),a0
	lea	MoveRight,a1
	move.l	a1,(a0)
	rts

Action_Down:
	lea	Article_Screen(pc),a0
	move.w	(a0),d0
	addq.w	#1,d0
	cmp.w	Articles,d0
	beq	ActionDown_Skip
	move.w	d0,(a0)

;now test if article deleted
	lea	Articles_Table,a1
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a1
	move.l	(a1),a1
	cmp.w	#-1,(a1)
	beq	Action_Down
;if article deleted then jump article down again.
;last article MUST NEVER be deleted this way
;to delete last article simply decrease article_counter


	move.l	Main_Mastercommand(pc),a0
	lea	Article_Organize,a1
	move.l	a1,(a0)

	move.w	#0,Screen2Jaul_F_Skip

	move.w	#4,Button_F_Skip
	move.w	#4,Click_F_Skip
	move.w	#4,MainInputRK_F_Skip

ActionDown_Skip:
	rts

Action_Up:
	lea	Article_Screen(pc),a0
	move.w	(a0),d0
	subq.w	#1,d0
	bmi	ActionUp_Skip
	move.w	d0,(a0)

;now test if article deleted
	lea	Articles_Table,a1
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a1
	move.l	(a1),a1
	cmp.w	#-1,(a1)
	beq	Action_Up
;if article deleten then jump article up again.
;article 0 (index-page) MUST NEVER be deleted


	move.l	Main_Mastercommand(pc),a0
	lea	Article_Organize,a1
	move.l	a1,(a0)

	move.w	#0,Screen2Jaul_F_Skip

	move.w	#5,Button_F_Skip
	move.w	#5,Click_F_Skip
	move.w	#5,MainInputRK_F_Skip

ActionUp_Skip:
	rts

Action_Right:
	move.w	#6,Button_F_Skip
	move.w	#6,Click_F_Skip
	move.w	#6,MainInputRK_F_Skip
	move.l	Main_Mastercommand(pc),a0
	lea	MoveLeft,a1
	move.l	a1,(a0)
	rts



Button_CodeTable:
	dc.l	Set_Article



;ButtonMarkP:	dc.l	0
;ButtonMarkL:	dc.w	-1
;ButtonCode:	dc.w	0
;ButtonData:	dc.w	0

ActiveButton:	dc.l	0


ButtonTable:	dc.w	-1
;welcome
;	dc.w	56		;ButtonMarkX1:
;	dc.w	121		;ButtonMarkY1:
;	dc.w	56+4*8-1	;ButtonMarkX2:
;	dc.w	121+9-1		;ButtonMarkY2:
;	dc.l	13+8*(4*240*9)	;ButtonMarkP:
;	dc.w	10-1		;ButtonMarkL:
;	dc.w	1*256		;Button_Data:  (not used yet)
;	dc.w	1		;ButtonCode:

;credits
;	dc.w	56		;ButtonMarkX1:			 0
;	dc.w	130		;ButtonMarkY1:			 2
;	dc.w	56+4*7-1	;ButtonMarkX2:			 4
;	dc.w	130+9-1		;ButtonMarkY2:			 6
;	dc.l	13+9*(4*240*9)	;ButtonMarkP:			 8
;	dc.w	8		;ButtonMarkL:			12
;	dc.w	2*256		;Button_Data:  (not used yet)	14
;	dc.w	1		;ButtonCode:			16

;diskback
;	dc.w	44		;ButtonMarkX1:
;	dc.w	139		;ButtonMarkY1:
;	dc.w	44+4*15-1	;ButtonMarkX2:
;	dc.w	139+9-1		;ButtonMarkY2:
;	dc.l	10+10*(4*240*9)	;ButtonMarkP:
;	dc.w	16		;ButtonMarkL:
;	dc.w	3*256		;Button_Data:  (not used yet)
;	dc.w	1		;ButtonCode:
;
;;howtosupport
;	dc.w	44		;ButtonMarkX1:
;	dc.w	148		;ButtonMarkY1:
;	dc.w	44+4*14-1	;ButtonMarkX2:
;	dc.w	148+9-1		;ButtonMarkY2:
;	dc.l	10+11*(4*240*9)	;ButtonMarkP:
;	dc.w	15		;ButtonMarkL:
;	dc.w	4*256		;Button_Data:  (not used yet)
;	dc.w	1		;ButtonCode:
;
;;contactaddress
;	dc.w	40		;ButtonMarkX1:
;	dc.w	157		;ButtonMarkY1:
;	dc.w	40+4*16-1	;ButtonMarkX2:
;	dc.w	157+9-1		;ButtonMarkY2:
;	dc.l	9+12*(4*240*9)	;ButtonMarkP:
;	dc.w	17		;ButtonMarkL:
;	dc.w	5*256		;Button_Data:  (not used yet)
;	dc.w	1		;ButtonCode:

;miraclesupportbbs
;miraclegreets
;reactions
;newa-c
;newd-l
;newm-r
;newy-z


	dc.w	-1
dcb.b	32*18,0


Set_Article:
	move.w	#0,Screen2Jaul_F_Skip
;->d0: Article number
	move.w	d0,Article_Screen
	move.l	Main_Mastercommand(pc),a0
	lea	Article_Organize,a1
	move.l	a1,(a0)
	move.w	#2,Button_F_Skip
	move.w	#2,Click_F_Skip
	move.w	#2,MainInputRK_F_Skip
	rts


Button_F_Skip:	dc.w	0

Button:
	tst.w	Click_F_Skip	;;;
	bne	Button_Skip	;;;

	tst.w	Button_F_Skip
	bne	Button_Skip

	lea	ButtonTable-18(pc),a1
	move.l	ActiveButton(pc),a0
;-----------
	move.w	SpriteX(pc),d0
	move.w	SpriteY(pc),d1

Button_Loop:
	lea	18(a1),a1
	move.w	(a1),d2		;x1
	bmi	Button_OffSkip	;mouse NOT over button
	move.w	2(a1),d3	;y1
	cmp.w	d2,d0
	blt	Button_Loop
	cmp.w	d3,d1
	blt	Button_Loop
	move.w	4(a1),d2	;x2
	cmp.w	d2,d0
	bhi	Button_Loop
	move.w	6(a1),d3	;y2
	cmp.w	d3,d1
	bhi	Button_Loop
;now mouse over button...


	move.l	a0,d7
	tst.l	d7
	beq	Button_NoButBefore
	move.l	8(a1),d0	;ButtonMarkP
;	cmp.w	ButtonCode(pc),d0
	cmp.l	8(a0),d0
	beq	Button_Skip	;mouse STILL over same button

Button_NoButBefore:
	bsr	ButtonMark	;clr mark if before other button
	lea	ActiveButton(pc),a0
	move.l	a1,(a0)

;	move.l	ActiveButton(pc),a0
;	move.w	16(a1),ButtonCode
;	move.l	8(a1),ButtonMarkP
;	move.w	12(a1),ButtonMarkL
;	move.w	14(a1),ButtonData
	move.l	a1,a0
	bsr	ButtonMark	;mark new button

;-----------

	
Button_Skip:
	rts

Button_OffSkip:
	bsr	ButtonMark
;	move.w	#-1,12(a0)	;ButtonMarkL
	move.l	#0,ActiveButton
	rts



ButtonMark:
	move.l	ActiveButton(pc),d7
	beq	ButtonMark_Skip
	move.l	d7,a0

	lea	screen+80,a4
	add.l	8(a0),a4	;ButtonMarkP

	moveq	#3,d6		;planeloop
Buttonmark_Planeloop:
	move.w	12(a0),d7	;ButtonMarkL
	bmi	ButtonMark_Skip
	move.l	a4,a3
ButtonMark_TestLoop:
	tst.b	8*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	7*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	6*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	5*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	4*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	3*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	2*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	1*4*240(a3)
	bne	ButtonMark_PlaneDo
	tst.b	(a3)+
	bne	ButtonMark_PlaneDo
	dbf	d7,ButtonMark_TestLoop
	bra	ButtonMark_PlaneSkip


ButtonMark_PlaneDo:
	move.w	12(a0),d7	;ButtonMarkL
ButtonMark_Loop:
	not.b	8*4*240(a4)
	not.b	7*4*240(a4)
	not.b	6*4*240(a4)
	not.b	5*4*240(a4)
	not.b	4*4*240(a4)
	not.b	3*4*240(a4)
	not.b	2*4*240(a4)
	not.b	1*4*240(a4)
	not.b	(a4)+
;	addq.w	#1,a4
	dbf	d7,ButtonMark_Loop
	sub.w	12(a0),a4	;ButtonMarkL
	subq.w	#1,a4
ButtonMark_PlaneSkip:
	lea	240(a4),a4
	dbf	d6,ButtonMark_Planeloop
ButtonMark_Skip:
	rts



Action_Music1:
	move.w	#7,Button_F_Skip
	move.w	#7,Click_F_Skip
	move.w	#7,MainInputRK_F_Skip
	move.l	Main_Mastercommand(pc),a0
	lea	Set_Module1(pc),a1
	move.l	a1,(a0)
	rts

Action_Music2:
	move.w	#8,Button_F_Skip
	move.w	#8,Click_F_Skip
	move.w	#8,MainInputRK_F_Skip
	move.l	Main_Mastercommand(pc),a0
	lea	Set_Module2(pc),a1
	move.l	a1,(a0)
	rts

Action_Index:
	move.w	#9,Button_F_Skip
	move.w	#9,Click_F_Skip
	move.w	#9,MainInputRK_F_Skip

	move.w	#0,Screen2Jaul_F_Skip

	move.w	#0,Article_Screen
	move.l	Main_Mastercommand(pc),a0
	lea	Article_Organize(pc),a1
	move.l	a1,(a0)
	rts

Action_Quit:
	move.w	#10,Button_F_Skip
	move.w	#10,Click_F_Skip
	move.w	#10,MainInputRK_F_Skip

	move.l	Main_Mastercommand(pc),a0
	lea	Quit(pc),a1
	move.l	a1,(a0)
	rts

Quit:
	move.w	#0,Screen2Jaul_F_Skip

	move.w	#-80*4,PanelScrollAdd
	move.w	#-1,P60_fadestep

Quit_JaulWait:
	tst.w	Screen2Jaul_F_Skip
	beq	Quit_JaulWait

Quit_ScrollWait:
	tst.w	PanelScrollAdd
	bne	Quit_ScrollWait


quit_waitmusicout:
	tst.w	P60_master
	bne.b	quit_waitmusicout

	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	move.l	d0,(a0)

rts



Article_Screen:		dc.w	0	;actual article
Article_Page:		dc.w	0	;actual page
Article_PageQuant:	dc.w	0	;pages of actual article
Articles:		dc.w	71	;articles in this issue
Article_Organize:
;-;	bsr	flash2
	lea	Articles_Table,a0
	lea	Stream,a1
	move.w	Article_Screen,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,a0
	move.l	(a0),a0

	exg.l	a0,a1
	move.l	a0,a2
	add.l	8(a1),a2
	movem.l	d0-a6,-(a7)
	jsr	STCdecrunch
	movem.l	(a7)+,d0-a6
	move.b	#-1,(a2)+
	move.b	#-1,(a2)+
	move.b	#-1,(a2)+
	move.b	#-1,(a2)


	bsr	Screen_Startarticle	;comes back when scrolling finished

	move.w	#0,Click_F_Skip
	move.w	#0,Button_F_Skip
	move.w	#0,MainInputRK_F_Skip
	rts

Article_Pagecount:
	lea	Stream,a0
	lea	Article_Pages,a1
	lea	Article_Buttons,a2
	move.l	a0,(a1)+
ArticlePagecount_Loop:
	cmp.b	#-1,(a0)		;is next byte a command?
	bne	ArticlePagecount_Next
	cmp.b	#-1,1(a0)		;command #-1 ?
	beq	ArticlePagecount_End

ArticlePagecount_Next:
	addq.w	#1,Article_Pagequant
	move.l	#0,Seekpage_Buttondata
	bsr	SeekPageRight
	move.l	a0,(a1)+
	move.l	Seekpage_Buttondata,(a2)+
	bra	ArticlePageCount_Loop

ArticlePagecount_End:
	subq.w	#1,Article_Pagequant
	rts



player:	incbin	"data/player60a_c1.code"
playerend:	;look to !playersize! when changing there
P60_init=player+80
P60_end=player+774
P60_master=player+16

include	"data/stcdecrunch.s"

codep_e:;----------------------------------------------------------------
;------------------------------------------------------------------------
ifne	UseSection
section	DataC,data_c
endif
;------------------------------------------------------------------------
datac_s:;----------------------------------------------------------------
TitleMasc:	incbin	"data/Titlemasc.raw"	;)

Screen:						;)
Iris:	incbin	"data/Iris.blt"			;)
IrisEnd:					;)
	dcb.b	4*(18*9)*80*3-(IrisEnd-Iris),-1
ScreenEnd:					;)

WriteBuffer:					;)
Title:	incbin	"data/Title1.blt"		;)
TitleEnd:					;)
	dcb.b	4*(18*9)*80*1-(TitleEnd-Title),-1
WriteBufferEnd:					;)

EmptyScreenLine:	dcb.b	48,0		;)	;8 for border


drugframe1:	dc.l	Iris			;)
drugframe2:	dc.l	Iris+240




miracle:
	incbin	"data/miracle.blt"
	dcb.b	80*4*45,0
menu:
	dcb.b	80*4*45,0
	incbin	"data/menu.blt"

MouseSprite0:
	dc.w	$505a,$6000
	incbin	"data/mouse_0.spr"
	dc.l	0
MouseSprite1:
	dc.w	$505a,$6000+2^7
	incbin	"data/mouse_1.spr"
	dc.l	0
Endoflist:	dc.l	0



datac_e:;----------------------------------------------------------------
;------------------------------------------------------------------------






ifne	UseSection
;section	CodeC,code_c
endif
;------------------------------------------------------------------------
codec_s:
codec_e:
;-----------------------------------------------------------------------


ifne	UseSection
section	BSSC,bss_c
endif
;------------------------------------------------------------------------
bssc_s:
Copperlist:	dcb.b	512,0			;)
ModuleX:	ds.b	110000
copperlist1:	ds.b	64
copperlist2:	ds.b	64

bssc_e:
;------------------------------------------------------------------------


ifne	UseSection
section	DataP,data_p
endif
;------------------------------------------------------------------------
datap_s:
Font1:	incbin	"data/font1.raw"
Font2:	incbin	"data/font2.raw"
;Font3:

pal_miracle:
	dc.w	$0000,$0000,$0011,$0021,$0032,$0142,$0253,$0364,$0475,$0587
	dc.w	$0698,$08a9,$09bb,$0bcb,$0ded,$0fff

pal_screen:
;dc.w $000,$CBC,$FDF,$989,$DA6,$FC6,$F32,$C20
 dc.w $000,$CBC,$FDF,$989,$DA6,$FC6,$c20,$f32
dc.w $5C8,$385,$0AF,$07B,$F66,$B44,$FFF,$FFF

pal_menu:
	dc.w	$0000,$0000,$0011,$0021,$0032,$0142,$0253,$0364,$0475,$0587
	dc.w	$0698,$08a9,$09bb,$0bcb,$0ded,$0fff

pal_mouse:
	dc.w $000,$EEE,$555,$666,$777,$888,$999,$AAA
	dc.w $CCC,$DDD,$444,$FFF,$FF2,$FA0,$F60,$F00

col_Title:
pal_title:	incbin	"data/Title1.pal"

col_Iris:
pal_iris:	incbin	"data/Iris.pal"


include	"data/Articles_DATA.s"

Gadgets:
dc.w	11,227,29,246
dc.l	Action_Left
dc.w	33,227,51,246
dc.l	Action_Down
dc.w	55,227,73,246
dc.l	Action_Up
dc.w	77,227,95,246
dc.l	Action_Right
dc.w	166,227,193,253
dc.l	Action_Music1
dc.w	197,227,224,253
dc.l	Action_Music2
dc.w	227,219,266,253
dc.l	Action_Index
dc.w	270,219,308,253
dc.l	Action_Quit

dc.w	0,49,0,210
dc.l	Action_Left
dc.w	319,49,319,210
dc.l	Action_Right

dc.w	-1	;endmark


even
Module1:	incbin	"data/p60.uplifting2.stc"
even
Module2:	incbin	"data/p60.forbidden water.stc"
even
datap_e:
;------------------------------------------------------------------------

ifne	UseSection
section	BSSP,bss_p
endif
;------------------------------------------------------------------------
bssp_s:
Article_Pages:		ds.l	200
Article_Buttons:	ds.l	200
playercode:		ds.b	6620;	playerend-player   ;!playersize!

Stream:	ds.b	60000
bssp_e:
;------------------------------------------------------------------------

printt	"----------------------------------------------------------------"
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
printt	"Total memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s+codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s
printt	"Total memory without BSS areas:"
printv	codec_e-codec_s+datac_e-datac_s+codep_e-codep_s+datap_e-datap_s
printt	"----------------------------------------------------------------"

 
;auto ?z-a\
;auto ?zz-a\

b:
