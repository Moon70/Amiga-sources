;------------------------------------------------------------------------
;-                                                                      -
;-                              StarScroller                            -
;-                             --------------                           -
;-                                                                      -
;-                                                                      -
;- coded in april 1992 by Moon, released in july 1993 by Abyss          -
;------------------------------------------------------------------------

rastport=$60000
bitmapstr=$61000
textpoint=$60404
copmark=$60408
coltab=$63c60
clist=$60500

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

dmaconr=$002
findresident=-96

move.l	4,a6	;this lines only to test from ASMOne
bsr	start
rts


a:
block:
dc.b	"DOS",0
dc.l	0
dc.l	$00000370

start:
movem.l	a4-a6,-(a7)		;store some register
;--------------------------------------------------------------------
	lea	gfxname(pc),a1	;name gfxlib
	moveq	#0,d0
	jsr	-$228(a6)	;openlib
	move.l	d0,a6		;base gfxlib in a6

	lea	rastport,a1	;address of rastport-structur
	move.l	a1,-(a7)	;save on stack
	jsr	-$c6(a6)	;init rastport

	lea	bitmapstr,a0	;bitmap-structur address
	move.l	(a7),a1		;rastport-structur (from stack)
	move.l	a0,4(a1)	;bitmapstructaddr in rastport-structur

	moveq	#1,d0		;bitplanes

moveq	#96,d1	;this four lines are doing the same like this two lines:
moveq	#1,d2	;	move.l	#352,d1		(screen x=352 pixels)
lsl.w	#8,d2	;	move.l	#256,d2		(screen y=256 pixels)
or.w	d2,d1	;...but the commands are four bytes shorter!!

	jsr	-$186(a6)	;initbitmap


	lea	$61050,a0	;bitplane-adr...
	lea	clist-$61050(a0),a2;   = lea $60500,a2 (copperlist)
	lea	[206*44]+36(a0),a4;stamp-screenoffset

	move.l	a0,bitmapstr+8	;...in bitmapstructur

	move.w	#2816+80,d0	;clear bitmap+coltab
clrloop:
	clr.l	(a0)+
	dbf	d0,clrloop

	move.l	#$226c90,(a4)
	move.l	#$3692d0,44(a4)
	move.l	#$2a92b0,88(a4)
	move.l	#$226c90,132(a4)

;the colours of the scroller are moved in a big, cleared area (coltab)
;and from this area they were moved into the copperlist       (clist)
;stupid datamoving-but saves some bytes!

	lea	coltab+140,a3	;coltab
	lea	128(a3),a0	;stampcol
	lea	colcodes(pc),a4	;colours for scroller
	moveq	#10,d0
setcolloop:
	move.w	(a4)+,(a3)
	addq.w	#6,a3
	dbf	d0,setcolloop

	move.l	-(a4),(a0)+	;set stampcol
	move.l	(a4),(a0)


	lea	copperlist(pc),a1
	moveq	#[[coppercut-copperlist]/4]-1,d0

	lea	$dff000,a4	;basic custom chips
	move.w	#%0000000000100000,$96(a4)	;dmacon
	move.l	a2,$80(a4)	;cop1lch
copcopyloop:
	move.l	(a1)+,(a2)+
	dbf	d0,copcopyloop

move.l	#$01400000,d3
move.l	d3,(a2)+

move.l	a2,copmark

lea	start(pc),a0	;bitplane-adr...
lea	coltab,a3
move.w	#139,d0
move.w	#$720f,d2

copcopyloop3:
move.w	#$0184,(a2)+
move.w	(a3),(a2)+
move.w	#$0186,(a2)+
move.w	(a3)+,(a2)+

move.w	d2,(a2)+
move.l	#$fffe0140,(a2)+
move.w	(a0)+,(a2)+

add.w	#$0100,d2
	dbf	d0,copcopyloop3
move.l	d3,(a2)+

	moveq	#[[copperlistend-coppercut]/4]-1,d0
copcopyloop2:
	move.l	(a1)+,(a2)+
	dbf	d0,copcopyloop2
 
	move.w	#%1000001111000000,$96(a4)	;dmacon


	lea	spirit(pc),a0	;set textpointer to the start...
	move.l	a0,textpoint			;...of SPIRIT

	moveq	#9,d1
	lea	$61050+[55*44]-2,a1

writelogo:
	move.l	d1,-(a7)
	addq.l	#4,a1
	move.l	a1,-(a7)
	bsr.w	setzoom
	move.l	(a7),a1
	lea	$61050+[170*44]+40,a2
	moveq	#31,d0
	moveq	#44,d1
logocopy:
	move.l	(a2),(a1)
	sub.l	d1,a1
	sub.l	d1,a2
	dbf	d0,logocopy
	move.l	(a7)+,a1
	move.l	(a7)+,d1
	dbf	d1,writelogo




moveq	#8,d1
lea	text(pc),a0		;set textpointer to the start
move.l	a0,textpoint		;...of the scroller


scrollloop:
	lea	$dff000,a4
	cmp.b	#$40,6(a4)
	bne.b	scrollloop

move.l	d1,-(a7)

	move.l	#$62994,bltapth(a4) 
	move.l	#$62992,bltdpth(a4)
	move.l	#%11001001111100000000000000000000,bltcon0(a4)
	clr.l	bltamod(a4)
	clr.l	bltcdat(a4)
	move.l	#%00000000011111111111111111111111,bltafwm(a4)
	move.w	#1942,bltsize(a4)

	move.l	copmark,a0
	moveq	#34,d0
starmove:
	addq.w	#1,14(a0)
	addq.w	#2,30(a0)
	addq.w	#3,46(a0)
	addq.w	#4,62(a0)
	lea	64(a0),a0
	dbf	d0,starmove

blitterwait:
	btst	#14,dmaconr(a4)
	bne.b	blitterwait

	move.l	(a7)+,d1
	dbf	d1,scrollloop
	bsr.b	setzoom
	moveq	#8,d1
	btst	#6,$bfe001	;hey mousie, how are you
	bne.b	scrollloop

	move.l	$26(a6),$80(a4)	;systemcopperlist
	addq.l	#4,a7
;--------------------------------------------------------------------
movem.l	(a7)+,a4-a6		;restore some register

lea	gfxname+5(pc),a1
move.w	#"do",(a1)		;this MOVE changes   graphics.library to
				;                         dos.library
				;this idea brings me 10 bytes !!!
jsr	findresident(a6)	;find doslib as a resident module
sub.l	a0,a0			;clear a0
move.l	22(a0,d0),a0		;move base in a0

moveq	#0,d0			;no errors
ende:	rts			;return



setzoom:
	move.l	#rastport,-(a7)
	move.l	(a7),a1
	move.l	#319,d0
	moveq	#54,d1
	jsr	-$f0(a6)	;move (set gfx-cursor)

	move.l	(a7)+,a1
	move.l	textpoint,a0
	tst.b	(a0)
	bne.b	noscrollrestart

	lea	text(pc),a0
	move.l	a0,textpoint
	
noscrollrestart:
	addq.l	#1,textpoint
	moveq	#1,d0
	jsr	-$3c(a6)	;print text

	lea	$61050+[55*44]+40,a1
	lea	5060(a1),a2
	moveq	#44,d6
	moveq	#7,d0
charcopyloop:
	move.b	(a1),d1
	sub.l	d6,a1
	move.b	d1,d2
	move.b	d1,d5
	moveq	#7,d4
	moveq	#0,d3
bitmoveloop:

	roxr.b	#1,d1
	roxr.l	#1,d3
	roxr.b	#1,d2
	roxr.l	#1,d3
	roxr.b	#1,d5
	roxr.l	#1,d3
	dbf	d4,bitmoveloop

	move.l	d3,(a2)
	sub.l	d6,a2
	move.l	d3,(a2)
	sub.l	d6,a2
	move.l	d3,(a2)
	sub.l	d6,a2
	dbf	d0,charcopyloop
rts

spirit:	dc.b	"A B Y S S "
scrollcount:	dc.w	16

copperlist:
dc.l	$01a60079

dc.l	$01440001
dc.l	$01460001

dc.l	$01002200	;bplcon0
dc.l	$01020034	;bplcon1
dc.l	$01040000	;bplcon2

dc.l	$00e00006	;bpl1pth
dc.l	$00e21050	;bpl1ptl

dc.l	$00e40006	;bpl2pth
dc.l	$00e6107c	;bpl2ptl

dc.l	$008e2a81	;diwstrt
dc.l	$00902ac1	;diwstop
dc.l	$00920038	;ddfstrt
dc.l	$009400d0	;ddfstop

dc.l	$01080004	;bpl1mod
dc.l	$010a0004	;bpl2mod


dc.l	$450ffffe
dc.l	$01800b04
dc.l	$460ffffe
dc.l	$01800200

dc.l	$01820f00
dc.l	$01840fff

dc.l	$490ffffe
dc.l	$01860660
dc.l	$4b0ffffe
dc.l	$01860770
dc.l	$4d0ffffe
dc.l	$01860990
dc.l	$4f0ffffe
dc.l	$01860bb0
dc.l	$510ffffe
dc.l	$01860dd0

dc.l	$540ffffe
dc.l	$01860ff0

dc.l	$580ffffe
dc.l	$01860dd0
dc.l	$5b0ffffe
dc.l	$01860bb0
dc.l	$5d0ffffe
dc.l	$01860990
dc.l	$5f0ffffe
dc.l	$01860770
dc.l	$610ffffe
dc.l	$01860660


dc.l	$620ffffe
dc.l	$01800b04
dc.l	$630ffffe
dc.l	$01800000

dc.l	$700ffffe
dc.l	$0180000f
dc.l	$710ffffe
dc.l	$01800002

dc.l	$01820804


coppercut:
dc.l	$fe0ffffe
dc.l	$0180000f
dc.l	$ff0ffffe
dc.l	$01800000

dc.l	$fffffffe

copperlistend:
sign:
;dc.b	"MOON"
dc.l	$456e798c
colcodes:
dc.w	$0666
dc.w	$0777
dc.w	$0999
dc.w	$0bbb
dc.w	$0ddd

dc.w	$0fff

dc.w	$0ddd
dc.w	$0bbb
dc.w	$0999
dc.w	$0777
dc.w	$0666






text:
dc.b	" ABYSS presents a new Issue of ETERNAL TERROR !  "
dc.b	"Disc done by SKINDIVER and DUKE of ABYSS "
dc.b	"Support this Pack with your Productions !     "
dc.b	0
gfxname:	dc.b	"graphics.library",0
b:
