;***************************************************
;*                                                 *
;*                  Sinecroller                    *
;*                                                 *
;* Part 4 of Megademo                              *
;*                                                 *
;* code by Moon/Gallows                            *
;***************************************************

planesize=48*275
execbase=4
forbid=-132
permit=-138
startlist=38
openlibrary=-30-522

dmaconr=$002
dmacon=$096
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

;bitplaneoffsets
bplcon0=$100
bplcon1=$102
bplcon2=$104
bpl1pth=$0e0
bpl1ptl=$0e2
bpl2pth=$0e4
bpl2ptl=$0e6
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
	move.b	#$fd,$bfd100;lets 
	nop                 ;stop
	nop                 ;the
	nop                 ;disc
	nop                 ;drive
	move.b	#$e7,$bfd100;motor

	move.l	execbase,a6
	lea	$dff000,a5
	jsr	forbid(a6)
	jsr	switchplane
	move.w	#%0000001111100000,dmacon(a5)
	move.w	#$1a74,diwstrt(a5)
	move.w	#$2dd5,diwstop(a5)
	move.w	#$0030,ddfstrt(a5)
	move.w	#$00d8,ddfstop(a5)
	move.w	#%0010001000000000,bplcon0(a5)
	move.w	#%0000000001000000,bplcon1(a5)
	move.w	#$0000,bplcon2(a5)
	move.w	#$0004,bpl1mod(a5)
	move.w	#$0004,bpl2mod(a5)
	jsr	coppercopy
	move.l	#copperlist,cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000011111100000,dmacon(a5)

	move.l	#0,$dff144;adios, mouse sprite!

	jsr	mt_init
	jsr	intstart
	move.w	#$0409,$dff182
	move.w	#$0409,$dff184
	move.w	#$0409,$dff186
	move.w	#$066f,$dff1a4		;;star color
wait:	btst	#6,ciaapra
	bne.S	wait
back:
	lea	$dff000,a5
	jsr	intstop
	jsr	mt_end
	move.l	execbase,a6
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
	move.w	#%0000000001100000,intena(a5)
	move.l	$6c,oldint
	move.l	#introut,$6c
	move.w	#%1100000000100000,intena(a5)
	rts

;;
introut:	;leave a5 alone
	btst	#5,intreqr(a5)
	bne	intback
	
	move.l	plane1adr,d0
	move.l	d0,bpl2pth(a5)
	add.l	#48*6,d0
	move.l	d0,bpl1pth(a5)
	move.l	#spritelist,spr0pth(a5)
	move.l	#endoflist,d0
	move.l	d0,spr1pth(a5)
	move.l	d0,spr2pth(a5)
	move.l	d0,spr3pth(a5)
	move.l	d0,spr4pth(a5)
	move.l	d0,spr5pth(a5)
	move.l	d0,spr6pth(a5)
	move.l	d0,spr7pth(a5)

	bsr	mt_music	;play Dukeดs Music
	bsr	switchplane	;swap the first plane
	bsr	plane1cls	;delete the plane for calc
	bsr	coppercopy	;calc the copperlist
	bsr	barrotate	;rotate the colorbars
	bsr	starmove	;move the starsprites
bltwait:	btst	#14,dmaconr(a5)
	bne	bltwait

	bsr	drawsinus	;and now my sinusroutine
	bsr	scroller	;the normal scrollroutine

intback:
	move.w	#%0000000001100000,intreq(a5)
	rte

intstop:
	move.l	oldint,$6c
	rts

sodatpointer:	dc.w	0
sineoffset:	dc.w	0

drawsinus:
	lea $dff000,a5		;base custom chips
	move.l	#sinoffdat,a1
	move.l	#sinus2,a0
	
	move.w	sineoffset,d3
	add.w	#2,d3
	cmp.w	#1440,d3
	bne	nosineoffres
	move.w	#0,d3
nosineoffres:
	move.w	d3,sineoffset

	move.w	sodatpointer,d0
	add.w	0(a0,d3.w),d0
	bpl	nounterlauf
	add.w	#1430,d0
nounterlauf:
	cmp.w	#1430,d0
	ble	mosodatrestart
	move.w	#0,d0
mosodatrestart:
	move.w	d0,sodatpointer
	add.w	d0,a1

	move.l	plane1adr,a0
	add.l	#48*10,a0	;offset scroller start
	move.l	a0,a2		;a0 wird veraendert,-> zwischenspeichern
	move.l	#21,d0		;21 woerter (schleifenzaehler)
	move.w	#1153,d3
;blitterinit
	move.w	#46,bltdmod(a5)	;48=breite,2=bltsiz,48-2=46
	move.l	#$002e002e,bltbmod(a5)	;bltbmod & bltbmod
	move.l	#$0d540000,bltcon0(a5)
	move.w	#0,bltcdat(a5)


routa:	move.l	a2,a0
	move.l	a2,bltapth(a5)		;quell=scrollstart
	add.w	(a1)+,a0		;add sindiff
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	a0,bltbpth(a5)
	move.l	#$80008000,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	d3,bltsize(a5)	;h=32,l=1 (start blitter)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$40004000,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$20002000,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$10001000,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$08000800,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$04000400,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$02000200,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$01000100,bltafwm(a5)
	move.w	d3,bltsize(a5)




	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00800080,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00400040,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00200020,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00100010,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00080008,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00040004,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00020002,bltafwm(a5)
	move.w	d3,bltsize(a5)

	move.l	a2,a0
	move.l	a0,bltapth(a5)
	add.w	(a1)+,a0
	move.l	a0,bltdpth(a5)
	move.l	a0,bltbpth(a5)
	move.l	#$00010001,bltafwm(a5)
	move.w	d3,bltsize(a5)

	addq	#2,a2
	dbf	d0,routa
rts


plane1cls:	move.w	#0,bltdmod(a5)
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	plane1adr,a0
		add.l	#48*44,a0		;offset scroller start
		move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#$3e93,bltsize(a5)	;h=250,l=21 (start blitter)
		rts

switchdata:	dc.w	0
switchplane:
	move.w	switchdata,d0
	beq	otheron
	move.w	#0,switchdata
	move.l	#plane1_1,plane1adr
	move.l	#plane1_2,otherplane
	rts
otheron:
	move.w	#1,switchdata
	move.l	#plane1_2,plane1adr
	move.l	#plane1_1,otherplane
rts

font:	incbin	"data/font"

textpoint:	dc.w	0

scrollpoint:	dc.w	1
scrollsleep:	dc.w	0

scroller:
	move.w	scrollpoint,d0
	cmp.w	#8,d0
	bne	nosleep
	move.w	scrollsleep,d0
	beq	nosleep
	subq	#1,d0
	move.w	d0,scrollsleep

	lea $dff000,a5		;base custom chips
	move.l	plane1adr,a0
	add.l	#48*10,a0	;offset scroller start laden
	move.l	otherplane,a1
	add.l	#48*10,a1
	moveq	#0,d0

	move.l	d0,bltamod(a5)		;bltamod & bltdmod
	move.l	#$09100000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	d0,bltcdat(a5)		;bltbdat & bltcdat
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	a1,bltapth(a5)		;source=scrollstart
	subq.l	#1,d0
	move.l	d0,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#2070,bltsize(a5)	;h=32,l=1 (start blitter)
	rts

nosleep:
	lea $dff000,a5		;base custom chips
	move.l	plane1adr,a0
	add.l	#48*10-2,a0	;offset scroller start
	move.l	otherplane,a1
	add.l	#48*10,a1
	moveq	#0,d0

	move.l	d0,bltamod(a5)		;bltamod & bltdmod
	move.l	#$e9100000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	d0,bltcdat(a5)		;bltbdat & bltcdat
	move.l	a0,bltdpth(a5)		;dest=scrstart+offsetdat
	move.l	a1,bltapth(a5)		;source=scrollstart
	subq.l	#1,d0
	move.l	d0,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#2070,bltsize(a5)	;h=32,l=1 (start blitter)

	move.w	scrollpoint,d0
	subq	#1,d0
	move.w	d0,scrollpoint
	bne	noput
	move.w	#15,scrollpoint

scrrest:
	move.w	textpoint,d0
	lea	text,a0
	moveq	#0,d1
	move.b	0(a0,d0.w),d1
	cmp.b	#255,d1
	bne	noscrrestart
	move.w	#0,textpoint
	bra	scrrest
noscrrestart:
	cmp.b	#254,d1
	bne	nosleepset
	addq.w	#1,d0
	move.w	d0,textpoint
	move.w	#254,scrollsleep
	bra	scrrest
nosleepset:
	addq.w	#1,d0
	move.w	d0,textpoint
	lsl.w	#7,d1

	lea	font,a1
	moveq	#48,d2
	move.l	plane1adr,a0
	add.l	#48*10+44,a0
	add.l	d1,a1
	moveq	#17,d0
drawcharloop:
	move.l	(a1)+,(a0)
	add.l	d2,a0
	dbf	d0,drawcharloop
noput:
	rts

color1:
         dc.w $F00
         dc.w $F10,$F20,$F30,$F40,$F50,$F60,$F70,$F80
         dc.w $F90,$FA0,$FB0,$FC0,$FD0,$FE0,$FF0,$FF0
         dc.w $FF0,$EF0,$DF0,$CF0,$BF0,$AF0,$9F0,$8F0
         dc.w $7F0,$6F0,$5F0,$4F0,$3F0,$2F0,$1F0,$0F0
         dc.w $0F1,$0F2,$0F3,$0F4,$0F5,$0F6,$0F7,$0F8
         dc.w $0F9,$0FA,$0FB,$0FC,$0FD,$0FE,$0FF,$0FF
         dc.w $0FF,$0EF,$0DF,$0CF,$0BF,$0AF,$09F,$08F
         dc.w $07F,$06F,$05F,$04F,$03F,$02F,$01F,$00F
         dc.w $00F,$10F,$20F,$30F,$40F,$50F,$60F,$70F
         dc.w $80F,$90F,$A0F,$B0F,$C0F,$D0F,$E0F,$F0F
         dc.w $F0F,$F0E,$F0D,$F0C,$F0B,$F0A,$F09,$F08
         dc.w $F07,$F06,$F05,$F04,$F03,$F02,$F01,$F00
	dc.w	$f00


copperlist:	blk.l	1100,0

grname:		dc.b	"graphics.library",0
even
coppercopy:
	move.l	#color1,a0	;rotate colorbars
	move.l	#48,d0
	move.w	(a0),d1
sepploop:
	move.l	2(a0),(a0)+
	dbf	d0,sepploop
	move.w	d1,-(a0)

	move.l	#copperlist,a0
	move.l	#color1,a1
	move.w	#$3c0f,d1	;3c0f
	move.w	#92,d0
	move.l	#stars,a4

	move.l	#$01820000,(a0)+	;upper
	move.l	#$01840000,(a0)+	;  scroll
	move.l	#$01860000,(a0)+	;    black


	move.l	#$3c39fffe,(a0)+	;wait colorbarline

	move.l	#42,d3	;42 colors/line
	move.l	#colorbardat,a3
	move.w	#$0180,d4
	move.w	#$0182,d5
	move.w	#$0186,d6
	move.w	#$fffe,d7
colorbar1rout:
	move.w	d4,(a0)+	
	move.w	(a3)+,(a0)+
	dbf	d3,colorbar1rout

	move.l	#$01800000,(a0)+	;black between bars
	move.l	#$01840209,(a0)+	;shadow
	move.w	#$100,d3
coppercopyloop1:
	move.w	d1,(a0)+
	move.w	d7,(a0)+		;fffe

	move.w	d5,(a0)+		;182
	move.w	(a1),(a0)+
	move.w	d6,(a0)+		;186
	move.w	(a1)+,(a0)+

	move.w	#$0140,(a0)+
	move.w	(a4)+,(a0)+
	
	add.l	d3,d1
	move.w	d1,(a0)+
	move.w	d7,(a0)+		;fffe
	move.w	#$0140,(a0)+
	move.w	(a4)+,(a0)+
	add.l	d3,d1
	dbf	d0,coppercopyloop1

	move.l	#$f739fffe,(a0)+	;wait colorbarline2
	move.l	#42,d3	;20 colors/line
	move.l	#colorbardat+100,a3
colorbar2rout:
	move.w	d4,(a0)+		;180	
	move.w	-(a3),(a0)+
	dbf	d3,colorbar2rout
	move.l	#$01800000,(a0)+
	move.l	#$01820000,(a0)+
	move.l	#$01840000,(a0)+
	move.l	#$01860000,(a0)+

	move.l	#$fffffffe,(a0)
	rts

barrotate:
	move.l	#colorbardat,a0
	move.w	(a0),d1
	move.w	#40,d0
barrotaterout:
	move.l	2(a0),(a0)+
	dbf	d0,barrotaterout
	move.w	d1,(a0)
	rts

colorbardat:
         dc.w $000,$100,$200,$300,$400,$500,$600,$700
         dc.w $800,$900,$A00,$B00,$C00,$D00,$E00,$F00
         dc.w $F10,$F20,$F30,$F40,$F50,$F60,$F70,$F80
         dc.w $F90,$FA0,$FB0,$FC0,$FD0,$FE0,$FF0,$FF0

         dc.w $FF0,$EF1,$DF2,$CF3,$BF4,$AF5,$9F6,$8F7
         dc.w $7F8,$6F9,$5FA,$4FB,$3FC,$2FD,$1FE,$0FF
         dc.w $0EF,$0DF,$0CF,$0BF,$0AF,$09F,$08F,$07F
         dc.w $06F,$05F,$04F,$03F,$02F,$01F,$00F,$00F

         dc.w $00F,$00E,$00D,$00C,$00B,$00A,$009,$008
         dc.w $007,$006,$005,$004,$003,$002,$001,$000
         dc.w $000,$000,$000


spritelist:	dc.w	$3d5a,$f700
		blk.l	186,1
endoflist:	dc.w	0,0

stars:	incbin	"data/stars"


starmove:
	move.l	#stars,a0
	moveq	#46,d0
starmovloop:
	addq.w	#1,(a0)+
	addq.w	#2,(a0)+
	addq.w	#3,(a0)+
	addq.w	#4,(a0)+
	dbf	d0,starmovloop
	rts


;ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
;ญ   NoisetrackerV1.0 replayroutine   ญ
;ญ Mahoney & Kaktus - HALLONSOFT 1989 ญ
;ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
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
	bsr.s	mt_playvoice
	lea	$dff0b0,a5
	lea	mt_voice2(pc),a6
	bsr.s	mt_playvoice
	lea	$dff0c0,a5
	lea	mt_voice3(pc),a6
	bsr.s	mt_playvoice
	lea	$dff0d0,a5
	lea	mt_voice4(pc),a6
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
mt_data:	incbin "data/mod.silent peace"

sinus2:		incbin	"data/sinus2"
oldint:		dc.l	0
otherplane:	dc.l	0
plane1adr:	dc.l	0
plane2adr:	dc.l	0
plane1_1:	blk.l	48*275/4,0
plane1_2:	blk.l	48*275/4,0
;plane2:	blk.l	48*275/4,0
sineload1:	incbin	"data/sinus"
sineload2:	incbin	"data/sinus"
sinoffdat:
sineload3:	incbin	"data/sinus"
sineload4:	incbin	"data/sinus"

text:		incbin	"data/text"
textend:
