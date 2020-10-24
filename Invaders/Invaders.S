;*******************************************************
;**                                                   **
;**                    INVADERS                       **
;**                                                   **
;**            All coding by MOON/GALLOWS             **
;**                                                   **
;**        Written from April 1991-April 1992         **
;**                                                   **
;**         Released on the 26th april 1992           **
;**                                                   **
;*******************************************************
>extern "data/font1",font1+64
>extern "data/font1a",font1dat+128
>extern "data/font1b",font1cod+128

execbase=4
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$096
dmaconr=$002
startlist=38
openlibrary=-30-522

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
bpl1mod=$108
bpl2mod=$10a
diwstrt=$08e
diwstop=$090
ddfstrt=$092
ddfstop=$094

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
	jsr	forbid(a6)
	lea	$dff000,a5
blwait1:
	btst	#14,dmaconr(a5)
	bne	blwait1
	move.w	#%0000001111100000,dmacon(a5)
lea	plane1adr,a0
move.l	#40800*2/4,d0
clsloop:
move.l	#0,(a0)+
dbf	d0,clsloop

	move.l	#copperlist,cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000001111000000,dmacon(a5)
	jsr	switchplanes
	jsr	mt_init
	move.w	#%0000000001011000,$dff09a
	move.l	$6c,oldint
	move.l	#introut,$6c
	move.l	#%0,$dff144		;sprite 0 off
wait:
	move.w	dircommand,d0		;dircommand ?
	beq	mousewait		;no-then mouseask
	move.w	#0,dircommand		;clear dircommandflag
	jsr	dircomexecutor
mousewait:
	tst.w	ente
	beq	wait
;	btst	#6,ciaapra
;	bne wait

back:	
move.l	#reset,$6c

resetwait:
jmp	resetwait

;	move.l	oldint,$6c
;	jsr	mt_end
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
;	rts	;---> BACK TO SYSTEM <---
reset:
move.l	4,a6
lea	$fc0002,a0
reset
jmp	(a0)

;/////////////////////////////////////////////////////////////////////
intcommand:	dc.w	0	;intcommand that should be executed
dircommand:	dc.w	0	;dircommand that should be executed
switchmark:	dc.w	0	;flag switchplanes
thisplane:	dc.l	0	;adress of activated plane
otherplane:	dc.l	0	;adress of deactivated plane
oldint:		dc.l	0	;old level3interrupt-vector
fadesleep:	dc.w	1
fadecount:	dc.w	3
tofade:		blk.w	36,$0000
faded:		blk.w	36,$0000
fadedat:	blk.w	36*16,$0000
fadeflag:	dc.w	0
gurkpoint:	dc.w	0
gurklenght:	dc.w	0
gurke:		dc.l	0
bobkoord:	dc.l	0
bobtext:	dc.l	0
bobquant:	dc.w	0
bobspeed:	dc.w	0
bobdiff:	dc.w	0
bscrollwait:	dc.w	1
scrpos:		dc.w	1
bscrolltextpos:	dc.w	0
barsetx:	dc.w	168
barsety:	dc.w	127
cline1:		dc.w	0
cline2:		dc.w	0
cline3:		dc.w	0
cline4:		dc.w	0
cline5:		dc.w	0
cline6:		dc.w	0
cbar1:		dc.b	$4d	;$4d = 77   ($2f
cbar2:		dc.b	$04
cbar1m:		dc.b	$4d
cbar2m:		dc.b	$04	;end=$2b
toplogo:	dc.l	0
;/////////////////////////////////////////////////////////////////////
logo1:		incbin	"data/logo1"
logo2:		incbin	"data/logo2"
logo3:		incbin	"data/logo3"
logo4:		incbin	"data/logo4"
logo5:		incbin	"data/logo5"
logo6:		incbin	"data/logo6"
logo7:	;not used
logo8:		incbin	"data/logo8"
gurke1:		incbin	"data/gurke1"
gurkend:
gurke2:		incbin	"data/gurke2"
gurke2end:
logo1col:
dc.w	$0000,$0fff,$0eee,$0ddd,$0ccc,$0bbb,$0aaa,$0999
dc.w	$0888,$0666,$0555,$0444,$0333,$0222,$0111,$0000
logo4col:
dc.w	$0000,$0fff,$0ddd,$0bbb,$0999,$0777,$0555,$0333
dc.w	$0f9d,$0d6a,$0b49,$0926,$0715,$0503,$0abf,$079d
dc.w	$057b,$036a,$0158,$0046,$08fc,$05da,$03a8,$0287
dc.w	$0165,$0044,$0000,$0000,$0000,$0000,$0000,$0000
logo5cop:
dc.w	$0180,$0000,$0182,$0cde,$0184,$09ac,$0186,$078b
dc.w	$0188,$056a,$018a,$0338,$018c,$0227,$018e,$0115
dc.w	$0190,$0104,$0192,$0b9c,$0194,$0a6a,$0196,$0849
dc.w	$0198,$0737,$019a,$0515,$019c,$0403,$019e,$0201
logo6cop:
dc.w	$0180,$0000,$0182,$0754,$0184,$0644,$0186,$0634
dc.w	$0188,$0535,$018a,$0525,$018c,$0424,$018e,$0224
logo7cop:
dc.w	$0180,$0000,$0182,$0abc,$0184,$09ab,$0186,$089a
dc.w	$0188,$0789,$018a,$0678,$018c,$0567,$018e,$0456
dc.w	$0190,$0345,$0192,$0234,$0194,$0123,$0196,$0012
dc.w	$0198,$0000,$019a,$0000,$019c,$0000,$019e,$0000
logo8cop:
dc.w	$0180,$0000,$0182,$0e80,$0184,$0d70,$0186,$0c60
dc.w	$0188,$0b50,$018a,$0a40,$018c,$0930,$018e,$0820
dc.w	$0190,$0600,$0192,$0500,$0194,$0400,$0196,$0300
dc.w	$0198,$0200,$019a,$0110,$019c,$0100,$019e,$0000




starcol:
dc.w	$005f,$002e,$000d,$030c,$050b,$060a,$0709,$0808;060a
dc.w	$0808,$0907,$0a06,$0b05,$0c03,$0d01,$0e20,$0f50

;other version
dc.w	$0ff0,$0ce1,$09d1,$07c2,$05b2,$04a3,$0393,$0384
dc.w	$0387,$0399,$039a,$028b,$027c,$016d,$013e,$000f
starcolfaded:	blk.b	72,0
;/////////////////////////////////////////////////////////////////////
fader:
	lea	tofade,a2	;scr-farbdaten
	lea	fadedat,a1	;obj-farbdaten
	lea	faded,a0	;akt-farbdaten
	moveq	#35,d0		;anzahl farben
faderloop1:
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
faderloop2:
	cmp.w	d2,d5
	beq	nobluefade
	ble	blueblack
	addq.w	#%1,d2
	bra	nobluefade
blueblack:
	subq.w	#1,d2
nobluefade:
	cmp.w	d3,d6
	beq	nogreenfade
	ble	greenblack
	add.w	#%10000,d3
	bra	nogreenfade
greenblack:
	sub.w	#%10000,d3
nogreenfade:
	cmp.w	d4,d7
	beq	noredfade
	ble	redblack
	add.w	#%100000000,d4
	bra	noredfade
redblack:
	sub.w	#%100000000,d4
noredfade:
	move.w	d2,a3
	or.w	d3,d2
	or.w	d4,d2
	move.w	d2,(a1)+
	move.w	a3,d2
	dbf	d1,faderloop2
	dbf	d0,faderloop1
	move.w	#0,fadeflag
	rts
;*****

realfade:
	move.w	fadesleep,d0
	beq	fadeit
	subq.w	#1,d0
	move.w	d0,fadesleep
	rts
fadeit:
	move.w	fadecount,fadesleep
	move.w	fadeflag,d0
	cmp.w	#30,d0
	bne	fadereal
	rts
fadereal:
	addq.w	#2,d0
	move.w	d0,fadeflag
	subq.w	#2,d0;;
	lea	fadedat,a0
	lea	faded,a1
	moveq	#35,d1
fadereall1:
	move.w	0(a0,d0.w),(a1)+	;180
	add.l	#30,d0
	dbf	d1,fadereall1
	rts
;*****

switchplanes:
	move.w	switchmark,d0
	beq	swplane2
	move.w	#0,switchmark
	move.l	#plane1adr,thisplane
	move.l	#plane2adr,otherplane
	move.l	#plane2adr+20400,starplane
	rts
swplane2:
	move.w	#1,switchmark
	move.l	#plane2adr,thisplane
	move.l	#plane2adr,starplane
	move.l	#plane1adr,otherplane
	rts
;*****

bobscroll:
	subq.w	#1,bscrollwait
	bne	bscrollback
	lea	bscrolltext,a0
	move.w	bscrolltextpos,d0
	addq.w	#1,bscrolltextpos
	move.w	#10,bscrollwait
	lea	onscreenfont1,a1
	move.w	scrpos,d1
	bne	noscrbobrestart
	moveq	#13,d1
noscrbobrestart:
	subq.w	#1,d1
	move.w	d1,scrpos
	move.b	0(a0,d0.w),0(a1,d1.w)
bscrollback:
	rts
;*****

starmove1:
	moveq	#67,d0
	lea	starpos,a0
starmov1l1:
	addq.w	#1,(a0)+
	addq.w	#2,(a0)+
	addq.w	#3,(a0)+
	addq.w	#4,(a0)+
	dbf	d0,starmov1l1
	rts
;*****

starmove2:
	moveq	#67,d0
	lea	starpos,a0
starmov2l1:
	move.w	(a0),d1
	addq.w	#1,d1
	and.w	#$00ff,d1
	move.w	d1,(a0)+

	move.w	(a0),d1
	addq.w	#2,d1
	and.w	#$00ff,d1
	move.w	d1,(a0)+

	move.w	(a0),d1
	addq.w	#3,d1
	and.w	#$00ff,d1
	move.w	d1,(a0)+

	move.w	(a0),d1
	addq.w	#4,d1
	and.w	#$00ff,d1
	move.w	d1,(a0)+

	dbf	d0,starmov2l1
	rts
;*****

coppercopy1:
	lea	copperlist,a0
	lea	faded,a1
	lea	starcolfaded,a2
	move.w	#$0180,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0182,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0184,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0186,(a0)+
	move.w	(a1)+,(a0)+
	move.l	#$0100,d1
	move.l	#$20df,d2
	lea	starpos,a1
	move.w	#[272/8]-1,d0
coppercopy1l1:
	moveq	#7,d3
coppercopy1l2:
	move.w	d2,(a0)+
	move.l	#$fffe0140,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$01a4,(a0)+
	move.w	(a2),(a0)+
	add.w	d1,d2
	dbf	d3,coppercopy1l2
	addq.l	#2,a2
	dbf	d0,coppercopy1l1
	move.l	#$fffffffe,(a0)
	rts
;*****

coppercopy10:
	lea	copperlist,a0
	lea	faded,a1
	lea	starcolfaded,a2
	move.l	#$0100,d1
	move.l	#$20df,d2
	lea	starpos,a1
	move.w	#[272/8]-1,d0
coppercopy10l1:
	moveq	#7,d3
coppercopy10l2:
	move.w	d2,(a0)+
	move.l	#$fffe0140,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0182,(a0)+
	move.w	(a2),(a0)+
	add.w	d1,d2
	dbf	d3,coppercopy10l2
	addq.l	#2,a2
	dbf	d0,coppercopy10l1
	move.l	#$fffffffe,(a0)
	rts
;*****

drawbobs1:
	move.w	gurkpoint,d0
	add.w	bobspeed,d0
	cmp.w	gurklenght,d0
	ble	nogurkrestart
	sub.w	gurklenght,d0
nogurkrestart:
	move.w	d0,gurkpoint
	move.l	gurke,a2
	move.w	bobdiff,d5	;offset
	move.l	bobkoord,a1
	move.l	bobtext,a6
	move.w	bobquant,d3			;;bobs


	lea	$dff000,a5
blitterwait3:	;wait for end of cls !
	btst	#14,dmaconr(a5)
	bne	blitterwait3
	move.l	#$002e0000,bltcmod(a5)	;bltcmod & bltbmod !
	move.l	#$0000002e,bltamod(a5)	;bltamod & bltdmod !
move.l	#%11111111111111110000000000000000,bltafwm(a5)	;afwm+alwm

drawbobs1l1:
	moveq	#0,d1
	move.w	(a1)+,d1	;x-koord
	moveq	#0,d2
	move.w	(a1)+,d2	;y-koord
	add.w	0(a2,d0.w),d1
	add.w	2(a2,d0.w),d2
sub.w	#20,d2
bpl	nozeroflow
moveq	#0,d2

nozeroflow:
	add.w	d5,d0
	cmp.w	gurklenght,d0
	ble	nogurkrestart2
	sub.w	gurklenght,d0
nogurkrestart2:
	cmp.w	#371,d1
	ble	nooffsetkill
	move.w	#370,d1
nooffsetkill:

	move.w	d1,d4
	lsr.w	#4,d1			;x/16=wordoffset
	and.w	#%0000000000001111,d4	;scrollbits...
	ror.w	#4,d4			;...rotate to highbits...
	move.w	d4,d6			;...copy...
	or.w	#%0000111111110010,d6	;...set miniterms...
	swap	d6			;...word on highword...
	move.w	d4,d6			;...and word!!!

	mulu	#100,d2
	move.l	thisplane,a0		;planeadresse laden
	subq.l	#2,a0
	add.w	d1,d1
	add.l	d1,a0
	add.l	d2,a0
	move.b	(a6)+,d4
	lsl.w	#7,d4
	lea	font1cod,a4
	add.w	d4,a4	
	lea	font1dat,a3
	add.w	d4,a3

blitterwait5:
btst	#14,dmaconr(a5)
bne	blitterwait5

	move.l	a0,bltdpth(a5)		;ziel=scrstart+offsetdat
	move.l	a0,bltcpth(a5)
	move.l	a4,bltapth(a5)	;quelle=bobdata
	move.l	a3,bltbpth(a5)	;data

	move.l	d6,bltcon0(a5)	;bltcon0&bltcon1
	move.w	#2050,bltsize(a5)	;x=2 (32),y=32 (16*2)
	dbf	d3,drawbobs1l1
	rts
;*****

planecls1:
	lea	$dff000,a5
	move.w	#0,bltdmod(a5)
	move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	thisplane,bltdpth(a5)	;ziel
	move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#$7719,bltsize(a5)	;h=544,l=25  136*4=544,*3=408!

moveq	#0,d0
moveq	#0,d1
moveq	#0,d2
moveq	#0,d3
moveq	#0,d4
move.l	d0,a0
move.l	d0,a1
move.l	d0,a2
move.l	d0,a3
move.l	d0,a4

move.l	#84,d5
move.l	thisplane,a5
add.l	#68*7*50,a5

prozessorclsloop:
movem.l	d0-d4/a0-a4,(a5)
add.l	#40,a5
dbf	d5,prozessorclsloop
rts
;*****

planecls2:
	lea	$dff000,a5
	move.w	#50,bltdmod(a5)
	move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
	move.l	otherplane,bltdpth(a5)	;ziel
	move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
	move.w	#$4419,bltsize(a5)	;h=544,l=25  136*4=544,*3=408!
rts;???????
;*****

planecls4:
		lea	$dff000,a5
		move.w	#0,bltdmod(a5)
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	otherplane,d0
		add.l	#40*100*3,d0
		move.l	d0,bltdpth(a5)	;ziel
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#$7694,bltsize(a5)	;x=20 y=158*3
rts
	move.l	#166,d7
	move.l	otherplane,a6
	movem.l	(a6),d0-d6/a0-a5
	add.l	#217*2*40,a6
prozclsloop:
	movem	d0-d6/a0-a5,(a6)
	add.l	#52,a6
	dbf	d7,prozclsloop
	rts


;*****

planecls5:
		lea	$dff000,a5
		move.w	#0,bltdmod(a5)
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	otherplane,d0
		move.l	d0,bltdpth(a5)	;ziel
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#$3ad4,bltsize(a5)	;x=20 y=235
rts
;*****

planecls6:
		lea	$dff000,a5
		move.w	#0,bltdmod(a5)
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	otherplane,d0
		move.l	d0,bltdpth(a5)	;ziel
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#$4094,bltsize(a5)	;x=20 y=258
rts
;*****

planecls7:
		lea	$dff000,a5
		move.w	#0,bltdmod(a5)
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	starplane,d0
		move.l	d0,bltdpth(a5)	;ziel
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#$4194,bltsize(a5)	;x=20 y=362

	move.l	#76,d7
	move.l	starplane,a6
	movem.l	(a6),d0-d6/a0-a5
	add.l	#40*262-4,a6
prozclsloop2:
	movem.l	d0-d6/a0-a5,(a6)
	add.l	#52,a6
	dbf	d7,prozclsloop2
	rts

rts
;*****

starcolcopy:
	lea	faded+8,a0
	lea	starcolfaded,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)+
	move.w	(a0),(a1)+

	move.w	(a0),(a1)+
	move.w	(a0),(a1)+
	move.w	(a0),(a1)+
	move.w	(a0),(a1)+

	move.w	(a0),(a1)+
	moveq	#14,d0
starcolcopyl1:
	move.w	-(a0),(a1)+
	dbf	d0,starcolcopyl1
rts
;*****

coppercopy2:
	move.b	cbar1,d0
	cmp.b	cbar1m,d0
	beq	coppercopy2l2
	bls	coppercopy2l3
	subq.b	#1,cbar1
	bra	coppercopy2l2
coppercopy2l3:
	addq.b	#1,cbar1
coppercopy2l2:
	move.b	cbar2,d0
	cmp.b	cbar2m,d0
	beq	coppercopy2l4
	bls	coppercopy2l5
	subq.b	#1,cbar2
	bra	coppercopy2l4
coppercopy2l5:
	addq.b	#1,cbar2
coppercopy2l4:


	lea	copperlist1,a0
	move.l	#$100ffffe,(a0)+
	move.l	toplogo,d0
	moveq	#0,d1
	move.w	logoplanesize,d1
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 3
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
	swap	d0

	move.w	#diwstrt,(a0)+
	move.w	#$3081,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$30c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0100001000000000,(a0)+

	move.l	logocolour,a1
	move.l	#15,d0
coppercopy2l1:
	move.l	(a1)+,(a0)+
	dbf	d0,coppercopy2l1

	move.b	cbar1,d6		;bar1 pos
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+	;0 planes

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 1.1
	move.w	cline1,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.2
	move.w	cline2,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.3
	move.w	cline3,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.l	#$01800000,(a0)+	;line off

	move.l	#copperlist,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
rts

;*****

coppercopy11:
	move.b	cbar1,d0
	cmp.b	cbar1m,d0
	beq	coppercopy11l2
	bls	coppercopy11l3
	subq.b	#1,cbar1
	bra	coppercopy11l2
coppercopy11l3:
	addq.b	#1,cbar1
coppercopy11l2:
	move.b	cbar2,d0
	cmp.b	cbar2m,d0
	beq	coppercopy11l4
	bls	coppercopy11l5
	subq.b	#1,cbar2
	bra	coppercopy11l4
coppercopy11l5:
	addq.b	#1,cbar2
coppercopy11l4:

	lea	copperlist1,a0
	move.l	#$050ffffe,(a0)+
	move.l	toplogo,d0
	moveq	#0,d1
	move.w	logoplanesize,d1
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0

	move.w	#bplcon0,(a0)+
	move.w	#%0011001000000000,(a0)+

	move.w	#diwstrt,(a0)+
	move.w	#$3081,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$30c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	move.l	logocolour,a1
	move.l	#7,d0
coppercopy11l1:
	move.l	(a1)+,(a0)+
	dbf	d0,coppercopy11l1

	move.b	cbar1,d6		;bar1 pos
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+	;0 planes

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 1.1
	move.w	cline1,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.2
	move.w	cline2,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.3
	move.w	cline3,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.l	#$01800000,(a0)+	;line off

	move.l	#copperlist,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
rts

;*****

coppercopy3:	;middle screen pointeffect
	lea	copperlist,a0
	move.l	thisplane,d0	;logoplaneadr
	moveq	#64,d1	;planesize
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0

	move.w	#diwstrt,(a0)+
	move.w	#$3081,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$30c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#24+64,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#24+64,(a0)+
	move.l	#$01820fa0,(a0)+
	move.l	#$01840f60,(a0)+
	move.l	#$01860f20,(a0)+
	move.b	cbar1,d6		;bar1 pos
	addq.b	#6,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0010000100000000,(a0)+
	move.l	#$ab0ffffe,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#-104-64,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#-104-64,(a0)+

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
	move.l	#$fffffffe,(a0)
	rts
;*****

coppercopy4:
	lea	copperlist2,a0
	move.l	#$ffdffffe,(a0)+

	move.b	cbar2,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000000100000000,(a0)+
move.l	#scrollplane,d0
move.w	#bpl1ptl,(a0)+
move.w	d0,(a0)+
swap	d0
move.w	#bpl1pth,(a0)+
move.w	d0,(a0)+
swap	d0
add.l	#48*16,d0
move.w	#bpl2ptl,(a0)+
move.w	d0,(a0)+
swap	d0
move.w	#bpl2pth,(a0)+
move.w	d0,(a0)+
	move.b	cbar2,d0


	addq.b	#1,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 2.1
	move.w	cline4,(a0)+

	addq.b	#1,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 2.2
	move.w	cline5,(a0)+

	addq.b	#1,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 2.3
	move.w	cline6,(a0)+
move.w	#diwstrt,(a0)+
move.w	#$2076,(a0)+
move.w	#diwstop,(a0)+
move.w	#$30c9,(a0)+
move.w	#ddfstrt,(a0)+
move.w	#$0030,(a0)+
move.w	#ddfstop,(a0)+
move.w	#$00d8,(a0)+
move.w	#bpl1mod,(a0)+
move.w	#4,(a0)+
move.w	#bpl2mod,(a0)+
move.w	#4,(a0)+
move.w	#bplcon1,(a0)+
move.w	#0,(a0)+

	addq.b	#1,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.l	#$01800000,(a0)+	;line 2 off



	move.w	#bplcon0,(a0)+
	move.w	#%0010001000000000,(a0)+

move.l	#$01800000,(a0)+
move.l	#$01820e44,(a0)+
move.l	#$01840822,(a0)+
move.l	#$01860311,(a0)+

cmp.b	#$24,cbar2
bge	scrollout

	move.b	cbar2,d0
	add.b	#16+4,d0
	move.b	d0,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+


scrollout:
	move.w	#bplcon0,(a0)+
	move.w	#%0000000100000000,(a0)+

	move.l	#copperlist1,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	rts
;*****

coppercopy5:
	move.b	cbar1,d0
	cmp.b	cbar1m,d0
	beq	coppercopy5l2
	bls	coppercopy5l3
	subq.b	#1,cbar1
	bra	coppercopy5l2
coppercopy5l3:
	addq.b	#1,cbar1
coppercopy5l2:
	move.b	cbar2,d0
	cmp.b	cbar2m,d0
	beq	coppercopy5l4
	bls	coppercopy5l5
	subq.b	#1,cbar2
	bra	coppercopy5l4
coppercopy5l5:
	addq.b	#1,cbar2
coppercopy5l4:


	lea	copperlist1,a0
	move.l	#$100ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
	move.l	#scrollplane,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	#48*16,d0
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	move.w	#diwstrt,(a0)+
	move.w	#$2076,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$30c9,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0030,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d8,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#4,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#4,(a0)+
	move.l	#$01820e44,(a0)+
	move.l	#$01840822,(a0)+
	move.l	#$01860311,(a0)+
	move.b	cbar1,d6		;bar1 pos
	sub.b	#16,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0010001000000000,(a0)+
	move.b	cbar1,d6		;bar1 pos
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+	;0 planes

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line 1.1
	move.w	cline1,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.2
	move.w	cline2,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.l	#$fffe0180,(a0)+	;line1.3
	move.w	cline3,(a0)+

	addq.b	#1,d6
	move.b	d6,(a0)+
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.l	#$01800000,(a0)+	;line off

	move.l	#copperlist,d0		;(( gosub copperlist ))
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
	rts
;*****

psetter1:
	move.l	thisplane,a0		;planeadresse laden
	add.l	#100*1,a0
	lea	starpos,a1
	lea	barpos,a2
	move.w	#271,d0			;272 stars
psetter1l1:
	move.b	#%10000000,d3		;point-bit
	moveq	#0,d1			;clr d1
	moveq	#0,d2			;clr d2
	move.w	(a2)+,d2
	move.w	(a2)+,d2
	move.w	(a1)+,d1		;x-pos=starpos
	add.w	d1,d1
	sub.w	#97,d1
	bmi	psetter1l8
	cmp.w	#350,d1
	bge	psetter1l8
	mulu	#100,d2
	move.w	d1,d4
	lsr.w	#3,d1			;bytepos
	and.w	#%0000000000000111,d4	;bitpos
	lsr.b	d4,d3			;move bit on bitpos
	add.l	d2,d1
	or.b	d3,0(a0,d1.w)
psetter1l8:
	dbf	d0,psetter1l1
	lea	barpos,a0
	move.l	#271,d0
psetter1l2:
	move.w	(a0)+,d1	;overread
	move.w	(a0),d1	;y-pos
	cmp.w	#136,d1
	beq	psetter1l4
	bge	psetter1l3
	addq.w	#1,(a0)
	bra	psetter1l4
psetter1l3:
	subq.w	#1,(a0)
psetter1l4:
	addq.l	#2,a0
	dbf	d0,psetter1l2
	rts
;*****

psetter2:
	move.l	thisplane,a0		;planeadresse laden upper bar
	add.l	#100*10+44,a0
	moveq	#0,d0
	move.w	barsety,d0
	mulu	#100,d0
	add.l	d0,a0

	move.l	thisplane,a1		;planeadresse laden lower bar
	add.l	#100*10,a1
	move.l	#254,d0
	sub.w	barsety,d0
	mulu	#100,d0
	add.l	d0,a1

	moveq	#0,d0
	move.w	barsetx,d0
	move.w	d0,d1
	lsr.w	#3,d1
psetter2l1:
	move.b	#$ff,-(a0)
	move.b	#$ff,(a1)+
	dbf	d1,psetter2l1

	move.b	#%01111111,d4		;point-bit
	move.b	#%11111110,d5		;point-bit
	not.w	d0
	and.w	#%0000000000000111,d0	;bitpos
	lsr.b	d0,d4			;move bit on bitpos

	or.b	d4,-(a0)
	lsl.b	d0,d5
	or.b	d5,(a1)+

	moveq	#0,d0
	move.w	barsety,d0
	cmp.w	#36,d0
	beq	psetter2l2
	subq.w	#1,barsety
	addq.w	#2,barsetx
psetter2l2:
	rts
;*****

psetter3:
	move.l	otherplane,a0		;planeadresse laden
	move.w	pointcount,d0
	add.w	pointadder,d0
	cmp.b	#114,d0
	beq	psetter3l12
	tst.w	switchmark
	beq	psetter3l12
	move.w	d0,pointcount
psetter3l12:

	moveq	#0,d7
	move.w	barsinposx1,d7
	addq.w	#6,d7
	cmp.w	#sin1end-sin1,d7
	bne	psetter3l2

	moveq	#0,d7
psetter3l2:
	move.w	d7,barsinposx1
	moveq	#0,d6
	move.w	barsinposy1,d6
	addq.w	#4,d6
	cmp.w	#sin1end-sin1,d6
	bne	psetter3l5
	moveq	#0,d6
psetter3l5:
	move.w	d6,barsinposy1

	moveq	#0,d5
	move.w	barsinposx2,d5
	addq.w	#8,d5
	cmp.w	#sin1end-sin1,d5
	bne	psetter3l7
	moveq	#0,d5
psetter3l7:
	move.w	d5,barsinposx2

	moveq	#0,d4
	move.w	barsinposy2,d4
	addq.w	#6,d4
	cmp.w	#sin1end-sin1,d4
	bne	psetter3l8
	moveq	#0,d4
psetter3l8:
	move.w	d4,barsinposy2

	lea	barpos,a1
	lea	sin1,a2
	move.w	pointcount,d0
psetter3l1:
;plane 1
	moveq	#70,d1
	moveq	#2,d2
	add.w	(a2,d7.w),d1
	add.w	(a2,d6.w),d2
	add.w	(a2,d5.w),d1
	add.w	(a2,d4.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,0(a0,d1.w)

	move.w	#240,d1
	moveq	#2,d2
	sub.w	(a2,d7.w),d1
	add.w	(a2,d6.w),d2
	sub.w	(a2,d5.w),d1
	add.w	(a2,d4.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,0(a0,d1.w)

;plane 2
	moveq	#70,d1
	moveq	#2,d2
	add.w	(a2,d6.w),d1
	add.w	(a2,d7.w),d2
	add.w	(a2,d4.w),d1
	add.w	(a2,d5.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,64(a0,d1.w)
	bclr.b	d3,0(a0,d1.w)

	move.w	#240,d1
	moveq	#2,d2
	sub.w	(a2,d6.w),d1
	add.w	(a2,d7.w),d2
	sub.w	(a2,d4.w),d1
	add.w	(a2,d5.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,64(a0,d1.w)
	bclr.b	d3,0(a0,d1.w)

;plane 1+2
	moveq	#70,d1
	moveq	#2,d2
	add.w	(a2,d4.w),d1
	add.w	(a2,d6.w),d2
	add.w	(a2,d5.w),d1
	add.w	(a2,d7.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,0(a0,d1.w)
	bset.b	d3,64(a0,d1.w)

	move.w	#240,d1
	moveq	#2,d2
	sub.w	(a2,d4.w),d1
	add.w	(a2,d6.w),d2
	sub.w	(a2,d5.w),d1
	add.w	(a2,d7.w),d2
	lsl.w	#7,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos
	bset.b	d3,0(a0,d1.w)
	bset.b	d3,64(a0,d1.w)

	subq.w	#4,d7
	bpl	psetter3l4
	add.w	#sin1end-sin1,d7	
psetter3l4:
	subq.w	#8,d6
	bpl	psetter3l6
	add.w	#sin1end-sin1,d6
psetter3l6:
	subq.w	#8,d5				;10
	bpl	psetter3l9
	add.w	#sin1end-sin1,d5
psetter3l9:
	subq.w	#8,d4				;14
	bpl	psetter3l10
	add.w	#sin1end-sin1,d4
psetter3l10:
	dbf	d0,psetter3l1
	rts
;*****

coppercopy7:
	lea	copperlist,a0
	move.b	cbar1,d6		;bar1 pos
	addq.b	#6,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000000100000000,(a0)+

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
	rts
;*****

linequant:	dc.w	0
lines:		dc.l	0
turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0
turnaddx:	dc.w	0
turnaddy:	dc.w	0
turnaddz:	dc.w	0


turner:
	move.w	turnx,d0
	add.w	turnaddx,d0
	cmp.w	#359,d0
	ble nolaufx
	sub.w	#360,d0
nolaufx:
	move.w	d0,turnx

	move.w	turny,d0
	add.w	turnaddy,d0
	cmp.w	#359,d0
	ble nolaufy
	sub.w	#360,d0
nolaufy:
	move.w	d0,turny

	move.w	turnz,d0
	add.w	turnaddz,d0
	cmp.w	#359,d0
	ble nolaufz
	sub.w	#360,d0
nolaufz:
	move.w	d0,turnz


turner1:
	move.l	turnkoord,a0	;koordinaten
	move.l	turnkoords,a3
	lea	sinus,a1	;sinus/cosinus
	moveq	#0,d0
	move.w	turnquant,d0
turnrout1:
	move.w	d0,d1		;schleifenzaehler in d1
	lsl.w	#3,d1		;*8 als offset/koord
	move.w	d1,a2
	move.w	turnz,d2	;drehwinkel z laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	moveq	#0,d5
	moveq	#0,d6
	move.w	0(a1,d2.w),d6	;d6 = sin z
	move.w	2(a1,d2.w),d5	;d5 = cos z
	move.w	2(a3,a2.w),d3	;d3=x
	move.w	4(a3,a2.w),d4	;d4=y
	move.w	d3,d2		;d2=x
	muls	d5,d2		;d2=x*cos z
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=y
	muls	d6,d1		;d1=y*sin z
	swap	d1
	rol.l	#1,d1
	sub.w	d1,d2		;d2=x*cos z - y*sin z  ->new  x-koord
	move.w	d2,2(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=x
	muls	d6,d2		;d2=x*sin z
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=y
	muls	d5,d1		;d1=y*cos z
	swap	d1
	rol.l	#1,d1
	add.w	d1,d2		;d2=x*sin z + y*cos z  ->new  y-koord
	move.w	d2,4(a0,a2.w)	;in liste eintragen

	move.w	turnx,d2	;drehwinkel x laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	moveq	#0,d5
	moveq	#0,d6
	move.w	0(a1,d2.w),d6	;d6 = sin x
	move.w	2(a1,d2.w),d5	;d5 = cos x
	move.w	4(a0,a2.w),d3	;d3=y
	move.w	6(a3,a2.w),d4	;d4=z
	move.w	d3,d2		;d2=y
	muls	d5,d2		;d2=y*cos x
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=z
	muls	d6,d1		;d1=z*sin x
	swap	d1
	rol.l	#1,d1
	sub.w	d1,d2		;d2=y*cos x - z*sin x ->new y-koord
	move.w	d2,4(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=y
	muls	d6,d2		;d2=y*sin x
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=z
	muls	d5,d1		;d1=z*cos x
	swap	d1
	rol.l	#1,d1
	add.w	d1,d2		;d2=y*sin x + z*cos x
	move.w	d2,6(a0,a2.w)	;in liste eintragen

	move.w	turny,d2	;drehwinkel y laden
	add.w	d2,d2
	add.w	d2,d2		;drehwinkel * 4
	moveq	#0,d5
	moveq	#0,d6
	move.w	0(a1,d2.w),d6	;d6 = sin y
	move.w	2(a1,d2.w),d5	;d5 = cos y
	move.w	2(a0,a2.w),d3	;d3=x
	move.w	6(a0,a2.w),d4	;d4=z
	move.w	d3,d2		;d2=x
	muls	d5,d2		;d2=x*cos y
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=z
	muls	d6,d1		;d1=z*sin y
	swap	d1
	rol.l	#1,d1
	add.w	d1,d2		;d2=x*cos y + z*sin y
	move.w	d2,2(a0,a2.w)	;in liste eintragen
	move.w	d3,d2		;d2=x
	muls	d6,d2		;d2=x*sin y
	swap	d2
	rol.l	#1,d2
	move.w	d4,d1		;d1=z
	muls	d5,d1		;d1=z*cos y
	swap	d1
	rol.l	#1,d1
	sub.w	d2,d1		;d2=z*cos y - x*sin y
	move.w	d2,6(a0,a2.w)	;in liste eintragen
	dbf	d0,turnrout1
	rts
;*****


;/////////////////////////////////////////////////////////////////////
charmove:	dc.w	1
textpoint:	dc.w	0
charpoint:	dc.w	0
bremse:		dc.w	34
sinuspoint:	dc.w	0
compoint:	dc.w	0
sleeper:	dc.w	1
copperlist1:	blk.l	500,0
copperlist2:	blk.l	500,0
copperlist:	dc.w	$ffff,$fffe
		blk.l	1000,0
grname:		dc.b	"graphics.library",0
even

barsinposx1:	dc.w	0
barsinposy1:	dc.w	0
barsinposx2:	dc.w	0
barsinposy2:	dc.w	0
pointcount:	dc.w	0
pointadder:	dc.w	1


bscrolltext:
dc.b	18,5,12,5,1,19,5,4,0,9,14,0,1,16,18,9,12,0,28
dc.b	36,36,29,39,0,12,5,20,19,0,19,20,1,18,20,0,23
dc.b	9,20,8,0,19,15,13,5,0,3,18,5,4,9,20,19,39,39,39
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b	25,15,21,0,8,1,22,5,0,20,15
dc.b 0,11,14,15,23,0,20,8,1,20,0,14,21,11,5,0,1,14
dc.b 4,0,9,0,37,13,15,15,14,38,0,12,5,6,20,0,7,1,12
dc.b 12,15,23,19,0,1,14,4,0,10,15,9,14,5,4,0,19,16
dc.b 9,18,9,20,39,0,0,2,21,20,0,20,8,9,19,0,9,19,0,1
dc.b 0,7,1,12,12,15,23,19,40,4,5,14,20,18,15,0,3,15
dc.b 26,0,23,5,0,4,9,4,0,9,20,0,1,19,0,7,1,12,12,15
dc.b 23,19,40,13,5,13,2,5,18,19,41

dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
even
onscreenfont1:
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0
even
onscreenfont2:
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
dc.b	40,00,00,00,00,04,21,11,05,00,00,00,00,00,40	;.    DUKE     .
dc.b	40,00,03,15,13,16,15,19,05,04,00,02,25,00,40	;. COMPOSED BY .
dc.b	40,20,08,05,00,13,21,19,09,03,00,23,01,19,40	;.THE MUSIC WAS.
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
even

onscreenfont3:
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
dc.b	40,00,00,09,03,05,00,03,21,02,05,00,00,00,40	;.  ICE CUBE   .
dc.b	40,00,00,00,00,04,21,11,05,00,00,00,00,00,40	;.    DUKE     .
dc.b	40,01,12,12,00,12,15,07,15,19,00,02,25,00,40	;.ALL LOGOS BY .
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
even

onscreenfont4:
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
dc.b	40,05,18,01,00,19,20,14,15,06,00,05,08,20,40	;.ERA STNOF EHT.
dc.b	40,00,04,05,20,21,02,09,18,20,14,15,03,00,40	;. DETUBIRTNOC .
dc.b	40,00,00,00,00,16,09,18,00,25,02,00,00,00,40	;.    PIR YB   .
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
even

onscreenfont5:
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
dc.b	40,00,00,25,12,01,14,09,06,00,04,14,01,00,40	;.  YLANIF DNA .
dc.b	40,00,00,25,02,00,07,14,09,04,15,03,00,00,40	;.  YB GNIDOC  .
dc.b	40,00,00,00,00,00,14,15,15,13,00,00,00,00,40	;.     NOOM    .
dc.b	40,40,40,40,40,40,40,40,40,40,40,40,40,40,40	;...............
even

koord1:	blk.l	13,0

koord2:
dc.w	0,80
dc.w	20,80
dc.w	40,80
dc.w	60,80
dc.w	80,80
dc.w	100,80
dc.w	120,80
dc.w	140,80
dc.w	160,80
dc.w	180,80
dc.w	200,80
dc.w	220,80
dc.w	240,80
dc.w	260,80
dc.w	280,80

dc.w	0,60
dc.w	30,60
dc.w	50,60
dc.w	70,60
dc.w	90,60
dc.w	110,60
dc.w	130,60
dc.w	150,60
dc.w	170,60
dc.w	190,60
dc.w	210,60
dc.w	230,60
dc.w	250,60
dc.w	270,60
dc.w	280,60

dc.w	0,40
dc.w	20,40
dc.w	40,40
dc.w	60,40
dc.w	80,40
dc.w	100,40
dc.w	120,40
dc.w	140,40
dc.w	160,40
dc.w	180,40
dc.w	200,40
dc.w	220,40
dc.w	240,40
dc.w	260,40
dc.w	280,40

dc.w	0,20
dc.w	20,20
dc.w	40,20
dc.w	60,20
dc.w	80,20
dc.w	100,20
dc.w	120,20
dc.w	140,20
dc.w	160,20
dc.w	180,20
dc.w	200,20
dc.w	220,20
dc.w	240,20
dc.w	260,20
dc.w	280,20

dc.w	0,0
dc.w	20,0
dc.w	40,0
dc.w	60,0
dc.w	80,0
dc.w	100,0
dc.w	120,0
dc.w	140,0
dc.w	160,0
dc.w	180,0
dc.w	200,0
dc.w	220,0
dc.w	240,0
dc.w	260,0
dc.w	280,0


koord22:
dc.w	0,80
dc.w	20,80
dc.w	40,80
dc.w	60,80
dc.w	80,80
dc.w	100,80
dc.w	120,80
dc.w	140,80
dc.w	160,80
dc.w	180,80
dc.w	200,80
dc.w	220,80
dc.w	240,80
dc.w	260,80
dc.w	280,80

dc.w	0,60
dc.w	30,60
dc.w	50,60
dc.w	70,60
dc.w	90,60
dc.w	110,60
dc.w	130,60
dc.w	150,60
dc.w	170,60
dc.w	190,60
dc.w	210,60
dc.w	230,60
dc.w	250,60
dc.w	270,60
dc.w	280,60

dc.w	0,40
dc.w	30,40
dc.w	50,40
dc.w	70,40
dc.w	90,40
dc.w	110,40
dc.w	130,40
dc.w	150,40
dc.w	170,40
dc.w	190,40
dc.w	210,40
dc.w	230,40
dc.w	250,40
dc.w	270,40
dc.w	280,40

dc.w	0,20
dc.w	30,20
dc.w	50,20
dc.w	70,20
dc.w	90,20
dc.w	110,20
dc.w	130,20
dc.w	150,20
dc.w	170,20
dc.w	190,20
dc.w	210,20
dc.w	230,20
dc.w	250,20
dc.w	270,20
dc.w	280,20

dc.w	0,0
dc.w	20,0
dc.w	40,0
dc.w	60,0
dc.w	80,0
dc.w	100,0
dc.w	120,0
dc.w	140,0
dc.w	160,0
dc.w	180,0
dc.w	200,0
dc.w	220,0
dc.w	240,0
dc.w	260,0
dc.w	280,0


koord3:
dc.w	280,0
dc.w	260,0
dc.w	240,0
dc.w	220,0
dc.w	200,0
dc.w	180,0
dc.w	160,0
dc.w	140,0
dc.w	120,0
dc.w	100,0
dc.w	80,0
dc.w	60,0
dc.w	40,0
dc.w	20,0
dc.w	0,0

dc.w	280,20
dc.w	260,20
dc.w	240,20
dc.w	220,20
dc.w	200,20
dc.w	180,20
dc.w	160,20
dc.w	140,20
dc.w	120,20
dc.w	100,20
dc.w	80,20
dc.w	60,20
dc.w	40,20
dc.w	20,20
dc.w	0,20

dc.w	280,40
dc.w	260,40
dc.w	240,40
dc.w	220,40
dc.w	200,40
dc.w	180,40
dc.w	160,40
dc.w	140,40
dc.w	120,40
dc.w	100,40
dc.w	80,40
dc.w	60,40
dc.w	40,40
dc.w	20,40
dc.w	0,40

dc.w	280,60
dc.w	270,60
dc.w	250,60
dc.w	230,60
dc.w	210,60
dc.w	190,60
dc.w	170,60
dc.w	150,60
dc.w	130,60
dc.w	110,60
dc.w	90,60
dc.w	70,60
dc.w	50,60
dc.w	30,60
dc.w	0,60

dc.w	280,80
dc.w	260,80
dc.w	240,80
dc.w	220,80
dc.w	200,80
dc.w	180,80
dc.w	160,80
dc.w	140,80
dc.w	120,80
dc.w	100,80
dc.w	80,80
dc.w	60,80
dc.w	40,80
dc.w	20,80
dc.w	0,80


koord33:
dc.w	280,0
dc.w	260,0
dc.w	240,0
dc.w	220,0
dc.w	200,0
dc.w	180,0
dc.w	160,0
dc.w	140,0
dc.w	120,0
dc.w	100,0
dc.w	80,0
dc.w	60,0
dc.w	40,0
dc.w	20,0
dc.w	0,0

dc.w	280,20
dc.w	270,20
dc.w	250,20
dc.w	230,20
dc.w	210,20
dc.w	190,20
dc.w	170,20
dc.w	150,20
dc.w	130,20
dc.w	110,20
dc.w	90,20
dc.w	70,20
dc.w	50,20
dc.w	30,20
dc.w	0,20

dc.w	280,40
dc.w	260,40
dc.w	240,40
dc.w	220,40
dc.w	200,40
dc.w	180,40
dc.w	160,40
dc.w	140,40
dc.w	120,40
dc.w	100,40
dc.w	80,40
dc.w	60,40
dc.w	40,40
dc.w	20,40
dc.w	0,40

dc.w	280,60
dc.w	270,60
dc.w	250,60
dc.w	230,60
dc.w	210,60
dc.w	190,60
dc.w	170,60
dc.w	150,60
dc.w	130,60
dc.w	110,60
dc.w	90,60
dc.w	70,60
dc.w	50,60
dc.w	30,60
dc.w	0,60

dc.w	280,80
dc.w	260,80
dc.w	240,80
dc.w	220,80
dc.w	200,80
dc.w	180,80
dc.w	160,80
dc.w	140,80
dc.w	120,80
dc.w	100,80
dc.w	80,80
dc.w	60,80
dc.w	40,80
dc.w	20,80
dc.w	0,80


;copperlogo1:
dc.w	$0000,$0754,$0644,$0634,$0535,$0525,$0424,$0224
dc.w	$0000,$0111,$0111,$0111,$0111,$0111,$0111,$0111
dc.w	$0620,$0e52,$0a52,$0fca,$0333,$0444,$0555,$0666
dc.w	$0777,$0888,$0999,$0aaa,$0ccc,$0ddd,$0eee,$0fff

;copperlogo2:
dc.w	$0000,$0fff,$0ddd,$0bbb,$0999,$0777,$0555,$0333
dc.w	$0f9d,$0d6a,$0b49,$0926,$0715,$0503,$0abf,$079d
dc.w	$057b,$036a,$0158,$0046,$08fc,$05da,$03a8,$0287
dc.w	$0165,$0044,$0000,$0000,$0000,$0000,$0000,$0000

starpos:
dc.w  38, 208, 278, 233, 255, 23, 156, 145, 34, 304, 225, 170
dc.w  310, 102, 305, 299, 171, 180, 214, 224, 237, 213, 145, 106
dc.w  50, 235, 173, 136, 17, 245, 164, 180, 237, 211, 74, 148
dc.w  41, 155, 17, 116, 182, 316, 92, 210, 300, 121, 284, 255
dc.w  302, 103, 132, 135, 234, 70, 70, 244, 218, 229, 298, 83
dc.w  165, 151, 43, 154, 194, 56, 105, 78, 182, 259, 39, 2, 23
dc.w  53, 228, 168, 298, 195, 177, 230, 139, 32, 109, 266, 291
dc.w  144, 62, 262, 183, 271, 36, 313, 186, 196, 222, 272, 122
dc.w  73, 21, 112, 89, 187, 33, 55, 85, 164, 280, 132, 34, 175
dc.w  114, 153, 209, 298, 116, 67, 140, 287, 249, 92, 155, 53
dc.w  316, 276, 130, 233, 189, 143, 228, 271, 112, 22, 131, 107
dc.w  128, 204, 259, 19, 221, 194, 198, 230, 224, 275, 85, 271
dc.w  124, 268, 149, 27, 124, 302, 24, 224, 149, 60, 47, 109
dc.w  75, 18, 84, 20, 28, 216, 40, 190, 134, 59, 116, 268, 19
dc.w  124, 201, 211, 318, 205, 294, 280, 102, 318, 49, 176, 134
dc.w  184, 0, 154, 145, 77, 307, 316, 10, 147, 220, 292, 60, 145
dc.w  184, 286, 181, 189, 184, 282, 284, 10, 92, 286, 207, 194
dc.w  50, 235, 173, 136, 17, 245, 164, 180, 237, 211, 74, 148
dc.w  88, 16, 19, 308, 210, 262, 91, 306, 293, 173, 273, 96, 1
dc.w  63, 124, 138, 205, 135, 176, 218, 293, 245, 80, 206, 34
dc.w  69, 27, 264, 241, 308, 18, 171, 317, 129, 167, 8, 41, 136
dc.w  124, 280, 153, 292, 183, 207, 138, 161, 227, 244, 249, 200
dc.w  28, 207, 99, 237, 280, 39, 196, 281, 178, 15, 58, 124
dc.w  144, 62, 262, 183, 271, 36, 313, 186, 196, 222, 272, 122
dc.w  73, 21, 112, 89, 187, 33, 55, 85, 164, 280, 132, 34, 175
dc.w  114, 153, 209, 298, 116, 67, 140, 287, 249, 92, 155, 53



font1cod:		blk.l	1568,0
font1dat:		blk.l	1568,0
textpresents:
	dc.w	2048,2304,640,2432,640,1792,2560,2432
textademocalled:
	dc.w	128,0,512,640,1664,1920,0,384,128,1536,1536,640,512
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
introut:			;interruptroutine
	btst	#5,$dff01e	;vblankinterrupt ?
	bne	intback		;no !
	movem.l	d0-d7/a0-a6,-(a7)

move.w	intcommand,d0

;command 1 *********************************************************
intcom1:
cmp.w	#1,d0
bne	intcom2
;---
	lea	$dff000,a5
	move.l	thisplane,d0	;blitline-mode
	move.l	d0,bpl1pth(a5)
	add.l	#50,d0
	move.l	d0,bpl2pth(a5)
	jsr	realfade
jsr	starcolcopy
	jsr	bobscroll
	jsr	switchplanes
	jsr	planecls1
	jsr	starmove1
	jsr	coppercopy1
	jsr	mt_music
	lea	$dff000,a5
	jsr	drawbobs1
	jsr	commander
	jmp	intback
;*****

;command 2 ********************************************************
intcom2:
cmp.w	#2,d0
bne	intcom3
	move.l	#$dff000,a5
	move.l	#plane1adr,d0
	move.l	d0,bpl1pth(a5)
	add.l	#272*50,d0
	move.l	d0,bpl2pth(a5)
	add.l	#272*50,d0
	move.l	d0,bpl3pth(a5)
	add.l	#272*50,d0
	move.l	d0,bpl4pth(a5)
	add.l	#272*50,d0
	move.l	d0,bpl5pth(a5)
	jsr	realfade
	move.l	#copperlist,a0
	move.l	#faded,a1
	move.l	#31,d0
	move.w	#$0180,d1
intcoml1:
	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	add.w	#2,d1
	dbf	d0,intcoml1
	move.l	#$950ffffe,(a0)+	;wait logo1/2 end for NorTex
;move.l	#$018000f0,(a0)+		;mark-----------------------
;move.l	#$960ffffe,(a0)+

	move.w	#$0180,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0182,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0184,(a0)+
	move.w	(a1)+,(a0)+
	move.w	#$0186,(a0)+
	move.w	(a1)+,(a0)+
	move.l	#$fffffffe,(a0)+
	jsr	mt_music
	jsr	commander
	jmp	intback
;*****

intcom3:
cmp.w	#3,d0
bne	intcom4
	lea	$dff000,a5
	move.l	thisplane,d0
	move.l	d0,bpl1pth(a5)
	add.l	#50,d0
	move.l	d0,bpl2pth(a5)
	jsr	switchplanes
	jsr	planecls1
	jsr	starmove1
	jsr	coppercopy1
	jsr	mt_music
	jsr	drawbobs1
	jsr	commander
	jmp	intback
;*****

intcom4:
cmp.w	#4,d0
bne	intcom5
	lea	$dff000,a5
	move.l	thisplane,d0
	move.l	d0,bpl1pth(a5)
	add.l	#50,d0
	move.l	d0,bpl2pth(a5)
	move.l	#$fffffffe,copperlist
	move.l	#%0,$dff144		;sprite 0 off
	jsr	planecls2
	jsr	coppercopy10
	jsr	switchplanes
	jsr	starmove2
	jsr	mt_music
	lea	$dff000,a5
blitterwait8:
	btst	#14,dmaconr(a5)
	bne	blitterwait8
	jsr	psetter1
	jsr	commander
	jmp	intback
;*****

intcom5:
cmp.w	#5,d0
bne	intcom6
	lea	$dff000,a5
	move.l	thisplane,d0
	move.l	d0,bpl1pth(a5)
	add.l	#50,d0
	move.l	d0,bpl2pth(a5)
	jsr	starmove2
	jsr	mt_music
	lea	$dff000,a5
blitterwait9:
	btst	#14,dmaconr(a5)
	bne	blitterwait9
	jsr	psetter1
	jsr	commander
	jmp	intback
;*****

intcom6:
cmp.w	#6,d0
bne	intcom7
	lea	$dff000,a5
	move.l	thisplane,d0
	move.l	d0,bpl1pth(a5)
	add.l	#50,d0
	move.l	d0,bpl2pth(a5)
	jsr	planecls2
	jsr	switchplanes
	jsr	mt_music
lea	$dff000,a5
blitterwait10:
	btst	#14,dmaconr(a5)
	bne	blitterwait10
	jsr	psetter2
	jsr	commander
	jmp	intback
;*****


intcom7:
cmp.w	#7,d0
bne	intcom8
	jsr	switchplanes
	jsr	scroller
	lea	$dff000,a5
blitterwait14:
	btst	#14,dmaconr(a5)
	bne	blitterwait14
	jsr	planecls3
	jsr	coppercopy5
	jsr	coppercopy3
	jsr	coppercopy4
	jsr	mt_music
	lea	$dff000,a5
blitterwait13:
	btst	#14,dmaconr(a5)
	bne	blitterwait13

jsr	psetter3
;*****









blitterwait11:
	btst	#14,dmaconr(a5)
	bne	blitterwait11

	jsr	commander
;move.w	#$0555,$dff180
	jmp	intback
;*****



intcom8:	;empty to move 4 planes-logo/clines
cmp.w	#8,d0
bne	intcom9
	jsr	switchplanes
	jsr	scroller
	jsr	coppercopy2
	jsr	coppercopy7
	jsr	coppercopy4
	jsr	mt_music
	jsr	commander
	jmp	intback
;*****

intcom9:
cmp.w	#9,d0
bne	intcom10
	jsr	switchplanes
	jsr	scroller
	jsr	coppercopy5
	jsr	coppercopy3
	jsr	coppercopy4
	jsr	mt_music
	jsr	commander
	jmp	intback
;*****

intcom10:	;keil-effect
cmp.w	#10,d0
bne	intcom11
;jsr	switchplanes
jsr	scroller
jsr	realfade
jsr	coppercopy2	;logo
jsr	coppercopy6
jsr	coppercopy4	;scroller
jsr	mt_music
jsr	planecalc
lea	$dff000,a5
;move.w	#$0555,$dff180
	jsr	commander
;move.w	#$0555,$dff180
	jmp	intback
;*****

intcom11:	;vectorbobs
cmp.w	#11,d0
bne	intcom12
	jsr	scroller
	jsr	switchplanes
	jsr	realfade
jsr	planecls4
;;	jsr	coppercopy2	;logo
	jsr	coppercopy8
;	jsr	coppercopy4	;scroller
	jsr	mt_music
;move.w	#$0f00,$dff180
jsr	turner	;(tina??)
	jsr	commander
;move.w	#$0ff0,$dff180
;move.w	#$0,$dff180
lea	$dff000,a5
blitterwait12:	btst	#14,dmaconr(a5)
bne	blitterwait12
;move.w	#$000f,$dff180
jsr	drawbobs3
;move.w	#$0,$dff180

blitterwait123:	btst	#14,dmaconr(a5)
bne	blitterwait123

	jmp	intback
;*****


intcom12:	;nothing, first logo
cmp.w	#12,d0
bne	intcom13
;	jsr	scroller
	jsr	mt_music
	jsr	realfade
	lea	faded,a0
	lea	$dff180,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0),(a1)
	jsr	commander
jmp	intback
;*****

intcom13:
cmp.w	#13,d0
bne	intcom14
	jsr	coppercopy9
;	jsr	scroller
	jsr	mt_music
	jsr	realfade
	lea	faded,a0
	lea	$dff180,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0),(a1)
	jsr	commander
jmp	intback
;*****

intcom14:	;nothing, first logo
cmp.w	#14,d0
bne	intcom15
	jsr	mt_music
	jsr	realfade
	lea	faded,a0
move.w	(a0)+,cline1
move.w	(a0)+,cline2
move.w	(a0)+,cline3
move.w	(a0)+,cline4
move.w	(a0)+,cline5
move.w	(a0),cline6
jsr	coppercopy5
jsr	coppercopy4
	jsr	commander
jmp	intback
;*****

intcom15:	;empty to move 4 planes-logo/clines
cmp.w	#15,d0
bne	intcom16
	jsr	switchplanes
	jsr	scroller
	jsr	coppercopy2
	jsr	coppercopy11
	jsr	coppercopy4
	jsr	mt_music
	jsr	commander
	jmp	intback
;*****


intcom16:	;vectorbobs
cmp.w	#16,d0
bne	intcom17
	jsr	scroller
	jsr	switchplanes
	jsr	realfade
jsr	planecls5
;;	jsr	coppercopy2	;logo
	jsr	coppercopy12
;	jsr	coppercopy4	;scroller
	jsr	mt_music
;move.w	#$0f00,$dff180
jsr	turner	;(tina??)
	jsr	commander
;move.w	#$0ff0,$dff180
;move.w	#$0,$dff180
lea	$dff000,a5
blitterwait312:	btst	#14,dmaconr(a5)
bne	blitterwait312
;move.w	#$000f,$dff180
;jsr	drawbobs4
jsr	drawline
;move.w	#$0,$dff180

	subq.w	#1,linemaskcount
	bne	nomaskchange3
	move.w	linemasksleep,linemaskcount
	move.w	linemask,d0
	lsl.w	#1,d0
	bset	#0,d0
	move.w	d0,linemask
nomaskchange3:

blitterwait133:	btst	#14,dmaconr(a5)
bne	blitterwait133

	jmp	intback
;*****

com17flag:	dc.w	0
linemask:	dc.w	0
linemasksleep:	dc.w	5
linemaskcount:	dc.w	1

intcom17:
cmp.w	#17,d0
bne	intcom18
	jsr	mt_music
	tst.w	com17flag
	bne	intback

	jsr	switchplanes
	jsr	coppercopy12
	move.w	#1,com17flag
;	jsr	commander
	subq.w	#1,linemaskcount
	bne	nomaskchange1
	move.w	linemasksleep,linemaskcount
	move.w	linemask,d0
	lsl.w	#1,d0
	bset	#0,d0
	move.w	d0,linemask
nomaskchange1:
	jmp	intback
	
;*****

intcom18:
cmp.w	#18,d0
bne	intcom19
	jsr	mt_music
	tst.w	com17flag
	bne	intback

	jsr	switchplanes
	jsr	coppercopy12
	move.w	#1,com17flag
;	jsr	commander
	subq.w	#1,linemaskcount
	bne	nomaskchange2
	move.w	linemasksleep,linemaskcount
	move.w	linemask,d0
	lsl.w	#1,d0
	bclr	#0,d0
	move.w	d0,linemask
nomaskchange2:
	jmp	intback
	
;*****

intcom19:	;textrout1
cmp.w	#19,d0
bne	intcom20
lea	$dff000,a5

blitterwait1112:	btst	#14,dmaconr(a5)
bne	blitterwait1112
jsr	planecls7


	jsr	coppercopy2	;logo
	jsr	switchplanes
	jsr	coppercopy13

	jsr	drawstars
;	jsr	coppercopy14
	jsr	coppercopy4	;scroller
	jsr	realfade
	jsr	mt_music


;move.w	#$0003,$dff180
lea	$dff000,a5
blitterwait3112:	btst	#14,dmaconr(a5)
bne	blitterwait3112
move.w	#$0,$dff180
	jsr	scroller

lea	$dff000,a5

	jsr	commander

blitterwait11123:	btst	#14,dmaconr(a5)
bne	blitterwait11123

	jmp	intback
;*****




intcom20:
lastcommand:
move.l	#0,$dff180
move.l	#0,$dff184
move.l	#0,$dff188
move.l	#0,$dff18c
move.l	#0,$dff190
move.l	#0,$dff194
move.l	#0,$dff198
move.l	#0,$dff19c
move.l	#0,$dff1a0
move.l	#0,$dff1a4
move.l	#0,$dff1a8
move.l	#0,$dff1ac
move.l	#0,$dff1b0
move.l	#0,$dff1b4
move.l	#0,$dff1b8
move.l	#0,$dff1bc
jsr	commander
jmp	intback


;**********************************************************




;**********************************************************

;jsr	switchplanes
;move.w	#0,$dff180
;jsr	planecls
;jsr	movescrleft
;blitterwait4:	btst	#14,dmaconr(a5)
;bne	blitterwait4
;move.w	#$0005,$dff180
;jsr	drawbobs
;move.w	#777,$dff180



intback:
;move.w	#$0fff,$dff180
;move.w	#$0,$dff180

blitterwait7:
	btst	#14,dmaconr(a5)
	bne	blitterwait7
	movem.l	(a7)+,d0-d7/a0-a6
	move.w	#%0000000001100000,$dff09c	;clear intflags
	rte					;return from exeption
;**********************************************************************
pcsinpoint1:	dc.w	0
pcsinpoint2:	dc.w	0
pccolours:
dc.w	$0000,$0c36,$0c47,$0c58,$0c69,$0c7a,$0c8b,$0c9c
dc.w	$0cad,$0bbd,$0aad,$099d,$088d,$077d,$066d,$055d
pcdata:
dc.l	%10101010101010110000000000000000
dc.l	%01100110011001110000000000000000
dc.l	%00011110000111110000000000000000
dc.l	%00000001111111110000000000000000
dc.l	%00000000000000001111111111111111
dc.l	0,0,0

dc.l	%01010101010101011000000000000000
dc.l	%00110011001100111000000000000000
dc.l	%00001111000011111000000000000000
dc.l	%00000000111111111000000000000000
dc.l	%10000000000000000111111111111111
dc.l	0,0,0

dc.l	%00101010101010101100000000000000
dc.l	%00011001100110011100000000000000
dc.l	%00000111100001111100000000000000
dc.l	%00000000011111111100000000000000
dc.l	%11000000000000000011111111111111
dc.l	0,0,0

dc.l	%00010101010101010110000000000000
dc.l	%00001100110011001110000000000000
dc.l	%00000011110000111110000000000000
dc.l	%00000000001111111110000000000000
dc.l	%11100000000000000001111111111111
dc.l	0,0,0

dc.l	%00001010101010101011000000000000
dc.l	%00000110011001100111000000000000
dc.l	%00000001111000011111000000000000
dc.l	%00000000000111111111000000000000
dc.l	%11110000000000000000111111111111
dc.l	0,0,0

dc.l	%00000101010101010101100000000000
dc.l	%00000011001100110011100000000000
dc.l	%00000000111100001111100000000000
dc.l	%00000000000011111111100000000000
dc.l	%11111000000000000000011111111111
dc.l	0,0,0

dc.l	%00000010101010101010110000000000
dc.l	%00000001100110011001110000000000
dc.l	%00000000011110000111110000000000
dc.l	%00000000000001111111110000000000
dc.l	%11111100000000000000001111111111
dc.l	0,0,0

dc.l	%00000001010101010101011000000000
dc.l	%00000000110011001100111000000000
dc.l	%00000000001111000011111000000000
dc.l	%00000000000000111111111000000000
dc.l	%11111110000000000000000111111111
dc.l	0,0,0

dc.l	%00000000101010101010101100000000
dc.l	%00000000011001100110011100000000
dc.l	%00000000000111100001111100000000
dc.l	%00000000000000011111111100000000
dc.l	%11111111000000000000000011111111
dc.l	0,0,0

dc.l	%00000000010101010101010110000000
dc.l	%00000000001100110011001110000000
dc.l	%00000000000011110000111110000000
dc.l	%00000000000000001111111110000000
dc.l	%11111111100000000000000001111111
dc.l	0,0,0

dc.l	%00000000001010101010101011000000
dc.l	%00000000000110011001100111000000
dc.l	%00000000000001111000011111000000
dc.l	%00000000000000000111111111000000
dc.l	%11111111110000000000000000111111
dc.l	0,0,0

dc.l	%00000000000101010101010101100000
dc.l	%00000000000011001100110011100000
dc.l	%00000000000000111100001111100000
dc.l	%00000000000000000011111111100000
dc.l	%11111111111000000000000000011111
dc.l	0,0,0

dc.l	%00000000000010101010101010110000
dc.l	%00000000000001100110011001110000
dc.l	%00000000000000011110000111110000
dc.l	%00000000000000000001111111110000
dc.l	%11111111111100000000000000001111
dc.l	0,0,0

dc.l	%00000000000001010101010101011000
dc.l	%00000000000000110011001100111000
dc.l	%00000000000000001111000011111000
dc.l	%00000000000000000000111111111000
dc.l	%11111111111110000000000000000111
dc.l	0,0,0

dc.l	%00000000000000101010101010101100
dc.l	%00000000000000011001100110011100
dc.l	%00000000000000000111100001111100
dc.l	%00000000000000000000011111111100
dc.l	%11111111111111000000000000000011
dc.l	0,0,0

dc.l	%00000000000000010101010101010110
dc.l	%00000000000000001100110011001110
dc.l	%00000000000000000011110000111110
dc.l	%00000000000000000000001111111110
dc.l	%11111111111111100000000000000001
dc.l	0,0,0


planecalc:
move.l	thisplane,a0
moveq	#0,d0
moveq	#9,d1

planecalcl4:
move.l	d0,192(a0)
move.l	d0,128(a0)
move.l	d0,64(a0)
move.l	d0,(a0)+
dbf	d1,planecalcl4


move.l	thisplane,a0
lea	64(a0),a1
lea	64(a1),a2
lea	64(a2),a3

move.w	pcsinpoint1,a4
addq.w	#4,a4
cmp.w	#720,a4
bne	planecalcl5
move.w	#0,a4
planecalcl5:
move.w	a4,pcsinpoint1
lea	sin2,a4
add.w	pcsinpoint1,a4

move.w	pcsinpoint2,a5
addq.w	#6,a5
cmp.w	#720,a5
bne	planecalcl6
move.w	#0,a5
planecalcl6:
move.w	a5,pcsinpoint2
lea	sin2,a5
add.w	pcsinpoint2,a5


moveq	#99,d5
planecalcl1:
cmp.w	#$48d0,$dff006
ble	planecalcl1

planecalcl3:

move.w	(a4)+,d4
add.w	(a5)+,d4
move.w	d4,d7
lsr.w	#3,d4
bclr	#0,d4
and.w	#%0000000000001111,d7

lsl.w	#5,d7
lea	pcdata,a6
movem.l	(a6,d7.w),d0-d3/d6

move.l	(a0,d4.w),d7
and.l	d6,d7
or.l	d7,d0

move.l	(a1,d4.w),d7
and.l	d6,d7
or.l	d7,d1

move.l	(a2,d4.w),d7
and.l	d6,d7
or.l	d7,d2

move.l	(a3,d4.w),d7
and.l	d6,d7
or.l	d7,d3

planecalcl2:
cmp.b	#$d0,$dff007
ble	planecalcl2

move.l	d0,(a0,d4.w)
move.l	d1,(a1,d4.w)
move.l	d2,(a2,d4.w)
move.l	d3,(a3,d4.w)

add.l	pcalcval1,a4
add.l	pcalcval2,a5

move.w	(a4)+,d4
add.w	(a5)+,d4
move.w	d4,d7
lsr.w	#3,d4
bclr	#0,d4
and.w	#%0000000000001111,d7

lsl.w	#5,d7
lea	pcdata,a6
add.w	d7,a6
movem.l	(a6),d0-d3/d6

move.l	(a0,d4.w),d7
and.l	d6,d7
or.l	d7,d0

move.l	(a1,d4.w),d7
and.l	d6,d7
or.l	d7,d1

move.l	(a2,d4.w),d7
and.l	d6,d7
or.l	d7,d2

move.l	(a3,d4.w),d7
and.l	d6,d7
or.l	d7,d3

planecalcl7:
cmp.b	#$d0,$dff007
ble	planecalcl7

move.l	d0,(a0,d4.w)
move.l	d1,(a1,d4.w)
move.l	d2,(a2,d4.w)
move.l	d3,(a3,d4.w)

;addq.l	#4,a4
;addq.l	#2,a5
;sub.l	#360-6,a4
;sub.l	#110-2,a5

add.l	pcalcval3,a4
add.l	pcalcval4,a5


dbf	d5,planecalcl3
rts

pcalcval1:	dc.l	0
pcalcval2:	dc.l	0
pcalcval3:	dc.l	0
pcalcval4:	dc.l	0
pcalcvalues:	dc.l	4,2,4,2,360,110,-354,-108
pcalcvpos:	dc.l	0

planecls3:
	lea	$dff000,a5
	move.w	#14,bltdmod(a5)
	move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
;	move.l	#%00000001111111110000000000000000,bltcon0(a5);bltcon0+1
	move.l	otherplane,d0
	add.l	#128*2,d0
	move.l	d0,bltdpth(a5)	;ziel
	move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
;move.w	#$ffff,bltddat(a5)
	move.w	#$2c99,bltsize(a5)	;l=25,	h=3*89
rts
;*****

bobcod:
dc.w$0380,$0000,$0380,$0000,$0380,$0000,$0FE0,$0000,$0FE0,$0000,$0FE0,$0000
dc.w $1FF0,$0000,$1FF0,$0000,$1FF0,$0000,$3FF8,$0000,$3FF8,$0000,$3FF8,$0000
dc.w $7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000
dc.w $FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000
dc.w $FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000
dc.w $7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$3FF8,$0000,$3FF8,$0000,$3FF8,$0000
dc.w $1FF0,$0000,$1FF0,$0000,$1FF0,$0000,$0FE0,$0000,$0FE0,$0000,$0FE0,$0000
dc.w $0380,$0000,$0380,$0000,$0380,$0000,$0000,$0000,$0000,$0000,$0000,$0000

dc.w$0380,$0000,$0380,$0000,$0380,$0000,$0FE0,$0000,$0FE0,$0000,$0FE0,$0000
dc.w $1FF0,$0000,$1FF0,$0000,$1FF0,$0000,$3FF8,$0000,$3FF8,$0000,$3FF8,$0000
dc.w $7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000
dc.w $FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$FFFE,$0000
dc.w $FFFE,$0000,$FFFE,$0000,$FFFE,$0000,$7FFC,$0000,$7FFC,$0000,$7FFC,$0000
dc.w $7FFC,$0000,$7FFC,$0000,$7FFC,$0000,$3FF8,$0000,$3FF8,$0000,$3FF8,$0000
dc.w $1FF0,$0000,$1FF0,$0000,$1FF0,$0000,$0FE0,$0000,$0FE0,$0000,$0FE0,$0000
dc.w $0380,$0000,$0380,$0000,$0380,$0000,$0000,$0000,$0000,$0000,$0000,$0000


bobdat:
dc.w$0380,$0,$0000,$0,$0000,$0,$0EE0,$0,$0100,$0,$0000,$0,$1830,$0
dc.w $07C0,$0,$0000,$0,$3018,$0,$0FE0,$0,$0000,$0,$638C,$0,$1FF0,$0
dc.w $0000,$0,$47C4,$0,$3FF8,$0,$0000,$0,$CFE6,$0,$3FF8,$0,$0000,$0
dc.w $8FE2,$0,$7FFC,$0,$0000,$0,$CFE6,$0,$3FF8,$0,$0000,$0,$47C4,$0
dc.w $3FF8,$0,$0000,$0,$638C,$0,$1FF0,$0,$0000,$0,$3018,$0,$0FE0,$0
dc.w $0000,$0,$1830,$0,$07C0,$0,$0000,$0,$0EE0,$0,$0100,$0,$0000,$0
dc.w $0380,$0,$0000,$0,$0000,$0,$0000,$0,$0000,$0,$0000,$0
dc.w$0000,$0,$0000,$0,$0380,$0,$0100,$0,$0000,$0,$0FE0,$0,$07C0,$0
dc.w $0000,$0,$1FF0,$0,$0FE0,$0,$0000,$0,$3FF8,$0,$1C70,$0,$0380,$0
dc.w $7FFC,$0,$3838,$0,$07C0,$0,$7FFC,$0,$3018,$0,$0FE0,$0,$FFFE,$0
dc.w $701C,$0,$0FE0,$0,$FFFE,$0,$3018,$0,$0FE0,$0,$FFFE,$0,$3838,$0
dc.w $07C0,$0,$7FFC,$0,$1C70,$0,$0380,$0,$7FFC,$0,$0FE0,$0,$0000,$0
dc.w $3FF8,$0,$07C0,$0,$0000,$0,$1FF0,$0,$0100,$0,$0000,$0,$0FE0,$0
dc.w $0000,$0,$0000,$0,$0380,$0,$0000,$0,$0000,$0,$0000,$0

d3bobquant:	dc.w	25
kx:	dc.w	0
ky:	dc.w	0
kz:	dc.w	110

drawbobs3:
	move.w	switchmark,d0
	beq	weiter
	move.w	kx,d0
	beq	weiter
	subq.w	#1,d0

weiter:
		lea	$dff000,a5
		move.l	#$00240000,bltcmod(a5)	;bltcmod & bltbmod !
		move.l	#$00000024,bltamod(a5)	;bltamod & bltdmod !
move.l		#%11111111111111110000000000000000,bltafwm(a5)	;bltafwm+bltalwm !!!

	move.w	d3bobquant,d3

drawbobs3l1:
	move.l	turnkoord,a1	;koordinatenadresse
	move.l	a1,a6	;koordinatenadresse
;	moveq	#0,d4
	move.w	d3bobquant,d4
	move.l	#$7fff,d5	;groesster positiver wert
sortloop:
	cmp.w	6(a1),d5	;aktuelle z-koord kleiner als flag ?
	blt	sortl1
	move.l	a1,a6		;ja, dann koordpoint merken...
	move.w	6(a1),d5	;...und aktuelle als flag
sortl1:
	addq.l	#8,a1		;next field
	dbf	d4,sortloop	;alle z-koords durch

	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d0
	move.w	2(a6),d1	;x
	move.w	4(a6),d2	;y
	move.w	d5,d0		;z
	move.w	#$7fff,6(a6)	;z-koord auf groesstmoeglichen wert

	move.w	0(a6),a6	;boboffset (which gfx)




	moveq	#0,d4		;loeschen
	moveq	#0,d5		;loeschen

	move.w	d1,d5		;d5=px
	move.w	kx,d4		;d4=kx
	sub.w	d4,d5		;d5=px-kx
	sub.w	kz,d4		;d4=kx-kz
	muls	d4,d5		;d5=(kx-kz)*(px-kx)

	move.l	d0,d4		;d4=pz
	sub.w	kz,d4		;d4=pz-kz
	move.l	d4,d6		;d6=pz-kz (merken fuer y-koord)
	divs	d6,d5		;d5=(kx-kz)*(px-kx)/(pz-kz)
	move.w	d5,d1		;x-koord (perspective!)


	moveq	#0,d4		;loeschen
	moveq	#0,d5		;loeschen

	move.w	d2,d5		;d5=py
	move.w	ky,d4		;d4=ky
	sub.w	d4,d5		;d5=py-ky
	sub.w	kz,d4		;d4=ky-kz
	muls	d4,d5		;d5=(ky-kz)*(py-ky)

	divs	d6,d5		;d5=(ky-kz)*(py-ky)/(pz-kz)
	move.w	d5,d2		;y-koord (perspective!)


	add.w	#150,d1		;screen-offset x
	add.w	#70,d2		;screen-offset y


	addq.l	#8,a1

	move.w	d1,d4
	lsr.w	#4,d1			;x/16=wordoffset
	and.w	#%0000000000001111,d4	;scrollbits...
	ror.w	#4,d4			;...rotate to highbits...
	move.w	d4,d6			;...copy...
	or.w	#%0000111111110010,d6	;...set miniterms...
	swap	d6			;...word on highword...
	move.w	d4,d6			;...and word!!!

	mulu	#120,d2

	move.l	otherplane,a0		;planeadresse laden
	add.l	#40*100*3,a0

	add.w	d1,d1
	add.l	d1,a0
	add.l	d2,a0

	move.l	a0,bltdpth(a5)		;ziel=scrstart+offsetdat
	move.l	a0,bltcpth(a5)

	lea	bobdat,a4
	add.l	a6,a4	
	move.l	a4,bltapth(a5)	;quelle=bobdata
	lea	bobcod,a4
	add.l	a6,a4	
	move.l	a4,bltbpth(a5)	;data

	move.l	d6,bltcon0(a5)	;bltcon0&bltcon1

	move.w	#3074,bltsize(a5)	;h=250,l=21 (blitter starten);

;blitterwait16:	btst	#14,dmaconr(a5)
;bne	blitterwait16

dbf	d3,drawbobs3l1
rts

;*****




turnx:	dc.w	1
turny:	dc.w	1
turnz:	dc.w	1
bkoord:
dc.w 0, 9, 28,-50
dc.w 0, 9, 28,-25
dc.w 0, 9, 28, 0
dc.w 0, 9, 28, 25
dc.w 0, 9, 28, 50
dc.w 0,-25, 17,-50
dc.w 0,-25, 17,-25
dc.w 0,-25, 17, 0
dc.w 0,-25, 17, 25
dc.w 0,-25, 17, 50
dc.w 0,-25,-18,-50
dc.w 0,-25,-18,-25
dc.w 0,-25,-18, 0
dc.w 0,-25,-18, 25
dc.w 0,-25,-18, 50
dc.w 0, 9,-29,-50
dc.w 0, 9,-29,-25
dc.w 0, 9,-29, 0
dc.w 0, 9,-29, 25
dc.w 0, 9,-29, 50
dc.w 0, 30, 0,-50
dc.w 0, 30, 0,-25
dc.w 0, 30, 0, 0
dc.w 0, 30, 0, 25
dc.w 0, 30, 0, 50
dc.w	192,0,0,50

bskoord:
dc.w 0, 9, 28,-50
dc.w 0, 9, 28,-25
dc.w 0, 9, 28, 0
dc.w 0, 9, 28, 25
dc.w 0, 9, 28, 50
dc.w 0,-25, 17,-50
dc.w 0,-25, 17,-25
dc.w 0,-25, 17, 0
dc.w 0,-25, 17, 25
dc.w 0,-25, 17, 50
dc.w 0,-25,-18,-50
dc.w 0,-25,-18,-25
dc.w 0,-25,-18, 0
dc.w 0,-25,-18, 25
dc.w 0,-25,-18, 50
dc.w 0, 9,-29,-50
dc.w 0, 9,-29,-25
dc.w 0, 9,-29, 0
dc.w 0, 9,-29, 25
dc.w 0, 9,-29, 50
dc.w 0, 30, 0,-50
dc.w 0, 30, 0,-25
dc.w 0, 30, 0, 0
dc.w 0, 30, 0, 25
dc.w 0, 30, 0, 50
dc.w	0,0,0,50


bskoord2:
dc.w 0,-20,-20,-40
dc.w 0, 20,-20,-40
dc.w 0, 20, 20,-40
dc.w 0,-20, 20,-40
dc.w 0,-20,-20,-20
dc.w 0, 20,-20,-20
dc.w 0, 20, 20,-20
dc.w 0,-20, 20,-20
dc.w 0,-20,-20, 20
dc.w 0, 20,-20, 20
dc.w 0, 20, 20, 20
dc.w 0,-20, 20, 20
dc.w 0,-20,-20, 40
dc.w 0, 20,-20, 40
dc.w 0, 20, 20, 40
dc.w 0,-20, 20, 40
dc.w 0,-31, 0, 0
dc.w 0,-24, 0, 0
dc.w 0,-17, 0, 0
dc.w 0,-10, 0, 0
dc.w 0,-3, 0, 0
dc.w 0, 4, 0, 0
dc.w 0, 11, 0, 0
dc.w 0, 18, 0, 0
dc.w 0, 25, 0, 0
dc.w 0, 32, 0, 0

bkoord2:
dc.w 0,-20,-20,-40
dc.w 0, 20,-20,-40
dc.w 0, 20, 20,-40
dc.w 0,-20, 20,-40
dc.w 0,-20,-20,-20
dc.w 0, 20,-20,-20
dc.w 0, 20, 20,-20
dc.w 0,-20, 20,-20
dc.w 0,-20,-20, 20
dc.w 0, 20,-20, 20
dc.w 0, 20, 20, 20
dc.w 0,-20, 20, 20
dc.w 0,-20,-20, 40
dc.w 0, 20,-20, 40
dc.w 0, 20, 20, 40
dc.w 0,-20, 20, 40
dc.w 192,-31, 0, 0
dc.w 192,-24, 0, 0
dc.w 192,-17, 0, 0
dc.w 192,-10, 0, 0
dc.w 192,-3, 0, 0
dc.w 192, 4, 0, 0
dc.w 192, 11, 0, 0
dc.w 192, 18, 0, 0
dc.w 192, 25, 0, 0
dc.w 192, 32, 0, 0


koord:
dc.w  0,-28, 0,-35
dc.w  0,-28, 19,-29
dc.w  0,-28, 31,-14
dc.w  0,-28, 33, 5
dc.w  0,-29, 25, 22
dc.w  0,-29, 9, 33
dc.w  0,-29,-11, 32
dc.w  0,-29,-27, 22
dc.w  0,-28,-35, 4
dc.w  0,-28,-31,-15
dc.w  0,-28,-19,-30
dc.w  0,-28, 0, 0
dc.w  0,-14, 0, 0
dc.w  192, 14, 0, 0
dc.w  192, 28, 0, 0
dc.w  192, 28, 0,-35
dc.w  192, 28, 19,-29
dc.w  192, 28, 31,-14
dc.w  192, 28, 33, 5
dc.w  192, 27, 25, 22
dc.w  192, 27, 9, 33
dc.w  192, 27,-11, 32
dc.w  192, 27,-27, 22
dc.w  192, 28,-35, 4
dc.w  192, 28,-31,-15
dc.w  192, 28,-19,-30


dc.w  0,-28, 0,-35
dc.w  0,-28, 19,-29
dc.w  0,-28, 31,-14
dc.w  0,-28, 33, 5
dc.w  0,-29, 25, 22
dc.w  0,-29, 9, 33
dc.w  0,-29,-11, 32
dc.w  0,-29,-27, 22
dc.w  0,-28,-35, 4
dc.w  0,-28,-31,-15
dc.w  0,-28,-19,-30
dc.w  0,-28, 0, 0
dc.w  0,-14, 0, 0
dc.w  192, 14, 0, 0
dc.w  192, 28, 0, 0
dc.w  192, 28, 0,-35
dc.w  192, 28, 19,-29
dc.w  192, 28, 31,-14
dc.w  192, 28, 33, 5
dc.w  192, 27, 25, 22
dc.w  192, 27, 9, 33
dc.w  192, 27,-11, 32
dc.w  192, 27,-27, 22
dc.w  192, 28,-35, 4
dc.w  192, 28,-31,-15
dc.w  192, 28,-19,-30


scrkoord:
dc.w  0,-28, 0,-35
dc.w  0,-28, 19,-29
dc.w  0,-28, 31,-14
dc.w  0,-28, 33, 5
dc.w  0,-29, 25, 22
dc.w  0,-29, 9, 33
dc.w  0,-29,-11, 32
dc.w  0,-29,-27, 22
dc.w  0,-28,-35, 4
dc.w  0,-28,-31,-15
dc.w  0,-28,-19,-30
dc.w  0,-28, 0, 0
dc.w  0,-14, 0, 0
dc.w  0, 14, 0, 0
dc.w  0, 28, 0, 0
dc.w  0, 28, 0,-35
dc.w  0, 28, 19,-29
dc.w  0, 28, 31,-14
dc.w  0, 28, 33, 5
dc.w  0, 27, 25, 22
dc.w  0, 27, 9, 33
dc.w  0, 27,-11, 32
dc.w  0, 27,-27, 22
dc.w  0, 28,-35, 4
dc.w  0, 28,-31,-15
dc.w  0, 28,-19,-30


dc.w  0,-28, 0,-35
dc.w  0,-28, 19,-29
dc.w  0,-28, 31,-14
dc.w  0,-28, 33, 5
dc.w  0,-29, 25, 22
dc.w  0,-29, 9, 33
dc.w  0,-29,-11, 32
dc.w  0,-29,-27, 22
dc.w  0,-28,-35, 4
dc.w  0,-28,-31,-15
dc.w  0,-28,-19,-30
dc.w  0,-28, 0, 0
dc.w  0,-14, 0, 0
dc.w  0, 14, 0, 0
dc.w  0, 28, 0, 0
dc.w  0, 28, 0,-35
dc.w  0, 28, 19,-29
dc.w  0, 28, 31,-14
dc.w  0, 28, 33, 5
dc.w  0, 27, 25, 22
dc.w  0, 27, 9, 33
dc.w  0, 27,-11, 32
dc.w  0, 27,-27, 22
dc.w  0, 28,-35, 4
dc.w  0, 28,-31,-15
dc.w  0, 28,-19,-30


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

logocolour:	dc.l	0
logoplanesize:	dc.w	0

coppercopy6:	;middle screen keil-effect
	lea	copperlist,a0
	move.l	thisplane,d0	;logoplaneadr
	moveq	#64,d1	;planesize
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0

;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0

;plane 3
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0


	move.w	#diwstrt,(a0)+
	move.w	#$3081,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$30c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	move.l	#$01820fa0,(a0)+
	move.l	#$01840f60,(a0)+
	move.l	#$01860f20,(a0)+

	lea	faded,a1
	moveq	#15,d0
	move.w	#$0180,d1
coppercopy3l6:
	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d1
	dbf	d0,coppercopy3l6

	move.b	cbar1,d6		;bar1 pos
	add.b	#7,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0100000100000000,(a0)+



;move.l	#$530ffffe,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#-40,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#-40,(a0)+

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+

;move.l	#$fffffffe,(a0)

rts

coppercopy8:	;middle screen vectorbobs-effect
	lea	copperlist,a0
;set middlescreen
	move.l	thisplane,d0	;logoplaneadr
	add.l	#40*100*3,d0
	move.l	#40,d1	;planesize

;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0

;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0


move.w	#diwstrt,(a0)+
move.w	#$2581,(a0)+
move.w	#diwstop,(a0)+
move.w	#$29c1,(a0)+
move.w	#ddfstrt,(a0)+
move.w	#$0038,(a0)+
move.w	#ddfstop,(a0)+
move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
move.w	#bpl1mod,(a0)+
move.w	#80,(a0)+
move.w	#bpl2mod,(a0)+
move.w	#80,(a0)+



	lea	faded,a1
	move.w	#7,d0
	move.w	#$0180,d1
coppercopy8l6:
	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d1
	dbf	d0,coppercopy8l6


	move.b	cbar1,d6		;bar1 pos
	addq.b	#7,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0011001000000000,(a0)+



	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+

move.l	#$fffffffe,(a0)

rts

textsinpoints:	dc.w	0
text1add:	dc.w	0
coppercopy13:	;middle screen texter1
	lea	copperlist,a0
;set middlescreen
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+

move.w	#diwstrt,(a0)+
move.w	#$2981,(a0)+
move.w	#diwstop,(a0)+
move.w	#$29c1,(a0)+
move.w	#ddfstrt,(a0)+
move.w	#$0028,(a0)+
move.w	#ddfstop,(a0)+
move.w	#$00d0,(a0)+
	move.w	#bplcon2,(a0)+
;	move.w	#%0000000001000000,(a0)+
	move.w	#0,(a0)+
move.w	#bpl1mod,(a0)+
move.w	#116,(a0)+
move.w	#bpl2mod,(a0)+
move.w	#36,(a0)+
move.l	#$01800000,(a0)+
move.l	#$01820f00,(a0)+
move.l	#$01840900,(a0)+
move.l	#$01860500,(a0)+

move.w	#$0192,(a0)+
move.w	faded+2,(a0)+
move.w	#$0194,(a0)+
move.w	faded+4,(a0)+
move.w	#$0196,(a0)+
move.w	faded+6,(a0)+

	move.b	cbar1,d6		;bar1 pos
	addq.b	#7,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+


	move.l	starplane,d0	;logoplaneadr
	move.l	#40,d1	;planesize
;plane 1
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 3
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
;	move.w	#bplcon0,(a0)+
;	move.w	#%0100011000000000,(a0)+


	move.l	#plane1adr,d0	;logoplaneadr
	add.l	#160*15,d0
	move.l	#80,d1	;planesize
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0100011000000000,(a0)+




lea	logosin1,a4
move.w	textsinpoints,d2
cmp.w	#414,d2
beq	coppercopy13l1

add.w	text1add,d2
cmp.w	#logosin1end-logosin1,d2
bne	coppercopy13l1
moveq	#0,d2
move.w	#0,logosinadd1
coppercopy13l1:
move.w	d2,textsinpoints


move.w	#$6b0f,d6
move.l	#plane1adr,d4	;logoplaneadr
add.l	#160*15,d4

moveq	#6,d7
coppercopy13l2:

move.w	d6,(a0)+
move.w	#$fffe,(a0)+
;move.l	#$01800fff,(a0)+



moveq	#0,d5
;btst.l	#0,d7
;beq	coppercopy13l3
;move.w	#319,d5
;sub.w	0(a4,d2.w),d5
;bra	coppercopy13l4

coppercopy13l3:
move.w	0(a4,d2.w),d5
coppercopy13l4:
move.w	d5,d3
not.b	d3
and.w	#%0000000000001111,d3
lsr.w	#4,d5
add.w	d5,d5
;mulu.w	#17,d3

move.l	d4,d0
add.l	d5,d0

	move.l	#80,d1	;planesize
;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 2
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+


	move.w	#bplcon1,(a0)+
	move.w	d3,(a0)+

add.w	#$1600,d6
add.l	#160*22,d4
add.w	#8,d2
dbf	d7,coppercopy13l2

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+

move.l	#$fffffffe,(a0)
rts

;--------------

coppercopy14:		;middle screen stars
lea	copperlist,a0

	move.w	#diwstrt,(a0)+
	move.w	#$2981,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$29c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0028,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
move.w	#bpl1mod,(a0)+
move.w	#36,(a0)+
move.w	#bpl2mod,(a0)+
move.w	#36,(a0)+
move.w	#bplcon1,(a0)+
move.w	d3,(a0)+
move.l	#$01800000,(a0)+
move.l	#$01820f00,(a0)+
move.l	#$018400f0,(a0)+
move.l	#$0186000f,(a0)+

	move.b	cbar1,d6		;bar1 pos
	addq.b	#7,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+

	move.l	#plane2adr,d0	;logoplaneadr
	move.l	#40,d1	;planesize
;plane 1
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
	add.l	d1,d0
;plane 3
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0010001000000000,(a0)+

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+

move.l	#$fffffffe,(a0)
jsr	drawstars
rts

winrad:
dc.w  132, 85
dc.w  18, 35
dc.w  119, 122
dc.w  144, 111
dc.w  235, 128
dc.w  221, 62
dc.w  313, 109
dc.w  114, 5
dc.w  236, 8
dc.w  131, 40
dc.w  42, 127
dc.w  62, 32
dc.w  189, 63
dc.w  142, 58
dc.w  210, 139
dc.w  244, 85
dc.w  168, 1
dc.w  148, 113
dc.w  349, 22
dc.w  341, 67
dc.w  166, 55
dc.w  97, 145
dc.w  97, 45
dc.w  346, 53
dc.w  299, 144
dc.w  289, 133
dc.w  52, 3
dc.w  257, 75
dc.w  264, 44
dc.w  242, 146
dc.w  179, 40
dc.w  121, 57
dc.w  67, 42
dc.w  195, 135
dc.w  107, 32
dc.w  331, 140
dc.w  295, 118
dc.w  151, 148
dc.w  329, 83
dc.w  248, 142
dc.w  41, 59
dc.w  269, 45
dc.w  27, 43
dc.w  10, 128
dc.w  266, 47
dc.w  316, 34
dc.w  122, 61
dc.w  353, 67
dc.w  207, 114
dc.w  300, 20
dc.w  53, 94
dc.w  84, 55
dc.w  351, 71
dc.w  20, 147
dc.w  170, 1
dc.w  96, 61
dc.w  115, 14
dc.w  308, 106
dc.w  56, 50
dc.w  333, 17
dc.w  255, 97
dc.w  28, 17
dc.w  185, 78
dc.w  128, 70
dc.w  115, 101
dc.w  237, 126
dc.w  213, 102
dc.w  183, 150
dc.w  270, 98
dc.w  261, 75
dc.w  304, 18
dc.w  290, 106
dc.w  6, 4
dc.w  51, 45
dc.w  113, 17
dc.w  309, 21
dc.w  193, 150
dc.w  310, 54
dc.w  185, 116
dc.w  176, 27
dc.w  159, 73
dc.w  260, 26
dc.w  315, 2
dc.w  237, 69
dc.w  150, 41
dc.w  253, 138
dc.w  1, 36
dc.w  352, 134
dc.w  184, 22
dc.w  232, 143
dc.w  196, 57
dc.w  215, 91
dc.w  295, 105
dc.w  329, 61
dc.w  241, 103
dc.w  163, 53
dc.w  270, 122
dc.w  41, 90
dc.w  48, 87
dc.w  179, 82
dc.w  25, 34
dc.w  287, 68
dc.w  64, 137
dc.w  180, 82
dc.w  27, 12
dc.w  320, 146
dc.w  94, 90
dc.w  114, 104
dc.w  202, 73
dc.w  176, 85
dc.w  263, 137
dc.w  104, 149
dc.w  168, 55
dc.w  100, 141
dc.w  287, 64
dc.w  224, 31
dc.w  132, 116
dc.w  322, 116
dc.w  131, 1
dc.w  17, 122
dc.w  340, 45
dc.w  300, 79
dc.w  83, 49
dc.w  259, 84
dc.w  327, 26
dc.w  216, 61
dc.w  0, 124
dc.w  28, 87
dc.w  281, 57
dc.w  240, 122
dc.w  341, 76
dc.w  207, 92
dc.w  328, 49
dc.w  229, 135
dc.w  205, 38
dc.w  235, 126
dc.w  302, 137
dc.w  166, 94
dc.w  110, 75
dc.w  137, 57
dc.w  335, 6
dc.w  94, 105
dc.w  24, 2
dc.w  76, 56
dc.w  335, 65
dc.w  174, 12
dc.w  49, 48
dc.w  213, 46
dc.w  30, 130
dc.w  335, 102
dc.w  227, 55
dc.w  58, 148
dc.w  309, 62
dc.w  285, 150
dc.w  0, 132
dc.w  350, 13
dc.w  38, 58
dc.w  187, 106

dc.w  132, 22
dc.w  201, 105
dc.w  354, 143
dc.w  332, 51
dc.w  20, 101
dc.w  96, 102
dc.w  122, 9
dc.w  29, 105
dc.w  282, 103
dc.w  358, 55
dc.w  224, 98
dc.w  337, 63
dc.w  203, 5
dc.w  325, 24
dc.w  78, 92
dc.w  78, 99
dc.w  51, 3
dc.w  30, 110
dc.w  37, 93
dc.w  15, 115
dc.w  61, 92
dc.w  157, 52
dc.w  327, 122
dc.w  336, 67
dc.w  16, 107
dc.w  355, 116
dc.w  334, 95
dc.w  180, 130
dc.w  83, 48
dc.w  154, 105
dc.w  120, 73
dc.w  182, 88
dc.w  82, 12
dc.w  47, 111
dc.w  53, 36
dc.w  26, 58
dc.w  8, 56
dc.w  213, 23
dc.w  347, 82
dc.w  310, 114
dc.w  102, 136
dc.w  186, 29

drawstars:
lea	winrad,a2

move.w	#168,d4

drawstarsl2:

move.w	(a2),d0
addq.w	#1,d0
cmp.w	#360,d0
;ble	rotwink
bne	rotwink
sub.w	#360,d0
;moveq	#1,d0
rotwink:
move.w	d0,(a2)+

move.w	(a2),d0
addq.w	#1,d0
cmp.w	#160,d0
ble	rotrad
moveq	#5,d0
rotrad:
move.w	d0,(a2)+




	lea	sinus,a1	;sinus/cosinus

;lea	plane2adr,a0
;move.l	thisplane,a0
move.l	starplane,a0


moveq	#0,d1
moveq	#0,d2
moveq	#0,d5
moveq	#0,d6
move.w	-4(a2),d1
move.w	-2(a2),d2



add.w	d1,d1
add.w	d1,d1
move.w	2(a1,d1.w),d5	;d5 = cos z
;add.w	#360,d1
move.w	0(a1,d1.w),d6	;d6 = sin z
muls	d2,d5
muls	d2,d6
swap	d5
rol.l	#1,d5
swap	d6
rol.l	#1,d6


	move.l	#160,d1
	moveq	#90,d2
add.w	d5,d1
add.w	d6,d2


cmp.w	#1,d1
ble	drawstarsl4
cmp.w	#340,d1
bge	drawstarsl4

cmp.w	#10,d2
ble	drawstarsl4
cmp.w	#170,d2
bge	drawstarsl4


	mulu	#80,d2
	move.w	d1,d3
	lsr.w	#3,d1			;bytepos
	add.w	d2,d1
	not.b	d3
	and.b	#%00000111,d3	;bitpos

cmp.w	#50,-2(a2)
ble	drawstarsl5

	bset.b	d3,0(a0,d1.w)
drawstarsl5:
cmp.w	#100,-2(a2)
bge	drawstarsl4
	bset.b	d3,40(a0,d1.w)


drawstarsl4:
dbf	d4,drawstarsl2

rts


coppercopy12:	;middle screen vectorbobs-effect-equalized
	lea	copperlist,a0
;set middlescreen
	move.l	thisplane,d0	;logoplaneadr
	moveq	#40,d1	;planesize

;plane 0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+


	move.w	#diwstrt,(a0)+
	move.w	#$2581,(a0)+
	move.w	#diwstop,(a0)+
	move.w	#$29c1,(a0)+
	move.w	#ddfstrt,(a0)+
	move.w	#$0038,(a0)+
	move.w	#ddfstop,(a0)+
	move.w	#$00d0,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	#0,(a0)+
	move.w	#bplcon2,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	lea	faded,a1
	moveq	#1,d0
	move.w	#$0180,d1
coppercopy12l1:
	move.w	d1,(a0)+
	move.w	(a1)+,(a0)+
	addq.w	#2,d1
	dbf	d0,coppercopy12l1

;move.l	#$01820f00,(a0)+
	move.b	cbar1,d6		;bar1 pos
	addq.b	#7,d6
	move.b	d6,(a0)+		;wait for bar 1
	move.b	#$0f,(a0)+
	move.w	#$fffe,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0001001000000000,(a0)+

	move.l	#copperlist2,d0
	move.w	#cop1lcl,(a0)+
	move.w	d0,(a0)+
	move.w	#cop1lch,(a0)+
	swap	d0
	move.w	d0,(a0)+
	move.w	#copjmp1,(a0)+
	move.w	#0,(a0)+
	move.l	#$fffffffe,(a0)
	rts

barpos:
dc.w  0, 20, 351, 20, 1, 20, 350, 20, 2, 20, 349, 20, 3, 20, 348, 20
dc.w  4, 20, 347, 20, 5, 20, 346, 20, 6, 20, 345, 20, 7, 20, 344, 20
dc.w  8, 20, 343, 20, 9, 20, 342, 20, 10, 20, 341, 20, 11, 20
dc.w  340, 20, 12, 20, 339, 20, 13, 20, 338, 20, 14, 20, 337, 20
dc.w  15, 20, 336, 20, 16, 20, 335, 20, 17, 20, 334, 20, 18, 20
dc.w  333, 20, 19, 20, 332, 20, 20, 20, 331, 20, 21, 20, 330, 20
dc.w  22, 20, 329, 20, 23, 20, 328, 20, 24, 20, 327, 20, 25, 20
dc.w  326, 20, 26, 20, 325, 20, 27, 20, 324, 20, 28, 20, 323, 20
dc.w  29, 20, 322, 20, 30, 20, 321, 20, 31, 20, 320, 20, 32, 20
dc.w  319, 20, 33, 20, 318, 20, 34, 20, 317, 20, 35, 20, 316, 20
dc.w  36, 20, 315, 20, 37, 20, 314, 20, 38, 20, 313, 20, 39, 20
dc.w  312, 20, 40, 20, 311, 20, 41, 20, 310, 20, 42, 20, 309, 20
dc.w  43, 20, 308, 20, 44, 20, 307, 20, 45, 20, 306, 20, 46, 20
dc.w  305, 20, 47, 20, 304, 20, 48, 20, 303, 20, 49, 20, 302, 20
dc.w  50, 20, 301, 20, 51, 20, 300, 20, 52, 20, 299, 20, 53, 20
dc.w  298, 20, 54, 20, 297, 20, 55, 20, 296, 20, 56, 20, 295, 20
dc.w  57, 20, 294, 20, 58, 20, 293, 20, 59, 20, 292, 20, 60, 20
dc.w  291, 20, 61, 20, 290, 20, 62, 20, 289, 20, 63, 20, 288, 20
dc.w  64, 20, 287, 20, 65, 20, 286, 20, 66, 20, 285, 20, 67, 20
dc.w  284, 20, 68, 20, 283, 20, 69, 20, 282, 20, 70, 20, 281, 20
dc.w  71, 20, 280, 20, 72, 20, 279, 20, 73, 20, 278, 20, 74, 20
dc.w  277, 20, 75, 20, 276, 20, 76, 20, 275, 20, 77, 20, 274, 20
dc.w  78, 20, 273, 20, 79, 20, 272, 20, 80, 20, 271, 20, 81, 20
dc.w  270, 20, 82, 20, 269, 20, 83, 20, 268, 20, 84, 20, 267, 20
dc.w  85, 20, 266, 20, 86, 20, 265, 20, 87, 20, 264, 20, 88, 20
dc.w  263, 20, 89, 20, 262, 20, 90, 20, 261, 20, 91, 20, 260, 20
dc.w  92, 20, 259, 20, 93, 20, 258, 20, 94, 20, 257, 20, 95, 20
dc.w  256, 20, 96, 20, 255, 20, 97, 20, 254, 20, 98, 20, 253, 20
dc.w  99, 20, 252, 20, 100, 20, 251, 20, 101, 20, 250, 20, 102, 20
dc.w  249, 20, 103, 20, 248, 20, 104, 20, 247, 20, 105, 20, 246, 20
dc.w  106, 20, 245, 20, 107, 20, 244, 20, 108, 20, 243, 20, 109, 20
dc.w  242, 20, 110, 20, 241, 20, 111, 20, 240, 20, 112, 20, 239, 20
dc.w  113, 20, 238, 20, 114, 20, 237, 20, 115, 20, 236, 20, 116, 20
dc.w  235, 20, 117, 20, 234, 20, 118, 20, 233, 20, 119, 20, 232, 20
dc.w  120, 20, 231, 20, 121, 20, 230, 20, 122, 20, 229, 20, 123, 20
dc.w  228, 20, 124, 20, 227, 20, 125, 20, 226, 20, 126, 20, 225, 20
dc.w  127, 20, 224, 20, 128, 20, 223, 20, 129, 20, 222, 20, 130, 20
dc.w  221, 20, 131, 20, 220, 20, 132, 20, 219, 20, 133, 20, 218, 20
dc.w  134, 20, 217, 20, 135, 20, 216, 20, 136, 20, 215, 20, 137, 20
dc.w  214, 20, 138, 20, 213, 20, 139, 20, 212, 20, 140, 20, 211, 20
dc.w  141, 20, 210, 20, 142, 20, 209, 20, 143, 20, 208, 20, 144, 20
dc.w  207, 20, 145, 20, 206, 20, 146, 20, 205, 20, 147, 20, 204, 20
dc.w  148, 20, 203, 20, 149, 20, 202, 20, 150, 20, 201, 20, 151, 20
dc.w  200, 20, 152, 20, 199, 20, 153, 20, 198, 20, 154, 20, 197, 20
dc.w  155, 20, 196, 20, 156, 20, 195, 20, 157, 20, 194, 20, 158, 20
dc.w  193, 20, 159, 20, 192, 20, 160, 20, 191, 20, 161, 20, 190, 20
dc.w  162, 20, 189, 20, 163, 20, 188, 20, 164, 20, 187, 20, 165, 20
dc.w  186, 20, 166, 20, 185, 20, 167, 20, 184, 20, 168, 20, 183, 20
dc.w  169, 20, 182, 20, 170, 20, 181, 20, 171, 20, 180, 20, 172, 20
dc.w  179, 20, 173, 20, 178, 20, 174, 20, 177, 20, 175, 20, 176, 20

clrallplanes:
	move.l	#plane1adr,a0
	move.l	#$4fb0-1,d0
clalpl1:
	move.l	#0,(a0)+
	dbf	d0,clalpl1
	rts
;*****

setallplanes:
	move.l	#plane1adr,a0
	move.l	#$4fb0-1,d0
sealpl1:
	move.l	#$ffffffff,(a0)+
	dbf	d0,sealpl1
	rts
;*****

;**********************************************************************
commands:
		dc.w	2,30	;logo1 on,fade all col white
		dc.w	3,15	;col0=black, other 15 white
		dc.w	4,100	;col=logo1col
		dc.w	5,100	;all col black
		dc.w	6,1	;logo2+logo3 on
		dc.w	7,50	;start logo2move
		dc.w	8,300	;start logo3move
		dc.w	9,200	;logo4 on, fade to logo4col
		dc.w	12,40	;fade 32 col white
		dc.w	5,100	;all col black

		dc.w	10,690	;start first gurke(scroller)
		dc.w	11,370	;rip
		dc.w	16,369	;neg bobspeed
		dc.w	13,370	;duke
		dc.w	16,369	;neg bobspeed
		dc.w	14,370	;ice cube
		dc.w	16,369	;neg bobspeed
		dc.w	15,370	;moon
		dc.w	16,368	;neg bobspeed

		dc.w	17,1400	;continue first scroll
		dc.w	21,150	;fade col 0-3 black
		dc.w	18,140	;stars to line
		dc.w	19,8	;fill line
		dc.w	20,100	;move line

	dc.w	24,45	;fade copperlines
		dc.w	22,600	;2planes mirrow cheated - pointroutine
		dc.w	26,206	;pointquant to 0 (neg adder)
		dc.w	26,206	;pointquant to max (neg adder)
		dc.w	26,206	;pointquant to 0 (neg adder)


		dc.w	23,60	;upperbar+scroll up
;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
dc.w	45,100		;logo8 down

dc.w	46,150
dc.w	47,650
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,650
dc.w	48,52
dc.w	49,200

dc.w	44,200		;logo up

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

		dc.w	28,45	;logo5+bar down
		dc.w	30,700	;effect2 (keil1)
		dc.w	31,150	;fade 16 col black speed 4
		dc.w	30,700	;effect2 (keil2)
		dc.w	31,150	;fade 16 col black speed 4
		dc.w	34,60	;upperbar+logo5 up
;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
dc.w	45,100		;logo8 down

dc.w	46,150
dc.w	47,650
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,650
dc.w	48,52
dc.w	49,200

dc.w	44,200		;logo up

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
		dc.w	29,55	;upperbar+logo6 down
		dc.w	33,600	;effect3 (vectorbobs)
		dc.w	31,100	;fade 16 col black speed 4
		dc.w	50,400	;effect3 (vectorbobs)
		dc.w	31,100	;fade 16 col black speed 4
		dc.w	51,600	;effect3 (vectorbobs)
		dc.w	31,100	;fade 16 col black speed 4
	dc.w	32,100	;move upperbar+logo6 up
;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
dc.w	45,100		;logo8 down

dc.w	46,150
dc.w	47,650
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,650
dc.w	48,52
dc.w	49,200

dc.w	44,200		;logo up

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.



dc.w	35,1000	;line 1 frame
dc.w	41,60
dc.w	52,1000	;line 1 frame
dc.w	41,60

dc.w	36,80
dc.w	37,300
dc.w	40,80
dc.w	38,300
dc.w	40,80
dc.w	39,300
dc.w	40,100
dc.w	42,150		;scroll up

;dc.w	45,100		;logo8 down
;dc.w	46,150
;dc.w	47,600
;dc.w	48,52
;;dc.w	49,200

;;dc.w	44,200		;logo up
;;dc.w	43,200		;logo7 down
;;dc.w	44,200		;logo up

;;dc.w	45,100		;logo8 down
;;dc.w	46,150
;dc.w	47,600
;dc.w	48,52
;dc.w	49,200



;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
dc.w	45,100		;logo8 down

dc.w	46,150
dc.w	47,700
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,700
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,700
dc.w	48,52
;dc.w	49,200

;dc.w	45,100		;logo8 down
;dc.w	46,150
dc.w	47,700
dc.w	48,52
dc.w	49,200


dc.w	44,200		;logo up

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

dc.w	44,55200		;logo up
		dc.w	100,2

		dc.w	0,0


commander:
sub.w	#1,sleeper
bne	backcom
move.l	#commands,a0		;basicadress of commands
move.w	compoint,d1		;pointer of actual command
move.w	0(a0,d1.w),d0		;actual command in d0
move.w	2(a0,d1.w),sleeper	;act counter for next command in sleeper
addq	#4,d1			;add offset-->pointer for next command
move.w	d1,compoint		;store pointer

com1:
cmp.w	#1,d0	;command 1?
bne	com2
	rts
;*****

com2:	;logo1 on, init fader, start fad as dcom
cmp.w	#2,d0
bne	com3
	move.w	#12,intcommand
	lea	$dff000,a5
	move.l	#%0,$dff144		;sprite 0 off
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.l	#0,bplcon1(a5)		;con1+2
	move.l	#0,bpl1mod(a5)		;mod1+2

	lea	copperlist,a0
	move.l	a0,cop1lch(a5)
	move.l	#logo1,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#4360,d0	
	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#4360,d0	
	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#4360,d0	
	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
	
	move.l	#$600ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0100001000000000,(a0)+
	move.l	#$cd0ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+

	move.l	#$fffffffe,(a0)+

	lea	tofade,a1
	move.l	#$0fff0fff,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.w	#0,fadecount
	move.w	#4,dircommand	;fader
	rts
;*****




com3:	;col0=black, other 15 white
cmp.w	#3,d0
bne	com4
	lea	tofade,a1
	move.l	#$0fff0fff,d0
	move.w	#0,(a1)+
	move.w	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.w	#1,fadecount
	move.w	#4,dircommand	;fader
	rts
;*****


com4:	;col = logo1col
cmp.w	#4,d0
bne	com5
	lea	logo1col,a0
	lea	tofade,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0),(a1)
	move.w	#2,fadecount
	move.w	#4,dircommand	;fader

	rts
;*****

com5:	;all col black
cmp.w	#5,d0
bne	com6
	lea	tofade,a1
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)
	move.w	#2,fadecount
	move.w	#4,dircommand	;fader
	rts
;*****

com6:
cmp.w	#6,d0	;logo2+3 on screen, intcom13
bne	com7
	move.w	#13,intcommand
	lea	$dff000,a5
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0028,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.l	#0,bplcon1(a5)		;con1+2
	move.l	#$00280028,bpl1mod(a5)	;mod1+2
	move.l	#copperlist,cop1lch(a5)
	rts
;*****

com7:			;logo2move on
cmp.w	#7,d0
bne	com8
	move.w	#2,logosinadd1
	rts
;*****



com8:			;logo3move on
cmp.w	#8,d0
bne	com9
	move.w	#2,logosinadd2
	rts
;*****


com9:
cmp.w	#9,d0	;
bne	com10
	move.w	#12,intcommand
	lea	$dff000,a5
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.l	#0,bplcon1(a5)		;con1+2
	move.l	#0,bpl1mod(a5)		;mod1+2

	lea	copperlist,a0
	move.l	a0,cop1lch(a5)
	move.l	#logo4,d0

	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#7800,d0	

	move.w	#bpl2ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl2pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#7800,d0	

	move.w	#bpl3ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl3pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#7800,d0	

	move.w	#bpl4ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl4pth,(a0)+
	move.w	d0,(a0)+
	swap	d0
add.l	#7800,d0	

	move.w	#bpl5ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl5pth,(a0)+
	move.w	d0,(a0)+

	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
	
	move.l	#$3c0ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0101001000000000,(a0)+
	move.l	#$ff0ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+

	move.l	#$fffffffe,(a0)+

	lea	tofade,a1
	lea	logo4col,a0
	move.w	#15,d0
com9l1:
	move.l	(a0)+,(a1)+
	dbf	d0,com9l1

	move.w	#3,fadecount
	move.w	#4,dircommand	;fader
	rts



com10:
cmp.w	#10,d0	;
bne	com11
	move.w	#1,intcommand
	lea	$dff000,a5
	move.l	#$fffffffe,copperlist
	clr.w	copjmp1(a5)
	move.w	#$2076,diwstrt(a5)
	move.w	#$30c9,diwstop(a5)
	move.w	#$0030,ddfstrt(a5)
	move.w	#$00d8,ddfstop(a5)
	move.w	#%0010001000000000,bplcon0(a5)
	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
	move.w	#4+52,bpl1mod(a5)
	move.w	#4+52,bpl2mod(a5)
	move.l	#%1,$dff144	;starpoint

	move.l	#gurke1,gurke
	move.w	#gurkend-gurke1-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord1,bobkoord
	move.l	#onscreenfont1,bobtext
	move.w	#12,bobquant
	move.w	#4,bobspeed
	move.w	#10*4,bobdiff
	move.w	#1,bscrollwait
	move.w	#1,scrpos
	move.w	#0,bscrolltextpos
	lea	tofade,a1
	move.w	#$0000,(a1)+
	move.w	#$0aaa,(a1)+
	move.w	#$0777,(a1)+
	move.w	#$0555,(a1)+
	moveq	#7,d0
	lea	starcol,a2
com10l1:
	move.l	(a2)+,(a1)+
	dbf	d0,com10l1
	move.w	#10,fadecount
	move.w	#4,dircommand
	rts
;*****


com11:
cmp.w	#11,d0	;
bne	com12
	move.w	#3,intcommand
	move.l	#gurke2,gurke
	move.w	#gurke2end-gurke2-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord2,bobkoord
	move.l	#onscreenfont2,bobtext
	move.w	#29+30+15,bobquant
	move.w	#8,bobspeed
	move.w	#2*4,bobdiff
	rts
;*****

com12:
cmp.w	#12,d0	;
bne	com13
	lea	tofade,a1
	move.l	#$0fff0fff,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.w	#1,fadecount
	move.w	#4,dircommand	;fader

	rts
;*****

com13:
cmp.w	#13,d0
bne	com14
	move.w	#3,intcommand
	move.l	#gurke2,gurke
	move.w	#gurke2end-gurke2-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord22,bobkoord
move.l	#onscreenfont3,bobtext
	move.w	#29+30+15,bobquant
	move.w	#8,bobspeed
	move.w	#5*4,bobdiff
	rts
;*****

com14:
cmp.w	#14,d0
bne	com15
	move.w	#3,intcommand
	move.l	#gurke2,gurke
	move.w	#gurke2end-gurke2-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord3,bobkoord
move.l	#onscreenfont4,bobtext
	move.w	#29+30+15,bobquant
	move.w	#8,bobspeed
	move.w	#3*4,bobdiff
	rts
;*****

com15:
cmp.w	#15,d0
bne	com16
	move.w	#3,intcommand
	move.l	#gurke2,gurke
	move.w	#gurke2end-gurke2-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord33,bobkoord
move.l	#onscreenfont5,bobtext
	move.w	#29+30+15,bobquant
	move.w	#8,bobspeed
	move.w	#5*4,bobdiff
	rts
;*****

com16:
cmp.w	#16,d0
bne	com17
	neg.w	bobspeed
	rts
;*****

com17:
cmp.w	#17,d0
bne	com18
	move.w	#1,intcommand
	move.l	#gurke1,gurke
	move.w	#gurkend-gurke1-4,gurklenght
	move.w	#0,gurkpoint
	move.l	#koord1,bobkoord
	move.l	#onscreenfont1,bobtext
	move.w	#12,bobquant
	move.w	#4,bobspeed
	move.w	#10*4,bobdiff
	move.w	#1,bscrollwait
	move.w	#1,scrpos
	rts
;*****

com18:
cmp.w	#18,d0
bne	com19
	move.w	#4,intcommand
	lea	barpos,a0
	move.l	#271,d0
	moveq	#0,d1
com18l1:
	move.w	(a0)+,d3	;overread x-koord
	move.w	d1,(a0)+	;write y-koord
	addq.w	#1,d1		;y(n)=y(n-1)+1
	dbf	d0,com18l1
	rts
;*****

com19:
cmp.w	#19,d0
bne	com20
	move.w	#5,intcommand
	rts
;*****

com20:
cmp.w	#20,d0
bne	com21
	move.w	#6,intcommand
	rts
;*****

com21:
cmp.w	#21,d0	;fade col 0-3 black
bne	com22
	lea	tofade,a1
	moveq	#3,d0
com21l1:
	move.w	#0,(a1)+
	dbf	d0,com21l1
	move.w	#6,fadecount
	jsr	fader
	rts
;*****

com22:
cmp.w	#22,d0
bne	com23
	move.w	#7,intcommand
	move.w	#2,dircommand
	rts
;*****

com23:
cmp.w	#23,d0
bne	com24
	move.b	#$20,cbar1m;2f
	move.w	#9,intcommand
	move.w	#2,dircommand
	rts
;*****

com24:
cmp.w	#24,d0
bne	com25
	move.w	#14,intcommand
	lea	$dff000,a5
	move.l	#$fffffffe,copperlist1
	move.l	#copperlist1,cop1lch(a5)
	clr.w	copjmp1(a5)
	jsr	coppercopy5
	jsr	coppercopy7
	jsr	coppercopy4
	lea	faded,a0
	move.w	#$060a,(a0)+
	move.l	#0,(a0)+
	move.w	#$060a,(a0)+
	move.l	#0,(a0)
	lea	tofade,a0
	move.w	#$0555,(a0)+
	move.w	#$0777,(a0)+
	move.w	#$0999,(a0)+
	move.w	#$005f,(a0)+
	move.w	#$0049,(a0)+
	move.w	#$0035,(a0)+
	move.w	#2,fadecount
	move.w	#4,dircommand
	rts
;*****

com25:
cmp.w	#25,d0	;	logo/effect/scroll-screen
bne	com26
	move.b	#$60,cbar1m
	move.b	#$12,cbar2m	;total down
	move.w	#8,intcommand
	move.w	#5,dircommand
;move.l	#logo22col,logocolour
move.w	#1920,logoplanesize
	rts
;*****

com26:
cmp.w	#26,d0	;	logo/effect/scroll-screen
bne	com27
move.w	pointadder,d0
neg.w	d0
move.w	d0,pointadder
	rts
;*****

com27:
cmp.w	#27,d0	;	logo/effect/scroll-screen
bne	com28
	move.b	#$7f,cbar1m
	move.b	#$12,cbar2m	;total down
	move.w	#8,intcommand
	move.w	#6,dircommand
;move.l	#logo33col,logocolour
move.w	#3360,logoplanesize
	rts
;*****
com28:
cmp.w	#28,d0
bne	com29
	move.b	#$43,cbar1m;43
	move.b	#$12,cbar2m	;total down
	move.w	#8,intcommand
	move.w	#7,dircommand
move.l	#logo5cop,logocolour
move.w	#760,logoplanesize
move.l	#logo5,toplogo
move.l	#pcalcvalues,pcalcvpos	;reset planecalculatevalueposition
	rts
;*****

com29:
cmp.w	#29,d0
bne	com30
	move.b	#$6d,cbar1m
	move.b	#$12,cbar2m	;total down
	move.w	#15,intcommand
	move.w	#8,dircommand
move.l	#logo6cop,logocolour
move.w	#2440,logoplanesize
move.l	#logo6,toplogo
	rts
;*****

com30:
cmp.w	#30,d0	;keil-effect
bne	com31
move.w	#10,intcommand
	lea	tofade,a1
	lea	faded,a3
	moveq	#15,d0
	lea	pccolours,a2
com30l1:
	move.w	(a2)+,(a1)+		;003d starcol
	move.w	#0,(a3)+
	dbf	d0,com30l1
	move.w	#4,fadecount
	move.w	#4,dircommand	;fader
move.l	pcalcvpos,a0
move.l	(a0)+,pcalcval1
move.l	(a0)+,pcalcval2
move.l	(a0)+,pcalcval3
move.l	(a0)+,pcalcval4
move.l	a0,pcalcvpos

	rts
;*****

com31:
cmp.w	#31,d0	;keil-effect
bne	com32
	move.w	#9,dircommand	;fader
	rts
;*****

com32:
cmp.w	#32,d0
bne	com33
	move.b	#$20,cbar1m
;	move.b	#$2b,cbar2m	;total down
	move.w	#15,intcommand
	move.w	#8,dircommand
	rts
;*****

com33:
cmp.w	#33,d0
bne	com34
	move.l	#koord,turnkoord
	move.l	#scrkoord,turnkoords
	move.w	d3bobquant,turnquant
	move.w	#2,turnaddx
	move.w	#4,turnaddy
	move.w	#6,turnaddz
	move.w	#11,intcommand
	move.w	#4,fadecount
	move.w	#4,dircommand	;fader
;	move.w	#1,dircommand	;fader

	lea	tofade,a0
	lea	faded,a1

	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0000,(a0)+
	move.w	#$0f40,(a0)+
	move.w	#$0fa0,(a0)+
	move.w	#$0ff0,(a0)+
	move.w	#$000f,(a0)+
	move.w	#$005f,(a0)+
	move.w	#$009f,(a0)+
	move.w	#$0555,(a0)+
	rts
;*****

com34:
cmp.w	#34,d0
bne	com35
	move.b	#$29,cbar1m;2f
	move.w	#8,intcommand
	move.w	#2,dircommand
	rts
;*****

com35:
cmp.w	#35,d0
bne	com36
	move.l	#linekoord1,turnkoord
	move.l	#linekoords1,turnkoords
	move.w	linepoints1,turnquant
	move.w	linequant1,linequant
	move.l	#lines1,lines
	move.w	#4,turnaddx
	move.w	#6,turnaddy
	move.w	#2,turnaddz
	move.w	#16,intcommand
	move.w	#4,dircommand	;fader
	lea	tofade,a0
	lea	faded,a1
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0003,(a0)+

	move.w	#$0f00,(a0)+
	move.w	#4,fadecount
move.w	#0,linemask
	rts
;*****



com36:
cmp.w	#36,d0
bne	com37
	move.b	#$20,cbar1m
	move.b	#$2b,cbar2m	;total down
	move.w	#15,intcommand
	move.w	#8,dircommand
	rts

com37:
cmp.w	#37,d0	;equalized 3d-bobs
bne	com38
	move.w	#$0f00,faded+2
	move.l	#linekoord2,turnkoord
	move.l	#linekoords2,turnkoords
	move.w	linepoints2,turnquant
	move.w	linequant2,linequant
	move.l	#lines2,lines
	move.w	#2,turnaddx
	move.w	#2,turnaddy
	move.w	#4,turnaddz
	move.w	#17,intcommand
;	move.w	#4,dircommand
	move.w	#3,dircommand
move.w	#0,linemask
	rts
com38:
cmp.w	#38,d0	;equalized 3d-bobs
bne	com39
	move.l	#linekoord3,turnkoord
	move.l	#linekoords3,turnkoords
	move.w	linepoints3,turnquant
	move.w	linequant3,linequant
	move.l	#lines3,lines
	move.w	#4,turnaddx
	move.w	#4,turnaddy
	move.w	#2,turnaddz
	move.w	#17,intcommand
;	move.w	#4,dircommand	;fader
;	move.w	#1,dircommand	;fader
move.w	#0,linemask
	rts

com39:
cmp.w	#39,d0	;equalized 3d-bobs
bne	com40
	move.l	#linekoord4,turnkoord
	move.l	#linekoords4,turnkoords
	move.w	linepoints4,turnquant
	move.w	linequant4,linequant
	move.l	#lines4,lines
	move.w	#2,turnaddx
	move.w	#4,turnaddy
	move.w	#4,turnaddz
	move.w	#17,intcommand
;	move.w	#4,dircommand	;fader
;	move.w	#1,dircommand	;fader
move.w	#0,linemask
	rts


com40:
cmp.w	#40,d0	;equalized 3d-bobs
bne	com41
	move.w	#18,intcommand
rts

com41:
cmp.w	#41,d0	;equalized 3d-bobs
bne	com42
	move.w	#%0000000001010000,$dff09a
	move.w	faded,tofade+2
	move.w	#2,fadecount
	move.w	#4,dircommand	;fader

rts

com42:
cmp.w	#42,d0
bne	com43
;	move.b	#$40,cbar1m	;20
	move.b	#$12,cbar2m	;2btotal down
	move.w	#15,intcommand
;	move.w	#8,dircommand
	move.w	#1,stopdircom3
	sub.w	#40,stextpoint
move.w	#0,faded
	rts

com43:
cmp.w	#43,d0
bne	com44
	move.b	#$50,cbar1m;43
	move.b	#$12,cbar2m	;total down
	move.w	#8,intcommand
;	move.w	#7,dircommand
move.l	#logo7cop,logocolour
move.w	#1280,logoplanesize
move.l	#logo7,toplogo
	rts
;*****

com44:
cmp.w	#44,d0
bne	com45
	move.b	#$20,cbar1m;43
	move.b	#$12,cbar2m	;total up
	move.w	#8,intcommand
;	move.w	#7,dircommand
;move.l	#logo7cop,logocolour
;move.w	#1280,logoplanesize
;move.l	#logo7,toplogo
	rts
;*****

com45:
cmp.w	#45,d0
bne	com46
	move.b	#$57,cbar1m;43
	move.b	#$13,cbar2m	;
	move.w	#8,intcommand
	move.w	#2,dircommand
move.l	#logo8cop,logocolour
move.w	#1560,logoplanesize
move.l	#logo8,toplogo
	rts
;*****

com46:
cmp.w	#46,d0
bne	com47
	move.w	#19,intcommand
	move.w	#8,fadecount
	move.w	#4,dircommand	;print text1
	move.w	#0,text1add

	lea	tofade,a0
	lea	faded,a1
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0000,(a0)+
	move.w	#$0557,(a0)+
	move.w	#$0ddf,(a0)+
	move.w	#$099b,(a0)+
	rts
;*****

com47:
cmp.w	#47,d0
bne	com48
	move.w	#2,text1add
	move.w	#0,textsinpoints
	move.w	#5,dircommand	;print text1
rts



com48:
cmp.w	#48,d0
bne	com49
move.w	#416,textsinpoints
rts

com49:
cmp.w	#49,d0
bne	com50
	move.w	#19,intcommand
	move.w	#8,fadecount
	move.w	#4,dircommand	;print text1
	move.w	#0,text1add

	lea	tofade,a0
	lea	faded,a1
	move.w	#$0,(a0)+
	move.w	#$0,(a0)+
	move.w	#$0,(a0)+
	move.w	#$0,(a0)+
	rts
;*****


com50:
cmp.w	#50,d0
bne	com51
	move.l	#bkoord,turnkoord
	move.l	#bskoord,turnkoords
	move.w	d3bobquant,turnquant
	move.w	#2,turnaddx
	move.w	#4,turnaddy
	move.w	#6,turnaddz
	move.w	#11,intcommand
	move.w	#4,fadecount
	move.w	#4,dircommand	;fader
;	move.w	#1,dircommand	;fader

	lea	tofade,a0
	lea	faded,a1

	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0000,(a0)+
	move.w	#$0f40,(a0)+
	move.w	#$0fa0,(a0)+
	move.w	#$0ff0,(a0)+
	move.w	#$000f,(a0)+
	move.w	#$005f,(a0)+
	move.w	#$009f,(a0)+
	move.w	#$0555,(a0)+
	rts
;*****

com51:
cmp.w	#51,d0
bne	com52
	move.l	#bkoord2,turnkoord
	move.l	#bskoord2,turnkoords
	move.w	d3bobquant,turnquant
	move.w	#2,turnaddx
	move.w	#4,turnaddy
	move.w	#6,turnaddz
	move.w	#11,intcommand
	move.w	#4,fadecount
	move.w	#4,dircommand	;fader
;	move.w	#1,dircommand	;fader

	lea	tofade,a0
	lea	faded,a1

	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0000,(a0)+
	move.w	#$0f40,(a0)+
	move.w	#$0fa0,(a0)+
	move.w	#$0ff0,(a0)+
	move.w	#$000f,(a0)+
	move.w	#$005f,(a0)+
	move.w	#$009f,(a0)+
	move.w	#$0555,(a0)+
	rts
;*****

com52:
cmp.w	#52,d0
bne	com53
	move.l	#linekoord0,turnkoord
	move.l	#linekoords0,turnkoords
	move.w	linepoints0,turnquant
	move.w	linequant0,linequant
	move.l	#lines0,lines
	move.w	#6,turnaddx
	move.w	#2,turnaddy
	move.w	#4,turnaddz
	move.w	#16,intcommand
	move.w	#4,dircommand	;fader
	lea	tofade,a0
	lea	faded,a1
	move.w	#0,(a1)+
	move.w	#0,(a1)+
	move.w	#$0003,(a0)+

	move.w	#$0f00,(a0)+
	move.w	#4,fadecount
move.w	#0,linemask
	rts
;*****



com53:

move.w	#0,compoint
backcom:
rts

;**********************************************************************
stopdircom3:	dc.w	0

dircomexecutor:
dcom1:			;1 --> copy logo1 to bitplane ( GALLOWS )
cmp.w	#1,d0
bne	dcom2
	jsr	setallplanes
;---
	jmp	mouse
;*****

dcom2:			;2 --> clear all planes with prozessor
cmp.w	#2,d0
bne	dcom3
	jsr	clrallplanes
	jmp	mouse
;*****

dcom3:
cmp.w	#3,d0
bne	dcom4
;---
waitswitch:
;move.w	#$0fff,$dff180
tst.w	com17flag
beq	waitswitch
;move.w	#$0,$dff180

jsr	planecls6
jsr	turner	;(tina??)

lea	$dff000,a5
blitterwait7312:	btst	#14,dmaconr(a5)
bne	blitterwait7312
jsr	drawline

move.w	#0,com17flag
jsr	commander

tst.w	stopdircom3
beq	null
jmp	mouse
null:


	btst	#6,ciaapra
	bne waitswitch

	jmp	mouse
;*****

dcom4:			;fader
cmp.w	#4,d0
bne	dcom5
	jsr	fader
	jmp	mouse
;*****

dcom5:
cmp.w	#5,d0
bne	dcom6
;-----
jsr	drawtext1
;-----
	jmp	mouse
;*****

dcom6:
cmp.w	#6,d0
bne	dcom7
;-----
;-----
	jmp	mouse
;*****

dcom7:
cmp.w	#7,d0
bne	dcom8
;-----
;-----
	jmp	mouse
;*****

dcom8:
cmp.w	#8,d0
bne	dcom9
;-----
;-----
	jmp	mouse
;*****

dcom9:			;4 --> call fader
cmp.w	#9,d0
bne	dcom10
	move.l	#tofade,a1
	move.l	#15,d0
dcom9l1:
	move.w	#0,(a1)+		;003d starcol
	dbf	d0,dcom9l1
	move.w	#4,fadecount
	jsr	fader
	jmp	mouse
;*****



dcom10:			;;5 --> 
mouse:
rts



scroller:
	lea	$dff000,a5

	move.l	#scrollplane,d0
;	add.l	#4*48,d0


	move.l	d0,bltapth(a5)	;anfang von plane ist source
	sub.l	#2,d0
	move.l	d0,bltdpth(a5)	;dest=ein wort vorher



	move.w	#%1100100111110000,bltcon0(a5)
	moveq	#0,d0
	move.w	d0,bltcon1(a5)
	move.l	d0,bltamod(a5)	;a+d
	move.l	d0,bltcdat(a5)	;c+b
	move.l	#%00000000011111111111111111111111,bltafwm(a5)	;fwm+lwm
	move.w	#2072,bltsize(a5)	;x=24,y=32

	blitterwait1512:
	btst	#14,dmaconr(a5)
	bne	blitterwait1512

	sub.w	#1,scrollwait
	bne	scrollerl1	;nonewchar
	move.w	#4,scrollwait

	lea	scrollplane,a0
	add.l	#44,a0
	move.w	stextpoint,d0
	addq.w	#1,stextpoint
	lea	text,a1
	moveq	#0,d1
	move.b	0(a1,d0.w),d1
	bpl	scrollerl2	;noscrollrestart
	sub.b	d1,d1
	move.w	#0,stextpoint
	move.w	#1,ente
scrollerl2:
	lsl.w	#6,d1
	lea	font1,a1
	adda.l	d1,a1
	move.l	#31,d0
scrollerl3:
	move.w	(a1)+,(a0)
	add.l	#48,a0
	dbf	d0,scrollerl3
scrollerl1:

	blitterwait15:
	btst	#14,dmaconr(a5)
	bne	blitterwait15

	rts
;*****
blk.b	30*40,$ff
dc.w	0
scrollplane:
blk.b	32*48,$00

blk.b	17*48,$aa
blk.b	30*40,$00
scrollwait:	dc.w	40
stextpoint:	dc.w	0

text:
dc.b 0,0,0,0,0,8,5,12,12,15,0,5,22,5,18,25,2,15,4,25
dc.b 43,0,20,8,9,19,0,9,19,0,13,15,15,14,0,23,18,9
dc.b 20,9,14,7,0,19,15,13,5,0,9,14,20,18,15,4,21,3
dc.b 9,14,7,0,23,15,18,4,19,37,0,9,0,19,20,1,18,20
dc.b 5,4,0,3,15,4,9,14,7,0,20,8,9,19,0,4,5,13,15,0
dc.b 15,14,5,0,25,5,1,18,0,1,7,15,43,0,20,8,1,20,19
dc.b 0,1,0,12,15,14,7,0,20,9,13,5,43,43,0,23,5,12,12
dc.b 38,0,9,0,8,1,4,0,20,15,0,4,15,0,13,25,0,13,9,12
dc.b 9,20,1,18,25,0,19,5,18,22,9,3,5,0,9,14,0,20,8
dc.b 9,19,0,20,9,13,5,38,0,2,21,20,0,20,8,5,0,13,1
dc.b 9,14,41,18,5,1,19,15,14,0,6,15,18,0,20,8,5,0,22
dc.b 5,18,25,0,12,15,14,7,0,4,5,22,5,12,15,16,9,14
dc.b 7,0,20,9,13,5,0,23,1,19,38,0,20,8,1,20,0,14,15
dc.b 2,15,4,25,0,9,14,0,7,1,12,12,15,23,19,0,23,1,19
dc.b 0,9,14,20,5,18,5,19,20,5,4,0,20,15,0,13,1,11,5
dc.b 0,9,14,22,1,4,5,18,19,0,1,19,0,1,0,4,5,13,15,0
dc.b 23,8,9,3,8,0,19,8,15,23,19,0,15,21,18,0,12,5,22
dc.b 5,12,0,1,14,4,0,11,14,15,23,12,5,4,7,5,37,0,14
dc.b 15,23,0,9,0,20,5,12,12,0,25,15,21,0,8,15,23,0
dc.b 9,0,13,1,4,5,0,20,8,9,19,0,4,5,13,15,39,0,1,19
dc.b 0,9,0,19,20,1,18,20,5,4,0,23,9,20,8,0,9,14,22
dc.b 1,4,5,18,19,38,9,0,19,20,1,18,20,5,4,0,3,15,4
dc.b 9,14,7,0,1,0,12,9,20,20,12,5,0,7,1,13,5,38,0,20
dc.b 15,15,43,0,19,15,0,9,6,0,9,0,8,1,4,0,20,15,0,23
dc.b 1,9,20,0,6,15,18,0,19,15,13,5,0,19,20,21,6,6,0
dc.b 6,15,18,0,20,8,5,0,4,5,13,15,38,0,9,0,23,15,18
dc.b 11,5,4,0,15,14,0,20,8,5,0,7,1,13,5,43,0,1,14,4
dc.b 0,23,8,5,14,0,9,0,8,1,4,0,20,15,0,23,1,9,20,0
dc.b 6,15,18,0,19,15,13,5,20,8,9,14,7,0,6,15,18,0,20
dc.b 8,5,0,7,1,13,5,37,37,37,37,37,0,0,1,14,4,0,19
dc.b 15,0,15,14,0,1,14,4,0,15,14,0,1,14,4,0,15,14,0
dc.b 0,0,19,15,13,5,20,9,13,5,19,0,9,0,8,1,4,0,20,15
dc.b 0,19,20,15,16,0,2,15,20,8,0,16,18,15,10,5,3,20
dc.b 19,38,0,19,15,0,9,0,19,20,1,18,20,5,4,0,1,0,20
dc.b 8,9,18,4,0,15,14,5,38,0,23,9,20,8,15,21,20,0,1
dc.b 14,25,0,13,21,19,9,3,0,15,18,0,7,18,1,16,8,9,3
dc.b 19,39,0,9,0,19,20,1,18,20,5,4,0,20,15,0,23,18
dc.b 9,20,5,0,19,15,13,5,0,3,18,21,14,3,8,41,18,15
dc.b 21,20,9,14,5,19,0,2,21,20,0,14,15,0,15,14,5,0
dc.b 18,5,1,3,8,5,4,0,20,8,5,0,12,5,22,5,12,0,15,6
dc.b 0,1,14,25,0,15,20,8,5,18,0,16,1,3,11,5,18,37,37
dc.b 37,0,0,20,8,5,14,0,14,21,11,5,0,1,19,11,5,4,0
dc.b 13,5,0,20,15,0,10,15,9,14,0,19,16,9,18,9,20,37
dc.b 0,9,0,20,8,15,21,7,8,20,0,15,14,0,9,14,22,1,4
dc.b 5,18,19,38,0,15,14,0,20,8,5,0,1,3,20,21,1,12,0
dc.b 20,5,1,13,23,15,18,11,38,0,20,8,5,14,0,9,0,19
dc.b 13,9,12,5,4,0,1,14,4,0,19,1,9,4,0,25,5,19,38,0
dc.b 25,5,1,8,38,0,7,18,5,1,20,43,43,43,43,43,43,0
dc.b 0,0,0,0,2,21,20,0,14,15,23,0,9,0,19,20,15,16,0
dc.b 2,15,18,5,0,25,15,21,0,23,9,20,8,0,6,1,3,20,19
dc.b 38,0,19,15,0,9,0,13,15,22,5,37,12,0,20,8,5,0,11
dc.b 5,25,2,15,1,18,4,0,20,15,0,14,21,11,5,37,37,37
dc.b 37,37,0,0,0,0,1,6,20,5,18,0,1,0,12,15,14,7,0,3
dc.b 15,12,4,0,23,9,14,20,5,18,0,19,16,9,18,9,20,0
dc.b 9,19,0,2,1,3,11,0,23,8,9,20,0,1,0,14,5,23,0,4
dc.b 5,13,15,43,0,25,21,13,13,25,43,0,23,5,0,23,18
dc.b 9,20,5,0,20,8,5,0,25,5,1,18,0,15,6,0,27,35,35
dc.b 28,43,0,14,15,23,0,23,5,0,18,5,16,18,5,19,5,14
dc.b 20,0,1,0,14,5,23,0,3,21,12,20,38,0,1,0,20,15,21
dc.b 7,8,5,18,0,19,20,25,12,5,0,4,9,19,20,9,14,7,21
dc.b 9,19,8,5,4,0,2,25,0,9,20,19,0,19,5,12,5,3,20,5
dc.b 4,0,13,5,13,2,5,18,19,43,0,1,0,20,15,21,7,8,0
dc.b 19,20,25,12,5,0,6,15,18,0,1,0,18,15,21,7,8,0,1
dc.b 16,16,5,1,18,5,14,3,5,0,20,8,5,0,3,21,12,20,0
dc.b 15,6,0,1,14,21,18,2,1,14,0,19,16,9,18,9,20,0,1
dc.b 19,19,15,3,9,1,20,5,4,0,23,8,9,20,0,20,8,9,19
dc.b 0,4,5,3,1,4,5,0,15,6,0,12,9,22,9,14,7,0,12,5,7
dc.b 5,14,4,43,43,0,2,15,18,14,0,1,14,4,0,18,5,12,5
dc.b 1,19,5,4,0,9,14,0,5,21,18,15,16,5,43,43,0,41,19
dc.b 16,9,18,9,20,41,0,0,12,9,22,9,14,7,0,12,5,7,5
dc.b 14,4,19,0,40,0,19,20,18,5,5,20,0,12,9,6,5,0,40
dc.b 0,24,24,0,40,0,7,15,4,19,0,40,0,1,12,3,15,8,15
dc.b 12,0,40,0,18,5,2,5,12,19,0,40,0,20,18,21,5,0,6
dc.b 18,5,1,24,0,40,0,8,5,18,15,5,19,0,40,0,25,15,21
dc.b 14,7,0,5,21,18,15,16,5,19,0,43,43,0,0,6,9,18,19
dc.b 20,0,9,38,0,14,21,11,5,38,0,13,21,19,20,0,20,8
dc.b 1,14,11,0,13,15,15,14,0,6,15,18,0,3,15,4,9,14
dc.b 7,0,20,8,9,19,0,4,5,13,15,0,1,14,4,0,6,15,18,0
dc.b 2,5,5,9,14,7,0,19,21,3,8,0,1,0,20,1,4,5,12,12
dc.b 15,19,0,13,1,20,5,43,0,0,1,19,0,20,8,5,0,20,9
dc.b 13,5,0,7,15,5,19,0,15,14,0,9,0,8,1,22,5,0,20,15
dc.b 0,13,5,14,20,9,15,14,0,14,15,23,0,9,14,0,23,8
dc.b 9,3,8,0,7,18,15,21,16,19,0,9,22,5,0,2,5,5,14,0
dc.b 20,15,0,20,8,9,19,0,20,9,13,5,37,0,9,0,19,20,1
dc.b 18,20,5,4,0,15,14,0,20,8,5,0,1,13,9,7,1,0,9,14
dc.b 0,20,8,5,0,7,12,15,18,25,0,25,5,1,18,0,27,35,34
dc.b 34,0,23,8,5,14,0,4,21,11,5,38,0,13,15,15,14,0
dc.b 1,14,4,0,13,5,0,15,16,5,14,5,4,0,1,0,19,13,1,12
dc.b 12,0,7,18,15,21,16,0,3,1,12,12,5,4,0,15,14,25
dc.b 24,43,0,9,0,19,20,1,18,20,5,4,0,20,18,1,4,9,14
dc.b 7,0,1,18,15,21,14,4,0,23,8,9,20,0,20,8,5,0,5,12
dc.b 9,20,5,0,7,21,25,19,0,9,14,0,20,8,5,0,19,3,5,14
dc.b 5,37,0,6,18,15,13,0,4,1,25,0,20,15,0,4,1,25,0
dc.b 9,0,7,15,20,0,13,15,18,5,0,6,1,13,15,21,19,43
dc.b 0,14,15,23,0,1,0,14,5,23,0,1,18,5,1,0,19,20,1
dc.b 18,20,5,4,0,6,15,18,0,13,5,37,37,37,0,9,0,10,15
dc.b 9,14,5,4,0,19,21,2,23,1,25,43,0,9,14,0,19,21,2
dc.b 23,1,25,0,9,0,12,5,1,18,14,5,4,0,8,15,23,0,20
dc.b 15,0,15,18,7,1,14,9,19,5,0,20,8,5,0,7,21,25,19
dc.b 37,0,23,5,0,2,5,1,20,0,1,12,12,0,20,18,1,9,14
dc.b 5,18,0,13,1,11,5,18,19,0,9,14,0,20,8,5,0,23,15
dc.b 18,12,4,0,1,14,4,0,3,12,9,13,5,4,0,20,15,0,14
dc.b 15,37,27,43,0,14,15,23,0,13,25,0,13,1,9,12,2,15
dc.b 24,0,23,1,19,0,6,21,12,12,0,15,6,0,12,5,20,20
dc.b 5,18,19,0,5,22,5,18,25,0,4,1,25,0,1,14,4,0,9,0
dc.b 19,23,1,16,16,5,4,0,23,8,9,20,0,20,8,5,0,2,5,19
dc.b 20,43,0,27,0,25,5,1,18,0,1,14,4,0,31,0,13,15,14
dc.b 20,8,19,0,9,0,19,20,1,25,5,4,0,9,14,0,19,21,2
dc.b 23,1,25,38,0,20,8,5,14,0,9,0,12,5,6,20,0,3,15
dc.b 26,0,20,8,5,0,3,18,1,3,11,5,18,19,0,10,15,9,14
dc.b 5,4,0,19,16,18,5,1,4,16,15,9,14,20,0,1,14,4,0
dc.b 9,0,4,9,4,0,14,15,20,0,23,1,14,20,0,20,15,0,10
dc.b 15,9,14,43,43,0,14,15,23,0,20,8,5,0,2,25,20,5
dc.b 18,1,16,5,18,19,0,15,6,6,5,18,5,4,0,13,5,0,20
dc.b 15,0,10,15,9,14,0,20,8,5,9,18,0,3,18,5,23,0,1
dc.b 14,4,0,9,0,10,15,9,14,5,4,43,0,2,21,20,0,20,8
dc.b 9,19,0,20,5,1,13,0,23,1,19,14,20,0,22,5,18,25
dc.b 0,16,18,15,4,21,3,20,9,22,5,0,19,15,0,13,15,15
dc.b 14,0,1,14,4,0,13,5,0,19,20,1,18,20,5,4,0,9,14
dc.b 0,4,21,1,12,0,3,18,5,23,37,0,1,0,6,5,23,0,23,5
dc.b 5,11,19,0,12,1,20,5,18,0,23,5,0,12,5,6,20,0,1
dc.b 7,1,9,14,37,37,37,0,9,0,23,1,19,0,9,14,4,5,16
dc.b 5,14,4,5,14,20,0,6,15,18,0,19,15,13,5,0,4,1,25
dc.b 19,37,0,2,21,20,0,20,8,5,14,0,9,0,19,16,15,11
dc.b 5,0,20,15,0,19,20,1,12,11,5,18,0,1,14,4,0,10,15
dc.b 9,14,5,4,0,3,12,1,19,19,9,3,43,43,0,9,0,19,20
dc.b 1,18,20,5,4,0,6,21,12,12,0,19,23,1,16,16,9,14
dc.b 7,37,0,1,7,1,9,14,0,23,5,0,3,12,9,13,5,4,0,20
dc.b 8,5,0,14,15,37,27,0,9,14,0,20,8,5,0,3,18,1,3,11
dc.b 5,18,0,1,14,4,0,2,2,19,0,3,8,1,18,20,19,0,6,15
dc.b 18,0,1,0,12,15,14,7,0,20,9,13,5,43,0,1,6,20,5
dc.b 18,0,15,14,5,0,25,5,1,18,0,3,12,1,19,19,9,3,0
dc.b 4,9,5,4,0,2,5,3,1,21,19,5,0,23,5,0,18,5,1,3,8
dc.b 5,4,0,20,8,5,0,6,9,14,9,19,8,0,20,15,0,2,5,0,20
dc.b 8,5,0,2,5,19,20,0,3,18,5,23,43,43,0,14,15,23,0
dc.b 9,14,0,27,35,35,28,0,9,0,1,13,0,2,1,3,11,0,1,7
dc.b 1,9,14,0,23,8,9,20,0,19,16,9,18,9,20,43,0,1,14
dc.b 4,0,9,20,19,0,15,14,12,25,0,1,0,17,21,5,19,20
dc.b 9,15,14,0,15,6,0,20,9,13,5,0,20,15,0,1,14,14,5
dc.b 24,0,20,8,5,0,15,12,4,0,20,9,13,5,19,0,1,14,4
dc.b 0,18,21,12,5,0,1,7,1,9,14,43,43,43,43,0,0,25,5
dc.b 18,0,14,21,11,5,46,19,16,9,18,9,20,43,43,0,0,0
dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,8
dc.b 9,19,0,9,19,0,20,8,5,0,7,18,5,5,20,9,14,7,19,0
dc.b 19,3,18,15,12,12,5,18,43,0,9,6,0,25,15,21,0,23
dc.b 1,14,14,1,0,7,5,20,0,9,14,0,20,15,21,3,8,0,23
dc.b 8,9,20,0,21,19,0,4,15,14,20,0,8,5,19,9,20,1,20
dc.b 5,0,1,14,4,0,13,1,11,5,0,9,13,16,1,3,20,0,1,20
dc.b 39,0,14,21,11,5,46,19,16,9,18,9,20,0,0,16,37,15
dc.b 37,0,2,15,24,0,29,33,0,0,1,41,31,30,27,27,0,15
dc.b 2,5,18,1,12,13,0,0,19,1,12,26,2,21,18,7,0,0,1
dc.b 21,19,20,18,9,1,0,0,0,15,18,0,0,0,13,9,7,8,20
dc.b 25,13,21,26,46,19,16,9,18,9,20,0,8,15,6,22,5,18
dc.b 2,5,18,7,19,7,1,20,1,14,0,32,0,0,19,41,28,31,30
dc.b 0,30,29,0,8,5,12,19,9,14,7,2,15,18,7,0,19,23,5
dc.b 4,5,14,37,0,19,16,5,3,9,1,12,0,7,18,5,5,20,19
dc.b 0,6,18,15,13,0,13,5,38,0,14,21,11,5,38,0,20,15
dc.b 0,13,25,0,2,5,19,20,0,6,18,9,5,14,4,19,39,0,0
dc.b 14,21,7,7,5,20,38,0,23,9,3,15,38,0,18,21,2,5,14
dc.b 46,18,5,2,5,12,19,0,41,0,2,1,13,2,1,13,46,17,21
dc.b 1,18,20,5,24,0,41,0,19,16,12,1,20,20,38,0,12,21
dc.b 11,5,38,0,3,8,21,3,11,46,6,1,9,18,12,9,7,8,20
dc.b 0,41,0,19,3,15,20,20,38,0,9,2,13,46,3,18,25,19
dc.b 20,1,12,0,41,0,19,12,1,25,5,18,38,0,6,6,3,38,0
dc.b 23,9,19,5,13,1,14,46,19,11,9,4,0,18,15,23,0,41
dc.b 0,14,37,15,37,13,37,1,37,4,37,46,14,5,13,5,19
dc.b 9,19,0,41,0,4,1,14,46,1,14,1,18,3,8,25,0,41,0
dc.b 18,1,14,7,5,18,38,0,20,13,2,46,19,3,15,15,16,5
dc.b 24,0,41,0,13,9,11,5,38,0,9,14,7,15,38,0,13,21
dc.b 14,19,20,5,18,46,19,16,18,5,1,4,16,15,9,14,20
dc.b 0,41,0,1,18,13,9,14,46,19,21,16,16,12,5,24,0,41
dc.b 0,19,20,15,15,11,9,5,38,0,26,1,26,38,0,18,5,4
dc.b 0,4,5,22,9,12,38,0,12,5,5,2,15,12,4,38,0,21,12
dc.b 20,9,13,1,20,5,0,23,1,18,18,9,15,18,46,4,21,1
dc.b 12,0,3,18,5,23,0,41,0,3,9,18,3,21,12,1,20,15,18
dc.b 46,19,9,12,5,14,20,19,0,41,0,8,5,14,4,18,9,3,11
dc.b 46,22,9,19,9,15,14,0,6,1,3,20,15,18,25,0,41,0
dc.b 13,15,24,25,46,3,25,20,1,24,0,41,0,9,18,1,20,1
dc.b 46,20,18,19,9,0,41,0,12,9,7,8,20,2,5,5,18,46,16
dc.b 1,12,1,3,5,0,41,0,13,9,3,0,4,1,9,18,46,3,15,13
dc.b 16,12,5,24,0,41,0,23,9,14,20,5,18,13,21,20,5,46
dc.b 1,14,20,8,18,15,24,0,41,37,37,37,37,0,1,14,4,0
dc.b 20,15,0,20,8,15,19,5,0,3,15,15,12,0,7,21,25,19
dc.b 37,37,37,37,0,19,11,5,12,5,20,15,14,0,41,0,16
dc.b 8,9,12,15,0,41,0,1,18,13,25,20,1,7,5,0,41,0,3
dc.b 15,14,17,21,5,18,15,18,0,41,0,19,1,2,2,1,20,8
dc.b 0,20,8,5,0,22,1,14,4,1,12,0,41,0,12,15,22,5,18
dc.b 2,15,25,0,41,0,13,15,19,5,19,0,41,0,13,25,19,20
dc.b 9,17,21,5,0,41,0,26,5,12,14,9,11,0,41,0,19,12
dc.b 5,1,26,5,0,41,0,1,14,4,0,20,15,0,1,12,12,0,20
dc.b 8,1,20,0,9,0,8,1,22,5,0,6,15,18,7,15,20,20,5,14
dc.b 43,43,0,0,14,15,18,13,1,12,0,7,18,5,5,20,19,0
dc.b 7,15,9,14,7,0,15,21,20,0,20,15,0,20,8,5,19,5,0
dc.b 20,5,1,13,19,39,0,0,1,21,18,15,18,1,0,41,0,1,4
dc.b 4,15,14,9,3,0,41,0,1,7,14,15,19,20,9,3,0,6,18
dc.b 15,14,20,0,40,0,16,1,14,9,3,0,41,0,1,7,9,12,5
dc.b 0,41,0,1,14,1,18,3,8,25,0,41,0,1,12,3,1,20,18
dc.b 1,26,0,41,0,1,14,1,12,0,9,14,20,18,21,4,5,18,19
dc.b 0,41,0,1,20,12,1,14,20,9,19,0,41,0,1,12,16,8,1
dc.b 0,6,12,9,7,8,20,0,41,0,1,14,20,8,18,15,24,0,41
dc.b 0,3,8,18,15,13,5,0,41,0,3,25,20,1,24,0,41,0,3
dc.b 18,25,19,20,1,12,0,41,0,4,5,22,9,12,19,0,41,0
dc.b 4,1,13,15,14,5,19,0,41,0,4,21,1,12,0,3,18,5,23
dc.b 0,41,0,5,14,5,18,7,25,0,41,0,5,14,4,0,15,6,0,3
dc.b 5,14,20,21,18,25,0,27,35,35,35,0,41,0,5,17,21
dc.b 9,14,15,24,0,41,0,6,21,19,9,15,14,0,40,0,2,9,20
dc.b 19,20,15,16,16,5,18,19,0,41,0,6,1,9,18,12,9,7
dc.b 8,20,0,40,0,9,20,1,12,9,1,14,0,3,18,1,3,11,9,14
dc.b 7,0,19,5,18,22,9,3,5,0,41,0,6,18,1,14,20,9,3,0
dc.b 41,0,11,5,6,18,5,14,19,0,41,0,12,5,7,5,14,4,0
dc.b 41,0,12,19,4,0,41,0,13,9,18,1,7,5,0,41,0,14,15
dc.b 24,9,15,21,19,0,41,0,14,5,13,5,19,9,19,0,41,0
dc.b 16,15,12,1,18,9,19,0,41,0,16,1,18,1,4,9,19,5,0
dc.b 41,0,16,21,18,5,0,13,5,20,1,12,0,3,15,4,5,18,19
dc.b 0,41,0,16,1,12,1,3,5,0,41,0,17,21,1,18,20,5,24
dc.b 0,41,0,18,5,2,5,12,19,0,41,0,19,11,9,4,0,18,15
dc.b 23,0,41,0,19,3,15,15,16,5,24,0,41,0,19,9,12,5
dc.b 14,20,19,0,41,0,19,8,9,14,9,14,7,0,41,0,19,8,9
dc.b 14,9,14,7,0,34,0,41,0,19,43,16,46,20,18,19,9,0
dc.b 41,0,19,21,16,16,12,5,24,0,41,0,19,16,18,5,1,4
dc.b 16,15,9,14,20,0,41,0,20,8,5,0,19,16,5,3,9,1,12
dc.b 0,2,18,15,20,8,5,18,19,0,41,0,20,18,9,19,20,1
dc.b 18,0,40,0,18,5,4,0,19,5,3,20,15,18,0,41,0,22,9
dc.b 19,9,15,14,0,6,1,3,20,15,18,25,0,40,0,3,15,13
dc.b 16,1,14,25,0,41,0,23,9,26,26,3,1,20,0,0,0,0,0
dc.b 0,0,0,0,0,0,0,20,8,5,0,5,14,4,0,0,0,0,0,0
dc.b 255


dc.b 0,255
even
font1:	blk.b	3840,0
even

blue:
dc.w	$060,$090,$0d0,$0f0,$0d0,$090,$060
dc.w	0,0,0
dc.w	0,0,0,0,0
dc.w	$705,$805,$905,$a05,$b05,$c05,$d05,$e05
dc.w	$f05
dc.w	$e05,$d05,$c05,$b05,$a05,$905,$805,$705



dc.w	$fff,$fff,$fff,$fff,$fff,$fff,$fff
dc.w	$700,$800,$900,$a00,$b00,$c00,$d00,$e00
dc.w	$f00
dc.w	$e00,$d00,$c00,$b00,$a00,$900,$800,$700


dc.w	$a04,$a07,$a0b,$a0f,$04C,$06C,$08C,$3AC,$8AC,$3AC,$08C,$06C
dc.w	$04C,$a0f,$a0b,$a07,$a04

dc.w	$007,$00b,$00f,$00B,$04C,$06C,$08C,$3AC,$3AC,$08C,$06C
dc.w	$04C,$00B,$00f,$00b,$007






sin1:
dc.w 25,26,26,27,27,28,28,28,29,29,30,30,31,31,31,32,32,33,33,34,34
dc.w 34,35,35,36,36,36,37,37,38,38,38,39,39,39,40,40,40,41,41,41,42
dc.w 42,42,43,43,43,44,44,44,44,45,45,45,45,46,46,46,46,47,47,47,47
dc.w 47,48,48,48,48,48,48,49,49,49,49,49,49,49,49,50,50,50,50,50,50
dc.w 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,49,49,49,49
dc.w 49,49,49,49,48,48,48,48,48,48,47,47,47,47,47,46,46,46,46,45,45
dc.w 45,45,44,44,44,44,43,43,43,42,42,42,41,41,41,40,40,40,39,39,39
dc.w 38,38,37,37,37,36,36,36,35,35,34,34,34,33,33,32,32,31,31,31,30
dc.w 30,29,29,28,28,28,27,27,26,26,25,25,25,24,24,23,23,22,22,22,21
dc.w 21,20,20,19,19,19,18,18,17,17,16,16,16,15,15,14,14,14,13,13,12
dc.w 12,12,11,11,11,10,10,10,9,9,9,8,8,8,7,7,7,6,6,6,6,5,5,5,5,4,4
dc.w 4,4,3,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0
dc.w 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3
dc.w 3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10,11,11,11
dc.w 12,12,13,13,13,14,14,14,15,15,16,16,16,17,17,18,18,19,19,19,20
dc.w 20,21,21,22,22,22,23,23,24,24,25,25
sin1end:

sin2:
dc.w 77,79,80,81,83,84,85,87,88,89,91,92,93,94,96,97,98,99,101,102
dc.w 103,104,106,107,108,109,111,112,113,114,115,116,117,118,120,121
dc.w 122,123,124,125,126,127,128,129,130,131,132,132,133,134,135,136
dc.w 137,137,138,139,140,140,141,142,142,143,144,144,145,145,146,146
dc.w 147,147,148,148,149,149,149,150,150,150,151,151,151,151,151,152
dc.w 152,152,152,152,152,152,152,152,152,152,152,152,151,151,151,151
dc.w 151,150,150,150,149,149,149,148,148,147,147,146,146,145,145,144
dc.w 144,143,142,142,141,140,140,139,138,137,137,136,135,134,133,132
dc.w 132,131,130,129,128,127,126,125,124,123,122,121,120,118,117,116
dc.w 115,114,113,112,111,109,108,107,106,104,103,102,101,99,98,97
dc.w 96,94,93,92,91,89,88,87,85,84,83,81,80,79,77,76,75,73,72,71,69
dc.w 68,67,65,64,63,61,60,59,58,56,55,54,53,51,50,49,48,46,45,44,43
dc.w 41,40,39,38,37,36,35,34,32,31,30,29,28,27,26,25,24,23,22,21,20
dc.w 20,19,18,17,16,15,15,14,13,12,12,11,10,10,9,8,8,7,7,6,6,5,5,4
dc.w 4,3,3,3,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2
dc.w 2,2,3,3,3,4,4,5,5,6,6,7,7,8,8,9,10,10,11,12,12,13,14,15,15,16
dc.w 17,18,19,20,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,36,37
dc.w 38,39,40,41,43,44,45,46,48,49,50,51,53,54,55,56,58,59,60,61,63
dc.w 64,65,67,68,69,71,72,73,75,76

dc.w 77,79,80,81,83,84,85,87,88,89,91,92,93,94,96,97,98,99,101,102
dc.w 103,104,106,107,108,109,111,112,113,114,115,116,117,118,120,121
dc.w 122,123,124,125,126,127,128,129,130,131,132,132,133,134,135,136
dc.w 137,137,138,139,140,140,141,142,142,143,144,144,145,145,146,146
dc.w 147,147,148,148,149,149,149,150,150,150,151,151,151,151,151,152
dc.w 152,152,152,152,152,152,152,152,152,152,152,152,151,151,151,151
dc.w 151,150,150,150,149,149,149,148,148,147,147,146,146,145,145,144
dc.w 144,143,142,142,141,140,140,139,138,137,137,136,135,134,133,132
dc.w 132,131,130,129,128,127,126,125,124,123,122,121,120,118,117,116
dc.w 115,114,113,112,111,109,108,107,106,104,103,102,101,99,98,97
dc.w 96,94,93,92,91,89,88,87,85,84,83,81,80,79,77,76,75,73,72,71,69
dc.w 68,67,65,64,63,61,60,59,58,56,55,54,53,51,50,49,48,46,45,44,43
dc.w 41,40,39,38,37,36,35,34,32,31,30,29,28,27,26,25,24,23,22,21,20
dc.w 20,19,18,17,16,15,15,14,13,12,12,11,10,10,9,8,8,7,7,6,6,5,5,4
dc.w 4,3,3,3,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2
dc.w 2,2,3,3,3,4,4,5,5,6,6,7,7,8,8,9,10,10,11,12,12,13,14,15,15,16
dc.w 17,18,19,20,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,36,37
dc.w 38,39,40,41,43,44,45,46,48,49,50,51,53,54,55,56,58,59,60,61,63
dc.w 64,65,67,68,69,71,72,73,75,76

dc.w 77,79,80,81,83,84,85,87,88,89,91,92,93,94,96,97,98,99,101,102
dc.w 103,104,106,107,108,109,111,112,113,114,115,116,117,118,120,121
dc.w 122,123,124,125,126,127,128,129,130,131,132,132,133,134,135,136
dc.w 137,137,138,139,140,140,141,142,142,143,144,144,145,145,146,146
dc.w 147,147,148,148,149,149,149,150,150,150,151,151,151,151,151,152
dc.w 152,152,152,152,152,152,152,152,152,152,152,152,151,151,151,151
dc.w 151,150,150,150,149,149,149,148,148,147,147,146,146,145,145,144
dc.w 144,143,142,142,141,140,140,139,138,137,137,136,135,134,133,132
dc.w 132,131,130,129,128,127,126,125,124,123,122,121,120,118,117,116
dc.w 115,114,113,112,111,109,108,107,106,104,103,102,101,99,98,97
dc.w 96,94,93,92,91,89,88,87,85,84,83,81,80,79,77,76,75,73,72,71,69
dc.w 68,67,65,64,63,61,60,59,58,56,55,54,53,51,50,49,48,46,45,44,43
dc.w 41,40,39,38,37,36,35,34,32,31,30,29,28,27,26,25,24,23,22,21,20
dc.w 20,19,18,17,16,15,15,14,13,12,12,11,10,10,9,8,8,7,7,6,6,5,5,4
dc.w 4,3,3,3,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2
dc.w 2,2,3,3,3,4,4,5,5,6,6,7,7,8,8,9,10,10,11,12,12,13,14,15,15,16
dc.w 17,18,19,20,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,36,37
dc.w 38,39,40,41,43,44,45,46,48,49,50,51,53,54,55,56,58,59,60,61,63
dc.w 64,65,67,68,69,71,72,73,75,76

dc.w 77,79,80,81,83,84,85,87,88,89,91,92,93,94,96,97,98,99,101,102
dc.w 103,104,106,107,108,109,111,112,113,114,115,116,117,118,120,121
dc.w 122,123,124,125,126,127,128,129,130,131,132,132,133,134,135,136
dc.w 137,137,138,139,140,140,141,142,142,143,144,144,145,145,146,146
dc.w 147,147,148,148,149,149,149,150,150,150,151,151,151,151,151,152
dc.w 152,152,152,152,152,152,152,152,152,152,152,152,151,151,151,151
dc.w 151,150,150,150,149,149,149,148,148,147,147,146,146,145,145,144
dc.w 144,143,142,142,141,140,140,139,138,137,137,136,135,134,133,132
dc.w 132,131,130,129,128,127,126,125,124,123,122,121,120,118,117,116
dc.w 115,114,113,112,111,109,108,107,106,104,103,102,101,99,98,97
dc.w 96,94,93,92,91,89,88,87,85,84,83,81,80,79,77,76,75,73,72,71,69
dc.w 68,67,65,64,63,61,60,59,58,56,55,54,53,51,50,49,48,46,45,44,43
dc.w 41,40,39,38,37,36,35,34,32,31,30,29,28,27,26,25,24,23,22,21,20
dc.w 20,19,18,17,16,15,15,14,13,12,12,11,10,10,9,8,8,7,7,6,6,5,5,4
dc.w 4,3,3,3,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2
dc.w 2,2,3,3,3,4,4,5,5,6,6,7,7,8,8,9,10,10,11,12,12,13,14,15,15,16
dc.w 17,18,19,20,20,21,22,23,24,25,26,27,28,29,30,31,32,34,35,36,37
dc.w 38,39,40,41,43,44,45,46,48,49,50,51,53,54,55,56,58,59,60,61,63
dc.w 64,65,67,68,69,71,72,73,75,76



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
;;move.l	#148,d4
;;move.l	#equal1,a4
	bsr.s	mt_playvoice
	lea	$dff0b0,a5
	lea	mt_voice2(pc),a6
;;move.l	#148,d4
;;move.l	#equal2,a4
	bsr.s	mt_playvoice
	lea	$dff0c0,a5
	lea	mt_voice3(pc),a6
;;move.l	#200,d4
;;move.l	#equal3,a4
	bsr.s	mt_playvoice
	lea	$dff0d0,a5
	lea	mt_voice4(pc),a6
;;move.l	#255,d4
;;move.l	#equal4,a4
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
;;move.w	d4,(a4)
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

mt_data:	incbin	"data/mod.Nightfever"


logosin1:
blk.w	50,0

dc.w 0,1,2,5,8,12,17,23,30,37,46,55,64,75,86,98,110,123,136,150,165
dc.w 180,195,211,226,243,259,275,292,309

dc.w 317,309,301,292,284,276,268,260,252,245,238,231,224,217,211,205,199,194,189
dc.w 184,180,176,173,170,167,165,163,162,161,160,160,160,161,162,163,165,168,171
dc.w 174,177,181,186,191,196,201,207,213,219,226,233,240,247,255,263,271,279,287
dc.w 295,303,312

dc.w 319,314,310,306,302,298,294,290,286,282,279,275,272,269,265,262,260,257,254
dc.w 252,250,248,246,245,243,242,241,241,240,240,240,240,240,241,242,243,244,245
dc.w 247,249,251,253,255,258,261,263,266,270,273,276,280,284,287,291,295,299,303
dc.w 307,312,316

blk.w	30,319

dc.w 319,319,318,316,313,309,304,299,292,285,277,268,259,249,238,226
dc.w 214,201,188,174,160,145,130,115,99,83,67,50,33,17,0

blk.w	100,0	;only for testing textrout1
logosin1end:

logosinpoint1:	dc.w	0
logosinpoint2:	dc.w	0

logosinadd1:	dc.w	0
logosinadd2:	dc.w	0


coppercopy9:
lea	logosin1,a4
move.w	logosinpoint1,d2
add.w	logosinadd1,d2
cmp.w	#logosin1end-logosin1,d2
bne	coppercopy9l1
moveq	#0,d2
move.w	#0,logosinadd1
coppercopy9l1:
move.w	d2,logosinpoint1

moveq	#0,d5
move.w	0(a4,d2.w),d5
move.w	d5,d3
not.b	d3
and.w	#%0000000000001111,d3
lsr.w	#4,d5
add.w	d5,d5



move.w	logosinpoint2,d2
add.w	logosinadd2,d2
cmp.w	#logosin1end-logosin1,d2
bne	coppercopy9l2
moveq	#0,d2
move.w	#0,logosinadd2
coppercopy9l2:
move.w	d2,logosinpoint2

moveq	#0,d6
move.w	#319,d6
sub.w	0(a4,d2.w),d6
move.w	d6,d4
not.b	d4
and.w	#%0000000000001111,d4
lsr.w	#4,d6
add.w	d6,d6



	lea	copperlist,a0
move.l	#$200ffffe,(a0)+
	lea	logo2col,a1
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
	move.l	#logo2,d0
add.l	d5,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	move.l	#$490ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0001001000000000,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	d3,(a0)+
move.w	#$490f,d1
move.w	#36,d0
coppercopy9l5:
move.w	#$182,(a0)+
move.w	(a1)+,(a0)+
add.w	#$0100,d1
move.w	d1,(a0)+
move.w	#$fffe,(a0)+
dbf	d0,coppercopy9l5

;	move.l	#$6e0ffffe,(a0)+
	lea	logo3col,a1
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+


	move.l	#logo3,d0
add.l	d6,d0
	move.w	#bpl1ptl,(a0)+
	move.w	d0,(a0)+
	swap	d0
	move.w	#bpl1pth,(a0)+
	move.w	d0,(a0)+
	move.l	#$da0ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0001001000000000,(a0)+
	move.w	#bplcon1,(a0)+
	move.w	d4,(a0)+

move.w	#$da0f,d1
move.w	#36,d0
coppercopy9l6:
move.w	#$182,(a0)+
move.w	(a1)+,(a0)+
add.w	#$0100,d1
move.w	d1,(a0)+
move.w	#$fffe,(a0)+
dbf	d0,coppercopy9l6


;	move.l	#$ff0ffffe,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+




	move.l	#$fffffffe,(a0)+
rts



logo2col:
logo3col:
dc.w	$0c22,$0b24,$0b25,$0a27,$0a28,$0929,$0829,$0628,$0528,$0427
dc.w	$0327,$0226,$0337,$0338,$0338,$0349,$044a,$045b
dc.w	$045c
dc.w	$045b,$044a,$0349,$0338,$0338,$0337,$0226,$0327,$0427,$0528
dc.w	$0628,$0829,$0929,$0a28,$0a27,$0b25,$0b24,$0c22


linepoints0: dc.w  39; 40 Linepoints
linequant0: dc.w  69*4; 70 Lines
linekoord0:
dc.w 0,-50, 2, 4
dc.w 0,-50, 4, 1
dc.w 0,-50, 4,-2
dc.w 0,-50, 2,-5
dc.w 0,-50, 0,-5
dc.w 0,-50,-3,-5
dc.w 0,-50,-5,-2
dc.w 0,-50,-5, 1
dc.w 0,-50,-3, 4
dc.w 0,-50,-1, 5
dc.w 0, 0, 35, 49
dc.w 0, 0, 58, 18
dc.w 0, 0, 58,-19
dc.w 0, 0, 35,-50
dc.w 0, 0, 0,-61
dc.w 0, 0,-36,-50
dc.w 0, 0,-59,-19
dc.w 0, 0,-59, 18
dc.w 0, 0,-36, 49
dc.w 0, 0,-1, 61
dc.w 0, 26, 32, 45
dc.w 0, 26, 53, 17
dc.w 0, 26, 53,-18
dc.w 0, 26, 32,-46
dc.w 0, 26, 0,-56
dc.w 0, 26,-33,-46
dc.w 0, 26,-54,-18
dc.w 0, 26,-54, 17
dc.w 0, 26,-33, 45
dc.w 0, 26,-1, 56
dc.w 0, 48, 14, 19
dc.w 0, 48, 22, 7
dc.w 0, 48, 22,-8
dc.w 0, 48, 14,-20
dc.w 0, 48, 0,-24
dc.w 0, 48,-15,-20
dc.w 0, 48,-23,-8
dc.w 0, 48,-23, 7
dc.w 0, 48,-15, 19
dc.w 0, 48,-1, 24

linekoords0:
dc.w 0,-50, 2, 4
dc.w 0,-50, 4, 1
dc.w 0,-50, 4,-2
dc.w 0,-50, 2,-5
dc.w 0,-50, 0,-5
dc.w 0,-50,-3,-5
dc.w 0,-50,-5,-2
dc.w 0,-50,-5, 1
dc.w 0,-50,-3, 4
dc.w 0,-50,-1, 5
dc.w 0, 0, 35, 49
dc.w 0, 0, 58, 18
dc.w 0, 0, 58,-19
dc.w 0, 0, 35,-50
dc.w 0, 0, 0,-61
dc.w 0, 0,-36,-50
dc.w 0, 0,-59,-19
dc.w 0, 0,-59, 18
dc.w 0, 0,-36, 49
dc.w 0, 0,-1, 61
dc.w 0, 26, 32, 45
dc.w 0, 26, 53, 17
dc.w 0, 26, 53,-18
dc.w 0, 26, 32,-46
dc.w 0, 26, 0,-56
dc.w 0, 26,-33,-46
dc.w 0, 26,-54,-18
dc.w 0, 26,-54, 17
dc.w 0, 26,-33, 45
dc.w 0, 26,-1, 56
dc.w 0, 48, 14, 19
dc.w 0, 48, 22, 7
dc.w 0, 48, 22,-8
dc.w 0, 48, 14,-20
dc.w 0, 48, 0,-24
dc.w 0, 48,-15,-20
dc.w 0, 48,-23,-8
dc.w 0, 48,-23, 7
dc.w 0, 48,-15, 19
dc.w 0, 48,-1, 24

lines0:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  0, 9
dc.w  10, 11
dc.w  11, 12
dc.w  12, 13
dc.w  13, 14
dc.w  14, 15
dc.w  15, 16
dc.w  16, 17
dc.w  17, 18
dc.w  18, 19
dc.w  10, 19
dc.w  20, 21
dc.w  21, 22
dc.w  22, 23
dc.w  23, 24
dc.w  24, 25
dc.w  25, 26
dc.w  26, 27
dc.w  27, 28
dc.w  28, 29
dc.w  20, 29
dc.w  30, 31
dc.w  31, 32
dc.w  32, 33
dc.w  33, 34
dc.w  34, 35
dc.w  35, 36
dc.w  36, 37
dc.w  37, 38
dc.w  38, 39
dc.w  30, 39
dc.w  0, 10
dc.w  1, 11
dc.w  2, 12
dc.w  3, 13
dc.w  4, 14
dc.w  5, 15
dc.w  6, 16
dc.w  7, 17
dc.w  8, 18
dc.w  9, 19
dc.w  10, 20
dc.w  11, 21
dc.w  12, 22
dc.w  13, 23
dc.w  14, 24
dc.w  15, 25
dc.w  16, 26
dc.w  17, 27
dc.w  18, 28
dc.w  19, 29
dc.w  20, 30
dc.w  21, 31
dc.w  22, 32
dc.w  23, 33
dc.w  24, 34
dc.w  25, 35
dc.w  26, 36
dc.w  27, 37
dc.w  28, 38
dc.w  29, 39




;Objects created with VectorEditor_V2.0 by Thomas Mattel
linepoints1: dc.w  39; 40 Linepoints
linequant1: dc.w  59*4; 60 Lines
linekoord1: blk.l  320/4,0
linekoords1:
dc.w 0,-1,-85,-8
dc.w 0, 84,-1,-8
dc.w 0, 0, 84,-8
dc.w 0,-85, 0,-8
dc.w 0,-1,-85, 7
dc.w 0, 84,-1, 7
dc.w 0, 0, 84, 7
dc.w 0,-85, 0, 7
dc.w 0,-60,-30,-45
dc.w 0,-60,-30, 45
dc.w 0,-60, 30, 45
dc.w 0,-60, 30,-45
dc.w 0,-75,-30,-45
dc.w 0,-75,-30, 45
dc.w 0,-75, 30, 45
dc.w 0,-75, 30,-45
dc.w 0, 75,-30,-45
dc.w 0, 75,-30, 45
dc.w 0, 75, 30, 45
dc.w 0, 75, 30,-45
dc.w 0, 60,-30,-45
dc.w 0, 60,-30, 45
dc.w 0, 60, 30, 45
dc.w 0, 60, 30,-45
dc.w 0,-45,-75, 30
dc.w 0, 45,-75, 30
dc.w 0, 45,-75,-30
dc.w 0,-45,-75,-30
dc.w 0,-45,-60, 30
dc.w 0, 45,-60, 30
dc.w 0, 45,-60,-30
dc.w 0,-45,-60,-30
dc.w 0, 45, 75, 30
dc.w 0,-45, 75, 30
dc.w 0,-45, 75,-30
dc.w 0, 45, 75,-30
dc.w 0, 45, 60, 30
dc.w 0,-45, 60, 30
dc.w 0,-45, 60,-30
dc.w 0, 45, 60,-30
lines1:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 0
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 4
dc.w  0, 4
dc.w  1, 5
dc.w  2, 6
dc.w  3, 7
dc.w  8, 9
dc.w  9, 10
dc.w  10, 11
dc.w  11, 8
dc.w  12, 13
dc.w  13, 14
dc.w  14, 15
dc.w  15, 12
dc.w  8, 12
dc.w  9, 13
dc.w  10, 14
dc.w  11, 15
dc.w  16, 17
dc.w  17, 18
dc.w  18, 19
dc.w  19, 16
dc.w  20, 21
dc.w  21, 22
dc.w  22, 23
dc.w  23, 20
dc.w  16, 20
dc.w  17, 21
dc.w  18, 22
dc.w  19, 23
dc.w  24, 25
dc.w  25, 26
dc.w  26, 27
dc.w  27, 24
dc.w  28, 29
dc.w  29, 30
dc.w  30, 31
dc.w  31, 28
dc.w  24, 28
dc.w  25, 29
dc.w  26, 30
dc.w  27, 31
dc.w  32, 33
dc.w  33, 34
dc.w  34, 35
dc.w  35, 32
dc.w  36, 37
dc.w  37, 38
dc.w  38, 39
dc.w  39, 36
dc.w  32, 36
dc.w  33, 37
dc.w  34, 38
dc.w  35, 39


;Objects created with VectorEditor_V2.0 by Thomas Mattel
linepoints2: dc.w  119; 120 Linepoints
linequant2: dc.w  224*4; 225 Lines
linekoord2:blk.l  960/4,0
linekoords2:
dc.w 0,-75, 9, 20
dc.w 0,-75, 16, 15
dc.w 0,-75, 21, 6
dc.w 0,-75, 22,-3
dc.w 0,-75, 19,-12
dc.w 0,-75, 13,-19
dc.w 0,-75, 4,-23
dc.w 0,-75,-5,-23
dc.w 0,-75,-14,-19
dc.w 0,-75,-20,-12
dc.w 0,-75,-23,-3
dc.w 0,-75,-22, 6
dc.w 0,-75,-17, 15
dc.w 0,-75,-10, 20
dc.w 0,-75,-1, 22
dc.w 0,-36, 40, 91
dc.w 0,-36, 74, 67
dc.w 0,-36, 95, 31
dc.w 0,-36, 99,-11
dc.w 0,-36, 87,-51
dc.w 0,-36, 59,-82
dc.w 0,-36, 20,-99
dc.w 0,-36,-21,-99
dc.w 0,-36,-60,-82
dc.w 0,-36,-88,-51
dc.w 0,-36,-100,-11
dc.w 0,-36,-96, 31
dc.w 0,-36,-75, 67
dc.w 0,-36,-41, 91
dc.w 0,-36,-1, 100
dc.w 0,-15, 32, 72
dc.w 0,-15, 59, 53
dc.w 0,-15, 75, 24
dc.w 0,-15, 79,-9
dc.w 0,-15, 68,-40
dc.w 0,-15, 46,-65
dc.w 0,-15, 16,-78
dc.w 0,-15,-17,-78
dc.w 0,-15,-47,-65
dc.w 0,-15,-69,-40
dc.w 0,-15,-80,-9
dc.w 0,-15,-76, 24
dc.w 0,-15,-60, 53
dc.w 0,-15,-33, 72
dc.w 0,-15,-1, 79
dc.w 0,-15, 9, 21
dc.w 0,-15, 17, 16
dc.w 0,-15, 22, 7
dc.w 0,-15, 23,-3
dc.w 0,-15, 20,-12
dc.w 0,-15, 14,-20
dc.w 0,-15, 4,-24
dc.w 0,-15,-5,-24
dc.w 0,-15,-15,-20
dc.w 0,-15,-21,-13
dc.w 0,-15,-24,-3
dc.w 0,-15,-23, 7
dc.w 0,-15,-18, 16
dc.w 0,-15,-10, 21
dc.w 0,-15,-1, 24
dc.w 0, 48, 9, 21
dc.w 0, 48, 17, 16
dc.w 0, 48, 22, 7
dc.w 0, 48, 23,-3
dc.w 0, 48, 20,-12
dc.w 0, 48, 14,-20
dc.w 0, 48, 4,-24
dc.w 0, 48,-5,-24
dc.w 0, 48,-15,-20
dc.w 0, 48,-21,-13
dc.w 0, 48,-24,-3
dc.w 0, 48,-23, 7
dc.w 0, 48,-18, 16
dc.w 0, 48,-10, 21
dc.w 0, 48,-1, 24
dc.w 0, 48, 40, 90
dc.w 0, 48, 73, 66
dc.w 0, 48, 94, 30
dc.w 0, 48, 98,-11
dc.w 0, 48, 85,-50
dc.w 0, 48, 58,-81
dc.w 0, 48, 20,-97
dc.w 0, 48,-21,-97
dc.w 0, 48,-59,-81
dc.w 0, 48,-86,-50
dc.w 0, 48,-99,-11
dc.w 0, 48,-95, 30
dc.w 0, 48,-74, 66
dc.w 0, 48,-41, 90
dc.w 0, 48,-1, 99
dc.w 0, 69, 40, 90
dc.w 0, 69, 73, 66
dc.w 0, 69, 94, 30
dc.w 0, 69, 98,-11
dc.w 0, 69, 85,-50
dc.w 0, 69, 58,-81
dc.w 0, 69, 20,-97
dc.w 0, 69,-21,-97
dc.w 0, 69,-59,-81
dc.w 0, 69,-86,-50
dc.w 0, 69,-99,-11
dc.w 0, 69,-95, 30
dc.w 0, 69,-74, 66
dc.w 0, 69,-41, 90
dc.w 0, 69,-1, 99
dc.w 0, 75, 3, 6
dc.w 0, 75, 5, 5
dc.w 0, 75, 7, 2
dc.w 0, 75, 7,-1
dc.w 0, 75, 6,-4
dc.w 0, 75, 4,-7
dc.w 0, 75, 1,-8
dc.w 0, 75,-2,-8
dc.w 0, 75,-5,-7
dc.w 0, 75,-7,-4
dc.w 0, 75,-8,-1
dc.w 0, 75,-8, 2
dc.w 0, 75,-6, 5
dc.w 0, 75,-4, 6
dc.w 0, 75,-1, 7
lines2:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  9, 10
dc.w  10, 11
dc.w  11, 12
dc.w  12, 13
dc.w  13, 14
dc.w  0, 14
dc.w  15, 16
dc.w  16, 17
dc.w  17, 18
dc.w  18, 19
dc.w  19, 20
dc.w  20, 21
dc.w  21, 22
dc.w  22, 23
dc.w  23, 24
dc.w  24, 25
dc.w  25, 26
dc.w  26, 27
dc.w  27, 28
dc.w  28, 29
dc.w  15, 29
dc.w  30, 31
dc.w  31, 32
dc.w  32, 33
dc.w  33, 34
dc.w  34, 35
dc.w  35, 36
dc.w  36, 37
dc.w  37, 38
dc.w  38, 39
dc.w  39, 40
dc.w  40, 41
dc.w  41, 42
dc.w  42, 43
dc.w  43, 44
dc.w  30, 44
dc.w  45, 46
dc.w  46, 47
dc.w  47, 48
dc.w  48, 49
dc.w  49, 50
dc.w  50, 51
dc.w  51, 52
dc.w  52, 53
dc.w  53, 54
dc.w  54, 55
dc.w  55, 56
dc.w  56, 57
dc.w  57, 58
dc.w  58, 59
dc.w  45, 59
dc.w  60, 61
dc.w  61, 62
dc.w  62, 63
dc.w  63, 64
dc.w  64, 65
dc.w  65, 66
dc.w  66, 67
dc.w  67, 68
dc.w  68, 69
dc.w  69, 70
dc.w  70, 71
dc.w  71, 72
dc.w  72, 73
dc.w  73, 74
dc.w  60, 74
dc.w  75, 76
dc.w  76, 77
dc.w  77, 78
dc.w  78, 79
dc.w  79, 80
dc.w  80, 81
dc.w  81, 82
dc.w  82, 83
dc.w  83, 84
dc.w  84, 85
dc.w  85, 86
dc.w  86, 87
dc.w  87, 88
dc.w  88, 89
dc.w  75, 89
dc.w  90, 91
dc.w  91, 92
dc.w  92, 93
dc.w  93, 94
dc.w  94, 95
dc.w  95, 96
dc.w  96, 97
dc.w  97, 98
dc.w  98, 99
dc.w  99, 100
dc.w  100, 101
dc.w  101, 102
dc.w  102, 103
dc.w  103, 104
dc.w  90, 104
dc.w  105, 106
dc.w  106, 107
dc.w  107, 108
dc.w  108, 109
dc.w  109, 110
dc.w  110, 111
dc.w  111, 112
dc.w  112, 113
dc.w  113, 114
dc.w  114, 115
dc.w  115, 116
dc.w  116, 117
dc.w  117, 118
dc.w  118, 119
dc.w  105, 119
dc.w  0, 15
dc.w  1, 16
dc.w  2, 17
dc.w  3, 18
dc.w  4, 19
dc.w  5, 20
dc.w  6, 21
dc.w  7, 22
dc.w  8, 23
dc.w  9, 24
dc.w  10, 25
dc.w  11, 26
dc.w  12, 27
dc.w  13, 28
dc.w  14, 29
dc.w  15, 30
dc.w  16, 31
dc.w  17, 32
dc.w  18, 33
dc.w  19, 34
dc.w  20, 35
dc.w  21, 36
dc.w  22, 37
dc.w  23, 38
dc.w  24, 39
dc.w  25, 40
dc.w  26, 41
dc.w  27, 42
dc.w  28, 43
dc.w  29, 44
dc.w  30, 45
dc.w  31, 46
dc.w  32, 47
dc.w  33, 48
dc.w  34, 49
dc.w  35, 50
dc.w  36, 51
dc.w  37, 52
dc.w  38, 53
dc.w  39, 54
dc.w  40, 55
dc.w  41, 56
dc.w  42, 57
dc.w  43, 58
dc.w  44, 59
dc.w  45, 60
dc.w  46, 61
dc.w  47, 62
dc.w  48, 63
dc.w  49, 64
dc.w  50, 65
dc.w  51, 66
dc.w  52, 67
dc.w  53, 68
dc.w  54, 69
dc.w  55, 70
dc.w  56, 71
dc.w  57, 72
dc.w  58, 73
dc.w  59, 74
dc.w  60, 75
dc.w  61, 76
dc.w  62, 77
dc.w  63, 78
dc.w  64, 79
dc.w  65, 80
dc.w  66, 81
dc.w  67, 82
dc.w  68, 83
dc.w  69, 84
dc.w  70, 85
dc.w  71, 86
dc.w  72, 87
dc.w  73, 88
dc.w  74, 89
dc.w  75, 90
dc.w  76, 91
dc.w  77, 92
dc.w  78, 93
dc.w  79, 94
dc.w  80, 95
dc.w  81, 96
dc.w  82, 97
dc.w  83, 98
dc.w  84, 99
dc.w  85, 100
dc.w  86, 101
dc.w  87, 102
dc.w  88, 103
dc.w  89, 104
dc.w  90, 105
dc.w  91, 106
dc.w  92, 107
dc.w  93, 108
dc.w  94, 109
dc.w  95, 110
dc.w  96, 111
dc.w  97, 112
dc.w  98, 113
dc.w  99, 114
dc.w  100, 115
dc.w  101, 116
dc.w  102, 117
dc.w  103, 118
dc.w  104, 119


;Objects created with VectorEditor_V2.0 by Thomas Mattel
linepoints3: dc.w  79; 80 Linepoints
linequant3: dc.w  139*4; 140 Lines
linekoord3:blk.l  640/4,0
linekoords3:
dc.w 0,-36, 6, 18
dc.w 0,-36, 11, 15
dc.w 0,-36, 15, 11
dc.w 0,-36, 18, 6
dc.w 0,-36, 19, 0
dc.w 0,-36, 18,-7
dc.w 0,-36, 15,-12
dc.w 0,-36, 11,-16
dc.w 0,-36, 6,-19
dc.w 0,-36, 0,-20
dc.w 0,-36,-7,-19
dc.w 0,-36,-12,-16
dc.w 0,-36,-16,-12
dc.w 0,-36,-19,-7
dc.w 0,-36,-20, 0
dc.w 0,-36,-19, 6
dc.w 0,-36,-16, 11
dc.w 0,-36,-12, 15
dc.w 0,-36,-7, 18
dc.w 0,-36,-1, 19
dc.w 0,-65, 30, 92
dc.w 0,-65, 57, 78
dc.w 0,-65, 78, 57
dc.w 0,-65, 92, 30
dc.w 0,-65, 97, 0
dc.w 0,-65, 92,-31
dc.w 0,-65, 78,-58
dc.w 0,-65, 57,-79
dc.w 0,-65, 30,-93
dc.w 0,-65, 0,-98
dc.w 0,-65,-31,-93
dc.w 0,-65,-58,-79
dc.w 0,-65,-79,-58
dc.w 0,-65,-93,-31
dc.w 0,-65,-98, 0
dc.w 0,-65,-93, 30
dc.w 0,-65,-79, 57
dc.w 0,-65,-58, 78
dc.w 0,-65,-31, 92
dc.w 0,-65,-1, 97
dc.w 0, 3, 30, 92
dc.w 0, 3, 57, 78
dc.w 0, 3, 78, 57
dc.w 0, 3, 92, 30
dc.w 0, 3, 97, 0
dc.w 0, 3, 92,-31
dc.w 0, 3, 78,-58
dc.w 0, 3, 57,-79
dc.w 0, 3, 30,-93
dc.w 0, 3, 0,-98
dc.w 0, 3,-31,-93
dc.w 0, 3,-58,-79
dc.w 0, 3,-79,-58
dc.w 0, 3,-93,-31
dc.w 0, 3,-98, 0
dc.w 0, 3,-93, 30
dc.w 0, 3,-79, 57
dc.w 0, 3,-58, 78
dc.w 0, 3,-31, 92
dc.w 0, 3,-1, 97
dc.w 0, 65, 6, 19
dc.w 0, 65, 12, 16
dc.w 0, 65, 16, 12
dc.w 0, 65, 19, 6
dc.w 0, 65, 20, 0
dc.w 0, 65, 19,-7
dc.w 0, 65, 16,-13
dc.w 0, 65, 12,-17
dc.w 0, 65, 6,-20
dc.w 0, 65, 0,-21
dc.w 0, 65,-7,-20
dc.w 0, 65,-13,-17
dc.w 0, 65,-17,-13
dc.w 0, 65,-20,-7
dc.w 0, 65,-21, 0
dc.w 0, 65,-20, 6
dc.w 0, 65,-17, 12
dc.w 0, 65,-13, 16
dc.w 0, 65,-7, 19
dc.w 0, 65,-1, 20
lines3:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  9, 10
dc.w  10, 11
dc.w  11, 12
dc.w  12, 13
dc.w  13, 14
dc.w  14, 15
dc.w  15, 16
dc.w  16, 17
dc.w  17, 18
dc.w  18, 19
dc.w  0, 19
dc.w  20, 21
dc.w  21, 22
dc.w  22, 23
dc.w  23, 24
dc.w  24, 25
dc.w  25, 26
dc.w  26, 27
dc.w  27, 28
dc.w  28, 29
dc.w  29, 30
dc.w  30, 31
dc.w  31, 32
dc.w  32, 33
dc.w  33, 34
dc.w  34, 35
dc.w  35, 36
dc.w  36, 37
dc.w  37, 38
dc.w  38, 39
dc.w  20, 39
dc.w  40, 41
dc.w  41, 42
dc.w  42, 43
dc.w  43, 44
dc.w  44, 45
dc.w  45, 46
dc.w  46, 47
dc.w  47, 48
dc.w  48, 49
dc.w  49, 50
dc.w  50, 51
dc.w  51, 52
dc.w  52, 53
dc.w  53, 54
dc.w  54, 55
dc.w  55, 56
dc.w  56, 57
dc.w  57, 58
dc.w  58, 59
dc.w  40, 59
dc.w  60, 61
dc.w  61, 62
dc.w  62, 63
dc.w  63, 64
dc.w  64, 65
dc.w  65, 66
dc.w  66, 67
dc.w  67, 68
dc.w  68, 69
dc.w  69, 70
dc.w  70, 71
dc.w  71, 72
dc.w  72, 73
dc.w  73, 74
dc.w  74, 75
dc.w  75, 76
dc.w  76, 77
dc.w  77, 78
dc.w  78, 79
dc.w  60, 79
dc.w  0, 20
dc.w  1, 21
dc.w  2, 22
dc.w  3, 23
dc.w  4, 24
dc.w  5, 25
dc.w  6, 26
dc.w  7, 27
dc.w  8, 28
dc.w  9, 29
dc.w  10, 30
dc.w  11, 31
dc.w  12, 32
dc.w  13, 33
dc.w  14, 34
dc.w  15, 35
dc.w  16, 36
dc.w  17, 37
dc.w  18, 38
dc.w  19, 39
dc.w  20, 40
dc.w  21, 41
dc.w  22, 42
dc.w  23, 43
dc.w  24, 44
dc.w  25, 45
dc.w  26, 46
dc.w  27, 47
dc.w  28, 48
dc.w  29, 49
dc.w  30, 50
dc.w  31, 51
dc.w  32, 52
dc.w  33, 53
dc.w  34, 54
dc.w  35, 55
dc.w  36, 56
dc.w  37, 57
dc.w  38, 58
dc.w  39, 59
dc.w  40, 60
dc.w  41, 61
dc.w  42, 62
dc.w  43, 63
dc.w  44, 64
dc.w  45, 65
dc.w  46, 66
dc.w  47, 67
dc.w  48, 68
dc.w  49, 69
dc.w  50, 70
dc.w  51, 71
dc.w  52, 72
dc.w  53, 73
dc.w  54, 74
dc.w  55, 75
dc.w  56, 76
dc.w  57, 77
dc.w  58, 78
dc.w  59, 79



;Objects created with VectorEditor_V2.0 by Thomas Mattel
linepoints4: dc.w  67; 68 Linepoints
linequant4: dc.w  111*4; 112 Lines
linekoord4:blk.l  544/4,0
linekoords4:
dc.w 0,-70, 17, 53
dc.w 0,-70, 32, 45
dc.w 0,-70, 45, 32
dc.w 0,-70, 53, 17
dc.w 0,-70, 56, 0
dc.w 0,-70, 53,-18
dc.w 0,-70, 45,-33
dc.w 0,-70, 32,-46
dc.w 0,-70, 17,-54
dc.w 0,-70, 0,-56
dc.w 0,-70,-18,-54
dc.w 0,-70,-33,-46
dc.w 0,-70,-46,-33
dc.w 0,-70,-54,-18
dc.w 0,-70,-56, 0
dc.w 0,-70,-54, 17
dc.w 0,-70,-46, 32
dc.w 0,-70,-33, 45
dc.w 0,-70,-18, 53
dc.w 0,-70,-1, 56
dc.w 0,-2, 38, 118
dc.w 0,-2, 73, 100
dc.w 0,-2, 100, 73
dc.w 0,-2, 118, 38
dc.w 0,-2, 124, 0
dc.w 0,-2, 118,-39
dc.w 0,-2, 100,-74
dc.w 0,-2, 73,-101
dc.w 0,-2, 38,-119
dc.w 0,-2, 0,-125
dc.w 0,-2,-39,-119
dc.w 0,-2,-74,-101
dc.w 0,-2,-101,-74
dc.w 0,-2,-119,-39
dc.w 0,-2,-125, 0
dc.w 0,-2,-119, 38
dc.w 0,-2,-101, 73
dc.w 0,-2,-74, 100
dc.w 0,-2,-39, 118
dc.w 0,-2,-1, 124
dc.w 0, 67, 17, 53
dc.w 0, 67, 32, 45
dc.w 0, 67, 45, 32
dc.w 0, 67, 53, 17
dc.w 0, 67, 56,-1
dc.w 0, 67, 53,-18
dc.w 0, 67, 45,-33
dc.w 0, 67, 32,-46
dc.w 0, 67, 17,-54
dc.w 0, 67, 0,-56
dc.w 0, 67,-18,-54
dc.w 0, 67,-33,-46
dc.w 0, 67,-46,-33
dc.w 0, 67,-54,-18
dc.w 0, 67,-56,-1
dc.w 0, 67,-54, 17
dc.w 0, 67,-46, 32
dc.w 0, 67,-33, 45
dc.w 0, 67,-18, 53
dc.w 0, 67,-1, 56
dc.w 0, 19,-40,-20
dc.w 0, 47,-1, 8
dc.w 0, 19, 39,-20
dc.w 0,-9, 0,-48
dc.w 0,-20,-40, 19
dc.w 0, 8,-1, 47
dc.w 0,-20, 39, 19
dc.w 0,-48, 0,-9
lines4:
dc.w  0, 1
dc.w  1, 2
dc.w  2, 3
dc.w  3, 4
dc.w  4, 5
dc.w  5, 6
dc.w  6, 7
dc.w  7, 8
dc.w  8, 9
dc.w  9, 10
dc.w  10, 11
dc.w  11, 12
dc.w  12, 13
dc.w  13, 14
dc.w  14, 15
dc.w  15, 16
dc.w  16, 17
dc.w  17, 18
dc.w  18, 19
dc.w  0, 19
dc.w  20, 21
dc.w  21, 22
dc.w  22, 23
dc.w  23, 24
dc.w  24, 25
dc.w  25, 26
dc.w  26, 27
dc.w  27, 28
dc.w  28, 29
dc.w  29, 30
dc.w  30, 31
dc.w  31, 32
dc.w  32, 33
dc.w  33, 34
dc.w  34, 35
dc.w  35, 36
dc.w  36, 37
dc.w  37, 38
dc.w  38, 39
dc.w  20, 39
dc.w  40, 41
dc.w  41, 42
dc.w  42, 43
dc.w  43, 44
dc.w  44, 45
dc.w  45, 46
dc.w  46, 47
dc.w  47, 48
dc.w  48, 49
dc.w  49, 50
dc.w  50, 51
dc.w  51, 52
dc.w  52, 53
dc.w  53, 54
dc.w  54, 55
dc.w  55, 56
dc.w  56, 57
dc.w  57, 58
dc.w  58, 59
dc.w  40, 59
dc.w  0, 20
dc.w  1, 21
dc.w  2, 22
dc.w  3, 23
dc.w  4, 24
dc.w  5, 25
dc.w  6, 26
dc.w  7, 27
dc.w  8, 28
dc.w  9, 29
dc.w  10, 30
dc.w  11, 31
dc.w  12, 32
dc.w  13, 33
dc.w  14, 34
dc.w  15, 35
dc.w  16, 36
dc.w  17, 37
dc.w  18, 38
dc.w  19, 39
dc.w  20, 40
dc.w  21, 41
dc.w  22, 42
dc.w  23, 43
dc.w  24, 44
dc.w  25, 45
dc.w  26, 46
dc.w  27, 47
dc.w  28, 48
dc.w  29, 49
dc.w  30, 50
dc.w  31, 51
dc.w  32, 52
dc.w  33, 53
dc.w  34, 54
dc.w  35, 55
dc.w  36, 56
dc.w  37, 57
dc.w  38, 58
dc.w  39, 59
dc.w  60, 61
dc.w  61, 62
dc.w  62, 63
dc.w  63, 60
dc.w  64, 65
dc.w  65, 66
dc.w  66, 67
dc.w  67, 64
dc.w  60, 64
dc.w  61, 65
dc.w  62, 66
dc.w  63, 67



drawline:
lea	$dff000,a5

move.l	turnkoord,a0
move.l	lines,a1
move.w	linequant,d7

drawloop:
moveq	#0,d0
moveq	#0,d2

move.w	#150,d0
moveq	#127,d1
move.w	#150,d2
moveq	#127,d3

move.w	0(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d0
add.w	4(a0,a2.w),d1

move.w	2(a1,d7.w),a2

add.w	a2,a2
add.w	a2,a2
add.w	a2,a2
add.w	2(a0,a2.w),d2
add.w	4(a0,a2.w),d3

cmp.w	d0,d2
bne	notsamepoint
cmp.w	d1,d3
bne	notsamepoint
bra	samepoint

notsamepoint:
bsr	line

samepoint:
subq.w	#4,d7
bpl	drawloop

bwait1:	
btst	#14,dmaconr(a5)
bne	bwait1
rts



line:
moveq	#40,d6
mulu	d1,d6
moveq	#-$10,d5
and.w	d0,d5
lsr.w	#3,d5
add.w	d5,d6
add.l	otherplane,d6


	moveq	#0,d4
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
	lea	okttab,a3
	move.b	0(a3,d4),d4
add.w	d3,d3			;d3=2*kdelta

bwait2:	
btst	#14,dmaconr(a5)
bne	bwait2

	move.w	d3,bltbmod(a5)	;2*kdelta
sub.w	d2,d3			;2*kdelta-gdelta

bpl	nosign
bset	#6,d4
nosign:

	move.w	d3,bltaptl(a5)	;2*kdelta-gdelta
sub.w	d2,d3			;2*kdelta-2*gdelta
lsl.w	#6,d2			;gdelta*64
addq	#2,d2			;d2=gdelta*64+2
	move.l	d6,bltcpth(a5)	;startadresse linie
	move.l	d6,bltdpth(a5)	;startadresse linie
and.w	#$000f,d0		;unteren 4 bits von x-koord...
ror.w	#4,d0			;bits 0123 -> bits 12 13 14 15
or.w	#$0bca,d0		;USEx und LFx setzen
;move.w	d0,bltcon0(a5)
;move.w	d4,bltcon1(a5)	;oktant
movem.w	d0/d4,$dff040
moveq	#40,d4
	move.w	d4,bltcmod(a5)	;breite plane in bytes

;	move.w	d3,bltamod(a5)	;2*kdelta-2*gdelta
;	move.w	d4,bltdmod(a5)	;breite plane in bytes
movem.w	d3-d4,$dff064

	move.w	#$8000,bltadat(a5)	;fixwert
	move.w	linemask,bltbdat(a5)	;maske
	move.w	#$ffff,bltafwm(a5)	;fixwert

	move.w	d2,bltsize(a5)	;blitterstart
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

drawtext1:
move.l	text1adr,a3
;lea	font1cod,a2
lea	font1,a2

move.l	#plane1adr,a0
add.l	#160*15+6+40,a0
move.l	a0,a1
add.l	#80,a1

moveq	#6,d6		;7 lines
drawtext1l3:
moveq	#16,d7		;17 chars per line

drawtext1l2:
moveq	#0,d1
move.b	(a3)+,d1
;lsl.w	#7,d1
lsl.w	#6,d1

moveq	#15,d0
drawtext1l1:
move.w	(a2,d1.w),(a0)
;move.w	4(a2,d1.w),(a1)
move.w	32(a2,d1.w),(a1)
;add.l	#8,a2
add.l	#2,a2
add.l	#160,a0
add.l	#160,a1
dbf	d0,drawtext1l1
;sub.l	#8*16,a2
sub.l	#2*16,a2
sub.l	#16*160-2,a0
sub.l	#16*160-2,a1

dbf	d7,drawtext1l2
add.l	#160*22-34,a0
add.l	#160*22-34,a1
;btst.l	#0,d6
;beq	drawtext1l4
;add.l	#40,a0
;add.l	#40,a1
;bra	drawtext1l5

drawtext1l4:
;sub.l	#40,a0
;sub.l	#40,a1

drawtext1l5:

dbf	d6,drawtext1l3
move.l	a3,text1adr
rts

text1adr:	dc.l	text1
text1:
dc.b 8,5,12,12,15,0,6,15,12,11,19,43,43,43,0,0,0,13
dc.b 15,15,14,0,8,5,18,5,38,0,9,0,8,1,22,5,19,15,13
dc.b 5,0,13,5,19,19,1,7,5,19,0,20,15,41,14,21,11,5
dc.b 39,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,5,20,19
dc.b 0,3,15,14,20,9,14,21,5,0,0,0,0,20,8,5,0,7,15,15
dc.b 4,0,15,12,4,0,0,0,0,0,20,9,13,5,19,0,14,15,23
dc.b 43,43,43,0,13,9,7,8,20,25,13,21,26,46,19,16,9
dc.b 18,9,20,39,0,0,0,8,15,16,5,0,25,15,21,0,12,9,11
dc.b 5,0,0,0,0,20,8,5,0,2,15,15,20,9,14,20,18,15,37
dc.b 0,0,0,9,0,23,9,12,12,0,13,1,11,5,0,1,0,0,0,0,12
dc.b 9,20,20,12,5,0,4,5,14,20,18,15,0,0,0,0,9,14,0
dc.b 20,8,5,0,14,5,1,18,0,0,0,0,0,0,6,21,20,21,18,5
dc.b 37,0,0,0,0,0,0,0,18,9,16,46,7,1,12,12,15,23,19
dc.b 39,0,0,0,0,0,0,0,0,0,9,0,23,1,9,20,0,6,15,18,0
dc.b 25,1,0,0,0,0,4,9,19,11,13,1,7,0,43,0,0,0,0,4,21
dc.b 11,5,46,7,1,12,12,15,23,19,39,0,0,0,0,0,0,0,0
dc.b 23,8,1,20,0,1,2,15,21,20,0,20,15,0,0,0,0,13,1
dc.b 11,5,0,1,0,7,1,13,5,0,0,0,0,0,0,9,14,0,1,21,20
dc.b 21,13,14,44,44,44,0,9,3,5,0,3,21,2,5,46,7,1,12
dc.b 12,15,23,19,39,0,0,0,23,8,1,20,0,1,2,15,21,20
dc.b 0,1,0,0,0,0,0,4,18,21,13,41,19,5,19,19,9,15,14
dc.b 0,44,18,1,12,16,8,39,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b 0,19,15,18,18,25,0,6,15,18,0,20,8,5,0,0,0,0,4
dc.b 5,12,1,25,38,0,9,0,23,9,12,12,0,0,0,0,3,1,12,12
dc.b 0,25,15,21,0,19,15,15,14,43,1,14,4,0,1,7,1,9,14
dc.b 39,0,0,0,0,0,0,0,25,5,19,38,0,9,20,19,0,20,18
dc.b 21,5,37,37,37,0,37,37,37,14,21,11,5,0,9,19,0,2
dc.b 1,3,11,0,43,19,15,13,5,0,4,1,25,19,0,1,7,15,38
dc.b 0,0,0,14,21,11,5,0,1,14,4,0,9,0,12,5,6,20,0,0
dc.b 7,1,12,12,15,23,19,0,1,14,4,0,0,0,0,0,0,10,15
dc.b 9,14,5,4,0,19,16,9,18,9,20,37,0,0,0,4,21,11,5
dc.b 0,9,19,0,9,14,1,3,20,9,22,5,0,6,15,18,0,19,15
dc.b 13,5,0,13,15,14,20,8,19,37,37,3,15,26,0,8,9,19
dc.b 0,16,1,18,5,14,20,19,0,0,4,9,4,14,20,0,21,14,4
dc.b 5,18,19,20,1,14,4,0,20,8,1,20,0,3,15,13,16,21
dc.b 20,9,14,7,0,9,19,13,15,18,5,0,9,13,16,15,18,20
dc.b 1,14,20,0,0,0,20,8,1,14,0,19,3,8,15,15,12,37,0
dc.b 0,0,0,0,2,21,20,0,14,15,23,0,7,18,1,2,0,0,0,0
dc.b 0,19,15,13,5,20,8,9,14,7,0,20,15,0,0,0,0,0,23
dc.b 18,9,20,5,0,3,15,26,0,9,0,20,5,12,12,0,25,15,21
dc.b 0,19,15,13,5,0,3,15,15,12,0,1,14,4,9,13,16,15
dc.b 18,20,1,14,20,0,1,4,4,19,43,43,43,23,18,9,20,5
dc.b 0,21,19,0,6,15,18,0,1,14,25,0,18,5,1,19,15,14
dc.b 0,43,43,43,0,0,0,0,0,0,0,20,15,0,3,15,14,20,1
dc.b 3,20,0,19,16,9,18,9,20,23,18,9,20,5,0,20,15,39
dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b 0,0,41,41,41,41,41,0,14,21,11,5,0,41,41,41,41
dc.b 41,41,0,0,0,0,16,15,37,2,15,24,0,29,33,0,0,0,0
dc.b 0,0,31,30,27,27,0,0,15,2,5,18,1,12,13,0,0,19,1
dc.b 12,26,2,21,18,7,38,0,1,21,19,20,18,9,1,15,18,0
dc.b 23,18,9,20,5,0,20,15,39,0,0,0,0,0,0,0,0,0,0,0
dc.b 0,0,0,0,0,0,0,0,0,0,0,41,41,41,0,13,9,7,8,20,25
dc.b 13,21,26,0,41,41,41,0,0,0,0,19,41,28,31,30,0,30
dc.b 29,0,0,0,0,0,8,15,6,22,5,18,2,5,18,7,19,7,1,20
dc.b 1,14,32,0,0,0,8,5,12,19,9,14,7,2,15,18,7,0,0,0
dc.b 0,0,0,0,0,19,23,5,4,5,14,0,0,0,0,0,0,20,15,0,3
dc.b 15,14,20,1,3,20,0,0,0,0,0,0,0,7,1,12,12,15,23
dc.b 19,0,23,18,9,20,5,0,20,15,39,0,0,0,0,0,0,0,0,0
dc.b 0,0,0,0,0,0,0,0,41,41,41,41,41,41,0,18,9,16,0
dc.b 41,41,41,41,41,41,0,0,0,0,16,15,37,2,15,24,0,32
dc.b 35,0,0,0,0,0,0,31,30,36,36,0,0,8,1,12,12,5,9,14
dc.b 0,0,19,1,12,26,2,21,18,7,38,0,1,21,19,20,18,9
dc.b 1,255

even
starplane:	dc.l	0

ente:	dc.w	0

plane1adr:	blk.b	3*272*50,0
plane2adr:	blk.b	3*272*50,0


