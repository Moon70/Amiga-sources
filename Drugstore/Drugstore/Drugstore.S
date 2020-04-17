;------------------------------------------------------------------------
;|                                                                      |
;|                                Drugpic                               |
;|                               ---------                              |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                  Jan-94 |
;------------------------------------------------------------------------

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
section	code,code_c
codec_s:
;--------------------------------
	jmp	start		;
	jmp	main_init	;
	jmp	main_program	;
	jmp	main_back	;
	rts			;
;--------------------------------
;--------------------------------------------------------
start:							;
	move.l	4.w,a6					;
	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001100000,intena(a5)		;
	move.l	$6c.w,oldint				;
	move.l	#main_vbi,$6c.w				;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000100000,intena(a5)		;
	move.w	#%1000001111000000,dmacon(a5)		;
	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
	bsr.w	main_init				;
	bsr.w	main_program				;
wait:							;
	btst.b	#6,ciaapra				;
	beq.b	back					;
	tst.w	f_endprogram				;
	beq.b	wait					;
back:							;
	move.l	oldint,$6c.w				;
	move.l	4.w,a6					;
	lea	gfxname(pc),a1				;
	moveq	#0,d0					;
	jsr	openlibrary(a6)				;
	move.l	d0,a0					;
	lea	$dff000,a5				;
	move.l	38(a0),cop1lch(a5)			;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1000001111100000,dmacon(a5)		;
	move.l	4.w,a6					;
	jsr	permit(a6)				;
	moveq	#0,d0					;
	rts						;
;--------------------------------------------------------
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
f_endprogram:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
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
	bpl.b	noempty_copperlist
	lea	main_emptycopperlist(pc),a1
	move.l	a1,cop1lch(a5)					;
	clr.l	(a0)						;
	bra.b	nomain_copperlist				;
noempty_copperlist:
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
;	move.w	#0,copjmp1(a5); should be removed!!		;
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
		dc.l	240,	setint_fadepicin
		dc.l	46,	setint_fadepicout
		dc.l	1,	setente
		dc.l	60000,	commandrestart
;---------------------------------------------
commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	move.w	#1,f_endprogram
;	lea	main_copperlist(pc),a1
;	move.l	(a1),a1
;	move.l	#main_emptycopperlist,(a1)
	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	bsr.w	coppercopy
	bsr.w	fadetest
	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	movem.l	d0-a6,-(a7)
;---
;---
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
	lea	$dff000,a5
	move.w	#1,intflag
	bsr.w	commander
	rts
;----------

;---------------------------------------------
setint_fadepicin:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#200+240,bpl1mod(a5)
	move.w	#200+240,bpl2mod(a5)
	move.w	#%0110001000000100,bplcon0(a5)
	move.w	#%1000001100000000,dmacon(a5)
	btst.b	#7,$004(a5)
	bne.b	sf_badframe


	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_fadein,(a0)

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#copperlist1,(a1)
	move.w	#%1000001110000000,dmacon(a5)


	lea	$180(a5),a1
	moveq	#15,d0
colcopyloop:
	move.l	#0,(a1)+
	dbf	d0,colcopyloop

	move.w	#64,fader_direct
	move.w	#fadequant1*2,fader_direct
	rts
sf_badframe:
	subq.w	#8,compoint
	move.w	#1,comsleep
	move.w	#%0000001000000100,bplcon0(a5)
	rts

setint_fadepicout:
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_fadeout,(a0)
	rts
;------------------------------------------------------------------------


int_fadein:
	bsr.w	fader_real
	bsr.w	fader_real
	bsr.w	fader_real
	bsr.w	commander
	move.w	#1,intflag
	rts

int_fadeout:
	cmp.w	#-32,fadout_sleeptest
	beq.b	fadefin
	moveq	#0,d0
	lea	fadout_offsets(pc),a1
	lea	fadout_sleep(pc),a2

	moveq	#15,d6
fadeoutloop2:
	move.l	(a1)+,a0
	add.l	#drugpic,a0
	subq.w	#1,(a2)+
	bpl.b	skipline
	add.l	#240,-4(a1)
	
	moveq	#59,d7
fadeoutloop1:
	move.l	d0,(a0)+
	dbf	d7,fadeoutloop1
skipline:
	dbf	d6,fadeoutloop2
fadefin:
	bsr.w	commander
	move.w	#1,intflag
	rts

fadout_offsets:
	dc.l	00*32*240
	dc.l	01*32*240
	dc.l	02*32*240
	dc.l	03*32*240
	dc.l	04*32*240
	dc.l	05*32*240
	dc.l	06*32*240
	dc.l	07*32*240
	dc.l	08*32*240
	dc.l	09*32*240
	dc.l	10*32*240
	dc.l	11*32*240
	dc.l	12*32*240
	dc.l	13*32*240
	dc.l	14*32*240
	dc.l	15*32*240

fadout_sleep:
	dc.w	00
	dc.w	01
	dc.w	02
	dc.w	03
	dc.w	04
	dc.w	05
	dc.w	06
	dc.w	07
	dc.w	08
	dc.w	09
	dc.w	10
	dc.w	11
	dc.w	12
	dc.w	13
	dc.w	14
fadout_sleeptest:
	dc.w	15



coppercopy:
	lea	copperlist1(pc),a0
	move.l	#drugpic,d0
	move.l	#copperlist2,d1
	bsr.b	putlist

	lea	copperlist2(pc),a0
	move.l	#drugpic+240,d0
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


drugcol2:;source
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000

drugcol3:;destination
dc.w $000,$332,$110,$030,$050,$080,$1C0,$09D
dc.w $048,$035,$200,$800,$B20,$BA7,$A96,$985
dc.w $874,$763,$652,$541,$430,$FFF,$06A,$554
dc.w $443,$111,$333,$444,$555,$777,$AAA,$CCC
dc.w $000,$332,$110,$030,$050,$080,$1C0,$09D
dc.w $048,$035,$200,$800,$B20,$BA7,$A96,$985
dc.w $874,$763,$652,$541,$430,$FFF,$06A,$554
dc.w $443,$111,$333,$444,$555,$777,$AAA,$CCC


fadetest:
;	lea	drugcol4,a0
;	moveq	#fadequant1,d7	;number of colours
;	jsr	fader_makegrey

fadequant1=32	;number of colours in this calculation

	lea	drugcol2(pc),a0	;source-colourstable
	lea	drugcol3(pc),a1	;destination-colourtable
	lea	fader_table(pc),a2	;point in fader-table
	moveq	#%100,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr.w	fader_calc


	lea	fader_table+15*fadequant1*2(pc),a0
	lea	drugcol3(pc),a1
	lea	fader_table+16*fadequant1*2(pc),a2
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr.w	fader_calc

	lea	fader_table(pc),a2
	move.w	#-1,2*16*fadequant1*2(a2)	;set endmark in colourlist

rts


fader_maxnum=32*3;;	maximal number of colours in program!!

fader_colnum:	dc.w	0

dc.w	-1
fader_table:	dcb.w	fader_maxnum*16
dc.w	-1
fader_pos:	dc.l	fader_table
fader_direct:	dc.w	0
fader_sleep:	dc.w	2
fader_slpcount:	dc.w	1


;----------
fader_real:
	move.w	fader_direct,d0
	beq.b	fader_skip
	subq.w	#1,fader_slpcount
	bne.b	fader_skip
	move.w	fader_sleep,fader_slpcount

	move.l	fader_pos,a0
	tst.w	(a0)
	bmi.b	fader_end

	moveq	#31,d0
	lea	$180(a5),a1
fader_copy:
	move.w	(a0)+,(a1)+
	dbf	d0,fader_copy
	move.l	a0,fader_pos
	rts
fader_end:
	neg.w	d0
	add.w	d0,a0
	move.l	a0,fader_pos
	move.w	#0,fader_direct
fader_skip:
	rts
;----------
;---------------
fader_calc:;V2.0
	move.w	d7,d0
	subq.w	#1,d7	;colour counter
	add.w	d0,d0	;table offset
	move.w	d1,-(a7)

fader_l1:
	move.w	#0,(a2)	;clear colour
	move.w	(a7),d1
	roxr.w	#1,d1
	bcc.b	fader_skipblue
;blue:
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4	;startpos/solution
	move.w	(a1),d3	;rgb-col dest
	and.w	#15,d3	;b-col dest
	swap	d3
	move.w	(a0),d4
	and.w	#15,d4	;b-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl.b	fader_noblueflow
	sub.l	d3,d4
fader_noblueflow:
	
	moveq	#15,d6	;rgb counter
fader_calcblue:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcblue
fader_skipblue:

	roxr.w	#1,d1
	bcc.b	fader_skipgreen
;green
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3	;rgb-col dest
	lsr.w	#4,d3	;rg-col dest
	and.w	#15,d3	;g-col dest
	swap	d3
	move.w	(a0),d4	;g-col src
	lsr.w	#4,d4
	and.w	#15,d4	;g-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl.b	fader_nogreenflow
	sub.l	d3,d4
fader_nogreenflow:
	moveq	#15,d6	;rgb counter
fader_calcgreen:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#4,d5	;shift green-value to green bit-position
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcgreen
fader_skipgreen:
	roxr.w	#1,d1
	bcc.b	fader_skipred
;red
	
	move.l	a2,a3	;destination adress
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3	;rgb-col dest
	lsr.w	#8,d3	;r-col dest
	swap	d3
	move.w	(a0),d4	;rgb-col src
	lsr.w	#8,d4	;r-col src
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl.b	fader_noredflow	
	sub.l	d3,d4
fader_noredflow:
	moveq	#15,d6	;rgb counter
fader_calcred:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#8,d5	;shift red-value to red bit-position
	or.w	d5,(a3)
	add.w	d0,a3	;next position in table for this colour
	dbf	d6,fader_calcred
fader_skipred:
	addq.l	#2,a0
	addq.l	#2,a1
	addq.l	#2,a2
	dbf	d7,fader_l1

	move.w	(a7)+,d1
	rts
;----------
;fader_makegrey:
;	subq.w	#1,d7
;fader_makegreyloop:
;	moveq	#0,d0
;	move.w	(a0),d0
;	move.w	d0,d1
;	move.w	d0,d2
;	and.w	#%1111,d0	;red
;	lsr.w	#4,d1
;	and.w	#%1111,d1	;green
;	lsr.w	#8,d2		;blue
;	add.w	d1,d0
;	add.w	d2,d0
;	divu	#3,d0
;	move.w	d0,d1
;	lsl.w	#4,d0
;	or.w	d1,d0
;	lsl.w	#4,d0
;	or.w	d1,d0
;	move.w	d0,(a0)+
;	dbf	d7,fader_makegreyloop
;	rts


;------------------------------------------------------------------------

drugframe1:	dc.l	drugpic
drugframe2:	dc.l	drugpic+240


copperlist1:
	dcb.b	64,0
	dc.l	-2

copperlist2:
	dcb.b	64,0
	dc.l	-2

drugpic:	incbin	"data/Drugstore.con"
drugpicend:


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


