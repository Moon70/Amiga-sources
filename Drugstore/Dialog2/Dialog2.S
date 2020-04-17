;------------------------------------------------------------------------
;|                                                                      |
;|                                 Dialog 2                             |
;|                                ----------                            |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                                         12-May-94 |
;------------------------------------------------------------------------
showtime=0
a:
;changes from 5.2 to 5.3:
; double; at: Commands:, main_init:, Main_program: and Main_intuser:
; all possible jsr to bsr, lea to lea(pc),--> relocs from 168 to 96
; offset JSR changed to JMP
; commander not longer uses main_talk to exit program, now f_endprogram
; does this job
; main_init/program/end now are saving all registers, easier to jump in

forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
planesize=64*256
intena=$09a
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
bpl6pth=$0f4
bpl6ptl=$0f6
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
;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
section	main,code_c
codec_s:
;--------------------------------
	jmp	start		;
	jmp	main_init	;
	jmp	main_program	;
	jmp	main_back	;
	rts			;
;--------------------------------
;--------------------------------------------------------
start:							;
	move.l	4.w,a6					;
	jsr	forbid(a6)				;
	lea	$dff000,a5				;
	move.w	#%0000001111100000,dmacon(a5)		;
	move.w	#%0000000001100000,intena(a5)		;
	move.l	$6c.w,oldint				;
	move.l	#main_vbi,$6c.w				;
	move.l	#main_emptycopperlist,cop1lch(a5)	;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1100000000100000,intena(a5)		;
	move.w	#%1000001111000000,dmacon(a5)		;
	lea	fakemain_vbiuser(pc),a0			;
	lea	fakemain_copperlist(pc),a1		;
	lea	fakemain_talk(pc),a2			;
move.w	#%0000001000000000,bplcon0(a5)

	bsr.w	main_init				;
	bsr.w	main_program				;

;right1:
;	btst	#10,$dff016
;	bne.b	right1
;	move.l	main_talk,a0
;	move.w	#1,(a0)
wait:							;
	btst.b	#6,ciaapra				;
	beq.b	back					;
	tst.w	f_endprogram				;
	beq.b	wait					;
back:							;
	move.l	oldint,$6c.w				;
	move.l	4.w,a6					;
	lea	gfxname(pc),a1				;
	moveq	#0,d0					;
	jsr	openlibrary(a6)				;
	move.l	d0,a0					;
	lea	$dff000,a5				;
	move.l	38(a0),cop1lch(a5)			;
	move.w	#0,copjmp1(a5)				;
	move.w	#%1000001111100000,dmacon(a5)		;
	move.l	4.w,a6					;
	jsr	permit(a6)				;
	moveq	#0,d0					;
	rts						;
;--------------------------------------------------------
;--------------------------------------------------------
main_vbiuser:		dc.l	0			;
fakemain_vbiuser:	dc.l	0			;
main_copperlist:	dc.l	0			;
fakemain_copperlist:	dc.l	main_emptycopperlist	;
main_talk:		dc.l	0			;
fakemain_talk:		dc.l	0			;
oldint:			dc.l	0			;
main_emptycopperlist:	dc.l	-2			;
intflag:		dc.w	0			;
f_endprogram:		dc.w	0			;
gfxname:		dc.b	"graphics.library",0,0	;
;--------------------------------------------------------
;----------------------------------------------------------------
main_vbi:							;
	btst.b	#5,$dff01f					;
	beq.b	main_vbiback					;
	movem.l	d0-a6,-(a7)					;
;--------------------------					;
	lea	$dff000,a5					;

	lea	main_vbiuser(pc),a0 ;adress of UserVbiAdress	;
	move.l	(a0),a0		;adress of UserVbi		;
	tst.l	(a0)						;
	beq.b	nomain_uservbi					;
	move.l	(a0),a0						;
	jsr	(a0)						;
nomain_uservbi:							;

	lea	main_copperlist(pc),a0				;
	move.l	(a0),a0						;
	tst.l	(a0)						;
	beq.b	nomain_copperlist				;
	bpl.b	noempty_copperlist
	lea	main_emptycopperlist(pc),a1
	move.l	a1,cop1lch(a5)					;
	clr.l	(a0)						;
	bra.b	nomain_copperlist				;
