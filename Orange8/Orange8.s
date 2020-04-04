UseSection=1



showtime=0
Program_ID=1
Main_Initcall2=0
Main_Enable_Jp60music=1
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=1
Main_Enable_Exit=0


ifne	UseSection
section	CodeC,code_c
endif
codec_s:
include	"data/maininit6.01.s"
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk

	bsr.w	Fader2_TitlePic1

	lea	vector,a0
	lea	vector_term,a1
	jsr	determ

	lea	vector,a0
	move.l	a0,a1
	sub.l	a2,a2
	jsr	relocator	;relocate memory
	lea	vector,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	jsr	textcalc

	lea	playercode,a0
	lea	player,a1
	move.w	#(playerend-player)/4-1,d7
playerback:
	move.l	(a1)+,(a0)+
	dbf	d7,playerback

	move.w	#0,f_skipmusic

	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)
;-------------------------
	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
	waitblit
;-------------------------
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$003c,ddfstrt(a5)
	move.w	#$00d4,ddfstop(a5)
	move.w	#%1100001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#3*80,bpl1mod(a5)
	move.w	#3*80,bpl2mod(a5)
;	move.w	#%1000000000100000,dmacon(a5)

	lea	col_titlepic(pc),a0
	lea	$180(a5),a1
	move.w	Col_titlepic,d0
rept	16
	move.w	d0,(a1)+
endr

	move.l	Main_VBIVector(pc),a0
	move.l	#vbi,(a0)

	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist,(a0)
	move.l	#0,maincommand

	move.w	#600,commander_sleep
;-------------------------
	lea	module1s,a0
	sub.l	a1,a1
	sub.l	a2,a2
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_init
	lea	$dff000,a5
;-------------------------

main_loop:
	btst	#7,ciaapra
;	beq	main_loopexit
	lea	maincommand(pc),a0
	tst.l	(a0)
	bmi.b	main_loopexit
	beq.b	main_loop

	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	bra.b	main_loop

main_loopexit:
	move.w	#Program_ID,d0
	lsl.w	#8,d0
	move.l	Main_Talk(pc),a0
	move.w	d0,2(a0)
	
	rts
;----------

Commands:;;
	dc.l	6000,	nothing;600
	dc.l	1,	setdcommand,	StopCoppercopy
	dc.l	15,	setdcommand,	Fader2_TitlePic2
	dc.l	1,	nothing
	dc.l	505,	startfade2;560
	dc.l	335-30-90,	setdcommand,	exe_vector
	dc.l	30+90+30,	setdcommand,	determ_menu1

;dc.l	1,	set_menu

	dc.l	1,	setvbivector,	vbi_menu
	dc.l	1,	set_menu
	dc.l	1000,	setdcommand,	determ_menu2
	dc.l	150,	set_copypage
	dc.l	1,	enable_setball

	dc.l	300,	setdcommand,	writepage
	dc.l	1,	stepback,	20
	dc.l	60000,	nothing


Nothing:	rts
stepback:
	move.l	(a1)+,d0
	sub.w	d0,Commander_Point
	rts

enable_setball:
	move.w	#1,f_setball
	move.w	#0,askkeyskip
	rts

SetVBIVector:
	move.l	Main_VBIVector(pc),a0
	move.l	(a1)+,(a0)
	addq.w	#4,Commander_Point
rts

SetDCommand:
	move.l	(a1)+,d0
	addq.w	#4,Commander_Point
	lea	MainCommand(pc),a0
	move.l	d0,(a0)
	rts

startfade2:
	neg.w	colmovedir
	move.w	colmovedir,d0
	add.w	d0,colpoint
	move.w	#10,colmovesleep
	move.w	#0,f_stopcoppercopy
rts

determ_menu1:
	lea	menupic1,a0
	lea	menupic1_term,a1
	jsr	determ
	rts

determ_menu2:
	lea	menupic2,a0
	lea	menupic2_term,a1
	jsr	determ
	move.w	#1,commander_sleep
	rts



set_copypage:
	move.w	#0,copyoffset
	move.w	#255,copyoffsetbot
	move.w	#256,Copypoint
rts

exe_vector:
	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)

	lea	vector,a4
	jsr	2*6(a4)
	move.l	#0,maincommand
rts

set_Menu:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$003c,ddfstrt(a5)
	move.w	#$00d4,ddfstop(a5)
	move.w	#%1100001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#%0000000000100100,bplcon2(a5)
	move.w	#3*80,bpl1mod(a5)
	move.w	#3*80,bpl2mod(a5)

