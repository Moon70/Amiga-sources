;------------------------------------------------------------------------
;|                                                                      |
;|                                Cloud                                 |
;|                               -------                                |
;| greetings...                                                         |
;|                                                                      |
;| code by Moon                                                         |
;------------------------------------------------------------------------
UseSection=1


ifne	UseSection
section	CodeC,code_c
endif
codec_s:


showtime=0
Program_ID=1
Main_Initcall2=0
Main_Enable_Jp60music=0
Main_Enable_SetIntFlag=0
Main_Enable_JCommander=0
Main_Enable_Exit=1
include	"/maininit/maininit6.01.s"
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
;---------------------------------
	bsr.w	switchplanes
	jsr	textcalc

;-------
	lea	picsin,a0
	moveq	#60,d7
sincalc_l:
	move.l	(a0),d0
	lsl.l	#8,d0
	addq.l	#1,d0
	move.l	d0,(a0)+
	dbf	d7,sincalc_l
;-------
	move.l	#DPage1,maincommand

	jsr	logocopy
	lea	$dff000,a5
	jsr	coppercopy

;--------------------------
	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)
	movem.l	(a7)+,d0-a6
;-------------------------
	rts
;----------
;------------------------------------------------------------------------
;--------------
Main_program:;;
	lea	$dff000,a5
	move.l	#$298129c1,diwstrt(a5)	;strt+stop!
	move.l	#$003800d0,ddfstrt(a5)	;strt+stop!
;	move.w	#%0101001000000000,bplcon0(a5)
	move.l	#$00000000,bplcon1(a5)	;col1+col2!
	move.l	#$00000000,bpl1mod(a5)	;1mod+2mod!

	move.l	showplane(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl5pth(a5)


	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)

	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist,(a0)

	jsr	logocolput
	move.w	#$0feb,$18a(a5)
	move.w	#$0eda,$18c(a5)

main_loop:
;	btst	#6,ciaapra
;	beq.b	main_loopexit
	lea	maincommand(pc),a0
	tst.l	(a0)
	bmi.b	main_loopexit
	beq.b	main_loop

	move.l	(a0),a1
	clr.l	(a0)
	jsr	(a1)
	bra.b	main_loop

main_loopexit:
	rts
;----------

Commands:;;
	dc.l		60,	nothing
	dc.l		10,	dotext
	dc.l		250,	down
	dc.l		110,	up

	dc.l		10,	setpage2
	dc.l		250,	down
	dc.l		110,	up

	dc.l		10,	setpage3
	dc.l		250,	down
	dc.l		110,	up
	dc.l		1,	picdown
	dc.l		60000,	nothing


nothing:	rts

picdown:
	move.l	Main_VBIVector(pc),a0
	move.l	#vbi,(a0)
	move.w	#-4,picsinadd
	subq.w	#4,picsinpos
	move.l	#-2,copperlist
	lea	maincommand(pc),a0
	move.l	#-1,(a0)
	rts

dotext:
	move.l	Main_VBIVector(pc),a0
	move.l	#vbi2,(a0)
	move.w	#%0101001000000000,bplcon0(a5)
	rts

up:
	move.w	#-$0200,copper_bardir
	rts

down:
	move.w	#$0200,copper_bardir
	rts

Setpage2:
	move.l	#DPage2,maincommand
	rts

Setpage3:
	move.l	#DPage3,maincommand
	rts

DPage1:
	lea	text+16*11*2*0,a6
	jsr	drawpage
rts

DPage2:
	lea	text+16*11*2*1,a6
	jsr	drawpage
rts

DPage3:
	lea	text+16*11*2*2,a6
	jsr	drawpage
rts


VBI:;;
	move.l	showplane(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl5pth(a5)

	bsr	coppercopy2

	jsr	drawstar
	bsr	switchplanes
	bsr.w	commander
rts

VBI2:;;
	move.l	showplane(pc),a0
	move.l	a0,bpl1pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	40*256(a0),a0
	move.l	a0,bpl5pth(a5)

	bsr	coppercopy

	jsr	drawstar
	bsr	switchplanes
	bsr.w	commander
rts

;------------------------------------------------------------------------
intreq=$09c
startlist=38


dmaconr=$002


oldint:		dc.l	0
switchmark:	dc.l	0

switchplanes:
	not.w	switchmark
	beq.b	switchplanesl2
	move.l	#logopic0,showplane
	move.l	#logopic1,pointplane
	rts
switchplanesl2:
	move.l	#logopic1,showplane
	move.l	#logopic0,pointplane
	rts
;--------

planecls:
	lea	$dff000,a5
	move.l	clearplane(pc),d0
	add.l	#45*40+8,d0
bwait4:
btst	#14,dmaconr(a5)
bne.b	bwait4

	move.l	d0,BLTDPTH(A5)
	move.w	#16,BLTDMOD(A5)
	move.l	#%00000001000000000000000000000000,BLTCON0(A5);0+1
	move.w	#164*64+20-8,BLTSIZE(A5)
	rts

fill:
	lea	$dff000,a5
	move.l	pointplane,d0
	add.l	#45*40+8-2,d0
	add.l	#164*40+((20-8)*2),d0

bwait2:	
btst	#14,dmaconr(a5)
bne.b	bwait2


	MOVE.l	d0,bltapth(A5)
	MOVE.l	d0,bltdpth(A5)
	MOVE.w	#16,bltamod(A5)
	MOVE.w	#16,bltdmod(A5)
	MOVE.l	#%00001001111100000000000000001010,bltcon0(a5);0+1 con
	MOVE.l	#-1,bltafwm(a5)

	move.w	#164*64+20-8,BLTSIZE(A5)

	rts



copper_barpos:	dc.w	$3895
copper_bardir:	dc.w	-$0100


coppercopy:
;	move.w	#$3795,d0
;	move.w	#$f795,d0
	lea	copper_barpos(pc),a0
	move.w	(a0)+,d0
	move.w	(a0),d1
	beq.b	coppercopy_skip
	add.w	d1,d0
	cmp.w	#$f795,d0
	beq.b	coppercopy_last
	cmp.w	#$3795,d0
	bne.b	coppercopy_notlast

coppercopy_last:
	move.w	#0,(a0)
coppercopy_notlast:
	move.w	d0,-(a0)

	lea	copperlist,a0
	lea	copcol1,a1
	lea	copcol2,a2

	move.l	#$01800000,(a0)+
;	move.w	#bplcon0,(a0)+
;	move.w	#%0101001000000000,(a0)+
;	move.l	#$018a0feb,(a0)+
;	move.l	#$018c0eda,(a0)+
	move.l	#$018a0322,(a0)+
	move.l	#$018c0000,(a0)+

	move.w	#14,d7
coppercopy_l1:
	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.w	#$018a,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$018c,(a0)+
	move.w	(a2)+,(a0)+

	add.w	#$0100,d0
	dbf	d7,coppercopy_l1
	move.l	#-2,(a0)
coppercopy_skip:
	rts

Copcol1:
dc.w $322,$433,$533,$644,$654,$765,$866,$976
dc.w $a87,$b98,$ca8,$cb9,$dca,$eda,$feb

dc.w $FEB,$EDA,$DCA,$CB9,$CA8,$B98,$A87
dc.w $976,$866,$765,$654,$644,$533,$433,$322

Copcol2:
dc.w $000,$111,$221,$332,$443,$554,$664,$765
dc.w $876,$986,$a97,$ba8,$cb8,$dc9,$eda

dc.w $EDA,$DC9,$CB8,$BA8,$A97,$986,$876
dc.w $765,$664,$554,$443,$332,$221,$111,$000


;copper_picpos:	dc.l	$1300f

coppercopy2:
	lea	copperlist,a0
	move.l	#$200ffffe,(a0)+
	move.l	#$01800003,(a0)+
	move.l	#$01000000,(a0)+
	lea	picsin(pc),a1
	add.w	picsinpos,a1
	
	move.l	(a1),d0
	bmi.b	coppercopy2_skip2
	move.w	picsinadd,d1
	add.w	d1,picsinpos

;	sub.l	#$0100,d0
;	move.l	d0,copper_picpos

	cmp.l	#$ff0f,d0
	bls.b	coppercopy2_noborder
	move.l	#$ffe1fffe,(a0)+
coppercopy2_noborder:

	move.w	d0,(a0)+
	move.w	#-2,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0101001000000000,(a0)+
	move.l	#$01800000,(a0)+
	move.l	#-2,(a0)
coppercopy2_skip:
	rts

coppercopy2_skip2:
	move.l	#$01800002,copperlist+4
	bra.b	coppercopy2_skip

Copperlist:
;	dc.l	$01000000
;	dc.l	$900ffffe
;	dc.w	bplcon0,%0101001000000000
;	dc.l	-2
	dcb.b	200,0



picsinpos:	dc.w	0

picsinadd:	dc.w	4
dc.l	-1
picsin:
dc.l	300
dc.L  292, 285, 279, 272, 265, 259, 252, 245, 239, 232, 226
dc.L  219, 213, 207, 200, 194, 188, 182, 176, 170, 164, 158
dc.L  153, 147, 142, 136, 131, 126, 121, 116, 111, 106, 102
dc.L  97, 93, 89, 85, 81, 77, 74, 70, 67, 64, 61, 58, 55
dc.L  53, 51, 49, 47, 45, 43, 42, 40, 39, 38, 37, 37, 36
dc.L  36
picsinend:
dc.l	-1


;intwait:	dc.w	0



showplane:	dc.l	0
clearplane:	dc.l	0
pointplane:	dc.l	0


logocopy:
	lea	logopic2,a0
	lea	logopic0,a1
	lea	logopic1,a2
	move.w	#51200/4-1,d0
logocopyl1:
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,logocopyl1
rts





logopic2:
	incbin	"data/Cloudface11.raw"
logopic3:
	incbin	"data/Cloudface33.raw"


logocol:
dc.w $000,$FEB,$EDA,$EDA,$CB9,$00f,$F00,$CA9
dc.w $BA8,$B98,$A98,$A87,$987,$977,$876,$866
dc.w $766,$765,$655,$654,$544,$F00,$DB9,$433
dc.w $DCA,$332,$322,$221,$211,$111,$100,$000

dc.w $000,$EDA,$FEB,$EDA,$DCA,$DB9,$CB9,$CA9
dc.w $BA8,$B98,$A98,$A87,$987,$977,$876,$866
dc.w $766,$765,$655,$654,$544,$544,$433,$433
dc.w $433,$332,$322,$221,$211,$111,$100,$000


logocolput:
	lea	$dff182,a0
	lea	logocol+2(pc),a1	;skip background(=black)

	move.w	(a1)+,(a0)+
	moveq	#14,d0
logocolputl1:
	move.l	(a1)+,(a0)+
	dbf	d0,logocolputl1
	rts


staranim:
a:
incbin	"data/star4/starpic00.con"
incbin	"data/star4/starpic01.con"
incbin	"data/star4/starpic02.con"
incbin	"data/star4/starpic03.con"
incbin	"data/star4/starpic04.con"
incbin	"data/star4/starpic05.con"
incbin	"data/star4/starpic06.con"
incbin	"data/star4/starpic07.con"
incbin	"data/star4/starpic08.con"
incbin	"data/star4/starpic09.con"
incbin	"data/star4/starpic10.con"
incbin	"data/star4/starpic11.con"
incbin	"data/star4/starpic12.con"
incbin	"data/star4/starpic13.con"
incbin	"data/star4/starpic14.con"
incbin	"data/star4/starpic15.con"
incbin	"data/star4/starpic16.con"
incbin	"data/star4/starpic17.con"
b:

starpic1:	dc.w	0
starpic2:	dc.w	0

size=105

drawstar:
	lea	$dff000,a5
move.w	sinxpos1(pc),d1
lea	sinusx(pc),a3
add.w	d1,a3

moveq	#0,d1
move.w	(a3),d1
move.w	720(a3),d2

subq.w	#8,d2
bpl.b	noneg
moveq	#0,d2
noneg:

;	lsl.w	#6,d2
mulu	#40,d2
;	add.l	d2,a0			;			 6

	ror.l	#4,d1			;x/16=wordoffset	16
	add.w	d1,d1			;bytes to words		 4
	add.w	d1,d2

	swap	d1			;			 4
	move.w	d1,d6			;...copy...		 4
	or.w	#%0000111111001010,d6	;...set miniterms...	 8
;	or.w	#%0000111111111111,d6	;...set miniterms...	 8
	swap	d6			;...word on highword...	 4
	move.w	d1,d6			;...and word!!!		 4
	move.w	#0,d6			;...and word!!!		 4









	lea	logopic2,a0
	move.l	pointplane,a1
add.w	d2,a0
add.w	d2,a1
subq.l	#2,a0
subq.l	#2,a1

moveq	#4,d7
clrstarl1:

bwait3:
btst	#14,dmaconr(a5)
bne.b	bwait3
	move.l	#-1,bltafwm(a5)

	move.l	a0,bltapth(a5)
	move.l	a1,bltdpth(a5)

	move.w	#40-20,bltamod(a5)
	move.w	#40-20,bltdmod(a5)

	move.l	#%00001001111100000000000000000000,bltcon0(a5);0+1
	move.w	#(size+16)*64+10,bltsize(a5)

	lea	256*40(a0),a0
	lea	256*40(a1),a1
	dbf	d7,clrstarl1

;--------------------------
	lea	starpic1(pc),a0
	move.w	(a0),d0
	addq.w	#1,d0
	cmp.w	#18,d0
	bne.b	noanimrestart
	moveq	#0,d0
noanimrestart:
	move.w	d0,(a0)
	move.w	d0,2(a0)

	move.w	sinxpos1(pc),d1
	addq.w	#2,d1
	cmp.w	#720,d1
	bne.b	nosinxrestart
	moveq	#0,d1
nosinxrestart:
	move.w	d1,sinxpos1
	move.w	d1,sinxpos2


	moveq	#0,d5
drawstarl2:


	lea	starpic1+2(pc),a0
	move.w	(a0),d0
	addq.w	#2,d0
	cmp.w	#18,d0
	blo.b	noanimrestart2
;	moveq	#0,d0
	sub.w	#18,d0
noanimrestart2:
	move.w	d0,(a0)
	mulu	#1792,d0
	lea	staranim(pc),a0
	add.l	d0,a0
	move.l	pointplane,a1
;	add.l	#64*140+10,a1
;	move.l	pointplane(pc),a2
	lea	logopic3,a2
;	add.l	#64*4,a2

	move.w	sinxpos2(pc),d1
	add.w	#16,d1
	cmp.w	#720,d1
	blo.b	nosinxrestart2
;	moveq	#0,d1
	sub.w	#720,d1
nosinxrestart2:
	move.w	d1,sinxpos2

lea	sinusx(pc),a3
add.w	d1,a3

moveq	#0,d1
move.w	(a3),d1
move.w	720(a3),d2

mulu	#40,d2
;	lsl.w	#6,d2
;	add.l	d2,a0			;			 6

	ror.l	#4,d1			;x/16=wordoffset	16
	add.w	d1,d1			;bytes to words		 4
	add.w	d1,d2

	swap	d1			;			 4
	move.w	d1,d6			;...copy...		 4
	or.w	#%0000111111001010,d6	;...set miniterms...	 8
;	or.w	#%0000111111111111,d6	;...set miniterms...	 8
	swap	d6			;...word on highword...	 4
	move.w	d1,d6			;...and word!!!		 4
	move.w	#0,d6			;...and word!!!		 4

add.w	d2,a1
add.w	d2,a2

moveq	#4,d7
drawstarl1:

bwait7:
btst	#14,dmaconr(a5)
bne.b	bwait7

	move.l	a0,bltapth(a5)	;stars
	move.l	a2,bltbpth(a5)	;logo2
	move.l	a1,bltcpth(a5)	;plane
	move.l	a1,bltdpth(a5)	;plane

	move.w	#0,bltamod(a5)
	move.w	#40-16,bltbmod(a5)
	move.w	#40-16,bltcmod(a5)
	move.w	#40-16,bltdmod(a5)

;	move.w	#%0000111111001010,bltcon0(a5)
;	move.w	#%0000000000000000,bltcon1(a5)
	move.l	d6,bltcon0(a5)

	move.w	#size*64+8,bltsize(a5)

add.l	#256*40,a1
add.l	#256*40,a2
dbf	d7,drawstarl1

dbf	d5,drawstarl2

bwait6:
btst	#14,dmaconr(a5)
bne.b	bwait6






rts













	lea	starpic2,a0
	move.w	(a0),d0
	addq.w	#1,d0
	cmp.w	#18,d0
	bne.b	noanimrestart3
	moveq	#0,d0
noanimrestart3:
	move.w	d0,(a0)
	mulu	#1792,d0
	lea	staranim,a0
	add.l	d0,a0
	move.l	pointplane,a1
;	add.l	#64*140+10,a1
;	move.l	pointplane,a2
	lea	logopic3,a2
	add.l	#40*2,a2

move.w	sinxpos2,d1
add.w	#72,d1
cmp.w	#720,d1
bne.b	nosinxrestart3
moveq	#0,d1

nosinxrestart3:
move.w	d1,sinxpos2

lea	sinusx,a3
add.w	d1,a3

moveq	#0,d1
move.w	(a3),d1
move.w	720(a3),d2

mulu	#40,d2
;	lsl.w	#6,d2
;	add.l	d2,a0			;			 6

	ror.l	#4,d1			;x/16=wordoffset	16
	add.w	d1,d1			;bytes to words		 4
	add.w	d1,d2

	swap	d1			;			 4
	move.w	d1,d6			;...copy...		 4
	or.w	#%0000111111001010,d6	;...set miniterms...	 8
;	or.w	#%0000111111111111,d6	;...set miniterms...	 8
	swap	d6			;...word on highword...	 4
	move.w	d1,d6			;...and word!!!		 4
	move.w	#0,d6			;...and word!!!		 4

add.w	d2,a1
add.w	d2,a2

moveq	#3,d7
drawstarl12:

bwait8:
btst	#14,dmaconr(a5)
bne.b	bwait8

	move.l	a0,bltapth(a5)	;stars
	move.l	a2,bltbpth(a5)	;logo2
	move.l	a1,bltcpth(a5)	;plane
	move.l	a1,bltdpth(a5)	;plane

	move.w	#0,bltamod(a5)
	move.w	#40-16,bltbmod(a5)
	move.w	#40-16,bltcmod(a5)
	move.w	#40-16,bltdmod(a5)

;	move.w	#%0000111111001010,bltcon0(a5)
;	move.w	#%0000000000000000,bltcon1(a5)
	move.l	d6,bltcon0(a5)

	move.w	#size*64+8,bltsize(a5)

add.l	#256*40,a1
add.l	#256*40,a2
dbf	d7,drawstarl12


bwait9:
btst	#14,dmaconr(a5)
bne.b	bwait9



rts

Drawpage:
	lea	logopic0+40*256*2,a1
	lea	logopic1+40*256*2,a2
	lea	logopic2+40*256*2,a3
	lea	logopic3+40*256*2,a4

	add.w	#23+30*40,a1
	add.w	#23+30*40,a2
	add.w	#23+30*40,a3
	add.w	#23+30*40,a4



	moveq	#10,d5
Drawpage_Yloop:

	moveq	#15,d6
Drawpage_Xloop:
	lea	font,a0
	add.w	(a6)+,a0

	moveq	#40,d0
	move.w	#15*40-1,d1
	move.w	#16*40-16,d2

	moveq	#14,d7
Drawpage_Charloop:
	move.b	(a0),(a1)
	move.b	(a0),(a2)
	move.b	(a0),(a3)
	move.b	(a0)+,(a4)

	add.w	d0,a1	;note, its raw-format
	add.w	d0,a2
	add.w	d0,a3
	add.w	d0,a4

	dbf	d7,Drawpage_Charloop
	sub.w	d1,a1
	sub.w	d1,a2
	sub.w	d1,a3
	sub.w	d1,a4
	dbf	d6,Drawpage_Xloop
	add.w	d2,a1
	add.w	d2,a2
	add.w	d2,a3
	add.w	d2,a4
	dbf	d5,Drawpage_yloop
rts


sinxpos1:	dc.w	0
sinxpos2:	dc.w	0

Sinusx:;Created with Liberty Design's Sinusmaker
dc.W  100, 103, 107, 110, 114, 117, 121, 124, 127, 131, 134
dc.W  137, 140, 143, 146, 148, 151, 153, 156, 158, 160, 162
dc.W  164, 166, 168, 169, 171, 172, 173, 174, 175, 176, 176
dc.W  177, 177, 177, 177, 177, 176, 176, 175, 175, 174, 173
dc.W  172, 171, 169, 168, 167, 165, 163, 162, 160, 158, 156
dc.W  154, 152, 150, 148, 145, 143, 141, 139, 137, 135, 132
dc.W  130, 128, 126, 124, 122, 120, 118, 116, 115, 113, 111
dc.W  110, 108, 107, 106, 105, 104, 103, 102, 102, 101, 101
dc.W  100, 100, 100, 100, 100, 101, 101, 102, 102, 103, 104
dc.W  105, 106, 107, 108, 110, 111, 113, 115, 116, 118, 120
dc.W  122, 124, 126, 128, 130, 132, 135, 137, 139, 141, 143
dc.W  145, 148, 150, 152, 154, 156, 158, 160, 162, 163, 165
dc.W  167, 168, 169, 171, 172, 173, 174, 175, 175, 176, 176
dc.W  177, 177, 177, 177, 177, 176, 176, 175, 174, 173, 172
dc.W  171, 169, 168, 166, 164, 162, 160, 158, 156, 153, 151
dc.W  148, 146, 143, 140, 137, 134, 131, 127, 124, 121, 117
dc.W  114, 110, 107, 103, 100, 97, 93, 90, 86, 83, 79, 76
dc.W  73, 69, 66, 63, 60, 57, 54, 52, 49, 47, 44, 42, 40
dc.W  38, 36, 34, 32, 31, 29, 28, 27, 26, 25, 24, 24, 23
dc.W  23, 23, 23, 23, 24, 24, 25, 25, 26, 27, 28, 29, 31
dc.W  32, 33, 35, 37, 38, 40, 42, 44, 46, 48, 50, 52, 55
dc.W  57, 59, 61, 63, 65, 68, 70, 72, 74, 76, 78, 80, 82
dc.W  84, 85, 87, 89, 90, 92, 93, 94, 95, 96, 97, 98, 98
dc.W  99, 99, 100, 100, 100, 100, 100, 99, 99, 98, 98, 97
dc.W  96, 95, 94, 93, 92, 90, 89, 87, 85, 84, 82, 80, 78
dc.W  76, 74, 72, 70, 68, 65, 63, 61, 59, 57, 55, 52, 50
dc.W  48, 46, 44, 42, 40, 38, 37, 35, 33, 32, 31, 29, 28
dc.W  27, 26, 25, 25, 24, 24, 23, 23, 23, 23, 23, 24, 24
dc.W  25, 26, 27, 28, 29, 31, 32, 34, 36, 38, 40, 42, 44
dc.W  47, 49, 52, 54, 57, 60, 63, 66, 69, 73, 76, 79, 83
dc.W  86, 90, 93, 97


Sinusy:;Created with Liberty Design's Sinusmaker
dc.W  70, 72, 74, 75, 77, 79, 81, 83, 85, 86, 88, 90, 92
dc.W  93, 95, 97, 98, 100, 101, 103, 104, 106, 107, 109, 110
dc.W  112, 113, 114, 115, 117, 118, 119, 120, 121, 122, 123
dc.W  124, 125, 126, 126, 127, 128, 128, 129, 129, 130, 130
dc.W  131, 131, 131, 131, 131, 132, 132, 132, 132, 131, 131
dc.W  131, 131, 131, 130, 130, 130, 129, 129, 128, 127, 127
dc.W  126, 125, 125, 124, 123, 122, 121, 120, 119, 118, 117
dc.W  116, 115, 114, 113, 112, 111, 110, 109, 107, 106, 105
dc.W  104, 103, 101, 100, 99, 98, 96, 95, 94, 92, 91, 90
dc.W  89, 88, 86, 85, 84, 83, 82, 80, 79, 78, 77, 76, 75
dc.W  74, 73, 72, 71, 70, 69, 68, 67, 67, 66, 65, 64, 64
dc.W  63, 62, 62, 61, 61, 60, 60, 59, 59, 59, 58, 58, 58
dc.W  58, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 58, 58
dc.W  58, 58, 58, 59, 59, 59, 60, 60, 61, 61, 62, 62, 63
dc.W  63, 64, 64, 65, 65, 66, 66, 67, 68, 68, 69, 69, 70
dc.W  71, 71, 72, 72, 73, 74, 74, 75, 75, 76, 76, 77, 77
dc.W  78, 78, 79, 79, 80, 80, 81, 81, 81, 82, 82, 82, 82
dc.W  82, 83, 83, 83, 83, 83, 83, 83, 83, 83, 83, 82, 82
dc.W  82, 82, 81, 81, 81, 80, 80, 79, 79, 78, 78, 77, 76
dc.W  76, 75, 74, 73, 73, 72, 71, 70, 69, 68, 67, 66, 65
dc.W  64, 63, 62, 61, 60, 58, 57, 56, 55, 54, 52, 51, 50
dc.W  49, 48, 46, 45, 44, 42, 41, 40, 39, 37, 36, 35, 34
dc.W  33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20
dc.W  19, 18, 17, 16, 15, 15, 14, 13, 13, 12, 11, 11, 10
dc.W  10, 10, 9, 9, 9, 9, 9, 8, 8, 8, 8, 9, 9, 9, 9, 9, 10
dc.W  10, 11, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 19
dc.W  20, 21, 22, 23, 25, 26, 27, 28, 30, 31, 33, 34, 36
dc.W  37, 39, 40, 42, 43, 45, 47, 48, 50, 52, 54, 55, 57
dc.W  59, 61, 63, 65, 66, 68


;------------------------------------------------------------------------
chars:	dc.b	" abcdefghijklmnopqrstuvwxyz1234567890"
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
dc.b	"greets to these "
dc.b	"    friends     "
dc.b	"                "
dc.b	"absolute        "
dc.b	"        alcatraz"
dc.b	"andromeda       "
dc.b	"         balance"
dc.b	"bomb            "
dc.b	"         complex"
dc.b	"cryptoburners   "
dc.b	"             dcs"

dc.b	"delon           "
dc.b	"          desire"
dc.b	"essence         "
dc.b	"        freezers"
dc.b	"lego            "
dc.b	"           melon"
dc.b	"movement        "
dc.b	"          mystic"
dc.b	"nuance          "
dc.b	"        parallax"
dc.b	"polka brothers  "

dc.b	"ram jam         "
dc.b	"      razor 1911"
dc.b	"rebels          "
dc.b	"          saints"
dc.b	"sanity          "
dc.b	"      spaceballs"
dc.b	"speedy          "
dc.b	"            trsi"
dc.b	"virtual dreams  "
dc.b	"                "
dc.b	"and to the rest "

	textend:	blk.b	textend-text,0
textoffsetend:	dc.w	-1

charsize=1*15
textcalc:
	lea	textoffsetend(pc),a0
	lea	textend(pc),a1
	lea	charsend(pc),a2
	move.w	#textend-text-1,d7
textcalcl1:
	move.l	a2,a3
	move.b	-(a1),d0
	moveq	#charsend-chars-1,d6
textcalcl2:
	cmp.b	-(a3),d0	
	beq.b	textcalcl3
	dbf	d6,textcalcl2
textcalcl3:
	mulu.w	#charsize,d6
	move.w	d6,-(a0)
	dbf	d7,textcalcl1
	rts
;----------



Font:	incbin	"data/Font.raw"
even
codec_e:

ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:

ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
logopic0:
	ds.b	51200
logopic1:
	ds.b	51200
bssc_e:

ifne	UseSection
;section	CodeP,code_p
endif
codep_s:
codep_e:

ifne	UseSection
;section	DataP,data_p
endif
datap_s:
datap_e:

ifne	UseSection
;section	BSSP,bss_p
endif
bssp_s:
bssp_e:

printt	"Code Chip:"
printv	codec_e-codec_s
printt	"Data Chip:"
printv	datac_e-datac_s
printt	"BSS Chip"
printv	bssc_e-bssc_s
printt	"Code Public:"
printv	codep_e-codep_s
printt	"Data Public:"
printv	datap_e-datap_s
printt	"BSS Public"
printv	bssp_e-bssp_s
printt
printt	"Chip Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s
printt	"Public Memory:"
printv	codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s


