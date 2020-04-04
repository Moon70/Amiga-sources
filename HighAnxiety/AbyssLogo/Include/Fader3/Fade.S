Fader3_Table:		dc.l	0
Fader3_Fade:
	move.l	Fader3_Table(pc),d0	;calctable set?
	beq	Fader3_skip		;nope-adios
	move.l	d0,a0
	move.w	(a0),d0			;ctable inactive or fad.finished?
	beq	Fader3_skip		;adios
	subq.w	#1,d0			;decrease stepcounter
	move.w	d0,(a0)
	addq.l	#6,a0			;skip stepcount.w+quant.w+dummy.w
	move.w	(a0)+,d7		;colquant-1

	move.l	(a0)+,a1		;colour fading list
	move.l	#$00008000,d6
Fader3_Loop:
	movem.l	(a0),d0-d5	;R/G/B float16/R/G/B delta float16
	add.l	d3,d0
	add.l	d4,d1
	add.l	d5,d2
	movem.l	d0-d2,(a0)

	add.l	d6,d0
	add.l	d6,d1
	add.l	d6,d2
	lea	6*4(a0),a0
	swap	d1
	lsl.w	#8,d1
	move.w	d1,d0
	swap	d2
	move.b	d2,d0
	move.l	d0,(a1)+
	dbf	d7,Fader3_Loop

Fader3_skip:
	rts
