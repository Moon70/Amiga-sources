;------------------------------------------------------------------------
;|                                                                      |
;|                              Jaul u.c.                               |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                         12-May-94 |
;------------------------------------------------------------------------

section	code,code_c
codec_s:

forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize=40*256
intena=$09a
openlibrary=-30-522

bplcon0=$100
bplcon1=$102
bplcon2=$104
bpl1pth=$0e0
bpl1ptl=$0e2
bpl2pth=$0e4
bpl2ptl=$0e6
bpl3pth=$0e8
bpl3ptl=$0ea
bpl4pth=$0ec
bpl4ptl=$0ee
bpl5pth=$0f0
bpl5ptl=$0f2
bpl6pth=$0f4
bpl6ptl=$0f6
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
;--------------------------------
	jmp	start		;
	jmp	main_init	;
	jmp	main_program	;
	jmp	main_back	;
	rts			;
;--------------------------------
;------------------------------------------------
start:						;
	move.l	4.w,a6				;
	jsr	forbid(a6)			;
	lea	$dff000,a5			;
	move.w	#%0000001111100000,dmacon(a5)	;
	move.w	#%0000000001100000,intena(a5)	;
	move.l	$6c.w,oldint			;
	move.l	#main_vbi,$6c.w			;
	move.w	#%1100000000100000,intena(a5)	;
	move.w	#%1000001101000000,dmacon(a5)	;
	lea	fakemain_vbiuser(pc),a0		;
	lea	fakemain_copperlist(pc),a1	;
	lea	fakemain_talk(pc),a2		;
	bsr.w	main_init			;
	bsr.w	main_program			;
wait:						;
	btst.b	#6,ciaapra			;
	beq.b	back				;
	tst.w	f_endprogram			;
	beq.b	wait				;
back:						;
	move.l	oldint,$6c.w			;
	move.l	4.w,a6				;
	lea	gfxname(pc),a1			;
	moveq	#0,d0				;
	jsr	openlibrary(a6)			;
	move.l	d0,a0				;
	lea	$dff000,a5			;
	move.l	38(a0),cop1lch(a5)		;
	move.w	#0,copjmp1(a5)			;
	move.w	#%1000001111100000,dmacon(a5)	;
	move.l	4.w,a6				;
	jsr	permit(a6)			;
	moveq	#0,d0				;
	rts					;
;-----------------------------------------------;
;--------------------------------------------------------
main_vbiuser:		dc.l	0			;
fakemain_vbiuser:	dc.l	0			;
main_copperlist:	dc.l	0			;
fakemain_copperlist:	dc.l	main_emptycopperlist	;
main_talk:		dc.l	0			;
fakemain_talk:		dc.l	0			;
oldint:			dc.l	0			;
main_emptycopperlist:	dc.l	-2			;
intflag:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
f_endprogram:		dc.w	0			;
;--------------------------------------------------------
;----------------------------------------------------------------
main_vbi:							;
	btst.b	#5,$dff01f					;
	beq.b	main_vbiback					;
	movem.l	d0-a6,-(a7)					;
;--------------------------					;
	lea	$dff000,a5					;
	lea	main_vbiuser(pc),a0 ;adress of UserVbiAdress	;
	move.l	(a0),a0		;adress of UserVbi		;
	tst.l	(a0)						;
	beq.b	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;
	lea	main_copperlist(pc),a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq.b	nomain_copperlist				;
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
	move.w	#0,copjmp1(a5); should be removed!!		;
nomain_copperlist:						;
ifd	showtime						;
	move.w	#$0f00,$dff180					;
endif								;
	movem.l	(a7)+,d0-a6					;
ifd	showtime						;
	move.w	#$0000,$dff180					;
endif								;
main_vbiback:							;
	move.w	#%0000000001100000,$dff09c			;
	rte							;
;----------------------------------------------------------------

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
commander:; v4.1 last optimizing: 93-10-30
	lea	comsleep(pc),a0		;  8
	subq.w	#1,(a0)+		; 12
	beq.b	commanderl1		; 10 (true), 8 (false)
	rts				; 16
commanderl1:
	move.w	(a0),d0			;  8
	addq.w	#8,(a0)			; 12
	lea	commands+2(pc,d0.w),a1	; 12
	move.w	(a1)+,-(a0)		; 12
	move.l	(a1),a0			; 12
	jmp	(a0)			;  8
comsleep:	dc.w	1	;|
compoint:	dc.w	0	;|
commands:;;
		dc.l	5000,	nothing
		dc.l	60001,	setente
;---------------------------------------------
setente:
	move.w	#1,f_endprogram
	subq.w	#8,compoint
	rts

nothing:	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	movem.l	d0-a6,-(a7)
	movem.l	(a7)+,d0-a6
	rts
;----------

Main_program:;;
	movem.l	d0-a6,-(a7)
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)

	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	move.l	#$298129c1,diwstrt(a5)
	move.l	#$003800d0,ddfstrt(a5)
	moveq	#0,d0
	move.l	d0,bplcon1(a5)
	move	#-40,d0
	move.w	d0,bpl1mod(a5)
	move.w	d0,bpl2mod(a5)
	move.w	#%0101001000000000,bplcon0(a5)

	move.l	planepoint(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	testpiccol(pc),a0
	lea	$180(a5),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

	bsr.b	animate
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------

animate:
	lea	planepoint(pc),a0
	move.l	(a0),a1
	lea	5*40(a1),a1
	cmp.l	#testpic+5*40*35,a1
	bne.b	noanimrestart
	lea	testpic(pc),a1
	move.w	#1,comsleep
	rts
noanimrestart:
	move.l	a1,(a0)
	rts

testpiccol:
	dc.w $000,$F43,$0F0,$0F0,$0F0,$0F0,$0F0,$0F0
	dc.w $666,$777,$999,$AAA,$BBB,$CCC,$EEE,$FFF
	dc.w $111,$333,$555,$777,$999,$BBB,$DDD,$FFF
	dc.w $00F,$00F,$00F,$00F,$00F,$00F,$00F,$00F

planepoint:	dc.l	testpic


testpic:	incbin	"data/Jaulpic1.blt"

codec_e:
datac_s:
datac_e:
bssc_s:
bssc_e:
codep_s:
codep_e:
datap_s:
datap_e:
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