;	lea	Menupic1,a0
;	move.l	a0,bpl1pth(a5)
;	lea	80(a0),a0
;	move.l	a0,bpl2pth(a5)
;	lea	80(a0),a0
;	move.l	a0,bpl3pth(a5)
;	lea	80(a0),a0
;	move.l	a0,bpl4pth(a5)

	lea	col_titlepic(pc),a0
	lea	$180(a5),a1
rept	16
	move.w	(a0),32(a1)
	move.w	(a0)+,(a1)+
endr


	move.l	Main_Copperlist(pc),a0
	move.l	#-1,(a0)

rts

StopCoppercopy:
	move.w	#1,f_stopcoppercopy
	lea	Fader2_Table_TitlePic,a0
	moveq	#0,d0
	move.w	#(Fader2_Tableend_TitlePic-Fader2_Table_TitlePic)/4-1,d7
mapclr:
	move.l	d0,(a0)+
	dbf	d7,mapclr
rts


f_stopcoppercopy:	dc.w	0
;------------------------------------------------------------------------
VBI:
	lea	Titlepic,a0
	move.l	a0,bpl1pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl4pth(a5)

	bsr.w	fader2_real
	jsr	coppercopy
;	bsr	commander
	rts

VBI_menu:
	lea	Menupic1,a0
	move.l	a0,bpl1pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl4pth(a5)

;	bsr	fader2_real
;	jsr	coppercopy
;	bsr	commander
	bsr.w	copymenu
	bsr.w	copymenu
	jsr	askmouse
	jsr	setball
	rts
;------------------------------------------------------------------------
tune:
	dc.w	56*80*4+36+(0*18*80*4)
	dc.l	module1s

	dc.w	56*80*4+36+(1*18*80*4)
	dc.l	module2s

	dc.w	56*80*4+36+(2*18*80*4)
	dc.l	module3s
;-------------
organizemusic:
	move.w	#-1,P60_fadestep

waitmusicout:
	tst.w	P60_master
	bne.b	waitmusicout

	move.w	#1,f_skipmusic

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
	move.w	#64,p60_master

	lea	playercode,a0
	lea	player,a1
	move.w	#(playerend-player)/4-1,d7
playercopy:
	move.l	(a0)+,(a1)+
	dbf	d7,playercopy

;---
	lea	tune,a0
	move.w	(a0),d1
	cmp.w	ballpos,d1
	beq.b	restartsamemodule
	move.l	2(a0),a1

seekloop:
	addq.w	#6,a0
	move.w	(a0),d2
	cmp.w	ballpos,d2
	bne.b	seekloop
	move.l	2(a0),a2

	move.w	d1,(a0)
;	move.l	a1,2(a0)
	move.w	d2,tune
;	move.l	a2,tune+2

	move.w	#180000/4-1,d7
copytuneloop:
	move.l	(a1),d0
	move.l	(a2),(a1)+
	move.l	d0,(a2)+
	dbf	d7,copytuneloop


restartsamemodule:
;---
	move.w	#0,f_skipmusic
;-------------------------
	lea	module1s,a0
	sub.l	a1,a1
	sub.l	a2,a2
	moveq	#0,d0		; Auto Detect
	lea	$dff000,a6
	jsr	P60_init
	lea	$dff000,a5
;-------------------------
	move.w	#0,askkeyskip
	rts

;------------
P60_fadestep:	dc.w	0
P60_fader:
	lea	P60_fadestep(pc),a0
	move.w	(a0),d0
	beq.b	P60_fader_skip

	lea	p60_master,a1
	add.w	d0,(a1)
	move.w	(a1),d0
	beq.b	P60_fader_fin
	cmp.w	#64,d0
	beq.b	P60_fader_fin

P60_fader_skip:
	rts

P60_fader_fin:
	move.w	#0,(a0)
	rts
;----------

include	"include/Fader2/Calc1.2.i"

Fader2_Colquant_TitlePic=16	;number of colours in this calculation
Fader2_Tablequant_TitlePic=7;	maximal number of colours in program!!
Fader2_Table_TitlePic:	dcb.w	Fader2_Tablequant_TitlePic*Fader2_Colquant_TitlePic*16
Fader2_Tableend_TitlePic:

Fader2_TitlePic1:
	moveq	#Fader2_Colquant_TitlePic,d7	;number of colours
	lea	col_back1,a0		;colour source
	lea	col_back1,a1
	lea	fader2_table_TitlePic,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc
rept	2
	lea	col_back1,a1
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
endr
	lea	col_White,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
rept	3
	lea	col_TitlePic,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
endr
rts

