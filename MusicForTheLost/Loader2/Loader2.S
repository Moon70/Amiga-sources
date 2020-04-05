a:
loop:    
	move.w	#%0000000110100000,$dff096
	move.w	#$0000,$dff180
	move.l	#0,$dff144

	lea	discbuf(pc),a0
	lea	introloaderend(pc),a1
	add.l	#430000,a1
	move.l	a1,(a0)


	lea	diskdemo(pc),a0
	move.l	a0,$80.w

	trap	#0
 	rts

diskdemo:
	movem.l	d0-a6,-(a7)
	lea	loaderend(pc),a0
	move.l	a0,-(a7)
	add.l	#210000,a0
	move.l	#146,d0			;start track
	moveq	#14,d1			;lengh (tracks)
	bsr.w	loadtrack

	move.l	(a7),a0
	move.l	a0,a1
	add.l	#210000,a1
	bsr.w	determ

	move.l	(a7),a0
	bsr.w	relocator

	move.l	(a7)+,a0
	jsr	(a0)

	movem.l	(a7)+,d0-d7/a0-a6
	rte

moondecoder:
movem.l	d0-a6,-(a7)
move.l	a0,a4
;lea	trackbuffer(pc),a0
move.l	discbuf(pc),a0
moveq	#10,d7
move.l	#$55555555,d6

syncsearch:
cmp.w	#$4489,(a0)+	;search syncword
bne.b	syncsearch
cmp.w	#$4489,(a0)+	;second syncword
beq.b	sync2found
subq.l	#2,a0		;no second sync, (when first was not readable)
sync2found:
subq.l	#8,a0

movem.l	56(a0),d0/d1	;data checksum mfm
and.l	d6,d0
add.l	d0,d0
and.l	d6,d1
or.l	d1,d0		;data checksum decoded

lea	64(a0),a1	;data block adress
moveq	#0,d1
move.w	#255,d5
checksumloop:
move.l	(a1)+,d2
eor.l	d2,d1
dbf	d5,checksumloop
and.l	d6,d1
sub.l	d0,d1
beq.b	nochecksumerror

;move.l	#100,d0
checksumbug:
;move.w	#$00f0,$dff19e
;move.w	#$0,$dff19e
;sub.l	#1,d0
;bne.b	checksumbug

;bra.b	checksumbug
lea	readerror(pc),a0
addq.w	#1,(a0)

movem.l	(a7)+,d0-a6
rts


nochecksumerror:
move.w	10(a0),d0	;sector number and distance mfm-word1
move.w	14(a0),d1	;sector number and distance mfm-word2
and.w	d6,d0
add.w	d0,d0
and.w	d6,d1
or.w	d1,d0		;sector number and distance decoded
move.b	#0,d0		;sector number (distance killed)
add.w	d0,d0		;offset in trackblock (sectornumber*512)

lea	(a4,d0.w),a3	;data destination
lea	64(a0),a1	;data mfm part1
lea	512(a1),a2	;data mfm part2

moveq	#127,d5		;1 sector =128 decoded longwords
decodeloop:
;move.w	$dff006,$dff180
move.l	(a1)+,d0
move.l	(a2)+,d1
and.l	d6,d0
add.l	d0,d0
and.l	d6,d1
or.l	d1,d0
move.l	d0,(a3)+
dbf	d5,decodeloop
lea	1088(a0),a0	;64 header-bytes and 1024 databytes
dbf	d7,syncsearch	;next sector
movem.l	(a7)+,d0-a6
;move.w	#0,$dff180
rts			;track checked and decoded


relocator:
;got codeadress in a0
move.l	a0,a1
move.l	a0,-(a7)

	cmp.l	#$000003f3,(a0)+	;hunk header
bne.b	bug
	cmp.l	#0,(a0)+		;no hunkname
bne.b	bug
	cmp.l	#1,(a0)+		;1 hunk
bne.b	bug
	cmp.l	#0,(a0)+		;first hunknumber
bne.b	bug
	cmp.l	#0,(a0)+		;last hunknumber
bne.b	bug
	tst.l	(a0)+			;hunk 0 length

	cmp.l	#$000003e9,(a0)+	;hunk code
bne.b	bug
	move.l	(a0)+,d0		;hunk length

codecopy:
	move.l	(a0)+,(a1)+
	subq.l	#1,d0
	bne.b	codecopy
move.l	(a7)+,a1

	cmp.l	#$000003ec,(a0)+	;hunk reloc 32
bne.b	bug
	move.l	(a0)+,d0		;hunk reloc 32 offsets length
	tst.l	(a0)+			;hunk reloc 32 for hunk code 0
bne.b	bug


move.l	a1,d2

relocate:
move.l	(a0)+,d1
add.l	d2,(a1,d1.l)
subq.l	#1,d0
bne.b	relocate

rts


bug:
move.w	#$00f0,$dff180
move.w	#$0,$dff180
bra.b	bug

rts




;------------------------------------------------------------------------
loadtrack:
;a0=destination adress
;d0=starttrack
;d1=length tracks

movem.l	d0-a6,-(a7)

	lea	$dff000,a5
	lea	$bfd100,a6
	bsr.b	sethead

readloop:
	subq.w	#1,d1		;length tracks
	bmi.b	loadtrackfin

move.l	a4,-(a7)
lea	readerror(pc),a4
move.w	#0,(a4)
move.l	(a7)+,a4

rereadloop:
bsr.w	readtrack
bsr.w	moondecoder

move.w	readerror(pc),d7

tst.w	d7
beq.b	noreaderror

;cmp.w	#2,d7
;bne	rereadloop	; no, try again
;move.l	a4,-(a7)
;lea	readerror(pc),a4
;move.w	#0,(a4)
;move.l	(a7)+,a4
bsr.b	sethead		;reset head, try again

;move.w	#50000,d7
resethead:
;move.w	#$000f,$dff19e
;move.w	#$0,$dff19e
;dbf	d7,resethead

bra.b	rereadloop




noreaderror:
lea	$1600(a0),a0
addq.w	#1,d0		;starttrack+1=next track
bchg	#2,(a6)
btst.l	#0,d0		;even track?
bne.b	readloop
bclr.b	#1,(a6)		;CIA-B PRB, bit 1=direction signal to drive
bclr.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
nop
bset.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
moveq	#64,d7		;number of rasterlines to wait...
bsr.w	timewait
bra.b	readloop



loadtrackfin:
;move.w	#$000f,$dff180
;move.w	#$0,$dff180
btst.b	#5,$f01(a6)
bne.b	loadtrackfin

move.b	#%11111101,(a6)
moveq	#100,d7		;number of rasterlines to wait...
bsr.w	timewait
move.b	#%10000101,(a6)

moveq	#100,d7
bsr.w	timewait
move.b	#%11111101,(a6)


movem.l	(a7)+,d0-a6
rts

sethead:
move.b	#%01111111,(a6)	;set all bits except dsk-motor
nop
bclr	#0+3,(a6)	;bit 3=drive0select
nop
waitdrive:
	btst.b	#5,$f01(a6)
	bne.b	waitdrive
zeromove:
btst.b	#4,$f01(a6)	;CIA-A PRA(bfe001), bit4=track00
beq.b	zeromoved
bclr.b	#0,(a6)		;CIA-B PRB, step signal
nop
bset.b	#0,(a6)		;CIA-B PRB, step signal
moveq	#64,d7		;number of rasterlines to wait...
bsr.w	timewait
bra.b	zeromove

zeromoved:
bset.b	#2,(a6)	;CIA-B PRB, bit 2=side select
		;(choose side 0)
move.w	d0,d2	;copy of starttrack
lsr.w	#1,d2	;tracknumber/2=cylindernumber
bcc.b	eventrack
bclr.b	#2,(a6)	;CIA-B PRB, side select
		;(choose side 1)

eventrack:
subq.w	#1,d2
bmi.b	rightpos
bclr.b	#1,(a6)
movehead:
bclr.b	#0,(a6)		;CIA-B PRB, step signal
nop
bset.b	#0,(a6)		;CIA-B PRB, step signal
moveq	#64,d7		;number of rasterlines to wait...
bsr.b	timewait
dbf	d2,movehead

rightpos:
rts

readtrack:
move.w	#%0111111100000000,$9e(a5)	;adkcon7 all off
move.w	#%1000010100000000,$9e(a5)	;adkcon7, mfm+wordsync on
move.w	#$4489,$7e(a5)			;dsksync
move.w	#%1000001000010000,$96(a5)	;dmacon, diskdma on
waitdrive2:
	btst.b	#5,$f01(a6)	;CIA-A PRA(bfe001, disk ready
	bne.b	waitdrive2

move.w	#$4000,$24(a5)	;dsklen
move.l	discbuf(pc),$20(a5)
move.w	#$8000+6436,d2	;dma on, 6436 words length
move.w	d2,$24(a5)	;dsklen
move.w	d2,$24(a5)	;dsklen
move.w	#%0000000000000010,$9c(a5)	;intreq, clear disk-irq
diskdmawait:
btst	#1,$1f(a5)	;intreq (lobyte)
beq.b	diskdmawait

move.w	#$4000,$24(a5)	;dsklen dma off
move.w	#$400,$9e(a5)	;adkcon wordsync off
rts


;------------------------------------------------------------------------





timewait:
	movem.l	d1/d2,-(a7)
timewait0:
	move.w	$dff006,d1	;vhpos
	lsr.w	#8,d1		;d1=vertical position
timewait1:
	move.w	$dff006,d2	;vhpos
	lsr.w	#8,d2		;d2=vertical position
	cmp.w	d1,d2		;first test and last test the same line?
	beq.s	timewait1	;yep, wait...
	dbf	d7,timewait0	;wait for next line
	movem.l	(a7)+,d1/d2
	rts

readerror:	dc.w	0


;------------------------------------------------------------------------
;---	      BYTESTRING decrunchroutine by Moon, april 1991		-
;------------------------------------------------------------------------
determ:
;a0=decrunchadress	(destination)
;a1=crunched data	(source)

move.l	(a1)+,d1	;crunched length
move.l	(a1)+,d2	;decrunched length
tst.b	(a1)+		;routine-code
move.b	(a1)+,d0	;codebyte

sub.l	#4+4+1+1,d1

decrunchl1:
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3

decrunchl4:
move.b	d3,(a0)+
dbf	d2,decrunchl4
subq.l	#3,d1
bra.b	decrunchl3

decrunchl2:
move.b	-1(a1),(a0)+
subq.l	#1,d1

decrunchl3:
bne.b	decrunchl1

rts

discbuf:	dc.l	0

b:
blk.b	$1600-1024+a-b,0
c:
loaderend:
introloaderend:



