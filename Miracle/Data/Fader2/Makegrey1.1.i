Fader2_Makegrey:
	;following register must be set by calling routine
	;d7=number of colours
	;a0=colour source
	;a1=colour dest

	move.w	d7,-(a7)
	subq.w	#1,d7
Fader2_Makegreyloop:
	moveq	#0,d0
	move.w	(a0)+,d0
	move.w	d0,d1
	move.w	d0,d2
	and.w	#%1111,d0	;red
	lsr.w	#4,d1
	and.w	#%1111,d1	;green
	lsr.w	#8,d2		;blue
	add.w	d1,d0
	add.w	d2,d0
	divu	#3,d0
	move.w	d0,d1
	lsl.w	#4,d0
	or.w	d1,d0
	lsl.w	#4,d0
	or.w	d1,d0
	move.w	d0,(a1)+
	dbf	d7,Fader2_Makegreyloop
	move.w	(a7)+,d7	;restore colquant
	rts
