;***************************************************
;*                                                 *
;*             Spiralscroller + Plasma             *
;*                                                 *
;* Part 7+8 of Megademo                            *
;*                                                 *
;* code by Moon/Gallows                            *
;***************************************************
     
>extern "data/fontb",blockdata+128
>extern "data/fonta",bobdat+128
>extern "data/thelogo",logo1plane
>extern "data/logosinus",logosinus
>extern "data/litsin",litsin
>extern "data/bigsin",bigsin
>extern "data/colors",colors
>extern "data/mod.akazuma",mt_data
execbase=4
allocmem=-198
freemem=-210
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize=52*300
chip=2
clear=chip+$10000
startlist=38
openlibrary=-30-522
dmaconr=$002
intena=$09a

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


a:
start:
	move.l	execbase,a6
	jsr	forbid(a6)
	lea	$dff000,a5
	move.w	#$03e0,dmacon(a5)

	move.w	#$1a64,diwstrt(a5)
	move.w	#$39d1,diwstop(a5)
	move.w	#$0020,ddfstrt(a5)
	move.w	#$00d8,ddfstop(a5)
	move.w	#%0011001000000000,bplcon0(a5)
	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
	move.w	#4,bpl1mod(a5)
	move.w	#4,bpl2mod(a5)
jsr	switchplanes
jsr	switchplanes

move.l	#copperlist21,thiscopper
move.l	#copperlist22,othercopper
	move.l	#copperlist,cop1lch(a5)
	clr.w	copjmp1(a5)
	move.w	#%1000001111000000,dmacon(a5)
jsr	fader
;jsr	fullcls

move.l	#plane1adr,a0
move.l	#11712,d0
clrloop:
move.l	#0,(a0)+
dbf	d0,clrloop

jsr	mt_init

	jsr 	intstart

move.w	#$0000,$dff180
wait:
;move.w	#$0ff0,$dff180

;	btst	#6,ciaapra
;	beq	back
cmp.w	#1,backflag
beq	back


move.w	comakt,d0
cmp.w	#1,d0
bne	nocom1_2
	move.b	flag,d0
	cmp.b	#1,d0
	beq	wait
	jsr	copper2copy
nocom1_2:
jmp	wait


back:

	jsr	intstop
jsr	mt_end
	move.l	execbase,a6
	lea	$dff000,a5
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
	move.w	#%0010000001100000,$dff09a	;interrupt fuer
						; autovektor 3 sperren
						; (blitter/vertblank)
	move.l	$6c,oldint
	move.l	#introut,$6c			;adresse des intprogs
						; auf autovector 3
	move.w	#%1100000000100000,$dff09a	;vertblank interr.
						;einschalten
	rts
;;
introut:			;interruptroutine
	btst.b	#5,$dff01f	;bit 5 testen(=verticalinterrupt)
	beq	intback		;nein,dann ist interrupt vom blitter

	movem.l	d0-d7/a0-a6,-(a7)
jsr	mt_music


jsr	commander
jsr	realfade

move.w	comakt,d0
cmp.w	#1,d0
bne	nocom1
sub.b	#1,flag

bne	nocalc
move.b	#3,flag
nocalc:
jsr	coppercopy
	btst	#6,ciaapra
	bne	noback2

;move.w	#400,comsleep
;move.w	#1,wurzelsepp
jsr	return

noback2:

nocom1:
cmp.w	#2,d0
bne	nocom2

jsr	switchplanes
jsr	planecls

;move.w	#$ff0,$dff180
jsr	firstcoppercopy
;move.w	#$f0f,$dff180
jsr	starmove

;move.w	#$fff,$dff180
bltwait3:	btst	#14,dmaconr(a5)
		bne	bltwait3

jsr	drawbobs
;move.w	#$005,$dff180




nocom2:


;move.w	#$f00,$dff180


	movem.l	(a7)+,d0-d7/a0-a6


intback:
;move.l	#$dff000,a5
;bltwait0:	btst	#14,dmaconr(a5)
;		bne	bltwait0


	move.w	#%0000000001100000,$dff09c	;interruptflag
				;vom blitter und verticalblkint
				;loeschen


	rte			;return from exeption
intstop:
	move.l	oldint,$6c
	rts

blk.w	300,$666
;colors:

dc.w	21,$0fff
dc.w	21,$0f00
dc.w	21,$00f0
dc.w	21,$000f
dc.w	21,$0ff0
dc.w	21,$00ff
dc.w	21,$0f0f

colors:	blk.l	694,0







bigsin:	blk.l	720,0

litsin:	blk.l	900,0


oldint:		dc.l	0
logo1plane:	blk.l	62*104/4,0
logo2plane:	blk.l	62*104/4,0
logo3plane:	blk.l	62*104/4,0
;plane1adr:	blk.l	300*52/4,0
;plane2adr:	blk.l	300*52/4,0
;plane3adr:	blk.l	300*52/4,0
;plane4adr:	blk.l	300*52/4,0

plane1adr:	dcb.b	$3d00
plane2adr:	dcb.b	$3d00
plane3adr:	dcb.b	$3d00
plane4adr:	dcb.b	$3d00



planesend:
;plane5adr:	blk.l	300*52/4,$ffffffff
thisplane:	dc.l	0
otherplane:	dc.l	0



copperlist:	blk.w	100,0
copperlist21:	blk.w	10000,0
copperlist22:	blk.w	10000,0
copper3list:	blk.w	100,0

thiscopper:	dc.l	0
othercopper:	dc.l	0
switchmark:	dc.w	0
switchplanes:
move.w	switchmark,d0
beq	swplane2
move.w	#0,switchmark
move.l	#plane1adr,thisplane
move.l	#plane3adr,otherplane
rts
swplane2:
move.w	#1,switchmark
move.l	#plane3adr,thisplane
move.l	#plane1adr,otherplane
rts

grname:		dc.b	"graphics.library",0
even
flag:		dc.b	2
even




copoffx1:	dc.w	0
copoffx2:	dc.w	0
copoffy1:	dc.w	0
copoffy2:	dc.w	0

copoffdifx1:	dc.w	8
copoffdify1:	dc.w	16

copoffspex1:	dc.w	10
copoffspey1:	dc.w	12
otherpos:	dc.w	0
otherscroll:	dc.w	0
;register in coppercopy-routine...
;	a0,copperlistadress
;	a1,coloradress
;	a2,litsineadress
;	d0,spaltenschleifenzaehler
;	d1,zeilenschleifenzaehler
;	d2,waitcode fuer copper
;

copperswitch:	dc.w	0
copper2copy:
move.w	#720,d5

move.w	copoffy1,d3		;offset fuer farbdaten laden
add.w	copoffspey1,d3		;coloroffset erhoehen
cmp.w	d5,d3			;sine overflow
blt	noresy1			;no,range in first wave
sub.w	d5,d3			;yes,range in second wave,sub pi (360deg)
noresy1:
move.w	d3,copoffy1		;write back into memory


move.w	copoffx1,d3		;offset fuer farbdaten laden
add.w	copoffspex1,d3		;coloroffset erhoehen
cmp.w	d5,d3			;sine overflow
blt	noresx1			;no,range in first wave
sub.w	d5,d3			;yes,range in second wave,sub pi (360deg)
noresx1:
move.w	d3,copoffx1		;write back into memory


move.w	copoffdify1,a4		;coloroffset erhoehen



