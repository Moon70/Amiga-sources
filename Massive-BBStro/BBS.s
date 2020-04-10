;--------------------------------
;|  Massive BBStro              |
;|                              |
;| code by Moon/ABYSS ^ Massive |
;| music by Lousy               |
;--------------------------------
music=1		;music on/off
sinus=1		;sinus on/off
bright=0	;bright or dark mode

Showtime=0
Program_ID=1
Main_Initcall2=0
Main_Enable_jp60music=0
Main_Enable_setintflag=0
Main_Enable_jcommander=0
Main_Enable_exit=1
Main_Skipwbstarttest=1
Main_Cache=1

Planesize=256*80


section code,code_p

include	"Include/maininit/Maininit6.2.s"

bpl7pth=bpl6pth+4
bpl8pth=bpl7pth+4
bplcon3=$106
FMODE=$1fc
;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,Main_VBIVector
	move.l	a1,Main_CopperList
	move.l	a2,Main_Talk
	move.l	a3,Main_MasterCommand

	bsr.w	textcalc
	bsr.w	makecoltable
	bsr.w	makemulutab
ifne	sinus
	bsr.w	sinuscopy
endif

	bsr.w	cls
	bsr.w	apfelcalc

	bsr.w	c2p
	bsr.w	writepage

	movem.l	(a7)+,d0-a6
	rts
;----------
;------------------------------------------------------------------------
;---------
main_Back:
;-------------------------
	movem.l	d0-a6,-(a7)

ifne	music
	move.l	a5,a6
	bsr.w	P60_end
	lea	$dff000,a5
endif

	move.w	#%0000000000001111,dmacon(a5)
	move.w	#0,$a8(a5)
	move.w	#0,$b8(a5)
	move.w	#0,$c8(a5)
	move.w	#0,$d8(a5)

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
	move.w	#$00ba,ddfstop(a5)

	move.w	#%1000001000010000,bplcon0(a5)
	moveq	#0,d0
	move.l	d0,bplcon1(a5)
	move.l	d0,bpl1mod(a5)
	move.w	#%0000000000000011,fmode(a5)
	move.w	#%1000001100000000,dmacon(a5)

ifne	music
	lea	Module,a0
	sub.l	a1,a1
	moveq	#0,d0		; Auto Detect
	move.l	a5,a6
	bsr.w	P60_Init
	lea	$dff000,a5
endif

	move.l	Main_VBIVector(pc),a0
	move.l	#VBI,(a0)


;-------------------------------------------------------------


;-------------------------------------------------------------

	rts
;----------

Commands:;;



VBI:
	lea	$dff000,a5

	lea	Screen,a0
	move.l	a0,bpl1pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl2pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl3pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl4pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl5pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl6pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl7pth(a5)
	lea	planesize(a0),a0
	move.l	a0,bpl8pth(a5)


	lea	colbuffer,a4
	lea	256*2(a4),a2

	moveq	#7,d6
colcopyloop22:
	moveq	#7,d2
	sub.w	d6,d2
	ror.w	#3,d2
	move.w	d2,d3
	bset.l	#9,d3

	move.w	d2,bplcon3(a5)
	lea	$180(a5),a1
	moveq	#32/2-1,d7
colcopyloop12:
	move.l	(a4)+,(a1)+
	dbf	d7,colcopyloop12

	move.w	d3,bplcon3(a5)
	lea	$180(a5),a1
	moveq	#32/2-1,d7
colcopyloop13:
	move.l	(a2)+,(a1)+
	dbf	d7,colcopyloop13

	dbf	d6,colcopyloop22

	move.w	#0,bplcon3(a5)
	move.w	#0,$180(a5)
	move.w	#$0fff,$182(a5)



	move.w	colours1_pos,d0
	addq.w	#4,d0
	cmp.w	#2*256*4,d0
	bne.b	.noflow
	moveq	#0,d0
.noflow:
	move.w	d0,colours1_pos


	move.w	colours2_pos,d1
	addq.w	#8,d1
	cmp.w	#2*256*4,d1
	bne.b	.noflow2
	moveq	#0,d1
.noflow2:
	move.w	d1,colours2_pos

	move.w	colours3_pos,d2
	sub.w	#8,d2
	bpl.b	.noflow3
	add.w	#2*256*4,d2
.noflow3:
	move.w	d2,colours3_pos

;-------------------------------------------------------------
	lea	colours1,a0
	add.w	d0,a0
	lea	colours2,a2
	add.w	d1,a2
	lea	colours3,a3
	add.w	d2,a3

	lea	colbuffer,a4

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
	move.l	(a0)+,d0
	or.l	(a2)+,d0
	or.l	(a3)+,d0
	move.l	d0,d1

	ror.l	#4,d1
	lsr.w	#4,d1
	ror.l	#4,d1
	lsr.w	#4,d1
	rol.l	#8,d1

	lsr.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	lsl.w	#4,d0
	lsl.l	#4,d0
	swap	d0

;	move.w	d0,(a1)
;	move.w	d3,bplcon3(a5)
;	move.w	d1,(a1)+
;	move.w	d2,bplcon3(a5)

	move.w	d1,256*2(a4)
	move.w	d0,(a4)+

	dbf	d7,colcopyloop1
	dbf	d6,colcopyloop2

	rts

;-------------------------------------------------------------

colbuffer:	dcb.l	256,0

makecoltable:
	lea	colours1,a0
	lea	colours2,a1
	lea	colours3,a2

ifne	bright
	move.w	#256-1,d7
else
	move.w	#128-1,d7
endif
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
makecoltable_loop1:
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
ifeq	bright
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
endif
	addq.l	#$00000001,d0
	add.l	#$00000100,d1
	add.l	#$00010000,d2
	dbf	d7,makecoltable_loop1

ifne	bright
	move.w	#256-1,d7
else
	move.w	#128-1,d7
endif
makecoltable_loop2:
	subq.l	#$00000001,d0
	sub.l	#$00000100,d1
	sub.l	#$00010000,d2

	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
ifeq	bright
	move.l	d0,256*4*2(a0)
	move.l	d0,(a0)+
	move.l	d1,256*4*2(a1)
	move.l	d1,(a1)+
	move.l	d2,256*4*2(a2)
	move.l	d2,(a2)+
endif
	dbf	d7,makecoltable_loop2

	rts


colours1_pos:	dc.w	0
colours2_pos:	dc.w	0
colours3_pos:	dc.w	0

makemulutab:
	lea	mulu640tab,a0
	move.w	#256-1,d7
makemulutab_loop:
	move.w	#255,d0
	sub.w	d7,d0
	mulu.w	#640,d0
	move.l	d0,(a0)+
	dbf	d7,makemulutab_loop
	rts


;-----------------------------------------------------------------------

apfelcalc:
	lea	mulu640tab,a6
	lea	screen,a1
	lea	chunky,a4

	move.w	#255,d7		;y-loop bildaufbau
loopy:
	move.w	#319,d6		;x-loop	bildaufbau
loopx:


ifne	sinus
	move.w	d6,d0
	move.w	d7,d1

	lea	sinusx,a0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	add.w	d1,d1
	move.w	0(a0,d1.w),d1
	lsr.l	#1,d0
	lsr.l	#1,d1
	move.w	d0,d2
	add.w	d1,d2
else
	move.w	d7,d2
	or.w	d6,d2
	or.b	#2,d2
endif

	move.b	d2,(a4)+
	move.b	d2,(a4)+

	dbf	d6,loopx
	dbf	d7,loopy

	rts


writepage:
	lea	screen,a0
	lea	font(pc),a1
	lea	text(pc),a2

	moveq	#27,d5
writepage_yloop:

	moveq	#79,d6
writepage_xloop:
	move.w	(a2)+,d4
cmp.w	#$7b3,d4
	beq.w	writepage_space

	lea	(a1,d4.w),a3
;	move.l	a1,a3

	moveq	#0,d4
	moveq	#9-1,d7
writepage_charloop:
	move.b	(a3)+,d0
	move.b	d0,d1
	lsr.b	#1,d1
	exg	d1,d4

	or.b	d0,d1
	not.b	d1

	move.b	(a0),d2
	and.b	d1,d2
	or.b	d0,d2
	move.b	d2,(a0)

;	lea	80(a0),a0
	add.l	#planesize,a0

rept	7
	move.b	(a0),d2
	and.b	d1,d2
	move.b	d2,(a0)
;	lea	80(a0),a0
	add.l	#planesize,a0
endr

	add.l	#80-8*planesize,a0

	dbf	d7,writepage_charloop

	moveq	#0,d0
	move.b	d0,d1
	lsr.b	#1,d1
	exg	d1,d4

	or.b	d0,d1
	not.b	d1

	move.b	(a0),d2
	and.b	d1,d2
	or.b	d0,d2
	move.b	d2,(a0)

;	lea	80(a0),a0
	add.l	#planesize,a0

rept	7
	move.b	(a0),d2
	and.b	d1,d2
	move.b	d2,(a0)
;	lea	80(a0),a0
	add.l	#planesize,a0
endr

	add.l	#80-8*planesize,a0

	lea	1-80*10(a0),a0
writepage_spacecontinue:
	dbf	d6,writepage_xloop
	lea	-80+80*9(a0),a0
	dbf	d5,writepage_yloop

	rts

Writepage_space:
	lea	1(a0),a0
	bra.b	writepage_spacecontinue


CLS:
	lea	screen_end,a0
	move.w	#80*8*256/32-1,d7

	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4

CLS_Loop:
	movem.l	d0-d3/a1-a4,-(a0)
	dbf	d7,CLS_Loop
rts


ifne	sinus
sinuscopy:
	lea	sinusx,a0
	lea	sinusy,a1

	move.w	#180-1,d7
sinuscopy_loop:
	move.w	(a0)+,180*2-2(a0)
	move.w	(a1)+,180*2-2(a1)
	dbf	d7,sinuscopy_loop

rts

sinusx:
dc.W  128, 138, 148, 157, 166, 175, 182, 189, 194, 199, 202
dc.W  204, 206, 206, 205, 204, 202, 199, 196, 193, 190, 187
dc.W  184, 182, 180, 178, 178, 178, 179, 181, 183, 187, 190
dc.W  194, 199, 203, 208, 212, 216, 220, 223, 225, 226, 226
dc.W  226, 224, 221, 217, 213, 207, 201, 194, 186, 178, 170
dc.W  162, 154, 147, 140, 133, 128, 123, 120, 117, 116, 115
dc.W  116, 118, 120, 123, 127, 131, 135, 140, 144, 148, 152
dc.W  155, 158, 160, 161, 161, 160, 159, 156, 153, 149, 144
dc.W  139, 134, 128, 122, 117, 112, 107, 103, 100, 97, 96
dc.W  95, 95, 96, 98, 101, 104, 108, 112, 116, 121, 125, 129
dc.W  133, 136, 138, 140, 141, 140, 139, 136, 133, 128, 123
dc.W  116, 109, 102, 94, 86, 78, 70, 62, 55, 49, 43, 39, 35
dc.W  32, 30, 30, 30, 31, 33, 36, 40, 44, 48, 53, 57, 62
dc.W  66, 69, 73, 75, 77, 78, 78, 78, 76, 74, 72, 69, 66
dc.W  63, 60, 57, 54, 52, 51, 50, 50, 52, 54, 57, 62, 67
dc.W  74, 81, 90, 99, 108, 118

dcb.w	180,0

sinusy:
dc.W  128, 136, 144, 151, 159, 166, 173, 180, 186, 192, 198
dc.W  203, 208, 213, 216, 220, 223, 225, 226, 228, 228, 229
dc.W  228, 227, 226, 225, 222, 220, 217, 214, 211, 208, 204
dc.W  200, 197, 193, 189, 185, 181, 178, 174, 171, 168, 165
dc.W  162, 160, 158, 156, 155, 153, 152, 152, 151, 151, 151
dc.W  152, 152, 153, 154, 155, 156, 157, 158, 159, 160, 162
dc.W  163, 163, 164, 165, 165, 166, 166, 165, 165, 164, 163
dc.W  162, 161, 159, 157, 155, 152, 150, 147, 144, 141, 138
dc.W  135, 131, 128, 125, 121, 118, 115, 112, 109, 106, 104
dc.W  101, 99, 97, 95, 94, 93, 92, 91, 91, 90, 90, 91, 91
dc.W  92, 93, 93, 94, 96, 97, 98, 99, 100, 101, 102, 103
dc.W  104, 104, 105, 105, 105, 104, 104, 103, 101, 100, 98
dc.W  96, 94, 91, 88, 85, 82, 78, 75, 71, 67, 63, 59, 56
dc.W  52, 48, 45, 42, 39, 36, 34, 31, 30, 29, 28, 27, 28
dc.W  28, 30, 31, 33, 36, 40, 43, 48, 53, 58, 64, 70, 76
dc.W  83, 90, 97, 105, 112, 120

dcb.w	180,0
endif


ifne	music
text:	incbin	"data/disaster.fix.music"
else
text:	incbin	"data/disaster.fix"
endif

textend:	dcb.b	textend-text,0
textoffsetend:	dc.w	-1

chars:	incbin	"data/chars.txt"
charsend:
even

charsize=1*9
textcalc:
	lea	textoffsetend(pc),a0
	lea	textend(pc),a1
	lea	charsend(pc),a2
	move.w	#textend-text-1,d7
textcalcl1:
	move.l	a2,a3
	move.b	-(a1),d0
	move.w	#charsend-chars-1,d6
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


C2P:
	lea	Screen,a0
	lea	Chunky,a1

;	lea	planesize*2(a0),a2
;	lea	planesize*2(a2),a3
;	lea	planesize*2(a3),a4

	move.l	a0,a2
	add.l	#planesize*2,a2
	move.l	a2,a3
	add.l	#planesize*2,a3
	move.l	a3,a4
	add.l	#planesize*2,a4

	lea	C2P_Data(pc),a6
	move.w	#640*256/8/2/2,C2P_Counter(a6)

C2P_Loop:
	move.w	#2,C2P_2Count(a6)
C2P_Loop2:
	move.w	#8,(a6)

C2P_8Loop:
	move.w	(a1)+,d0	;get chunkyword (=2 pixel)
	add.w	d0,d0		;pix1plane7
	addx.l	d7,d7

	add.w	d0,d0		;pix1plane6
	addx.l	d6,d6

	add.w	d0,d0
	addx.l	d5,d5

	add.w	d0,d0
	addx.l	d4,d4

	add.w	d0,d0
	addx.l	d3,d3

	add.w	d0,d0
	addx.l	d2,d2

	add.w	d0,d0
	addx.l	d1,d1

	add.w	d0,d0
	swap	d0		;wahh, need more register...
	addx.w	d0,d0
	swap	d0

	add.w	d0,d0		;pix2plane7
	addx.l	d7,d7

	add.w	d0,d0		;pix2plane6
	addx.l	d6,d6

	add.w	d0,d0
	addx.l	d5,d5

	add.w	d0,d0
	addx.l	d4,d4

	add.w	d0,d0
	addx.l	d3,d3

	add.w	d0,d0
	addx.l	d2,d2

	add.w	d0,d0
	addx.l	d1,d1

	add.w	d0,d0
	swap	d0		;wahh, need more register...
	addx.w	d0,d0
	swap	d0

subq.w	#1,(a6)
bne.b	C2P_8Loop
	swap	d0
	move.w	d0,(a0)+
	swap	d0

	subq.w	#1,2(a6)
	bne.b	C2P_Loop2

	move.l	d7,planesize(a4)
	move.l	d6,(a4)+
	move.l	d5,planesize(a3)
	move.l	d4,(a3)+
	move.l	d3,planesize(a2)
	move.l	d2,(a2)+
	move.l	d1,planesize-4(a0)
;	move.w	d0,(a0)+

	subq.w	#1,C2P_Counter(a6)
	bne.b	C2P_Loop

	rts

C2P_Data:	rsreset
		dcb.w	3,0
C2P_8Count:	rs.w	1
C2P_2Count:	rs.w	1
C2P_Counter:	rs.w	1


ifne	music
player:	incbin	"data/player60a_c1.code"
playerend:
P60_init=player+80
P60_end=player+774
P60_master=player+16
endif



font:	incbin	"data/font1.raw"


ifne	music
section data,data_c
Module:	
;	incbin	"data/p60.klezmer-disaster"
	incbin	"data/p60.liquid_simplicity"
endif


section	screen,bss_c

Screen:
	ds.b	8*80*256
Screen_end:


section	bssp,bss_p
	Chunky:		ds.b	640*256

	colours1:	ds.l	4*256
	colours2:	ds.l	4*256
	colours3:	ds.l	4*256

	mulu640tab:	ds.l	256
