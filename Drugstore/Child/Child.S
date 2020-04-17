;------------------------------------------------------------------------
;|                                                                      |
;|                                 Child                                |
;|                                -------                               |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                         |
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
	bsr.w	Fader2_Agonyface
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
	lea	$dff000,a5
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0101001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#160,bpl1mod(a5)
	move.w	#160,bpl2mod(a5)
	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)


	lea	$180(a5),a0
	moveq	#0,d0
rept	16
	move.l	d0,(a0)+
endr


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
	dc.l	1,	set_Child
	dc.l	270,	fadein
	dc.l	16,	fadeout
	dc.l	1,	set_Agonyface
	dc.l	270,	fadein
	dc.l	16,	fadeblack


	dc.l	60000,	nothing

nothing:	rts

fadeout:
	move.w	#Fader2_Colquant_Agonyface,fader2_quant
	move.w	#fader2_Tablequant_Agonyface*16/2,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

;	move.w	#1,fader2_direct		;this combination to...
;	move.l	#fader2_table_Agonyface,Fader2_pos	;...fade forward

	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Agonyface,Fader2_pos	;...fade backward
	rts

fadein:
	move.w	#Fader2_Colquant_Agonyface,fader2_quant
	move.w	#fader2_Tablequant_Agonyface*16/2,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Agonyface,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Agonyface,Fader2_pos	;...fade backward
	rts

fadeblack:
	move.w	#Fader2_Colquant_Agonyface,fader2_quant
	move.w	#fader2_Tablequant_Agonyface*16/2,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
;	move.l	#fader2_table_Agonyface,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Agonyface,Fader2_pos	;...fade backward
	rts


set_Agonyface:
	move.l	#Agonyface,pic
	rts

set_Child:
	move.l	#Child,pic
	rts


VBI:
	move.l	pic(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)

	bsr.w	Fader2_real	
	bsr.w	Commander
rts


pic:	dc.l	Child

Col_Agonyface:
	dc.w $311,$EEE,$EDB,$DC8,$DB6,$DA4,$C91,$C80
	dc.w $B70,$A60,$950,$840,$730,$620,$510,$410
	dc.w $FFE,$EED,$DDB,$DCA,$CB9,$BA8,$A97,$986
	dc.w $975,$864,$754,$643,$532,$522,$421,$200
Col_Child:
	dc.w $311,$EEE,$EDB,$DC8,$DB6,$DA4,$C91,$C80
	dc.w $B70,$A60,$950,$840,$730,$620,$510,$410
	dc.w $FFE,$EED,$DDB,$DCA,$CB9,$BA8,$A97,$986
	dc.w $975,$864,$754,$643,$532,$522,$421,$200

Col_Begin:	dcb.w	32,$0fff
Col_black:	dcb.w	32,$0000


include	"/include/Fader2/Calc1.2.i"
;include	"/include/Fader2/Makegrey1.1.i"

Fader2_Colquant_Agonyface=32	;number of colours in this calculation
Fader2_Tablequant_Agonyface=2;	maximal number of colours in program!!
Fader2_Table_Agonyface:	dcb.w	Fader2_Tablequant_Agonyface*Fader2_Colquant_Agonyface*16
Fader2_Tableend_Agonyface:


Fader2_Agonyface:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_Agonyface,d7	;number of colours

;	lea	col_Agonyface,a0		;colour source
;	lea	col_gray,a1		;colour dest
;	jsr	Fader2_makegrey		;make gray

	lea	col_Begin,a0		;colour source
	lea	col_Agonyface,a1		;colour dest
	lea	fader2_table_Agonyface,a2	;point in fader-table
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

	lea	col_black,a1		;colour dest
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc
rts


Fader2Start_Agonyface:
	move.w	#Fader2_Colquant_Agonyface,fader2_quant
	move.w	#fader2_Tablequant_Agonyface*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Agonyface,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Agonyface,Fader2_pos	;...fade backward
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


Agonyface:	incbin	"data/Agonyface.blt"
Child:		incbin	"data/Child.blt"

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


