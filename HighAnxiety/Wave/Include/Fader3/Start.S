Fader3_Start:
;--> a0   Fader calc table
;--> d0.w number of cols to fade or zero for all colours
;<-- a0/a1 changed
;Fader3_Table is a lable of Fader3_Fade.s

	lea	Fader3_Table(pc),a1	;tableptr
	move.l	a0,(a1)
	move.w	d0,(a0)+		;number of steps
	bne.b	Fader3_gotnumber
	move.w	(a0),-(a0)		;0 steps = max steps
Fader3_gotnumber:
	rts
