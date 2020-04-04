onlychip=0
UseSection=1
zoom=0
turn=0
shade2=0
Movetunnel=1
deltasingleadd_mode=1
deltabigadd_mode=0



Planesize=256*40



ifne	UseSection
section	CodeC,code_c
endif
codec_s:
;------
Main_Showtime=0
Main_ProgramID=2
Main_Cache=1
Main_SkipWBStartTest=1
Main_Joyhold=0
include	"Include/maininit/Maininit6.2.s"
;------



bpl7pth=bpl6pth+4
bpl8pth=bpl7pth+4
bplcon3=$106
bplcon4=$10c

FMODE=$1fc

;------------------------------------------------------------------------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand

	move.l	#0,colours1
	move.l	#0,colours2

	move.l	#coord_d,turnkoord
	move.l	#coord_s,turnkoords
	move.w	#3,turnquant
ifne	turn
	move.w	#4*6,turnaddz
endif



;------------------------------------------------------------------------
	lea	Colours1,a0
	jsr	ColConvert

	lea	col_black,a0		;colour source
	lea	col_tunnel1,a1		;colour dest
	jsr	Fader2_Tunnel

	lea	picture1,a0
	lea	colours1,a2
	lea	Junky1,a3
	jsr	MakeJunkyColTable2

rept	15
	jsr	focus_switch
endr

	lea	JunkyAnim1,a3
	move.w	focustab,focus

	lea	JunkyAnim1,a3
	move.l	#junky1,Junky_pic
rept	15
	move.l	a3,-(a7)
	jsr	turner
	jsr	perspective
	jsr	focus_switch
	move.l	(a7)+,a3
	jsr	Junky_Set
endr


;------------------------------------------------------------------------
	lea	Colours2,a0
	jsr	ColConvert

	lea	Fader2_Table_Tunnel,a0
	move.w	#(Fader2_Tableend_Tunnel-Fader2_Table_Tunnel)/4-1,d7
	moveq	#0,d0
fadetableclr_loop:
	move.l	d0,(a0)+
	dbf	d7,fadetableclr_loop

	lea	col_black,a0		;colour source
	lea	col_tunnel2,a1		;colour dest
	jsr	Fader2_Tunnel

	lea	picture2,a0
	lea	colours2,a2
	lea	Junky1,a3
	jsr	MakeJunkyColTable2
;---


rept	15
	jsr	focus_switch
endr

	lea	JunkyAnim2,a3
	move.w	focustab,focus

	move.l	#junky1,Junky_pic
	move.l	#Junky_ColList+4*2,Junky_ColListPos
rept	15
	move.l	a3,-(a7)
	jsr	turner
	jsr	perspective
	jsr	focus_switch
	move.l	(a7)+,a3
	jsr	Junky_Set
endr


	lea	Copperlist1,a0
	jsr	coppercopy
	lea	Copperlist2,a0
	jsr	coppercopy


	lea	Screen,a0
	move.w	#40*256*7/4-1,d7
	moveq	#0,d0
Screenclr:
	move.l	d0,(a0)+
	dbf	d7,screenclr

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
	move.w	#$2981,diwstrt(a5)
	move.w	#$29c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00b6,ddfstop(a5)
;	move.w	#%0000001000010000,bplcon0(a5)
	move.w	#%0111001000000000,bplcon0(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#00,bpl1mod(a5)
	move.w	#00,bpl2mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)

	move.l	Main_MasterCommand(pc),a0
	move.l	#MainLoop,4(a0)		;second priority mastercommand

	lea	colours1,a0
	moveq	#7,d6
colcopyloop2:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,bplcon3(a5)
	move.w	d2,d3
	bset.l	#9,d3


	lea	$180(a5),a1
	moveq	#31,d7
colcopyloop1:
;	move.l	(a0)+,d0
	move.l	#0,d0
	move.l	d0,d1

	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	swap	d1
	lsr.w	#4,d1

	lsr.l	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	lsr.w	#4,d0
	ror.l	#4,d0
	swap	d0
	lsr.w	#4,d0

	move.w	d1,(a1)
	move.w	d2,bplcon3(a5)
	move.w	d0,(a1)+
	move.w	d3,bplcon3(a5)

	dbf	d7,colcopyloop1
	dbf	d6,colcopyloop2

	move.l	Main_Copperlist(pc),a0
	move.l	#copperlist1,(a0)

rts



mainloop:;;
	move.l	Main_Talk(pc),a0
	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	move.w	#$d,d0
	cmp.l	(a0),d0
	bne	noendcommand
	sub.w	d0,d0
	move.l	d0,(a0)
	move.w	#1,Commander_sleep



noendcommand:
	tst.w	f_vbi
	beq	mainloop

;	btst	#10,$dff016
;	beq	skipcall_tunnel
	tst.w	sleep_tunnel
;	bne	skipcall_tunnel
	move.w	#3,sleep_tunnel

	jsr	Junkytunnel

lea	copperlist_work,a0
move.l	(a0),d0
move.l	4(a0),d1
move.l	d1,(a0)+
move.l	d0,(a0)

move.l	Main_Copperlist(pc),a0
move.l	d0,(a0)

move.w	#0,f_VBI

skipcall_tunnel:
	rts
;----------

