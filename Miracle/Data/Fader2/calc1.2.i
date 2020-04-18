Fader2_Calc:	;V2.2, september 1994, code by moon
	;the following register must be set from the calling routine
	;a0 = source list
	;a1 = dest list
	;a2 = fader table
	;d1 = RGB-filter
	;d7 = colors number

	move.l	a1,-(a7)
	move.w	d7,-(a7)	;store colquant
	move.w	d7,d0		;number of cols
	subq.w	#1,d7		;decrease for counter
	add.w	d0,d0		;word number for table offset
	move.w	d1,-(a7)	;store RGB filter

Fader2_l1:
	move.w	#0,(a2)		;clr col (calcsol will be ORed to dest!)
	move.w	(a7),d1		;get RGB-filter
	move.w	d1,d3
	move.w	(a0),d4

	roxr.w	#1,d1
	bcs.b	Fader2_Holdblue
	and.w	#%111111110000,d4
Fader2_Holdblue:

	roxr.w	#2,d1
	bcs.b	Fader2_Holdgreen
	and.w	#%111100001111,d4
Fader2_Holdgreen:

	roxr.w	#2,d1
	bcs.b	Fader2_Holdred
	and.w	#%000011111111,d4
Fader2_Holdred:

	move.w	d4,-(a7)

	move.w	2(a7),d1	;get RGB-filter
	roxr.w	#2,d1		;B-bit in x-reg
	bcc.b	Fader2_Skipblue	;blue filter set (blue bit=0)
;blue:
	move.l	a2,a3		;table adress
	moveq	#0,d3
	moveq	#0,d4		;startpos/solution
	move.w	(a1),d3		;rgb-col dest
	and.w	#15,d3		;  b-col dest
	swap	d3		;*65536
	move.w	(a0),d4		;rgb-col source
	and.w	#15,d4		;  b-col source
	swap	d4		;*65536

	sub.l	d4,d3		;dest-source
	asr.l	#4,d3		;/16 (table = 16 entrys/col) (nonAGA)
	bpl.b	Fader2_Noblueflow;positive=upfading
	sub.l	d3,d4		;downfading, sub one time=fake integer bug
Fader2_Noblueflow:
	
	moveq	#15,d6		;16 entrys/col
Fader2_Calcblue:
	add.l	d3,d4		;source+fadestep
	move.l	d4,d5		;actual col
	swap	d5		;/65536 (integer)
	and.w	#15,d5		;only blue
	or.w	(a7),d5
	or.w	d5,(a3)		;OR value in table
	add.w	d0,a3		;next pos=actpos+colquant*2(wordoffset)
	dbf	d6,Fader2_Calcblue
Fader2_Skipblue:

	roxr.w	#2,d1
	bcc.b	Fader2_Skipgreen
;green
	move.l	a2,a3
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3
	lsr.w	#4,d3
	and.w	#15,d3
	swap	d3
	move.w	(a0),d4
	lsr.w	#4,d4
	and.w	#15,d4
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl.b	Fader2_Nogreenflow
	sub.l	d3,d4
Fader2_Nogreenflow:
	moveq	#15,d6
Fader2_Calcgreen:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#4,d5
	or.w	(a7),d5
	or.w	d5,(a3)
	add.w	d0,a3
	dbf	d6,Fader2_Calcgreen
Fader2_Skipgreen:
	roxr.w	#2,d1
	bcc.b	Fader2_Skipred
;red
	
	move.l	a2,a3
	moveq	#0,d3
	moveq	#0,d4
	move.w	(a1),d3
	lsr.w	#8,d3
	swap	d3
	move.w	(a0),d4
	lsr.w	#8,d4
	swap	d4

	sub.l	d4,d3
	asr.l	#4,d3
	bpl.b	Fader2_Noredflow	
	sub.l	d3,d4
Fader2_Noredflow:
	moveq	#15,d6
Fader2_Calcred:
	add.l	d3,d4
	move.l	d4,d5
	swap	d5
	and.w	#15,d5
	lsl.w	#8,d5
	or.w	(a7),d5
	or.w	d5,(a3)
	add.w	d0,a3
	dbf	d6,Fader2_Calcred
Fader2_Skipred:
	addq.l	#2,a0
	addq.l	#2,a1
	addq.l	#2,a2
	addq.w	#2,a7
	dbf	d7,Fader2_l1

	sub.w	d0,a3
	addq.w	#2,a3
	move.l	a3,a2

	move.l	a3,a0
	sub.w	d0,a0
	move.w	(a7)+,d1	;restore RGB-filter
	move.w	(a7)+,d7	;restore colquant
	move.l	(a7)+,a1
	rts
Fader2_Pos:		dc.l	0
Fader2_Direct:		dc.w	0
Fader2_Sleep:		dc.w	0
Fader2_Quant:		dc.w	0
Fader2_Step:		dc.w	0
Fader2_Slpcount:	dc.w	1