move.l	thiscopper,a0	;basisadresse der copperlist
move.l	#colors,a1	;basisadresse der farbdaten
move.l	#$603f,d2	;504flinke obere ecke des copperfeldes
move.l	#143,d1		;anzahl der zeilen des copperfeldes

move.w	copoffx1,d6	;offsety1 fuer farbdaten laden

move.l	#bigsin,a2
move.l	#litsin,a3


coppercopyl2:
move.l	#14,d0		;spaltenschleifenzaehler setzen
;;
move.w	0(a3,d6.w),d5

move.w	d5,d4
lsr.w	#1,d5
and.w	#%1111111111111110,d5		;lowerbits loeschen
and.w	#%0000000000001111,d4


move.w	#$102,(a0)+		;bitplanetrick
move.w	d4,(a0)+		;put colorcode into copperlist
add.w	d2,d5

move.w	d5,(a0)+	;warten auf ...
move.w	#$fffe,(a0)+	;		...zeilenanfang

move.w	copoffy1,d3	;offsety1 fuer farbdaten laden

coppercopyl1:
move.w	0(a2,d3.w),d5
move.w	#$180,(a0)+		;change backgroundcolor
move.w	0(a1,d5.w),(a0)+	;put colorcode into copperlist
add.w	a4,d3			;coloroffset erhoehen

move.w	0(a2,d3.w),d5
move.w	#$182,(a0)+		;change backgroundcolor
move.w	0(a1,d5.w),(a0)+		;put colorcode into copperlist
add.w	a4,d3			;coloroffset erhoehen

dbf	d0,coppercopyl1


add.w	copoffdifx1,d6		;coloroffset erhoehen
move.w	#$180,(a0)+	;rest der zeile ...
move.w	#0,(a0)+	;		   ...auf schwarz stellen
move.w	#$182,(a0)+	;rest der zeile ...
move.w	#$0,(a0)+	;		   ...auf schwarz stellen
add.w	#2,a1		;coloradress erhoehen

add.w	#$0100,d2
dbf	d1,coppercopyl2

;move.l	#$fffffffe,(a0)+
;rts
move.l	#copper3list,d0	;1. logo fertig,jetzt copperroutine
move.w	#$0086,(a0)+
move.w	d0,(a0)+
move.w	#$0084,(a0)+
swap	d0
move.w	d0,(a0)+
move.l	#$008a0000,(a0)+	;copper startet sich selber (ja ja..)


move.w	copperswitch,d0
beq	changecopper
move.w	#0,copperswitch
move.l	#copperlist21,thiscopper
move.l	#copperlist22,othercopper
bra	copper2copymain
changecopper:
move.w	#1,copperswitch
move.l	#copperlist22,thiscopper
move.l	#copperlist21,othercopper
copper2copymain:

rts






coppercopy:	;mainroutine,every frame

move.l	#copperlist,a0	;basisadresse der copperlist
;move.l	#colors,a1	;basisadresse der farbdaten
;move.l	#$604f,d2	;504flinke obere ecke des copperfeldes
;move.l	#143,d1		;anzahl der zeilen des copperfeldes

;move.w	copoffx1,d6	;offsety1 fuer farbdaten laden

move.l	#logosinus,a2
move.l	#0,d0
move.w	sepp,d0		;scrollwert 0-415
add.w	#10,d0
cmp.w	#1438,d0
ble	noruck
move.w	#0,d0
noruck:
move.w	d0,sepp
move.w	0(a2,d0.w),d0

move.l	#0,d4
move.w	d0,d4
and.w	#%0000000000001111,d4
move.w	d4,d5
lsl.w	#4,d5
add.w	d4,d5
move.w	d5,otherscroll
not.w d5
move.w	#$0102,(a0)+
move.w	d5,(a0)+

lsr.w	#4,d0
add.w	d0,d0
move.w	d0,d4




move.l	#logo1plane,d0
add.l	d4,d0
move.w	#$0e2,(a0)+
move.w	d0,(a0)+
move.w	#$0e0,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#logo2plane,d0
add.l	d4,d0
move.w	#$0e6,(a0)+
move.w	d0,(a0)+
move.w	#$0e4,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#logo3plane,d0
add.l	d4,d0
move.w	#$0ea,(a0)+
move.w	d0,(a0)+
move.w	#$0e8,(a0)+
swap	d0
move.w	d0,(a0)+
move.w	#1090,d0
sub.w	d4,d0
move.w	d0,otherpos

move.l	#$01080038,(a0)+
move.l	#$010a0038,(a0)+

move.l	#$2901fffe,(a0)+
move.l	#faded,a1

move.w	#$0180,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0182,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0184,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0186,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0188,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018a,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018c,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018e,(a0)+
move.w	(a1)+,(a0)+

move.l	#$5801fffe,(a0)+


;now mainbitplane

move.l	#plane1adr,d0
move.w	#$0e2,(a0)+
move.w	d0,(a0)+
move.w	#$0e0,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#plane2adr,d0
move.w	#$0e6,(a0)+
move.w	d0,(a0)+
move.w	#$0e4,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#plane3adr,d0
move.w	#$0ea,(a0)+
move.w	d0,(a0)+
move.w	#$0e8,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#$01080004,(a0)+
move.l	#$010a0004,(a0)+

move.l	#$5f01fffe,(a0)+
move.l	#$0180000f,(a0)+
move.l	#$01820000,(a0)+
move.l	#$6001fffe,(a0)+
move.l	#$01800000,(a0)+




move.l	othercopper,d0	;1. logo fertig,jetzt copperroutine
move.w	#$0086,(a0)+
move.w	d0,(a0)+
move.w	#$0084,(a0)+
swap	d0
move.w	d0,(a0)+
move.l	#$008a0000,(a0)+	;copper startet sich selber (ja ja..)





move.l	#copper3list,a0

move.l	#$f001fffe,(a0)+
move.l	#$0180000f,(a0)+
move.l	#$f101fffe,(a0)+
move.l	#$01800000,(a0)+



move.w	otherpos,d4
move.w	otherscroll,d5

move.w	#$0102,(a0)+
move.w	d5,(a0)+

move.l	#logo1plane,d0
add.l	d4,d0
move.w	#$0e2,(a0)+
move.w	d0,(a0)+
move.w	#$0e0,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#logo2plane,d0
add.l	d4,d0
move.w	#$0e6,(a0)+
move.w	d0,(a0)+
move.w	#$0e4,(a0)+
swap	d0
move.w	d0,(a0)+

move.l	#logo3plane,d0
add.l	d4,d0
move.w	#$0ea,(a0)+
move.w	d0,(a0)+
move.w	#$0e8,(a0)+
swap	d0
move.w	d0,(a0)+


move.l	#$01080038,(a0)+
move.l	#$010a0038,(a0)+

move.l	#faded,a1

move.w	#$0180,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0182,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0184,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0186,(a0)+
move.w	(a1)+,(a0)+
move.w	#$0188,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018a,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018c,(a0)+
move.w	(a1)+,(a0)+
move.w	#$018e,(a0)+
move.w	(a1)+,(a0)+


move.l	#$ffddfffe,(a0)+

move.l	#$2501fffe,(a0)+
move.l	#$01800000,(a0)+
move.l	#$01820000,(a0)+
move.l	#$01840000,(a0)+
move.l	#$01860000,(a0)+
move.l	#$01880000,(a0)+
move.l	#$018a0000,(a0)+
move.l	#$018c0000,(a0)+
move.l	#$018e0000,(a0)+





move.l	#$fffffffe,(a0)+
rts





