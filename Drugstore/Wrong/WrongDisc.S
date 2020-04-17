;------------------------------------------------------------------------
;|                               Wrong Disc                             |
;|                              ------------                            |
;|                                                                      |
;| booting from disc2...                                                |
;|                                                                      |
;| code by Moon/ABYSS                                                   |
;------------------------------------------------------------------------
Showtime=0
Program_ID=1
main_initcall2=0
UseSection=1


ifne	UseSection
section	CodeC,code_c
endif
codec_s:
Main_Enable_Jp60music=0
Main_Enable_Setintflag=0
Main_Enable_Jcommander=0
Main_Enable_Exit=0
include	"/maininit/Maininit6.01.s"
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	bsr.w	Fader2_Disc2
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
	move.w	#$003c,ddfstrt(a5)
	move.w	#$00d4,ddfstop(a5)
	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#240,bpl1mod(a5)
	move.w	#240,bpl2mod(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)

	lea	Col_Screen(pc),a0
	lea	$180(a5),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	bsr.w	Fader2Start_Disc2

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
	bra	main_loopexit
	rts
;----------

Commands:;;

VBI:
	lea	screen(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl4pth(a5)
	move.w	#%1100001000000000,bplcon0(a5)

	bsr.w	Fader2_real
rts


Col_Empty:	dcb.w	16,$211

Col_Disc2:
Col_Screen:
dc.w $211,$221,$223,$444,$556,$655,$665,$667
dc.w $778,$877,$987,$989,$BAA,$CBB,$CCD,$EDE


include	"/include/Fader2/Calc1.2.i"

Fader2_Colquant_Disc2=16			;number of colours in this calculation
Fader2_Tablequant_Disc2=1;	maximal number of colours in program!!
Fader2_Table_Disc2:	dcb.w	Fader2_Tablequant_Disc2*Fader2_Colquant_Disc2*16
Fader2_Tableend_Disc2:

Fader2_Disc2:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_Disc2,d7	;number of colours

	lea	col_Empty,a0		;colour source
	lea	col_Disc2,a1		;colour dest
	lea	fader2_table_Disc2,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

rts


Fader2Start_Disc2:
	move.w	#Fader2_Colquant_Disc2,fader2_quant
	move.w	#fader2_Tablequant_Disc2*16,fader2_step
	move.w	#2,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Disc2,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Disc2,Fader2_pos	;...fade backward
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

Screen:
	incbin	"data/Disk2.blt"

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


