;------------------------------------------------------------------------
;-                                                                      -
;-                             ZOOMSCROLLER                             -
;-                            --------------                            -
;-                                                                      -
;-                                                                      -
;- coded in july 1992 by Moon, released in august 1993 by ABYSS         -
;------------------------------------------------------------------------
textpoint=$7c006
clistpoint=$7c00c
clistwait=$7c00e
clistadd=$7c010
fontadress=$7c018
copcalcloop=$7c01c
oldopenlibrary=-408
planeadr=$20000

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
OpenFont=-72


move.l	4,a6		;this is only to test from the assembler
			;use ASM-One coz this is the BEST one.
bra.b	start
a:
dc.b	"DOS",0
dc.l	0
dc.l	$00000370

start:
movem.l	a0-a6,-(a7)		;store some register
;--------------------------------------------------------------------
	lea	gfxname(pc),a1		;name gfxlib
	jsr	oldopenlibrary(a6)	;openlib
	move.l	d0,-(a7)
	
	move.l	d0,A6			; Use The GfxBase Pointer
	lea	textattr(pc),A0		; FontStructure Pointer To A0
	lea	fontname(pc),a1
	move.l	a1,(a0)			;insert fontname in textattrlist
	jsr	openfont(A6)
	move.l	d0,a1			;fontpointer
	move.l	34(A1),fontadress	;fontadress


	lea	planeadr,a0		;bitplane-adr...
	move.w	#[$14000]/4,d0
clrloop:
	clr.l	(a0)+			;lets clear some bytes
	dbf	d0,clrloop

	lea	$dff000,a4		;basis custom chips
	move.w	#%0000000110100000,$96(a4);sprite+copper+bitplane off
	lea	copanim(pc),a6
	move.l	(a6),$80(a4)
	move.b	#7,copcalcloop	;7lists,(no datareg free for loopcounter)

calcloop:
	move.l	(a6)+,a2		;adress of the copperlist
	moveq	#10,d5
	moveq	#0,d2
	move.b	(a6)+,d2
	sub.w	d2,d5
	move.b	(a6)+,d2
	add.w	d2,d2
	bsr.w	calc			;calc a copperlist (1 to 7)

	subq.b	#1,copcalcloop
	bne.b	calcloop


moveq	#4+1+1,d1
move.w	d1,clistadd
lea	text(pc),a0		;set textpointer to the start
move.l	a0,textpoint		;...of the scroller
move.l	#500,clistpoint


	move.w	#%1000001111000000,$96(a4);blitter+copper+bitplane on
scrollloop:
	cmp.b	#$ff,6(a4)
	bne.b	scrollloop

scrollloop2:
	cmp.b	#$20,6(a4)
	bne.b	scrollloop2

move.l	d1,-(a7)

	lea	planeadr+4*44,a3	;bitplane-adr...
	move.l	a3,bltdpth(a4)
	addq.l	#2,a3
	move.l	a3,bltapth(a4) 

	move.l	#%10001001111100000000000000000000,bltcon0(a4)
	clr.l	bltamod(a4)
	move.l	#%00000000011111111111111111111111,bltafwm(a4)
	move.w	#64*8+22,bltsize(a4)

	subq.l	#2,a3
	move.l	a3,d1
	lea	12*44(a3),a3

blitterwait1:
	btst	#14,dmaconr(a4)
	bne.b	blitterwait1


	move.l	a3,bltdpth(a4)
	move.l	d1,bltapth(a4) 

	move.l	#%00001001111100000000000000000000,bltcon0(a4)
	move.l	#$00ff00ff,bltafwm(a4)
	move.w	#64*176+1,bltsize(a4)

	add.l	#$10000,a3

	subq.w	#1,clistwait
	bne.b	nocopanim
	move.w	#3,clistwait

	move.w	clistpoint,d7
	add.w	clistadd,d7
	move.w	d7,clistpoint
	bne.b	nozero
	neg.w	clistadd
	move.w	#300,clistwait