drawraster:
move.l	#plane1adr,a0
add.l	#8*52+4,a0
move.l	#1870,d0
drawrasterloop:
move.l	#%00000000111111110000000011111111,(a0)+
dbf	d0,drawrasterloop

rts

drawlogo:


move.l	#logo1plane,a0
move.l	#plane4adr,a1
add.l	#15*104+6+26,a0
move.l	#46,d0
drawlogoloop1:
move.l	(a1)+,(a0)
move.l	(a1)+,$4(a0)
move.l	(a1)+,$8(a0)
move.l	(a1)+,$c(a0)
move.l	(a1)+,$10(a0)
move.l	(a1)+,$14(a0)
move.l	(a1)+,$18(a0)
move.l	(a1)+,$1c(a0)
move.l	(a1)+,$20(a0)
add.l	#104,a0
dbf d0,drawlogoloop1



move.l	#logo2plane,a0
add.l	#15*104+6+26,a0
move.l	#46,d0
drawlogoloop2:
move.l	(a1)+,(a0)
move.l	(a1)+,$4(a0)
move.l	(a1)+,$8(a0)
move.l	(a1)+,$c(a0)
move.l	(a1)+,$10(a0)
move.l	(a1)+,$14(a0)
move.l	(a1)+,$18(a0)
move.l	(a1)+,$1c(a0)
move.l	(a1)+,$20(a0)
add.l	#104,a0
dbf d0,drawlogoloop2



move.l	#logo3plane,a0
add.l	#15*104+6+26,a0
move.l	#46,d0
drawlogoloop3:
move.l	(a1)+,(a0)
move.l	(a1)+,$4(a0)
move.l	(a1)+,$8(a0)
move.l	(a1)+,$c(a0)
move.l	(a1)+,$10(a0)
move.l	(a1)+,$14(a0)
move.l	(a1)+,$18(a0)
move.l	(a1)+,$1c(a0)
move.l	(a1)+,$20(a0)
add.l	#104,a0
dbf d0,drawlogoloop3


rts



sepp:	dc.w	0
sepp2:	dc.w	2
sepp3:	dc.w	0

logosinus:	blk.l	360,0


end:

comakt:		dc.w	0
comsleep:	dc.w	1
compoint:	dc.w	0
commands:
dc.w	50,10	;copperroutine-stars ein
dc.w	65535,11	;stars blau

dc.w	10,1	;set copperflag

dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	50,8
dc.w	100,9
dc.w	300,4
dc.w	300,3
dc.w	300,5
dc.w	300,6
dc.w	300,7
dc.w	100,20

dc.w	0,0
commander:
;move.w	comsleep,d0
sub.w	#1,comsleep			;warteschleife...
bne	nonewcom		;-nicht aus..
move.l	#commands,a0		;-aus-->neues command lesen
move.w	compoint,d0		;zeiger auf commands
move.w	0(a0,d0.w),d1		;load command
bne	nocomrestart		;restart commands?
move.w	#0,d0			;-yes,offset=0
move.w	0(a0,d0.w),d1		;load command
nocomrestart:
;now first command in d1= new waitcounter..
move.w	d1,comsleep		;store next counter
move.w	2(a0,d0.w),d1		;read maincommandcode
addq.w	#4,d0			;offset next command
move.w	d0,compoint		;--> store

move.l	#$dff000,a5




comtest1:
cmp.w	#1,d1		;copperroutine on ??
bne	comtest2

move.l	#copperlist21,thiscopper
move.l	#copperlist22,othercopper
move.l	thiscopper,a0
move.l	#$fffffffe,(a0)
jsr	coppercopy
jsr	copper2copy
move.l	#copperlist,cop1lch(a5)
clr.w	copjmp1(a5)
move.w	#%0011001000000000,bplcon0(a5)
jsr	fullcls
jsr	drawraster
move.w	#%000000000,$dff144
move.w	#%000000000,$dff146

move.w	#1,comakt
rts



comtest2:
cmp.w	#2,d1		;copperroutine off ??
bne	comtest3
move.w	#0,comakt
move.l	#copperlist,a0
move.l	#$fffffffe,(a0)
move.l	a0,cop1lch(a5)
clr.w	copjmp1(a5)
rts




comtest3:
cmp.w	#3,d1
bne	comtest4
move.w	#6,fadecount
jsr	putgrey
rts


comtest4:
cmp.w	#4,d1
bne	comtest5
move.w	#6,fadecount
jsr	putred
rts


comtest5:
cmp.w	#5,d1
bne	comtest6
move.w	#6,fadecount
jsr	putblue
rts


comtest6:
cmp.w	#6,d1
bne	comtest7
move.w	#6,fadecount
jsr	putgreen
rts


comtest7:
cmp.w	#7,d1
bne	comtest8
move.w	#6,fadecount
jsr	putyello
rts


comtest8:
cmp.w	#8,d1
bne	comtest9
move.w	#1,fadecount
jsr	putallwhite

rts


comtest9:
cmp.w	#9,d1
bne	comtest10
move.w	#2,fadecount
jsr	putwhite
rts


comtest10:
cmp.w	#10,d1
bne	comtest11
move.l	#copperlist21,a0
move.l	#$fffffffe,(a0)
move.l	a0,cop1lch(a5)
clr.w	copjmp1(a5)

move.w	#$3d6a,$dff140
move.w	#$f700,$dff142
move.w	#%000000001,$dff144
move.w	#%000000001,$dff146
	move.w	#%0010001000000000,bplcon0(a5)
	clr.w	bplcon1(a5)
	clr.w	bplcon2(a5)
	move.w	#52,bpl1mod(a5)
	move.w	#52,bpl2mod(a5)
jsr	fullcls
;;
move.w	#2,comakt
;jsr	drawfield

rts


comtest11:
cmp.w	#11,d1
bne	comtest12
move.w	#15,fadecount
jsr	putspritecol
rts


comtest12:
cmp.w	#12,d1
bne	comtest13
move.w	#15,fadecount
jsr	putspr2
rts




comtest13:
cmp.w	#13,d1
bne	comtest20
move.w	#15,fadecount
jsr	putspritetextcol
rts



comtest20:
cmp.w	#20,d1
bne	nonewcom
jsr	return

nonewcom:
rts	



;seppi:	dc.w	0

tofade:		blk.w	32,$0000
faded:		blk.w	32,$0000
fadedat:	blk.w	32*16,$ffff
fadeflag:	dc.w	0
fader:
move.l	#tofade,a2	;scr-farbdaten
move.l	#fadedat,a1	;obj-farbdaten
move.l	#faded,a0	;akt-farbdaten
move.l	#31,d0		;anzahl farben

faderloop1:
move.l	#14,d1		;anzahl faderschritte
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
add.w	#%1,d2
bra	nobluefade
blueblack:
sub.w	#1,d2
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



putblack:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+;spritecol
jsr	fader
rts

putspritetextcol:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$00bc,(a0)+
move.w	#$008a,(a0)+
move.w	#$0057,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$000f,(a0)+;spritecol

jsr	fader
rts

;;
putspritecol:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$000f,(a0)+;spritecol
jsr	fader
rts


putspr2:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+
move.w	#$0000,(a0)+;spritecol
jsr	fader
rts

putgrey:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0f0f,(a0)+
move.w	#$0444,(a0)+
move.w	#$0666,(a0)+
move.w	#$0888,(a0)+
move.w	#$0aaa,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0fff,(a0)+
jsr	fader
rts

putyello:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0f00,(a0)+
move.w	#$0440,(a0)+
move.w	#$0660,(a0)+
move.w	#$0880,(a0)+
move.w	#$0aa0,(a0)+
move.w	#$0cc0,(a0)+
move.w	#$0ff0,(a0)+
jsr	fader
rts

putgreen:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0f00,(a0)+
move.w	#$0040,(a0)+
move.w	#$0060,(a0)+
move.w	#$0080,(a0)+
move.w	#$00a0,(a0)+
move.w	#$00c0,(a0)+
move.w	#$00f0,(a0)+
jsr	fader
rts

putblue:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0ff0,(a0)+
move.w	#$0044,(a0)+
move.w	#$0066,(a0)+
move.w	#$0088,(a0)+
move.w	#$00aa,(a0)+
move.w	#$00cc,(a0)+
move.w	#$00ff,(a0)+
jsr	fader
rts

putallwhite:
move.l	#tofade,a0
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
move.w	#$0fff,(a0)+
jsr	fader
rts

putwhite:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
move.w	#$0ccc,(a0)+
jsr	fader
rts

putred:
move.l	#tofade,a0
move.w	#$0000,(a0)+
move.w	#$00a0,(a0)+
move.w	#$0400,(a0)+
move.w	#$0600,(a0)+
move.w	#$0800,(a0)+
move.w	#$0a00,(a0)+
move.w	#$0c00,(a0)+
move.w	#$0f00,(a0)+
jsr	fader
rts

fullcls:	;loescht ganzen screen mit prozessor
		;faster als mit blitter !!!
move.l	#0,d0
move.l	d0,d1
move.l	d0,d2
move.l	d0,d3
move.l	d0,a0
move.l	d0,a1
move.l	d0,a2
move.l	d0,a3
move.l	#plane1adr,a4
;add.l	#176*24+4,a4
;add.l	#44*418,a4
move.l	#1949,d4
move.l	#32,d5
clearloop:
movem.l	d0-d3/a0-a3,(a4)
add.l	d5,a4
dbf	d4,clearloop
rts





fadesleep:	dc.w	1
fadecount:	dc.w	3



realfade:
;rts
move.w	fadesleep,d0
beq	fadeit
subq.w	#1,d0
move.w	d0,fadesleep
rts


fadeit:
move.w	fadecount,fadesleep
;rts
move.w	fadeflag,d0
cmp.w	#28,d0
bne	fadereal
rts
fadereal:
addq.w	#2,d0
move.w	d0,fadeflag

move.l	#fadedat,a0
move.l	#faded,a1

;move.l	#0,d0

move.w	0(a0,d0.w),(a1)+	;180
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;182
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;184
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;186
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;188
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;18a
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;18c
add.l	#30,d0
move.w	0(a0,d0.w),(a1)+	;18e
add.l	#30,d0
move.w	0(a0,d0.w),spritecol

rts



;spritelist:	dc.w	$3d5a,$f700
;		blk.l	186,1
;endoflist:	dc.w	0,0

;stars:	blk.l	150,0


starmove:
move.l	#stars,a0
moveq	#65,d0
starmovloop:
addq.w	#1,(a0)+
addq.w	#2,(a0)+
addq.w	#3,(a0)+
addq.w	#4,(a0)+
dbf	d0,starmovloop
rts

firstcoppercopy:
move.l	#copperlist21,a0
move.l	#stars,a2

move.l	otherplane,d0

move.w	#$0e2,(a0)+
move.w	d0,(a0)+
move.w	#$0e0,(a0)+
swap	d0
move.w	d0,(a0)+
swap	d0

add.l	#50,d0
move.w	#$0e6,(a0)+
move.w	d0,(a0)+
move.w	#$0e4,(a0)+
swap	d0
move.w	d0,(a0)+




move.l	#260,d0
move.w	#$23dd,d1
;move.l	#$ffddfffe,(a0)+
firstcopcopyl1:
move.w	d1,(a0)+
move.w	#$fffe,(a0)+
move.w	#$1a6,(a0)+
move.w	spritecol,(a0)+

;move.w	#$180,(a0)+
;move.w	#$000,(a0)+

move.l	#$018200bc,(a0)+
move.l	#$0184008a,(a0)+
move.l	#$01860057,(a0)+



move.w	#$140,(a0)+
move.w	(a2)+,(a0)+

add.w	#$0100,d1
dbf	d0,firstcopcopyl1

;move.l	#$01800000,(a0)+
move.l	#$01a60000,(a0)+
move.l	#$fffffffe,(a0)+
rts


;spritelist:	dc.w	$3d5a,$f700


spritecol:	dc.w	0
stars:
dc.w 30,166,221,186,203,18,125,115,27,242,179,135,247,81,243,238,136
dc.w 143,171,179,188,170,115,85,39,187,138,108,14,195,130,143,188
dc.w 168,59,118,32,123,14,92,145,252,73,167,239,96,227,203,241,82
dc.w 105,108,186,55,56,194,174,182,238,66,131,120,35,123,155,45,83
dc.w 62,145,206,31,2,18,42,181,133,237,156,141,183,110,26,87,212,232
dc.w 115,49,209,146,216,29,250,148,156,177,217,97,58,17,89,71,149
dc.w 26,44,68,131,223,105,27,139,91,122,167,238,93,53,111,229,199
dc.w 73,124,42,252,220,103,185,151,114,182,216,89,17,105,85,102,162
dc.w 207,15,176,155,158,183,179,219,67,216,99,213,119,22,98,241,19
dc.w 178,119,48,37,87,60,14,67,16,23,172,32,151,106,47,92,214,15,99
dc.w 160,168,254,163,234,223,81,253,39,140,107,146,0,123,115,61,245

dc.w 252,8,117,175,233,48,115,146,228,144,151,147,224,226,8,73,228
dc.w 165,154,70,13,15,245,167,209,72,244,234,138,217,76,1,50,99,110
dc.w 163,107,140,174,234,195,64,164,27,55,22,211,192,245,15,136,252
dc.w 103,133,6,33,108,99,223,122,232,146,165,110,128,180,194,199,159
dc.w 22,165,100,100,100,100,100,100,100,100,100,100,100,100

blockdata:	blk.l	1440+32,0
bobdat:		blk.l	1440+32,0





planecls:
		move.l	#$dff000,a5
bltwaitq3:	btst	#14,dmaconr(a5)
		bne	bltwaitq3
		move.w	#6,bltdmod(a5)		;d-modulo=0
		move.l	#$01000000,bltcon0(a5)	;bltcon0 & bltcon1
		move.l	otherplane,a0		;planeadresse laden
		add.l	#100*15+4,a0
		move.l	a0,bltdpth(a5)		;ziel=scrstart+offsetdat
		move.l	#$ffffffff,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#28182,bltsize(a5)	;h=250,l=21 (blitter starten);
		rts
sdata:		dc.w	49
boboffset:	blk.w	100,0
koord:	
dc.w	0,50
dc.w	30,50
dc.w	60,50
dc.w	90,50
dc.w	0,0
dc.w	150,50
dc.w	180,50
dc.w	210,50
dc.w	240,50
dc.w	270,50

dc.w	00,75
dc.w	30,75
dc.w	60,75
dc.w	90,75
dc.w	120,75
dc.w	150,75
dc.w	180,75
dc.w	210,75
dc.w	240,75
dc.w	270,75

