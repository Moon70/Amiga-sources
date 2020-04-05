;------------------------------------------------------------------------
;-                                                                      -
;-                      MUSIC FOR THE LOST - MAIN MENU                  -
;-                 ----------------------------------------             -
;-                                                                      -
;-                coded in february/march 1993 by Moon/ABYSS            -
;-                                                                      -
;------------------------------------------------------------------------
a:

execbase=4
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
openlibrary=-30-522
startlist=38
dmaconr=$002
intena=$09a

bplcon0=$100
bplcon1=$102
bplcon2=$104
bpl1pth=$0e0
bpl1ptl=$0e2
bpl2pth=$0e4
bpl2ptl=$0e6
bpl3pth=$0e8
bpl3ptl=$0ea
bpl4pth=$0ec
bpl4ptl=$0ee
bpl5pth=$0f0
bpl5ptl=$0f2
bpl6pth=$0f4
bpl6ptl=$0f6
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094

;copperoffsets
copcon=$02e
cop1lch=$080
cop1lcl=$082
cop2lch=$084
cop2lcl=$086
copjmp1=$088
copjmp2=$08a
copins=$08c

;blitteroffsets
bltddat=$000
bltcon0=$040
bltcon1=$042
bltafwm=$044
bltalwm=$046
bltcpth=$048
bltcptl=$04a
bltbpth=$04c
bltbptl=$04e
bltapth=$050
bltaptl=$052
bltdpth=$054
bltdptl=$056
bltsize=$058
bltcmod=$060
bltbmod=$062
bltamod=$064
bltdmod=$066
bltcdat=$070
bltbdat=$072
bltadat=$074

start:
	move.l	execbase,a6
	jsr	forbid(a6)

bsr	getparameter	;table in a1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	bsr.w	textcalc1
	bsr.w	textcalc2
	move.b	$a(a5),mousemem
	bsr.w	mouse
	bsr.w	putarrow

	lea	mencol1(pc),a0
	lea	mencol2(pc),a2
	lea	tofade1(pc),a1
	lea	faded1(pc),a3
;	lea	piccol+2(pc),a4
	lea	unit+2,a4

	moveq	#15,d0
fadeinit1:
	move.l	#$0fff0fff,(a3)+
	move.w	#$0fff,(a3)+
	move.w	(a0)+,(a1)+
	move.w	(a2)+,(a1)+
	move.w	(a4)+,(a1)+
addq.l	#2,a4
	dbf	d0,fadeinit1
	move.w	#$0220,(a1)	;scrollcolour dest
	move.w	#$0fff,(a3)	;scrollcolour source
	move.w	#0,fadecount1
	bsr.w	fader1


	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	#3*4,turnaddx
	move.w	#0*4,turnaddy	;disable in turner-routine
	move.w	#1*4,turnaddz

	bsr.w	switchplanes
	bsr.w	turner
	bsr.w	hidesort

	lea	$dff000,a5
	move.w	#$03e0,dmacon(a5)
	move.w	#$1a71,diwstrt(a5)
	move.w	#$38e0,diwstop(a5)
	move.w	#$0028,ddfstrt(a5)
	move.w	#$00d8,ddfstop(a5)
	move.w	#%0110001000000000,bplcon0(a5)

	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
	move.w	#8+54*5,bpl1mod(a5)
	move.w	#8+54*5,bpl2mod(a5)
	move.l	#copperlist,cop1lch(a5)
	move.w	#0,copjmp1(a5)
	move.w	#%1000001111000000,dmacon(a5)
	move.l	#0,$dff144
	move.l	#0,$dff14c
	move.l	#0,$dff154
	move.l	#0,$dff15c
	move.l	#0,$dff164
	move.l	#0,$dff16c
	move.l	#0,$dff174
	move.l	#0,$dff17c

;move.l	#pr_data,pr_module
;jsr	pr_init

	move.w	#%0010000001100000,$dff09a
	move.l	$6c,oldint


	move.l	#firstint,$6c
	move.w	#%1100000000100000,$dff09a

;fadewait:
;cmp.w	#32,fadeflag1
;bne	fadewait

;-------------------
move.w	#1024*7,d0
move.w	d0,smallscrollrestart
move.w	d0,textpoint2

;move.w	#0,nosong
;lea	unitinfo,a1
;moveq	#0,d0
;moveq	#0,d1
;movem.w	4(a1),d0-d1		;get starttrack and length and disknumber
;lea	unit,a0			;unit adress
;jsr	loadtrack	;t!
;jsr	odeterm		;t!

bsr.w	getsong
;------------------------------------------------------------------
lea	unit,a1	;which pic (parameter for picdraw)
bsr.w	picdraw
bsr.w	printname
lea	allsongtimes(pc),a1		;timecounter for all songs
move.w	(a1),songtime
move.w	songtime,time

move.l	#pr_data,pr_module
bsr.w	pr_init
move.w	#1,nosong


bsr.w	fadeunit

move.l	#introut,$6c

	move.l	#0,$dff144
	move.l	#0,$dff14c
	move.l	#0,$dff154
	move.l	#0,$dff15c
	move.l	#0,$dff164
	move.l	#0,$dff16c
	move.l	#0,$dff174
	move.l	#0,$dff17c

wait:
	bsr.w	printtime
	btst	#10,$dff016	;right mouse ?
	beq.w back

	btst	#6,$bfe001	;left mouse ?
	bne.b	wait

	move.w	#1,noselect

;set little scroller
	move.w	#1024*7,d0
	move.w	d0,smallscrollrestart
	move.w	d0,textpoint2

;fade music out...

	move.w	selectpiece,d0		;selected song
	cmp.w	lastpiece,d0
	beq.b	dontfadeblack
	bsr.w	muspicblack

dontfadeblack:
	move.w	#-1,pr_musicfadedirection

;...then wait 21 frames...

	moveq	#20,d7
waitsomeints:
	move.w	#0,intmark
waitsomeintsl1:
	tst.w	intmark
	beq.b	waitsomeintsl1
	dbf	d7,waitsomeints

;...then fade musicpic to black

	bsr.w	fadeunit

;wait till music faded out

musicoutwait:
	tst.w	pr_musicfadedirection
	bne.b	musicoutwait

move.w	#0,songchanged
	move.w	#0,nosong	;pr_music skipped in interrupt
move.l	#introut0,$6c
	bsr.w	pr_end
	move.w	#maxvolume,pr_musicfadedirection

	move.w	#0,intmark
waitint:
	tst.w	intmark
	beq.b	waitint

bsr.b	getsong


lea	unit,a1	;which pic (parameter for picdraw)
bsr.w	picdraw
bsr.w	printname
bsr.w	fadeunit

move.l	#pr_data,pr_module
bsr.w	pr_init
move.w	songtime,time
move.w	#1,nosong
move.l	#introut,$6c

fadeoutwait2:
	cmp.w	#30,fadeflag1
	bne.b	fadeoutwait2

move.w	#0,noselect
bra.w	wait

;------------------------------------------------------------
getsong:
	move.w	selectpiece,d0		;selected song
	cmp.w	lastpiece,d0
	beq.w	dontload
	move.w	selectpiece,lastpiece

	lea	allsongtimes(pc),a1		;timecounter for all songs
	add.w	d0,d0			;number*2 to wordoffset
	move.w	0(a1,d0.w),songtime	;set songcounter

	moveq	#0,d0
	move.w	selectpiece,d0		;selected song

	mulu	#12,d0			;length unitinfo for one song

	lea	unitinfo(pc),a1
	lea	(a1,d0.l),a1		;add the offset
	move.l	(a1),a0			;get memory adress
	cmp.l	#0,a0
	beq.b	diskload
	tst.l	(a0)			;0=mem avail, but dule not loaded
	beq.b	diskload
;a0=decrunchadress	(destination)
;a1=crunched data	(source)
	move.l	a0,a1
	lea	unit,a0
	bsr.w	determ
	bra.b	ramloaded

diskload:
move.l	a1,-(a7)	;save akt unitinfo
;loader, unitinfo=a1
moveq	#0,d0
moveq	#0,d1
movem.w	4(a1),d0-d1		;get starttrack and length
move.l	8(a1),d2		;checksum
lea	unit,a0			;unit adress

	bsr.w	searchdisk
	bsr.w	loadtrack
	move.l	(a7)+,a1
	move.l	(a1),a0			;get memory adress
	cmp.l	#0,a0
	beq.b	nomemavail

	lea	unit,a1		;crunched adress
	move.l	(a1),d0		;crunched length to copy crunched data
	lsr.l	#2,d0
storeloop:
	move.l	(a1)+,(a0)+
	dbf	d0,storeloop


nomemavail:
bsr.w	odeterm

ramloaded:
dontload:
rts
;--------------------------------------------------------------------

getparameter:
lea	unitinfo(pc),a0
addq.l	#1,a1
move.b	(a1)+,availdrives
;move.l	$100,a1

move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0
move.l	(a1)+,(a0)
add.l	#12,a0

rts


unitusing:	dc.w	-1	;music playing; pic shown, scroller
unitinfo:
;unit 1
dc.l	0	;memory-adress of unit or 0 for nomem available
dc.w	49,34	;track startnumber, length tracks
dc.l	$a5901a67	;checksum of disc

;unit 2
dc.l	0
dc.w	83,40
dc.l	$a5901a67

;unit 3
dc.l	0
dc.w	123,37
dc.l	$a5901a67

;unit 4
dc.l	0
dc.w	1,39
dc.l	$ea59b964

;unit 5
dc.l	0
dc.w	41,34
dc.l	$ea59b964

;unit 6
dc.l	0
dc.w	75,15
dc.l	$ea59b964

;unit 7
dc.l	0
dc.w	90,39
dc.l	$ea59b964

