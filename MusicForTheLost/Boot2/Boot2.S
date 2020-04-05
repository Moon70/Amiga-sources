openlibrary=-30-552
allocmem=-30-168

a:
kennung:	dc.b	"DOS",0
checksumme:	dc.l	0
rootblock:	dc.l	$00000370

	move.l	4.w,a6
	movem.l	d0-a6,-(a7)

	move.l	#300000,d0
	moveq	#2,d1		;chip mem
	jsr	allocmem(a6)
	lea	memory(pc),a0
	move.l	d0,(a0)
	bne.b	gotit

nomemavail:
	move.w	#$0f00,$dff180
	move.w	#$0,$dff180
	bra.b	nomemavail

gotit:
	movem.l	(a7),d0-a6

loader:
	lea	memory(pc),a0

	move.l	#$1200,$24(a1)	;length bytes $1600-1024
	move.l	(a0),$28(a1)	;data memory
	move.l	#1024,$2c(a1)	;offset
	jsr	-$1c8(a6)

	lea	memory(pc),a0
	move.l	(a0),a0
	jsr	(a0)

wait:
	bra.b	wait

;	movem.l	(a7)+,d0-a6
;	rts
memory:	dc.l	0

blk.b	24,0
blk.b	64*2," "
dc.b "----------------------------------------------------------------"
dc.b "|                                                              |"
dc.b "|                       * A B Y S S *                          |"
dc.b "|                     -----------------                        |"
dc.b "|                                                              |"
dc.b "|                MUSIC FOR THE LOST - DISK TWO                 |"
dc.b "|                                                              |"
dc.b "|         a neurodancer-toxic-artline-moon production          |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "----------------------------------------------------------------"
b:
