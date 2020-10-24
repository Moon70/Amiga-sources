;***************************************************
;*                                                 *
;*                      Part 6                     *
;*                                                 *
;* Part 6 of Megademo                              *
;*                                                 *
;* code by Moon/Gallows                            *
;***************************************************
>extern "data/font",font
>extern "data/sinusx",sinusx
>extern "data/sinusy",sinusy
>extern "data/blobdat",anim0a
>extern "data/a1",anim1a
>extern "data/b1",anim1b
>extern "data/a2",anim2a
>extern "data/b2",anim2b
>extern "data/a4",anim4a
>extern "data/b4",anim4b
>extern "data/mod.discotime10",mt_data

planesize=44*278
execbase=4
forbid=-132
permit=-138
startlist=38
openlibrary=-30-522
allocmem=-30-168
freemem=-30-180

dmacon=$096
dmaconr=$2
intena=$09a
intreq=$09c
intenar=$01c
intreqr=$01e
ciaapra=$bfe001

;spriteoffsets
spr0pth=$120
spr0ptl=$122
spr1pth=$124
spr1ptl=$126
spr2pth=$128
spr2ptl=$12a
spr3pth=$12c
spr3ptl=$12e
spr4pth=$130
spr4ptl=$132
spr5pth=$134
spr5ptl=$136
spr6pth=$138
spr6ptl=$13a
spr7pth=$13c
spr7ptl=$13e
spr0pos=$140
spr0ctl=$142
spr0data=$144
spr0datb=$146
spr1pos=$148
spr1ctl=$14a
spr1data=$14c
spr1datb=$14e
spr2pos=$150
spr2ctl=$152
spr2data=$154
spr2datb=$156
spr3pos=$158
spr3ctl=$15a
spr3data=$15c
spr3datb=$15e
spr4pos=$160
spr4ctl=$162
spr4data=$164
spr4datb=$166
spr5pos=$168
spr5ctl=$16a
spr5data=$16c
spr5datb=$16e
spr6pos=$170
spr6ctl=$172
spr6data=$174
spr6datb=$176
spr7pos=$178
spr7ctl=$17a
spr7data=$17c
spr7datb=$17e

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


;bitplaneoffsets
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


start:
	move.l	execbase,a6
	move.l	#$dff000,a5
	jsr	forbid(a6)
	move.l	#$bf20,d0		;44*278*4
	move.l	#$10002,d1		;oh,its the chipram
	jsr	allocmem(a6)		
	move.l	d0,planes1
	beq	noplane12

	move.l	#$bf20,d0		;44*278*4
	move.l	#$10002,d1		;oh,its the chipram
	jsr	allocmem(a6)		
	move.l	d0,planes2
	beq noplane2

	move.w	#%0000001111100000,dmacon(a5)
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#%0100001000000000,bplcon0(a5)
	move.w	#$0000,bplcon1(a5)
	move.w	#$0000,bplcon2(a5)
	move.w	#136,bpl1mod(a5)
	move.w	#136,bpl2mod(a5)
	jsr	switchplane
	jsr	switchcopper
	move.l	#$fffffffe,copperlist

	move.l	copperlist,cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000001111100000,dmacon(a5)
	jsr	mt_init
	jsr	intstart
	move.w	#$0000,$dff180
	move.w	#$000f,$dff182
	move.w	#$000d,$dff184
	move.w	#$000b,$dff186

	move.w	#$0009,$dff188
	move.w	#$0007,$dff18a
	move.w	#$0005,$dff18c
	move.w	#$0003,$dff18e



	move.w	#$0567,$dff190
	move.w	#$0309,$dff192
	move.w	#$0561,$dff194
	move.w	#$038a,$dff196

	move.w	#$0061,$dff198
	move.w	#$0158,$dff19a
	move.w	#$033d,$dff19c
	move.w	#$0133,$dff19e


	move.w	#$0600,$dff1a2
	move.w	#$0900,$dff1a4
	move.w	#$0c00,$dff1a6
	move.w	#$0f00,$dff1a8
	move.w	#$0c00,$dff1aa
	move.w	#$0900,$dff1ac
	move.w	#$0600,$dff1ae

	move.w	#$0000,$dff1b0
	move.w	#$0660,$dff1b2
	move.w	#$0990,$dff1b4
	move.w	#$0cc0,$dff1b6
	move.w	#$0ff0,$dff1b8
	move.w	#$0cc0,$dff1ba
	move.w	#$0990,$dff1bc
	move.w	#$0660,$dff1be

wait:	btst	#6,ciaapra
	bne.S	wait
back:
	jsr	intstop

	jsr	mt_end
	move.l	execbase,a6
	move.l	#$dff000,a5

	move.l	#$bf20,d0
	move.l	planes2,a1
	jsr	freemem(a6)		

noplane2:
	move.l	#$bf20,d0
	move.l	planes1,a1
	jsr	freemem(a6)		

noplane12:
	move.l	#grname,a1
	clr.l	d0
	jsr	openlibrary(a6)
	move.l	d0,a4
	move.l	startlist(a4),cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000001111100000,dmacon(a5)
	jsr	permit(a6)
	clr.l	d0
	rts

intstart:
	move.l	#$dff000,a5
	move.w	#%0000000001100000,intena(a5)
	move.l	$6c,oldint
	move.l	#introut,$6c
	move.w	#%1100000000100000,intena(a5)
	rts

introut:
	btst	#5,intreqr
	bne	intback
	move.l	#$dff000,a5
	move.l	otherplane,d0
	move.l	#44,d1
	move.l	d0,bpl1pth(a5)
	add.l	d1,d0
	move.l	d0,bpl2pth(a5)
	add.l	d1,d0
	move.l	d0,bpl3pth(a5)
	add.l	d1,d0
	move.l	d0,bpl4pth(a5)
	move.l	#spritelist1,spr0pth(a5)
	move.l	#spritelist2,spr1pth(a5)
	move.l	#spritelist3,spr2pth(a5)
	move.l	#spritelist4,spr3pth(a5)
	move.l	#endoflist,spr4pth(a5)
	move.l	#endoflist,spr5pth(a5)
	move.l	#endoflist,spr6pth(a5)
	move.l	#endoflist,spr7pth(a5)
	move.l	copperlist,cop1lch(a5)
	clr.w	copjmp1(a5)

	jsr	commander		;whats up ??

	btst	#0,aktrout
	beq	nextrout1
	jsr	mt_music		;music everytime
	jsr	sprites			;also the nice...
	jsr	coppercopy		;		...euqalizer

nextrout1:
	btst	#1,aktrout
	beq	nextrout2
	jsr	plane1cls
	jsr	movebobs
	jsr	animator
bltwait:	btst	#14,dmaconr(a5)
		bne	bltwait
		jsr	drawbobs
		jsr	switchplane

nextrout2:
	btst	#4,aktrout
	beq	nextrout3
	jsr	clsplane1b
	jsr	movebobs
	jsr	drawline
	jsr	switchplane
	bra	intback

nextrout3:
	btst	#5,aktrout
	beq	nextrout4
	jsr	clsplane1b
	jsr	movebobs
	jsr	drawline2
	jsr	switchplane
	bra	intback

nextrout4:
	btst	#6,aktrout
	beq	nextrout5
	jsr	clsplane1b
	jsr	movebobs
	jsr	drawline3
	jsr	switchplane
	bra	intback

nextrout5:
	btst	#7,aktrout
	beq	nextrout6
	jsr	clsplane1b
	jsr	movebobs
	jsr	drawline4
	jsr	switchplane
	bra	intback

nextrout6:

intback:
	move.l	#$dff000,a5
	move.w	#%0000000001100000,intreq(a5)
	rte

intstop:
move.l	oldint,$6c
rts

oldint:		dc.l	0
planes1:	dc.l	0
planes2:	dc.l	0


grname:		dc.b	"graphics.library",0
even

currentplane:	dc.l	0
otherplane:	dc.l	0
switchmark:	dc.w	0
switchmarkc:	dc.w	0

switchplane:
	move.w	switchmark,d0
	beq	onetotwo
	move.w	#0,switchmark
	move.l	planes1,currentplane
	move.l	planes2,otherplane
	rts
onetotwo:
	move.w	#1,switchmark
	move.l	planes2,currentplane
	move.l	planes1,otherplane
	rts

switchcopper:
	move.w	switchmarkc,d0
	beq	onetotwoc
	move.w	#0,switchmarkc
	move.l	#copperlist1,copperlist
	rts
onetotwoc:
	move.w	#1,switchmarkc
	move.l	#copperlist2,copperlist
	rts

sinusx:		blk.l	180,0
sinusy:		blk.l	180,0

sinusend:

clsplane1:	;loescht 1. bitplane,slow
	move.l	currentplane,a0
	move.l	#277,d0	;zeilen
	moveq	#0,d2

clsplane1l1:
	move.l	#10,d1	;spalten
	clsplane1l2:
	move.l	d2,(a0)+
	dbf	d1,clsplane1l2
	add.l	#132,a0
	dbf	d0,clsplane1l1
	rts

plane1cls:
	move.l	#$dff000,a5
bltwaitq3:	btst	#14,dmaconr(a5)
	bne	bltwaitq3

	move.w	#12,bltdmod(a5)		;d-modulo=0
	move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	currentplane,a0
	add.l	#176*24+4,a0
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#$6890,bltsize(a5)	;h=250,l=21 (start blitter);
;	rts
planecls2:

	move.l	#0,d0
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,a0
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	currentplane,a4
;	movem.l	(a4),d0-d3/a0-a3
	add.l	#176*24+4,a4
	add.l	#44*418,a4
	move.l	#417,d4
	move.l	#44,d5
clearloop:
	movem.l	d0-d3/a0-a3,(a4)
	add.l	d5,a4
	dbf	d4,clearloop
	rts

clsplane1b:
	move.l	#$dff000,a5
bltwaitw3:	btst	#14,dmaconr(a5)
	bne	bltwaitw3
	move.w	#144,bltdmod(a5)	;12 d-modulo=0
	move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	currentplane,a0
	add.l	#176*24+4,a0
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#$3450,bltsize(a5)	;h=250,l=21 (start blitter);
	rts

drawbobs:	
	move.l	#$dff000,a5
	move.w	#0,bltamod(a5)		;source modulo=0
	move.w	#0,bltbmod(a5)
	move.w	#38,bltdmod(a5)		;dest modulo=plane-4 (44-4)
	move.w	#38,bltcmod(a5)
	move.w	sdata,d0	;number of bobs
	move.l	#koord,a1
	sub.l	d6,d6
	move.w	dbcounter,d6
	sub.w	#1,d6
drawbobl1:
	add.w	#1,d6
	cmp.w	animlenght,d6
	bne	noresanim2
	move.w	#0,d6
noresanim2:
	move.w	d6,d5

	mulu	#768,d5
	move.l	thisboba,a2
	move.l	thisbobb,a3
	add.l	d5,a2
	add.l	d5,a3
	
	move.w	(a1)+,d1	;x
	move.w	d1,d3
	lsr.w	#4,d1
	and.l	#%00000000000000000000000000001111,d3
	swap	d3
	move.l	d3,d4
	lsr.l	#4,d4

	lsl.l	#6,d3
	lsl.l	#6,d3
	or.l	#%00001111111100100000000000000000,d3
	or.l	d4,d3

	move.w	(a1)+,d2	;y
	mulu	#176,d2

	move.l	currentplane,a0
	add.l	#176*24+4,a0
	add.l	d1,a0
	add.l	d1,a0
	add.l	d2,a0

bltwaitr3:	btst	#14,dmaconr(a5)
	bne	bltwaitr3
	
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	a0,bltcpth(a5)
	move.l	a2,bltapth(a5)	;source=bobdata
	move.l	a3,bltbpth(a5)	;data

	move.l	d3,bltcon0(a5)	;bltcon0&bltcon1

	move.l		#%11111111111111110000000000000000,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#$2003,bltsize(a5)	;h=250,l=21 (start blitter);
	dbf	d0,drawbobl1

	rts


rts


sdata:	dc.w	71	;bobszahl-1
koord:
blk.w	1000,0

position:
dc.w	0,0,0,0		;current pos
dc.w	4		;speed phase x1
dc.w	4		;speed phase y1
dc.w	6		;speed phase x2
dc.w	4		;speed phase y2

dc.w	50		;differenz phase x1
dc.w	50		;differenz phase y1
dc.w	60		;differenz phase x2
dc.w	40		;differenz phase y2


movebobs:
	move.l	#$dff000,a5
	move.w	sdata,d0	;number of bobs
	addq	#1,d0
	move.l	#position,a0
	move.l	#sinusx,a1
	move.l	#koord,a2
	move.l	#sinusy,a3
	move.w	#720,d6
	move.l	#0,d1
	move.l	#0,d2
	move.l	#0,d3
	move.l	#0,d4


move.w	0(a0),d1		;x1 current x-pos in sinus
add.w	8(a0),d1		;add speed
cmp.w	d6,d1
blt.S	movebobsw1
sub.w	d6,d1
movebobsw1:
move.w	d1,(a0)

move.w	2(a0),d2		;y1 current x-pos in sinus
add.w	10(a0),d2		;add speed
cmp.w	d6,d2
blt.S	movebobsw2
sub.w	d6,d2
movebobsw2:
move.w	d2,2(a0)

move.w	4(a0),d3		;x2 current x-pos in sinus
add.w	12(a0),d3	;add speed
cmp.w	d6,d3
blt.S	movebobsw3
sub.w	d6,d3
movebobsw3:
move.w	d3,4(a0)

move.w	6(a0),d4		;y2 current x-pos in sinus
add.w	14(a0),d4	;add speed
cmp.w	d6,d4
blt.S	movebobsw4
sub.w	d6,d4
movebobsw4:
move.w	d4,6(a0)


movebobl1:


move.w	0(a1,d1),d5	;d5=x1
add.w	0(a1,d3),d5	;d5=x1+x2
move.w	d5,(a2)+

move.w	0(a3,d2),d5	;d5=y1
add.w	0(a3,d4),d5	;d5=y1+y2
move.w	d5,(a2)+


add.w	16(a0),d1		;add speed
cmp.w	d6,d1
blt.S	movebobsw5
sub.w	d6,d1
movebobsw5:

add.w	18(a0),d2		;add speed
cmp.w	d6,d2
blt.S	movebobsw6
sub.w	d6,d2
movebobsw6:

add.w	20(a0),d3	;add speed
cmp.w	d6,d3
blt.S	movebobsw7
sub.w	d6,d3
movebobsw7:

add.w	22(a0),d4	;add speed
cmp.w	d6,d4
blt.S	movebobsw8
sub.w	d6,d4
movebobsw8:


dbf	d0,movebobl1
rts

;***********************************************************
copsinoffset1:	dc.w	0
copsinoffset2:	dc.w	0
copsinoffset3:	dc.w	0
copperlist:	dc.l	0
copperlist1:	blk.l	2400,0
copperlist2:	blk.l	2400,0
coppercopy:
jsr	switchcopper

move.l	copperlist,a0
move.l	#blau,a1		;farbadresse
move.w	#150,d0			;zeilenanzahl
move.w	#$2941,d2		;706dstartfeld
move.w	#$0100,d3		;nextline
move.l	#copsinbig,a4
move.w	#$0180,d6

;first let set the upper equalizer...
move.w	#12,d1	;equalizer=16 lines
move.w	equal1,d4
subq	#4,d4
cmp.w	#16,d4
bne	eq1end
addq	#4,d4
eq1end:
move.w	d4,equal1
eq1spalte:
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+

move.w	d6,(a0)+		;the color
move.w	(a1)+,(a0)+
move.w	d4,d7
add.w	d2,d7
move.w	d7,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+

move.w	d6,(a0)+		;the color
move.w	#0,(a0)+


add.w	d3,d2
dbf d1,eq1spalte
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+
move.w	d6,(a0)+
move.w	#0,(a0)+



btst	#2,aktrout
beq	notextcopper
jsr	textcopper
jmp	nocopperdemo

notextcopper:
btst	#3,aktrout
beq	nocopperdemo


move.w	#$4079,d2		;706dstartfeld
move.l	#copcolor,a1		;farbadresse

move.w	copsinoffset1,d7
addq.w	#4,d7
cmp.w	#720,d7
blt.S	norestart1
sub.w	#720,d7
norestart1:
move.w	d7,copsinoffset1

move.w	copsinoffset2,d4
add.w	#10,d4
cmp.w	#720,d4
blt.S	norestart2
sub.w	#720,d4
norestart2:
move.w	d4,copsinoffset2


lineloop:
add.w	#4,d4
cmp.w	#720,d4
blt.S	norestart3
sub.w	#720,d4
norestart3:

move.w	d2,d5
add.w	0(a4,d4),d5
move.w	d5,(a0)+		;auf startfeld warten

move.w	#$fffe,(a0)+
move.l	#copsinlit,a3
add.w	d7,a3

move.l	a1,a2
move.w	#12,d1			;32 felder/zeile

spaltenloop:
move.w	d6,(a0)+
move.w	(a2),(a0)+
add.w	(a3)+,a2
dbf d1,spaltenloop

move.l	#$01800000,(a0)+
add.w	d3,d2
addq.w	#2,a1
dbf d0,lineloop

nocopperdemo:
;now the other equalizer...
move.w	#$ffe1,(a0)+		;first wait for highline
move.w	#$fffe,(a0)+


move.l	#rot,a1		;farbadresse
move.w	#$15dd,d2		;706dstartfeld
move.w	#$0180,d6

move.w	#12,d1	;equalizer=16 lines
move.w	equal2,d4
subq	#4,d4
cmp.w	#16,d4
bne	eq2end
add	#4,d4
eq2end:
move.w	d4,equal2
eq2spalte:
move.w	d2,d7
sub.w	d4,d7
move.w	d7,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+


move.w	d6,(a0)+		;the color
move.w	(a1)+,(a0)+
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+

move.w	d6,(a0)+		;the color
move.w	#0,(a0)+

add.w	d3,d2
dbf d1,eq2spalte
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+
move.w	d6,(a0)+
move.w	#0,(a0)+





move.l	#$fffffffe,(a0)+
rts
texcol1:
         dc.w $022,$044,$066
         dc.w $088,$099,$0aa,$0bb,$0cc,$0dd,$0ee,$0FF
;blk.w	3,0
         dc.w $020,$040,$060
         dc.w $080,$090,$0A0,$0B0,$0C0,$0D0,$0E0,$0F0
;blk.w	3,0
         dc.w $002,$004,$006
         dc.w $008,$009,$00A,$00B,$00C,$00D,$00E,$00F
;blk.w	3,0
         dc.w $200,$400,$600
         dc.w $800,$900,$A00,$B00,$C00,$D00,$E00,$F00
;blk.w	3,0
texpos1:
sinus:
dc.w 8,9,10,11,12,13,14,14,15,15,15,15,15,15,15,14,14,13,12,11,10
dc.w 9,8,7,6,5,4,3,2,1,1,0,0,0,0,0,0,0,1,2,2,3,4,5,7

textcopper:
move.w	#$470f,d2		;706dstartfeld
move.w	#$0182,d6

move.l	#5,d1
textcoplineloop:
move.l	#texcol1,a1		;farbadresse
move.l	#texpos1,a2
move.l	#17,d0
textcoploop:
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+
move.w	d6,(a0)+		;the color
move.w	(a1)+,(a0)+
move.w	#$102,(a0)+
move.w	(a2)+,(a0)+

add.w	d3,d2
dbf d0,textcoploop
move.w	d2,(a0)+		;auf startfeld warten
move.w	#$fffe,(a0)+
move.w	d6,(a0)+		;the color
move.w	#0,(a0)+
add.w	#$0e00,d2
dbf d1,textcoplineloop



move.w	switchmarkc,d0
beq thisnot
move.l	#texcol1,a1
move.l	#43,d0
move.w	(a1),d2
colzyk:
move.w	2(a1),(a1)+
dbf	d0,colzyk
move.w	d2,-(a1)



move.l	#texpos1,a1
move.l	#44,d0
move.w	(a1),d2
poszyk:
move.w	2(a1),(a1)+
dbf	d0,poszyk
move.w	d2,-(a1)

thisnot:
rts




;blk.w	100,0
;blk.w	100,0
dc.w	$0fff
blk.w	80,0

         dc.w $100,$100,$200,$300,$400,$500,$600,$700
         dc.w $800,$900,$A00,$B00,$C00,$D00,$E00,$F00
         dc.w $F00,$E00,$D00,$C00,$B00,$A00,$900,$800
         dc.w $700,$600,$500,$400,$300,$200,$100,$100


copcolor:
         dc.w $000,$000,$000,$001,$001,$001,$002,$002
         dc.w $002,$003,$003,$003,$004,$004,$004,$005
         dc.w $005,$005,$006,$006,$006,$007,$007,$007
         dc.w $008,$008,$008,$009,$009,$009,$00A,$00A
         dc.w $00A,$00B,$00B,$00B,$00C,$00C,$00C,$00D
         dc.w $00D,$00D,$00E,$00E,$00E,$00F,$00F,$00F
         dc.w $00F,$00F,$00F,$00E,$00E,$00E,$00D,$00D
         dc.w $00D,$00C,$00C,$00C,$00B,$00B,$00B,$00A
         dc.w $00A,$00A,$009,$009,$009,$008,$008,$008
         dc.w $007,$007,$007,$006,$006,$006,$005,$005
         dc.w $005,$004,$004,$004,$003,$003,$003,$002
         dc.w $002,$002,$001,$001,$001,$000,$000,$000


         dc.w $100,$100,$200,$300,$400,$500,$600,$700
         dc.w $800,$900,$A00,$B00,$C00,$D00,$E00,$F00
         dc.w $F00,$E00,$D00,$C00,$B00,$A00,$900,$800
         dc.w $700,$600,$500,$400,$300,$200,$100,$100

blk.w	120,0
dc.w	$0fff
;blk.w	100,0

copsinlit:
dc.w  0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4
dc.w  4, 6, 6, 6, 6, 6, 6, 6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 10, 10, 10
dc.w  10, 10, 10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12
dc.w  12, 12, 12, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  16, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 12, 12
dc.w  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 10
dc.w  10, 10, 10, 10, 8, 8, 8, 8, 8, 8, 8, 8, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0
dc.w  0, 0,-2,-2,-2,-2,-2,-2,-2,-2,-4,-4,-4,-4,-4,-4,-4,-6,-6,-6,-6
dc.w -6,-6,-6,-6,-8,-8,-8,-8,-8,-8,-8,-10,-10,-10,-10,-10,-10,-10
dc.w -10,-10,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-14,-14,-14,-14
dc.w -14,-14,-14,-14,-14,-14,-14,-14,-14,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-12
dc.w -12,-12,-12,-12,-12,-12,-12,-12,-12,-10,-10,-10,-10,-10,-10,-10
dc.w -10,-8,-8,-8,-8,-8,-8,-8,-8,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -4,-4,-4,-4,-2,-2,-2,-2,-2,-2,-2, 0

dc.w  0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4
dc.w  4, 6, 6, 6, 6, 6, 6, 6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 10, 10, 10
dc.w  10, 10, 10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12
dc.w  12, 12, 12, 12, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  16, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14
dc.w  14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 12, 12
dc.w  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 10
dc.w  10, 10, 10, 10, 8, 8, 8, 8, 8, 8, 8, 8, 6, 6, 6, 6, 6, 6, 6
dc.w  6, 4, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0
dc.w  0, 0,-2,-2,-2,-2,-2,-2,-2,-2,-4,-4,-4,-4,-4,-4,-4,-6,-6,-6,-6
dc.w -6,-6,-6,-6,-8,-8,-8,-8,-8,-8,-8,-10,-10,-10,-10,-10,-10,-10
dc.w -10,-10,-12,-12,-12,-12,-12,-12,-12,-12,-12,-12,-14,-14,-14,-14
dc.w -14,-14,-14,-14,-14,-14,-14,-14,-14,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16,-16
dc.w -16,-16,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-12
dc.w -12,-12,-12,-12,-12,-12,-12,-12,-12,-10,-10,-10,-10,-10,-10,-10
dc.w -10,-8,-8,-8,-8,-8,-8,-8,-8,-6,-6,-6,-6,-6,-6,-6,-6,-4,-4,-4
dc.w -4,-4,-4,-4,-2,-2,-2,-2,-2,-2,-2, 0

copsinbig:
dc.w  0, 0, 2, 2, 2, 4, 4, 4, 6, 6, 6, 8, 8, 8, 10, 10, 10, 12, 12
dc.w  12, 14, 14, 14, 16, 16, 16, 18, 18, 18, 20, 20, 20, 20, 22, 22
dc.w  22, 24, 24, 24, 24, 26, 26, 26, 26, 28, 28, 28, 28, 30, 30, 30
dc.w  30, 30, 32, 32, 32, 32, 32, 34, 34, 34, 34, 34, 34, 36, 36, 36
dc.w  36, 36, 36, 36, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38
dc.w  38, 38, 38, 38, 38, 38, 40, 38, 38, 38, 38, 38, 38, 38, 38, 38
dc.w  38, 38, 38, 38, 38, 38, 38, 38, 38, 36, 36, 36, 36, 36, 36, 36
dc.w  34, 34, 34, 34, 34, 34, 32, 32, 32, 32, 32, 30, 30, 30, 30, 30
dc.w  28, 28, 28, 28, 26, 26, 26, 26, 24, 24, 24, 24, 22, 22, 22, 20
dc.w  20, 20, 18, 18, 18, 18, 16, 16, 16, 14, 14, 14, 12, 12, 12, 10
dc.w  10, 10, 8, 8, 8, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0,-2,-2,-2,-4
dc.w -4,-4,-6,-6,-6,-8,-8,-8,-10,-10,-10,-12,-12,-12,-14,-14,-14,-16
dc.w -16,-16,-18,-18,-18,-20,-20,-20,-22,-22,-22,-22,-24,-24,-24,-26
dc.w -26,-26,-26,-28,-28,-28,-28,-30,-30,-30,-30,-32,-32,-32,-32,-32
dc.w -34,-34,-34,-34,-34,-36,-36,-36,-36,-36,-36,-38,-38,-38,-38,-38
dc.w -38,-38,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40
dc.w -40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40
dc.w -40,-40,-40,-40,-40,-40,-40,-38,-38,-38,-38,-38,-38,-38,-36,-36
dc.w -36,-36,-36,-36,-34,-34,-34,-34,-34,-32,-32,-32,-32,-32,-30,-30
dc.w -30,-30,-28,-28,-28,-28,-26,-26,-26,-26,-24,-24,-24,-22,-22,-22
dc.w -20,-20,-20,-20,-18,-18,-18,-16,-16,-16,-14,-14,-14,-12,-12,-12
dc.w -10,-10,-10,-8,-8,-8,-6,-6,-6,-4,-4,-4,-2,-2, 0

dc.w  0, 0, 2, 2, 2, 4, 4, 4, 6, 6, 6, 8, 8, 8, 10, 10, 10, 12, 12
dc.w  12, 14, 14, 14, 16, 16, 16, 18, 18, 18, 20, 20, 20, 20, 22, 22
dc.w  22, 24, 24, 24, 24, 26, 26, 26, 26, 28, 28, 28, 28, 30, 30, 30
dc.w  30, 30, 32, 32, 32, 32, 32, 34, 34, 34, 34, 34, 34, 36, 36, 36
dc.w  36, 36, 36, 36, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38
dc.w  38, 38, 38, 38, 38, 38, 40, 38, 38, 38, 38, 38, 38, 38, 38, 38
dc.w  38, 38, 38, 38, 38, 38, 38, 38, 38, 36, 36, 36, 36, 36, 36, 36
dc.w  34, 34, 34, 34, 34, 34, 32, 32, 32, 32, 32, 30, 30, 30, 30, 30
dc.w  28, 28, 28, 28, 26, 26, 26, 26, 24, 24, 24, 24, 22, 22, 22, 20
dc.w  20, 20, 18, 18, 18, 18, 16, 16, 16, 14, 14, 14, 12, 12, 12, 10
dc.w  10, 10, 8, 8, 8, 6, 6, 6, 4, 4, 4, 2, 2, 2, 0, 0,-2,-2,-2,-4
dc.w -4,-4,-6,-6,-6,-8,-8,-8,-10,-10,-10,-12,-12,-12,-14,-14,-14,-16
dc.w -16,-16,-18,-18,-18,-20,-20,-20,-22,-22,-22,-22,-24,-24,-24,-26
dc.w -26,-26,-26,-28,-28,-28,-28,-30,-30,-30,-30,-32,-32,-32,-32,-32
dc.w -34,-34,-34,-34,-34,-36,-36,-36,-36,-36,-36,-38,-38,-38,-38,-38
dc.w -38,-38,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40
dc.w -40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40,-40
dc.w -40,-40,-40,-40,-40,-40,-40,-38,-38,-38,-38,-38,-38,-38,-36,-36
dc.w -36,-36,-36,-36,-34,-34,-34,-34,-34,-32,-32,-32,-32,-32,-30,-30
dc.w -30,-30,-28,-28,-28,-28,-26,-26,-26,-26,-24,-24,-24,-22,-22,-22
dc.w -20,-20,-20,-20,-18,-18,-18,-16,-16,-16,-14,-14,-14,-12,-12,-12
dc.w -10,-10,-10,-8,-8,-8,-6,-6,-6,-4,-4,-4,-2,-2, 0

equal1:	dc.w	20
equal2:	dc.w	20
equal3:	dc.w	4
equal4:	dc.w	59

rot:	dc.w	$060,$060,$090,$090,$0c0,$0c0,$0f0
	dc.w	$0c0,$0c0,$090,$090,$060,$060
blau:	dc.w	$006,$006,$009,$009,$00c,$00c,$00f
	dc.w	$00c,$00c,$009,$009,$006,$006


spritelist1:	dc.w	$3640,$2203
		blk.l	236,%00110011001100110000111100001111
endoflist:	dc.w	$0000,$0000

spritelist2:	dc.w	$3640,$2283
		blk.l	236,%00000000111111110000000000000000
		dc.w	$0000,$0000

spritelist3:	dc.w	$29d5,$1503
		blk.l	236,%00110011001100110000111100001111
		dc.w	$0000,$0000

spritelist4:	dc.w	$29d5,$1583
		blk.l	236,%00000000111111111111111111111111
		dc.w	$0000,$0000


sprites:
move.w	equal3,d0
sub.w	#4,d0
cmp	#0,d0
bne	noend3
add.w	#4,d0
noend3:
move.w	d0,equal3
lsl.w	#8,d0
move.w	#$fe40,d1
sub.w	d0,d1
move.w	d1,spritelist1
move.w	d1,spritelist2



move.w	equal4,d0
sub.w	#4,d0
cmp.w	#55,d0
bne	noend4
add.w	#4,d0
noend4:
move.w	d0,equal4
lsl.w	#8,d0
move.w	#$1503,d1
add.w	d0,d1
bcs	noueber
sub.w	#$0002,d1
noueber:
move.w	d1,spritelist3+2
add.w	#$80,d1
move.w	d1,spritelist4+2


rts

;blk.l	15000,0

font:	blk.l	1090,0


compoint:	dc.w	0	;pointer to current command
comwait:	dc.w	1	;countdown
commands:
dc.w	1,0		;music/coppercopy on

dc.w	500,20		;bob on
dc.w	2,2		;bob off
dc.w	1,3		;exe plane1cls


dc.w	1,7		;textcol on
dc.w	300,6		;prttext
dc.w	2,8		;textcol off
dc.w	1,9		;exe clsplane1

dc.w	1,7		;textcol on
dc.w	300,6		;prttext
dc.w	2,8		;textcol off
dc.w	1,9		;exe clsplane1

dc.w	500,18		;bob on
dc.w	2,2		;bob off
dc.w	1,3		;exe plane1cls

dc.w	500,10		;bobline on
dc.w	2,11		;bobline off
dc.w	1,9		;exe clsplane1


dc.w	500,12		;bobline on
dc.w	2,13		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	500,14		;bobline on
dc.w	2,15		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	500,16		;bobline on
dc.w	2,17		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	200,4		;copper on
dc.w	1,5		;copper off




dc.w	400,19		;bob on
dc.w	2,2		;bob off
dc.w	1,3		;exe plane1cls


;dc.w	800,21		;bob on
;dc.w	2,2		;bob off
;dc.w	1,3		;exe plane1cls




dc.w	300,1		;bob on
dc.w	1,2		;bob off
dc.w	1,3		;exe plane1cls

dc.w	1,7		;textcol on
dc.w	300,6		;prttext
dc.w	2,8		;textcol off
dc.w	1,9		;exe clsplane1

dc.w	500,10		;bobline on
dc.w	2,11		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	500,12		;bobline on
dc.w	2,13		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	500,14		;bobline on
dc.w	2,15		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	500,16		;bobline on
dc.w	2,17		;bobline off
dc.w	1,9		;exe clsplane1

dc.w	200,4		;copper on
dc.w	1,5		;copper off


dc.w	0		;restart commands



commander:
move.w	comwait,d0	;counter laden
beq	execom		;wenn 0 dann naechster befehl
subq.w	#1,d0		;wenn >0 dann minus 1
move.w	d0,comwait	;zurueckschreiben
rts			;das wars
execom:			;naechster befehl
move.l	#commands,a0	;commanddatenstart
moveq	#0,d0
move.w	compoint,d0	;offset akt command
move.w	0(a0,d0),d1	;load new counter
bne	nocomrest	;nocommandrestart
moveq	#0,d0		;restart-offset=0
move.w	0(a0,d0),d1	;load new counter
nocomrest:
move.w	d1,comwait	;write new counter
move.w	2(a0,d0),d1	;load new command
addq.w	#4,d0		;calc new offset
move.w	d0,compoint	;write back


com0:			;music/coppercopy-flag on
cmp.w	#0,d1
bne	com1
bset	#0,aktrout
rts

com1:			;bobroutine-flag on
cmp.w	#1,d1
bne	com2
bset	#1,aktrout
move.w	#9,sdata
move.w	#$0000,$dff180
move.w	#$000f,$dff182
move.w	#$000d,$dff184
move.w	#$000b,$dff186
move.w	#$0009,$dff188
move.w	#$0007,$dff18a
move.w	#$0005,$dff18c
move.w	#$0003,$dff18e
move.w	#$0567,$dff190
move.w	#$0309,$dff192
move.w	#$0561,$dff194
move.w	#$038a,$dff196
move.w	#$0061,$dff198
move.w	#$0158,$dff19a
move.w	#$033d,$dff19c
move.w	#$0133,$dff19e
move.l	#position,a0
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#6,(a0)+
move.w	#4,(a0)+
move.w	#6,(a0)+
move.w	#2,(a0)+
move.w	#50,(a0)+
move.w	#30,(a0)+
move.w	#50,(a0)+
move.w	#60,(a0)+


move.w	#5,dbtimer
move.w	#18,animlenght
move.w	#1,dbsleep
move.l	#anim0a,thisboba
move.l	#anim0b,thisbobb
rts


com2:			;bobroutine-flag off
cmp.w	#2,d1
bne	com3
bclr	#1,aktrout
rts

com3:			;execute plane1cls
cmp.w	#3,d1
bne	com4
jsr	plane1cls
jsr	switchplane
bltwait4:	btst	#14,dmaconr(a5)
		bne	bltwait4
jsr	plane1cls
rts

com4:			;copperroutine-flag on
cmp.w	#4,d1
bne	com5
bset	#3,aktrout
rts

com5:			;copperroutine-flag off
cmp.w	#5,d1
bne	com6
bclr	#3,aktrout
rts

com6:			;exe prttext
cmp.w	#6,d1
bne	com7
jsr	drawtext
rts

com7:			;textcol on
cmp.w	#7,d1
bne	com8
bset	#2,aktrout
rts

com8:			;textcol off
cmp.w	#8,d1
bne	com9
bclr	#2,aktrout
rts

com9:
cmp.w	#9,d1
bne	com10
jsr	switchplane
jsr	clsplane1
jsr	switchplane
move.w	#0,$dff102	;bplcon1
rts



com10:
cmp.w	#10,d1		;bobline on
bne	com11
bset	#4,aktrout
move.w	#100,sdata	
jsr	nextboblinedat
rts

com11:			;bobline off
cmp.w	#11,d1
bne	com12
bclr	#4,aktrout
rts


com12:
cmp.w	#12,d1		;bobline2 on
bne	com13
bset	#5,aktrout
move.w	#40,sdata	
jsr	nextboblinedat
rts

com13:			;bobline2 off
cmp.w	#13,d1
bne	com14
bclr	#5,aktrout
rts

com14:
cmp.w	#14,d1		;bobline3 on
bne	com15
bset	#6,aktrout
move.w	#45,sdata	
jsr	nextboblinedat
rts

com15:			;bobline3 off
cmp.w	#15,d1
bne	com16
bclr	#6,aktrout
rts


com16:
cmp.w	#16,d1		;bobline4 on
bne	com17
bset	#7,aktrout
move.w	#80,sdata	
jsr	nextboblinedat
rts

com17:			;bobline4 off
cmp.w	#17,d1
bne	com18
bclr	#7,aktrout
rts


com18:
cmp.w	#18,d1
bne	com19
bset	#1,aktrout
move.w	#9,sdata
move.w	#$0000,$dff180
move.w	#$0eca,$dff182
move.w	#$0333,$dff184
move.w	#$0444,$dff186
move.w	#$0006,$dff188
move.w	#$0307,$dff18a
move.w	#$0508,$dff18c
move.w	#$0608,$dff18e
move.w	#$0500,$dff190
move.w	#$0801,$dff192
move.w	#$0b02,$dff194
move.w	#$0e03,$dff196
move.w	#$0030,$dff198
move.w	#$0051,$dff19a
move.w	#$0082,$dff19c
move.w	#$00a4,$dff19e
move.l	#position,a0
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#4,(a0)+
move.w	#4,(a0)+
move.w	#6,(a0)+
move.w	#4,(a0)+
move.w	#50,(a0)+
move.w	#50,(a0)+
move.w	#60,(a0)+
move.w	#40,(a0)+

move.w	#8,dbtimer
move.w	#6,animlenght
move.w	#1,dbsleep
move.l	#anim1a,thisboba
move.l	#anim1b,thisbobb
rts


com19:
cmp.w	#19,d1
bne	com20
bset	#1,aktrout
move.w	#7,sdata
move.w	#$0000,$dff180
move.w	#$0eca,$dff182
move.w	#$0f40,$dff184
move.w	#$0f60,$dff186
move.w	#$0f71,$dff188
move.w	#$0f91,$dff18a
move.w	#$0fa2,$dff18c
move.w	#$0fb2,$dff18e
move.w	#$0222,$dff190
move.w	#$0333,$dff192
move.w	#$0444,$dff194
move.w	#$0555,$dff196
move.w	#$0666,$dff198
move.w	#$0777,$dff19a
move.w	#$0888,$dff19c
move.w	#$0aaa,$dff19e
move.w	#$ffff,dbtimer
move.w	#8,animlenght
move.w	#7,dbcounter
;;
move.l	#position,a0
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#10,(a0)+
move.w	#14,(a0)+
move.w	#8,(a0)+
move.w	#6,(a0)+
move.w	#8,(a0)+
move.w	#18,(a0)+
move.w	#10,(a0)+
move.w	#10,(a0)+
move.l	#anim2a,thisboba
move.l	#anim2b,thisbobb
rts


com20:
cmp.w	#20,d1
bne	com21
bset	#1,aktrout
move.w	#$0000,$dff180
move.w	#$0eca,$dff182
move.w	#$0023,$dff184
move.w	#$0034,$dff186
move.w	#$0045,$dff188
move.w	#$0056,$dff18a
move.w	#$0057,$dff18c
move.w	#$0068,$dff18e
move.w	#$0078,$dff190
move.w	#$0089,$dff192
move.w	#$009a,$dff194
move.w	#$00ab,$dff196
move.w	#$00bc,$dff198
move.w	#$00cd,$dff19a
move.w	#$00de,$dff19c
move.w	#$00ef,$dff19e

move.w	#9,sdata
move.w	#5,dbtimer
move.w	#1,dbcounter
move.w	#1,dbsleep
move.w	#6,animlenght
move.l	#position,a0
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#0,(a0)+
move.w	#2,(a0)+
move.w	#4,(a0)+
move.w	#6,(a0)+
move.w	#8,(a0)+
move.w	#30,(a0)+
move.w	#50,(a0)+
move.w	#60,(a0)+
move.w	#50,(a0)+


move.l	#anim4a,thisboba
move.l	#anim4b,thisbobb
rts

;;
com21:
bra com22
cmp.w	#21,d1
bne	com22
bset	#1,aktrout
move.w	#9,sdata
move.w	#$0000,$dff180
move.w	#$0eca,$dff182
move.w	#$0010,$dff184
move.w	#$0020,$dff186
move.w	#$0030,$dff188
move.w	#$0040,$dff18a
move.w	#$0151,$dff18c
move.w	#$0161,$dff18e
move.w	#$0272,$dff190
move.w	#$0282,$dff192
move.w	#$0393,$dff194
move.w	#$04a3,$dff196
move.w	#$04b4,$dff198
move.w	#$05c5,$dff19a
move.w	#$06d6,$dff19c
move.w	#$07e7,$dff19e
move.w	#5,dbtimer
move.w	#8,animlenght
;move.l	#anim3a,thisboba
;move.l	#anim3b,thisbobb
rts






com22:
rts


aktrout:	dc.b	%00000000	;running routines
dc.b	0
even
sepp:	dc.l	0



textlength:	dc.w	4
textpos:	dc.w	$ffff

drawtext:
move.w	textpos,d0	;neues offset
addq.w	#1,d0
cmp.w	textlength,d0	;letzte seite ?
bne	notextrest	;notextrestart
move.w	#0,d0		;wieder seite 1
notextrest:
move.w	d0,textpos
mulu	#108,d0

		move.l	otherplane,a0
		add.l	#176*30+2,a0
		move.l	#font,a1
		move.l	#text,a2
add.l	d0,a2

move.l	#5,d2	;zeilen
drawcharline:
move.l	#7,d1	;8 spalten
moveq	#0,d4
move.w	(a2)+,d4
add.w	d4,a0
drawcharspalt:

move.l	#31,d0
moveq	#0,d3
move.w	(a2)+,d3
lsl.w	#7,d3
drawcharl1:
move.l	0(a1,d3),(a0)
addq.w	#4,d3
add.l	#176,a0
dbf	d0,drawcharl1
sub.w	#5628,a0
dbf	d1,drawcharspalt
sub.w	d4,a0
add.l	#5600,a0
dbf	d2,drawcharline
rts


text:
dc.w 2,7,1,12,12,15,22,18,0,0,16,17,5,18,5,14,19,18
dc.w 2,1,14,15,19,8,5,17,0,0,0,0,16,1,17,19,0,0,2,4
dc.w 15,14,5,0,2,24,0,0,0,0,13,15,15,14,0,0,2,19,20
dc.w 14,5,0,2,24,0,0,0,0,4,20,11,5,0,0,0,0,7,6,23,0
dc.w 2,24,0,0,0,0,4,20,11,5,0,0,2,19,5,23,19,0,2,24
dc.w 0,2,0,0,17,9,16,0,0,0,2,0,1,19,1,17,9,0,0,2,0,0
dc.w 6,15,17,0,0,0,0,0,12,1,13,5,17,18,0,2,0,1,13,9
dc.w 7,1,0,0,2,0,0,6,15,17,0,0,0,2,0,20,18,5,17,18,0
dc.w 0,2,13,5,13,2,5,17,18,0,0,0,0,13,15,15,14,0,0,0
dc.w 0,0,4,20,11,5,0,0,2,0,0,17,9,16,0,0,0,0,9,3,5,0
dc.w 3,20,2,5,2,0,18,19,5,21,5,0,0,2,3,15,14,19,1,3
dc.w 19,0,0,20,18,0,20,14,4,5,17,0,0,16,15,0,2,15,23
dc.w 0,69,0,0,1,0,31,30,26,26,0,2,8,1,12,12,5,9,14,0




drawline2:
move.l	#$dff000,a6
bwait5:	
btst	#14,dmaconr(a6)
bne	bwait5

move.l	#koord,a0
move.w	sdata,d7
drawloop2:
clr.l	d0
clr.l	d1
clr.l	d2
clr.l	d3
move.w	koord,d0
move.w	koord+2,d1
move.w	(a0)+,d2
move.w	(a0)+,d3
or.w	#%0000000000000001,d0
or.w	#%0000000000000001,d1
and.w	#%1111111111111110,d2
and.w	#%1111111111111110,d3
addq	#1,d2
jsr	line
;subq	#4,a0
dbf	d7,drawloop2
rts




drawline:
move.l	#$dff000,a6
bwait1:	
btst	#14,dmaconr(a6)
bne	bwait1

move.l	#koord,a0
move.w	sdata,d7

drawloop:
clr.l	d0
clr.l	d1
clr.l	d2
clr.l	d3


move.w	(a0)+,d0
move.w	(a0)+,d1

move.w	(a0)+,d2
move.w	(a0)+,d3

or.w	#%0000000000000001,d0
or.w	#%0000000000000001,d1
and.w	#%1111111111111110,d2
and.w	#%1111111111111110,d3
addq	#1,d2
jsr	line
subq	#4,a0
dbf	d7,drawloop
rts


line:
move.l	#176,d6
mulu	d1,d6
moveq	#-$10,d5
and.w	d0,d5
lsr.w	#3,d5
add.w	d5,d6
add.l	currentplane,d6
	add.l	#176*24+6,d6


	clr.l	d4
	sub.w	d0,d2
	roxl.w	#1,d4
	sub.w	d1,d3
	roxl.w	#1,d4

	tst.w	d2
	bpl	noneg1
	neg.w	d2
noneg1:
	tst.w	d3
	bpl	noneg2
	neg.w	d3
noneg2:
	move.l	d2,d5
	sub.w	d3,d5
	roxl.w	#1,d4
	tst.w	d5
	bpl	noneg3
	exg	d2,d3
noneg3:
	move.l	#okttab,a5
	move.b	0(a5,d4),d4
add.w	d3,d3			;d3=2*kdelta
bwait2:	
btst	#14,dmaconr(a6)
bne	bwait2

	move.w	d3,bltbmod(a6)	;2*kdelta
sub.w	d2,d3			;2*kdelta-gdelta

bpl	nosign
bset	#6,d4
nosign:

	move.w	d3,bltaptl(a6)	;2*kdelta-gdelta
sub.w	d2,d3			;2*kdelta-2*gdelta
	move.w	d3,bltamod(a6)	;2*kdelta-2*gdelta
lsl.w	#6,d2			;gdelta*64
addq	#2,d2			;d2=gdelta*64+2
	move.l	d6,bltcpth(a6)	;startadresse linie
	move.l	d6,bltdpth(a6)	;startadresse linie
	move.w	#176,bltcmod(a6)	;breite plane in bytes
	move.w	#176,bltdmod(a6)	;breite plane in bytes
	move.w	#$8000,bltadat(a6)	;fixwert
	move.w	#$ffff,bltbdat(a6)	;maske
	move.w	#$ffff,bltafwm(a6)	;fixwert
	move.w	d4,bltcon1(a6)	;oktant
and.w	#$000f,d0		;unteren 4 bits von x...
ror.w	#4,d0			;bits 0123 -> bits 12 13 14 15
or.w	#$0bca,d0		;USEx und LFx setzen
move.w	d0,bltcon0(a6)



	move.w	d2,bltsize(a6)	;blitterstart



rts

okttab:
dc.b	4*4+1
dc.b	0*4+1
dc.b	6*4+1
dc.b	1*4+1
dc.b	5*4+1
dc.b	2*4+1
dc.b	7*4+1
dc.b	3*4+1
even






linebobmax:		dc.w	9
linebobpoint:		dc.w	0
linebobdat:
		dc.w	8,8,10,14,20,10,10,14
		dc.w	6,8,12,16,20,20,20,20;*
		dc.w	6,10,8,8,36,26,20,10
		dc.w	8,6,10,18,20,30,10,18
		dc.w	8,10,14,14,8,10,10,30
		dc.w	8,14,12,10,8,16,24,32;*
		dc.w	6,8,12,16,20,20,40,40
		dc.w	10,6,12,8,10,20,30,40;*
		dc.w	10,8,12,12,16,26,8,14
linebobcol:
	dc.w	$0f39,$0fff,$000f,$00f0,$0f00,$0ff0,$0f0f,$00ff,$0999
	dc.w	$0600,$0555,$0770,$0044,$0080,$0507,$0008,$0468
nextboblinedat:
move.w	linebobpoint,d0
add.w	#1,d0
move.w	d0,linebobpoint
cmp.w	linebobmax,d0
bne	nolinbobdatres
move.w	#0,d0
move.w	d0,linebobpoint
nolinbobdatres:	;nolinebobdatenrestart
move.l	#linebobcol,a0
lsl.w	#1,d0
move.w	0(a0,d0),$dff182

move.l	#linebobdat,a0
lsl.w	#3,d0
move.l	#position,a1

move.l	0(a0,d0),8(a1)
move.l	4(a0,d0),12(a1)
move.l	8(a0,d0),16(a1)
move.l	12(a0,d0),20(a1)
rts







;nextbobline2dat:
move.w	linebobpoint,d0
move.l	#linebobcol,a0
lsl.w	#1,d0
move.w	16(a0,d0),$dff182
move.l	#linebobdat,a0
lsl.w	#3,d0
move.l	#position,a1
move.l	0(a0,d0),8(a1)
move.l	4(a0,d0),12(a1)
move.l	8(a0,d0),16(a1)
move.l	12(a0,d0),20(a1)
rts







drawline3:
move.l	#$dff000,a6
bwait6:	
btst	#14,dmaconr(a6)
bne	bwait6

move.l	#koord,a0
move.w	sdata,d7
lsr.w	#1,d7
drawloop3:
clr.l	d0
clr.l	d1
clr.l	d2
clr.l	d3
move.w	koord,d0
move.w	koord+2,d1
move.w	(a0)+,d2
move.w	(a0)+,d3
or.w	#%0000000000000001,d0
or.w	#%0000000000000001,d1
and.w	#%1111111111111110,d2
and.w	#%1111111111111110,d3
addq	#1,d2
jsr	line

clr.l	d0
clr.l	d1
clr.l	d2
clr.l	d3
move.w	koord+176,d0
move.w	koord+178,d1
move.w	(a0)+,d2
move.w	(a0)+,d3
or.w	#%0000000000000001,d0
or.w	#%0000000000000001,d1
and.w	#%1111111111111110,d2
and.w	#%1111111111111110,d3
addq	#1,d2
jsr	line





dbf	d7,drawloop3
rts








drawline4:
move.l	#$dff000,a6
bwait7:	
btst	#14,dmaconr(a6)
bne	bwait7

move.l	#koord,a0
move.w	sdata,d7
lsr.w	#1,d7
drawloop4:
clr.l	d0
clr.l	d1
clr.l	d2
clr.l	d3
move.w	40(a0),d0
move.w	42(a0),d1
move.w	(a0)+,d2
move.w	(a0)+,d3
or.w	#%0000000000000001,d0
or.w	#%0000000000000001,d1
and.w	#%1111111111111110,d2
and.w	#%1111111111111110,d3
addq	#1,d2
jsr	line
;subq	#4,a0
dbf	d7,drawloop4
rts

thisboba:	dc.l	0
thisbobb:	dc.l	0

anim0a:		blk.b	13824,0
anim0b:		blk.b	13824,0

anim1a:		blk.b	4608,0
anim1b:		blk.b	4608,0

anim2a:		blk.b	6144,0
anim2b:		blk.b	6144,0


anim4a:		blk.b	6144,0
anim4b:		blk.b	6144,0

dbcounter:	dc.w	1	;drawbobcounter
dbtimer:	dc.w	5	;number of ints for next pig(speed)

dbsleep:	dc.w	10	;counter fuer next pic (animspeed)
animlenght:	dc.w	18	;wieviele schweine (pigs)

animator:
sub.w	#1,dbsleep
beq	animnextpic
rts
;;
animnextpic:
move.w	dbtimer,dbsleep
move.w	dbcounter,d0
add.w	#1,d0
cmp.w	animlenght,d0
bne	noresanim
moveq	#0,d0
noresanim:
move.w	d0,dbcounter
rts

;нннннннннннннннннннннннннннннннннннннн
;н   NoisetrackerV1.0 replayroutine   н
;н Mahoney & Kaktus - HALLONSOFT 1989 н
;нннннннннннннннннннннннннннннннннннннн
mt_init:lea	mt_data,a0
	move.l	a0,a1
	add.l	#$3b8,a1
	moveq	#$7f,d0
	moveq	#0,d1
mt_loop:move.l	d1,d2
	subq.w	#1,d0
mt_lop2:move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	mt_loop
	dbf	d0,mt_lop2
	addq.b	#1,d2

	lea	mt_samplestarts(pc),a1
	asl.l	#8,d2
	asl.l	#2,d2
	add.l	#$43c,d2
	add.l	a0,d2
	move.l	d2,a2
	moveq	#$1e,d0
mt_lop3:clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	asl.l	#1,d1
	add.l	d1,a2
	add.l	#$1e,a0
	dbf	d0,mt_lop3

	or.b	#$2,$bfe001
	move.b	#$6,mt_speed
	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	clr.b	mt_songpos
	clr.b	mt_counter
	clr.w	mt_pattpos
	rts

mt_end:	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	move.w	#$f,$dff096
	rts

mt_music:
	movem.l	d0-d4/a0-a3/a5-a6,-(a7)
	lea	mt_data,a0
	addq.b	#$1,mt_counter
	move.b	mt_counter,D0
	cmp.b	mt_speed,D0
	blt.s	mt_nonew
	clr.b	mt_counter
	bra	mt_getnew

mt_nonew:
	lea	mt_voice1(pc),a6
	lea	$dff0a0,a5
	bsr	mt_checkcom
	lea	mt_voice2(pc),a6
	lea	$dff0b0,a5
	bsr	mt_checkcom
	lea	mt_voice3(pc),a6
	lea	$dff0c0,a5
	bsr	mt_checkcom
	lea	mt_voice4(pc),a6
	lea	$dff0d0,a5
	bsr	mt_checkcom
	bra	mt_endr

mt_arpeggio:
	moveq	#0,d0
	move.b	mt_counter,d0
	divs	#$3,d0
	swap	d0
	cmp.w	#$0,d0
	beq.s	mt_arp2
	cmp.w	#$2,d0
	beq.s	mt_arp1

	moveq	#0,d0
	move.b	$3(a6),d0
	lsr.b	#4,d0
	bra.s	mt_arp3
mt_arp1:moveq	#0,d0
	move.b	$3(a6),d0
	and.b	#$f,d0
	bra.s	mt_arp3
mt_arp2:move.w	$10(a6),d2
	bra.s	mt_arp4
mt_arp3:asl.w	#1,d0
	moveq	#0,d1
	move.w	$10(a6),d1
	lea	mt_periods(pc),a0
	moveq	#$24,d7
mt_arploop:
	move.w	(a0,d0.w),d2
	cmp.w	(a0),d1
	bge.s	mt_arp4
	addq.l	#2,a0
	dbf	d7,mt_arploop
	rts
mt_arp4:move.w	d2,$6(a5)
	rts

mt_getnew:
	lea	mt_data,a0
	move.l	a0,a3
	move.l	a0,a2
	add.l	#$c,a3
	add.l	#$3b8,a2
	add.l	#$43c,a0

	moveq	#0,d0
	move.l	d0,d1
	move.b	mt_songpos,d0
	move.b	(a2,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	mt_pattpos,d1
	clr.w	mt_dmacon

	lea	$dff0a0,a5
	lea	mt_voice1(pc),a6
move.l	#148,d4
move.l	#equal1,a4
	bsr.s	mt_playvoice
	lea	$dff0b0,a5
	lea	mt_voice2(pc),a6
move.l	#148,d4
move.l	#equal2,a4
	bsr.s	mt_playvoice
	lea	$dff0c0,a5
	lea	mt_voice3(pc),a6
move.l	#200,d4
move.l	#equal3,a4
	bsr.s	mt_playvoice
	lea	$dff0d0,a5
	lea	mt_voice4(pc),a6
move.l	#255,d4
move.l	#equal4,a4
	bsr.s	mt_playvoice
	bra	mt_setdma

mt_playvoice:
	move.l	(a0,d1.l),(a6)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	$2(a6),d2
	and.b	#$f0,d2
	lsr.b	#4,d2
	move.b	(a6),d0
	and.b	#$f0,d0
	or.b	d0,d2
	tst.b	d2
	beq.s	mt_setregs
	moveq	#0,d3
move.w	d4,(a4)
	lea	mt_samplestarts(pc),a1
	move.l	d2,d4
	subq.l	#$1,d2
	asl.l	#2,d2
	mulu	#$1e,d4
	move.l	(a1,d2.l),$4(a6)
	move.w	(a3,d4.l),$8(a6)
	move.w	$2(a3,d4.l),$12(a6)
	move.w	$4(a3,d4.l),d3
	tst.w	d3
	beq.s	mt_noloop
	move.l	$4(a6),d2
	asl.w	#1,d3
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$4(a3,d4.l),d0
	add.w	$6(a3,d4.l),d0
	move.w	d0,8(a6)
	move.w	$6(a3,d4.l),$e(a6)
	move.w	$12(a6),$8(a5)
	bra.s	mt_setregs
mt_noloop:
	move.l	$4(a6),d2
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$6(a3,d4.l),$e(a6)
	move.w	$12(a6),$8(a5)
mt_setregs:
	move.w	(a6),d0
	and.w	#$fff,d0
	beq	mt_checkcom2
	move.b	$2(a6),d0
	and.b	#$F,d0
	cmp.b	#$3,d0
	bne.s	mt_setperiod
	bsr	mt_setmyport
	bra	mt_checkcom2
mt_setperiod:
	move.w	(a6),$10(a6)
	and.w	#$fff,$10(a6)
	move.w	$14(a6),d0
	move.w	d0,$dff096
	clr.b	$1b(a6)

	move.l	$4(a6),(a5)
	move.w	$8(a6),$4(a5)
	move.w	$10(a6),d0
	and.w	#$fff,d0
	move.w	d0,$6(a5)
	move.w	$14(a6),d0
	or.w	d0,mt_dmacon
	bra	mt_checkcom2

mt_setdma:
	move.w	#$12c,d0
mt_wait:dbf	d0,mt_wait
	move.w	mt_dmacon,d0
	or.w	#$8000,d0
	move.w	d0,$dff096
	move.w	#$12c,d0
mt_wai2:dbf	d0,mt_wai2
	lea	$dff000,a5
	lea	mt_voice4(pc),a6
	move.l	$a(a6),$d0(a5)
	move.w	$e(a6),$d4(a5)
	lea	mt_voice3(pc),a6
	move.l	$a(a6),$c0(a5)
	move.w	$e(a6),$c4(a5)
	lea	mt_voice2(pc),a6
	move.l	$a(a6),$b0(a5)
	move.w	$e(a6),$b4(a5)
	lea	mt_voice1(pc),a6
	move.l	$a(a6),$a0(a5)
	move.w	$e(a6),$a4(a5)

	add.w	#$10,mt_pattpos
	cmp.w	#$400,mt_pattpos
	bne.s	mt_endr
mt_nex:	clr.w	mt_pattpos
	clr.b	mt_break
	addq.b	#1,mt_songpos
	and.b	#$7f,mt_songpos
	move.b	mt_songpos,d1
	cmp.b	mt_data+$3b6,d1
	bne.s	mt_endr
	clr.b	mt_songpos
mt_endr:tst.b	mt_break
	bne.s	mt_nex
	movem.l	(a7)+,d0-d4/a0-a3/a5-a6
	rts

mt_setmyport:
	move.w	(a6),d2
	and.w	#$fff,d2
	move.w	d2,$18(a6)
	move.w	$10(a6),d0
	clr.b	$16(a6)
	cmp.w	d0,d2
	beq.s	mt_clrport
	bge.s	mt_rt
	move.b	#$1,$16(a6)
	rts
mt_clrport:
	clr.w	$18(a6)
mt_rt:	rts

mt_myport:
	move.b	$3(a6),d0
	beq.s	mt_myslide
	move.b	d0,$17(a6)
	clr.b	$3(a6)
mt_myslide:
	tst.w	$18(a6)
	beq.s	mt_rt
	moveq	#0,d0
	move.b	$17(a6),d0
	tst.b	$16(a6)
	bne.s	mt_mysub
	add.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	bgt.s	mt_myok
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
mt_myok:move.w	$10(a6),$6(a5)
	rts
mt_mysub:
	sub.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	blt.s	mt_myok
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
	move.w	$10(a6),$6(a5)
	rts

mt_vib:	move.b	$3(a6),d0
	beq.s	mt_vi
	move.b	d0,$1a(a6)

mt_vi:	move.b	$1b(a6),d0
	lea	mt_sin(pc),a4
	lsr.w	#$2,d0
	and.w	#$1f,d0
	moveq	#0,d2
	move.b	(a4,d0.w),d2
	move.b	$1a(a6),d0
	and.w	#$f,d0
	mulu	d0,d2
	lsr.w	#$6,d2
	move.w	$10(a6),d0
	tst.b	$1b(a6)
	bmi.s	mt_vibmin
	add.w	d2,d0
	bra.s	mt_vib2
mt_vibmin:
	sub.w	d2,d0
mt_vib2:move.w	d0,$6(a5)
	move.b	$1a(a6),d0
	lsr.w	#$2,d0
	and.w	#$3c,d0
	add.b	d0,$1b(a6)
	rts

mt_nop:	move.w	$10(a6),$6(a5)
	rts

mt_checkcom:
	move.w	$2(a6),d0
	and.w	#$fff,d0
	beq.s	mt_nop
	move.b	$2(a6),d0
	and.b	#$f,d0
	tst.b	d0
	beq	mt_arpeggio
	cmp.b	#$1,d0
	beq.s	mt_portup
	cmp.b	#$2,d0
	beq	mt_portdown
	cmp.b	#$3,d0
	beq	mt_myport
	cmp.b	#$4,d0
	beq	mt_vib
	move.w	$10(a6),$6(a5)
	cmp.b	#$a,d0
	beq.s	mt_volslide
	rts

mt_volslide:
	moveq	#0,d0
	move.b	$3(a6),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	mt_voldown
	add.w	d0,$12(a6)
	cmp.w	#$40,$12(a6)
	bmi.s	mt_vol2
	move.w	#$40,$12(a6)
mt_vol2:move.w	$12(a6),$8(a5)
	rts

mt_voldown:
	moveq	#0,d0
	move.b	$3(a6),d0
	and.b	#$f,d0
	sub.w	d0,$12(a6)
	bpl.s	mt_vol3
	clr.w	$12(a6)
mt_vol3:move.w	$12(a6),$8(a5)
	rts

mt_portup:
	moveq	#0,d0
	move.b	$3(a6),d0
	sub.w	d0,$10(a6)
	move.w	$10(a6),d0
	and.w	#$fff,d0
	cmp.w	#$71,d0
	bpl.s	mt_por2
	and.w	#$f000,$10(a6)
	or.w	#$71,$10(a6)
mt_por2:move.w	$10(a6),d0
	and.w	#$fff,d0
	move.w	d0,$6(a5)
	rts

mt_portdown:
	clr.w	d0
	move.b	$3(a6),d0
	add.w	d0,$10(a6)
	move.w	$10(a6),d0
	and.w	#$fff,d0
	cmp.w	#$358,d0
	bmi.s	mt_por3
	and.w	#$f000,$10(a6)
	or.w	#$358,$10(a6)
mt_por3:move.w	$10(a6),d0
	and.w	#$fff,d0
	move.w	d0,$6(a5)
	rts

mt_checkcom2:
	move.b	$2(a6),d0
	and.b	#$f,d0
	cmp.b	#$e,d0
	beq.s	mt_setfilt
	cmp.b	#$d,d0
	beq.s	mt_pattbreak
	cmp.b	#$b,d0
	beq.s	mt_posjmp
	cmp.b	#$c,d0
	beq.s	mt_setvol
	cmp.b	#$f,d0
	beq.s	mt_setspeed
	rts

mt_setfilt:
	move.b	$3(a6),d0
	and.b	#$1,d0
	asl.b	#$1,d0
	and.b	#$fd,$bfe001
	or.b	d0,$bfe001
	rts
mt_pattbreak:
	not.b	mt_break
	rts
mt_posjmp:
	move.b	$3(a6),d0
	subq.b	#$1,d0
	move.b	d0,mt_songpos
	not.b	mt_break
	rts
mt_setvol:
	cmp.b	#$40,$3(a6)
	ble.s	mt_vol4
	move.b	#$40,$3(a6)
mt_vol4:move.b	$3(a6),$8(a5)
	rts
mt_setspeed:
	move.b	$3(a6),d0
	and.w	#$1f,d0
	beq.s	mt_rts2
	clr.b	mt_counter
	move.b	d0,mt_speed
mt_rts2:rts

mt_sin:
dc.b $00,$18,$31,$4a,$61,$78,$8d,$a1,$b4,$c5,$d4,$e0,$eb,$f4,$fa,$fd
dc.b $ff,$fd,$fa,$f4,$eb,$e0,$d4,$c5,$b4,$a1,$8d,$78,$61,$4a,$31,$18

mt_periods:
dc.w $0358,$0328,$02fa,$02d0,$02a6,$0280,$025c,$023a,$021a,$01fc,$01e0
dc.w $01c5,$01ac,$0194,$017d,$0168,$0153,$0140,$012e,$011d,$010d,$00fe
dc.w $00f0,$00e2,$00d6,$00ca,$00be,$00b4,$00aa,$00a0,$0097,$008f,$0087
dc.w $007f,$0078,$0071,$0000,$0000

mt_speed:	dc.b	$6
mt_songpos:	dc.b	$0
mt_pattpos:	dc.w	$0
mt_counter:	dc.b	$0

mt_break:	dc.b	$0
mt_dmacon:	dc.w	$0
mt_samplestarts:blk.l	$1f,0
mt_voice1:	blk.w	10,0
		dc.w	$1
		blk.w	3,0
mt_voice2:	blk.w	10,0
		dc.w	$2
		blk.w	3,0
mt_voice3:	blk.w	10,0
		dc.w	$4
		blk.w	3,0
mt_voice4:	blk.w	10,0
		dc.w	$8
		blk.w	3,0
mt_data:	blk.b	116186,0






