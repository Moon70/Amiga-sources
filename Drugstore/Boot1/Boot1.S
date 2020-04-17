;------------------------------------------------------------------------
;-                                                                      -
;-                               Drugstore                              -
;-                              -----------                             -
;-                                                                      -
;- Bootblock disc 1                                                     -
;-                                                                      -
;-                                  coded in january 1994 by Moon/ABYSS -
;------------------------------------------------------------------------

;discname at offset 18

openlibrary=-30-552
allocmem=-30-168

a:
	dc.b	"DOS",0
	dc.l	0
	dc.l	$00000370

	bra.b	skipdiscname
	dc.b	"drg1"
skipdiscname:
	movem.l	d0-a6,-(a7)
	move.w	#$0102,$dff180
	move.l	#23000,d0
	moveq	#2,d1		;chip mem
	jsr	allocmem(a6)
	lea	memory(pc),a0
	move.l	d0,(a0)
	movem.l	(a7)+,d0-a6

loader:
	move.l	#$1600*4-1024,$24(a1)	;length bytes
	move.l	memory(pc),$28(a1)	;data memory
	move.l	#1024,$2c(a1)		;offset
	jsr	-$1c8(a6)

	move.l	memory(pc),a0
	jmp	(a0)

memory:	dc.l	0
;dc.b	"MooN"
dc.l	$2270fdc3
blk.b	36,0
blk.b	64*1," "
dc.b "----------------------------------------------------------------"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "|                      Drugstore Disc 1                        |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "|                ABYSS-the deepest experience                  |"
dc.b "|                                                              |"
dc.b "|                                                              |"
dc.b "----------------------------------------------------------------"
blk.b	64*1," "
b:
printt	"Code length:"
printv	b-a