;unit 8 (endpart
dc.l	0
dc.w	129,17
dc.l	$ea59b964

;if the first longword of the unit is zero, then then memory is
;available, but the unit not loaded yet.

back:
;---------------------------------------------------------------
;set little scroller
	move.w	#1024*7,d0
	move.w	d0,smallscrollrestart
	move.w	d0,textpoint2

;fade music out...
	bsr.w	muspicblack
	move.w	#-1,pr_musicfadedirection

;...then wait 21 frames...

	moveq	#20,d7
waitsomeints2:
	move.w	#0,intmark
waitsomeints2l1:
	tst.w	intmark
	beq.b	waitsomeints2l1
	dbf	d7,waitsomeints2

;...then fade musicpic to black

	bsr.w	fadeunit

;wait till music faded out

musicoutwait2:
	tst.w	pr_musicfadedirection
	bne.b	musicoutwait2

	move.w	#0,songchanged
	move.w	#0,nosong	;pr_music skipped in interrupt
	move.l	#introut0,$6c
	bsr.w	pr_end
	move.w	#maxvolume,pr_musicfadedirection

	move.w	#0,intmark
waitint2:
	tst.w	intmark
	beq.b	waitint2
;---------------------------------------------------------------
	moveq	#7,d0			;selected song (endpart)
	mulu	#12,d0			;length unitinfo for one song
	lea	unitinfo(pc),a1
	lea	(a1,d0.l),a1		;add the offset
	moveq	#0,d0
	moveq	#0,d1
	movem.w	4(a1),d0-d1		;get starttrack and length
	move.l	8(a1),d2		;checksum
	lea	unit,a0			;unit adress

	bsr.w	searchdisk
	bsr.w	loadtrack

;---------------------------------------------------------------
	lea	tofade1(pc),a1
	moveq	#15,d0
fadeout:
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	dbf	d0,fadeout
	move.w	#$0,(a1)	;scrollcolour dest
	move.w	#$0,(a3)	;scrollcolour source
	move.w	#6,fadecount1
	bsr.w	fader1

fadeoutwait:
	cmp.w	#30,fadeflag1
	bne.b	fadeoutwait

;musicoutwait3:
;	tst.w	pr_musicfadedirection
;	bne.b	musicoutwait3


move.w	#0,nosong
move.w	#0,intmark
waitint3:
tst.w	intmark
beq.b	waitint3		;safety-exit

;	move.l	#introut0,$6c	;alter verticalvector
move.l	oldint,$6c
;-------
	lea	unit,a1
	rts
;-------

;	move.l	execbase,a6
;	lea	$dff000,a5
;	lea	grname,a1
;	moveq	#0,d0
;	jsr	openlibrary(a6)
;	move.l	d0,a4
;	move.l	startlist(a4),cop1lch(a5)
;	clr.w	copjmp1(a5)
;	move.w	#%1000001111100000,dmacon(a5)
;	jsr	permit(a6)
;	clr.l	d0
;	rts

muspicblack:
	lea	unit+2,a4
	moveq	#15,d0
muspicblackl1:
	move.w	#0,(a4)+
	addq.l	#2,a4
	dbf	d0,muspicblackl1
rts

introut0:
	btst.b	#5,$dff01e+1
	beq.b	intback0
movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a5
	bsr.w	scroll2copy

	lea	menpic,a0
	moveq	#54,d0

	move.l	a0,bpl1pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl2pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl3pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl4pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl5pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl6pth(a5)
bsr.w	realfade1
bsr.w	scroller1
bsr.w	scroller2
;������������������������������
tst.w	nosong
beq.b	skipsong2
bsr.w	pr_music
lea	$dff000,a5
skipsong2:
;������������������������������

bsr.w	switchplanes


move.w	#1,intmark
movem.l	(a7)+,d0-d7/a0-a6
intback0:
;move.w	#$0fff,$dff19e
;move.w	#0,intwait
;move.w	#$0,$dff19e
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption



firstint:
	btst.b	#5,$dff01e+1
	beq.b	nofirstvbi
move.l	#introut0,$6c
nofirstvbi:
	move.w	#%0000000001100000,$dff09c
	rte

introut:			;interruptroutine
	btst.b	#5,$dff01e+1	;bit 5 testen(=verticalinterrupt)
	beq.w	intback		;nein,dann ist interrupt vom blitter
movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a5
bsr.w	scroll2copy	;9

	lea	menpic,a0
	moveq	#54,d0

	move.l	a0,bpl1pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl2pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl3pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl4pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl5pth(a5)
	lea	(a0,d0.w),a0
	move.l	a0,bpl6pth(a5)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++
bsr.w	veccls2		;14
bsr.w	realfade1
bsr.w	vecmove
;jsr	bltwait2

bsr.w	veccopy		;25
;������������������������������
tst.w	nosong
beq.b	skipsong
bsr.w	pr_music
lea	$dff000,a5
skipsong:
;������������������������������


;+++++++++++++++++++++++++++++++++++++++++++++++++++++
;jsr	printtime
bsr.b	scroller1	;4f
bsr.w	turner
bsr.w	scroller2	;26
;jsr	veccls		;1e
bsr.w	vecclsp		;1e

bsr.w	hidesort
bsr.w	drawline	;e
bsr.w	mouse
;+++++++++++++++++++++++++++++++++++++++++++++++++++++

bsr.w	switchplanes


	move.w	#1,intmark
movem.l	(a7)+,d0-d7/a0-a6
intback:
;move.w	#$000f,$dff19e
;move.w	#$0,$dff19e
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption

oldint:		dc.l	0

swapdiskonscreen:	dc.w	0
scrollpoint1:	dc.w	1
textpoint1:	dc.w	0
scrollpoint2:	dc.w	1
textpoint2:	dc.w	0
smallscrollrestart:	dc.w	0
songchanged:	dc.w	0
nosong:		dc.w	0
noselect:	dc.w	0
intmark:	dc.w	0

fadeunit:
	lea	mencol1(pc),a0
	lea	mencol2(pc),a2
	lea	tofade1(pc),a1
	lea	unit+2,a4
	moveq	#15,d0
fadeinit11:
	move.w	(a0)+,(a1)+
	move.w	(a2)+,(a1)+
	move.w	(a4)+,(a1)+
addq.l	#2,a4
	dbf	d0,fadeinit11
	move.w	#$0220,(a1)	;scrollcolour dest
	move.w	#4,fadecount1
	bsr.w	fader1
rts


scroller1:
subq.w	#1,scrollpoint1
bne.b	nonewchar1

	lea	offsettext1,a0
	lea	proptext1,a1
	move.w	textpoint1,d0
	move.w	(a0,d0.w),d1
	bpl.b	notextrestart1
	moveq	#0,d0
	move.w	(a0,d0.w),d1

notextrestart1:
	move.w	(a1,d0.w),scrollpoint1

	addq.w	#2,d0
	move.w	d0,textpoint1

;move.w	#64,scrollpoint1
lea	menpic+54*6*95+46+54*4,a0
lea	menubigfont(pc),a1
lea	0(a1,d1.w),a1

moveq	#41,d0
putchar1:
move.l	(a1)+,(a0)+
move.l	(a1)+,(a0)+
lea	54*6-8(a0),a0
dbf	d0,putchar1

nonewchar1:
;jsr	realfade1
;move.w	#$fff,$dff180
bsr.w	bltwait
;move.w	#$0,$dff180


	move.l	#menpic+54*6*95+0+54*4,d0

	move.l	d0,bltdpth(a5)
	addq.l	#2,d0
	move.l	d0,bltapth(a5)
;	move.l	#%11111111111111111111111100000000,bltafwm(a5)
	move.l	#%11111111111111111111111111111111,bltafwm(a5)

	move.w	#54*5,d0
	move.w	d0,bltamod(a5)
	move.w	d0,bltdmod(a5)
	move.l	#%11101001111100000000000000000000,bltcon0(a5);0+1
	move.w	#42*64+27,bltsize(a5)


noscroll:
rts

scroller2:
subq.w	#1,scrollpoint2
bne.b	nonewchar2

	lea	offsettext2,a0
;	lea	proptext2,a1
	move.w	textpoint2,d0
	move.w	(a0,d0.w),d1
	bpl.b	notextrestart2
;	moveq	#0,d0
move.w	smallscrollrestart,d0
	move.w	(a0,d0.w),d1

notextrestart2:
	move.w	#8,scrollpoint2

	addq.w	#2,d0
	move.w	d0,textpoint2


;lea	menpic+54*6*135+30,a0
lea	scrollplane+30,a0
lea	menusmallfont(pc),a1
;lea	(9*5)*1(a1),a1
lea	0(a1,d1.w),a1
	moveq	#8,d0
putchar2l1:
	move.b	9*0(a1),54*0(a0)
	move.b	9*1(a1),54*1(a0)
	move.b	9*2(a1),54*2(a0)
	move.b	9*3(a1),54*3(a0)
	move.b	9*4(a1),54*4(a0)

addq.l	#1,a1
lea	54*6(a0),a0
dbf	d0,putchar2l1


nonewchar2:

bsr.w	scroll2move


noscroll2:
rts






menubigfont:
incbin "data/menufont"
incbin "data/menufont2"

menusmallfont:
incbin "data/menusmallfont"



propcode1:
dc.w	32,38,35,34,37,33,32,40,39,17,26,36,32,49,35,40,32,40,37,28,31
dc.w	38,35,49,38,36,33,32,17,24,26,28,24,28,26,28,29,40,9,9,9,9,13
dc.w	13,8,25,17,27

textcalc1:
lea	asciitext1,a0
lea	offsettext1,a1
lea	proptext1,a3
lea	propcode1(pc),a4
move.w	#textend1-asciitext1-1,d0
textcalcloop1:
moveq	#0,d1
move.b	(a0)+,d1
moveq	#textcharsend1-textchars1-1,d2
lea	textchars1+(textcharsend1-textchars1),a2
asciicodeseek1:
cmp.b	-(a2),d1
beq.b	gotcode1
dbf	d2,asciicodeseek1

gotcode1:
move.l	d2,d3
mulu.w	#336,d2
move.w	d2,(a1)+
add.w	d3,d3
move.w	(a4,d3.w),d2
add.w	#3,d2
lsr.w	#1,d2
move.w	d2,(a3)+
dbf	d0,textcalcloop1
move.w	#-1,(a1)
rts





textcalc2:
lea	asciitext2,a0
lea	offsettext2,a1
;lea	proptext2,a3
;lea	propcode2,a4
move.w	#textend2-asciitext2-1,d0
textcalcloop2:
moveq	#0,d1
move.b	(a0)+,d1
move.w	d1,d2
ext.w	d2
bmi.b	gotcode2
moveq	#textcharsend2-textchars2-1,d2
lea	textchars2+(textcharsend2-textchars2),a2
asciicodeseek2:
cmp.b	-(a2),d1
beq.b	gotcode2
dbf	d2,asciicodeseek2

gotcode2:
move.l	d2,d3
mulu.w	#9*5,d2
move.w	d2,(a1)+
;add.w	d3,d3
;move.w	(a4,d3.w),d2
;add.w	#3,d2
;lsr.w	#1,d2
;move.w	d2,(a3)+
dbf	d0,textcalcloop2
move.w	#-1,(a1)
rts








printname:
lea	songscrollbase,a2
move.w	selectpiece,d2
lsl.w	#8,d2
lsl.w	#2,d2
lea	0(a2,d2.w),a2

lea	menpic+54*6*238+13,a4

moveq	#15,d4
printnamel1:
move.l	a4,a0
move.w	(a2)+,d1
bsr.w	putsmallchar
addq.l	#1,a4

dbf	d4,printnamel1
sub.l	#songscrollbase,a2
move.w	a2,smallscrollrestart
move.w	a2,textpoint2
rts


time:	dc.w	0
songtime:	dc.w	0
allsongtimes:	
	dc.w	14304-96	;angry heart
	dc.w	17688	;cry
	dc.w	15104	;fusion
	dc.w	17238-896	;third kiss
	dc.w	18596	;dawn of creation
	dc.w	6528	;waiting
	dc.w	16528	;angelo di luce


printtime:
moveq	#0,d4
moveq	#0,d1
move.w	time,d1
divu.w	#50,d1	;interrupts to seconds
move.w	d1,d4

divu.w	#60,d4	;/60 (seconds to minutes)
move.w	d4,d1
mulu.w	#9*5,d1		;charoffset
add.w	#9*5*27,d1

lea	menpic+54*6*198+13,a4

move.l	a4,a0
bsr.b	putsmallchar
addq.l	#2,a4


move.w	#0,d4
swap	d4
divu	#10,d4
move.w	d4,d1
mulu.w	#9*5,d1		;charoffset
add.w	#9*5*27,d1


move.l	a4,a0
bsr.b	putsmallchar
addq.l	#1,a4



move.w	#0,d4
swap	d4
move.w	d4,d1
mulu.w	#9*5,d1		;charoffset
add.w	#9*5*27,d1


move.l	a4,a0
bsr.b	putsmallchar



rts




putsmallchar:

lea	menusmallfont(pc),a1
;lea	(9*5)*1(a1),a1
lea	0(a1,d1.w),a1

	moveq	#8,d0
putsmallcharl1:
	move.b	9*0(a1),54*0(a0)
	move.b	9*1(a1),54*1(a0)
	move.b	9*2(a1),54*2(a0)
	move.b	9*3(a1),54*3(a0)
;	move.b	9*4(a1),54*4(a0)

addq.l	#1,a1
add.l	#54*6,a0
dbf	d0,putsmallcharl1
rts




arrowpoint:	dc.w	0*10*6*54
selectpiece:	dc.w	0
lastpiece:	dc.w	-1
availdrives:	dc.b	%00101000,0

arrowdat:
incbin "data/menupfeil"
even

putarrow:
lea	menpic+54*6*10+19,a0
move.w	arrowpoint,d0
lea	0(a0,d0.w),a0
lea	arrowdat(pc),a1

	moveq	#6,d0
putarrowl1:
	move.b	(a1),54*0(a0)
	move.b	7(a1),54*1(a0)
	move.b	14(a1),54*2(a0)
	move.b	21(a1),54*3(a0)
	move.b	28(a1),54*4(a0)

addq.l	#1,a1
lea	54*6(a0),a0
dbf	d0,putarrowl1
move.w	#1,songchanged

rts

clrarrow:
lea	menpic+54*6*10+19,a0
move.w	arrowpoint,d0
lea	0(a0,d0.w),a0

	moveq	#-1,d1
	moveq	#8,d0
clrarrowl1:
	move.b	d1,54*0(a0)
	move.b	d1,54*1(a0)
	move.b	d1,54*2(a0)
	move.b	d1,54*3(a0)
	move.b	d1,54*4(a0)

lea	54*6(a0),a0
dbf	d0,clrarrowl1
rts



scroll2copy:
	move.l	#menpic+54*6*151+14+54*0,d0
	move.l	#scrollplane+14,d1
	bsr.w	bltwait

	move.l	d0,bltdpth(a5)
	move.l	d1,bltapth(a5)
	move.l	#%11111111111111111111111111111111,bltafwm(a5)

	move.w	#38+54*0,bltamod(a5)
	move.w	#38+54*0,bltdmod(a5)
	move.l	#%00001001111100000000000000000000,bltcon0(a5);0+1
	move.w	#9*6*64+8,bltsize(a5)
rts


scroll2move:
	bsr.w	bltwait

;	move.l	#menpic+54*6*135+14+54*0-2,d0
	move.l	#scrollplane+14-2,d0

;	move.l	#menpic+54*6*135+14+54*0+0,d1
	move.l	#scrollplane+14,d1

	move.l	d0,bltdpth(a5)
	move.l	d1,bltapth(a5)
	move.l	#%11111111111111111111111111111111,bltafwm(a5)

	move.w	#34+54*0,bltamod(a5)
	move.w	#34+54*0,bltdmod(a5)
	move.l	#%11111001111100000000000000000000,bltcon0(a5);0+1
	move.w	#9*6*64+10,bltsize(a5)
rts

mousemem:	dc.b	0
even

mouse:
tst.w	noselect
bne.b	dontaskmouse
moveq	#0,d3
	move.b	mousemem,d0		;mousemem
	move.b	$00a(a5),d1		;mousereg
	sub.b	d1,d0
	roxr.b	#1,d3
	bpl.b	nichtneg
	neg.b	d0
nichtneg:
	cmp.b	#$19,d0
	ble.b	notmoved
gemoved:
	move.b	d1,mousemem
	cmp.b	#$50,d0
	bge.b	notmoved

	tst.b	d3
	beq.b	up

;cmp.w	#5*10*6*54,arrowpoint
cmp.w	#6,selectpiece
beq.b	notmoved
bsr.w	clrarrow
add.w	#10*6*54,arrowpoint
addq.w	#1,selectpiece
bsr.w	putarrow
dontaskmouse:
rts

up:
;cmp.w	#0,arrowpoint
tst.w	selectpiece
beq.b	notmoved
bsr.w	clrarrow
sub.w	#10*6*54,arrowpoint
subq.w	#1,selectpiece
bsr.w	putarrow
rts

;	btst	#6,$bfe001
;	btst	#10,$dff016


notmoved:
rts


picdraw:	;got unit in a1
;lea	piccol,a0
lea	unit,a0
moveq	#15,d0
swapdiskcolcopyl1:
addq.l	#2,a1	;skip colregister in copperlist
addq.l	#2,a0
move.w	(a1)+,(a0)+
;addq.l	#2,a1
;addq.l	#2,a0	;skip colregister in colourtable
dbf	d0,swapdiskcolcopyl1

;picdraw:	;got unit in a1
;add.l	#16*4,a1

;lea	menpic+54*6*170+28,a0
lea	menpic+54*6*170+28,a0

	moveq	#101,d0		;102 lines y
picdrawl1:
	moveq	#3,d1		;4 planes
picdrawl2:
	moveq	#8,d2		;9words
picdrawl3:
	move.w	(a1)+,(a0)+

	dbf	d2,picdrawl3	;next word

	add.l	#54-9*2,a0

	dbf	d1,picdrawl2	;next plane
	add.l	#54*2,a0	;skip plane 6 and 1
	dbf	d0,picdrawl1	;next line
	rts


odeterm:
;------------------------------------------------------------------------
;---          BYTESTRING decrunchroutine by Moon/LUNATICS             ---
;------------------------------------------------------------------------
	lea	unit,a0		;decrunched adress
	move.l	a0,a1		;decrunched adress...
	add.l	4(a0),a1	;...+decrunched length
	move.l	(a0),d3		;crunched length to copy crunched data
	add.l	d3,a0
odatacopyloop:
	move.b	-(a0),-(a1)
	subq.l	#1,d3
	bne.b	odatacopyloop
	lea	unit,a0		;decrunched adress

move.l	(a0)+,d1	;crunched length
move.l	(a0)+,d2	;decrunched length
tst.b	(a0)+		;routine-code
move.b	(a0)+,d0	;codebyte

add.l	#4+4+1+1,a1
sub.l	#4+4+1+1,a0

sub.l	#4+4+1+1-1,d1


odecrunchl1:
cmp.b	(a1)+,d0
bne.b	odecrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3
;move.w	$dff006,$dff180

odecrunchl4:
move.b	d3,(a0)+
dbf	d2,odecrunchl4
subq.l	#3,d1
bra.b	odecrunchl3



odecrunchl2:
move.b	-1(a1),(a0)+
subq.l	#1,d1

odecrunchl3:
bne.b	odecrunchl1

rts


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


loader:
;a1 = crunched data adress
lea	unit,a0
move.l	(a1),d0
lsr.l	#2,d0
loaderloop:
;move.w	a1,$dff180
move.l	(a1)+,(a0)+
subq.l	#1,d0
bne.b	loaderloop
rts


moondecoder:
movem.l	d0-a6,-(a7)
move.l	a0,a4
;lea	trackbuffer(pc),a0
lea	trackbuffer,a0
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

;move.l	#2000,d0
checksumbug:
;move.w	#$00f0,$dff19e
;move.w	#$0,$dff19e
;sub.l	#1,d0
;bne.b	checksumbug

;bra.b	checksumbug
movem.l	(a7)+,d0-a6
addq.w	#1,readerror
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

move.w	#0,readerror
rereadloop:
bsr.w	readtrack
bsr.w	moondecoder
tst.w	readerror
beq.b	noreaderror

;cmp.w	#5,readerror
;bne	rereadloop
move.w	#0,readerror
bsr.w	sethead
bra.b rereadloop


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

aktdrive:	dc.w	3

searchdisk:
movem.l	d0-d2/a0,-(a7)
;a0=destination adress
;d0=starttrack
;d1=length tracks
	moveq	#0,d0
	moveq	#1,d1
	lea	$bfd100,a6

repeatsearch:
	move.w	#3,aktdrive	;df0-df3 = bit 3-6
	moveq	#3,d5		;number of drives to test

searchdiskl1:
	lea	$bfd100,a6
	bsr.w	waitaline
	move.b	#%11111011,$bfd100
	bsr.w	waitaline
	moveq	#0,d6
	move.w	aktdrive,d6
	btst.b	d6,availdrives
	beq.b	drivenotready
	bclr.b	d6,$bfd100		;select drive
	bsr.w	waitaline


waitfordrive:
	btst.b	#5,$bfe001	;drive ready?
;	bne	waitfordrive

	btst.b	#4,$bfe001	;CIA-A PRA(bfe001), bit4=track00
	bne.b	notzero
	bclr.b	#1,$bfd100	;change direction
	bsr.w	waitaline
notzero:
	bclr.b	#0,$bfd100	;CIA-B PRB, step signal
	bsr.w	waitaline
	bset.b	#0,(a6)		;CIA-B PRB, step signal
	moveq	#64,d7		;number of rasterlines to wait...
	bsr.w	timewait
	btst.b	#2,$bfe001	;CIA-A PRA dskcange
	beq.b	drivenotready	
	bsr.w	askdisk
	beq.w	diskfound


drivenotready:
	lea	$bfd100,a6
	move.b	#%11111011,(a6)
	bsr.w	waitaline
	moveq	#0,d6
	move.w	aktdrive,d6
	bclr.b	d6,(a6)		;select drive
	bsr.w	waitaline
	bset.b	d6,(a6)		;select drive
;;
;	move.b	#%11111001,(a6)


;move.b	#%01111111,(a6)

addq.w	#1,aktdrive
;--------------
;	move.w	#100,d7
;qinsertdisksleepl2:
;	move.w	#0,intmark
;qinsertdisksleepl1:
;	move.w	#0,$dff19e
;	tst.w	intmark
;	beq	qinsertdisksleepl1
;	dbf	d7,qinsertdisksleepl2
;--------------
dbf	d5,searchdiskl1
tst.w	swapdiskonscreen
bne.b	noswapdiskonscreen

move.w	#1,swapdiskonscreen
movem.l	d0-a6,-(a7)

lea	swapdiskunit,a1	;which pic (parameter for picdraw)
lea	trackbuffer,a0
bsr.w	determ



;lea	swapdiskunit,a1	;which pic (parameter for picdraw)
lea	trackbuffer,a1
bsr.w	picdraw
bsr.w	fadeunit

;move.w	#1000,d0
;flash:
;dbf	d0,flash

movem.l	(a7)+,d0-a6

noswapdiskonscreen:
	move.w	#150,d7
insertdisksleepl2:
	move.w	#0,intmark
insertdisksleepl1:
;	move.w	$dff006,$dff19e
	tst.w	intmark
	beq.b	insertdisksleepl1
	dbf	d7,insertdisksleepl2
	bra.w	repeatsearch

askdisk:
moveq	#0,d0
moveq	#1,d1
bsr.w	loadtrack
moveq	#64,d7		;number of rasterlines to wait...
bsr.w	timewait
move.b	#%01111111,(a6)
cmp.l	4(a0),d2
rts


diskfound:
move.w	#0,swapdiskonscreen
bsr.w	muspicblack
bsr.w	fadeunit
movem.l	(a7)+,d0-d2/a0
rts

sethead:
move.b	#%01111111,(a6)	;set all bits except dsk-motor
nop
nop
nop
;bclr	#0+3,(a6)	;bit 3=drive0select
moveq	#0,d7
move.w	aktdrive,d7
bclr	d7,(a6)	;bit 3=drive0select
nop
nop
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
move.l	#trackbuffer,$20(a5)
move.w	#$8000+6436,d2	;dma on, 6436 words length
move.w	d2,$24(a5)	;dsklen
move.w	d2,$24(a5)	;dsklen
move.w	#%0000000000000010,$9c(a5)	;intreq, clear disk-irq
;move.w	#%1000000000000010,$9a(a5)	;intreq, clear disk-irq

diskdmawait:
btst.b	#1,$1f(a5)	;intreq (lobyte)
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

waitaline:
	moveq	#3,d7
	bsr.b	timewait
	rts



;###################################################################
switchmark:	dc.w	0

switchplanes:
not.w	switchmark

beq.b	switchplanesl1
	move.l	#plane2,vecdrawplane
	move.l	#plane1,vecshowplane
rts

switchplanesl1:
	move.l	#plane1,vecdrawplane
	move.l	#plane2,vecshowplane
	rts

vecshowplane:	dc.l	0
vecdrawplane:	dc.l	0





turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0

linemask:	dc.w	$ffff

;------------------------------------------------------------------------
turner:	;last optimizing:92-08-26
	move.w	turnx,a1
	add.w	turnaddx,a1
	cmp.w	#1436,a1
	ble.b nolaufx
	sub.w	#1440,a1
nolaufx:
	move.w	a1,turnx

	move.w	turny,a2
	add.w	turnaddy,a2
	cmp.w	#1436,a2
	ble.b nolaufy
	sub.w	#1440,a2
nolaufy:
	move.w	a2,turny

	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble.b nolaufz
	sub.w	#1440,a0
nolaufz:
	move.w	a0,turnz


turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sinus(pc),a6	;sinus/cosinus
	move.w	turnquant,d0
	lsl.w	#3,d0		;*8 als offset/koord
turnrout1:

	move.l	0(a6,a0.w),d5	;d5:hiword=sin z ,loword=cos z 
	move.l	2(a3,d0.w),d3	;d3:hi=x , lo=y
	move.w	d3,d4		;d4=y
	swap	d3		;d3.w=x
	move.w	d3,d6		;d6=x
	move.w	d4,d7		;d7=y
	muls.w	d5,d3		;d3=x*cos z
	muls.w	d5,d7		;d7=y*cos z
	swap	d5
	muls.w	d5,d4		;d4=y*sin z
	muls.w	d5,d6		;d6=x*sin z
	sub.l	d4,d3		;d3=x*cos z - y*sin z  ->new  x-koord
	swap	d3
rol.l	#1,d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	swap	d6
rol.l	#1,d6
move.w	d3,d1
	move.w	d3,2(a4,d0.w)
;	move.w	d6,4(a4,d0.w)


	move.l	0(a6,a1.w),d5	;d5:hiword=sin z ,loword=cos z 
;	move.w	4(a4,d0.w),d3	;d3=y
move.w	d6,d3
	move.w	6(a3,d0.w),d4	;d4=z
	move.w	d3,d6		;d6=y
	move.w	d4,d7		;d7=z
	muls.w	d5,d3		;d3=y*cos x
	muls.w	d5,d7		;d7=z*cos x
	swap	d5
	muls.w	d5,d4		;d4=z*sin x
	muls.w	d5,d6		;d6=y*sin x
	sub.l	d4,d3		;d3=y*cos x - z*sin x ->new y-koord
	swap	d3
rol.l	#1,d3
	add.l	d7,d6		;d6=y*sin x + z*cos x
	swap	d6
rol.l	#1,d6
	move.w	d3,4(a4,d0.w)


;********
move.w	d6,6(a4,d0.w)
	subq.w	#8,d0
	bpl.b	turnrout1
	rts
;********


drawline:
	move.l	turnkoord,a1	;turned koordinates
	lea	areaoffsets,a3	;areas to draw
	move.w	(a3)+,d7	;areacount
	lea	arealines+2,a4	;linecodes for each area
drawloop1:		;mainloop for each area
	move.w	(a3)+,d6	;get offset of area 1
	move.w	(a4,d6.w),d5	;number of lines in this area
	move.w	2(a4,d6.w),-(a7);areacolour of stack
	move.w	#$7fff,d0
	move.w	d0,lox
	move.w	d0,loy
	moveq	#0,d0
	move.l	d0,hix;(+hiy)

lea	$dff000,a5
bsr.w	bltwait

move.l	#-1,bltafwm(a5)
move.w	#64,bltcmod(a5)
move.w	#64,bltdmod(a5)
move.w	#0,bltbdat(a5)
move.w	#$8000,bltadat(a5)

drawloop2:
moveq	#90,d0
add.b	d0,d0
move.l	d0,d2
moveq	#127,d1

move.l	4(a4,d6.w),d4	;pointcode1+2
move.l	2(a1,d4.w),d3
add.w	d3,d1
swap	d3
add.w	d3,d0
addq.w	#2,d6	;cant remove this
swap	d4
moveq	#127,d3
move.l	2(a1,d4.w),d4
add.w	d4,d3
swap	d4
add.w	d4,d2


bsr.w	draw

dbf	d5,drawloop2
addq.w	#1,hiy	;highest x +1 coz difference 0-->1 line to blit
add.w	#16,hix
and.w	#%1111111111110000,hix
and.w	#%1111111111110000,lox

move.w	lox,d0		;lowest x	      	PLANEOFFSET CALCULATION
lsr.w	#4,d0		;/16=words
add.w	d0,d0		;*2=bytes from left border

move.w	loy,d1		;lowest y-koord
lsl.w	#6,d1		;*64 (bytes/line)
move.w	d1,d4		;copy for later use
add.w	d0,d1		;x-offset + y-offset...
sub.w	#64*90+18,d1
move.w	d1,planeoffsets	;...=planeoffset for blitterwindow sourcescreen

;move.w	loy,d4		;again lowest y-koord
;lsl.w	#6,d4		;*(64*3) (bytes/line)
move.w	d4,d1
;add.w	d4,d1
;add.w	d4,d1
add.w	d0,d1
sub.w	#64*90+18,d1
move.w	d1,planeoffsetd	;planeoffset for destination screen


moveq	#64,d0		;64 bytes/line		MODULO CALCULATION
move.w	hix,d1		;highest x...
sub.w	lox,d1		;...-lowest x
lsr.w	#4,d1		;/16=words
sub.w	d1,d0		;64-words...
sub.w	d1,d0		;...again -words --> 64-bytes
move.w	d0,planemodulos	;modulo=modulo source
;add.w	#64+64,d0	;modulo+64+64...
move.w	d0,planemodulod	;...=modulo destination


move.w	hiy,d2	;highest y-value...			BLTSIZE CALC
sub.w	loy,d2	;...-lowest y-value
lsl.w	#6,d2	;*64
add.w	d1,d2	;bltsize =y*64+x
move.w	d2,planesize	;planesize for source and destination

add.w	planeoffsets,d2
add.w	#4,d2
move.w	d2,planeoffsetf	;offset for filling (fill uses descending mode)

move.w	planesize,planesizef
move.w	planemodulos,planemodulof

addq.w	#6,planesizef
sub.w	#12,planemodulof
addq.w	#6,planeoffsetf

move.w	(a7)+,d0;areacolour from stack
	bsr.w	planefillcopycls
dbf	d7,drawloop1

rts



bltwait:
	btst	#14,dmaconr(a5)
	bne.b	bltwait
rts


bltwait2:
bltwait2loop:
;move.w	#$0f00,$19e(a5)
	btst	#14,dmaconr(a5)
	bne.b	bltwait2loop
;move.w	#$0,$dff19e
rts


veccls:
lea	$dff000,a5
move.l	vecshowplane,d1	;now show=then draw

bsr.b	bltwait
move.l	d1,bltdpth(a5)
move.w	#32-4+24+2,bltdmod(a5)
move.w	#0,bltcon1(a5)
move.w	#%0000000100000000,bltcon0(a5)
move.w	#72*64+5,bltsize(a5)

rts

vecclsp:
move.l	vecshowplane,a0	;now show=then draw


moveq	#0,d0
moveq	#0,d1
moveq	#0,d2
moveq	#0,d3
moveq	#0,d4

moveq	#71,d7
vecclspl1:
movem.w	d0-d4,(a0)
lea	64(a0),a0
dbf	d7,vecclspl1
rts


move.l	d1,bltdpth(a5)
move.w	#32-4+24+2,bltdmod(a5)
move.w	#0,bltcon1(a5)
move.w	#%0000000100000000,bltcon0(a5)
move.w	#72*64+5,bltsize(a5)

rts

vecobjects:
			;dont change order of this lines
	dc.w	50	;------------------------------
	dc.w	50
	dc.w	1
	dc.w	2

	dc.w	100
	dc.w	100
	dc.w	-1
	dc.w	2

	dc.w	150
	dc.w	150
	dc.w	2
	dc.w	-3

	dc.w	100
	dc.w	50
	dc.w	2
	dc.w	1

	dc.w	100
	dc.w	100
	dc.w	2
	dc.w	2

	dc.w	100
	dc.w	150
	dc.w	2
	dc.w	3

	dc.w	150
	dc.w	50
	dc.w	3
	dc.w	1

	dc.w	150
	dc.w	100
	dc.w	3
	dc.w	2

	dc.w	150
	dc.w	150
	dc.w	3
	dc.w	3

	dc.w	20
	dc.w	70
	dc.w	4
	dc.w	3

			;-------------------------------

vecmove:
moveq	#2,d3
lea	vecobjects(pc),a0

vecmoveloop:
move.w	(a0),d0
move.w	2(a0),d1
add.w	4(a0),d0
add.w	6(a0),d1


cmp.w	#10,d0
bhs.b	noxchangelo
neg.w	4(a0)
bra.b	noxchange

noxchangelo:
cmp.w	#300,d0
bls.b	noxchangehi
neg.w	4(a0)

noxchangehi:
noxchange:



cmp.w	#3,d1
bhs.b	noychangelo
neg.w	6(a0)
bra.b	noychange

noychangelo:
cmp.w	#215,d1
bls.b	noychangehi
neg.w	6(a0)

noychangehi:
noychange:


move.w	d0,(a0)
move.w	d1,2(a0)
addq.l	#8,a0
dbf	d3,vecmoveloop
rts


veccopy:
moveq	#2,d5
lea	vecobjects(pc),a1

veccopyloop:
lea	menpic+54*5,a0
move.w	#%0000110111111100,d3
moveq	#0,d4
move.w	2(a1),d4
mulu.w	#54*6,d4

moveq	#0,d1
move.w	(a1),d1
ror.l	#4,d1
add.w	d1,d1
add.w	d1,d4
swap	d1
or.w	d1,d3

lea	(a0,d4.l),a0

move.l	vecshowplane,d1	;now show=then draw

bsr.w	bltwait
move.l	a0,bltdpth(a5)
move.l	a0,bltbpth(a5)
move.l	d1,bltapth(a5)

move.w	#32-4+24+2,bltamod(a5)
move.w	#32-4+24-10+2+54*5,bltdmod(a5)
move.w	#32-4+24-10+2+54*5,bltbmod(a5)
move.w	#0,bltcon1(a5)
move.w	d3,bltcon0(a5)
move.w	#72*64+5,bltsize(a5)

addq.l	#8,a1
dbf	d5,veccopyloop
rts


veccls2:
moveq	#2,d5
lea	vecobjects(pc),a1

veccls2loop:
lea	menpic+54*5,a0
move.w	#%0000000100000000,d3

move.w	2(a1),d4
mulu.w	#54*6,d4

moveq	#0,d1
move.w	(a1),d1
ror.l	#4,d1
add.w	d1,d1
add.w	d1,d4
swap	d1
or.w	d1,d3

lea	(a0,d4.l),a0

bsr.w	bltwait

move.l	a0,bltdpth(a5)
move.w	#32-4+24-10+2+54*5,bltdmod(a5)
move.w	#0,bltcon1(a5)
	move.w	d3,bltcon0(a5)
move.w	#72*64+5,bltsize(a5)

addq.l	#8,a1
dbf	d5,veccls2loop

rts





turnx:	dc.w	0
turny:	dc.w	0
turnz:	dc.w	0
sinus:
dc.w  0, 32767, 572, 32763, 1144, 32748, 1715, 32723, 2286, 32688
dc.w  2856, 32643, 3425, 32588, 3993, 32524, 4560, 32449, 5126, 32365
dc.w  5690, 32270, 6252, 32166, 6813, 32052, 7371, 31928, 7927, 31795
dc.w  8481, 31651, 9032, 31499, 9580, 31336, 10126, 31164, 10668, 30983
dc.w  11207, 30792, 11743, 30592, 12275, 30382, 12803, 30163
dc.w  13328, 29935, 13848, 29698, 14365, 29452, 14876, 29197
dc.w  15384, 28932, 15886, 28660, 16384, 28378, 16877, 28088
dc.w  17364, 27789, 17847, 27482, 18324, 27166, 18795, 26842
dc.w  19261, 26510, 19720, 26170, 20174, 25822, 20622, 25466
dc.w  21063, 25102, 21498, 24730, 21926, 24351, 22348, 23965
dc.w  22763, 23571, 23170, 23170, 23571, 22763, 23965, 22348
dc.w  24351, 21926, 24730, 21498, 25102, 21063, 25466, 20622
dc.w  25822, 20174, 26170, 19720, 26510, 19261, 26842, 18795
dc.w  27166, 18324, 27482, 17847, 27789, 17364, 28088, 16877
dc.w  28378, 16384, 28660, 15886, 28932, 15384, 29196, 14876
dc.w  29452, 14365, 29698, 13848, 29935, 13328, 30163, 12803
dc.w  30382, 12275, 30592, 11743, 30792, 11207, 30983, 10668
dc.w  31164, 10126, 31336, 9580, 31499, 9032, 31651, 8481, 31795, 7927
dc.w  31928, 7371, 32052, 6813, 32166, 6252, 32270, 5690, 32365, 5126
dc.w  32449, 4560, 32524, 3993, 32588, 3425, 32643, 2856, 32688, 2286
dc.w  32723, 1715, 32748, 1144, 32763, 572, 32767, 0, 32763,-572
dc.w  32748,-1144, 32723,-1715, 32688,-2286, 32643,-2856, 32588,-3425
dc.w  32524,-3993, 32449,-4560, 32365,-5126, 32270,-5690, 32166,-6252
dc.w  32052,-6813, 31928,-7371, 31795,-7927, 31651,-8481, 31499,-9032
dc.w  31336,-9580, 31164,-10126, 30983,-10668, 30792,-11207, 30592,-11743
dc.w  30382,-12275, 30163,-12803, 29935,-13328, 29698,-13848
dc.w  29452,-14365, 29197,-14876, 28932,-15384, 28660,-15886
dc.w  28378,-16384, 28088,-16877, 27789,-17364, 27482,-17847
dc.w  27166,-18324, 26842,-18795, 26510,-19261, 26170,-19720
dc.w  25822,-20174, 25466,-20622, 25102,-21063, 24730,-21498
dc.w  24351,-21926, 23965,-22348, 23571,-22763, 23170,-23170
dc.w  22763,-23571, 22348,-23965, 21926,-24351, 21498,-24730
dc.w  21063,-25102, 20622,-25466, 20174,-25822, 19720,-26170
dc.w  19261,-26510, 18795,-26842, 18324,-27166, 17847,-27482
dc.w  17364,-27789, 16877,-28088, 16384,-28378, 15886,-28660
dc.w  15384,-28932, 14876,-29196, 14365,-29452, 13848,-29698
dc.w  13328,-29935, 12803,-30163, 12275,-30382, 11743,-30592
dc.w  11207,-30792, 10668,-30983, 10126,-31164, 9580,-31336, 9032,-31499
dc.w  8481,-31651, 7927,-31795, 7371,-31928, 6813,-32052, 6252,-32166
dc.w  5690,-32270, 5126,-32365, 4560,-32449, 3993,-32524, 3425,-32588
dc.w  2856,-32643, 2286,-32688, 1715,-32723, 1144,-32748, 572,-32763
dc.w  0,-32768,-572,-32763,-1144,-32748,-1715,-32723,-2286,-32688
dc.w -2856,-32643,-3425,-32588,-3993,-32524,-4560,-32449,-5126,-32365
dc.w -5690,-32270,-6252,-32166,-6813,-32052,-7371,-31928,-7927,-31795
dc.w -8481,-31651,-9032,-31499,-9580,-31336,-10126,-31164,-10668,-30983
dc.w -11207,-30792,-11743,-30592,-12275,-30382,-12803,-30163
dc.w -13328,-29935,-13848,-29698,-14365,-29452,-14876,-29196
dc.w -15384,-28932,-15886,-28660,-16384,-28378,-16877,-28088
dc.w -17364,-27789,-17847,-27482,-18324,-27166,-18795,-26842
dc.w -19261,-26510,-19720,-26170,-20174,-25822,-20622,-25466
dc.w -21063,-25102,-21498,-24730,-21926,-24351,-22348,-23965
dc.w -22763,-23571,-23170,-23170,-23571,-22763,-23965,-22348
dc.w -24351,-21926,-24730,-21498,-25102,-21063,-25466,-20622
dc.w -25822,-20174,-26170,-19720,-26510,-19261,-26842,-18795
dc.w -27166,-18324,-27482,-17847,-27789,-17364,-28088,-16877
dc.w -28378,-16384,-28660,-15886,-28932,-15384,-29196,-14876
dc.w -29452,-14365,-29698,-13848,-29935,-13328,-30163,-12803
dc.w -30382,-12275,-30592,-11743,-30792,-11207,-30983,-10668
dc.w -31164,-10126,-31336,-9580,-31499,-9032,-31651,-8481,-31795,-7927
dc.w -31928,-7371,-32052,-6813,-32166,-6252,-32270,-5690,-32365,-5126
dc.w -32449,-4560,-32524,-3993,-32588,-3425,-32643,-2856,-32688,-2286
dc.w -32723,-1715,-32748,-1144,-32763,-572,-32768, 0,-32763, 572
dc.w -32748, 1144,-32723, 1715,-32688, 2286,-32643, 2856,-32588, 3425
dc.w -32524, 3993,-32449, 4560,-32365, 5126,-32270, 5690,-32166, 6252
dc.w -32052, 6813,-31928, 7371,-31795, 7927,-31651, 8481,-31499, 9032
dc.w -31336, 9580,-31164, 10126,-30983, 10668,-30792, 11207,-30592, 11743
dc.w -30382, 12275,-30163, 12803,-29935, 13328,-29698, 13848
dc.w -29452, 14365,-29197, 14876,-28932, 15384,-28660, 15886
dc.w -28378, 16384,-28088, 16877,-27789, 17364,-27482, 17847
dc.w -27166, 18324,-26842, 18795,-26510, 19261,-26170, 19720
dc.w -25822, 20174,-25466, 20622,-25102, 21063,-24730, 21498
dc.w -24351, 21926,-23965, 22348,-23571, 22763,-23170, 23170
dc.w -22763, 23571,-22348, 23965,-21926, 24351,-21498, 24730
dc.w -21063, 25102,-20622, 25466,-20174, 25822,-19720, 26170
dc.w -19261, 26510,-18795, 26842,-18324, 27166,-17847, 27482
dc.w -17364, 27789,-16877, 28088,-16384, 28378,-15886, 28660
dc.w -15384, 28932,-14876, 29197,-14365, 29452,-13848, 29698
dc.w -13328, 29935,-12803, 30163,-12275, 30382,-11743, 30592
dc.w -11207, 30792,-10668, 30983,-10126, 31164,-9580, 31336,-9032, 31499
dc.w -8481, 31651,-7927, 31795,-7371, 31928,-6813, 32052,-6252, 32166
dc.w -5690, 32270,-5126, 32365,-4560, 32449,-3993, 32524,-3425, 32588
dc.w -2856, 32643,-2286, 32688,-1715, 32723,-1144, 32748,-572, 32763

;intwait:	dc.w	0

DRAW:
	lea	calcplane,a0	;planeadress
sub.l	#64*90+18,a0
	lea	octants(pc),a2	;octantbasis
	cmp.w	d1,d3		;compare y-value of the 2 points
	bgt.b	drawl1		;point 2 is greater--> okay
	beq.w	drawl2		;points equal, dont draw-->exit
	exg	D0,D2		;point 1 is greater-->swap x points
	exg	D1,D3		;...                       y

drawl1:	
;----------searching lowest x/y and highest x/y of polygon
;y-koord alredy sorted:y1 is always lower than y2
	cmp.w	lox,d0
	bhs.b	nonewlox1
	move.w	d0,lox
nonewlox1:

	cmp.w	lox,d2
	bhs.b	nonewlox2
	move.w	d2,lox
nonewlox2:

	cmp.w	loy,d1
	bhs.b	nonewloy
	move.w	d1,loy
nonewloy:

	cmp.w	hix,d0
	bls.b	nonewhix1
	move.w	d0,hix
nonewhix1:

	cmp.w	hix,d2
	bls.b	nonewhix2
	move.w	d2,hix
nonewhix2:

	cmp.w	hiy,d3
	bls.b	nonewhiy
	move.w	d3,hiy
nonewhiy:

;----------
	SUBQ.W	#1,D3		;y2=y2-1 
	SUB.W	D1,D3		;y2=y2-y1 , d3=ydiff (always positive)
	SUB.W	D0,D2		;x2=x2-x1 , d2=xdiff
	bpl.b	.OK2		;xdiff positive ?
	NEG.W	D2		;no-then make positive (xdiff=xdiff*-1)
	ADDQ.L	#8,A2		;octant adress
.OK2:	CMP.W	D2,D3		;xdiff,ydiff
	BLE.S	.OK3		;branch if xdiff>=ydiff
	ADDQ.L	#4,A2		;octopussy
	EXG	D2,D3		;xdiff<-->ydiff
.OK3:				;d2=HIdiff , d3=LOdiff
;d4 need first
	MOVE.L	(A2),D4		;get the pussy
	ROR.L	#3,D0		;d0.w=d0-w/8
	LEA	(A0,D0.W),A2	;a2=screenptr+x1-offset
;a0 free
	ROR.L	#1,D0		;d0/2 (d0.w = x1/16
	AND.L	#$F0000000,D0	;bit 12-15 =x1bit 0-3
	OR.L	D0,D4		;d4=octant or x1bits
	MOVE.W	D1,D0		;d0=y1

;	MULU.W	#64,D0		;d0=y1*screen offset
	lsl.w	#6,d0
	LEA	(A2,D0.W),A2	;a2=wordadress of x1/y1 
;a2 waits
	LSL.W	#1,D3		;d3=lodiff*2
	MOVE.W	D3,D0		;d0=lodiff*2
	SUB.W	D2,D3		;d3=lodiff*2-hidiff
;d3 waits
	BGE.S	.NOSIGN		;branch if lodiff*2 >hidiff
	OR.B	#$40,D4		;set bit 6	
;d4 waits
.NOSIGN:
	LSL.W		#1,D0		;d0=lodiff*4
	MOVE.W		D0,D1		;d1=lodiff*4
;d0 waits
	LSL.W		#2,D2		;d2=hidiff*4
	SUB.W		D2,D1		;d1=(lodiff*4) - (hidiff*4) 
;d1 waits
	ADDQ.W		#4,D2		;d2=hidiff*4+4
	LSL.W		#4,D2		;d2=(hidiff*4+4)*16
	ADDQ.W		#2,D2		;d2=(hidiff*4+4)*16+2
;d2 waits

lea	$dff000,a5
bsr.w	bltwait


move.w	d3,bltaptl(a5)

move.l	a2,bltcpth(a5)
move.l	a2,bltdpth(a5)

move.w	d0,bltbmod(a5)
move.l	d4,bltcon0(a5)
move.w	d1,bltamod(a5)
move.w	d2,bltsize(a5)


drawl2:
	RTS


OCTANTS:	DC.L	$0B5AF013;-2		; REMOVE THE ";" FOR NORMAL
	DC.L	$0B5AF003;-2		; DRAWING (WITH MORE THAN ONE
	DC.L	$0B5AF017;-2		; BIT/LINE.
	DC.L	$0B5AF00B;-2

planefillcopycls:
;planefill:
	moveq	#0,d1
	move.w	planeoffsetf,d1
	add.l	#calcplane,d1

lea	$dff000,a5
bsr.w	bltwait

move.w	#%0000100111110000,bltcon0(a5)
move.w	#%0000000000001010,bltcon1(a5)
move.l	#-1,bltafwm(a5)
move.l	d1,bltapth(a5)
move.l	d1,bltdpth(a5)

move.w	planemodulof,bltamod(a5)
move.w	planemodulof,bltdmod(a5)
move.w	planesizef,bltsize(a5)


;planecopy:
lea	patternplanes,a6
add.w	d0,d0
add.w	d0,d0
move.l	(a6,d0.w),d0
;move.l	#patternplane4,d0

move.w	#%0000110111111100,d3
move.w	#%0000111111101100,d3
;move.w	#%0000110100001100,d3

	moveq	#0,d2
	moveq	#0,d1
	move.w	planeoffsets,d2
	move.w	planeoffsetd,d1
	add.l	#calcplane,d2
	add.l	vecshowplane,d1	;next(drawplane)

lea	$dff000,a5
bsr.w	bltwait


move.w	#0,bltcon1(a5)
move.l	#-1,bltafwm(a5)

move.w	d3,bltcon0(a5)

move.l	d0,bltcpth(a5)

move.l	d1,bltbpth(a5)
move.l	d1,bltdpth(a5)
move.l	d2,bltapth(a5)

move.w	planemodulod,bltbmod(a5)
move.w	planemodulod,bltdmod(a5)
move.w	planemodulos,bltamod(a5)
move.w	planemodulos,bltcmod(a5)
move.w	planesize,bltsize(a5)


;-----

;planecls:
	moveq	#0,d2
	move.w	planeoffsets,d2
	add.l	#calcplane,d2

lea	$dff000,a5
bsr.w	bltwait

move.l	#%00000001000000000000000000000000,bltcon0(a5)
move.l	d2,bltdpth(a5)
move.w	planemodulos,bltdmod(a5)
move.w	planesize,bltsize(a5)

	rts


hideflag:	dc.w	0

hidesort:
;movem.l	d0-d7/a0-a4,-(a7)
lea	arealines,a0	;basis of all areas
move.l	turnkoord,a1	;turned koordinates
lea	areaoffsets+2,a2
lea	zpositions,a3	;mittelwerte der z-koords
move.w	(a0)+,d7	;number of all areas
moveq	#-1,d6		;counter of non-hidden areas

hidel1:
move.w	d7,d5
lsl.w	#5,d5
;move.w	4(a0,d5.w),d0	;pointcode1
;move.w	6(a0,d5.w),d2	;pointcode2
;move.w	8(a0,d5.w),d4	;pointcode3
movem.w	4(a0,d5.w),d0/d2/d4	;pointcode1

movem.w	2(a1,d0.w),d0-d1
movem.w	2(a1,d2.w),d2-d3
movem.w	2(a1,d4.w),d4-d5

sub.w	d0,d2	;delta x1 x2
sub.w	d1,d3	;delta y1 y2

sub.w	d0,d4	;delta x1 x3
sub.w	d1,d5	;delta y1 y3

muls	d2,d5	;delta x1 x2  *  delta y1 y3
muls	d3,d4	;delta y1 y2  *  delta x1 x3

sub.l	d5,d4
bpl.b	hidden
addq.w	#1,d6		;one more
move.w	d7,d5		;loopcounter
lsl.w	#5,d5		;*32
move.w	d5,(a2)+	;=offset

move.w	(a0,d5.w),d0	;number of points in area
move.w	d0,d4
addq.w	#1,d4
moveq	#0,d1		;addcounter for all z-values


lea	4(a0,d5.w),a4

zaddloop:
move.w	(a4)+,d3
;lsl.w	#3,d3
move.w	6(a1,d3.w),d3
add.l	d3,d1
dbf	d0,zaddloop

;lsl.l	#2,d1
;muls	#4,d1
asl.w	#2,d1
ext.l	d1
divs	d4,d1
move.w	d1,(a3)+

hidden:
dbf	d7,hidel1
lea	areaoffsets,a0
move.w	d6,(a0)

;movem.l	(a7)+,d0-d7/a0-a4

rts



bltfin:	dc.w	0

planeoffsets:	dc.w	0
planeoffsetd:	dc.w	0
planeoffsetf:	dc.w	0
planesizef:	dc.w	0
planesize:	dc.w	0
planemodulof:	dc.w	0
planemodulos:	dc.w	0
planemodulod:	dc.w	0
lox:	dc.w	0
loy:	dc.w	0
hix:	dc.w	0
hiy:	dc.w	0


bsr.w	bltwait

realfade1:
	move.w	fadesleep1,d0
	beq.b	fadeit1
	subq.w	#1,d0
	move.w	d0,fadesleep1
	rts
fadeit1:
	move.w	fadecount1,fadesleep1
	move.w	fadeflag1,d0
	cmp.w	#30,d0
	bne.b	fadereal1
	rts
fadereal1:
	addq.w	#2,d0
	move.w	d0,fadeflag1
	subq.w	#2,d0;;
	lea	fadedat1(pc),a0
	lea	faded1(pc),a1
	moveq	#48,d1
	lea	0(a0,d0.w),a0

fadereall11:
	move.w	(a0),(a1)+
	lea	30(a0),a0
	dbf	d1,fadereall11
lea	faded1(pc),a0
lea	cmencol1_1+2,a1
lea	cmencol2_1+2,a2
lea	cmencol2_2+2,a3
lea	piccol+2,a4
moveq	#15,d0
ccolcopy:
move.w	(a0)+,(a1)
move.w	(a0),(a2)
move.w	(a0)+,(a3)
move.w	(a0)+,(a4)
addq.l	#4,a1
addq.l	#4,a2
addq.l	#4,a3
addq.l	#4,a4
dbf	d0,ccolcopy


move.w	(a0),cscrollcol+2
move.w	cmencol2_1+62,cmencol2_2+2
	rts
;*****


fader1:
	lea	tofade1(pc),a2	;scr-farbdaten
	lea	fadedat1(pc),a1	;obj-farbdaten
	lea	faded1(pc),a0	;akt-farbdaten
	moveq	#48,d0		;anzahl farben
faderloop11:
	moveq	#14,d1		;anzahl faderschritte
	move.w	(a0)+,d2	;farbcode
	move.w	d2,d3
	move.w	d2,d4
	and.w	#%0000000000001111,d2	;blauanteil akt
	and.w	#%0000000011110000,d3	;gruenanteil akt
	and.w	#%0000111100000000,d4	;rotanteil akt
	move.w	(a2)+,d5		;momentaner code fuer farbe d0
	move.w	d5,d6
	move.w	d5,d7
	and.w	#%0000000000001111,d5	;blauanteil scr
	and.w	#%0000000011110000,d6	;gruenanteil scr
	and.w	#%0000111100000000,d7	;rotanteil scr
faderloop21:
	cmp.w	d2,d5
	beq.b	nobluefade1
	ble.b	blueblack1
	addq.w	#%1,d2
	bra.b	nobluefade1
blueblack1:
	subq.w	#1,d2
nobluefade1:
	cmp.w	d3,d6
	beq.b	nogreenfade1
	ble.b	greenblack1
	add.w	#%10000,d3
	bra.b	nogreenfade1
greenblack1:
	sub.w	#%10000,d3
nogreenfade1:
	cmp.w	d4,d7
	beq.b	noredfade1
	ble.b	redblack1
	add.w	#%100000000,d4
	bra.b	noredfade1
redblack1:
	sub.w	#%100000000,d4
noredfade1:
	move.w	d2,a3
	or.w	d3,d2
	or.w	d4,d2
	move.w	d2,(a1)+
	move.w	a3,d2
	dbf	d1,faderloop21
	dbf	d0,faderloop11
	move.w	#0,fadeflag1
	rts
;*****

fadesleep1:	dc.w	1
fadecount1:	dc.w	3
tofade1:	blk.w	49,$0000
faded1:		blk.w	49,$0000
fadedat1:	blk.w	49*16,$0000
fadeflag1:	dc.w	0

mencol1:
dc.w	$0000,$0fff,$0eed,$0ddb,$0cc9,$0bb8,$0aa6,$0995
dc.w	$0884,$0773,$0662,$0551,$0441,$0330,$0220,$0110

mencol2:
dc.w	$0220,$0ded,$0bdb,$0aca,$08b8,$07a7,$0696,$0585
dc.w	$0484,$0373,$0262,$0151,$0141,$0030,$0020,$0010


*****************************************
*					*
* PRORUNNER V2.0			*
* --------------			*
* CODED BY COSMOS OF SANITY IN 1992	*
*					*
*****************************************
*					*
* Supporting the following effects:	*
*					*
*	- Running with 68010/20/30/40	*
*	- Using VBR-register		*
*	- Packed/Normal PT-Moduleformat	*
*	- Fade Sound in/out		*
*	- Variable Musicfadespeed	*
*	- Variable Interrupt-timing	*
*	- Finetune			*
*	- Normal play or Arpeggio	*
*	- Slide Frequenz up		*
*	- Slide	Frequenz down		*
*	- Tone Portamento		*
*	- Vibrato			*
*	- Tone Portamento+Volume Slide	*
*	- Vibrato + Volume Slide	*
*	- Tremolo			*
*	- Set SampleOffset		*
*	- Volume Slide			*
*	- Position Jump			*
*	- Set Volume			*
*	- Pattern Break			*
*	- Set Speed			*
* - E-Commands:				*
*	- Set Filter			*
*	- Fine Slide Up			*
*	- Fine Slide Down		*
*	- Glissando Control		*
*	- Set Vibrato Waveform		*
*	- Set Finetune			*
*	- Set Loop / Jump to Loop	*
*	- Set Tremolo Waveform		*
*	- Retrig Note			*
*	- Fine VolumeSlide Up		*
*	- Fine VolumeSlide Down		*
*	- NoteCut			*
*	- NoteDelay			*
*	- PatternDelay			*
*	- FunkRepeat			*
*					*
*****************************************

YES				=	1
NO				=	0
INCLUDEFADINGROUTINE		=	YES
PACKEDSONGFORMAT		=	YES
FADINGSTEPS			=	7	; ( 0< FADINGSTEPS <9 )
MAXVOLUME			=	2^FADINGSTEPS
INTERRUPTTIME			=	$180

SAMPLELENGTHOFFSET		=	4
SAMPLEVOLUMEOFFSET		=	6
SAMPLEREPEATPOINTOFFSET		=	8
SAMPLEWITHLOOP			=	12
SAMPLEREPEATLENGTHOFFSET	=	14
SAMPLEFINETUNEOFFSET		=	16

* Init-Routine *******************************************************

pr_init:
;move.w	songtime,time
	lea	pr_framecounter(pc),a6
	move.w	#$7fff,pr_oldledvalue-pr_framecounter(a6)
	move.l	pr_module(pc),a0
	cmp.l	#0,a0
	bne.s	pr_init1
	rts
pr_init1:
	IFEQ	PACKEDSONGFORMAT-YES
	cmp.l	#'SNT!',(a0)
	beq.s	pr_init2
	ELSE
	cmp.l	#'M.K.',1080(a0)
	beq.s	pr_init2
	cmp.l	#'SNT.',1080(a0)
	beq.s	pr_init2
	ENDC
	rts
pr_init2:
	IFEQ	PACKEDSONGFORMAT-YES
	lea	8(a0),a1
	ELSE
	lea	20(a0),a1
	ENDC
	lea	pr_Sampleinfos(pc),a2
	moveq.l	#32,d7
	moveq	#30,d0
pr_init3:
	IFNE	PACKEDSONGFORMAT-YES
	lea	22(a1),a1		; Samplenamen �berspringen
	ENDC
	move.w	(a1)+,SAMPLELENGTHOFFSET(a2)	; Samplelength in Words
	lea	pr_periods(pc),a3
	moveq	#$f,d2
	and.b	(a1)+,d2		; Finetuning
	mulu.w	#36*2,d2
	add.l	d2,a3
	move.l	a3,SAMPLEFINETUNEOFFSET(a2)
	moveq	#0,d1
	move.b	(a1)+,d1
	move.w	d1,SAMPLEVOLUMEOFFSET(a2)	; Volume
	moveq.l	#0,d1
	move.w	(a1)+,d1		; Repeatpoint in Bytes
	add.l	d1,d1
	move.l	d1,SAMPLEREPEATPOINTOFFSET(a2)
	move.w	(a1)+,d1
	clr.w	SAMPLEWITHLOOP(a2)
	cmp.w	#1,d1
	bls.s	pr_init3_2
	addq.w	#1,SAMPLEWITHLOOP(a2)
pr_init3_2:
	move.w	d1,SAMPLEREPEATLENGTHOFFSET(a2)	; Repeatlength
	add.l	d7,a2
	dbf	d0,pr_init3

	moveq	#0,d0
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	256(a0),d0
	ELSE
	move.b	950(a0),d0		; Number of patterns
	ENDC
	subq.w	#1,d0
	move.w	d0,pr_highestpattern-pr_framecounter(a6)
	moveq.l	#0,d1
	lea	pr_Patternpositions(pc),a3
	IFEQ	PACKEDSONGFORMAT-YES
	lea	258(a0),a1		; 1.Patternpos
	lea	770(a0),a2		; 1.Patterndata
	lea	642(a0),a4		; 1.Patternoffset
pr_init4:
	moveq.l	#0,d2
	move.b	(a1)+,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d2
	add.l	a2,d2
	move.l	d2,(a3)+
	dbf	d0,pr_init4
	ELSE
	lea	952(a0),a1		; 1. Patternpos
	lea	1084(a0),a2		; 1. Patterndata
pr_init4:
	move.b	(a1)+,d2		; x. Patternpos
	moveq.l	#0,d3
	move.b	d2,d3
	mulu.w	#1024,d3
	add.l	a2,d3
	move.l	d3,(a3)+
	dbf	d0,pr_init4
	ENDC

	IFEQ	PACKEDSONGFORMAT-YES
	move.l	4(a0),d2
	add.l	a0,d2
	ELSE
	lea	952(a0),a1
	moveq.l	#0,d1
	moveq	#127,d0
pr_init4_1:
	move.b	(a1)+,d2
	cmp.b	d1,d2			; Highest Pattern ?
	bls.s	pr_init4_2
	move.b	d2,d1
pr_init4_2:
	dbf	d0,pr_init4_1
	addq.w	#1,d1
	move.l	a0,d2
	mulu.w	#1024,d1		; Highest Pattern * 1024 Bytes
	add.l	#1084,d2
	add.l	d1,d2
	ENDC
	lea	pr_Sampleinfos(pc),a3
	lea	pr_Sampleinfos+SAMPLELENGTHOFFSET(pc),a2
	moveq.l	#32,d7
	move.l	d2,(a3)
	moveq	#29,d0
pr_init4_3:
	move.l	(a3),d1
	add.l	d7,a3
	moveq.l	#0,d2
	move.w	(a2),d2
	add.l	d7,a2
	add.l	d2,d2
	add.l	d2,d1
	move.l	d1,(a3)
	dbf	d0,pr_init4_3

	lea	pr_Sampleinfos(pc),a2
	lea	pr_Sampleinfos+SAMPLEREPEATPOINTOFFSET(pc),a3
	moveq.l	#32,d7
	moveq	#30,d0
pr_init4_4:
	move.l	(a2),d1
	add.l	d1,(a3)
	add.l	d7,a2
	add.l	d7,a3
	dbf	d0,pr_init4_4
	
	IFNE	PACKEDSONGFORMAT-YES
	
	cmp.l	#'SNT.',1080(a0)
	beq.s	pr_init7
	
	lea	1084(a0),a1
	move.l	pr_Sampleinfos(pc),a2
	move.b	#$f0,d6
	move.w	#$fff,d7
pr_init5:
	move.b	(a1),d0
	move.b	2(a1),d1
	move.w	(a1),d2
	and.w	d7,2(a1)
	and.w	d7,d2
	
	and.b	d6,d0
	lsr.b	#4,d1
	or.b	d1,d0
	move.b	d0,(a1)
	
	tst.w	d2
	beq.s	pr_init5_3
	lea	pr_periods(pc),a4
	moveq	#0,d1
pr_init5_2:
	addq.w	#1,d1
	cmp.w	(a4)+,d2
	bne.s	pr_init5_2
	move.b	d1,1(a1)
pr_init5_3:
	cmp.b	#$d,2(a1)
	bne.s	pr_init5_4

	moveq	#0,d1
	move.b	3(a1),d1
	moveq	#$f,d2
	and.w	d1,d2
	lsr.w	#4,d1
	mulu.w	#10,d1
	add.w	d2,d1
	cmp.b	#63,d1
	bls.s	pr_init5_3_2
	moveq	#63,d1
pr_init5_3_2:
	move.b	d1,3(a1)
pr_init5_4:
	addq.l	#4,a1
	cmp.l	a2,a1
	blt.s	pr_init5	

	move.l	#'SNT.',1080(a0)

	ENDC
	
pr_init7:
	lea	pr_Arpeggiofastlist(pc),a2
	lea	pr_Arpeggiofastlistperiods(pc),a1
	lea	35*2(a1),a1		; to the end of list...
	moveq	#0,d0
	moveq	#35,d1
	move.w	#999,d2
	moveq	#0,d6
pr_init8:
	move.w	-(a1),d7
	addq.w	#1,d6
pr_init8_2:
	cmp.w	d7,d0
	blt.s	pr_init8_4
	subq.w	#1,d1
	tst.b	d1
	bne.s	pr_init8
pr_init8_3:
	move.b	d1,(a2)+
	dbf	d2,pr_init8_3
	bra.s	pr_init8_5	
pr_init8_4:
	move.b	d1,(a2)+
	addq.w	#1,d0
	dbf	d2,pr_init8_2
pr_init8_5:

	lea	pr_Channel0(pc),a1
	move.w	#1,pr_Channel1-pr_Channel0(a1)
	move.w	#1,pr_Channel2-pr_Channel0(a1)
	move.w	#1,pr_Channel3-pr_Channel0(a1)
	move.w	#1,(a1)+
	moveq	#(pr_Channel1-pr_Channel0)/2-2,d0
pr_init9_2:
	clr.w	pr_Channel1-pr_Channel0(a1)
	clr.w	pr_Channel2-pr_Channel0(a1)
	clr.w	pr_Channel3-pr_Channel0(a1)
	clr.w	(a1)+
	dbf	d0,pr_init9_2

	lea	pr_fastperiodlist(pc),a1
	lea	pr_periods(pc),a2
	move.l	a2,(a1)
	moveq.l	#36*2,d1
	moveq	#14,d0
pr_init9_3:
	move.l	(a1)+,d2
	add.l	d1,d2
	move.l	d2,(a1)
	dbf	d0,pr_init9_3
		
	lea	pr_Arpeggiofastdivisionlist(pc),a1
	moveq	#0,d1
	move.w	#$ff,d0
pr_init9_4:
	move.b	d1,(a1)+
	subq.b	#1,d1
	bpl.s	pr_init9_4_2
	moveq	#2,d1
pr_init9_4_2:
	dbf	d0,pr_init9_4
	
	move.w	#6,pr_speed-pr_framecounter(a6)
	move.w	pr_speed(pc),(a6)
	clr.w	pr_Patternct-pr_framecounter(a6)
	move.w	pr_highestpattern(pc),d0
	move.w	pr_startposition(pc),d1
	blt.s	pr_init9_5
	cmp.w	d0,d1
	bls.s	pr_init9_5_2
pr_init9_5:
	clr.w	pr_startposition-pr_framecounter(a6)
pr_init9_5_2:
	move.w	pr_startposition(pc),pr_currentpattern-pr_framecounter(a6)
	
	lea	pr_Patternpositions(pc),a3
	move.l	a3,d0
	moveq.l	#0,d1
	move.w	pr_startposition(pc),d1
	lsl.l	#2,d1
	add.l	d1,d0
	move.l	d0,pr_Patternpt-pr_framecounter(a6)
	move.l	pr_Patternpt(pc),a5
	move.l	(a5),pr_Currentposition-pr_framecounter(a6)
	
	lea	$dff000,a5
	lea	$bfd000,a0
	move.w	#$2000,d0
	move.w	d0,$9a(a5)
	move.w	d0,$9c(a5)
	
	lea	pr_int(pc),a1
	move.l	pr_Vectorbasept(pc),a3
	move.l	a1,$78(a3)

	move.b	#$7f,$d00(a0)
	move.b	#$08,$e00(a0)
	move.w	#INTERRUPTTIME,d0
	move.b	d0,$400(a0)
	lsr.w	#8,d0
	move.b	d0,$500(a0)
pr_init10:
	btst	#0,$bfdd00
	beq.s	pr_init10
	move.b	#$81,$d00(a0)
	move.w	#$2000,$9c(a5)
	move.w	#$a000,$9a(a5)
	move.w	#$f,$96(a5)
	move.w	#$8000,pr_dmacon-pr_framecounter(a6)
	clr.w	$a8(a5)
	clr.w	$b8(a5)
	clr.w	$c8(a5)
	clr.w	$d8(a5)
	moveq	#0,d0
	move.b	$bfe001,d0
	move.w	d0,pr_oldledvalue-pr_framecounter(a6)
	bset	#1,$bfe001
	rts

* End-Routine *********************************************************

pr_end:
	lea	$dff000,a5
	move.w	#$f,$96(a5)
	clr.w	$a8(a5)
	clr.w	$b8(a5)
	clr.w	$c8(a5)
	clr.w	$d8(a5)
	move.w	#$2000,$9a(a5)
	move.w	pr_oldledvalue(pc),d0
	cmp.w	#$7fff,d0
	beq.s	pr_end3
	btst	#1,d0
	beq.s	pr_end2
	bset	#1,$bfe001
	rts
pr_end2:
	bclr	#1,$bfe001
pr_end3:
	rts

* Music-Fading ********************************************************

	IFEQ	INCLUDEFADINGROUTINE-YES
pr_fademusic:	macro
	lea	pr_musicfadect(pc),a0
	move.w	pr_musicfadedirection(pc),d0
	add.w	d0,(a0)
	cmp.w	#MAXVOLUME,(a0)
	bls.s	pr_fademusicend
	bgt.s	pr_fademusictoohigh
	clr.w	(a0)
	clr.w	pr_musicfadedirection-pr_musicfadect(a0)
	rts
pr_fademusictoohigh:
	move.w	#MAXVOLUME,(a0)
	clr.w	pr_musicfadedirection-pr_musicfadect(a0)
pr_fademusicend:
	endm

pr_musicfadect:		dc.w	MAXVOLUME
pr_musicfadedirection:	dc.w	0
	ENDC
	
* MACROS **************************************************************

pr_playchannel:	macro				; do not change: d7,a2-a6
		moveq	#0,d2
		moveq	#0,d0
		moveq	#0,d1
		IFEQ	PACKEDSONGFORMAT-YES
		move.b	(a6),d6
		bpl.s	.pr_playchannel1
		btst	#6,d6
		bne.s	.pr_playchannel0
		subq.l	#2,a6
		clr.w	4(a4)
		bra.s	.pr_playchannelend
.pr_playchannel0:		
		subq.l	#2,a6
		move.b	56(a4),d0
		move.b	57(a4),d1
		move.b	58(a4),d2
		move.w	58(a4),4(a4)
		bra.s	.pr_playchanneljump		
.pr_playchannel1:
		moveq	#$f,d0
		and.b	1(a6),d0
		move.b	d0,4(a4)
		move.b	d0,d2
		move.b	2(a6),5(a4)
		move.w	4(a4),58(a4)
		
		moveq	#1,d0
		and.b	(a6),d0
		move.b	1(a6),d1
		lsr.b	#3,d1
		bclr	#0,d1
		or.b	d1,d0
		move.b	d0,56(a4)		

		move.b	(a6),d1
		lsr.b	#1,d1
		move.b	d1,57(a4)
		ELSE
		move.w	2(a6),4(a4)
		move.b	2(a6),d2
		move.b	(a6),d0
		move.b	1(a6),d1
		ENDC
.pr_playchanneljump:
		add.w	d2,d2
		lea	pr_playchannellist(pc),a0
		move.w	(a0,d2.w),d2
		jsr	(a0,d2.w)
.pr_playchannelend:
		IFEQ	PACKEDSONGFORMAT-YES
		addq.l	#3,a6
		ELSE
		addq.l	#4,a6
		ENDC
		endm

pr_checkchannel:	macro			; do not change: d7,a2-a6
		bsr.w	pr_checkfunkrepeat
		moveq	#0,d0
		move.b	4(a4),d0
		add.b	d0,d0
		lea	pr_Effectchecklist(pc),a0
		move.w	(a0,d0.w),d0
		jsr	(a0,d0.w)
		endm
		
pr_copyplayvalues:	macro
		tst.w	pr_commandnotedelay-pr_framecounter(a2)
		bne.s	.pr_copyplayvalues2
		move.w	2(a4),6(a3)
.pr_copyplayvalues2:
		IFEQ	INCLUDEFADINGROUTINE-YES
		move.w	12(a4),d0
		mulu.w	pr_musicfadect-pr_framecounter(a2),d0
 		lsr.l	#FADINGSTEPS,d0
		move.w	d0,8(a3)
		ELSE
		move.w	12(a4),8(a3)
		ENDC
		endm

* Music-Routine *******************************************************

pr_music:
	subq.w	#1,time
	IFEQ	INCLUDEFADINGROUTINE-YES
	pr_fademusic
	ENDC
;	lea	$dff000,a5

	lea	pr_framecounter(pc),a2
	subq.w	#1,(a2)
	beq.s	pr_music2
	bra.w	pr_checkeffects
pr_music2:
	cmp.b	#1,pr_patterndelaytime-pr_framecounter+1(a2)
	blt.s	pr_music2_2
	bsr.w	pr_checkeffects
	bra.w	pr_music2_9
pr_music2_2:
	move.l	pr_Currentposition(pc),a6
	lea	pr_Channel0(pc),a4
	lea	$a0(a5),a3
	moveq	#1,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_3:	
	lea	pr_Channel1(pc),a4
	lea	$b0(a5),a3
	moveq	#2,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_4:
	lea	pr_Channel2(pc),a4
	lea	$c0(a5),a3
	moveq	#4,d7
	pr_playchannel
	pr_copyplayvalues
pr_music2_5:
	lea	pr_Channel3(pc),a4
	lea	$d0(a5),a3
	moveq	#8,d7
	pr_playchannel
	pr_copyplayvalues
	
	lea	pr_int(pc),a0
	move.l	pr_Vectorbasept(pc),a1
	move.l	a0,$78(a1)
	move.b	#$19,$bfde00

pr_music2_9:
	move.w	pr_speed(pc),(a2)
	tst.w	pr_patternhasbeenbreaked-pr_framecounter(a2)
	bne.s	pr_music3
	tst.w	pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	subq.w	#1,pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	bra.s	pr_nonextpattern
pr_music3:
	clr.w	pr_patternhasbeenbreaked-pr_framecounter(a2)
	tst.w	pr_patterndelaytime-pr_framecounter(a2)
	beq.s	pr_music3_1
	subq.w	#1,pr_patterndelaytime-pr_framecounter(a2)
pr_music3_1:
	lea	pr_Patternct(pc),a1
	tst.w	pr_dontcalcnewposition-pr_framecounter(a2)
	bne.s	pr_music3_2
	move.l	a6,pr_Currentposition-pr_framecounter(a2)
	addq.w	#1,(a1)
pr_music3_2:
	clr.w	pr_dontcalcnewposition-pr_framecounter(a2)
	moveq.l	#64,d1
	cmp.w	(a1),d1
	bgt.s	pr_nonextpattern

	sub.w	d1,(a1)
	lea	pr_currentpattern(pc),a0
	move.w	(a1),d1
	beq.s	pr_music3_3
	IFEQ	PACKEDSONGFORMAT-YES
	move.l	pr_module(pc),a1
	lea	386(a1),a1
	move.w	(a0),d1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	ELSE
	lsl.w	#4,d1
	ENDC
pr_music3_3:
	addq.l	#4,pr_Patternpt-pr_framecounter(a2)
	addq.w	#1,(a0)
	move.w	(a0),d0
	cmp.w	pr_highestpattern-pr_framecounter(a2),d0
	bls.s	pr_nohighestpattern
move.w	songtime,time
	lea	pr_Patternpositions(pc),a1
	move.l	a1,pr_Patternpt-pr_framecounter(a2)
	clr.w	(a0)
pr_nohighestpattern:
	move.l	pr_Patternpt-pr_framecounter(a2),a6
	move.l	(a6),d0
	add.l	d1,d0
	move.l	d0,pr_Currentposition-pr_framecounter(a2)
pr_nonextpattern:
	rts

	
pr_int:
	tst.b	$bfdd00
	move.b	#$19,$bfde00
	move.w	pr_dmacon(pc),$dff096
	move.w	#$2000,$dff09c
	move.l	a0,-(sp)
	move.l	pr_Vectorbasept(pc),a0
	add.l	#pr_int2-pr_int,$78(a0)
	move.l	(sp)+,a0
	rte

pr_int2:
	tst.b	$bfdd00
	movem.l	a5-a6,-(sp)
	lea	$dff000,a5
	lea	pr_Channel0+6(pc),a6
	move.l	(a6),$a0(a5)
	move.w	4(a6),$a4(a5)
	move.l	pr_Channel1-pr_Channel0(a6),$b0(a5)
	move.w	4+pr_Channel1-pr_Channel0(a6),$b4(a5)
	move.l	pr_Channel2-pr_Channel0(a6),$c0(a5)
	move.w	4+pr_Channel2-pr_Channel0(a6),$c4(a5)
	move.l	pr_Channel3-pr_Channel0(a6),$d0(a5)
	move.w	4+pr_Channel3-pr_Channel0(a6),$d4(a5)
	move.w	#$2000,$9c(a5)
	move.l	pr_Vectorbasept(pc),a6
	move.l	pr_old78(pc),$78(a6)
	movem.l	(sp)+,a5-a6
	rte
		
pr_playchannellist:
	dc.w	pr_playnormalchannel-pr_playchannellist		; 0
	dc.w	pr_playnormalchannel-pr_playchannellist		; 1
	dc.w	pr_playnormalchannel-pr_playchannellist		; 2
	dc.w	pr_playtpchannel-pr_playchannellist		; 3
	dc.w	pr_playnormalchannel-pr_playchannellist		; 4
	dc.w	pr_playtpchannel-pr_playchannellist		; 5
	dc.w	pr_playnormalchannel-pr_playchannellist		; 6
	dc.w	pr_playnormalchannel-pr_playchannellist		; 7
	dc.w	pr_playnormalchannel-pr_playchannellist		; 8
	dc.w	pr_playsochannel-pr_playchannellist		; 9
	dc.w	pr_playnormalchannel-pr_playchannellist		; A
	dc.w	pr_playnormalchannel-pr_playchannellist		; B
	dc.w	pr_playnormalchannel-pr_playchannellist		; C
	dc.w	pr_playnormalchannel-pr_playchannellist		; D
	dc.w	pr_playnormalchannel-pr_playchannellist		; E
	dc.w	pr_playnormalchannel-pr_playchannellist		; F
	
* KANAL NORMAL SPIELEN ************************************************

pr_playnormalchannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	clr.w	pr_commandnotedelay-pr_framecounter(a2)
	moveq	#-1,d4
	lsl.w	#4,d4
	and.w	4(a4),d4
	cmp.w	#$ed0,d4
	bne.s	pr_playnormalsamplenotedelay
	addq.w	#1,pr_commandnotedelay-pr_framecounter(a2)
pr_playnormalsamplenotedelay:
	tst.b	d0
	beq.b	pr_playnormalnonewsample	; Irgendein Sample ?
	move.w	d0,(a4)				; Trage Samplenummer ein
	tst.b	d1
	bne.s	pr_playnormalsample
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playnormalchannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalchannel2:
	move.w	(a0)+,10(a4)
	bra.w	pr_playnormalnonewperiod
pr_playnormalsample:
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	tst.w	pr_commandnotedelay-pr_framecounter(a2)
	beq.b	pr_playnormalsamplenoedcom
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.w	6(a0),12(a4)
	move.l	8(a0),6(a4)
	move.w	14(a0),10(a4)
	bra.s	pr_playnormalnewperiod
pr_playnormalsamplenoedcom:
	move.w	d7,$96(a5)
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	move.w	(a0)+,12(a4)		; Setze Samplelautst�rke
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playnormalsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.s	pr_playnormalnewperiod
pr_playnormalnonewsample:
	clr.l	14(a4)
	tst.b	d1
	beq.s	pr_playnormalnonewperiod	; Irgend ne neue Frequenz ?
	move.w	(a4),d0			; Alte Samplenummer holen
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	tst.w	pr_commandnotedelay-pr_framecounter(a2)
	bne.s	pr_playnormalnewperiod
	move.w	d7,$96(a5)
pr_playnormalnonewsamplenoedcom:
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playnormalnonewsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playnormalnonewsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
pr_playnormalnewperiod:
	subq.b	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),2(a4)		; Frequenz eintragen
pr_playnormalnonewperiod:
	bra.w	pr_playeffect

* KANAL MIT OFFSET SPIELEN *********************************************

pr_playsochannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	tst.b	d0
	beq.w	pr_playsononewsample	; Irgendein Sample ?
	move.w	d0,(a4)				; Trage Samplenummer ein
	tst.b	d1
	bne.s	pr_playsosample
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsochannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsochannel2:
	move.w	(a0)+,10(a4)
	bra.w	pr_playsononewperiod
pr_playsosample:
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d6
	move.b	5(a4),d6
	lsl.w	#7,d6
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,d2
	move.w	(a0)+,d3
	cmp.w	d3,d6
	bge.s	pr_playsosample2
	sub.w	d6,d3
	add.l	d6,d6
	add.l	d6,d2
	move.l	d2,(a3)			; Setze Samplestart
	move.w	d3,4(a3)		; Setze Audiodatenl�nge
	move.w	(a0)+,12(a4)		; Setze Samplelautst�rke
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playsosample1
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample1:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.w	pr_playsonewperiod
pr_playsosample2:
	move.w	(a0)+,12(a4)
	move.l	(a0),(a3)
	move.w	4(a0),4(a3)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsosample4
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample4:
	move.w	(a0)+,10(a4)
	bra.s	pr_playsonewperiod
pr_playsononewsample:
	clr.l	14(a4)
	tst.b	d1
	beq.b	pr_playsononewperiod	; Irgend ne neue Frequenz ?
	move.w	(a4),d0			; Alte Samplenummer holen
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d6
	move.b	5(a4),d6
	lsl.w	#7,d6
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	move.l	(a0)+,d2
	move.w	(a0)+,d3
	cmp.w	d3,d6
	bge.s	pr_playsosample3
	sub.w	d6,d3
	add.l	d6,d6
	add.l	d6,d2
	move.l	d2,(a3)			; Setze Samplestart
	move.w	d3,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playsononewsample2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsononewsample2:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
	bra.s	pr_playsonewperiod
pr_playsosample3:
	addq.l	#2,a0
	move.l	(a0),(a3)
	move.w	4(a0),4(a3)
	move.l	(a0)+,d2
	move.l	d2,6(a4)
	tst.w	(a0)+
	beq.s	pr_playsosample5
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playsosample5:
	move.w	(a0)+,10(a4)
	bra.w	pr_playsonewperiod
pr_playsonewperiod:
	subq.w	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),2(a4)		; Frequenz eintragen
