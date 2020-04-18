Font2_CharsizeX=2
Font2_CharsizeY=13
Font2_Write:
;-->d0: charcode
;-->a0: screen (pos)
;-->a2: fontaddress


Font2_WriteC01:		;0001-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC01_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC01_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC01End:;---------------------------
Font2_WriteC02:		;0010-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC02_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC02_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC02End:;---------------------------
Font2_WriteC03:		;0011-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC03_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC03_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC03End:;---------------------------
Font2_WriteC04:		;0100-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC04_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC04_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC04End:;---------------------------
Font2_WriteC05:		;0101-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC05_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC05_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC05End:;---------------------------
Font2_WriteC06:		;0110-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC06_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC06_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC06End:;---------------------------
Font2_WriteC07:		;0111-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC07_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
;	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
;	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC07_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC07End:;---------------------------
Font2_WriteC08:		;1000-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC08_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC08_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC08End:;---------------------------
Font2_WriteC09:		;1001-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC09_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC09_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC09End:;---------------------------
Font2_WriteC10:		;1010-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC10_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC10_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC10End:;---------------------------
Font2_WriteC11:		;1011-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC11_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
;	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
;	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC11_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC11End:;---------------------------
Font2_WriteC12:		;1100-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC12_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC12_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC12End:;---------------------------
Font2_WriteC13:		;1101-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC13_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
;	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
;	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC13_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC13End:;---------------------------
Font2_WriteC14:		;1110-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC14_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
;	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
;	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC14_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC14End:;---------------------------
Font2_WriteC15:		;1111-----------------
	mulu.w	#Font2_CharsizeX*Font2_CharsizeY,d0
	lea	(a2,d0.w),a3

	moveq	#Font2_CharsizeY-1,d7
Font2WriteC15_Loop:
	move.b	(a3)+,d0	;byte0
	move.b	(a3)+,d1	;byte1
	move.b	d0,3*1*80(a0)
	move.b	d0,2*1*80(a0)
	move.b	d0,1*1*80(a0)
	move.b	d0,0*1*80(a0)
	move.b	d1,1+3*1*80(a0)
	move.b	d1,1+2*1*80(a0)
	move.b	d1,1+1*1*80(a0)
	move.b	d1,1+0*1*80(a0)

	lea	1*4*80(a0),a0
	dbf	d7,Font2WriteC15_Loop
	lea	1-1*4*80*Font2_CharsizeY(a0),a0
	rts
Font2_WriteC15End:;---------------------------



Font2_CodeTable:
	dc.l	Font2_WriteC01
	dc.l	Font2_WriteC02
	dc.l	Font2_WriteC03
	dc.l	Font2_WriteC04
	dc.l	Font2_WriteC05
	dc.l	Font2_WriteC06
	dc.l	Font2_WriteC07
	dc.l	Font2_WriteC08
	dc.l	Font2_WriteC09
	dc.l	Font2_WriteC10
	dc.l	Font2_WriteC11
	dc.l	Font2_WriteC12
	dc.l	Font2_WriteC13
	dc.l	Font2_WriteC14
	dc.l	Font2_WriteC15

