UseSection=1

Planesize=256*40


ifne	UseSection
section	CodeC,code_c
endif
codec_s:
;------
Main_Showtime=0
Main_ProgramID=4
Main_Cache=1
Main_SkipWBStartTest=1
Main_Joyhold=0
include	"Include/maininit/Maininit6.2.s"
;------


bpl7pth=bpl6pth+4
bpl8pth=bpl7pth+4
bplcon3=$106
bplcon4=$10c
FMODE=$1fc

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand
	bsr	Fader3_dragon
	bsr	Fader3_dragon2
	bsr	Fader3_Fade
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
	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)
;	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#0,bplcon3(a5)
	move.w	#0,bplcon4(a5)

	lea	Fader3_table_Dragon,a0	;point in fader-table
	moveq	#0,d0
	bsr	Fader3_Start

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
;----------


Commands:;;
	dc.l	65,	nothing
	dc.l	79,     nothing
*	dc.l	218-96,	nothing
	dc.l	96,	startfadeout
	dc.l	1,	exit
	dc.l	60000,	nothing

nothing:	rts


Startfadeout:
	lea	Fader3_table_Dragon2,a0	;point in fader-table
	moveq	#0,d0
	bsr	Fader3_Start
rts

Exit:
	subq.w	#8,commander_point
	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	move.l	d0,(a0)
	rts


VBI:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0111001000010000,bplcon0(a5)
	move.w	#%0000001000010000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#00,bpl1mod(a5)
	move.w	#00,bpl2mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

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
	lea	Planesize(a0),a0
	move.l	a0,bpl8pth(a5)

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


	lea	Col_Fade_Dragon(pc),a0

	moveq	#7,d6
colcopyloop2:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,d3
	bset.l	#9,d3

	lea	$180(a5),a1
	moveq	#31,d7
colcopyloop1:
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

	move.w	d2,bplcon3(a5)
	move.w	d0,(a1)
	move.w	d3,bplcon3(a5)
	move.w	d1,(a1)+

	dbf	d7,colcopyloop1
	dbf	d6,colcopyloop2
bsr	Fader3_Fade

	bsr	commander

	move.l	Main_Talk(pc),a0
	move.l	(a0),d0
	move.l	d0,d1
	rol.l	#8,d1
	cmp.b	#Main_ProgramID,d1
	bne	notacommand
	cmp.w	#$d,d0
	bne	notacommand
	move.l	#0,(a0)
	move.w	#1,Commander_sleep

notacommand:
rts

;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
include	"work:sources/Include/Fader3/Fade.s"
include	"work:sources/Include/Fader3/Calc.s"
include	"work:sources/Include/Fader3/Start.s"


;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

Fader3_Dragon:
	lea	col_white,a0			;colour source
	lea	col_dragon,a1			;colour dest
	lea	col_Fade_dragon,a2		;colour fading list
	lea	Fader3_table_Dragon,a3		;fader calc table
	move.w	#Fader3_Colquant_Dragon,d7	;number of cols
	move.w	#64,d0			;fadesteps
	bsr	Fader3_Calc
rts


Fader3_Dragon2:
	lea	col_dragon,a0			;colour source
	lea	col_black,a1			;colour dest
	lea	col_Fade_dragon,a2		;colour fading list
	lea	Fader3_table_Dragon2,a3		;fader calc table
	move.w	#Fader3_Colquant_Dragon,d7	;number of cols
	move.w	#94,d0			;fadesteps
	bsr	Fader3_Calc
rts




Fader3_Colquant_Dragon=256	;number of colours in this calculation
Fader3_Table_Dragon:	
	dcb.l	Fader3_Colquant_Dragon*6+3
Fader3_Tableend_Dragon:

Fader3_Table_Dragon2:	
	dcb.l	Fader3_Colquant_Dragon*6+3
Fader3_Tableend_Dragon2:


;IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

col_dragon:
colours:
incbin	"data/Racer.raw.pal"
Coloursend:

Col_white:		dcb.l	256,$00ffffff
Col_black:		dcb.l	256,0
h:
Col_Fade_Dragon:	dcb.l	256,0

codec_e:



ifne	UseSection
;section	BSSC,bss_c
endif
bssc_s:
bssc_e:

ifne	UseSection
section	DataC,data_c
endif
datac_s:
Screen:
	incbin	"data/Racer.raw"
datac_e:

ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:

ifne	UseSection
;section	DataP,data_p
endif
datap_s:
datap_e:

ifne	UseSection
;section	BSSP,bss_p
endif
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
printt	"Object Memory:"
printv	codec_e-codec_s+datac_e-datac_s+codep_e-codep_s+datap_e-datap_s
printt	"Total Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s+codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s