dc.w	00,100
dc.w	30,100
dc.w	60,100
dc.w	90,100
dc.w	120,100
dc.w	150,100
dc.w	180,100
dc.w	210,100
dc.w	240,100
dc.w	270,100

dc.w	00,125
dc.w	30,125
dc.w	60,125
dc.w	90,125
dc.w	120,125
dc.w	150,125
dc.w	180,125
dc.w	210,125
dc.w	240,125
dc.w	270,125

dc.w	00,150
dc.w	30,150
dc.w	60,150
dc.w	90,150
dc.w	120,150
dc.w	150,150
dc.w	180,150
dc.w	210,150
dc.w	400,150
dc.w	400,150
koordend:

dc.w	350,350
textbob:	dc.w	48
textpoint:	dc.w	0
textscrollwait:	dc.w	1

drawbobs:
sub.w	#1,textscrollwait
bne	notextscroll
move.w	#7,textscrollwait

move.w	textbob,d2
add.w	#1,d2
cmp.w	#49,d2
bne	notextbobrestart
move.w	#0,d2
notextbobrestart:
move.w	d2,textbob
lsl.w	#1,d2
move.l	#boboffset,a0

move.l	#text,a1
move.w	textpoint,d1
add.w	#1,d1
moveq	#0,d0
move.b	0(a1,d1.w),d0
cmp.b	#255,d0
bne	wetex
move.w	#1,comsleep
wetex:
cmp.w	#1,wurzelsepp
bne	notextend
move.b	#0,d0

notextend:
;;
move.w	d1,textpoint
lsl.w	#7,d0

move.w	d0,0(a0,d2.w)

;;
notextscroll:
	btst	#6,ciaapra
	bne	noback

move.w	#400,comsleep
move.w	#1,wurzelsepp

noback:
move.l	#gurke,a0
move.l	#koord,a1
move.w	gurkpoint,d0
move.l	#49,d1
drawbobsl1:
move.l	0(a0,d0.w),(a1)
add.l	#4,a1
add.l	#28,a0
dbf	d1,drawbobsl1

add.w	#4,d0
cmp.w	#$55c,d0
bne	nogurkrestart
move.w	#0,d0
nogurkrestart:
move.w	d0,gurkpoint

		move.l	#$dff000,a5

bltwaitw3:	btst	#14,dmaconr(a5)
		bne	bltwaitw3

		move.w	#0,bltamod(a5)		;quelle modulo=0
		move.w	#0,bltbmod(a5)
		move.w	#46,bltdmod(a5)		;zielmodulo=plane-4 (44-4)
		move.w	#46,bltcmod(a5)		;ziel auch als quelle
move.w	sdata,d0	;bobanzahl
move.l	#koordend,a1
move.l	#boboffset,a3

;add.w	#6,koord+4
;add.w	#2,koord+6
drawbobl1:
moveq	#0,d1
moveq	#0,d2
move.w	-(a1),d2	;y-koord
move.w	-(a1),d1	;x-koord
move.l	d1,d3
lsr.w	#4,d1
and.l	#%00000000000000000000000000001111,d3
swap	d3
move.l	d3,d4
lsr.l	#4,d4

lsl.l	#6,d3
lsl.l	#6,d3
or.l	#%00001111111100100000000000000000,d3
or.l	d4,d3

mulu	#100,d2


	move.l	otherplane,a0		;planeadresse laden
	add.l	#0*100+2,a0
add.l	d1,a0
add.l	d1,a0
add.l	d2,a0

bltwaite3:	btst	#14,dmaconr(a5)
		bne	bltwaite3

		move.l	a0,bltdpth(a5)		;ziel=scrstart+offsetdat
		move.l	a0,bltcpth(a5)
		move.l	#blockdata,a4
	add.w	(a3),a4
		move.l	a4,bltapth(a5)	;quelle=bobdata
		move.l	#bobdat,a4
	add.w	(a3)+,a4
		move.l	a4,bltbpth(a5)	;data

		move.l	d3,bltcon0(a5)	;bltcon0&bltcon1

	move.l		#%11111111111111110000000000000000,bltafwm(a5)	;bltafwm+bltalwm !!!
		move.w	#2050,bltsize(a5)	;h=250,l=21 (blitter starten);
dbf	d0,drawbobl1


rts
gurkpoint:	dc.w	0
gurke:
dc.w 365, 28,365, 28, 362, 28, 359, 28, 356, 28, 353, 28

dc.w  350, 28, 347, 28, 344, 28, 341, 28, 338, 28, 335, 28, 332, 28
dc.w  329, 28, 326, 28, 323, 28, 320, 28, 317, 28, 314, 28, 311, 28
dc.w  308, 28, 305, 28, 302, 28, 299, 28, 296, 28, 293, 28, 290, 28
dc.w  287, 28, 284, 28, 281, 28, 278, 28, 275, 28, 272, 28, 269, 28
dc.w  266, 28, 263, 28, 260, 28, 257, 28, 254, 28, 251, 28, 248, 28
dc.w  245, 28, 242, 28, 239, 28, 236, 28, 233, 28, 230, 28, 227, 28
dc.w  224, 28, 221, 28, 218, 28, 215, 28, 212, 28, 209, 28, 206, 28
dc.w  203, 28, 200, 28, 195, 28, 190, 29, 184, 29, 179, 30, 174, 31
dc.w  169, 33, 164, 35, 159, 37, 155, 39, 150, 41, 146, 44, 141, 47
dc.w  137, 50, 133, 54, 129, 57, 126, 61, 122, 65, 119, 69, 116, 74
dc.w  113, 78, 111, 83, 109, 87, 107, 92, 105, 97, 103, 102, 102, 107
dc.w  101, 112, 101, 118, 100, 123, 100, 128, 100, 133, 100, 137
dc.w  101, 142, 102, 147, 103, 151, 104, 156, 106, 160, 108, 165
dc.w  110, 169, 112, 173, 115, 177, 117, 181, 120, 185, 123, 188
dc.w  126, 192, 130, 195, 133, 198, 137, 201, 141, 203, 145, 206
dc.w  149, 208, 153, 210, 158, 212, 162, 214, 167, 215, 171, 216
dc.w  176, 217, 181, 218, 185, 218, 190, 218, 194, 218, 198, 218
dc.w  203, 217, 207, 216, 211, 215, 215, 214, 219, 213, 223, 211
dc.w  226, 209, 230, 207, 234, 205, 237, 203, 240, 200, 244, 197
dc.w  247, 195, 249, 192, 252, 188, 255, 185, 257, 182, 259, 178
dc.w  261, 174, 263, 171, 265, 167, 266, 163, 267, 159, 268, 155
dc.w  269, 151, 270, 146, 270, 142, 270, 138, 270, 134, 270, 131
dc.w  269, 127, 268, 123, 268, 120, 267, 116, 265, 113, 264, 110
dc.w  262, 106, 261, 103, 259, 100, 257, 97, 254, 94, 252, 91
dc.w  249, 89, 247, 86, 244, 84, 241, 81, 238, 79, 235, 77, 232, 76
dc.w  228, 74, 225, 73, 222, 71, 218, 70, 215, 70, 211, 69, 207, 68
dc.w  204, 68, 200, 68, 197, 68, 194, 68, 191, 69, 188, 69, 184, 70
dc.w  181, 71, 178, 72, 176, 73, 173, 75, 170, 76, 167, 78, 165, 79
dc.w  162, 81, 160, 83, 158, 86, 155, 88, 153, 90, 151, 93, 150, 95
dc.w  148, 98, 147, 101, 145, 104, 144, 106, 143, 109, 142, 112
dc.w  141, 116, 141, 119, 140, 122, 140, 125, 140, 128, 140, 131
dc.w  140, 133, 141, 136, 141, 138, 142, 141, 142, 143, 143, 146
dc.w  144, 148, 145, 151, 147, 153, 148, 155, 150, 157, 151, 159
dc.w  153, 161, 155, 163, 157, 165, 159, 167, 161, 168, 163, 170
dc.w  165, 171, 167, 173, 170, 174, 172, 175, 175, 176, 177, 176
dc.w  180, 177, 182, 177, 185, 178, 187, 178, 190, 178, 192, 178
dc.w  194, 178, 196, 178, 198, 177, 200, 177, 202, 176, 204, 175
dc.w  206, 175, 208, 174, 210, 173, 212, 172, 214, 170, 215, 169
dc.w  217, 168, 218, 166, 220, 165, 221, 163, 222, 162, 224, 160
dc.w  225, 158, 226, 156, 227, 154, 227, 152, 228, 150, 229, 148
dc.w  229, 146, 230, 144, 230, 142, 230, 140, 230, 138, 230, 136
dc.w  230, 135, 230, 133, 229, 132, 229, 130, 229, 129, 228, 127
dc.w  227, 126, 227, 124, 226, 123, 225, 122, 224, 120, 223, 119
dc.w  222, 118, 221, 117, 220, 116, 219, 115, 218, 114, 216, 113
dc.w  215, 112, 214, 111, 212, 111, 211, 110, 209, 109, 208, 109
dc.w  206, 109, 205, 108, 203, 108, 202, 108, 200, 108, 199, 108
dc.w  198, 108, 197, 108, 196, 108, 195, 109, 194, 109, 193, 109
dc.w  192, 110, 191, 110, 190, 111, 189, 111, 188, 112, 187, 112
dc.w  187, 113, 186, 114, 185, 115, 184, 115, 184, 116, 183, 117
dc.w  183, 118, 182, 119, 182, 120, 181, 121, 181, 122, 181, 123
dc.w  180, 124, 180, 125, 180, 126, 180, 127, 180, 128, 180, 129
dc.w  180, 130, 180, 131, 181, 132, 181, 133, 182, 133, 182, 134
dc.w  183, 135, 184, 136, 185, 136, 185, 137, 186, 137, 187, 138
dc.w  188, 138, 189, 138, 190, 138

gurkend:
dc.w 365, 28,365, 28, 362, 28, 359, 28, 356, 28, 353, 28

dc.w  350, 28, 347, 28, 344, 28, 341, 28, 338, 28, 335, 28, 332, 28
dc.w  329, 28, 326, 28, 323, 28, 320, 28, 317, 28, 314, 28, 311, 28
dc.w  308, 28, 305, 28, 302, 28, 299, 28, 296, 28, 293, 28, 290, 28
dc.w  287, 28, 284, 28, 281, 28, 278, 28, 275, 28, 272, 28, 269, 28
dc.w  266, 28, 263, 28, 260, 28, 257, 28, 254, 28, 251, 28, 248, 28
dc.w  245, 28, 242, 28, 239, 28, 236, 28, 233, 28, 230, 28, 227, 28
dc.w  224, 28, 221, 28, 218, 28, 215, 28, 212, 28, 209, 28, 206, 28
dc.w  203, 28, 200, 28, 195, 28, 190, 29, 184, 29, 179, 30, 174, 31
dc.w  169, 33, 164, 35, 159, 37, 155, 39, 150, 41, 146, 44, 141, 47
dc.w  137, 50, 133, 54, 129, 57, 126, 61, 122, 65, 119, 69, 116, 74
dc.w  113, 78, 111, 83, 109, 87, 107, 92, 105, 97, 103, 102, 102, 107
dc.w  101, 112, 101, 118, 100, 123, 100, 128, 100, 133, 100, 137
dc.w  101, 142, 102, 147, 103, 151, 104, 156, 106, 160, 108, 165
dc.w  110, 169, 112, 173, 115, 177, 117, 181, 120, 185, 123, 188
dc.w  126, 192, 130, 195, 133, 198, 137, 201, 141, 203, 145, 206
dc.w  149, 208, 153, 210, 158, 212, 162, 214, 167, 215, 171, 216
dc.w  176, 217, 181, 218, 185, 218, 190, 218, 194, 218, 198, 218
dc.w  203, 217, 207, 216, 211, 215, 215, 214, 219, 213, 223, 211
dc.w  226, 209, 230, 207, 234, 205, 237, 203, 240, 200, 244, 197
dc.w  247, 195, 249, 192, 252, 188, 255, 185, 257, 182, 259, 178
dc.w  261, 174, 263, 171, 265, 167, 266, 163, 267, 159, 268, 155
dc.w  269, 151, 270, 146, 270, 142, 270, 138, 270, 134, 270, 131
dc.w  269, 127, 268, 123, 268, 120, 267, 116, 265, 113, 264, 110
dc.w  262, 106, 261, 103, 259, 100, 257, 97, 254, 94, 252, 91
dc.w  249, 89, 247, 86, 244, 84, 241, 81, 238, 79, 235, 77, 232, 76
dc.w  228, 74, 225, 73, 222, 71, 218, 70, 215, 70, 211, 69, 207, 68
dc.w  204, 68, 200, 68, 197, 68, 194, 68, 191, 69, 188, 69, 184, 70
dc.w  181, 71, 178, 72, 176, 73, 173, 75, 170, 76, 167, 78, 165, 79
dc.w  162, 81, 160, 83, 158, 86, 155, 88, 153, 90, 151, 93, 150, 95
dc.w  148, 98, 147, 101, 145, 104, 144, 106, 143, 109, 142, 112
dc.w  141, 116, 141, 119, 140, 122, 140, 125, 140, 128, 140, 131
dc.w  140, 133, 141, 136, 141, 138, 142, 141, 142, 143, 143, 146
dc.w  144, 148, 145, 151, 147, 153, 148, 155, 150, 157, 151, 159
dc.w  153, 161, 155, 163, 157, 165, 159, 167, 161, 168, 163, 170
dc.w  165, 171, 167, 173, 170, 174, 172, 175, 175, 176, 177, 176
dc.w  180, 177, 182, 177, 185, 178, 187, 178, 190, 178, 192, 178
dc.w  194, 178, 196, 178, 198, 177, 200, 177, 202, 176, 204, 175
dc.w  206, 175, 208, 174, 210, 173, 212, 172, 214, 170, 215, 169
dc.w  217, 168, 218, 166, 220, 165, 221, 163, 222, 162, 224, 160
dc.w  225, 158, 226, 156, 227, 154, 227, 152, 228, 150, 229, 148
dc.w  229, 146, 230, 144, 230, 142, 230, 140, 230, 138, 230, 136
dc.w  230, 135, 230, 133, 229, 132, 229, 130, 229, 129, 228, 127
dc.w  227, 126, 227, 124, 226, 123, 225, 122, 224, 120, 223, 119
dc.w  222, 118, 221, 117, 220, 116, 219, 115, 218, 114, 216, 113
dc.w  215, 112, 214, 111, 212, 111, 211, 110, 209, 109, 208, 109
dc.w  206, 109, 205, 108, 203, 108, 202, 108, 200, 108, 199, 108
dc.w  198, 108, 197, 108, 196, 108, 195, 109, 194, 109, 193, 109
dc.w  192, 110, 191, 110, 190, 111, 189, 111, 188, 112, 187, 112
dc.w  187, 113, 186, 114, 185, 115, 184, 115, 184, 116, 183, 117
dc.w  183, 118, 182, 119, 182, 120, 181, 121, 181, 122, 181, 123
dc.w  180, 124, 180, 125, 180, 126, 180, 127, 180, 128, 180, 129
dc.w  180, 130, 180, 131, 181, 132, 181, 133, 182, 133, 182, 134
dc.w  183, 135, 184, 136, 185, 136, 185, 137, 186, 137, 187, 138
dc.w  188, 138, 189, 138, 190, 138

dc.w 365, 28,365, 28, 362, 28, 359, 28, 356, 28, 353, 28

dc.w  350, 28, 347, 28, 344, 28, 341, 28, 338, 28, 335, 28, 332, 28
dc.w  329, 28, 326, 28, 323, 28, 320, 28, 317, 28, 314, 28, 311, 28
dc.w  308, 28, 305, 28, 302, 28, 299, 28, 296, 28, 293, 28, 290, 28
dc.w  287, 28, 284, 28, 281, 28, 278, 28, 275, 28, 272, 28, 269, 28
dc.w  266, 28, 263, 28, 260, 28, 257, 28, 254, 28, 251, 28, 248, 28
dc.w  245, 28, 242, 28, 239, 28, 236, 28, 233, 28, 230, 28, 227, 28
dc.w  224, 28, 221, 28, 218, 28, 215, 28, 212, 28, 209, 28, 206, 28
dc.w  203, 28, 200, 28, 195, 28, 190, 29, 184, 29, 179, 30, 174, 31
dc.w  169, 33, 164, 35, 159, 37, 155, 39, 150, 41, 146, 44, 141, 47
dc.w  137, 50, 133, 54, 129, 57, 126, 61, 122, 65, 119, 69, 116, 74
dc.w  113, 78, 111, 83, 109, 87, 107, 92, 105, 97, 103, 102, 102, 107
dc.w  101, 112, 101, 118, 100, 123, 100, 128, 100, 133, 100, 137
dc.w  101, 142, 102, 147, 103, 151, 104, 156, 106, 160, 108, 165
dc.w  110, 169, 112, 173, 115, 177, 117, 181, 120, 185, 123, 188
dc.w  126, 192, 130, 195, 133, 198, 137, 201, 141, 203, 145, 206
dc.w  149, 208, 153, 210, 158, 212, 162, 214, 167, 215, 171, 216
dc.w  176, 217, 181, 218, 185, 218, 190, 218, 194, 218, 198, 218
dc.w  203, 217, 207, 216, 211, 215, 215, 214, 219, 213, 223, 211
dc.w  226, 209, 230, 207, 234, 205, 237, 203, 240, 200, 244, 197
dc.w  247, 195, 249, 192, 252, 188, 255, 185, 257, 182, 259, 178
dc.w  261, 174, 263, 171, 265, 167, 266, 163, 267, 159, 268, 155
dc.w  269, 151, 270, 146, 270, 142, 270, 138, 270, 134, 270, 131
dc.w  269, 127, 268, 123, 268, 120, 267, 116, 265, 113, 264, 110
dc.w  262, 106, 261, 103, 259, 100, 257, 97, 254, 94, 252, 91
dc.w  249, 89, 247, 86, 244, 84, 241, 81, 238, 79, 235, 77, 232, 76
dc.w  228, 74, 225, 73, 222, 71, 218, 70, 215, 70, 211, 69, 207, 68
dc.w  204, 68, 200, 68, 197, 68, 194, 68, 191, 69, 188, 69, 184, 70
dc.w  181, 71, 178, 72, 176, 73, 173, 75, 170, 76, 167, 78, 165, 79
dc.w  162, 81, 160, 83, 158, 86, 155, 88, 153, 90, 151, 93, 150, 95
dc.w  148, 98, 147, 101, 145, 104, 144, 106, 143, 109, 142, 112
dc.w  141, 116, 141, 119, 140, 122, 140, 125, 140, 128, 140, 131
dc.w  140, 133, 141, 136, 141, 138, 142, 141, 142, 143, 143, 146
dc.w  144, 148, 145, 151, 147, 153, 148, 155, 150, 157, 151, 159
dc.w  153, 161, 155, 163, 157, 165, 159, 167, 161, 168, 163, 170
dc.w  165, 171, 167, 173, 170, 174, 172, 175, 175, 176, 177, 176
dc.w  180, 177, 182, 177, 185, 178, 187, 178, 190, 178, 192, 178
dc.w  194, 178, 196, 178, 198, 177, 200, 177, 202, 176, 204, 175
dc.w  206, 175, 208, 174, 210, 173, 212, 172, 214, 170, 215, 169
dc.w  217, 168, 218, 166, 220, 165, 221, 163, 222, 162, 224, 160
dc.w  225, 158, 226, 156, 227, 154, 227, 152, 228, 150, 229, 148
dc.w  229, 146, 230, 144, 230, 142, 230, 140, 230, 138, 230, 136
dc.w  230, 135, 230, 133, 229, 132, 229, 130, 229, 129, 228, 127
dc.w  227, 126, 227, 124, 226, 123, 225, 122, 224, 120, 223, 119
dc.w  222, 118, 221, 117, 220, 116, 219, 115, 218, 114, 216, 113
dc.w  215, 112, 214, 111, 212, 111, 211, 110, 209, 109, 208, 109
dc.w  206, 109, 205, 108, 203, 108, 202, 108, 200, 108, 199, 108
dc.w  198, 108, 197, 108, 196, 108, 195, 109, 194, 109, 193, 109
dc.w  192, 110, 191, 110, 190, 111, 189, 111, 188, 112, 187, 112
dc.w  187, 113, 186, 114, 185, 115, 184, 115, 184, 116, 183, 117
dc.w  183, 118, 182, 119, 182, 120, 181, 121, 181, 122, 181, 123
dc.w  180, 124, 180, 125, 180, 126, 180, 127, 180, 128, 180, 129
dc.w  180, 130, 180, 131, 181, 132, 181, 133, 182, 133, 182, 134
dc.w  183, 135, 184, 136, 185, 136, 185, 137, 186, 137, 187, 138
dc.w  188, 138, 189, 138, 190, 138


text:
dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dc.b 23,5,12,3,15,13,5,0,20,15,0,20,8,5,0,5,14,4,0
dc.b 16,1,18,20,0,15,6,0,20,8,5,0,7,1,12,12,15,23,19
dc.b 0,13,5,7,1,4,5,13,15,0,28,0,0,0,0,0,0,0,0,18,5
dc.b 1,12,9,19,9,14,7,0,4,1,20,5,0,0,29,33,0,30,0,36
dc.b 28,0,0,0,0,0,0,20,8,1,14,11,19,0,20,15,0,0,14
dc.b 21,11,5,0,37,3,12,1,19,19,9,3,38,0,6,15,18,0,19
dc.b 16,18,5,1,4,9,14,7,0,20,8,5,0,13,5,7,1,4,5,13
dc.b 15,0,0,0,0,0,8,15,23,0,1,2,15,21,20,0,19,15,13
dc.b 5,0,3,18,5,4,9,20,19,0,0,0,0,0,0,0,0,0,6,9,18
dc.b 19,20,0,16,1,18,20,0,42,0,0,3,15,4,5,0,2,25,0
dc.b 18,9,16,0,0,0,0,0,7,6,24,0,2,25,0,18,9,16,0,0
dc.b 0,0,0,13,21,19,9,3,0,2,25,0,4,21,11,5,0,0,0,0
dc.b 0,0,19,5,3,15,14,4,0,16,1,18,20,0,42,0,0,3,15
dc.b 4,5,0,0,0,7,6,24,0,0,0,13,21,19,9,3,0,0,2,25,0
dc.b 18,9,16,0,0,0,0,0,0,20,8,9,18,4,0,16,1,18,20,0
dc.b 42,0,0,3,15,4,5,0,2,25,0,13,15,15,14,0,0,0,0,13
dc.b 21,19,9,3,0,2,25,0,4,21,11,5,0,0,0,0,0,0,0,6,15
dc.b 21,18,20,8,0,16,1,18,20,0,42,0,0,3,15,4,5,0,2
dc.b 25,0,18,9,16,0,0,0,0,12,15,7,15,0,2,25,0,4,21
dc.b 11,5,0,0,0,0,3,8,1,18,0,2,25,0,18,9,16,0,0,0,0
dc.b 13,21,19,9,3,0,2,25,0,4,21,11,5,0,0,0,0,0,0,6
dc.b 9,6,20,8,0,16,1,18,20,0,42,0,0,3,15,4,5,0,2,25
dc.b 0,13,15,15,14,0,0,0,0,7,6,24,0,2,25,0,4,21,11
dc.b 5,0,0,0,0,13,21,19,9,3,0,2,25,0,4,21,11,5,0,0
dc.b 0,0,0,0,19,9,24,20,8,0,16,1,18,20,0,42,0,0,3,15
dc.b 4,5,0,2,25,0,13,15,15,14,0,0,0,0,13,21,19,9,3
dc.b 0,2,25,0,4,21,11,5,0,0,0,0,3,8,1,18,0,2,25,0,18
dc.b 9,16,0,0,0,0,12,15,7,15,0,2,25,0,9,3,5,3,21,2
dc.b 5,0,0,0,0,0,0,12,1,19,20,0,16,9,3,20,21,18,5,42
dc.b 0,0,0,7,6,24,0,2,25,0,4,21,11,5,0,1,14,4,0,9,3
dc.b 5,0,3,21,2,5,0,0,0,0,0,0,0,0,0,0,3,21,18,18,5
dc.b 14,20,0,20,9,13,5,0,9,19,0,0,30,42,32,29,0,1,13
dc.b 0,0,0,0,0,0,20,8,9,19,0,20,5,24,20,0,2,25,0,4
dc.b 21,11,5,0,0,0,0,0,0,0,0,0,13,15,15,14,0,8,1,19
dc.b 0,1,0,12,9,20,20,12,5,0,16,18,15,2,12,5,13,0,0
dc.b 0,0,0,25,15,21,0,20,8,9,14,11,0,23,9,20,8,0,20
dc.b 8,5,0,20,18,15,21,19,5,18,0,1,20,0,20,8,5,0,0
dc.b 15,15,0,0,0,0,0,0,14,15,15,15,15,0,0,0,0,8,5,0
dc.b 8,1,19,0,20,15,0,7,15,0,20,15,0,15,21,18,0,7,12
dc.b 15,18,25,0,1,18,13,25,0,0,0,0,0,0,25,15,21,0,11
dc.b 14,15,23,0,0,20,8,5,0,7,18,5,5,14,0,2,18,15,23
dc.b 14,0,3,15,12,15,21,18,5,4,0,13,5,14,0,23,8,9,3
dc.b 8,0,12,9,5,19,0,1,12,23,1,25,19,0,9,14,0,20,8
dc.b 5,0,13,21,4,0,0,0,0,19,15,18,18,25,0,13,15,15
dc.b 14,0,0,2,21,20,0,23,5,0,23,9,12,12,0,19,5,5,0
dc.b 25,15,21,0,14,15,20,0,2,5,6,15,18,5,0,4,5,3,5
dc.b 13,2,5,18,0,0,0,0,0,0,0,0,0,0,0,0,20,15,16,9,3
dc.b 0,3,8,1,14,7,9,14,7,0,42,0,0,0,15,21,18,0,3,15
dc.b 14,20,1,3,20,0,1,4,18,5,19,19,0,9,19,0,16,15,0
dc.b 2,15,24,0,33,36,0,32,31,27,27,0,8,1,12,12,5,9
dc.b 14,0,1,21,19,20,18,9,1,0,0,0,0,0,0,1,14,4,0,19
dc.b 15,0,9,0,7,9,22,5,0,20,8,5,0,11,5,25,2,15,1,18
dc.b 4,0,20,15,0,9,3,5,3,21,2,5,0,1,14,4,0,18,9,16
dc.b 0,0,0,0,0,0,1,20,0,6,9,18,19,20,0,20,8,9,19,0
dc.b 9,19,0,9,3,5,0,3,21,2,5,0,7,18,1,2,2,9,14,7,0
dc.b 20,8,5,0,11,5,25,2,15,1,18,4,0,15,6,0,18,9,16
dc.b 19,0,29,27,27,27,5,18,0,0,0,9,0,1,13,0,19,9,20
dc.b 20,9,14,7,0,15,14,0,18,9,16,19,0,19,17,21,5,1
dc.b 11,3,8,1,9,18,0,6,5,5,12,9,14,7,0,20,8,5,0,18
dc.b 5,1,12,0,16,5,18,16,12,5,24,9,15,14,0,15,6,0,8
dc.b 1,18,13,15,14,9,5,0,0,2,21,20,0,14,15,23,0,20
dc.b 8,5,18,5,0,3,15,13,5,19,0,20,8,5,0,20,5,24,20
dc.b 0,0,0,0,20,8,9,19,0,9,19,0,18,9,16,0,20,25,16
dc.b 9,14,7,0,20,8,5,0,6,1,3,20,0,0,0,23,5,0,1,18,5
dc.b 0,19,9,20,20,9,14,7,0,9,14,0,13,25,0,18,15,15
dc.b 13,0,8,5,18,5,0,9,14,0,15,2,5,18,1,12,13,0,1,21
dc.b 19,20,18,9,1,0,1,14,4,0,23,5,0,4,15,14,20,0,11
dc.b 14,15,23,0,23,8,1,20,0,20,15,0,23,18,9,20,5,0
dc.b 0,0,2,21,20,0,1,12,23,1,25,19,0,18,5,13,5,13,2
dc.b 5,18,42,0,0,4,15,14,20,0,13,1,11,5,0,2,21,9,19
dc.b 19,14,5,19,0,9,14,0,20,8,5,0,19,3,5,14,5,0,0,13
dc.b 1,11,5,0,13,15,18,5,0,6,18,9,5,14,4,19,8,9,16
dc.b 0,0,0,20,8,5,0,14,5,23,5,19,20,0,18,5,12,5,1,19
dc.b 5,19,0,19,8,15,21,12,4,0,2,5,0,4,5,13,15,19,0
dc.b 0,13,5,7,1,4,5,13,15,19,0,1,14,4,0,13,1,18,22
dc.b 5,12,12,15,21,19,0,1,14,4,0,21,19,5,6,21,12,12
dc.b 0,20,15,15,12,19,0,0,0,0

dc.b	255
even

wurzelsepp:	dc.w	0
backflag:	dc.w	0

return:
move.w	#1,backflag
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
mt_data:	blk.b	62000,0

b:
