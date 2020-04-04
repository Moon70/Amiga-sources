;------------------------------------------------------------------------
;|									|
;|			   Determinator V1.1				|
;|			  -------------------				|
;|									|
;|	    decrunches data crunched with 'Terminator (Phase 1)'	|
;|		   Terminator (c) 1991 by Moon/ABYSS			|
;|									|
;|									|
;| DeTerm_Flash=0	--> do not flash				|
;| DeTerm_Flash<>0	--> blue/yellow flash during decrunching	|
;|			Note: bplcon3 (AGA) will NOT be changed!	|
;| Note: Determ_Flash must not exist!					|
;|									|
;| 									|
;|									|
;| coded by Moon/ABYSS					     April 1991	|
;|						last update: July  1995	|
;------------------------------------------------------------------------
;updates:
;1995-07-08: new labels, new documented, some optimizing

DeTerm:
;-->a0 = adress for decrunched data
;-->a1 = adress of crunched data
;<-- all register unchanged

	movem.l	d0-a6,-(a7)
	move.l	(a1)+,d1	;crunched length
	move.l	(a1)+,d2	;decrunched length
	addq.l	#1,a1		;byte not used yet
	move.b	(a1)+,d0	;codebyte

	sub.l	#4+4+1+1,d1	;sub 2longwords & 2bytes from crunlength

DeTerm_Mainloop:
	ifd	DeTerm_Flash
	ifne	DeTerm_Flash
		move.w	#$0990,$dff180
	endif
	endif

	move.b	(a1)+,d4		;get next byte
	cmp.b	d4,d0			;next byte = codebyte?
	bne.b	DeTerm_NoCommand	;no, -->copy it
	moveq	#0,d2			;need clear highbyte of 1st word
	move.b	(a1)+,d2		;length of string
	move.b	(a1)+,d3		;byte of string

	ifd	DeTerm_Flash
	ifne	DeTerm_Flash
		move.w	#$0009,$dff180
	endif
	endif

DeTerm_StringLoop:
	move.b	d3,(a0)+		;fill the string
	dbf	d2,DeTerm_StringLoop
	subq.l	#3,d1			;1string = 3bytes of crunch. data
	bne.b	DeTerm_Mainloop
	movem.l	(a7)+,d0-a6
	rts

DeTerm_NoCommand:
	move.b	d4,(a0)+		;copy uncrunched byte
	subq.l	#1,d1			;1byte = 1byte of crunched data
	bne.b	DeTerm_Mainloop
	movem.l	(a7)+,d0-a6
	rts

	dc.b	"$VER: Determinator V1.1",0
	even