pr_playsononewperiod:
	bra.b	pr_playeffect

* Kanal spielen mit TONE PORTAMENTO **********************************

pr_playtpchannel:
	lea	pr_Sampleinfos(pc),a0
	lea	(a0),a1
	lea	SAMPLEFINETUNEOFFSET(a1),a1
	tst.b	d0
	beq.s	pr_playtpnonewsample	; Irgendein Sample ?
	move.w	d0,(a4)			; Trage Samplenummer ein
	subq.b	#1,d0
	lsl.l	#5,d0
	add.l	d0,a0
	addq.l	#6,a0
	move.w	(a0)+,12(a4)		; Lautst�rke eintragen
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Repeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_playtpchannel2
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_playtpchannel2:
	move.w	(a0)+,10(a4)		; Repeatlength eintragen
pr_playtpnonewsample:
	tst.b	d1
	beq.s	pr_playtpnonewperiod	; Irgend ne neue Frequenz ?
pr_playtpnewperiod:
	move.w	2(a4),14(a4)
	subq.w	#1,d1
	add.b	d1,d1
	move.w	(a4),d0
	subq.b	#1,d0
	lsl.w	#5,d0
	move.l	(a1,d0.w),a1
	move.w	(a1,d1.w),d2
	move.w	d2,16(a4)		; Frequenz eintragen
	bra.s	pr_playtpallowed
