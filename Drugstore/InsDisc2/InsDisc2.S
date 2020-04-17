;------------------------------------------------------------------------
;|                                                                      |
;|                         Loading/Insert Disc2                         |
;|                        ----------------------                        |
;|                                                                      |
;| Routine code (number)=15 $0f                                         |
;|                                                                      |
;| Valid talk messages:                                                 |
;| $xxxx 00 0f  endcode 			routine --> mainpart                |
;| $xxxx 01 0f  change pic 			routine <-- mainpart                |
;| $xxxx 02 0f  change pic done			routine --> mainpart            |
;| $xxxx 03 0f  fade pic out			routine <-- mainpart            |
;| (fade pic out done=endcode)                                          |
;|                                                                      |
;|                                                                      |
;| code by Moon                                                  Oct-94 |
;------------------------------------------------------------------------

section	code,code_c
codec_s:

showtime=0
Program_ID=1
Main_Initcall2=0
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
commands:;;
		dc.l	150,	setint_fadepicin
		dc.l	1,	setente
		dc.l	60000,	commandrestart
;---------------------------------------------
commandrestart:
	lea	Commander_Point(pc),a0
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
	move.l	a0,main_VBIVector
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	lea	bssc_s,a0
	move.w	#(bssc_e-bssc_s)/4-1,d7
	moveq	#0,d0
bssc_clr:
	move.l	d0,(a0)+
	dbf	d7,bssc_clr

	bsr.w	coppercopy
	bsr.w	fadetest
	bsr.w	putpic

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
	lea	Main_VBIVector(pc),a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)
	lea	$180(a5),a0
	move.l	#$0fff0fff,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
;---
;testwait:
;	btst	#7,ciaapra
;	bne	nofire
;	move.l	main_talk(pc),a0
;	move.w	#$010f,(a0)	;change pic

;nofire:

;	btst	#10,$dff016
;	bne	noright
;	move.l	main_talk(pc),a0
;	move.w	#$030f,(a0)	;change pic

;noright:


;	btst	#6,ciaapra
;	bne	testwait
;---
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
	move.w	#$f181,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#240+320,bpl1mod(a5)
	move.w	#240+320,bpl2mod(a5)
	move.w	#%1100001000000100,bplcon0(a5)
	move.w	#%1000001100000000,dmacon(a5)
	btst.b	#7,$004(a5)
	bne.b	sf_badframe


	lea	Main_VBIVector(pc),a0
	move.l	(a0),a0
	move.l	#int_fadein,(a0)

	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	move.l	#copperlist1,(a1)
	move.w	#%1000001110000000,dmacon(a5)


;	lea	$180(a5),a1
;	moveq	#15,d0
;colcopyloop:
;	move.l	#$00f0,(a1)+
;	dbf	d0,colcopyloop

	move.w	#64,fader_direct
	move.w	#fadequant1*2,fader_direct
	rts
sf_badframe:
	subq.w	#8,Commander_Point
	move.w	#1,Commander_Sleep
	move.w	#%0000001000000100,bplcon0(a5)
	rts

;------------------------------------------------------------------------


int_fadein:
	bsr.w	fader_real
	bsr.w	fader_real
	bsr.w	fader_real
	bsr.w	commander
	bsr.b	coppercopy
	bsr.b	talker
	move.w	#1,intflag
	rts

talker:
	move.l	main_talk(pc),a0
	cmp.w	#$010f,(a0)	;change pic
	bne.b	talker_nochangepic
	move.w	#1,f_screenmove
talker_nochangepic:

	cmp.w	#$030f,(a0)	;pic out
	bne.b	talker_nopicout
	move.w	#1,f_screenmove
talker_nopicout:


rts


screenoffset:	dc.w	90
screenoffsetdir:	dc.w	-2
f_screenmove:	dc.w	0

coppercopy:
	lea	screenoffset(pc),a0
	move.w	(a0),d2
tst.w	f_screenmove
beq.b	coppercopy_skipmove
	add.w	screenoffsetdir,d2
coppercopy_skipmove:
	bmi.b	coppercopy_changedir
	cmp.w	#90,d2
	ble.b	coppercopy_scrmoveok
	move.w	#0,f_screenmove
	move.l	main_talk(pc),a1
	move.w	#$020f,(a1)	;change pic done

	bra.b	coppercopy_skippicchng
coppercopy_changedir:	
	movem.l	d0-a6,-(a7)
	bsr.w	putpic
	movem.l	(a7)+,d0-a6
	move.l	main_talk(pc),a1
	cmp.w	#$030f,(a1)	;pic out?
	bne.b	coppercopy_skippicchng
	move.w	#$000f,(a1)
	sub.w	screenoffsetdir,d2
	move.w	#0,screenoffsetdir
coppercopy_skippicchng:
	neg.w	screenoffsetdir
	add.w	screenoffsetdir,d2
coppercopy_scrmoveok:
	move.w	d2,(a0)
	mulu	#80*4,d2
	lea	copperlist1(pc),a0
	move.l	#Screen,d0
	add.l	d2,d0
	move.l	#copperlist2,d1
	bsr.b	putlist

	lea	copperlist2(pc),a0
	move.l	#Screen+320,d0
	add.l	d2,d0
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
	swap	d0

	add.l	#80,d0
	move.w	#bpl5ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl5pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	add.l	#80,d0
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
dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000
dc.w $000,$000,$000,$000,$000,$000,$000,$000

drugcol3:;destination
dc.w $000,$FFF,$DDE,$BCD,$9BC,$89B,$68A,$579
dc.w $468,$357,$246,$135,$124,$023,$301,$302

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
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr.w	fader_calc

	lea	fader_table(pc),a2
	move.w	#-1,1*16*fadequant1*2(a2)	;set endmark in colourlist

rts


fader_maxnum=32*3;;	maximal number of colours in program!!

fader_colnum:	dc.w	0

dc.w	-1
fader_table:	dcb.w	fader_maxnum*16
dc.w	-1
fader_pos:	dc.l	fader_table
fader_direct:	dc.w	0
fader_sleep:	dc.w	8
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


putpic_name:	dc.l	loading,insdisc2
putpic:
	lea	putpic_name(pc),a1
	move.l	(a1),a0
	move.l	4(a1),(a1)
	move.l	a0,4(a1)
	lea	screen,a1
	add.l	#80*4*(432+90-400)+2,a1
	move.w	#279,d7
putpic_ly:
	moveq	#7,d6
putpic_lx:
	move.l	(a0)+,(a1)+
	dbf	d6,putpic_lx
	lea	80-32(a1),a1
	dbf	d7,putpic_ly
rts
;------------------------------------------------------------------------

f_endprogram:	dc.w	0
drugframe1:	dc.l	Screen
drugframe2:	dc.l	Screen+320


copperlist1:
	dcb.b	64,0
	dc.l	-2

copperlist2:
	dcb.b	64,0
	dc.l	-2

Loading:	incbin	"data/Loading.blt"
Insdisc2:	incbin	"data/Insdisc2.blt"



codec_e:
datac_s:
datac_e:
;-------------------
section	memory,bss_c
bssc_s:
Screen:
	ds.b	80*4*90
	ds.b	80*056*4*2
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