Fader2_TitlePic2:
	moveq	#Fader2_Colquant_TitlePic,d7	;number of colours
	lea	col_back2,a0		;colour source
	lea	col_back2,a1
	lea	fader2_table_TitlePic,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc
rept	2
	lea	col_back2,a1
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
endr
	lea	col_White,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
rept	3
	lea	col_TitlePic,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
endr
rts


Fader2Start_TitlePic:
	move.w	#Fader2_Colquant_TitlePic,fader2_quant
	move.w	#fader2_Tablequant_TitlePic*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_TitlePic,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_TitlePic,Fader2_pos	;...fade backward
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


Col_Back1:
	dcb.w	16,$0323

Col_White:
	dc.w	$0323
	dc.w	$0fff
	dcb.w	13,$0fff
 	dc.w	$0fff



Col_Back2:
	dc.w	$0000
	dc.w	$0fff
	dcb.w	14,$0123

Col_Titlepic:
	DC.W	$0323,$0FFF,$0DEE,$0FFF,$0BBC,$09AC,$089B,$078A
	DC.W	$0689,$0578,$0467,$0356,$0346,$0235,$0134,$0123



Copyoffset:	dc.w	0
Copyoffsetbot:	dc.w	255
Copypoint:	dc.w	0
Copymenu:
	move.w	copypoint(pc),d0
	beq.b	Copymenu_skip
	subq.w	#1,d0
	move.w	d0,Copypoint
	lea	menupic1,a0
	lea	menupic2,a1
	move.w	copyoffsetbot(pc),d1
	sub.w	d0,d1
	add.w	copyoffset(pc),d0
	mulu.w	#80*4,d0
	mulu.w	#80*4,d1
	lea	1(a0,d1.l),a2
	lea	1(a1,d1.l),a3
	lea	(a0,d0.l),a0
	lea	(a1,d0.l),a1

	moveq	#39,d7
Copymenu_loop:
	move.b	3*80(a1),3*80(a0)
	move.b	2*80(a1),2*80(a0)
	move.b	1*80(a1),1*80(a0)
	move.b	(a1),(a0)

	move.b	3*80(a3),3*80(a2)
	move.b	2*80(a3),2*80(a2)
	move.b	1*80(a3),1*80(a2)
	move.b	(a3),(a2)

addq.w	#2,a0
addq.w	#2,a1
addq.w	#2,a2
addq.w	#2,a3
	dbf	d7,copymenu_loop

Copymenu_skip:
	rts


player:	incbin	"data/player60a_c1.code"
playerend:	;look to !playersize! when changing there
P60_init=player+80
P60_end=player+774
P60_master=player+16

p60_music:
	bsr.w	p60_fader
	rts

colsinpoint:	dc.w	0
colsinpoint2:	dc.w	0
colsin:
rept	12
dc.W  32, 33, 34, 35, 36, 37, 38, 39, 39, 40, 40, 41, 41
dc.W  41, 41, 41, 41, 41, 41, 40, 40, 40, 39, 39, 38, 38
dc.W  37, 37, 36, 36, 36, 35, 35, 35, 35, 35, 36, 36, 36
dc.W  37, 37, 37, 38, 39, 39, 40, 40, 41, 41, 42, 42, 43
dc.W  43, 43, 43, 43, 43, 43, 42, 42, 42, 41, 40, 40, 39
dc.W  38, 37, 36, 35, 34, 33, 33, 32, 31, 30, 30, 29, 29
dc.W  29, 29, 29, 29, 29, 29, 29, 30, 30, 31, 32, 32, 33
dc.W  34, 34, 35, 36, 36, 37, 37, 38, 38, 39, 39, 39, 39
dc.W  39, 39, 38, 38, 38, 37, 37, 36, 36, 35, 35, 34, 34
dc.W  34, 33, 33, 33, 33, 33, 33, 33, 33, 34, 34, 35, 35
dc.W  36, 37, 37, 38, 39, 40, 41, 41, 42, 43, 43, 44, 44
dc.W  45, 45, 45, 45, 45, 45, 45, 44, 44, 43, 43, 42, 41
dc.W  40, 39, 38, 38, 37, 36, 35, 34, 33, 33, 32, 32, 31
dc.W  31, 31, 30, 30, 30, 30, 31, 31, 31, 31, 32, 32, 32
dc.W  33, 33, 33, 33, 34, 34, 34, 34, 33, 33, 33, 32, 32
dc.W  31, 31, 30, 29, 28, 27, 26, 26, 25, 24, 23, 22, 21
dc.W  21, 20, 20, 19, 19, 19, 19, 19, 19, 19, 20, 20, 21
dc.W  21, 22, 23, 23, 24, 25, 26, 27, 27, 28, 29, 29, 30
dc.W  30, 31, 31, 31, 31, 31, 31, 31, 31, 30, 30, 30, 29
dc.W  29, 28, 28, 27, 27, 26, 26, 26, 25, 25, 25, 25, 25
dc.W  25, 26, 26, 27, 27, 28, 28, 29, 30, 30, 31, 32, 32
dc.W  33, 34, 34, 35, 35, 35, 35, 35, 35, 35, 35, 35, 34
dc.W  34, 33, 32, 31, 31, 30, 29, 28, 27, 26, 25, 24, 24
dc.W  23, 22, 22, 22, 21, 21, 21, 21, 21, 21, 21, 22, 22
dc.W  23, 23, 24, 24, 25, 25, 26, 27, 27, 27, 28, 28, 28
dc.W  29, 29, 29, 29, 29, 28, 28, 28, 27, 27, 26, 26, 25
dc.W  25, 24, 24, 24, 23, 23, 23, 23, 23, 23, 23, 23, 24
dc.W  24, 25, 25, 26, 27, 28, 29, 30, 31

endr

;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789!.-"
charsend:
even
textpoint:	dc.l	text;	|
text:
dc.b " it is time for another experience  "
dc.b "                                    "
dc.b "          ...a b y s s...           "
dc.b "          p r e s e n t s           "
dc.b "                                    "
dc.b "          o r a n g e   8           "

dc.b "                                    "
dc.b "          we care for you           "
dc.b "                                    "
dc.b "music....................neurodancer"
dc.b "code............................moon"
dc.b "gfx............................toxic"

dc.b "                                    "
dc.b "      welcome our new mates...      "
dc.b "                                    "
dc.b "           hi qwerty!!!             "
dc.b "                                    "
dc.b "           moin sting!!             "

dc.b "                                    "
dc.b "move your rat to toggle between the "
dc.b "  different tunes. left button to   "
dc.b "  select a module. right to quit    "
dc.b "                                    "
dc.b "     no aga but 1 meg of mem        "

dc.b "              members               "
dc.b "                                    "
dc.b "moon............................code"
dc.b "dexter..........................code"
dc.b "bartman.........................code"
dc.b "poet............................code"

dc.b "smc.........................code sfx"
dc.b "neurodancer......................sfx"
dc.b "pink.............................sfx"
dc.b "luka.........................sfx gfx"
dc.b "jumping pixel....................gfx"
dc.b "tyshdomos........................gfx"

dc.b "toxic.......................gfx swap"
dc.b "sting...........................swap"
dc.b "qwerty..........................swap"
dc.b "                                    "
dc.b "                                    "
dc.b "                                    "

dc.b "       greets to these crews...     "
dc.b "                                    "
dc.b "              absolute!             "
dc.b "              accession             "
dc.b "                 act                "
dc.b "              alcatraz              "
dc.b "               ambrosia             "
dc.b "               anaheim              "
dc.b "                analog              "
dc.b "               anathema             "
dc.b "              andromeda             "
dc.b "               applause             "
dc.b "                arise               "
dc.b "               artwork              "
dc.b "               balance              "
dc.b "             bizarre art            "
dc.b "           bonzai brothers          "
dc.b "             boom design            "
dc.b "                bronx               "
dc.b "                c-lous              "
dc.b "               cadaver              "
dc.b "                chrome              "
dc.b "               complex              "
dc.b "               control              "
dc.b "                damage              "
dc.b "                 dcs                "
dc.b "               decnite              "
dc.b "               defiance             "
dc.b "               delight              "
dc.b "                depth               "
dc.b "                desire              "
dc.b "              diffusion             "
dc.b "               digital              "
dc.b "               disaster             "
dc.b "               disorder             "
dc.b "                divine              "
dc.b "             dreamdealers           "
dc.b "              dual 4mat             "
dc.b "             dual format            "
dc.b "               effect               "
dc.b "               eltech               "
dc.b "               energy               "
dc.b "               enigma               "
dc.b "               equinox              "
dc.b "              eremation             "
dc.b "               essence              "
dc.b "               fanatic              "
dc.b "                fate                "
dc.b "                 fci                "
dc.b "                fear                "
dc.b "             flying cows            "
dc.b "             focus design           "
dc.b "               freezers             "
dc.b "               funzine              "
dc.b "              gel dezign            "
dc.b "                giants              "
dc.b "                 gods               "
dc.b "              hemoroids             "
dc.b "               illegal              "
dc.b "               illusion             "
dc.b "                infect              "
dc.b "               intense              "
dc.b "                 iris               "
dc.b "                jewels              "
dc.b "               kronical             "
dc.b "                legacy              "
dc.b "               mad elks             "
dc.b "               majic 12             "
dc.b "                masque              "
dc.b "                mayhem              "
dc.b "                mellow              "
dc.b "                metro               "
dc.b "                mirage              "
dc.b "               movement             "
dc.b "                mystic              "
dc.b "                 neo                "
dc.b "              neoplasia             "
dc.b "                 nova               "
dc.b "                nuance              "
dc.b "              obsession             "
dc.b "               offence              "
dc.b "              old bulls             "
dc.b "               orbital              "
dc.b "                orion               "
dc.b "               outlaws              "
dc.b "               parallax             "
dc.b "               passion              "
dc.b "                picco               "
dc.b "            polka brothers          "
dc.b "               progress             "
dc.b "                pulse               "
dc.b "             quick design           "
dc.b "               ram jam              "
dc.b "              razor 1911            "
dc.b "                rebels              "
dc.b "                retire              "
dc.b "                riots               "
dc.b "                 s!p                "
dc.b "                saints              "
dc.b "                samba               "
dc.b "                sanity              "
dc.b "               sardonyx             "
dc.b "               saturne              "
dc.b "                scania              "
dc.b "               scoopex              "
dc.b "                scope               "
dc.b "               silicon              "
dc.b "               simplex              "
dc.b "               solitude             "
dc.b "              spaceballs            "
dc.b "                spasm               "
dc.b "                speedy              "
dc.b "             static bytes           "
dc.b "              status o.k.           "
dc.b "               stearoid             "
dc.b "               stellar              "
dc.b "              stone arts            "
dc.b "                storm               "
dc.b "               sunshine             "
dc.b "               suspect              "
dc.b "                 tfd                "
dc.b "               the edge             "
dc.b "                 tilt               "
dc.b "                 tmg                "
dc.b "                 tpdl               "
dc.b "              trance inc.           "
dc.b "                trsi                "
dc.b "                union               "
dc.b "              unlimited             "
dc.b "               virtual              "
dc.b "             vision soft.           "
dc.b "            virtual dreams          "



dc.b "      write us for any reason       "
dc.b "                                    "
dc.b "             neurodancer            "
dc.b "          highvoltage.gun.de        "
dc.b "        or bbs   - the ambush -     "
dc.b "             08621-064260           "

dc.b "                                    "
dc.b "                toxic               "
dc.b "             sven dedek             "
dc.b "         gruenewaldstrasse 6        "
dc.b "           84453 muehldorf          "
dc.b "               germany              "

dc.b "                                    "
dc.b "               qwerty               "
dc.b "            adrian dolny            "
dc.b "           62-850  liskow           "
dc.b "            woj.kaliskie            "
dc.b "               poland               "

dc.b "                                    "
dc.b "                sting               "
dc.b "            dirk dallmann           "
dc.b "          steinfurthstr. 12         "
dc.b "         45884 gelsenkirchen        "
dc.b "               germany              "

dc.b "                                    "
dc.b "                pink                "
dc.b "           manfred linzner          "
dc.b "         rupert-mayer-str. 6        "
dc.b "           81379 muenchen           "
dc.b "               germany              "

dc.b "                                    "
dc.b "                luka                "
dc.b "         gregory engelhardt         "
dc.b "           am weiherbach 6          "
dc.b "         89361  landensberg         "
dc.b "               germany              "

dc.b "                                    "
dc.b "                moon                "
dc.b "             po box 162             "
dc.b "            5400 hallein            "
dc.b "               austria              "
dc.b "                                    "

dc.b "                                    "
dc.b "     ...sum releases at s i h...    "
dc.b "                                    "
dc.b "         diznee land issue 7        "
dc.b "                                    "
dc.b "                                    "

dc.b "                                    "
dc.b "                                    "
dc.b "             pixel storm            "
dc.b "                                    "
dc.b " a slideshow by tyshdomos and toxic "
dc.b "                                    "

dc.b "                                    "
dc.b "                                    "
dc.b "             think pink             "
dc.b "                                    "
dc.b "       a aga musicdisk by pink      "
dc.b "                                    "               

dc.b "                                    "
dc.b "          and a 40 kb intro         "
dc.b "                                    "
dc.b "code............................poet"
dc.b "gfx............................toxic"
dc.b "sfx.............................pink"

dc.b "to meet members of abyss be at these"
dc.b "              parties               "
dc.b "                                    "
dc.b "       somewhere in holland         "
dc.b "            assembly 95             "
dc.b "              party 5               "

dc.b "                                    "
dc.b "                                    "
dc.b "          text restarts             "
dc.b "                                    "
dc.b "                                    "
dc.b "                                    "

textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=4*9
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

Writepage:
	move.l	textpoint(pc),a0

	lea	font(pc),a1
;	add.w	#4*9,a1
	lea	menupic2,a2
	add.l	#125*80*4+33,a2


	moveq	#5,d5
Writepage_yloop:

	moveq	#35,d6
Writepage_xloop:

	move.w	(a0)+,d0
	lea	(a1,d0.w),a3

	moveq	#4*9-1,d7
Writepage_charloop:
	move.b	(a3)+,(a2)
	lea	80(a2),a2
	dbf	d7,writepage_charloop
	lea	1-80*4*9(a2),a2
	dbf	d6,Writepage_xloop
	lea	80*4*11-36(a2),a2
	dbf	d5,Writepage_yloop
	move.w	#67,Copypoint
	move.w	#125,copyoffset
	move.w	#188,copyoffsetbot

	cmp.l	#textoffsetend,a0
	bne.b	notextrestart
	lea	text(pc),a0
notextrestart:
	move.l	a0,textpoint
rts

Ballpos:	dc.w	56*80*4+36
f_setball:	dc.w	0

Setball:
	tst.w	f_setball
	beq.b	setball_skip
	lea	menupic1,a0
	add.w	ballpos(pc),a0
	lea	28(a0),a2
	lea	ball(pc),a1

	moveq	#10*4-1,d7
setball_loop:
	move.w	(a1),(a0)
	move.w	(a1)+,(a2)
	lea	80(a0),a0
	lea	80(a2),a2
	dbf	d7,setball_loop
setball_skip:
	rts

Clrball:
	lea	menupic1,a0
	add.w	ballpos(pc),a0
	lea	28(a0),a2

	moveq	#10*4-1,d7
clrball_loop:
	move.w	#-1,(a0)
	move.w	#-1,(a2)
	lea	80(a0),a0
	lea	80(a2),a2
	dbf	d7,clrball_loop
	rts

mousemem:	dc.w	0
f_buttonskip:	dc.w	0
askkeyskip:	dc.w	1
askmouse:
	tst.w	askkeyskip
	bne.w	askmouse_skip
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
	ble.b	notmoved	;moved, but not enough
	move.b	d1,(a0)		;mousemem
	cmp.b	#$20,d0
	bge.b	notmoved	;(overflow)
	tst.b	d3
	beq.b	mouse_up

;mouse_down
;;;	bsr	key_down
	cmp.w	#56*80*4+36+(2*18*80*4),ballpos
	beq.b	notmoved
	bsr.b	clrball
	add.w	#18*80*4,ballpos
	bra.b	notmoved
mouse_up:
;;;	bsr	key_up
	cmp.w	#56*80*4+36,ballpos
	beq.b	notmoved
	bsr.b	clrball
	sub.w	#18*80*4,ballpos

notmoved:
	btst.b	#6,ciaapra
	beq.b	mouse_leftbut
	btst.b	#10,$dff016
	beq.b	mouse_rightbut
	move.w	#0,f_buttonskip
	rts

mouse_leftbut:
	btst.b	#10,$dff016;both buttons allowed when buttons disabled
	beq.b	mouse_bothbut
	tst.w	f_buttonskip
	bne.b	askmouse_skip
	move.w	#1,f_buttonskip
	move.l	#organizemusic,maincommand
	move.w	#1,askkeyskip

askmouse_skip:
	rts

mouse_rightbut:
	tst.w	f_buttonskip
	bne.b	askmouse_skip
	move.w	#2,f_buttonskip
	move.w	#1,askkeyskip
	move.l	#getout,Maincommand
	rts

mouse_bothbut:
	move.w	#3,f_buttonskip
;	bra	key_exit
	rts
;-----------------------

Getout:
	tst.w	copypoint
	bne.b	getout
	move.w	#60000,commander_sleep

	lea	menupic2,a0
	lea	menupic1_term,a1
	jsr	determ
	move.w	#0,f_setball

	jsr	set_copypage

getoutsleep2:
	tst.w	copypoint
	bne.b	getoutsleep2


	lea	vector,a0
	lea	endvector_term,a1
	jsr	determ

	lea	vector,a0
	move.l	a0,a1
	sub.l	a2,a2
	jsr	relocator	;relocate memory


	lea	vector,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	
;move.w	#0,intflag

	move.w	#-1,P60_fadestep
	lea	vector,a4

	jsr	2*6(a4)
	move.l	#-1,maincommand
	move.l	Main_VBIVector,a0
	move.l	#0,(a0)
	waitblit
	waitblit

rts


ball:		incbin	"data/Ball.blt"
Font:		incbin	"data/Orangefont.blt"
Menupic1:
Titlepic:	incbin	"data/orange8.blt"
Menupic1_term:	incbin	"data/Menu.blt.term"

Colpoint:	dc.w	32
Colmovesleep:	dc.w	10
Colmovedir:	dc.w	32
Coppercopy:
	tst.w	f_stopcoppercopy
	bne.w	skip_coppercopy
	subq.w	#1,colmovesleep
	bne.b	nocoljump
	cmp.w	#1600+16*32,colpoint
	beq.b	nocoljump
	tst.w	colpoint
	beq.b	nocoljump
	move.w	colmovedir(pc),d0
	add.w	d0,colpoint
	move.w	#10,colmovesleep


nocoljump:
	btst	#10,$dff016
	bne.b	nofadebackstart
	neg.w	colmovedir
	move.w	colmovedir(pc),d0
	add.w	d0,colpoint
	move.w	#10,colmovesleep

nofadebackstart:
	lea	colsinpoint,a1
	move.w	(a1),d3
	addq.w	#4,d3
	cmp.w	#720,d3
	bne.b	nocolsinflow
	moveq	#0,d3
nocolsinflow:
	move.w	d3,(a1)

	lea	colsinpoint2,a1
	move.w	(a1),d4
	addq.w	#2,d4
	cmp.w	#720,d4
	bne.b	nocolsinflow2
	moveq	#0,d4
nocolsinflow2:
	move.w	d4,(a1)


	move.l	#$5e3b,d0
	lea	Copperlist,a0

	move.w	#132/2-1,d7
Coppercopy_l1:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	moveq	#14,d6
	move.w	#$0182,d1


	lea	colsin+720*6,a1
	move.w	(a1,d3.w),d2
	add.w	(a1,d4.w),d2
lsr.w	#1,d2
;and.w	#%1111111111100000,d2
	lea	Fader2_Table_TitlePic+2,a1
mulu.w	#32,d2
	add.w	d2,a1
	add.w	colpoint(pc),a1

	add.w	#2,d3
	add.w	#4,d4
Coppercopy_l2:
	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d1
	dbf	d6,coppercopy_l2

	add.w	#$0200,d0
	dbf	d7,coppercopy_l1

	move.l	#-2,(a0)
skip_coppercopy:
rts






;------------------------------------------------------------------------
;---	      BYTESTRING decrunchroutine by Moon, april 1991		-
;------------------------------------------------------------------------
determ:
;a0=adress of memory to decrunch
;a1=adress of crunched data

move.l	(a1)+,d1	;crunched length
move.l	(a1)+,d2	;decrunched length
tst.b	(a1)+		;routine-code
move.b	(a1)+,d0	;codebyte

sub.l	#4+4+1+1,d1

decrunchl1:
;move.w	#$0990,$dff180
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3
;move.w	#$0009,$dff180

decrunchl4:
move.b	d3,(a0)+
dbf	d2,decrunchl4
subq.l	#3,d1
bra.b	decrunchl3

decrunchl2:
move.b	-1(a1),(a0)+
subq.l	#1,d1

decrunchl3:
bne.b	decrunchl1

rts


;------------------------------------------------------------------------
;-			       RELOCATOR 2				-
;-			      -------------				-
;-									-
;- Support:								-
;-  Hunk code (chip/fast/public)					-
;-  Hunk reloc 32							-
;-  Hunk data								-
;-  Hunk bss								-
;-									-
;-									-
;- Usage:								-
;-	   lea	program,a0	;adress of reloc-file			-
;-	   lea	chip,a1		;free chipmemory			-
;-	   lea	fast,a2		;free fastmemory			-
;-	   jsr	relocator						-
;-	   tst	d0		;bug ?					-
;-	   bne	error							-
;-	   jmp	chip/fast	;position of first code segment		-
;-									-
;-  its your turn to make sure that both memoryblocks (chip/fast)	-
;-  are big enough!							-
;-  if you want to force all to chipmem, set a2 to zero: sub.l	a2,a2	-
;-									-
;-									-
;-									-
;- code by Moon/ABYSS					      May 1994	-
;------------------------------------------------------------------------
relocator:
	move.l	a1,memorypoint_chip
	move.l	a2,memorypoint_fast
	move.w	#0,hunk_work

	cmp.l	#$000003f3,(a0)+	;hunk header
	bne.w	bug			;not executable or file damaged

	cmp.l	#0,(a0)+		;hunkname
	bne.w	bug			;bug if there's a hunkname
					;(not supported yet)


	move.l	(a0)+,hunk_quant	;number of hunks
	move.l	(a0)+,hunk_first	;first hunknumber
	move.l	(a0)+,hunk_last		;last hunknumber

	move.l	hunk_quant,d7		;number of hunks
	subq.w	#1,d7
	lea	hunk_lengths(pc),a1	;memory for hunk-lengths
	move.l	a2,d6			;fastmem to test if valid
reloc_copylengths:
	move.l	(a0)+,d0		;next hunk length
	tst.l	d6
	beq.b	reloc_takechip		;no fastmem=force all to chipmem
	btst.l	#30,d0			;chipmem?
	bne.b	reloc_takechip
;	btst.l	#31,d0			;fastmem or public->take fast
;	bne	reloc_takefast
reloc_takepublic:
reloc_takefast:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length
	move.l	memorypoint_fast,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_fast
	bra.b	reloc_memorytaken

reloc_takechip:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length
	move.l	memorypoint_chip,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_chip

reloc_memorytaken:
	dbf	d7,reloc_copylengths
	lea	hunk_lengths(pc),a1	;memory for hunk-lengths

;-------------------------

reloc_mainloop:
	move.l	(a0)+,d0		;new hunk
	cmp.l	#$000003e9,d0		;hunk code ?
	beq.b	hunk_code

	cmp.l	#$000003ec,d0		;hunk reloc 32 ?
	beq.b	hunk_reloc32

	cmp.l	#$000003ea,d0		;hunk data ?
	beq.b	hunk_data

	cmp.l	#$000003eb,d0		;hunk bss ?
	beq.w	hunk_bss

	cmp.l	#$000003f2,d0		;hunk end ?
	beq.w	hunk_end

bug:
	move.w	#$0f00,$dff180
	move.w	#$0ff0,$dff180
	btst	#6,$bfe001
	bne.b	bug
	moveq	#-1,d0
	move.l	d7,bugcode
	rts
depp:	dc.w	0
;------------------------------------------------------------------------
;---------
hunk_code:
	move.l	(a0)+,d7		;hunk code length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_code_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	hunk_code_copy
	bra.b	reloc_mainloop
;-----------------------------
hunk_reloc32:
	move.l	(a0)+,d7		;hunk reloc 32 offsets length
	beq.b	reloc_mainloop
	move.l	(a0)+,d6		;hunknumber of offsets
	lsl.w	#3,d6
	move.l	4(a1,d6.w),d1		;hunkadress of offsets
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_reloc32_loop:
	move.l	(a0)+,d2		;next offset
	add.l	d1,(a2,d2.l)		;add hunk startadress
	subq.l	#1,d7
	bne.b	hunk_reloc32_loop
	bra.b	hunk_reloc32
;---------------------------------
hunk_data:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_data_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
furz:
	bne.b	hunk_data_copy
	bra.w	reloc_mainloop

;-----------------------------
hunk_bss:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	bra.w	reloc_mainloop
;-----------------------------
hunk_end:
	addq.w	#1,hunk_work
	subq.l	#1,hunk_quant
	bne.w	reloc_mainloop
	moveq	#0,d0			;no bug
	rts				;;finished
;----------


hunk_maximum=100
hunk_quant:	dc.l	0
hunk_first:	dc.l	0
hunk_last:	dc.l	0
hunk_lengths:	dcb.l	hunk_maximum*2,0

hunk_work:	dc.w	0

memorypoint_chip:	dc.l	0
memorypoint_fast:	dc.l	0



bugcode:	dc.l	0




codec_e:

ifne	UseSection
section	DataC,data_c
endif
datac_s:
module1s:	incbin	"data/modules/p60.killer trip"
module1e:	dcb.b	180000+module1s-module1e,0
datac_e:

ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
Copperlist:	ds.b	5000
Menupic2:
Vector:	ds.b	110000
bssc_e:

ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:

ifne	UseSection
section	DataP,data_p
endif
datap_s:
vector_term:	incbin	"data/startvector.term"
even
endvector_term:	incbin	"data/endvector.term"
even
Menupic2_term:	incbin	"data/Menu2.blt.term"
module2s:	incbin	"data/modules/p60.fuck you"
module2e:	dcb.b	180000+module2s-module2e,0

module3s:	incbin	"data/modules/p60.plasma sucker"
module3e:	dcb.b	180000+module3s-module3e,0

datap_e:

ifne	UseSection
section	BSSP,bss_p
endif
bssp_s:
playercode:	ds.b	6620;	playerend-player   ;!playersize!
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