pr_playtpnonewperiod:
	tst.w	16(a4)
	bne.s	pr_playtpallowed
	clr.w	14(a4)
	clr.l	26(a4)
pr_playtpallowed:
	bra.w	pr_playeffect

pr_playeffect:
	bsr.w	pr_checkfunkrepeat
	moveq	#0,d0
	move.b	4(a4),d0
	add.b	d0,d0
	lea	pr_normaleffectlist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
pr_playnoeffect:
	rts

pr_normaleffectlist:
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 0
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 1
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 2
	dc.w	pr_preptoneportamento-pr_normaleffectlist	; 3
	dc.w	pr_prepvibrato-pr_normaleffectlist		; 4
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 5
	dc.w	pr_prepvibandvolslide-pr_normaleffectlist	; 6
	dc.w	pr_preptremolo-pr_normaleffectlist		; 7
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 8
	dc.w	pr_playnoeffect-pr_normaleffectlist		; 9
	dc.w	pr_playnoeffect-pr_normaleffectlist		; A
	dc.w	pr_jumptopattern-pr_normaleffectlist		; B
	dc.w	pr_newvolume-pr_normaleffectlist		; C
	dc.w	pr_patternbreak-pr_normaleffectlist		; D
	dc.w	pr_play_e_command-pr_normaleffectlist		; E
	dc.w	pr_newspeed-pr_normaleffectlist			; F

pr_play_e_command:
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#3,d0
	bclr	#0,d0
	lea	pr_e_commandeffectlist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
	
pr_e_commandeffectlist:
	dc.w	pr_setfilter-pr_e_commandeffectlist		; 0
	dc.w	pr_fineslideup-pr_e_commandeffectlist		; 1
	dc.w	pr_fineslidedown-pr_e_commandeffectlist		; 2
	dc.w	pr_setglissandocontrol-pr_e_commandeffectlist	; 3
	dc.w	pr_setvibratowaveform-pr_e_commandeffectlist	; 4
	dc.w	pr_playfinetune-pr_e_commandeffectlist		; 5
	dc.w	pr_jumptoloop-pr_e_commandeffectlist		; 6
	dc.w	pr_settremolowaveform-pr_e_commandeffectlist	; 7
	dc.w	pr_playnoeffect-pr_e_commandeffectlist		; 8
	dc.w	pr_prepretrignote-pr_e_commandeffectlist	; 9
	dc.w	pr_finevolumeslideup-pr_e_commandeffectlist	; A
	dc.w	pr_finevolumeslidedown-pr_e_commandeffectlist	; B
	dc.w	pr_prepnotecut-pr_e_commandeffectlist		; C
	dc.w	pr_prepnotedelay-pr_e_commandeffectlist		; D
	dc.w	pr_preppatterndelay-pr_e_commandeffectlist	; E
	dc.w	pr_prepfunkrepeat-pr_e_commandeffectlist	; F

pr_preppatterndelay:
	cmp.b	#1,pr_patterndelaytime-pr_framecounter+1(a2)
	bge.s	pr_preppatterndelayend
	moveq	#$f,d0
	and.b	5(a4),d0
	addq.b	#1,d0
	move.b	d0,pr_patterndelaytime-pr_framecounter+1(a2)
pr_preppatterndelayend:
	rts

pr_setvibratowaveform:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,50(a4)
	rts

pr_settremolowaveform:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,52(a4)
	rts

pr_setglissandocontrol:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	d0,48(a4)
	rts

pr_playfinetune:
	moveq	#$f,d0
	and.b	5(a4),d0
	lsl.w	#2,d0
	lea	pr_fastperiodlist(pc),a0
	move.l	(a0,d0.w),a0
	moveq	#0,d1
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	move.b	1(a6),d1
	ENDC
	beq.s	pr_playfinetuneend
	subq.b	#1,d1
	add.w	d1,d1
	move.w	(a0,d1.w),2(a4)		; Frequenz eintragen
pr_playfinetuneend:
	rts
	
pr_jumptoloop:
	moveq	#$f,d0
	and.b	5(a4),d0
	beq.s	pr_prepjumptoloop
	addq.b	#1,47(a4)
	cmp.b	47(a4),d0
	blt.s	pr_jumptoloopend
	moveq.l	#0,d0
	move.w	44(a4),d0
	move.w	d0,pr_Patternct-pr_framecounter(a2)
	move.l	pr_Patternpt(pc),a0
	move.l	(a0),d5
	IFEQ	PACKEDSONGFORMAT-YES
	moveq.l	#0,d0
	move.w	60(a4),d0
	ELSE
	lsl.l	#4,d0
	ENDIF
	add.l	d0,d5
	move.l	d5,pr_Currentposition-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts
pr_jumptoloopend:
	clr.w	46(a4)
	rts
pr_prepjumptoloop:
	tst.w	46(a4)
	bne.s	pr_prepjumptoloopend
	move.w	pr_Patternct-pr_framecounter(a2),44(a4)
	IFEQ	PACKEDSONGFORMAT-YES
	move.l	pr_Currentposition(pc),d0
	move.l	pr_Patternpt(pc),a1
	sub.l	(a1),d0
	move.w	d0,60(a4)
	ENDC
	clr.w	46(a4)
pr_prepjumptoloopend:
	rts

pr_prepnotedelay:
	IFEQ	PACKEDSONGFORMAT-YES
	tst.b	57(a4)
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepnotedelayend2

	moveq	#$f,d0
	and.b	5(a4),d0
	bne.s	pr_prepnotedelay2
	move.w	#$fff,18(a4)
	bra.w	pr_checknotedelay2
pr_prepnotedelay2:
	move.w	d7,d0
	not.b	d0
	and.b	d0,pr_dmacon-pr_framecounter+1(a2)
	clr.w	18(a4)
	rts
pr_prepnotedelayend2:
	move.w	#$fff,18(a4)
	rts

pr_prepretrignote:
	clr.w	18(a4)
	IFEQ	PACKEDSONGFORMAT-YES
	tst.b	56(a4)
	ELSE
	tst.w	(a6)
	ENDC
	bne.s	pr_prepretrignoteend
	bra.w	pr_checkretrignote2	
pr_prepretrignoteend:
	rts

pr_prepnotecut:
	clr.w	18(a4)
	moveq	#$f,d0
	and.b	5(a4),d0
	tst.b	d0
	bne.s	pr_prepnotecutend
	clr.w	12(a4)
pr_prepnotecutend:
	rts
	
pr_finevolumeslideup:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	12(a4),d1
	add.w	d0,d1
	moveq	#64,d0
	cmp.w	d0,d1
	bls.s	pr_finevolumeslideup2
	move.w	d0,d1
pr_finevolumeslideup2:
	move.w	d1,12(a4)
	rts

pr_finevolumeslidedown:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	12(a4),d1
	sub.w	d0,d1
	bpl.s	pr_finevolumeslidedown2
	moveq	#0,d1
pr_finevolumeslidedown2:
	move.w	d1,12(a4)
	rts

pr_fineslideup:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	2(a4),d1
	sub.w	d0,d1
	cmp.w	#108,d1
	bge.s	pr_fineslideup2
	move.w	#108,d1
pr_fineslideup2:
	move.w	d1,2(a4)
	rts

pr_fineslidedown:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	2(a4),d1
	add.w	d0,d1
	cmp.w	#907,d1
	bls.s	pr_fineslidedown2
	move.w	#907,d1
pr_fineslidedown2:
	move.w	d1,2(a4)
	rts

pr_setfilter:
	btst	#0,5(a4)
	beq.s	pr_setfilteron
pr_setfilteroff:
	bset	#1,$bfe001
	rts
pr_setfilteron:
	bclr	#1,$bfe001
	rts

pr_prepvibandvolslide:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_prepvibandvolslide2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepvibandvolslide2
	clr.w	18(a4)
pr_prepvibandvolslide2:
	rts

pr_preptoneportamento:
	tst.b	5(a4)
	beq.s	pr_preptoneportamento2
	move.w	4(a4),22(a4)
pr_preptoneportamento2:
	rts

pr_prepvibrato:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_prepvibrato2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_prepvibrato0
	clr.w	18(a4)
pr_prepvibrato0:
	move.b	5(a4),d0
	move.b	d0,d1
	lsr.b	#4,d1
	beq.s	pr_prepvibrato1
	move.b	d1,24(a4)
pr_prepvibrato1:
	and.b	#$f,d0
	beq.s	pr_prepvibrato2
	move.b	d0,25(a4)
pr_prepvibrato2:
	rts

pr_preptremolo:
	cmp.b	#1,pr_speed-pr_framecounter+1(a2)
	beq.s	pr_preptremolo2
	IFEQ	PACKEDSONGFORMAT-YES
	move.b	(a6),d1
	lsr.b	#1,d1
	ELSE
	tst.b	1(a6)
	ENDC
	beq.s	pr_preptremolo0
	clr.w	18(a4)
pr_preptremolo0:
	move.w	12(a4),20(a4)
	move.b	5(a4),d0
	move.b	d0,d1
	lsr.b	#4,d1
	beq.s	pr_preptremolo1
	move.b	d1,30(a4)
pr_preptremolo1:
	and.b	#$f,d0
	beq.s	pr_preptremolo2
	move.b	d0,31(a4)
pr_preptremolo2:
	rts

pr_newvolume:
	move.b	5(a4),d0
	cmp.b	#64,d0
	bls.s	pr_newvolumeend
	moveq	#64,d0
pr_newvolumeend:
	move.b	d0,13(a4)
	rts

pr_newspeed:
	move.b	5(a4),d0
	tst.b	d0
	bne.s	pr_newspeed2
	moveq	#1,d0
pr_newspeed2:
	move.b	d0,pr_speed-pr_framecounter+1(a2)
	rts

pr_patternbreak:
	moveq	#0,d0
	move.b	5(a4),d0
	add.w	#64,d0
	move.w	d0,pr_Patternct-pr_framecounter(a2)
	addq.w	#1,pr_patternhasbeenbreaked-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts
		
pr_jumptopattern:
	moveq.l	#0,d0
	move.b	5(a4),d0
	subq.b	#1,d0
	bpl.s	pr_playjumptopattern2
	move.w	#128,d0
pr_playjumptopattern2:
	move.b	d0,pr_currentpattern-pr_framecounter+1(a2)
	lsl.l	#2,d0
	lea	pr_Patternpositions(pc),a0
	add.l	a0,d0
	move.l	d0,pr_Patternpt-pr_framecounter(a2)
	move.w	#64,pr_Patternct-pr_framecounter(a2)
	addq.w	#1,pr_patternhasbeenbreaked-pr_framecounter(a2)
	addq.w	#1,pr_dontcalcnewposition-pr_framecounter(a2)
	rts

* Control FX every frame **********************************************

