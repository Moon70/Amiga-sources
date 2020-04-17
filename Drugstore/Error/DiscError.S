;------------------------------------------------------------------------
;|                                                                      |
;|                               Disc Error                             |
;|                              ------------                            |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                         |
;------------------------------------------------------------------------

UseSection=1

ifne	UseSection
section	CodeC,code_c
endif
codec_s:

Showtime=0
Program_ID=1
main_initcall2=0

include	"/maininit/Maininit6.0000.s"
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
	move.w	#$a181,diwstrt(a5)
	move.w	#$a7c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0011001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#80,bpl1mod(a5)
	move.w	#80,bpl2mod(a5)

	move.l	Main_VBR(pc),a0
	move.l	#VBI,$6c(a0)

	move.l	#copperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)

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
	btst.b	#5,$dff01f
	beq.b	VBI_vbiback
	movem.l	d0-a6,-(a7)

	movem.l	(a7)+,d0-a6
VBI_vbiback:
	move.w	#%0000000001100000,$dff09c
	rte

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

	move.l	#$01800000,(a0)+
	move.l	#$01820bba,(a0)+
	move.l	#$01840ccb,(a0)+
	move.l	#$01860ffe,(a0)+
	move.l	#$01880888,(a0)+
	move.l	#$018a0555,(a0)+
	move.l	#$018c0333,(a0)+
	move.l	#$018e0999,(a0)+

	move.l	#-2,(a0)
	rts

Copperlist:
	dcb.b	64,0

Screen:
	incbin	"data/Diskerror.blt"


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


