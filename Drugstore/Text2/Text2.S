;------------------------------------------------------------------------
;|                                 Text2                                |
;|                                -------                               |
;|                                                                      |
;| threethousandtwohundredandtwelve...                                  |
;|                                                                      |
;| code by Moon/ABYSS                                                   |
;------------------------------------------------------------------------
UseSection=1

ifne	UseSection
section	CodeC,code_c
endif
codec_s:

showtime=0
Program_ID=1
Main_Initcall2=0
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk

	bsr.w	Fader2_Font
	bsr.w	textcalc

	bsr.w	printtext1
	bsr.w	printtext2
	bsr.w	printtext3
	bsr.w	printtext4
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


;	lea	$180(a5),a0
;	lea	col_font(pc),a1
;	move.l	(a1)+,(a0)+
;	move.l	(a1)+,(a0)+
;	move.l	(a1)+,(a0)+
;	move.l	(a1)+,(a0)+

main_loop:
	lea	maincommand(pc),a0
	tst.l	(a0)
	bmi.b	main_loopexit
	beq.b	main_loop

	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	bra.b	main_loop

main_loopexit:
	rts
;----------

Commands:;;
;	dc.l	1,	printtext1
;	dc.l	1,	printtext2
;	dc.l	1,	printtext3
;	dc.l	1,	printtext4
;	dc.l	170,	startfading1
;	dc.l	20,	startfading2
;	dc.l	1,	printtext1
;	dc.l	1,	printtext2
;	dc.l	1,	printtext3
;	dc.l	1,	printtext4

	dc.l	100,	startfading1
	dc.l	30,	startfading2

	dc.l	1,	printtext1
	dc.l	1,	printtext2
	dc.l	1,	printtext3
	dc.l	1,	printtext4
	dc.l	100,	startfading1
	dc.l	30,	startfading2

	dc.l	1,	printtext1
	dc.l	1,	printtext2
	dc.l	1,	printtext3
	dc.l	1,	printtext4
	dc.l	190,	startfading1
	dc.l	30,	startfading3

	dc.l	60000,	nothing

Nothing:	rts

startfading1:
	bsr.w	Fader2Start_Font1
	rts

startfading2:
	bsr.w	Fader2Start_Font2
	rts

startfading3:
	bsr.w	Fader2Start_Font3
	rts

printtext1:
	bsr.w	print1
	rts

printtext2:
	bsr.w	print2
	rts

printtext3:
	bsr.w	print3
	rts

printtext4:
	bsr.w	print4
	rts

VBI:;;
	move.w	#$7c81,diwstrt(a5)
	move.w	#$ccc1,diwstop(a5)
	move.w	#$003c,ddfstrt(a5)
	move.w	#$00d4,ddfstop(a5)
	move.w	#%1011001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#160,bpl1mod(a5)
	move.w	#160,bpl2mod(a5)

	lea	planes(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl3pth(a5)
	bsr.w	fader2_real
	bsr.w	commander
rts



;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789.![],-:/'@"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
dc.b	"threethousandtwohundredandtwelve"
dc.b	"twothousandeighthundredandeleven"
dc.b	"onethousandsixhundredandfiftytwo"
dc.b	"fourthousandsevenhundredandseven"

dc.b	"       diese seite bitte        "
dc.b	"         ausschneiden,          "
dc.b	"           umhaengen            "
dc.b	"         und abwarten!          "

dc.b	"  last routine is comin' up :   "
dc.b	"      the dotty mountains       "
dc.b	"threethousandandtwentyfour dots "
dc.b	"  please fasten your seatbelt   "




textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=2*17*3
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

Print1:
	lea	planes+8(pc),a0
	lea	font(pc),a1
	lea	Textpoint(pc),a2
	move.w	(a2),d5
	add.w	#32*2,(a2)+
	add.w	d5,a2

	moveq	#31,d6
print1_Xloop:

	move.l	a1,a3
	add.w	(a2)+,a3
	moveq	#17*3-1,d5
print1_Charloop:
	move.w	(a3)+,(a0)
	lea	80(a0),a0
	dbf	d5,print1_Charloop
	lea	2-80*17*3(a0),a0
	dbf	d6,print1_Xloop
	rts

Print2:
	lea	planes+8+80*3*20*1(pc),a0
	lea	font(pc),a1
	lea	Textpoint(pc),a2
	move.w	(a2),d5
	add.w	#32*2,(a2)+
	add.w	d5,a2

	moveq	#31,d6
print2_Xloop:

	move.l	a1,a3
	add.w	(a2)+,a3
	moveq	#17*3-1,d5
print2_Charloop:
	move.w	(a3)+,(a0)
	lea	80(a0),a0
	dbf	d5,print2_Charloop
	lea	2-80*17*3(a0),a0
	dbf	d6,print2_Xloop
	rts

print3:
	lea	planes+8+80*3*20*2(pc),a0
	lea	font(pc),a1
	lea	Textpoint(pc),a2
	move.w	(a2),d5
	add.w	#32*2,(a2)+
	add.w	d5,a2

	moveq	#31,d6
print3_Xloop:

	move.l	a1,a3
	add.w	(a2)+,a3
	moveq	#17*3-1,d5
print3_Charloop:
	move.w	(a3)+,(a0)
	lea	80(a0),a0
	dbf	d5,print3_Charloop
	lea	2-80*17*3(a0),a0
	dbf	d6,print3_Xloop
	rts

print4:
	lea	planes+8+80*3*20*3(pc),a0
	lea	font(pc),a1
	lea	Textpoint(pc),a2
	move.w	(a2),d5
	add.w	#32*2,(a2)+
	add.w	d5,a2

	moveq	#31,d6
print4_Xloop:

	move.l	a1,a3
	add.w	(a2)+,a3
	moveq	#17*3-1,d5
print4_Charloop:
	move.w	(a3)+,(a0)
	lea	80(a0),a0
	dbf	d5,print4_Charloop
	lea	2-80*17*3(a0),a0
	dbf	d6,print4_Xloop
	rts

Font:	incbin	"Data/Font.blt"

Planes:	dcb.b	3*80*80,0


Col_font:
	dc.w $013,$BDC,$7CB,$49A,$259,$149,$138,$028
;	dc.w $113,$EEF,$CCD,$AAC,$88A,$769,$547,$436

Col_white:
	dc.w	$013
;	dc.w	$113
	dcb.w	7,$0fff

Col_black:
	dc.w	$013
	dcb.w	7,$013

Col_realblack:
	dc.w	$000
	dcb.w	7,$000

;	dc.w	$113
;	dcb.w	7,$113

include	"/include/Fader2/Calc1.2.i"

Fader2_Colquant_Font=8			;number of colours in this calculation
Fader2_Tablequant_Font=3;	maximal number of colours in program!!
Fader2_Table_Font:	dcb.w	Fader2_Tablequant_Font*Fader2_Colquant_Font*16
Fader2_Tableend_Font:

Fader2_Font:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_Font,d7	;number of colours

	lea	col_white(pc),a0		;colour source
	lea	col_Font(pc),a1		;colour dest
	lea	fader2_table_Font(pc),a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	col_black(pc),a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc

	lea	col_font(pc),a0		;colour source
	lea	col_realblack(pc),a1	;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	fader2_calc
rts


Fader2Start_Font1:
	move.w	#Fader2_Colquant_Font,fader2_quant
	move.w	#fader2_Tablequant_Font*16/3,fader2_step
	move.w	#2,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Font,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Font,Fader2_pos	;...fade backward
rts


Fader2Start_Font2:
	move.w	#Fader2_Colquant_Font,fader2_quant
	move.w	#fader2_Tablequant_Font*16/3,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
;	move.l	#fader2_table_Font,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Font,Fader2_pos	;...fade backward
rts

Fader2Start_Font3:
	move.w	#Fader2_Colquant_Font*1,fader2_quant
	move.w	#fader2_Tablequant_Font*16/3,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Font+fader2_colquant_Font*16*2*2,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Font,Fader2_pos	;...fade backward
rts

depp:	dc.l	0

Fader2_real:
	tst.w	Fader2_step			;fading finished?
	beq.b	Fader2_skip			;yes-->exit

	subq.w	#1,Fader2_slpcount		;fader sleeping?
	bne.b	Fader2_skip			;yes-->exit
	move.w	Fader2_sleep(pc),Fader2_slpcount	;new sleepcounter
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

codec_e:

ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:

ifne	UseSection
;section	BSSC,bss_c
endif
bssc_s:
bssc_e:

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