pr_checkeffects:
	moveq	#1,d7
	lea	$a0(a5),a3
	lea	pr_Channel0(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC
	
	moveq	#2,d7
	lea	$b0(a5),a3
	lea	pr_Channel1(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	moveq	#4,d7
	lea	$c0(a5),a3
	lea	pr_Channel2(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	moveq	#8,d7
	lea	$d0(a5),a3
	lea	pr_Channel3(pc),a4
	move.w	12(a4),54(a4)
	pr_checkchannel
	IFEQ	INCLUDEFADINGROUTINE-YES
	move.w	54(a4),d0
	mulu.w	pr_musicfadect-pr_framecounter(a2),d0
	lsr.l	#FADINGSTEPS,d0
	move.w	d0,8(a3)
	ELSE
	move.w	54(a4),8(a3)
	ENDC

	lea	pr_int(pc),a0
	move.l	pr_Vectorbasept(pc),a1
	move.l	a0,$78(a1)
	move.b	#$19,$bfde00
	rts

***********************************************************************

pr_checknotchannel:
	rts

pr_check_e_commands:
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#3,d0
	bclr	#0,d0
	lea	pr_E_Command_checklist(pc),a0
	move.w	(a0,d0.w),d0
	jmp	(a0,d0.w)
	
pr_Effectchecklist:
	dc.w	pr_checkarpeggio-pr_Effectchecklist		; 0
	dc.w	pr_checkperiodslideup-pr_Effectchecklist	; 1
	dc.w	pr_checkperiodslidedown-pr_Effectchecklist	; 2
	dc.w	pr_checktoneportamento-pr_Effectchecklist	; 3
	dc.w	pr_checkvibrato-pr_Effectchecklist		; 4
	dc.w	pr_checktpandvolslide-pr_Effectchecklist	; 5
	dc.w	pr_checkvibandvolslide-pr_Effectchecklist	; 6
	dc.w	pr_checktremolo-pr_Effectchecklist		; 7
	dc.w	pr_checknotchannel-pr_Effectchecklist		; 8
	dc.w	pr_checknotchannel-pr_Effectchecklist		; 9
	dc.w	pr_checkvolumeslide-pr_Effectchecklist		; A
	dc.w	pr_checknotchannel-pr_Effectchecklist		; B
	dc.w	pr_checknotchannel-pr_Effectchecklist		; C
	dc.w	pr_checknotchannel-pr_Effectchecklist		; D
	dc.w	pr_check_e_commands-pr_Effectchecklist		; E
	dc.w	pr_checknotchannel-pr_Effectchecklist		; F

pr_E_Command_checklist:
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 0
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 1
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 2
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 3
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 4
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 5
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 6
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 7
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; 8
	dc.w	pr_checkretrignote-pr_E_Command_checklist	; 9
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; A
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; B
	dc.w	pr_checknotecut-pr_E_Command_checklist		; C
	dc.w	pr_checknotedelay-pr_E_Command_checklist	; D
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; E
	dc.w	pr_checknotchannel-pr_E_Command_checklist	; F

pr_prepfunkrepeat:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.b	d0,33(a4)
	tst.b	d0
	bne.s	pr_checkfunkrepeat
	rts
pr_checkfunkrepeat:
	move.w	32(a4),d0
	beq.s	pr_checkfunkrepeatend
	lea	pr_FunkTable(pc),a0
	move.b	(a0,d0.w),d0
	move.b	35(a4),d1
	add.b	d0,d1
	bmi.s	pr_checkfunkrepeat2
	move.b	d1,35(a4)
	rts
pr_checkfunkrepeat2:
	clr.b	35(a4)

	move.l	36(a4),d0
	beq.s	pr_checkfunkrepeatend
	move.l	d0,d2
	moveq.l	#0,d1
	move.w	10(a4),d1
	add.l	d1,d0
	add.l	d1,d0
	move.l	40(a4),a0
	addq.l	#1,a0
	cmp.l	d0,a0
	blo.s	pr_checkfunkrepeatok
	move.l	d2,a0
pr_checkfunkrepeatok:
	move.l	a0,40(a4)
	moveq	#-1,d0
	sub.b	(a0),d0
	move.b	d0,(a0)
pr_checkfunkrepeatend:
	rts

pr_checknotedelay:
	move.w	18(a4),d1
	addq.w	#1,d1
	cmp.w	d0,d1
	bne.s	pr_checknotedelayend
pr_checknotedelay2:
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	moveq.l	#0,d0
	move.w	(a4),d0
	subq.w	#1,d0
	lsl.w	#5,d0
	lea	pr_Sampleinfos(pc),a0
	add.l	d0,a0
	move.w	2(a4),6(a3)
	move.l	(a0)+,(a3)		; Setze Samplestart
	move.w	(a0)+,4(a3)		; Setze Audiodatenl�nge
	addq.l	#2,a0
	move.l	(a0)+,d2
	move.l	d2,6(a4)		; Samplerepeatpoint eintragen
	tst.w	(a0)+
	beq.s	pr_checknotedelay3
	move.l	d2,36(a4)
	move.l	d2,40(a4)
pr_checknotedelay3:
	move.w	(a0)+,10(a4)		; Samplerepeatlength eintragen
pr_checknotedelayend:
	move.w	d1,18(a4)
	rts

pr_checkretrignote:
	moveq	#$f,d0
	and.b	5(a4),d0
	move.w	18(a4),d1
	addq.w	#1,d1
	cmp.w	d0,d1
	bne.s	pr_checkretrignoteend
pr_checkretrignote2:
	moveq	#0,d1
	move.w	d7,$96(a5)
	or.w	d7,pr_dmacon-pr_framecounter(a2)
	move.w	(a4),d0
	subq.w	#1,d0
	lsl.w	#5,d0
	lea	pr_Sampleinfos(pc),a0
	move.l	(a0,d0.w),(a3)
	move.w	4(a0,d0.w),4(a3)
pr_checkretrignoteend:
	move.w	d1,18(a4)
	rts

pr_checknotecut:
	moveq	#$f,d0
	and.b	5(a4),d0
	addq.w	#1,18(a4)
	move.w	18(a4),d1
	cmp.w	d0,d1
	blt.s	pr_checknotecutend
	clr.w	12(a4)
	clr.w	54(a4)
pr_checknotecutend:
	rts

pr_checkarpeggio:
	tst.b	5(a4)
	bne.s	pr_checkarpeggio0
	rts
pr_checkarpeggio0:
	move.w	(a2),d0
	lea	pr_Arpeggiofastdivisionlist(pc),a1
	move.b	(a1,d0.w),d0
	beq.s	pr_checkarpeggio2
	cmp.b	#2,d0
	beq.s	pr_checkarpeggio1
	moveq	#0,d0
	move.b	5(a4),d0
	lsr.b	#4,d0
	bra.s	pr_checkarpeggio3
pr_checkarpeggio2:
	move.w	2(a4),6(a3)
	rts
pr_checkarpeggio1:
	moveq	#$f,d0
	and.b	5(a4),d0
pr_checkarpeggio3:
	asl.w	#1,d0
	move.w	(a4),d1
	lsl.w	#5,d1
	lea	pr_Sampleinfos+SAMPLEFINETUNEOFFSET(pc),a0
	move.l	(a0,d1.w),a0
	move.w	2(a4),d1
	lea	pr_Arpeggiofastlist(pc),a1
	moveq.l	#0,d2
	move.b	(a1,d1.w),d2
	add.b	d2,d2
	add.l	d2,a0
	moveq	#36,d7
pr_checkarpeggioloop:
	cmp.w	(a0)+,d1
	bhs.s	pr_checkarpeggio4
	dbf	d7,pr_checkarpeggioloop
	rts
pr_checkarpeggio4:
	subq.l	#2,a0
	move.w	(a0,d0.w),6(a3)
	rts

pr_checktpandvolslide:
	bsr.w	pr_checkvolumeslide
	moveq	#0,d2
	move.b	23(a4),d2
	move.w	26(a4),d0
	move.w	28(a4),d1
	bsr.s	pr_checktoneportamento2
	move.w	14(a4),26(a4)
	rts
	
pr_checktoneportamento:
	moveq	#0,d2
	move.b	5(a4),d2
	bne.s	pr_checktoneportamento1
	move.b	23(a4),d2
pr_checktoneportamento1:
	move.w	14(a4),d0
	move.w	16(a4),d1
pr_checktoneportamento2:
	cmp.w	d0,d1
	bgt.s	pr_checktoneportamentoplus
	blt.s	pr_checktoneportamentominus
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentoplus:
	add.w	d2,d0
	cmp.w	d0,d1
	bgt.s	pr_checktoneportamentoend
	move.w	d1,d0
	move.w	d1,14(a4)
	move.w	d1,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d1,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentominus:
	sub.w	d2,d0
	cmp.w	d0,d1
	blt.s	pr_checktoneportamentoend
	move.w	d1,d0
	move.w	d1,14(a4)
	move.w	d1,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d1,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts
pr_checktoneportamentoend:
	move.w	d0,14(a4)
	move.w	d0,2(a4)
	tst.w	48(a4)
	bne.s	pr_checktoneportamentoglissando
	move.w	d0,6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts	
pr_savetpvalues:
	move.l	14(a4),26(a4)
	rts
pr_checktoneportamentoglissando:
	move.w	(a4),d1
	lsl.w	#5,d1
	lea	pr_Sampleinfos+SAMPLEFINETUNEOFFSET(pc),a0
	move.l	(a0,d1.w),a0
	lea	pr_Arpeggiofastlist(pc),a1
	moveq.l	#0,d2
	move.b	(a1,d0.w),d2
	add.w	d2,d2
	add.l	d2,a0
	moveq	#0,d3
	moveq	#36*2,d1
pr_checktoneportamentoglissandoloop:
	cmp.w	(a0,d3.w),d0
	bhs.s	pr_checktoneportamentoglissando2
	addq.w	#2,d3
	cmp.w	d1,d3
	blo.s	pr_checktoneportamentoglissandoloop
	moveq	#35*2,d3
pr_checktoneportamentoglissando2:
	move.w	(a0,d3.w),6(a3)
	cmp.w	#1,(a2)
	beq.s	pr_savetpvalues
	rts

pr_checkvolumeslide:
	moveq	#0,d0
	move.b	5(a4),d0
	move.w	d0,d1
	lsr.b	#4,d1
	beq.s	pr_checkvolumeslidedown
	move.w	12(a4),d2
	add.w	d1,d2
	bmi.s	pr_checkvolumeslide0
	moveq	#64,d0
	cmp.w	d0,d2
	bgt.s	pr_checkvolumeslide64
	move.w	d2,12(a4)
	move.w	d2,54(a4)
	rts
pr_checkvolumeslidedown:	
	and.b	#$f,d0
	move.w	12(a4),d2
	sub.w	d0,d2
	bmi.s	pr_checkvolumeslide0
	moveq	#64,d0
	cmp.w	d0,d2
	bgt.s	pr_checkvolumeslide64
	move.w	d2,12(a4)
	move.w	d2,54(a4)
	rts
pr_checkvolumeslide64:
	move.w	d0,12(a4)
	move.w	d0,54(a4)
	rts
pr_checkvolumeslide0:
	clr.w	12(a4)
	clr.w	54(a4)
	rts
	
pr_checkperiodslidedown:
	moveq	#0,d0
	move.b	5(a4),d0
	add.w	d0,2(a4)
	cmp.w	#907,2(a4)
	bls.s	pr_checkperiodslidedown2
	move.w	#907,2(a4)
pr_checkperiodslidedown2:
	move.w	2(a4),6(a3)
	rts

pr_checkperiodslideup:
	moveq	#0,d0
	move.b	5(a4),d0
	sub.w	d0,2(a4)
	cmp.w	#108,2(a4)
	bge.s	pr_checkperiodslideup2
	move.w	#108,2(a4)
pr_checkperiodslideup2:
	move.w	2(a4),6(a3)
	rts

pr_checkvibandvolslide:
	bsr.w	pr_checkvolumeslide
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	25(a4),d0
	move.b	24(a4),d1
	bra.s	pr_checkvibrato4

pr_checkvibrato:
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	5(a4),d0	; Tiefe
pr_checkvibrato2:
	move.w	d0,d1		; Geschwindigkeit
	and.w	#$f,d0
	bne.s	pr_checkvibrato3
	move.b	25(a4),d0
pr_checkvibrato3:
	lsr.b	#4,d1
	bne.s	pr_checkvibrato4
	move.b	24(a4),d1
pr_checkvibrato4:
	move.w	18(a4),d2	;Position
	lsr.w	#2,d2
	and.w	#$1f,d2
	move.w	50(a4),d3
	beq.s	pr_checkvibratosine
	btst	#0,d3
	bne.s	pr_checkvibratorampdown
	move.b	#255,d3
	bra.s	pr_checkvibratoset
pr_checkvibratorampdown:
	lsl.b	#3,d2
	tst.b	19(a4)
	bmi.s	pr_checkvibratorampdown2
	move.b	#255,d3
	sub.b	d2,d3
	bra.s	pr_checkvibratoset
pr_checkvibratorampdown2:
	move.b	d2,d3
	bra.s	pr_checkvibratoset
pr_checkvibratosine:
	lea	pr_VibratoTable(pc),a0
	moveq	#0,d3
	move.b	(a0,d2.w),d3
pr_checkvibratoset:
	mulu.w	d0,d3
	lsr.w	#7,d3
	move.w	2(a4),d2
	tst.b	19(a4)
	bpl.s	pr_checkvibratoneg
	add.w	d3,d2
	bra.s	pr_checkvibrato5
pr_checkvibratoneg:
	sub.w	d3,d2
pr_checkvibrato5:
	move.w	d2,6(a3)
	lsl.w	#2,d1
	add.b	d1,19(a4)
	rts

pr_checktremolo:
	moveq	#0,d0
	moveq.l	#0,d1
	move.b	5(a4),d0	; Tiefe
pr_checktremolo2:
	move.w	d0,d1		; Geschwindigkeit
	and.w	#$f,d0
	bne.s	pr_checktremolo3
	move.b	31(a4),d0
pr_checktremolo3:
	lsr.b	#4,d1
	bne.s	pr_checktremolo4
	move.b	30(a4),d1
pr_checktremolo4:
	move.w	18(a4),d2	;Position
	lsr.w	#2,d2
	and.w	#$1f,d2
	move.w	52(a4),d3
	beq.s	pr_checktremolosine
	btst	#0,d3
	bne.s	pr_checktremolorampdown
	move.b	#255,d3
	bra.s	pr_checktremoloset
pr_checktremolorampdown:
	lsl.b	#3,d2
	tst.b	19(a4)
	bmi.s	pr_checktremolorampdown2
	move.b	#255,d3
	sub.b	d2,d3
	bra.s	pr_checktremoloset
pr_checktremolorampdown2:
	move.b	d2,d3
	bra.s	pr_checktremoloset
pr_checktremolosine:
	lea	pr_VibratoTable(pc),a0
	moveq	#0,d3
	move.b	(a0,d2.w),d3
pr_checktremoloset:
	mulu.w	d0,d3
	lsr.w	#6,d3
	move.w	20(a4),d2
	tst.b	19(a4)
	bpl.s	pr_checktremoloneg
	add.w	d3,d2
	moveq	#64,d4
	cmp.w	d4,d2
	bls.s	pr_checktremolo5
	move.w	d4,d2
	bra.s	pr_checktremolo5
pr_checktremoloneg:
	sub.w	d3,d2
	bpl.s	pr_checktremolo5
	moveq	#0,d2
pr_checktremolo5:
	move.w	d2,54(a4)
	lsl.w	#2,d1
	add.b	d1,19(a4)
	rts

pr_VibratoTable:	
	dc.b	0,24,49,74,97,120,141,161
	dc.b	180,197,212,224,235,244,250,253
	dc.b	255,253,250,244,235,224,212,197
	dc.b	180,161,141,120,97,74,49,24
pr_FunkTable:
	dc.b	0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128
	
* Variables ***********************************************************

pr_module:			dc.l	0
pr_startposition:		dc.w	0
pr_speed:			dc.w	6
pr_highestpattern:		dc.w	0
pr_currentpattern:		dc.w	0
pr_framecounter:		dc.w	0
pr_patterndelaytime:		dc.w	0
pr_patternhasbeenbreaked:	dc.w	0
pr_Patternpositions:		ds.l	128
pr_Patternpt:			dc.l	0
pr_Currentposition:		dc.l	0
pr_Patternct:			dc.w	0
pr_oldledvalue:			dc.w	0
pr_dontcalcnewposition:		dc.w	0
pr_commandnotedelay:		dc.w	0
pr_old78:			dc.l	0
pr_Vectorbasept:		dc.l	0
pr_Channel0:			dc.w	1
				ds.w	30
pr_Channel1:			dc.w	1
				ds.w	30
pr_Channel2:			dc.w	1
				ds.w	30
pr_Channel3:			dc.w	1
				ds.w	30
pr_dmacon:			dc.w	$8000

pr_Arpeggiofastlist:		ds.b	1000
pr_Arpeggiofastdivisionlist:	ds.b	$100
pr_fastperiodlist:		ds.l	16
pr_Sampleinfos:			ds.b	32*32

pr_periods:
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
pr_Arpeggiofastlistperiods:
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

* END OF PRORUNNER ***************************************************

;	SECTION	MUSIC,DATA_C
unit:
blk.b	16*4,0	;cols
blk.b	7344,0	;pic
pr_data:
blk.b	221000,0
pr_dataend:

trackbuffer=pr_dataend-7300

;trackbuffer:
;blk.b	14000,0

textchars1:
	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789&:;,.()!?'-"
textcharsend1:

asciitext1:
dc.b	"hi there, folks, and welcome to ...music for the lost... from abyss"
dc.b	". it took (as always) longer than expected, but finally, these guys"
dc.b	" made it:  moon - real havok coding ... artline and toxic" 
dc.b	"- grafix ... neurodancer - music & scrolltexts ... all of us named "
dc.b	"before - design ...       okey, you see, i'm the one responsible "
dc.b	"for the entertainment in the scrollers so lets start with that "
dc.b	"story of the musicdisk: "
dc.b	"but before i forget to mention it... you can reach the endpart "
dc.b	"with your right mousebutton! and now of to the story... "
dc.b	"well, artline and me were planning to "
dc.b	"create a musicdisk with some of my weird songs since our time in "
dc.b	"agnostic front, our former group, yet the lack of a decent coder "
dc.b	"always hindered us to release our plans - so, as we joined beyond, "
dc.b	"which became abyss in the cooperation with arise, our expectations "
dc.b	"were somewhat high, and codex 2005 seemed to be the guy able to "
dc.b	"realize the code and fulfil our purposes... unfortunately, when "
dc.b	"he was just starting to code he had to stop his activities becoz "
dc.b	"he had to pass his social year instead of doing military service. "
dc.b	"so the whole project died once more... but not for long! when moon " 
dc.b	"and apollo joined, they were the choosen ones (and cursed "
dc.b	"us more than once becoz of our weird ideas! "
dc.b	"but finaly apollo canceled his work and moon had to to the whole "
dc.b	"coding, "
dc.b	"but, as you can see, "
dc.b	"the job was done quite well (at least -we- are satisfied!)! "
dc.b	"i won't give you a listing of what this sounddisk took to create, "
dc.b	"becoz the idea of such a list is old and the list would contain "
dc.b	"only cigarettes, coffeinoholic beverage, numerous stamps and dozens "
dc.b	"of wrecked down nerves... so what? enuff!       maybe some words "
dc.b	"about the music on these two disks... as you might have noticed, "
dc.b	"we chose the songs standing a bit apart from normal amiga music "
dc.b	"you might be used to hearing from guys such as tip and mantronix "
dc.b	"or others... it wasn't my intention to give you amiga music in "
dc.b	"the normal style, i wanted to release the tunes being a bit out "
dc.b	"of the ordinary yet still pleasant to listen too... i hope i "
dc.b	"succeeded. maybe these songs won't hit the taste from all of you, "
dc.b	"but thats what i-do-not-care for! i neither want to discredit "
dc.b	"composers like tip/mtx, but... aren't you fed up with standard "
dc.b	"music, too? okey, its not my aim to become agressive in any way, "
dc.b	"don't take this all -too- serious!        well, i think enough "
dc.b	"has been said about this musicdisk... maybe we should continue "
dc.b	"with some more decent information. against any further statements, "
dc.b	"we are definitely -not- searching any more members! one might "
dc.b	"think its an odd as we just lost some friends that refounded "
dc.b	"arise... but we noticed that our bunch is just all right. we know "
dc.b	"each other at least a bit and except for our sysop i also know how "
dc.b	"the faces of our members look alike! great, eh! well, well, well, "
dc.b	"as we reached this stage, i'd like to pass "
dc.b	"some personal greetings over to: cazal - taron - pencl - pink - "
dc.b	"alex - tom - hellraiser - xxx - snake - funky - chris 6 percent"
dc.b	" - felix - candyman - redor - nose - uli - turbo... and to a lot "
dc.b	"of noncomputer guys, but as they never see this, why mention them "
dc.b	"here?! lets continue with "
dc.b	"the standard shit having to be present in every scroller... yessir, "
dc.b	"here comes a damn fucking memberlist - no order, just as they came "
dc.b	"into my mind... smc (coding/sfx) - skindiver (packs/swapping) - "
dc.b	"toxic (gfx) - artline (gfx) - the duke (packs/swapping) - zeroflag"
dc.b	" (coding) - jumping pixel (gfx) - apollo (coding) - moon (coding)"
dc.b	" - mr. night (modem) - kiwi (sysop) - caro (coding, modem) - "
dc.b	"neurodancer (sfx)... by the "
dc.b	"way, why don't you give digital implosion, our ghq, a call? just "
dc.b	"try:          49-(0)-762264818          and kiwi will welcome you "
dc.b	"with his dst 14.4 on this simply-no-business-thinking bbs! "
dc.b	" awright, seems as if the commercials are over, so why don't we "
dc.b	"continue? naaa, its been long enough you say? whats on, we have just "
dc.b	"passed 5 kilobytes of text, so everybody in the place, lets go! "
dc.b	"oh no not the prodigy please, the music is quite funny but its "
dc.b	"always the same... i'll take your brain to another dimension. "
dc.b	"erm... maybe not. because here come the bad news. mr. night, one "
dc.b	"of our youngest members, has been knocked out in the parking area "
dc.b	"in front of a disco, and then those bastards stole the car from "
dc.b	"his friend with whom he was at the disco... the car was found "
dc.b	"totally wrecked later, and mr. night will have to stay in the "
dc.b	"hospital for about six (!) weeks if his nose is as seriously "
dc.b	"damaged as it looks like ... seems as if germany is full "
dc.b	"of brainless idiots... best wishes to you from all of us, and hope "
dc.b	"you'll recover soon! okey, what else do we have to write? "
dc.b	"brainstorming... any ideas? no? you think its time to go? okey, "
dc.b	"i think so, too... long scrollers are boring if they reach this "
dc.b	"point of very low inspiration, and as i have to learn something "
dc.b	"for the damn school where i have to pass a little nasty test "
dc.b	"tomorrow, lets do it just like anarchy: stop at the top... erm, "
dc.b	"i wonder if this scroller had any tops, but who cares?! so, "
dc.b	"these words are all thats left: see you somewhere on amiga, this "
dc.b	"won't have been the last musicdisk from us as i still have loadsa "
dc.b	"weird songs in stock! "
dc.b	"and i can promise you a trackmo or at least a big filedemo, apollo "
dc.b	"already started coding... so watch out for any further abyss relea"
dc.b	"ses in the (more or less near) future. keep things rolling, and "
dc.b	"don't let 'em getcha! bye!                                     "
dc.b	"                                             wrap the shit, here "
dc.b	"it comes again: "
textend1:
even

textchars2:
	dc.b	" abcdefghijklmnopqrstuvwxyz0123456789/'.[]!?-,+:"
textcharsend2:

asciitext2:
songscroll1:
dc.b	"angry heart     "
dc.b	"   angry heart - ever felt so restless, so nervous, the anger "
dc.b	"burning inside you? you can see your aim but can't reach it? "
dc.b	"hard music for hard feelings, thats what this song is. it has "
dc.b	"some tendencies to techno, although i would rather call it "
dc.b	"some kind of aggressive depro electro. well, listen and make up "
dc.b	"your mind...           "
dc.b	-1
songscroll1end:
blk.b	songscroll1-songscroll1end+512,0

songscroll2:
dc.b	"cry             "
dc.b	"   cry, release your soul from the sorrow and the pain. see the "
dc.b	"world, clearer through your tears, and the light of life touches "
dc.b	"you with all its strength.                                   "
dc.b	-1
songscroll2end:
blk.b	songscroll2-songscroll2end+512,0

songscroll3:
dc.b	"fusion          "
dc.b	"   the forces united, fusion of strength... the first two patterns "
dc.b	"in this song were made about one year ago by pale rider of "
dc.b	"agnostic front, and as he never finished the song i asked him "
dc.b	"wether i may use them... this is the result - maybe not what you "
dc.b	"expected, christian, and its not your style, anyway. this is the "
dc.b	"fusion of your intro and my ideas...                         "
dc.b	-1
songscroll3end:
blk.b	songscroll3-songscroll3end+512,0

songscroll4:
dc.b	"third kiss      "
dc.b	"   the heart full of sorrow because you're going to leave me, the "
dc.b	"heart full of love which you don't know about, the heart full "
dc.b	"of love which we shared - don't leave me, please, release me.  "
dc.b	"                          "
dc.b	-1
songscroll4end:
blk.b	songscroll4-songscroll4end+512,0

songscroll5:
dc.b	"dawn of creation"
dc.b	"   dawn of creation - inspired by philip jose farmers novel world "
dc.b	"of tiers, where the race of the lords constantly fights against "
dc.b	"each other on their self created strange worlds. the song should "
dc.b	"express the feelings of one of those lords, creating another "
dc.b	"world where the peoples must life in fear every day.          "
dc.b	-1
songscroll5end:
blk.b	songscroll5-songscroll5end+512,0

songscroll6:
dc.b	"waiting         "
dc.b	"   watching the time, tick tick away, sitting in my room and waiting "
dc.b	"for your call, why don't you call? give me a sign, say that you're "
dc.b	"here, i'm waiting... still waiting.                              "
dc.b	-1
songscroll6end:
blk.b	songscroll6-songscroll6end+512,0

songscroll7:
dc.b	"angelo di luce  "
dc.b	"angelo di luce, the sun, angel of light... her first soft rays "
dc.b	"flying over fields and sea, threatening the darkness of the night,"
dc.b	" touching the land like the very first sweet kiss of two lovers, "
dc.b	"then increasing in strength into the amelioration of day... "
dc.b	"this song is some kind of an add-on to the existing ones, as "
dc.b	"there was a lot of space left... anyway, it was planned to be "
dc.b	"released here originally, so nothing changed in the end... "
DC.B	"                                                           "
dc.b	-1
songscroll7end:
blk.b	songscroll7-songscroll7end+512,0

messagescroll1:
dc.b	"   -loading-  -loading-  -loading-  -loading-  "
dc.b	"-loading-  -loading-  -loading-  -loading-  "
dc.b	"-loading-  -loading-  -loading-  -loading-  "
dc.b	"-loading-  -loading-  -loading-  -loading-  "
dc.b	"still loading. silence, only the "
dc.b	"floppy makes some noise. noise? well, whats the difference "
dc.b	"between noise and music? the difference between bad and "
dc.b	"harmonic music? harmony is like a key, a key to open doors, "
dc.b	"doors to other, strange dimensions. once you have discovered "
dc.b	"one, you want never turn back to realety. then its easy "
dc.b	"to see the difference between good and bad music! "
dc.b	"this text is dedicated to duke [gallows design/manitou] "
dc.b	"for a long 'midnight-discussion' about the meaning of music, "
dc.b	"which i [moon] enjoyed very much.                             "
dc.b	-1
messagescroll1end:

textend2:
calcplane:	blk.l	100*64/4,0;$ffffffff
plane1:	blk.l	100*64/4,$ffffffff
plane2:	blk.l	100*64/4,$ffffffff

even
offsettext2:
songscrollbase:
blk.w	textend2-asciitext2+2,0

offsettext1:
blk.w	textend1-asciitext1+2,0

proptext1:
blk.w	textend1-asciitext1+2,0

menpic:
incbin "data/menpic1add"

swapdiskunit:
incbin "data/swapdiskunit_p"
even

scrollplane:
;blk.b	54*6*9,0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0
blk.b	54*5,$ff
blk.b	54*1,$0


copperlist:
dc.l	$200ffffe	;second halv logo
cmencol2_1:
dc.w	$01a0,$0,$01a2,$0,$01a4,$0,$01a6,$0
dc.w	$01a8,$0,$01aa,$0,$01ac,$0,$01ae,$0
dc.w	$01b0,$0,$01b2,$0,$01b4,$0,$01b6,$0
dc.w	$01b8,$0,$01ba,$0,$01bc,$0,$01be,$0

dc.l	$750ffffe	;first halv second halv
cscrollcol:
dc.l	$01a00220	;scrollcol

cmencol2_2:
dc.w	$0180,$0,$0182,$0,$0184,$0,$0186,$0
dc.w	$0188,$0,$018a,$0,$018c,$0,$018e,$0
dc.w	$0190,$0,$0192,$0,$0194,$0,$0196,$0
dc.w	$0198,$0,$019a,$0,$019c,$0,$019e,$0

dc.l	$a40ffffe	;first halv first halv


cmencol1_1:
dc.w	$0180,$0,$0182,$0,$0184,$0,$0186,$0
dc.w	$0188,$0,$018a,$0,$018c,$0,$018e,$0
dc.w	$0190,$0,$0192,$0,$0194,$0,$0196,$0
dc.w	$0198,$0,$019a,$0,$019c,$0,$019e,$0

dc.l	$c30ffffe
piccol:
dc.w	$01a0,$0,$01a2,$0,$01a4,$0,$01a6,$0
dc.w	$01a8,$0,$01aa,$0,$01ac,$0,$01ae,$0
dc.w	$01b0,$0,$01b2,$0,$01b4,$0,$01b6,$0
dc.w	$01b8,$0,$01ba,$0,$01bc,$0,$01be,$0

copperlistend:
dc.l	$fffffffe
grname:	dc.b	"graphics.library",0
even

;cube

linepoints1: dc.w  7; 8 Linepoints

linekoord1:	blk.b	64,0
linekoords1:
dc.w 0,-19,-19, 19
dc.w 0,-19, 19, 19
dc.w 0, 19, 19, 19
dc.w 0, 19,-19, 19
dc.w 0,-19,-19,-19
dc.w 0,-19, 19,-19
dc.w 0, 19, 19,-19
dc.w 0, 19,-19,-19


arealines:
dc.w	5	;2 areas exist
dc.w	3,0,(0+0)*8,(1+0)*8,(2+0)*8,(3+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;1
dc.w	3,0,(4+0)*8,(7+0)*8,(6+0)*8,(5+0)*8,(4+0)*8,0,0,0,0,0,0,0,0,0;2
dc.w	3,1,(0+0)*8,(4+0)*8,(5+0)*8,(1+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;3
dc.w	3,1,(3+0)*8,(2+0)*8,(6+0)*8,(7+0)*8,(3+0)*8,0,0,0,0,0,0,0,0,0;4
dc.w	3,2,(1+0)*8,(5+0)*8,(6+0)*8,(2+0)*8,(1+0)*8,0,0,0,0,0,0,0,0,0;5
dc.w	3,2,(0+0)*8,(3+0)*8,(7+0)*8,(4+0)*8,(0+0)*8,0,0,0,0,0,0,0,0,0;6

areaoffsets:
dc.w	5	;2 areas to draw
dc.w	0*32
dc.w	1*32
dc.w	2*32
dc.w	3*32
dc.w	4*32
dc.w	5*32



zpositions:
blk.w	20,0

;2,3,(5)
patternplane1:
blk.b	6400,255

patternplane2:
blk.b	6400,0
>extern "data/patternplane2con",patternplane2,6400
patternplane3:
blk.b	6400,0
>extern "data/patternplane3con",patternplane3,6400

patternplanes:
dc.l	patternplane1
dc.l	patternplane2
dc.l	patternplane3



b:
