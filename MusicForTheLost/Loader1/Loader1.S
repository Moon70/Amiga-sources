allocmem=-30-168
freemem=-30-180
a:
	bsr	allout
	move.w	#%0000000000001000,d3

	moveq	#1,d0
	bsr	drive_check
	tst.l	d1
	bne	nodf1
	bset.l	#4,d3

nodf1:
	moveq	#2,d0
	bsr	drive_check
	tst.l	d1
	bne	nodf2
	bset.l	#5,d3

nodf2:
	moveq	#3,d0
	bsr	drive_check
	tst.l	d1
	bne	nodf3
	bset.l	#6,d3

nodf3:
	lea	memtable(pc),a0
	move.w	d3,(a0)

loop:
move.w	#%0000000010000000,$dff096
move.w	#$0000,$dff180

;---allocate mem
	lea	memtable+2(pc),a0
	lea	memneedtable(pc),a1
	move.l	4.w,a6
	moveq	#0,d1		;public mem
	moveq	#6,d7
allocmemloop:
	move.l	(a1)+,d0	;length

	movem.l	d1-a6,-(a7)
	jsr	allocmem(a6)	;allocate memory
	movem.l	(a7)+,d1-a6
	move.l	d0,(a0)+	;write memadress in table
	tst.l	d0
	beq	gotnomem
	move.l	d0,a2		;delete first longword of mem...
	move.l	#0,(a2)		;...-->code 'module not loaded yet'
gotnomem:
	dbf	d7,allocmemloop
	

;---

	lea	discbuf(pc),a0
	lea	introloaderend(pc),a1
	add.l	#430000,a1
	move.l	a1,(a0)

	lea	diskdemo(pc),a0
	move.l	a0,$80.w
	trap	#0
 	rts

allout:
	move.l	a0,-(a7)
	move.w	#$0,$dff180
	move.l	#0,$dff144
	move.l	#0,$dff14c
	move.l	#0,$dff154
	move.l	#0,$dff15c
	move.l	#0,$dff164
	move.l	#0,$dff16c
	move.l	#0,$dff174
	move.l	#0,$dff17c
	move.w	#0,$1fc
	
	lea	emptyint(pc),a0
	move.l	a0,$6c.w

	lea	emptycopper(pc),a0
	move.l	a0,$dff080
	move.w	#0,$dff088

	move.w	#%0000001000000000,$dff100
	move.l	(a7)+,a0

	lea	emptyintcount(pc),a0
	move.w	#0,(a0)
alloutl1:
	cmp.w	#2,(a0)
	bne	alloutl1

	rts


emptyintcount:	dc.w	0


emptyint:
	move.l	a0,-(a7)
	lea	emptyintcount(pc),a0
	addq.w	#1,(a0)
	move.l	(a7)+,a0

	move.w	#%0000000001100000,$dff09c	;clear intflags
rte

emptycopper:
dc.l	-2

diskdemo:
	movem.l	d0-a6,-(a7)
lea	a(pc),a0
add.l	#$1600-1024,a0			;destination adress
move.l	a0,-(a7)
;intro
	moveq	#1,d0			;start track
	moveq	#24,d1			;lengh (tracks)
	bsr.w	loadtrack
move.l	(a7),a0
bsr.w	determ
move.l	(a7),a0
bsr.w	relocator
move.l	(a7),a0
jsr	(a0)
bsr	allout

mouse:
	btst.b	#10,$dff016
;	bne	mouse
move.w	#%0000000001010000,$dff09c

;box
move.l	(a7),a0
	moveq	#25,d0			;start track
	moveq	#14,d1			;lengh (tracks)
	bsr.w	loadtrack
move.l	(a7),a0
bsr.w	determ
move.l	(a7),a0
bsr.w	relocator
move.l	(a7),a0
lea	memtable(pc),a1	;parameter for box
jsr	(a0)
move.l	a1,(a7)	;parameter, unit from mainpart

	lea	emptyintcount(pc),a0
	move.w	#0,(a0)
sleep:
	cmp.w	#50,(a0)
	bne	sleep


;move.l	#100000,d0
;flash:
;move.w	$dff006,$dff180
;sub.l	#1,d0
;bne	flash

bsr	allout

;endpart
;move.l	(a7),a0
;	move.l	#129,d0			;start track
;	moveq	#17,d1			;lengh (tracks)
;	bsr.w	loadtrack



move.l	(a7),a0
bsr.w	determ
move.l	(a7),a0
bsr.w	relocator
move.l	(a7),a0
jsr	(a0)




mouse2:
	btst.b	#10,$dff016
	bne.b	mouse2
addq.l	#4,a7

	movem.l	(a7)+,d0-d7/a0-a6
	rte




memtable:
dc.w	0	;drivecode
dc.l	0
dc.l	0
dc.l	0
dc.l	0
dc.l	0
dc.l	0
dc.l	0


memneedtable:
dc.l	189828		;unit 1
dc.l	221098		;unit 2
dc.l	205392		;unit 3
dc.l	214868		;unit 4
dc.l	186540		;unit 5
dc.l	81074		;unit 6
dc.l	215896		;unit 7


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

readerror:	dc.w	0

	

;------------------------------------------------------------------------
;---          BYTESTRING decrunchroutine by Moon/ABYSS                ---
;------------------------------------------------------------------------
determ:
;got adress of crunched data in a0
move.l	a0,-(a7)
	move.l	a0,a1		;decrunched adress...
	add.l	4(a0),a1	;...+decrunched length
	move.l	(a0),d3		;crunched length to copy crunched data
	add.l	d3,a0
datacopyloop:
	move.b	-(a0),-(a1)
	subq.l	#1,d3
	bne.b	datacopyloop
move.l	(a7)+,a0		;crunched adress

move.l	(a0)+,d1	;crunched length
move.l	(a0)+,d2	;decrunched length
tst.b	(a0)+		;routine-code
move.b	(a0)+,d0	;codebyte

add.l	#4+4+1+1,a1
sub.l	#4+4+1+1,a0

sub.l	#4+4+1+1-1,d1


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
move.w	#$0f00,$dff180
move.w	#$0ff0,$dff180
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
	bsr.w	sethead

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
bsr.w	sethead		;reset head, try again

;move.w	#50000,d7
resethead:
;move.w	#$000f,$dff19e
;move.w	#$0,$dff19e
;dbf	d7,resethead

bra	rereadloop




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

drive_check:
	addq.b	#3,d0
	moveq	#0,d1
 	move.b	#%10000011,$bfd100	;motor off (all drives)
	bsr	waitawhile

 	move.b	#%01111011,$bfd100	;deselect all drives+motorbit lo
	bsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor on
	bsr	waitawhile

	move.b	#%11111011,$bfd100	;deselect all drives+motorbit hi
	bsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor off
	bsr	waitawhile

	bset.b	d0,$bfd100		;deselect drive
	bsr	waitawhile

	moveq	#1,d2
getidcode:
	bclr.b	d0,$bfd100		;select drive
	bsr	waitawhile
	move.b	$bfe001,d4		;get drive status (CIA-A)
	roxl.b	#3,d4
	roxl.b	#1,d1			;get DSKRDY-bit
	bset.b	d0,$bfd100		;deselect drive
	bsr	waitawhile

	dbf	d2,getidcode

rts


waitawhile:
	moveq	#1,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
	move.b	$dff007,d5
	cmp.b	d5,d6
	beq	waitawhileloop2
	dbf	d7,waitawhileloop1
	rts


discbuf:	dc.l	0


b:
blk.b	$1600-1024+a-b,0
c:
introloaderend:
