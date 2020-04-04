;-----------------------------------------------------------------------------
;- S404 highly optimized data decruncher v1.1 turbo
;- 27.11.93 by Marcus 'Cozine' Ottosson
;-----------------------------------------------------------------------------
;- Based on S404 data_decruncher v0.2
;- (c) 1993 by Jouni 'Mr.Spiv' Korhonen (SWSW)
;-----------------------------------------------------------------------------
;- call with registers: a0 = destination address
;-                      a1 = crunched data
;-----------------------------------------------------------------------------

; uses d0-a6


STCdecrunch:
_l0:		addq	#8,a1			; Skip ID string & security
						; length..
		move.l	a0,a5
		add.l	(a1)+,a0
		add.l	(a1),a1
		moveq	#0,d4
		moveq	#16,d5
		movem.w	(a1),d2/d6/d7
		not.w	d4
		lea	_loff6(pc),a3
		lea	_llen5a(pc),a4
		moveq	#1,d0
		moveq	#-1,d3
		bra.s	_ltest1

_lins:		subq.w	#8,d7
		bpl.s	_lins2
_lins1:		move.w	d7,d1
		addq.w	#8,d7
		lsl.l	d7,d6
		move.w	-(a1),d6
		neg.w	d1
		lsl.l	d1,d6
		addq.w	#8,d7
		swap	d6
		move.b	d6,-(a0)
		swap	d6
		cmp.l	a0,a5
		dbhs	d7,_lmain
		bra.s	_lexma

_lins2:		rol.w	#8,d6
		move.b	d6,-(a0)
_ltest1:	cmp.l	a0,a5
		dbhs	d7,_lmain
_lexma:		bhs.s	_lexit

_lmain1:	move.w	-(a1),d6
		moveq	#15,d7
_lmain:		add.w	d6,d6
		bcc.s	_lins

		dbf	d7,_llen1
		move.w	-(a1),d6
		moveq	#15,d7
_llen1:		add.w	d6,d6
		bcs.s	_llen6
		dbf	d7,_llen2
		move.w	-(a1),d6
		moveq	#15,d7
_llen2:		moveq	#2,d1
		moveq	#2,d3
		add.w	d6,d6
		bcs.s	_llen5
		dbf	d7,_llen3
		move.w	-(a1),d6
		moveq	#15,d7
_llen3:		add.w	d6,d6
		bcc.s	_llen4
		moveq	#4,d1
		moveq	#6,d3
		lea	_llen3a(pc),a6
		bra.s	_lbits
_llen3a:	add.w	d1,d3
		cmp.w	#15,d1
		blo.s	_loff1

		moveq	#5,d1
		moveq	#14,d3
		lea	_llen3b(pc),a6
		bra.s	_lbits

_llen4:		moveq	#21,d3
_lloop:		moveq	#8,d1
_llen5:		move.l	a4,a6
		bra.s	_lbits
_llen5a:	add.w	d1,d3
		not.b	d1
		dbeq	d7,_loff2
		bne.s	_loff2a	
		beq.s	_lloop

_loff6:		add.w	d1,a2
		move.b	(a2),-(a0)
_lcopy:		move.b	-(a2),-(a0)
		dbf	d3,_lcopy
_ltest:		cmp.l	a0,a5
		dbhs	d7,_lmain
		blo.s	_lmain1
_lexit:		rts

_llen6:		dbf	d7,_llen7
		move.w	-(a1),d6
		moveq	#15,d7
_llen7:		add.w	d6,d6
		addx.w	d0,d3
_loff1:		dbf	d7,_loff2
_loff2a:	move.w	-(a1),d6
		moveq	#15,d7
_loff2:		add.w	d6,d6
		bcs.s	_loff3

		dbf	d7,_loff4
		move.w	-(a1),d6
		moveq	#15,d7
_loff4:		moveq	#9,d1
		lea	32(a0),a2
		add.w	d6,d6
		bcc.s	_loff5
		moveq	#5,d1
		move.l	a0,a2
		bra.s	_loff5
_loff3:		lea	544(a0),a2
		move.w	d2,d1
_loff5:		move.l	a3,a6

_lbits:		and.l	d4,d6
		sub.w	d1,d7
		bpl.s	_lbits2
		add.w	d7,d1
		lsl.l	d1,d6
		move.w	d7,d1
		move.w	-(a1),d6
		neg.w	d1
		add.w	d5,d7
_lbits2:	lsl.l	d1,d6
		move.l	d6,d1
		swap.w	d1
		jmp	(a6)

_lpins2:	moveq	#-1,d3
		bra.w	_lins2

_l2ins2:	rol.w	#8,d6
		move.b	d6,-(a0)
_l2ins1:	lsl.l	d7,d6
		move.w	-(a1),d6
		lsl.l	d1,d6
		swap	d6
		move.b	d6,-(a0)
		swap	d6
		subq.w	#2,d3
		bgt.s	_l2ins2
		beq.s	_lpins2
		addq.w	#8,d7
		bra.s	_ltest

_llen3b:	add.w	d1,d3
		move.b	_lnewd1(pc,d7),d1
		bpl.s	_l2ins1
		subq.w	#8,d7
		dbf	d3,_l2ins2

_lnewd1:	dc.b	$08,$07,$06,$05,$04,$03,$02,$01
		dc.b	$88,$87,$86,$85,$84,$83,$82,$81