Commands:;;
	dc.l	640,	set_fadein
	dc.l	160,	set_tuntex1
	dc.l	60000,	set_tuntex2

	dc.l	180,	set_fadeout

	dc.l	60000,	exit



set_fadein:
	move.w	#1,f_fadetunnelin
	move.w	#0,f_fadetunnelout
	move.w	#0,fadetunnel_pos
	rts

set_fadeout:
	move.w	#1,f_fadetunnelout
	move.w	#0,f_fadetunnelin
	move.w	#640-4,fadetunnel_pos
	rts

set_tuntex1:
	lea	junkyanimnext,a0
	lea	junkyanim1,a1
	move.l	a1,(a0)+
	move.l	a1,(a0)+
	rts

set_tuntex2:
	lea	junkyanimnext,a0
	lea	junkyanim2,a1
	move.l	a1,(a0)+
	move.l	a1,(a0)+
	rts





nothing:	rts

exit:
	moveq	#0,d0
	move.b	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	move.l	d0,(a0)
	rts



codec_e:

ifne	UseSection
ifeq	Onlychip
	section	CodeP,code_p
else
	section	CodeP,code_c	;onlychip
endif
endif

codep_s:

VBI:
	lea	Screen,a0
	move.l	a0,bpl1pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	Planesize(a0),a0
	move.l	a0,bpl7pth(a5)
;	lea	Planesize(a0),a0
;	move.l	a0,bpl8pth(a5)

	subq.w	#1,sleep_tunnel
	bpl	no_tunneltimeoverflow
;	move.w	#0,bplcon3(a5)
;	move.w	#$00f0,$180(a5)
	move.w	#0,sleep_tunnel
no_tunneltimeoverflow:

	bsr	junkyfadein
	bsr	junkyfadeout
	jsr	commander
	move.w	#1,f_VBI
rts


sleep_tunnel:	dc.w	1
f_fadetunnelin:		dc.w	0
f_fadetunnelout:	dc.w	0
f_VBI:	dc.w	0


junkyfadeout:
	tst.w	f_fadetunnelout
	beq	junkyfadeout_skip
lea	fadetunnel_pos,a0
move.w	(a0),d0
bmi	junkyfadeout_skip
subq.w	#4,(a0)+
add.w	d0,a0
moveq	#0,d0
move.w	(a0)+,d0
moveq	#0,d1
move.w	(a0),d1

	lea	screen,a0
	move.l	a0,a2
	add.l	d0,a0
	add.l	d1,a2


	moveq	#15,d7
junkyfadeout_fieldloop:
	lea	3*Planesize(a0),a1
	lea	3*Planesize(a2),a3
	moveq	#0,d0

	move.w	d0,(a0)
	move.w	d0,1*Planesize(a0)
	move.w	d0,2*Planesize(a0)
	move.w	d0,3*Planesize(a0)
	move.w	d0,1*Planesize(a1)
	move.w	d0,2*Planesize(a1)
	move.w	d0,3*Planesize(a1)


	move.w	d0,(a2)
	move.w	d0,1*Planesize(a2)
	move.w	d0,2*Planesize(a2)
	move.w	d0,3*Planesize(a2)
	move.w	d0,1*Planesize(a3)
	move.w	d0,2*Planesize(a3)
	move.w	d0,3*Planesize(a3)


	lea	40(a0),a0
	lea	40(a2),a2
	dbf	d7,junkyfadeout_fieldloop


junkyfadeout_skip:
	rts



junkyfadein:
	tst.w	f_fadetunnelin
	beq	junkyfadein_skip
	lea	fadetunnel_pos,a4
	move.w	(a4),d0
	cmp.w	#640,d0
	beq	junkyfadein_skip
	addq.w	#4,(a4)+
	add.w	d0,a4
	moveq	#0,d0
	move.w	(a4)+,d0

	lea	screen,a0
	add.l	d0,a0

	lea	junkygrid,a2
	add.l	d0,a2

	moveq	#15,d7
junkyfadein_fieldloop1:
	lea	3*Planesize(a0),a1
	lea	3*Planesize(a2),a3

	move.w	(a2),(a0)
	move.w	1*Planesize(a2),1*Planesize(a0)
	move.w	2*Planesize(a2),2*Planesize(a0)
	move.w	3*Planesize(a2),3*Planesize(a0)
	move.w	1*Planesize(a3),1*Planesize(a1)
	move.w	2*Planesize(a3),2*Planesize(a1)
	move.w	3*Planesize(a3),3*Planesize(a1)

	lea	40(a0),a0
	lea	40(a2),a2
	dbf	d7,junkyfadein_fieldloop1



	move.w	(a4)+,d0

	lea	screen,a0
	add.l	d0,a0

	lea	junkygrid,a2
	add.l	d0,a2


	moveq	#15,d7
junkyfadein_fieldloop2:
	lea	3*Planesize(a0),a1
	lea	3*Planesize(a2),a3

	move.w	(a2),(a0)
	move.w	1*Planesize(a2),1*Planesize(a0)
	move.w	2*Planesize(a2),2*Planesize(a0)
	move.w	3*Planesize(a2),3*Planesize(a0)
	move.w	1*Planesize(a3),1*Planesize(a1)
	move.w	2*Planesize(a3),2*Planesize(a1)
	move.w	3*Planesize(a3),3*Planesize(a1)

	lea	40(a0),a0
	lea	40(a2),a2
	dbf	d7,junkyfadein_fieldloop2






junkyfadein_skip:
	rts




Coppercopy:
;--> a0  ;address of copperlist
	move.l	a0,d3		;copadr to calc offsets
	move.w	#$2701,d0

	lea	Coplist_Offset,a2
	move.w	#bplcon0,(a0)+
	move.w	#%0111001000000000,(a0)+

	moveq	#jy-1,d5
Coppercopy_Blockloop:
	moveq	#3,d1		;bank number 3 (calc col 0-127)

	move.w	palswap(pc),d2	;bank offset (0 or 128)
	bchg	#15,d2		;offset 0<-->128
	beq	Coppercopy_Lowline
	moveq	#7,d1		;now lowshow=now highcalc, (col 128-255) 

Coppercopy_Lowline:
	move.w	d2,palswap
	move.w	#bplcon4,(a0)+
	move.w	d2,(a0)+	;set pal offset

	ror.w	#3,d1
	move.w	d0,(a0)+	;set rasterline
	move.w	#-2,(a0)+

	moveq	#2,d7
Coppercopy_Lineloop:
	move.w	#$1c0,d2	;highest colreg
	move.w	#bplcon3,(a0)+
	move.w	d1,(a0)+	;set colbank  number

	moveq	#31,d6
Coppercopy_Regloop:
	subq.w	#2,d2		;colreg adr decrement
	move.w	d2,(a0)+	;colreg adr

	move.l	a0,d4		;copperlist position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset

	move.w	#$0,(a0)+
	dbf	d6,Coppercopy_regloop

	rol.w	#3,d1
	subq.w	#1,d1
	ror.w	#3,d1
	dbf	d7,Coppercopy_lineloop

	move.w	#$1c0,d2
	move.w	#bplcon3,(a0)+
	move.w	d1,(a0)+
	moveq	#9,d6		;4 bonus moves (5 possible)
Coppercopy_Regloop2:
	subq.w	#2,d2		;colreg adr decrement
	move.w	d2,(a0)+	;colreg adr

	move.l	a0,d4		;copperlist position...
	sub.l	d3,d4		;...-copperstart...
	move.w	d4,(a2)+	;...=offset

	move.w	#$0,(a0)+
	dbf	d6,Coppercopy_regloop2

	add.w	#$0300,d0	;rasterpos

	dbf	d5,Coppercopy_blockloop

	move.w	palswap(pc),d2
	bchg.l	#15,d2
	move.w	#bplcon4,(a0)+
	move.w	d2,(a0)+


	add.w	#$0200,d0	;rasterpos
	move.w	d0,(a0)+	;set rasterline
	move.w	#-2,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#%0000001000000000,(a0)+
	move.l	#-2,(a0)
rts
palswap:	dc.w	0


jx=106;93		;junky resolution x
jy=85;128		;junky resolution y
jo=40;must be even number!			;junky pixel-offset

mdx:	dc.l	0
mdy:	dc.l	0

ldx:	dc.l	0
ldy:	dc.l	0

mdpx:	dc.l	0
mdpy:	dc.l	0



Focustab:
value1:	set	3900
value2:	set	150
rept	30
	dc.w	value1/10
value1:	set	value1-value2
value2:	set	value2-2
endr

;Focustab:
;value1:	set	50
;value2:	set	10
;rept	20
;	dc.w	value1
;value1:	set	value1+value2
;value2:	set	value2+1
;endr





focus_switch:
	lea	focustab(pc),a0
	move.w	(a0),d0
	move.w	d0,focus
rept	29
	move.w	2(a0),(a0)+
endr
	move.w	d0,(a0)
	rts


Junky_ColListPos:	dc.l	Junky_ColList+4*2
Junky_ColList:

rept	2

value:	set	0
rept	16
rept	1
dc.l	Fader2_table_tunnel+value
endr
value:	set	value+256*2
endr

endr

Junky_pic:	dc.l	0

Junky_Set:
	lea	Coord_d(pc),a0
	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+2(a0),d0	;cx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;cx-ax
	swap	d0
	divs.l	#jx+jo,d0
	move.l	d0,mdx
	swap	d1
	move.l	d1,mdpx

	moveq	#0,d0
	moveq	#0,d1
	move.w	2*8+4(a0),d0	;cy
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;cy-ay
	swap	d0
	divs.l	#jy+jo,d0
	move.l	d0,mdy
	swap	d1
	move.l	d1,mdpy



	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+2(a0),d0	;bx
	move.w	0*8+2(a0),d1	;ax
	sub.w	d1,d0		;bx-ax
	swap	d0
	divs.l	#jx+jo,d0
	move.l	d0,ldx

	moveq	#0,d0
	moveq	#0,d1
	move.w	1*8+4(a0),d0	;by
	move.w	0*8+4(a0),d1	;ay
	sub.w	d1,d0		;by-ay
	swap	d0
	divs.l	#jy+jo,d0
	move.l	d0,ldy


	lea	Junky_ColListPos(pc),a0
	move.l	(a0),a6
	addq.l	#4,(a0)
	move.l	(a6),a6
	
	move.l	Junky_pic,a2
	lea	Multab640(pc),a5
	move.l	ldx(pc),d0
	move.l	ldy(pc),d1

	move.w	#jy+jo-1,d7
Junky_Sety:
	move.l	mdpx(pc),d4
	move.l	mdpy(pc),d5

	move.w	#jx+jo-1,d6
Junky_Setx:
	move.l	d4,d2
	move.l	d5,d3

	sub.w	d2,d2
	swap	d2
	sub.w	d3,d3
	swap	d3


;---overflow-test---
tst.w	d2
bpl	Junky_xpos
moveq	#0,d2
moveq	#0,d3
bra	Junky_ok

Junky_xpos:
cmp.w	#319,d2
bls	Junky_xok
moveq	#0,d2
moveq	#0,d3
bra	Junky_ok

Junky_xok:
tst.w	d3
bpl	Junky_ypos
moveq	#0,d2
moveq	#0,d3
bra	Junky_ok

Junky_ypos:
cmp.w	#255,d3
bls	Junky_yok
moveq	#0,d2
moveq	#0,d3

Junky_yok:
Junky_ok:
;----

;	mulu.w	#640,d3
	move.l	(a5,d3.w*4),d3
	add.l	d2,d2
	add.l	d2,d3

	move.w	(a2,d3.l),d2	;pal-number from dragon
	move.w	(a6,d2.w),d2	;col from dragon

	move.w	d2,(a3)+

	add.l	d0,d4	;d0=ldx
	add.l	d1,d5	;d1=ldy

	dbf	d6,Junky_Setx

;	lea	(jo)*2(a3),a3	;offset*2(byte-->word)=modulo x

	move.l	mdx(pc),d3
	add.l	d3,mdpx
	move.l	mdy(pc),d3
	add.l	d3,mdpy
	dbf	d7,Junky_Sety
;	lea	jo*(jx+jo)*2(a3),a3	;offset*line=modulo y

	lea	$dff000,a5
rts



RingTab:
;	dc.l	JunkyAnim1+27*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+24*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+21*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+18*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+15*Junky_Size,0,0,0,0

;	dc.l	JunkyAnim1+12*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+9*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+6*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+3*Junky_Size,0,0,0,0
;	dc.l	JunkyAnim1+0*Junky_Size,0,0,0,0

	dc.l	JunkyAnim2+12*Junky_Size,0,0,0,0
	dc.l	JunkyAnim2+9*Junky_Size,0,0,0,0
	dc.l	JunkyAnim2+6*Junky_Size,0,0,0,0
	dc.l	JunkyAnim2+3*Junky_Size,0,0,0,0
	dc.l	JunkyAnim2+0*Junky_Size,0,0,0,0



offtab:
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0


ifne	deltabigadd_mode
Master_x:	dc.l	0
Master_y:	dc.l	0
Master_xd:	dc.l	0
Master_yd:	dc.l	0
endif

JunkyAnimNext:	dc.l	JunkyAnim2,Junkyanim2

JunkyTunnel:
	lea	RingTab(pc),a6

	moveq	#9-5,d7
Junkytunnel_calcloop:
	move.l	(a6),a2			;ring position
	add.l	#junky_size,a2		;next ring
	cmp.l	#JunkyAnim1End,a2	;ring anim overflow?
	beq	JunkyTunnel_anim1flow

	cmp.l	#JunkyAnim2End,a2	;ring anim overflow?
	bne	notunnelrestart

JunkyTunnel_anim1flow:
rept	9-5
	move.l	20(a6),(a6)+	;move table 1 step up
	move.l	20(a6),(a6)+	;move table 1 step up
	move.l	20(a6),(a6)+	;move table 1 step up
	move.l	20(a6),(a6)+	;move table 1 step up
	move.l	20(a6),(a6)+	;move table 1 step up
endr

;	lea	JunkyAnim2,a2		;new start on last position
	lea	JunkyAnimNext(pc),a5
	move.l	(a5)+,a2		;new start on last position
	move.l	(a5),-(a5)
	move.l	a2,4(a5)

	move.l	a2,(a6)		;write ring anim start

	lea	tunnelsinpos,a5
	move.w	(a5),d5
	add.w	#8*2,d5
	cmp.w	#720,d5
	bne	notunnelsinrestart
	moveq	#0,d5
notunnelsinrestart:
	move.w	d5,(a5)+
	add.w	d5,a5

	moveq	#0,d5
ifne	Movetunnel
	move.w	(a5),d5		;read sin x
endif
	swap	d5		;float
	move.l	d5,4(a6)	;write sin x float (start position)
	neg.l	d5		;negative offset...
	asr.l	#3,d5		;.../4 coz solution >1
	divs.w	#18,d5		;30 steps
	ext.l	d5		;extend solution
	asl.l	#3,d5		;*4
	move.l	d5,12(a6)	;write sin x delta float


	moveq	#0,d5
ifne	Movetunnel
	move.w	720(a5),d5	;read sin y
endif
	swap	d5		;float
	move.l	d5,8(a6)	;write sin y float (start position)
	neg.l	d5		;negative offset...
	asr.l	#3,d5		;.../4 coz solution >1
	divs.w	#18,d5		;30 steps
	ext.l	d5		;extend solution
	asl.l	#3,d5		;*4
	move.l	d5,16(a6)


	lea	RingTab(pc),a6
ifne	deltabigadd_mode
move.l	4(a6),d0
move.l	d0,Master_x
neg.l	d0		;negative offset...
asr.l	#6,d0		;.../4 coz solution >1
divs.w	#3,d0		;30 steps
ext.l	d0		;extend solution
asl.l	#6,d0		;*4
move.l	d0,Master_xd


move.l	8(a6),d0
move.l	d0,Master_y
neg.l	d0		;negative offset...
asr.l	#6,d0		;.../4 coz solution >1
divs.w	#3,d0		;30 steps
ext.l	d0		;extend solution
asl.l	#6,d0		;*4
move.l	d0,Master_yd
endif

	dbf	d7,Junkytunnel_calcloop


notunnelrestart:
	move.l	a2,(a6)
	add.l	#20,a6
	dbf	d7,Junkytunnel_calcloop





	lea	ringtab+4(pc),a6	;skip ring number
	lea	offtab,a5
	moveq	#9-5,d7
ringcentre_loop:
	move.l	(a6),d4			;ring pos x
	move.l	4(a6),d5		;ring pos y
ifne	deltasingleadd_mode
	add.l	8(a6),d4		;ring delta x
	add.l	12(a6),d5		;ring delta y
endif
ifne	deltabigadd_mode
	add.l	master_xd,d4
	add.l	master_yd,d5
endif
	move.l	d4,(a6)
	move.l	d5,4(a6)


swap	d4
ext.l	d4
add.l	d4,d4

swap	d5
muls.w	#292,d5
add.l	d4,d5


;move.l	ringtab(pc),d4
;cmp.l	#JunkyAnim1End-100,d4
;blt	nosectexture
;sub.l	#Junky_size*15,d5
;nosectexture:

cmp.l	#JunkyAnim1End-100,-4(a6)
blt	nosectexture2
add.l	#Junky_size*15,d5
nosectexture2:


move.l	d5,(a5)+

	add.w	#20,a6

	dbf	d7,ringcentre_loop



	move.l	Copperlist_work(pc),a0
	lea	Coplist_Offset,a1
	lea	RingTab(pc),a6
	move.l	(a6)+,a2
cmp.l	#JunkyAnim1End-100,a2
blt	nosectexture3
sub.l	#Junky_size*15,a2
nosectexture3:

	lea	(jo/2*2)+(jx+jo)*(jo/2*2)(a2),a2
	lea	offtab,a5

	add.l	(a5),a2
	
	moveq	#0,d5
	moveq	#0,d4
	moveq	#0,d3
	moveq	#0,d2

	sub.l	(a5),d5
	sub.l	(a5),d4
	sub.l	(a5),d3
	sub.l	(a5)+,d2

	add.l	(a5)+,d5
	add.l	(a5)+,d4
	add.l	(a5)+,d3
	add.l	(a5)+,d2

	add.l	#-Junky_Size*3*1,d5
	add.l	#-Junky_Size*3*2,d4
	add.l	#-Junky_Size*3*3,d3
	add.l	#-Junky_Size*3*4,d2


	moveq	#0,d0	;highword must be clear!

;a0-copperlist
;a1-copperlistoffset
;a2-tunnel 1

	lea	(a2,d5.l),a3
	lea	(a2,d4.l),a4
	lea	(a2,d3.l),a5
	lea	(a2,d2.l),a6


	moveq	#jy-1,d7
JunkyTunnel_Sety:

	moveq	#jx-1,d6
JunkyTunnel_Setx:
	move.w	(a1)+,d0		;copperlist position
	move.w	(a2)+,d1		;tunnel 1
	bne	JunkyTunnel_Gotcol1

;	move.w	-2(a2,d5.l),d1
	move.w	(a3)+,d1			;2
	bne	JunkyTunnel_Gotcol2

;	move.w	-2(a2,d4.l),d1
	move.w	(a4)+,d1			;3
	bne	JunkyTunnel_Gotcol3

;	move.w	-2(a2,d3.l),d1
	move.w	(a5)+,d1			;4
	bne	JunkyTunnel_Gotcol4

;	move.w	-2(a2,d2.l),d1
	move.w	(a6)+,d1			;5
	bne	JunkyTunnel_Gotcol5
	bra	JunkyTunnel_Gotcol5



JunkyTunnel_Gotcol1:
addq.l	#2,a3
JunkyTunnel_Gotcol2:
addq.l	#2,a4
JunkyTunnel_Gotcol3:
addq.l	#2,a5
JunkyTunnel_Gotcol4:
addq.l	#2,a6
JunkyTunnel_Gotcol5:

ifne	shade2
swap	d7	;use hiword of loopcounter for calc
	and.w	#%0000111011101110,d1
	lsr.w	#1,d1

	move.w	(a0,d0.l),d7	;col shadow 2
	and.w	#%0000111011101110,d7
	lsr.w	#1,d7
	add.w	d7,d1
swap	d7
endif

	move.w	d1,(a0,d0.l)	;col,copperlist,copperlistoffset


	dbf	d6,JunkyTunnel_Setx
	lea	jo*2(a2),a2	;offset*2(byte-->word)=modulo x
	lea	jo*2(a3),a3	;offset*2(byte-->word)=modulo x
	lea	jo*2(a4),a4	;offset*2(byte-->word)=modulo x
	lea	jo*2(a5),a5	;offset*2(byte-->word)=modulo x
	lea	jo*2(a6),a6	;offset*2(byte-->word)=modulo x
	dbf	d7,JunkyTunnel_Sety
	lea	$dff000,a5

rts


Multab640:
value:	set	0
rept	256
dc.l	value*640
value:	set	value+1
endr


sizex=160
sizey=128


Coord_s:
	dc.w	0,-sizex,+sizey,0
	dc.w	0,+sizex,+sizey,0
	dc.w	0,-sizex,-sizey,0
	dc.w	0,+sizex,+sizey,0

Coord_d:
	dc.w	0,000,000,0
	dc.w	0,320,000,0
	dc.w	0,000,256,0

	dc.w	0,320,256,0




Copperlist_work:	dc.l	copperlist1
Copperlist_show:	dc.l	copperlist2

turnkoord:	dc.l	0
turnkoords:	dc.l	0
turnquant:	dc.w	0

turnaddz:	dc.w	0
turnz:		dc.w	0

turner:	;last optimizing:93-09-05

	move.w	turnz,a0
	add.w	turnaddz,a0
	cmp.w	#1436,a0
	ble nolaufz
	sub.w	#1440,a0
nolaufz:

	move.w	a0,turnz

turner1:
	move.l	turnkoord,a4	;koordinaten
	move.l	turnkoords,a3
	lea	sinus,a6	;sinus/cosinus
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
	add.l	d3,d3
	swap	d3
	add.l	d7,d6		;d6=x*sin z + y*cos z  ->new  y-koord
	add.l	d6,d6
	swap	d6

	move.w	d3,2(a4,d0.w)
	move.w	d6,4(a4,d0.w)

	subq.w	#8,d0
	bpl	turnrout1
	rts
;*****

perspective:
	move.l	turnkoord,a3
	move.l	turnkoord,a4
	move.w	turnquant,d7

perspectiveloop:

move.w	2(a3),d0
move.w	4(a3),d1
move.w	6(a3),d2
neg.w	d2
asr.w	#1,d2
add.w	#100,d2

;---
move.w	focus,d3
muls.w	d3,d0
muls.w	d3,d1
divs.w	d2,d0
divs.w	d2,d1
;---
add.w	#160,d0
add.w	#128,d1

move.w	d0,2(a4)
move.w	d1,4(a4)
move.w	6(a3),6(a4)
addq.l	#8,a3
addq.l	#8,a4

dbf	d7,perspectiveloop
rts


focus:	dc.w	400
	dc.w	2



col_black:	dcb.w	256,0

;------
include	"include/Fader2/Calc1.2.i"

Fader2_Colquant_Tunnel=256			;number of colours in this calculation
Fader2_Tablequant_Tunnel=1;	maximal number of colours in program!!
Fader2_Table_Tunnel:
	dcb.w	Fader2_Tablequant_Tunnel*Fader2_Colquant_Tunnel*16
Fader2_Tableend_Tunnel:

Fader2_Tunnel:
	;normal fading: RGB-filter=#%101010
	move.w	#Fader2_Colquant_Tunnel,d7	;number of colours

	lea	fader2_table_Tunnel,a2	;point in fader-table

	moveq	#%101010,d1		;RGB filter
	bsr	Fader2_calc
rts


Fader2Start_Tunnel:
	move.w	#Fader2_Colquant_Tunnel,fader2_quant
	move.w	#fader2_Tablequant_Tunnel*16,fader2_step
	move.w	#1,fader2_sleep	;fading speed, 1=fastest

	move.w	#1,fader2_direct		;this combination to...
	move.l	#fader2_table_Tunnel,Fader2_pos	;...fade forward

;	move.w	#-1,fader2_direct		;this combination to...
;	move.l	#fader2_tableend_Tunnel,Fader2_pos	;...fade backward
rts

;------



fadetunnel_pos:		dc.w	0
fadetunnel_masc:	incbin	"data/tunnel2.masc"


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



tunnelsinpos:	dc.w	0
tunnelsinx:
dc.W  0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 27
dc.W  29, 31, 32, 34, 35, 36, 37, 39, 40, 41, 42, 42, 43
dc.W  44, 45, 45, 45, 46, 46, 46, 46, 46, 46, 46, 46, 45
dc.W  45, 44, 44, 43, 42, 42, 41, 40, 39, 38, 37, 36, 35
dc.W  34, 32, 31, 30, 29, 27, 26, 25, 23, 22, 21, 19, 18
dc.W  17, 16, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 4, 3
dc.W  2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3
dc.W  4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18
dc.W  19, 21, 22, 23, 25, 26, 27, 29, 30, 31, 32, 34, 35
dc.W  36, 37, 38, 39, 40, 41, 42, 42, 43, 44, 44, 45, 45
dc.W  46, 46, 46, 46, 46, 46, 46, 46, 45, 45, 45, 44, 43
dc.W  42, 42, 41, 40, 39, 37, 36, 35, 34, 32, 31, 29, 27
dc.W  26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0,-2
dc.W -4,-6,-8,-10,-12,-14,-16,-18,-20,-22,-24,-26,-27,-29
dc.W -31,-32,-34,-35,-36,-37,-39,-40,-41,-42,-42,-43,-44
dc.W -45,-45,-45,-46,-46,-46,-46,-46,-46,-46,-46,-45,-45
dc.W -44,-44,-43,-42,-42,-41,-40,-39,-38,-37,-36,-35,-34
dc.W -32,-31,-30,-29,-27,-26,-25,-23,-22,-21,-19,-18,-17
dc.W -16,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-4,-3,-2,-2
dc.W -1,-1,-1, 0, 0, 0, 0, 0, 0, 0,-1,-1,-1,-2,-2,-3,-4,-4
dc.W -5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-16,-17,-18,-19,-21
dc.W -22,-23,-25,-26,-27,-29,-30,-31,-32,-34,-35,-36,-37
dc.W -38,-39,-40,-41,-42,-42,-43,-44,-44,-45,-45,-46,-46
dc.W -46,-46,-46,-46,-46,-46,-45,-45,-45,-44,-43,-42,-42
dc.W -41,-40,-39,-37,-36,-35,-34,-32,-31,-29,-27,-26,-24
dc.W -22,-20,-18,-16,-14,-12,-10,-8,-6,-4,-2
tunnelsinxend:

tunnelsiny:
dc.W  0, 1, 3, 4, 6, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19
dc.W  20, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33
dc.W  34, 35, 36, 37, 38, 38, 39, 40, 40, 41, 41, 42, 42
dc.W  43, 43, 44, 44, 44, 44, 45, 45, 45, 45, 45, 45, 45
dc.W  45, 45, 44, 44, 44, 44, 43, 43, 43, 42, 42, 41, 41
dc.W  40, 39, 39, 38, 37, 37, 36, 35, 34, 33, 33, 32, 31
dc.W  30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18
dc.W  17, 16, 15, 14, 13, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2
dc.W  1, 0, 0,-1,-2,-3,-4,-5,-6,-6,-7,-8,-9,-9,-10,-11,-11
dc.W -12,-12,-13,-13,-14,-14,-15,-15,-15,-16,-16,-16,-16
dc.W -16,-17,-17,-17,-17,-17,-17,-17,-17,-17,-16,-16,-16
dc.W -16,-15,-15,-15,-15,-14,-14,-13,-13,-12,-12,-11,-11
dc.W -10,-10,-9,-9,-8,-7,-7,-6,-5,-5,-4,-3,-3,-2,-1,-1, 0
dc.W  1, 1, 2, 3, 3, 4, 5, 5, 6, 7, 7, 8, 9, 9, 10, 10, 11
dc.W  11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 15, 16, 16
dc.W  16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16
dc.W  16, 16, 16, 15, 15, 15, 14, 14, 13, 13, 12, 12, 11
dc.W  11, 10, 9, 9, 8, 7, 6, 6, 5, 4, 3, 2, 1, 0, 0,-1,-2
dc.W -3,-4,-5,-6,-7,-8,-9,-10,-12,-13,-14,-15,-16,-17,-18
dc.W -19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30,-31
dc.W -32,-33,-33,-34,-35,-36,-37,-37,-38,-39,-39,-40,-41
dc.W -41,-42,-42,-43,-43,-43,-44,-44,-44,-44,-45,-45,-45
dc.W -45,-45,-45,-45,-45,-45,-44,-44,-44,-44,-43,-43,-42
dc.W -42,-41,-41,-40,-40,-39,-38,-38,-37,-36,-35,-34,-33
dc.W -32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-21,-20,-19
dc.W -18,-16,-15,-14,-12,-11,-10,-8,-7,-6,-4,-3,-1
tunnelsinyend:

;------------------------------------------------------------------
ColConvert:
	move.l	a0,a1
	move.w	#255,d7
ColConvert_loop:
	move.l	(a0)+,d0
	move.l	d0,d1
	move.l	d0,d2
	sub.w	d0,d0
	swap	d0		;r
	lsr.l	#8,d1
	and.w	#$00ff,d1	;g
	and.l	#$000000ff,d2	;b

	addq.b	#8,d0
	bcc	ColConvert_noreddflow
	subq.b	#8,d0
ColConvert_noreddflow:

	addq.b	#8,d1
	bcc	ColConvert_nogreendflow
	subq.b	#8,d1
ColConvert_nogreendflow:

	addq.b	#8,d2
	bcc	ColConvert_nobluedflow
	subq.b	#8,d2
ColConvert_nobluedflow:

	lsl.w	#4,d0
	sub.b	d0,d0
	and.b	#$f0,d1
	lsr.b	#4,d2
	or.b	d1,d0
	or.b	d2,d0
	
	move.w	d0,(a1)+
	dbf	d7,ColConvert_loop
	rts
;------------------------------------------------------------------


MakeJunkyColTable:

	move.w	#255,d7
MakeJunkyColTable_y:
	move.w	#319,d6
MakeJunkyColTable_x:
	moveq	#0,d0
	move.w	d6,d0
	move.w	d7,d1

	move.w	d0,d2
	not.w	d2
	lsr.w	#3,d0
	mulu.w	#40*8,d1
	add.l	d0,d1
	move.l	a0,a1
	add.l	d1,a1

	moveq	#0,d3

	btst.b	d2,7*40(a1)
	beq	MakeJunkyColTable_no7
	add.w	#128,d3

MakeJunkyColTable_no7:
	btst.b	d2,6*40(a1)
	beq	MakeJunkyColTable_no6
	add.w	#64,d3

MakeJunkyColTable_no6:
	btst.b	d2,5*40(a1)
	beq	MakeJunkyColTable_no5
	add.w	#32,d3

MakeJunkyColTable_no5:
	btst.b	d2,4*40(a1)
	beq	MakeJunkyColTable_no4
	add.w	#16,d3

MakeJunkyColTable_no4:
	btst.b	d2,3*40(a1)
	beq	MakeJunkyColTable_no3
	addq.w	#8,d3

MakeJunkyColTable_no3:
	btst.b	d2,2*40(a1)
	beq	MakeJunkyColTable_no2
	addq.w	#4,d3

MakeJunkyColTable_no2:
	btst.b	d2,1*40(a1)
	beq	MakeJunkyColTable_no1
	addq.w	#2,d3

MakeJunkyColTable_no1:
	btst.b	d2,0*40(a1)
	beq	MakeJunkyColTable_no0
	addq.w	#1,d3

MakeJunkyColTable_no0:

	add.w	d3,d3
	move.w	(a2,d3.w),(a3)+

	dbf	d6,MakeJunkyColTable_x
	dbf	d7,MakeJunkyColTable_y

rts


MakeJunkyColTable2:

	move.w	#255,d7
MakeJunkyColTable2_y:
	move.w	#319,d6
MakeJunkyColTable2_x:
	moveq	#0,d0
	move.w	d6,d0
	move.w	d7,d1

	move.w	d0,d2
	not.w	d2
	lsr.w	#3,d0
	mulu.w	#40*8,d1
	add.l	d0,d1
	move.l	a0,a1
	add.l	d1,a1

	moveq	#0,d3

	btst.b	d2,7*40(a1)
	beq	MakeJunkyColTable2_no7
	add.w	#128,d3

MakeJunkyColTable2_no7:
	btst.b	d2,6*40(a1)
	beq	MakeJunkyColTable2_no6
	add.w	#64,d3

MakeJunkyColTable2_no6:
	btst.b	d2,5*40(a1)
	beq	MakeJunkyColTable2_no5
	add.w	#32,d3

MakeJunkyColTable2_no5:
	btst.b	d2,4*40(a1)
	beq	MakeJunkyColTable2_no4
	add.w	#16,d3

MakeJunkyColTable2_no4:
	btst.b	d2,3*40(a1)
	beq	MakeJunkyColTable2_no3
	addq.w	#8,d3

MakeJunkyColTable2_no3:
	btst.b	d2,2*40(a1)
	beq	MakeJunkyColTable2_no2
	addq.w	#4,d3

MakeJunkyColTable2_no2:
	btst.b	d2,1*40(a1)
	beq	MakeJunkyColTable2_no1
	addq.w	#2,d3

MakeJunkyColTable2_no1:
	btst.b	d2,0*40(a1)
	beq	MakeJunkyColTable2_no0
	addq.w	#1,d3

MakeJunkyColTable2_no0:

	add.w	d3,d3
;	move.w	(a2,d3.w),(a3)+
	move.w	d3,(a3)+

	dbf	d6,MakeJunkyColTable2_x
	dbf	d7,MakeJunkyColTable2_y

rts




col_tunnel1:
colours1:
	incbin	"data/gruen.blt.pal"

col_tunnel2:
colours2:
	incbin	"data/fritz22.blt.pal"


codep_e:



ifne	UseSection
section	DataC,data_c
endif
datac_s:

Junkygrid:
	incbin	"data/JunkyGrid_3.raw"

Picture1:
	incbin	"data/gruen.blt"

Picture2:
	incbin	"data/fritz22.blt"

datac_e:








ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:
aa:
bssc_Memory:
Junky1:		ds.w	320*256
Coplist_Offset:	ds.w	jx*jy		;junky x * junky y

bb:
;Copperlist1:	ds.b	38500
;Copperlist2:	ds.b	38500
;Screen:		ds.b	40*256*7
Copperlist1=bssc_Memory		;38500
Copperlist2=Copperlist1+38500	;38500
Screen=Copperlist2+38500	;40*256*7


cc:

bssc_e:



ifne	UseSection
;section	DataP,data_p
endif
datap_s:
datap_e:

ifne	UseSection
ifeq	Onlychip
section	BSSP,bss_p
else
section	BSSP,bss_c	;onlychip
endif

endif
bssp_s:
Junky_Size=(jx+jo)*(jy+jo)*2

JunkyAnim1:
	ds.b	junky_size*15
JunkyAnim1End:
	ds.b	4
JunkyAnim2:
	ds.b	junky_size*15
JunkyAnim2End:
bssp_e:

printt	"Code Chip:             "
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
printt	"Object Memory:"
printv	codec_e-codec_s+datac_e-datac_s+codep_e-codep_s+datap_e-datap_s
printt	"Total Memory:"
printv	codec_e-codec_s+datac_e-datac_s+bssc_e-bssc_s+codep_e-codep_s+datap_e-datap_s+bssp_e-bssp_s







printt	"Anim size:               "
printv	(junkyanim1end-junkyanim1)*2