noempty_copperlist:
	move.l	(a0),a1						;
	clr.l	(a0)						;
	move.l	a1,cop1lch(a5)					;
;	move.w	#0,copjmp1(a5); should be removed!!		;
nomain_copperlist:						;

ifne	showtime						;
	move.w	#$0f00,$dff180					;
endif								;
	movem.l	(a7)+,d0-a6					;
ifne	showtime						;
	move.w	#$0000,$dff180					;
endif								;
main_vbiback:							;
	move.w	#%0000000001100000,$dff09c			;
	rte							;
;----------------------------------------------------------------

;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
commander:; v4.1 last optimizing: 93-10-30
	lea	comsleep(pc),a0		;  8
	subq.w	#1,(a0)+		; 12
	beq.b	commanderl1		; 10 (true), 8 (false)
	rts				; 16
commanderl1:
	move.w	(a0),d0			;  8
	addq.w	#8,(a0)			; 12
	lea	commands+2(pc,d0.w),a1	; 12
	move.w	(a1)+,-(a0)		; 12
	move.l	(a1),a0			; 12
	jmp	(a0)			;  8
comsleep:	dc.w	1	;|
compoint:	dc.w	0	;|
commands:;;
		dc.l	40,	nothing
		dc.l	500,	set_dotstart
		dc.l	70,	set_clr
		dc.l	36,	set_picout
		dc.l	65000,	setente
;---------------------------------------------
nothing:	rts

setente:
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#2,(a0)
	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#-1,(a1)
	move.w	#1,f_endprogram
	move.w	#%0000001000000000,bplcon0(a5)
	rts

set_dotstart:
	move.w	#0,box_fin
	rts

CopScreen_freak:
	dc.w	diwstrt,$2981
	dc.w	diwstop,$29c1
	dc.w	ddfstrt,$0038
	dc.w	ddfstop,$00d0

	dc.w	bplcon0,%0101001000000000
	dc.w	bplcon1,0
	dc.w	bplcon2,0
	dc.w	bpl1mod,24
	dc.w	bpl2mod,24
	dc.l	-2

set_clr:
	move.w	#0,clrskip
	move.w	#1,dotskip
	rts

set_picout:
	move.w	#-2,planemovedir
	subq.w	#2,movsinpos
	rts
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbiuser
	move.l	a1,main_copperlist
	move.l	a2,main_talk

	bsr.w	switchplanes
	lea	freak(pc),a0
	lea	plane1copy1,a1
	lea	plane1copy2,a2
	lea	planeclscopy,a3
	move.w	#(planesize/4)-1,d7
planecopy:
	move.l	(a0),(a1)+
	move.l	(a0),(a2)+
	move.l	(a0)+,(a3)+
	dbf	d7,planecopy

	lea	dot_table,a0
	move.w	#3*250*2/4-1,d7
	moveq	#0,d0
clrdottableloop:
	move.l	d0,(a0)+
	dbf	d7,clrdottableloop

	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	rts
;----------

Main_program:;;
	lea	main_vbiuser,a0
	move.l	(a0),a0
	move.l	#main_intuser,(a0)
	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#CopScreen_freak,(a1)

	lea	freakcol(pc),a0
	lea	$180(a5),a1
	moveq	#15,d0
freakcolput:
	move.l	(a0)+,(a1)+
	dbf	d0,freakcolput
	rts

main_intuser:;;
	lea	$dff000,a5

	moveq	#0,d1

	lea	movsinpos(pc),a0
	lea	movsin(pc),a1
	move.w	(a0),d0
	move.w	(a1,d0.w),d0
	bmi.b	planemovefinished
	move.w	d0,d1
;	move.w	#128,d1	;
;	sub.w	d0,d1	;
;	move.w	d1,d0	;

	move.w	planemovedir(pc),d2
	add.w	d2,(a0)
planemovefinished:

	move.w	d1,d0
	lsr.w	#4,d1
	add.w	d1,d1
;	not.w	d0
	and.w	#%0000000000001111,d0
	move.w	d0,d2
	lsl.w	#4,d0
	or.w	d2,d0
	move.w	d0,bplcon1(a5)

	move.l	dot_showplane,d0
	sub.l	d1,d0
	move.l	d0,bpl1pth(a5)
	lea	freak(pc),a0
	sub.w	d1,a0
	lea	planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl5pth(a5)

	bsr.w	planecls
	move.w	#8,dot_framecount
	move.w	#60,maxdotscan
	bsr.w	dot_move
	bsr.b	cleartext
	bsr.w	switchplanes

	move.l	main_talk,a0
	cmp.w	#1,(a0)
	bne.b	noexternsignal
	move.w	#0,(a0)
	move.w	#1,comsleep
noexternsignal:
waitblit
	move.w	#1,intflag
	jsr	commander
	rts
;----------



planemovedir:	dc.w	2

box_x1:	dc.w	309-150-1
box_x2:	dc.w	180-150-1
;box_x1:	dc.w	180-150
;box_x2:	dc.w	309-150

box_y1:	dc.w	18
box_y2:	dc.w	113
box_xpos:	dc.w	309-150-1
;box_xpos:	dc.w	180-1-150-1
box_ypos:	dc.w	18

clr_xpos:	dc.w	180-150-1
;clr_xpos:	dc.w	309-150
clr_ypos:	dc.w	18

;box_x1:	dc.w	90
;box_x2:	dc.w	220
;box_y1:	dc.w	160
;box_y2:	dc.w	200


box_fin:	dc.w	-1
dot_framecount:	dc.w	0
maxdotscan:	dc.w	0

cleartext:
	tst.w	clrskip
	bne.b	skipclear

;	btst	#10,$dff016
;	bne	skipclear
	move.w	clr_xpos,d6
	cmp.w	box_x1,d6
	bge.b	skipclear
	addq.w	#1,d6
	addq.w	#2,clr_xpos

	lea	planeclscopy,a0
	move.w	box_y2,d7
	sub.w	box_y1,d7
	subq.w	#1,d7
clearloop:
	move.w	d6,d0
	move.w	clr_ypos,d1
	add.w	d7,d1
	move.w	d0,d2
	lsl.w	#6,d1
	lsr.w	#3,d0
	add.w	d0,d1
	not.w	d2
	bclr	d2,(a0,d1.w)	;planeclscopy

	move.w	d6,d0
	addq.w	#1,d0
	move.w	clr_ypos,d1
	add.w	d7,d1

	move.w	d0,d2
	lsl.w	#6,d1
	lsr.w	#3,d0
	add.w	d0,d1
	not.w	d2
	bclr	d2,(a0,d1.w)	;planeclscopy


	dbf	d7,clearloop

skipclear:
rts

box:
	lea	text(pc),a0
	tst.w	box_fin
	beq.b	box_notfin
	moveq	#-1,d0
	rts
box_notfin:
	move.w	box_xpos(pc),d0		;last scanned x
	move.w	box_ypos(pc),d1		;last scanned y
	subq.w	#1,d0			;last x +1 = new x
	cmp.w	box_x2(pc),d0		;right x-border?
	bne.b	noboxxflow		;no, then lets scan..
	move.w	box_x1(pc),d0		;new x = left border

	addq.w	#1,d1			;y+1 (next line)
	cmp.w	box_y2(pc),d1		;y border ?
	bne.b	noboxyflow		;no, then scan
	move.w	#1,box_fin		;yes, box finished
	moveq	#-1,d0			;invalid x-coord
	rts				;back to drawroutine
noboxyflow:
	move.w	d1,box_ypos		;store actual y-coord
noboxxflow:
	move.w	d0,box_xpos		;store actual x-coord

;-------
	move.w	d0,d3	
	move.w	d1,d4	
	move.w	d3,d2
	lsl.w	#6,d4
	lsr.w	#3,d3
	add.w	d3,d4
	not.w	d2
	btst	d2,(a0,d4.w)		;text page
	beq.b	box_notfin2		;no dot there
;-------

box_skip:
	rts

box_notfin2:
	subq.w	#1,maxdotscan
	bne.b	box_notfin
	move.w	#1,maxdotscan

	moveq	#-1,d0
	rts



dotskip:	dc.w	0
clrskip:	dc.w	1

dot_move:
	tst.w	dotskip
	bne.w	dot_skip
	lea	dot_table,a1
	lea	sinus(pc),a2
	lea	planeclscopy,a3
	move.l	dot_workplane(pc),a4
	move.w	#210,d7
dot_moveloop:
	move.w	(a1),d6		;angel
	bne.b	dot_nonew

	move.w	2(a1),d0
	beq.b	dot_skipdraw
	move.w	4(a1),d1
	move.w	d0,d2
	lsl.w	#6,d1
	lsr.w	#3,d0
	add.w	d0,d1
	not.w	d2
	bset	d2,(a3,d1.w)	;planeclscopy


dot_skipdraw:
	subq.w	#1,dot_framecount
	bmi.b	dot_dotskip	;no more dots added in this frame

	bsr.w	box		;scan the endpos of the next dot
	tst.w	d0
	bmi.b	dot_dotskip	;no dot found
	move.w	#90,d6		;angle of new dot
	move.w	d6,(a1)		;store new angle
	move.w	d0,2(a1)	;store new x (parameter from box)
	move.w	d1,4(a1)	;store new y (parameter from box)
dot_nonew:
	subq.w	#3,(a1)		;decrementing angle
	move.w	2(a1),d0	;x
	move.w	4(a1),d1	;y
	lsl.w	#2,d6		;angle to offset
	move.l	(a2,d6.w),d6
	move.w	d6,d5		;=sin w
	swap	d6		;=cos w

	move.w	#-90-150+20,d4
	add.w	d0,d4		;x-90
	muls	d4,d5		;sin(w) * (x-90) 


	move.w	#165+15,d4		;ry
	sub.w	d1,d4		;ry=140-y
	muls	d4,d6		;cos(w) * (165-y)

	add.l	d5,d5
	swap	d5		;new x
	add.l	d6,d6
	swap	d6		;new y

	move.w	#90+150-20,d0
	add.w	d5,d0		;x=x+90
	add.w	d6,d1		;y=old y + new y

;-------
	move.w	d0,d2
	lsl.w	#6,d1
	lsr.w	#3,d0
	add.w	d0,d1
	not.w	d2
	bset	d2,(a4,d1.w)	;workplane
;-------

dot_dotskip:
	addq.l	#6,a1
	dbf	d7,dot_moveloop
dot_skip:
rts

planecls:
	move.l	dot_clsplane(pc),a0
	lea	planeclscopy,a1
waitblit
	move.l	a0,bltdpth(a5)
	move.l	a1,bltapth(a5)
	move.w	#24,bltdmod(a5)
	move.w	#24,bltamod(a5)
	move.l	#-1,bltafwm(a5)
	move.w	#0,bltcon1(a5)
	move.w	#%0000100111110000,bltcon0(a5)
	move.w	#64*256+20,bltsize(a5)
rts

switchplanes:
	lea	dot_showplane(pc),a0
	move.l	(a0),d0
	move.l	4(a0),(a0)+
	move.l	4(a0),(a0)+
	move.l	d0,(a0)
rts


dot_showplane:	dc.l	freak
dot_workplane:	dc.l	plane1copy1
dot_clsplane:	dc.l	plane1copy2

freakcol:
	dc.w $202,$CCC,$DA8,$C97,$C86,$B75,$A64,$953
	dc.w $842,$731,$631,$520,$410,$310,$200,$100
	dc.w $054,$111,$333,$555,$999,$EB9,$FFF,$0A9
	dc.w $076,$032,$700,$0AE,$079,$056,$024,$013

movsinpos:	dc.w	0
	dc.w	-1
	dc.w	128,128,128,128,128,128
movsin:;Created with Liberty Design's Sinusmaker
	dc.W  128, 121, 115, 108, 101, 95, 88, 82, 76, 70, 64, 58
	dc.W  53, 47, 42, 37, 33, 29, 24, 21, 17, 14, 11, 9, 6, 4
	dc.W  3, 2, 1, 0
	dc.w	-1
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

b:

;text:	incbin	"data/freakII2text.con"
text:	incbin	"data/text22.con"
freak:	incbin	"data/freak_2.con"

codec_e:


section	memoryc,bss_c
bssc_s:
dot_table:	ds.w	3*250	;angel,destx,desty,fillword

planeclscopy:	ds.b	planesize
plane1copy1:	ds.b	planesize
plane1copy2:	ds.b	planesize


bssc_e:



printt	"Section Code Chip:"
printv	codec_e-codec_s
printt	"Section BSS Chip:"
printv	bssc_e-bssc_s

printt	"Chipmem needed:"
printv	codec_e-codec_s+bssc_e-bssc_s


