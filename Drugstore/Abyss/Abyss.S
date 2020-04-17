;------------------------------------------------------------------------
;|                                                                      |
;|                        ABYSS-part of DRUGSTORE                       |
;|                                                                      |
;| Part 1, the logo and the bars, will be calculated in this program    |
;| Part 2, the vectorbar, is uncrunched at the end of this program      |
;|  It will be relocated and initialized during Part 1 is running       |
;| Part 1 doesn't use blitter, Part 2 does                              |
;|                                                                      |
;| code by Moon/ABYSS                                         27-Feb-94 |
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
mce_s:
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
		dc.l	83,	setint_test
		dc.l	40,	setmover_hor1
		dc.l	19,	setmover_hor2
		dc.l	6,	stop
rept 51
	dc.l	1,go
endr
	dc.l	1,go
		dc.l	120,	setmover_dontmove

		dc.l	1,	setdotpic
		dc.l	60000,	set_dotpicrunning
		dc.l	1,	setente
		dc.l	60000,	commandrestart
;---------------------------------------------
nothing:	rts
commandrestart:
	lea	compoint(pc),a0
	move.w	#0,(a0)
	rts

setente:
	move.w	#1,f_endprogram
	lea	main_talk(pc),a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts
set_dotpicrunning:
	lea	main_talk(pc),a0
	move.l	(a0),a0
	move.w	#2,(a0)
	rts

setmover_hor1:
	move.l	#mover_horizontal1,moverpart
rts

setmover_hor2:
	move.l	#mover_horizontal2,moverpart
rts

setmover_vert:
	move.l	#mover_vertical,moverpart
rts
go:
	move.l	#mover_vertical,moverpart
rts
stop:
	move.l	#0,moverpart
rts

setmover_dontmove:
	move.l	#0,moverpart
;	move.w	#1,waitforvector
	lea	vector+12,a6
	jsr	(a6)
	lea	main_vbiuser(pc),a0
	move.l	(a0),a0
	move.l	#int_dotpic,(a0)
	move.w	#fadequant1*2,fader_direct
	rts


setdotpic:
	lea	main_copperlist(pc),a1
	move.l	(a1),a1
	lea	cop1lch(a5),a1
	move.l	#copperlist,(a1)
	move.w	#0,copjmp1(a5)

	move.w	#$8f81,diwstrt(a5)
	move.w	#$00c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#40*3,bpl1mod(a5)
	move.w	#40*3,bpl2mod(a5)
	move.w	#%0100001000000000,bplcon0(a5)

	lea	$180(a5),a0
	lea	dotpiccol(pc),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	#0,fakemain_vbiuser2
rts

setint_test:
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$003c,ddfstrt(a5)
	move.w	#$00d4,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#80*3,bpl1mod(a5)
	move.w	#80*3,bpl2mod(a5)
	move.w	#%1100001000000000,bplcon0(a5)

	bsr.w	Fader2Start_abyss
	bsr.w	fader2_real
	rts

;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	bsr.w	fadetest
	bsr.w	fader2_abyss
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
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)

	lea	vector,a0
	lea	crunched,a1
	bsr.w	determ
	lea	vector,a0
	bsr.w	relocator	;relocate memory
	lea	vector+6,a6
	move.l	main_vbiuser2,a0
	move.l	main_copperlist,a1
	move.l	main_talk2,a2
	jsr	(a6)
	movem.l	(a7)+,d0-a6
	rts

main_intuser:;;
	lea	$dff000,a5
	lea	abyss(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	80(a0),a0
	move.l	a0,bpl4pth(a5)
	bsr.w	fader2_real

	lea	moverpart(pc),a0
	tst.l	(a0)
	beq.b	skipmover
	move.l	(a0),a0
	jsr	(a0)

skipmover:
	move.w	#1,intflag
	bsr.w	commander

	rts
;----------





;-----------

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
main_talk2:	dc.l	fakemain_talk2
main_vbiuser2:	dc.l	fakemain_vbiuser2
fakemain_talk2:	dc.l	0
fakemain_vbiuser2:	dc.l	0
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;---------


;----------

int_dotpic:
	lea	$dff000,a5
	bsr.w	commander
	lea	main_vbiuser2(pc),a0
	move.l	(a0),a0
	tst.l	(a0)
	beq.b	nomain_uservbi2
	move.l	(a0),a0
	jsr	(a0)
	bra.b	nodotpic
nomain_uservbi2:

	lea	dotpic(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40(a0),a0
	move.l	a0,bpl4pth(a5)
	bsr.w	fader_real

nodotpic:
rts

moverpart:	dc.l	0
waitforvector:	dc.w	0

mover_horizontal1:
	addq.w	#1,bar1x1
	subq.w	#1,bar2x1
	bsr.b	drawbars
rts

mover_horizontal2:
	addq.w	#1,bar1x1
	addq.w	#1,bar1x2
	subq.w	#1,bar2x1
	subq.w	#1,bar2x2
	bsr.b	drawbars
rts

mover_vertical:
	add.l	#80*4,bar1y1
	add.w	#80*4,bar1y2
	sub.l	#80*4,bar2y1
	sub.w	#80*4,bar2y2
	bsr.w	drawbars2
rts


bar1x1:	dc.w	0		;pos
bar1x2:	dc.w	0		;pos
bar1y1:	dc.l	55*80*4		;pos
bar1y2:	dc.w	12		;size

bar2x1:	dc.w	79		;pos
bar2x2:	dc.w	79		;pos
bar2y1:	dc.l	173*80*4	;pos
bar2y2:	dc.w	12		;size



drawbars:
	lea	abyss(pc),a0
	add.l	bar1y1,a0

	move.l	a0,a1
	add.w	bar1x2,a1
	move.w	bar1y2,d7
drawbarsl1:			;clear left border
	move.b	#0,(a1)
	lea	80*4(a1),a1
	dbf	d7,drawbarsl1

	move.l	a0,a1
	add.w	bar1x1,a1
	move.w	bar1y2,d7
drawbarsl2:			;draw right border
	move.b	#-1,(a1)
	lea	80*4(a1),a1
	dbf	d7,drawbarsl2



	lea	abyss(pc),a0
	add.l	bar2y1,a0

	move.l	a0,a1
	add.w	bar2x2,a1
	move.w	bar2y2,d7
drawbarsl3:			;clear left border
	move.b	#0,(a1)
	lea	80*4(a1),a1
	dbf	d7,drawbarsl3

	move.l	a0,a1
	add.w	bar2x1,a1
	move.w	bar2y2,d7
drawbarsl4:			;draw right border
	move.b	#-1,(a1)
	lea	80*4(a1),a1
	dbf	d7,drawbarsl4

rts


drawbars2:
	lea	abyss(pc),a0
	add.l	bar1y1,a0
	add.w	bar1x2,a0
	addq.w	#1,a0
	move.l	a0,a1
	sub.w	#80*4,a1
	moveq	#39,d7
drawbars2l1:			;clear left border
	move.b	#0,80*3(a1)
	move.b	#0,80*2(a1)
	move.b	#0,80*1(a1)
	move.b	#0,(a1)+
	dbf	d7,drawbars2l1

	move.l	a0,a1
	add.w	#12*80*4,a1
	moveq	#39,d7
drawbars2l2:			;draw right border
	move.b	#0,80*3+80*4(a1)
	move.b	#0,80*2+80*4(a1)
	move.b	#0,80*1+80*4(a1)
	move.b	#0,80*0+80*4(a1)

	move.b	#0,80*3(a1)
	move.b	#0,80*2(a1)
	move.b	#0,80*1(a1)
	move.b	#-1,(a1)+
	dbf	d7,drawbars2l2




	lea	abyss(pc),a0
	add.l	bar2y1,a0
	add.w	bar2x1,a0

;	addq.w	#1,a0
	move.l	a0,a1
	moveq	#39,d7
drawbars2l3:			;clear left border
	move.b	#0,80*3-80*4(a1)
	move.b	#0,80*2-80*4(a1)
	move.b	#0,80*1-80*4(a1)
	move.b	#0,80*0-80*4(a1)

	move.b	#0,80*3(a1)
	move.b	#0,80*2(a1)
	move.b	#0,80*1(a1)
	move.b	#-1,(a1)+
	dbf	d7,drawbars2l3


	move.l	a0,a1
	add.w	#13*80*4,a1
	moveq	#39,d7
drawbars2l4:			;draw right border
	move.b	#0,80*3(a1)
	move.b	#0,80*2(a1)
	move.b	#0,80*1(a1)
	move.b	#0,(a1)+
	dbf	d7,drawbars2l4
rts


copperlist:
	dc.w	bplcon0,%0100001000000000
	dc.l	$bc0ffffe
	dc.w	bplcon0,%0000001000000000
	dc.l	-2

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

	moveq	#15,d0
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
fader_maxnum=16*1;;	maximal number of colours in program!!

fader_colnum:	dc.w	0

dc.w	-1
fader_table:	dcb.w	fader_maxnum*16
dc.w	-1
fader_pos:	dc.l	fader_table
fader_direct:	dc.w	0
fader_sleep:	dc.w	3
fader_slpcount:	dc.w	1

dotpic:	incbin	"data/dotpic.blt"
mce_e:



;------------------------------------------------------------------------
;---             RELOCATOR, coded by Moon, march 1993                 ---
;--- supporting only HUNK RELOC 32 !!!  , and only ONE hunk!!!!       ---
;--- coded for CURIOUS and MUSIC FOR THE LOST                         ---
;------------------------------------------------------------------------
relocator:
;got codeadress in a0
move.l	a0,a1
move.l	a0,-(a7)

	cmp.l	#$000003f3,(a0)+	;hunk header
bne.b	bug
	cmp.l	#0,(a0)+		;no hunkname
bne.b	bug
	cmp.l	#1,(a0)+		;1 hunk
bne.b	bug
	cmp.l	#0,(a0)+		;first hunknumber
bne.b	bug
	cmp.l	#0,(a0)+		;last hunknumber
bne.b	bug
	tst.l	(a0)+			;hunk 0 length

	cmp.l	#$000003e9,(a0)+	;hunk code
bne.b	bug
	move.l	(a0)+,d0		;hunk length

codecopy:
	move.l	(a0)+,(a1)+
	subq.l	#1,d0
	bne.b	codecopy
move.l	(a7)+,a1

	cmp.l	#$000003ec,(a0)+	;hunk reloc 32
bne.b	bug
	move.l	(a0)+,d0		;hunk reloc 32 offsets length
	tst.l	(a0)+			;hunk reloc 32 for hunk code 0
bne.b	bug


move.l	a1,d2

relocate:
move.l	(a0)+,d1
add.l	d2,(a1,d1.l)
subq.l	#1,d0
bne.b	relocate

rts


bug:
move.w	#$0f00,$dff180
move.w	#$0ff0,$dff180
move.w	#$0,$dff180
bra.b	bug

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
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3

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




fadetest:
fadequant1=16	;number of colours in this calculation

	lea	vectorbar(pc),a0	;source-colourstable
	lea	dotpiccol(pc),a1	;destination-colourtable
	lea	fader_table(pc),a2	;point in fader-table
	moveq	#%111,d1	;RGB filter
	moveq	#fadequant1,d7	;number of colours
	bsr.b	fader_calc


;	lea	fader_table+15*fadequant1*2,a0
;	lea	drugcol3,a1
;	lea	fader_table+16*fadequant1*2,a2
;	moveq	#%111,d1	;RGB filter
;	moveq	#fadequant1,d7	;number of colours
;	bsr	fader_calc

;	lea	fader_table,a2
;	move.w	#-1,2*16*fadequant1*2(a2)	;set endmark in colourlist

rts




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



include	"/include/Fader2/Calc1.2.i"

Fader2_Colquant_abyss=16			;number of colours in this calculation
Fader2_Tablequant_abyss=1;	maximal number of colours in program!!
Fader2_Table_abyss:	dcb.w	Fader2_Tablequant_abyss*Fader2_Colquant_abyss*16
Fader2_Tableend_abyss:

Fader2_abyss:
	;normal fading: RGB-filter=#%101010
	moveq	#Fader2_Colquant_abyss,d7	;number of colours

	lea	col_white,a0		;colour source
	lea	col_abyss,a1		;colour dest
	lea	fader2_table_abyss,a2	;point in fader-table
	moveq	#%101010,d1		;RGB filter
	bsr.w	Fader2_calc

rts


Fader2Start_abyss:
	move.w	#Fader2_Colquant_abyss,fader2_quant
	move.w	#fader2_Tablequant_abyss*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_abyss,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_abyss,Fader2_pos	;...fade backward
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


col_abyss:	;lable for fader
abysscol:
	dc.w	$0013,$0413,$0eed,$0edb,$0dca,$0cb9,$0ca8,$0b87
	dc.w	$0a76,$0a65,$0954,$0844,$0834,$0723,$0623,$0ffe

col_white:	dcb.w	16,$0fff

dotpiccol:
	dc.w $101,$999,$110,$422,$024,$035,$047,$06A
	dc.w $531,$654,$B20,$753,$876,$310,$B97,$FFF

vectorbar:
	dc.w $013,$fff,$fff,$fff,$fff,$fff,$fff,$fff
	dc.w $fff,$fff,$fff,$fff,$fff,$fff,$fff,$fff
;	dc.w $013,$623,$623,$623,$623,$623,$623,$623
;	dc.w $623,$623,$623,$623,$623,$623,$623,$623

abyss:	incbin	"data/abyss.con"

crunched:	incbin	"data/cubecode.term"

codec_e:

section	memory,bss_c
bssc_s:
vector:	ds.b	78000
bssc_e:


printt
printt	"Section Code Chip:"
printv	codec_e-codec_s

printt	"Section Bss  Chip:"
printv	bssc_e-bssc_s

printt
printt	"Memory Chip:"
printv	codec_e-codec_s+bssc_e-bssc_s

printt	"Memory Chip Endpart"
printv	mce_e-mce_s
