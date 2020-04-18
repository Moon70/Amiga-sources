Font1_CharsizeX=1
Font1_CharsizeY=9
Font1_Write:
;-->d0: charcode
;-->a0: screen (pos)
;-->a2: fontaddress

Font1_WriteC01:		;0001-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC01_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC01_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC01End:;---------------------------
Font1_WriteC02:		;0010-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC02_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC02_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC02End:;---------------------------
Font1_WriteC03:		;0011-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC03_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC03_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC03End:;---------------------------
Font1_WriteC04:		;0100-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC04_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC04_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC04End:;---------------------------
Font1_WriteC05:		;0101-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC05_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC05_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC05End:;---------------------------
Font1_WriteC06:		;0110-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC06_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC06_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC06End:;---------------------------
Font1_WriteC07:		;0111-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC07_Loop:
	move.b	(a3)+,d0
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC07_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC07End:;---------------------------
Font1_WriteC08:		;1000-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC08_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC08_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC08End:;---------------------------
Font1_WriteC09:		;1001-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC09_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	movE.b	d0,1*1*80(a0	
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC09_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC09End:;--------------------------
Font1_WriteC10:		;1010-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC10_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC10_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC10End:;---------------------------
Font1_WriteC11:		;1011-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC11_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC11_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC11End:;---------------------------
Font1_WriteC12:		;1100-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC12_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC12_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC12End:;---------------------------
Font1_WriteC13:		;1101-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC13_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC13_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC13End:;---------------------------
Font1_WriteC14:		;1110-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC14_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC14_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC14End:;---------------------------
Font1_WriteC15:		;1111-----------------
	mulu.w	#Font1_CharsizeX*Font1_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font1_CharsizeY-1,d7
Font1WriteC15_Loop:
	move.b	(a3)+,d0
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font1WriteC15_Loop
	lea	1-1*4*80*Font1_CharsizeY(a0),a0
	rts
Font1_WriteC15End:;---------------------------


Font1_CodeTable:
	dc.l	Font1_WriteC01
	dc.l	Font1_WriteC02
	dc.l	Font1_WriteC03
	dc.l	Font1_WriteC04
	dc.l	Font1_WriteC05
	dc.l	Font1_WriteC06
	dc.l	Font1_WriteC07
	dc.l	Font1_WriteC08
	dc.l	Font1_WriteC09
	dc.l	Font1_WriteC10
	dc.l	Font1_WriteC11
	dc.l	Font1_WriteC12
	dc.l	Font1_WriteC13
	dc.l	Font1_WriteC14
	dc.l	Font1_WriteC15
