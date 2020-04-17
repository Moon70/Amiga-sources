;------------------------------------------------------------------------
;|                                                                      |
;|                          Not enough emory                            |
;|                         ------------------                           |
;|                                                                      |
;|                                                                      |
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

	bsr.w	coppercopy

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
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#120,bpl1mod(a5)
	move.w	#120,bpl2mod(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)

	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist,(a0)

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

VBI:
rts

Coppercopy:
	lea	copperlist(pc),a0
	move.l	#screen,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	move.w	#bpl1pth,(a0)+
	swap	d0
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	move.w	#bpl2pth,(a0)+
	swap	d0
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	move.w	#bpl3pth,(a0)+
	swap	d0
	move.w	d0,(a0)+
	swap	d0

	add.l	#40,d0
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	move.w	#bpl4pth,(a0)+
	swap	d0
	move.w	d0,(a0)+

	lea	Col_Screen(pc),a1
	move.w	#$0180,d0
	moveq	#15,d7
Coppercopy_colcopyloop:
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d0
	dbf	d7,Coppercopy_colcopyloop

	move.l	#-2,(a0)
	rts

Copperlist:
	dcb.b	364,0

Col_Screen:
dc.w $201,$FFE,$EED,$DDB,$CCA,$BB9,$A98,$987
dc.w $876,$865,$754,$644,$533,$422,$322,$211

Screen:
	incbin	"data/Lomem.blt"


codec_e:
;------------------------------------------------------------------------
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