nozero:
	cmp.w	#24+6+6,d7
	bne.b	nozero2
	neg.w	clistadd
	move.w	#300,clistwait
nozero2:
	lea	copanim(pc),a5
	move.l	0(a5,d7.w),$80(a4)
nocopanim:

blitterwait2:
	btst	#14,dmaconr(a4)
	bne.b	blitterwait2

	move.l	a3,bltdpth(a4)
	move.l	d1,bltapth(a4) 
	move.l	#$ff00ff00,bltafwm(a4)
	move.w	#64*176+1,bltsize(a4)

blitterwait3:
	btst	#14,dmaconr(a4)
	bne.b	blitterwait3

	move.l	(a7)+,d1
	dbf	d1,scrollloop
	bsr.b	setzoom
	moveq	#3,d1

	btst	#6,$bfe001		;hey mousie, how are you
	bne.w	scrollloop		;still sleeping??

;	move.l	gfxbase,a6
	move.l	(a7)+,a6
	move.l	$26(a6),$80(a4)		;systemcopperlist
;--------------------------------------------------------------------
	movem.l	(a7)+,a0-a6		;restore some register
	lea	gfxname+5(pc),a1	;change graphics.library
	move.w	#"do",(a1)		;to          dos.library
;if you use my idea to improve your program be sure that
;the name "graphics.library" begins on an ODD-ADRESS!
;otherwise the move.w	#"do",(a1) will not work!
	jsr	findresident(a6)	;is doslib resident...
	move.l	d0,a0			;...or are some...
	move.l	22(a0),a0		;...chips broken???
	moveq	#0,d0			;no fault (i hope)
	rts


setzoom:
	move.l	textpoint,a0		;adress of next ASCII-code
	tst.b	(a0)			;zero? (restart?)
	bne.b	noscrollrestart		;no-then print it

	lea	text(pc),a0		;startadress scrolltext
	move.l	a0,textpoint		;nextchar is first char (restart)

noscrollrestart:
	addq.l	#1,textpoint		;nextchar =thischar+1

	lea	planeadr+4*44+40,a3	;bitplane-adr. of the char
	moveq	#0,d0
	move.b	(a0),d0			;aktual char of the scroller
	move.l	fontadress,a0		;basisadr. of topazfont in ROM
	lea	-32(a0,d0.w),a0		;basis+charnumber-32offset

	moveq	#8,d0			;1 char=9 lines
zoomloop:
	move.b	(a0),d1			;get a byte of the char
	move.b	d1,d2	;the routine will zoom the x-lenght of...
	move.b	d1,d3	;...the char with faktor 4, so i...
	move.b	d1,d4	;...need 3 copys of the charbyte. (d1,d2,d3,d4)

	moveq	#7,d5			;1 byte = 8 bit (yes it is!)
zoomloop2:
	roxr.b	#1,d1			;zoo
	roxr.l	#1,d6			;   oo
	roxr.b	#1,d2			;     oo
	roxr.l	#1,d6			;       o
	roxr.b	#1,d3			;        o
	roxr.l	#1,d6			;         oo
	roxr.b	#1,d4			;           oo
	roxr.l	#1,d6			;             oom
	dbf	d5,zoomloop2		;next bit

	move.l	d6,(a3)	;write zoomed byte (now longword) in bitmap
	lea	$c0(a0),a0		;$c0 is offset of the romfont
	lea	44(a3),a3		;44 is modulo of the bitplane

	dbf	d0,zoomloop		;next byte
	rts

calc:
	lea	copperlist(pc),a0
	moveq	#[copperlistend-copperlist]/4,d0

coppercopy:
	move.l	(a0)+,(a2)+
	dbf	d0,coppercopy

	move.l	a2,a5	;save copperlistpoint
	lea	planeadr+[[16-3]*44],a3	;bitplane-adr...

	move.w	#$3431,d1
	move.w	#$e2,d0
	move.w	#269,d3
	moveq	#4,d4

line2:
	move.w	d1,(a2)+
	move.w	#$fffe,(a2)+
	moveq	#39,d6
line:
	move.w	d0,(a2)+	;bpl1ptl
	move.w	a3,(a2)+	;planeadr lo
	add.w	d4,d0		;next reg
	neg.w	d4		;swap	regadd
	dbf	d6,line
	move.w	d1,(a2)+	;wait right border
	move.b	#$df,-1(a2)	;very right-kills coperror on line255/256
	move.w	#-2,(a2)+

	add.w	#$100,d1	;next line
	dbf	d3,line2
	;now list ready but empty
	move.l	#-2,(a2)	;last coppercommand

	moveq	#39,d0	;x-loop	(40 bytes per line)
setcop1:
	move.w	d2,d1
	subq.w	#1,d1
	moveq	#8+3,d3
	swap	d3
	divu	d2,d3
	and.l	#$0000ffff,d3
	moveq	#0,d4
setcop2:
	moveq	#7+3,d6
	swap	d4
	sub.w	d4,d6
	swap	d4

	mulu	#44,d6	;*44 (screen is 44 bytes / line)
	sub.l	d0,d6	;sub x-value of koord. (direction right to left)
	lea	40(a3,d6.l),a0

	move.l	d1,d6	;copy of y-loopcounter
	mulu	#(40*4+8),d6	;40cmoves/line,4bytes/cmove,4bytes cwait
	moveq	#39,d7	;calculate direction...
	sub.l	d0,d7	;...to right-to-left
	lsl.l	#2,d7	;x*4= ccommand-offset
	add.l	d6,d7	;+y offset
	lea	6(a5,d7.l),a1;	adress of the coppercomand
	move.w	a0,(a1)

	add.l	d3,d4
	dbf 	d1,setcop2
	add.w	d5,d2
	move.w	d2,$180(a4)
	dbf 	d0,setcop1
;sorry, bad documented, but i was a little bit 
;drunken as i coded this copper-routine, and i
;think you must drink something to understand this code, too
rts

sign:
dc.l	$7c0cbe2f
;dc.b	"MOON"

copanim:
dc.l	$24000
dc.b	10-6,[22]/2

dc.l	$34000
dc.b	10-4,[44*1]/2

dc.l	$40000
dc.b	10-2,[44*2]/2

dc.l	$4c000
dc.b	10-0,[44*3]/2

dc.l	$58000
dc.b	10-[-2],[44*4+4]/2

dc.l	$64000
dc.b	10-[-4],[44*5+4]/2

dc.l	$70000
dc.b	10-[-6],[44*6+4]/2


textattr:	DC.L	0
		DC.W	8
		DC.B	0
		DC.B	0
fontname:	DC.B	"topaz.font",0,0

copperlist:
	dc.l	$01002200	;bplcon0
	dc.l	$01020088	;bplcon1
	dc.l	$00e00002	;bpl1pth
	dc.l	$00e21000	;bpl1ptl
	dc.l	$00e40003	;bpl2pth
	dc.l	$00e61000	;bpl2ptl
	dc.l	$008e2a81	;diwstrt
	dc.l	$00902ac1	;diwstop
	dc.l	$00920038	;ddfstrt
	dc.l	$009400d0	;ddfstop
	dc.l	$01080004	;bpl1mod
	dc.l	$010a0004	;bpl2mod
	dc.l	$01800132	;col #0
	dc.l	$01820554	;#1
	dc.l	$01840554
	
		;#2
copperlistend:


text:
dc.b	"ABYSS presents a new Issue of ETERNAL TERROR! "
dc.b	"Disc done by TOXIC. "
dc.b	"Dont forget to support us with your Productions! "
dc.b	"Bootcode by MOON. "
dc.b	"Greez 2 all contacts. "
dc.b	"Press left Mousebutton.          ",0
gfxname:	dc.b	"graphics.library",0
b:
