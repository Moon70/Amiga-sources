Fader3_Calc:	;V3.0, july 1995, code by moon
	;the following register must be set from the calling routine
	;a0   = source list
	;a1   = dest list
	;a2   = fade list
	;a3   = fader data
	;d0.w = fading steps
	;d7.w = colors number
	ext.l	d0
	move.l	d0,(a3)+	;fadesteps  -->hiword (mem)=counter
	subq.w	#1,d7		;decrease for counter
	move.l	d7,(a3)+	;colquant   -->howord (mem)=unused word
	move.l	a2,(a3)+
Fader3_l1:
	move.l	(a0)+,d2	;get source-col
	move.l	d2,d5
	sub.w	d5,d5
	move.l	d5,(a3)+	;R start float16

	move.l	d2,d1
	and.l	#$0000ff00,d1
	lsl.l	#8,d1
	move.l	d1,(a3)+	;G start float16

	and.l	#$000000ff,d2
	swap	d2
	move.l	d2,(a3)+	;B start float16

	move.l	(a1)+,d3	;get dest-col
	move.l	d3,d4
	sub.w	d4,d4
	sub.l	d5,d4		;dest float16 - source float16
	divs.l	d0,d4
	move.l	d4,(a3)+	;R delta float16

	move.l	d3,d4
	and.l	#$0000ff00,d4
	lsl.l	#8,d4
	sub.l	d1,d4
	divs.l	d0,d4
	move.l	d4,(a3)+	;G delta float16

	and.l	#$000000ff,d3
	swap	d3
	sub.l	d2,d3
	divs.l	d0,d3
	move.l	d3,(a3)+	;B delta float16

	dbf	d7,Fader3_l1
	rts
