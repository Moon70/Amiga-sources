;------------------------------------------------------------------------
;|                                                                      |
;|                             Drugstore Main                           |
;|                            ----------------                          |
;|                                                                      |
;|                                                                      |
;|                                                                      |
;| code by Moon/Abyss                                                   |
;------------------------------------------------------------------------
UseSection=1
Printmem=1
OnlyDisc=0

a:
music=1
determblink=0
planesize=40*103
;intena=$09a

;--------
waitblit:	macro
loop\@:	btst	#14,$dff002
	bne	loop\@
	endm
;-----------
ifne	UseSection
section	CodeC,code_c
endif
codec_s:
Main_Enable_JP60music=1
Main_Enable_SetIntflag=1
Main_Enable_JCommander=1
Main_Enable_Exit=1
showtime=0
Main_Initcall2=0
Program_ID=99
include	"/maininit/maininit6.01.s"


commands:;;
		dc.l	150,	Setdcom,LDE_PDNote		       ;a
		dc.l	60000,Discerror2
		dc.l	1525,	Setdcom,L_Block1	       ;b
		dc.l	60000,Discerror

;L_block1, DI_module1, D_jaul, D_drugstore, DI1_dotpic
;continued when I1dotpic finished

		dc.l	80+10,	setdcom,pdout		;+I_jaul+I_drugstore   ;c
		dc.l	48-10,	Setdcom,E_jaul			       ;d
		dc.l	80+160+48-1,	Setdcom,E_drugstore	;+D_abyss      ;e
		dc.l	1,	Setdcom,I_abyss			       ;f
		dc.l	400,	Setdcom,E_abyss	;(-26)+I2_dotpic+C_sinedots ;g
;continued when I3_dotpic finished
		dc.l	746,	setdcom,E_dotpic;		       ;h

		dc.l	1,	setcopscreen_Emptydotpic
		dc.l	1,	setemptyvbi
		dc.l	29,	setdcom,dri_sinedots;		       ;i
		dc.l	740,	setdcom,e_sinedots;			j
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	28,	setdcom,dri_dialog1;			k
		dc.l	1,	setdcom,e_dialog1;			l
		dc.l	960-1-28+30-1-54,	Setdcom,L_Block2;			m
dc.l	60000,Discerror

		dc.l	160-30,	TalkDialog1out

;#####
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	54,	Setdcom,dri_Colvec
		dc.l	2690,	Setdcom,e_Colvec
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	28,	setdcom,dri_dialog2
		dc.l	640+80-1-28-1-42,	setdcom,e_dialog2
;#####

		dc.l	1,	setcopscreen_Emptydialog
		dc.l	42,		Setdcom,dri_SCScroll
		dc.l	2800,		Setdcom,e_SCScroll
;#####
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	28,	setdcom,dri_dialog3
		dc.l	640,	setdcom,e_dialog3
;#####
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	36,	Setdcom,dri_Glasvec
;		dc.l	100,	setcopscreen_Emptycopper
		dc.l	2218,	Setdcom,e_Glasvec
;#####
		dc.l	1,	setcopscreen_White
		dc.l	1,	SetEmptyVBI
		dc.l	13,	setdcom,dri_insdisc2
		dc.l	1,	setdcom,e_insdisc2

		dc.l	60000,	Setdcom,L_Module2Block3
		dc.l	65000,	Discerror

;#####

		dc.l	10,	setdcom,i_james

		dc.l	200,	setdcom,DRI1_RGB
		dc.l	50,	loadingout
		dc.l	1,	setcopscreen_Emptyblack
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	950,	e_james

		dc.l	1,	setcopscreen_EmptyStar
		dc.l	25,	setdcom,DRI_Starscroll
		dc.l	1,	setdcom,E_Starscroll
		dc.l	2200-200,	setdcom,I2_RGB
		dc.l	2870+50,	setdcom,E_RGB
		dc.l	1,	setcopscreen_EmptyStarback
		dc.l	55,	setdcom,dri_Cloud
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	1222+100-77,setdcom,e_Cloud	;+dri1_Spiral
		dc.l	1,	setcopscreen_Emptyspiral
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	115,	setdcom,dri1_Spiral	;+I2_Spiral
		dc.l	1800-290,	setdcom,E_Spiral

		dc.l	1,	setcopscreen_Emptyspiral
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	6,	setdcom,dri_Text1
		dc.l	380,	setdcom,e_Text1
		dc.l	1,	setcopscreen_Emptydialog
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	1740,	setdcom,e_Clown

		dc.l	1,	setcopscreen_Emptyblack
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	44,	setdcom,dri_Text2	;+dri_child
		dc.l	490,	setdcom,e_Text2	;+dri1_mont

		dc.l	1,	setcopscreen_EmptyText2
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	630+50,	e_Child

		dc.l	1,	setcopscreen_Emptyblack
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	6,	setdcom,i2_Mont
		dc.l	1700,	setdcom,e_Mont
		dc.l	1,	setcopscreen_Emptyblack
		dc.l	1,	setcopscreen_Emptycopper
		dc.l	1,	setdcom,drie_Text3
		dc.l	60000,	setdcom,ldrie_Endpart
		dc.l	100,	endloop

		
;#####

;---------------------------------------------
endloop:
	subq.w	#8,Commander_Point
rts

nothing:	rts

Discerror:
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)

	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)
	lea	$dff000,a6
	jsr	P60_end

Discerror2:
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)

	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)

	lea	Discerrorcode,a1
	lea	Chip_Memory,a0
	bsr.w	determ;-----------
	lea	Chip_Memory,a0
	move.l	a0,a1			;source=dest chip;
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	Chip_Memory,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	lea	Chip_Memory,a4
	jsr	2*6(a4)
	rts
;----------

;---------------------
CopScreen_Emptyscreen:
		dc.w	$0180
Emptyscreencol:	dc.w	$0fff
		dc.w	bplcon0,%0000001000000000
		dc.l	-2

SetCopScreen_Emptydotpic:
;	lea	main_vbivector(pc),a0
;	move.l	(a0),a0
;	move.l	#0,(a0)

	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0101,(a0)		;backgroundcol dotpic
	rts

SetCopScreen_Emptydialog:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0202,(a0)		;backgroundcol dialog
	rts

SetCopScreen_EmptyText2:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0013,(a0)
	rts

SetCopScreen_Emptyspiral:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0002,(a0)		;backgroundcol dialog
	rts


SetCopScreen_Emptyblack:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0000,(a0)
	rts


SetCopScreen_EmptyStar:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$004,(a0)
	rts

SetCopScreen_EmptyStarback:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$003,(a0)
	rts

SetCopScreen_White:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0fff,(a0)
	rts

SetCopScreen_Dialogback:
	lea	main_copperlist(pc),a0
	move.l	(a0),a0
	lea	CopScreen_Emptyscreen(pc),a1
	move.l	a1,(a0)
	lea	Emptyscreencol(pc),a0
	move.w	#$0202,(a0)		;backgroundcol dialog
	rts

SetEmptyVBI:
	lea	main_vbivector(pc),a0
	move.l	(a0),a0
	move.l	#0,(a0)
	rts


SetCopScreen_Emptycopper:
	move.l	main_copperlist(pc),a0
	move.l	#-1,(a0)
	rts


Setdcom:
	lea	dcommand(pc),a0
	move.l	(a1),(a0)
	addq.w	#4,Commander_Point
	rts
;----------
dri_sinedots:
	lea	TermMem_sinedots,a0
;	lea	LoadMem_sinedots,a1
	lea	CopyMem_sinedots,a1
	bsr.w	determ;-----------
	lea	TermMem_sinedots,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Sinedots,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
e_sinedots:
	lea	TermMem_Sinedots,a4
	jsr	2*6(a4)
	rts
;----------

;----------
dri_colvec:
	lea	TermMem_Colvec,a0
	lea	LoadMem_Colvec,a1
	bsr.w	determ;-----------
	lea	TermMem_Colvec,a0
	move.l	a0,a1			;source=dest chip;
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Colvec,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
e_colvec:
	lea	TermMem_Colvec,a4
	jsr	2*6(a4)
	rts
;----------
;----------
dri_SCScroll:
	lea	TermMem_SCScroll,a0
	lea	LoadMem_SCScroll,a1
	bsr.w	determ;-----------
	lea	TermMem_SCScroll,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_SCScroll,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
e_SCScroll:
	lea	TermMem_SCScroll,a4
	jsr	2*6(a4)
	rts
;----------
;----------
dri_Glasvec:
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	move.l	#0,(a0)
	move.l	#-2,(a1)
	move.l	#0,(a2)

	lea	TermMem_Glasvec,a0
	lea	LoadMem_Glasvec,a1
	bsr.w	determ;-----------
	lea	TermMem_Glasvec,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Glasvec,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
rts
;---------
e_Glasvec:
	lea	TermMem_Glasvec,a4
	jsr	2*6(a4)
	rts
;-----------
dri_dialog1:
	lea	TermMem_dialog1,a0
	lea	LoadMem_dialog1,a1
	bsr.w	determ;-----------
	lea	TermMem_dialog1,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Dialog1,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_dialog1:
	lea	TermMem_Dialog1,a4
	jsr	2*6(a4)
	rts
;-----
;----------
dri_dialog2:
	lea	TermMem_dialog2,a0
	lea	LoadMem_dialog2,a1
	bsr.w	determ;-----------
	lea	TermMem_dialog2,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Dialog2,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_dialog2:
	lea	TermMem_Dialog2,a4
	jsr	2*6(a4)
	rts
;-----
;----------
dri_dialog3:
	lea	TermMem_dialog3,a0
	lea	LoadMem_dialog3,a1
	bsr.w	determ;-----------
	lea	TermMem_dialog3,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------

	lea	TermMem_Dialog3,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_dialog3:
	lea	TermMem_Dialog3,a4
	jsr	2*6(a4)
	rts
;-----
dri_Insdisc2:
	lea	TermMem_Insdisc2,a0
	lea	LoadMem_Insdisc2,a1
	bsr.w	determ;------------
	lea	TermMem_Insdisc2,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;--------

	lea	TermMem_Insdisc2,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_Insdisc2:
	lea	TermMem_Insdisc2,a4
	jsr	2*6(a4)
	rts
;-----
dr_james:
	lea	TermMem_James,a0
	lea	LoadMem_James,a1
	bsr.w	determ;---------
	lea	TermMem_James,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-----
	rts
;----------
;-------
i_James:
	lea	TermMem_James,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_James:
	move.w	#64,p60_master
	move.w	#0,f_skipmusic

	lea	TermMem_James,a4
	jsr	2*6(a4)
	rts

;cont_james:
;	bsr	dri1_RGB
;bsr	setcopscreen_Emptydialog
;	bsr	dri_Starscroll
;	bsr	e_Starscroll

;	bsr	i2_RGB
;	bsr	e_RGB
	rts
;-----
;-----
DRI1_RGB:
	lea	TermMemF_RGB,a0
	lea	LoadMem_RGB,a1
	bsr.w	determ;------------
	lea	TermMemF_RGB,a0		;source
	lea	TermMemC_RGB,a1		;dest chip
	move.l	a0,a2			;dest fast
	bsr.w	relocator2;--------

	lea	TermMemC_RGB,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
;-----
i2_RGB:
	lea	TermMemC_RGB,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_RGB:
	lea	TermMemC_RGB,a4
	jsr	2*6(a4)
	rts
;-----
;-----
DRI_Starscroll:
	lea	TermMem_Starscroll,a0
	lea	LoadMem_Starscroll,a1
	bsr.w	determ;---------------
	lea	TermMem_Starscroll,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Starscroll,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
;-----
e_Starscroll:
	lea	TermMem_Starscroll,a4
	jsr	2*6(a4)
	rts
;-----
;-----
DRI_Cloud:
	lea	TermMem_Cloud,a0
	lea	LoadMem_Cloud,a1
	bsr.w	determ;---------------

	lea	TermMem_Cloud,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Cloud,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
;-----
e_Cloud:
	lea	TermMem_Cloud,a4
	jsr	2*6(a4)
	rts
;-----
;-----
DRI1_Spiral:
	lea	LoadMem_Text1,a0
	lea	CopyMem_Text1,a1
	move.w	#Disclen_Text1*$1600/4-1,d7
CopyText1_Loop:
	move.l	(a0)+,(a1)+
	dbf	d7,CopyText1_Loop

	lea	LoadMem_Clown,a0
	lea	CopyMem_Clown,a1
	move.w	#Disclen_Clown*$1600/4-1,d7
CopyClown_Loop:
	move.l	(a0)+,(a1)+
	dbf	d7,CopyClown_Loop


	lea	TermMemF_Spiral,a0
	lea	LoadMem_Spiral,a1
	bsr.w	determ;---------------

	lea	TermMemF_Spiral,a0		;source
	lea	TermMemC_Spiral,a1			;dest chip
	lea	TermMemF_Spiral,a2			;dest fast
	bsr.w	relocator2;-----------

	lea	TermMemC_Spiral,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	bsr.b	I2_Spiral
	rts
;-----
I2_Spiral:
	lea	TermMemC_Spiral,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
e_Spiral:
	lea	TermMemC_Spiral,a4
	jsr	2*6(a4)
	rts
;-----
;-----
DRI_Text1:
	lea	TermMem_Text1,a0
	lea	CopyMem_Text1,a1
	bsr.w	determ;---------------

	lea	TermMem_Text1,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Text1,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;-----
;-----
e_Text1:
	lea	TermMem_Text1,a4
	jsr	2*6(a4)
	bsr.b	dri_clown
	rts
;-----
;-----
DRI_Clown:
	lea	TermMemF_Clown,a0
	lea	CopyMem_Clown,a1
	bsr.w	determ;---------------

	lea	TermMemF_Clown,a0		;source
	lea	TermMemC_Clown,a1			;dest chip
	lea	TermMemF_Clown,a2			;dest fast
	bsr.w	relocator2;-----------

	lea	TermMemC_Clown,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	rts
;-----
;-----
e_Clown:
	lea	TermMemC_Clown,a4
	jsr	2*6(a4)

	lea	LoadMem_Block4,a0
	move.l	#DiscPos_Block4,d0
	move.l	#DiscLen_Block4,d1
	move.l	#DiscNam_Block4,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Block4,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror

	jsr	2*6(a4)
	rts
;-----
;-----
DRI_Text2:
	lea	TermMem_Text2,a0
	lea	LoadMem_Text2,a1
	bsr.w	determ;---------------

	lea	TermMem_Text2,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Text2,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	bsr.w	DRI_Child
	rts
;-----
;-----
e_Text2:
	lea	TermMem_Text2,a4
	jsr	2*6(a4)

	lea	dcommand(pc),a0
	move.l	#dri1_mont,(a0)
	rts
;-----
;-----
DRIE_Text3:
	lea	TermMem_Text3,a0
	lea	LoadMem_Text3,a1
	bsr.w	determ;---------------

	lea	TermMem_Text3,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Text3,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	lea	TermMem_Text3,a4
	jsr	2*6(a4)
	rts
;-----
LDRIE_Endpart:
	move.w	#1,f_skipmusic

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5

	lea	LoadMem_Module3,a0
	move.l	#DiscPos_Module3,d0
	move.l	#DiscLen_Module3,d1
	move.l	#DiscNam_Module3,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Module3,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror

	lea	TermMem_Module3,a0
	lea	LoadMem_Module3,a1
	bsr.w	determ;---------

	lea	TermMem_Module3,a0	; Module+Samples
	sub.l	a1,a1
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5





	lea	LoadMem_Endpart,a0
	move.l	#DiscPos_Endpart,d0
	move.l	#DiscLen_Endpart,d1
	move.l	#DiscNam_Endpart,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Endpart,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror

	lea	TermMemF_Endpart,a0
	lea	LoadMem_Endpart,a1
	bsr.w	determ;---------------

	lea	TermMemF_Endpart,a0		;source
	lea	TermMemC_Endpart,a1		;dest chip
	move.l	a0,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMemC_Endpart,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	move.w	#0,f_skipmusic
	lea	TermMemC_Endpart,a4
	jsr	2*6(a4)


DiscEndLoop:
	lea	Main_Register(pc),a1
	tst.l	(a1)
	bne	DoExit
	jsr	(a0)	;got backjump from Endpart
	bra	DiscEndLoop

DoExit:
	rts
;-----
;-----
DRI_Child:
	lea	TermMem_Child,a0
	lea	LoadMem_Child,a1
	bsr.w	determ;---------------

	lea	TermMem_Child,a0		;source
	move.l	a0,a1				;dest chip
	sub.l	a2,a2				;dest fast
	bsr.w	relocator2;-----------

	lea	TermMem_Child,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	rts
;-----
;-----
e_Child:
	lea	TermMem_Child,a4
	jsr	2*6(a4)
	rts
;-----
;-----
DRI1_Mont:
	lea	TermMemF_Mont,a0
	lea	LoadMem_Mont,a1
	bsr.w	determ;---------------

	lea	TermMemF_Mont,a0		;source
	lea	TermMemC_Mont,a1		;dest chip
	lea	TermMemF_Mont,a2		;dest fast
	bsr.w	relocator2;-----------

;i1
	lea	TermMemC_Mont,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	rts
;----------
i2_Mont:
	lea	TermMemC_Mont,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
;-----
e_Mont:
	lea	TermMemC_Mont,a4
	jsr	2*6(a4)
	rts
;-----
;-----
pdout:
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#2,(a0)
	move.w	#0,f_skipmusic

	lea	TermMem_Jaul,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)

	lea	TermMem_Drugstore,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
;------
E_jaul:
	lea	TermMem_Jaul,a4
	jsr	2*6(a4)
	jsr	3*6(a4)
	rts
;----------
;--------
E_dotpic:
	lea	TermMemCF_Dotpic,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	2*6(a4)
	rts
;----------
;----------
E_drugstore:
	lea	TermMem_Drugstore,a4
	jsr	2*6(a4)

	lea	dcommand(pc),a0
	lea	determ_abyss(pc),a1
	move.l	a1,(a0)
	rts
;----------
I_abyss:
	lea	TermMem_Abyss,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)
	rts
;----------
;-------
E_abyss:
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	move.l	#0,(a0)
	move.l	#-2,(a1)
	move.l	#0,(a2)

	lea	TermMem_Abyss,a4
	jsr	2*6(a4)

	lea	LoadMem_Sinedots,a0
	lea	CopyMem_Sinedots,a1
	move.w	#Disclen_Sinedots*$1600/16-1,d7
CopySinedots_Loop:
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	dbf	d7,CopySinedots_Loop

	moveq	#1,d0
	lea	TermMemCF_Dotpic,a4
	jsr	1*6(a4)		;precalc come table

	move.l	main_talk,a2
waitsignal:	;waiting till dotpic begins fading
	cmp.w	#2,(a2)
	bne.b	waitsignal

	moveq	#2,d0
	lea	TermMemCF_Dotpic,a4
	jsr	1*6(a4)		;precalc code table
;	move.w	#1,Commander_Sleep

	rts
;----------

commandrestart:
	lea	Commander_Point(pc),a0
	move.w	#0,(a0)
	rts

musicon:
	move.w	#0,f_skipmusic
rts

setint_test:
	move.w	#$9981,diwstrt(a5)
	move.w	#$00c1,diwstop(a5)
	move.w	#$0038,ddfstrt(a5)
	move.w	#$00d0,ddfstop(a5)
	move.w	#0,bplcon1(a5)
	move.w	#0,bplcon2(a5)
	move.w	#0,bpl1mod(a5)
	move.w	#0,bpl2mod(a5)
	move.w	#%0001001000000000,bplcon0(a5)

;	lea	main_vbivector,a0
;	move.l	(a0),a0
;	move.l	#int_test,(a0)

;	lea	main_copperlist,a1
;	move.l	(a1),a1
;	move.l	#copperlist,(a1)

	rts
;------------------------------------------------------------------------
;setdcom_ldsPDNote:
;	lea	dcommand(pc),a0
;	lea	lds_pdnote(pc),a1
;	move.l	a1,(a0)
;	rts
;------------------------------------------------------------------------
;setdcom_loadfirstpart:
;	lea	dcommand(pc),a0
;	lea	load_firstpart(pc),a1
;	move.l	a1,(a0)
;	rts
;----------
LDE_LoMem:
	lea	LoadMem_LoMem,a0
	move.l	#DiscPos_LoMem,d0
	move.l	#DiscLen_LoMem,d1
	move.l	#DiscNam_LoMem,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_LoMem,(a1)

	bsr.w	loadtracks;-------
	tst.w	d3
	bne.w	Discerror

	lea	TermMem_LoMem,a0
	lea	LoadMem_LoMem,a1
	bsr.w	determ;-----------
	lea	TermMem_LoMem,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------
	lea	TermMem_LoMem,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)			;init code
	jsr	2*6(a4)			;execute code
	rts
;----------
LDE_pdnote:
	lea	LoadMem_PDNote,a0
	move.l	#DiscPos_PDNote,d0
	move.l	#DiscLen_PDNote,d1
	move.l	#DiscNam_PDNote,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_PDNote,(a1)

	bsr.w	loadtracks;-------
	tst.w	d3
	bne.w	Discerror

	lea	TermMem_PDNote,a0
	lea	LoadMem_PDNote,a1
	bsr.w	determ;-----------
	lea	TermMem_PDNote,a0
	move.l	a0,a1			;source=dest chip
	sub.l	a2,a2			;no fast
	bsr.w	relocator2;-------
	lea	TermMem_PDNote,a4
	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	jsr	1*6(a4)			;init code
	jsr	2*6(a4)			;execute code
	addq.w	#8,Commander_Point
	rts
;----------
;-----------
L_Block1:
	lea	LoadMem_Block1,a0
	move.l	#DiscPos_Block1,d0
	move.l	#DiscLen_Block1,d1
	move.l	#DiscNam_Block1,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Block1,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror

	lea	TermMem_Module1,a0
	lea	LoadMem_Module1,a1
	bsr.w	determ;--------

;--------------------------
ifne	music
; ������������������������������������������������
; � Call P60_Init to initialize the playroutine	�
; � D0 --> Timer detection (for CIA-version)	�
; � A0 --> Address to the module		�
; � A1 --> Address to samples/0			�
; � A2 --> Address to sample buffer		�
; � D0 <-- 0 if succeeded			�
; � A6 <-- $DFF000				�
; � 		Uses D0-A6			�
; ������������������������������������������������
	lea	TermMem_Module1,a0	; Module
	sub.l	a1,a1	;	 Samples
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5
endif
;--------------------------

	lea	TermMem_Jaul,a0
	lea	LoadMem_Jaul,a1
	bsr.w	determ;--------
	lea	TermMem_Jaul,a0
	move.l	a0,a1
	sub.l	a2,a2
	bsr.w	relocator2;----

	lea	TermMem_Drugstore,a0
	lea	LoadMem_Drugstore,a1
	bsr.w	determ;-------------
	lea	TermMem_Drugstore,a0
	move.l	a0,a1
	sub.l	a2,a2
	bsr.w	relocator2;---------

	lea	TermMemCF_Dotpic,a0
	lea	LoadMem_Dotpic,a1
	bsr.w	determ;------------
	lea	TermMemCF_Dotpic,a0
	sub.l	a1,a1			;code for 'hunktable'
	lea	HunkTable_Dotpic,a2
	bsr.w	relocator2;--------

	move.l	main_vbivector,a0
	move.l	main_copperlist,a1
	move.l	main_talk,a2
	move.l	#0,(a2)
	lea	TermMemCF_Dotpic,a4
	moveq	#0,d0
	jsr	1*6(a4)		;precalc main table

	addq.w	#8,Commander_Point
	rts
;----------
;--------
L_Block2:
	lea	LoadMem_Block2,a0
	move.l	#DiscPos_Block2,d0
	move.l	#DiscLen_Block2,d1
	move.l	#DiscNam_Block2,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Block2,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror
	addq.w	#8,Commander_Point
	rts

L_Module2Block3:
	bsr.w	dr_james

	lea	LoadMem_Module2,a0
	move.l	#DiscPos_Module2,d0
	move.l	#DiscLen_Module2,d1
	move.l	#DiscNam_Module2,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Module2,(a1)

	bsr.w	loadtracks
	tst.w	d3
	bne.w	Discerror

Trytoload_Block3:
	lea	LoadMem_Block3,a0
	move.l	#DiscPos_Block3,d0
	move.l	#DiscLen_Block3,d1
	move.l	#DiscNam_Block3,d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Block3,(a1)

	bsr.w	loadtracks
	tst.w	d3
	beq.b	Loaded_Block3
	cmp.w	#1,d3
	beq.b	DRVnotfound_Block3
	nop
DRVnotfound_Block3:
	move.l	Main_Talk(pc),a0
	move.w	#$010f,(a0)	;change pic (insdisc2 <-> loading)
Waitforinspic:
	cmp.w	#$020f,(a0)
	bne.b	Waitforinspic

FakeDiscsearch:
	lea	LoadMem_Block3,a0
	move.l	#DiscPos_Block3,d0
	move.l	#DiscLen_Block3,d1
	move.l	#"DEPP",d2
	lea	trackbuffer(pc),a1
	move.l	#DiscBuf_Block3,(a1)

	bsr.w	loadtracks

	move.l	#DiscNam_Block3,d0
	cmp.l	ActDiscName,d0
	bne.b	FakeDiscsearch
	move.l	Main_Talk(pc),a0
	move.w	#$010f,(a0)	;change pic (insdisc2 <-> loading)

	bra.b	Trytoload_Block3
	

Loaded_Block3:

waitmusicout:
	move.w	#0,intflag
waitinterrupt:
	tst.w	intflag
	beq.b	waitinterrupt

	lea	p60_master,a1
	subq.w	#1,(a1)
	bne.b	waitmusicout

	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5

	move.w	#1,f_skipmusic

	lea	TermMem_Module2,a0
	lea	LoadMem_Module2,a1
	bsr.w	determ;---------

	lea	TermMem_Module2,a0	; Module+Samples
	sub.l	a1,a1
	lea	$dff000,a6
	jsr	P60_Init
	lea	$dff000,a5

	addq.w	#8,Commander_Point
	move.w	#1,Commander_Sleep	;next command: end pdnote
	rts

Loadingout:
	move.l	Main_Talk(pc),a0
	move.w	#$030f,(a0)
	rts
;----------
;--------------
TalkDialog1out:
	lea	main_talk,a0
	move.l	(a0),a0
	move.w	#1,(a0)
	rts
;----------
;------------
determ_abyss:
	lea	TermMem_Abyss,a0
	lea	LoadMem_Abyss,a1
	bsr.w	determ;---------
	lea	TermMem_Abyss,a0
	move.l	a0,a1
	sub.l	a2,a2
	bsr.w	relocator2;-----
	rts
;----------
HunkTable_Dotpic:
	dc.l	TermMemCF_Dotpic
	dc.l	TermMemCC_Dotpic
	dc.l	TermMemBC_Dotpic
	dc.l	TermMemBF_Dotpic



;------------------------------------------------------------------------
;---------
main_init:;;
	movem.l	d0-a6,-(a7)
	move.l	a0,main_vbivector
	move.l	a1,main_copperlist
	move.l	a2,main_talk
	move.w	#$0102,$dff180	;pdnote background

	move.w	#1,f_skipmusic
	bsr.w	track_getdrivecode

	movem.l	(a7)+,d0-a6
	rts
;----------
;---------
main_back:
	lea	main_vbivector,a0
	move.l	(a0),a0
	move.l	#0,(a0)

	lea	main_copperlist,a1
	move.l	(a1),a1
	move.l	#main_emptycopperlist,(a1)

ifne	music
; ������������������������������������������������
; �     	Call P60_End to stop the music	�
; �   A6 --> Customchip baseaddress ($DFF000)	�
; �		Uses D0/D1/A0/A1/A3		�
; ������������������������������������������������
	lea	$dff000,a6
	jsr	P60_end
	lea	$dff000,a5
endif
	rts
;----------

Main_program:;;
	lea	Main_Register(pc),a0
	tst.l	4(a0)
	beq.b	Main_Loop	;got enough memory
	move.w	#-1,Commander_Sleep
	bsr.w	LDE_LoMem


Main_Loop:
	bsr.b	dcommander
ifne	Main_Enable_Exit
	lea	Main_Register(pc),a0
	tst.l	(a0)
	beq	DontExit
	btst.b	#6,ciaapra
	beq.b	Main_Exit2
Dontexit:
endif
	tst.w	f_endprogram
	beq.b	Main_Loop
Main_Exit2:
	rts


f_endprogram:		dc.w	0
dcommand:		dc.l	0
;routines
;------------------------------------------------------------------------
dcommander:
	lea	dcommand(pc),a0
	tst.l	(a0)
	beq.b	dcommander_back
	move.l	(a0),a1
	move.l	#0,(a0)
	jsr	(a1)
dcommander_back:
	rts
;------------------------------------------------------------------------
;------------------------------------------------------------------------


;------------------------------------------------------------------------
;|                                                                      |
;|                              TRACKLOADER                             |
;|                                                                      |
;| Features: accessing disc, NOT drive!!                                |
;|   supporting df0: to df3:                                            |
;|   discsearch: last load = first seek                                 |
;|                                                                      |
;|                                                                      |
;| Usage:    jsr loadtracks                                             |
;|   a0...adress for loaded data                                        |
;|   d0...start track                                                   |
;|   d1...number of tracks                                              |
;|   d2...disc name                                                     |
;|                                                                      |
;|                                                                      |
;| code by Moon                                               16-Oct-93 |
;------------------------------------------------------------------------

trackloaderexc:
	movem.l	d0-a6,-(a7)
	bsr.b	loadtrack
	movem.l	(a7)+,d0-a6
	rte

loadtrack:
;a0=destination adress
;d0=starttrack
;d1=length tracks

movem.l	d0-a6,-(a7)

	lea	$dff000,a5
	lea	$bfd100,a6
	bsr.w	sethead	;d2/d7 changed

readloop:
	subq.w	#1,d1		;length tracks
	bmi.b	loadtrackfin

;move.l	a4,-(a7)
;lea	readerror,a4
;move.w	#0,(a4)
;move.l	(a7)+,a4

move.w	#3,rereadcount
move.w	#0,trys

rereadloop:
bsr.w	readtrack
bsr.w	trackdecoder
	
;move.w	readerror,d7

tst.w	d2
beq.b	noreaderror

sub.w	#1,rereadcount
bne.b	rereadloop

addq.w	#1,trys
cmp.w	#4,trys
bne.b	nogiveup


	bsr.w	discerror
baddisc:
	bra.b	baddisc


nogiveup:

move.w	#10,rereadcount

bsr.b	sethead		;d2/d7 changed	;reset head, try again

	btst.b	#6,ciaapra
	beq.b loadtrackfin
	bra.b	rereadloop


noreaderror:
	lea	$1600(a0),a0
	addq.w	#1,d0		;starttrack+1=next track
	bchg	#2,(a6)
	btst.l	#0,d0		;even track?
	bne.b	readloop
	bclr.b	#1,(a6)		;CIA-B PRB, bit 1=direction signal
	bclr.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
	;move.w	#1,d7		;number of rasterlines to wait...
	;bsr.w	timewait
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, bit 0=step signal to drive
	move.w	#100,d7		;number of rasterlines to wait...
	bsr.w	timewait
	bra.b	readloop

loadtrackfin:
	btst.b	#5,$f01(a6)
	bne.b	loadtrackfin
	moveq	#100,d7
	bsr.w	timewait
	movem.l	(a7)+,d0-a6
rts

;-------
sethead:;d2/d7 changed
	bset.b	#1,(a6)		;CIA-B PRB, direction signal to drive
waitdrive:
	btst.b	#5,$f01(a6)
	bne.b	waitdrive
zeromove:
	btst.b	#4,$f01(a6)	;CIA-A PRA(bfe001), bit4=track00
	beq.b	zeromoved
	bclr.b	#0,(a6)		;CIA-B PRB, step signal
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, step signal
	moveq	#70,d7		;number of rasterlines to wait...
	bsr.w	timewait
	bra.b	zeromove
zeromoved:
	bset.b	#2,(a6)	;CIA-B PRB, bit 2=side select (choose side 0)
	move.w	d0,d2	;copy of starttrack
	lsr.w	#1,d2	;tracknumber/2=cylindernumber
	bcc.b	eventrack
	bclr.b	#2,(a6)	;CIA-B PRB, side select (choose side 1)
eventrack:
	subq.w	#1,d2
	bmi.b	rightpos
	bclr.b	#1,(a6)		;CIA-B PRB, direction signal to drive
movehead:
	bclr.b	#0,(a6)		;CIA-B PRB, step signal
	bsr.w	waitawhile
	bset.b	#0,(a6)		;CIA-B PRB, step signal
	moveq	#70,d7		;number of rasterlines to wait...
	bsr.b	timewait
	dbf	d2,movehead
rightpos:
	rts
;----------


readtrack:
	move.w	#%0111111100000000,$9e(a5)	;adkcon7 all off
	move.w	#%1000010100000000,$9e(a5)	;adkcon7, mfm+wordsync on
	move.w	#$4489,$7e(a5)			;dsksync
	move.w	#%1000001000010000,$96(a5)	;dmacon, diskdma on
waitdrive2:
	btst.b	#5,$f01(a6)	;CIA-A PRA(bfe001, disk ready
	bne.b	waitdrive2

	move.w	#$4000,$24(a5)	;dsklen
	move.l	trackbuffer(pc),$20(a5)
	move.w	#$8000+6436,d2	;dma on, 6436 words length
	move.w	d2,$24(a5)	;dsklen
	move.w	d2,$24(a5)	;dsklen
	move.w	#%0000000000000010,$9c(a5)	;intreq, clear disk-irq
diskdmawait:
	btst	#1,$1f(a5)	;intreq (lobyte)
	beq.b	diskdmawait
	move.w	#$4000,$24(a5)	;dsklen dma off
	move.w	#$400,$9e(a5)	;adkcon wordsync off
rts


;------------------------------------------------------------------------
timewait:
	movem.l	d1/d2,-(a7)
timewait0:
	move.w	$dff006,d1	;vhpos
	lsr.w	#8,d1		;d1=vertical position
timewait1:
	move.w	$dff006,d2	;vhpos
	lsr.w	#8,d2		;d2=vertical position
	cmp.w	d1,d2		;first test and last test the same line?
	beq.s	timewait1	;yep, wait...
	dbf	d7,timewait0	;wait for next line
	movem.l	(a7)+,d1/d2
	rts

waitawhile:
	movem.l	d5-d7,-(a7)
	moveq	#1,d7
waitawhileloop1:
	move.b	$dff007,d6
waitawhileloop2:
;	move.b	$dff007,d5
;	cmp.b	d5,d6
	cmp.b	$dff007,d6
	beq.b	waitawhileloop2
	dbf	d7,waitawhileloop1
	movem.l	(a7)+,d5-d7
	rts
;------------------------------------------------------------------------
LoadFromMemory:;;
	cmp.l	#DrugstoreDisc2,d2
	bne.b	LoadFromMemory_Disc1
	add.l	#160,d0
LoadFromMemory_Disc1:
;Lomem
	cmp.l	#000+DiscPos_Lomem,d0
	bne.b	NotLomem
	move.l	Main_Register+8*4(pc),a0
	lea	LoadMem_Lomem,a1
	mulu	#$1600,d1
	bra.w	LFM_Copymem

NotLomem:;Block2
	cmp.l	#000+DiscPos_Block2,d0
	bne.b	NotBlock2

	move.w	#50*5,d7
Block2sleep1:
	move.w	#0,intflag
Block2sleep2:
	tst.w	intflag
	beq.b	block2sleep2
	dbf	d7,block2sleep1


	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	lea	LoadMem_Block2,a1
	mulu	#$1600,d1
	bra.w	LFM_Copymem

NotBlock2:;Module2
	cmp.l	#000+DiscPos_Module2,d0
	bne.b	NotModule2
	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	add.l	#DiscLen_Block2*$1600,a0
	lea	LoadMem_Module2,a1
	mulu	#$1600,d1
	bra.w	LFM_Copymem

NotModule2:;Block3
	cmp.l	#160+DiscPos_Block3,d0
	bne.b	NotBlock3
	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	add.l	#DiscLen_Block2*$1600,a0
	add.l	#DiscLen_Module2*$1600,a0
	lea	LoadMem_Block3,a1
	mulu	#$1600,d1
	bra.w	LFM_Copymem


NotBlock3:;Block4
	cmp.l	#160+DiscPos_Block4,d0
	bne.b	NotBlock4
	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	add.l	#DiscLen_Block2*$1600,a0
	add.l	#DiscLen_Module2*$1600,a0
	add.l	#DiscLen_Block3*$1600,a0
	lea	LoadMem_Block4,a1
	mulu	#$1600,d1
	bra.b	LFM_Copymem

NotBlock4:;Module3
	cmp.l	#160+DiscPos_Module3,d0
	bne.b	NotModule3
	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	add.l	#DiscLen_Block2*$1600,a0
	add.l	#DiscLen_Module2*$1600,a0
	add.l	#DiscLen_Block3*$1600,a0
	add.l	#DiscLen_Block4*$1600,a0
	lea	LoadMem_Module3,a1
	mulu	#$1600,d1
	bra.b	LFM_Copymem

NotModule3:;Endpart
	cmp.l	#160+DiscPos_Endpart,d0
	bne.b	NotEndpart
	move.l	Main_Register+8*4(pc),a0
	add.l	#DiscLen_Lomem*$1600,a0
	add.l	#DiscLen_Block2*$1600,a0
	add.l	#DiscLen_Module2*$1600,a0
	add.l	#DiscLen_Block3*$1600,a0
	add.l	#DiscLen_Block4*$1600,a0
	add.l	#DiscLen_Module3*$1600,a0
	lea	LoadMem_Endpart,a1
	mulu	#$1600,d1
	bra.b	LFM_Copymem

NotEndpart:
LoadFromMemory_back:
moveq	#0,d3	;No Error
rts

LFM_Copymem:
	lsr.l	#2,d1
LFM_Copymem2:
	move.l	(a0)+,(a1)+
	subq.l	#1,d1
	bne.b	LFM_Copymem2
	bra.b	LoadFromMemory_back



ActDiscName:	dc.l	0
loadtracks:
;!!!PATCH!!!
ifeq	Onlydisc
	lea	Main_Register(pc),a6
	tst.l	(a6)
	bne.w	LoadFromMemory
endif
;!!!PATCH!!!

;searchdisc:
	move.l	d2,discname
	movem.l	d0-a6,-(a7)
searchdiscl1:
	moveq	#3,d7			;4 drivecounter
	move.w	lastdrive(pc),opendrive
searchdiscl3:


	move.w	d7,drivecountstore
	move.w	opendrive,d0
	btst.b	d0,availdrives
	beq.w	searchdiscl4	;drive not available, skip test


	lea	$bfd100,a6
	move.b	#%01111111,(a6)	;set all bits except dsk-motor
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 1

	bclr.b	d0,(a6)	;driveselect

	bset.b	#1,(a6)		;CIA-B PRB, direction to zero
	btst.b	#4,$bfe001	;head on zero-position ?
	bne.b	headnotzero
	bclr.b	#1,(a6)		;CIA-B PRB, direction from zero
headnotzero:
	bclr.b	#0,$bfd100	;step signal
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 2
	bset.b	#0,$bfd100	;step signal
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
	jsr	waitawhile	;;james 3
	btst.b	#2,$bfe001
	beq.b	searchdiscl5	;drive available, but no disc in it!

	moveq	#0,d0		;track 0
	moveq	#1,d1		;1 track

;	lea	trackloaderexc(pc),a2
;	move.l	a2,$80.w
;	trap	#0

	movem.l	d0-a6,-(a7)
	bsr.w	loadtrack
	movem.l	(a7)+,d0-a6

;	jsr	trackloader

	movem.l	(a7),d0-a6
	move.l	discname,d0
	move.l	14(a0),ActDiscName
	cmp.l	14(a0),d0
	beq.b	searchdiscl2

searchdiscl5:
move.w	opendrive,d0
lea	$bfd100,a6
move.b	#%11111111,(a6)	;set all bits except dsk-motor
;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
bsr.w	waitawhile	;;james 4
bclr.b	d0,(a6)	;bit 3=drive0select
searchdiscl4:
	addq.w	#1,opendrive
	cmp.w	#7,opendrive
	bne.b	nodrivecyclerestart

	move.w	#3,opendrive
nodrivecyclerestart:
	move.w	drivecountstore,d7
	dbf	d7,searchdiscl3	;next drive

;-------------------------
	move.l	#100,d0
flash:
	move.w	#1,intflag2
intwait2:
;	move.w	#$0500,$dff180
;	move.w	#$0,$dff180
	tst.w	intflag2
	bne.b	intwait2

	dbf	d0,flash
;--------------------
	movem.l	(a7)+,d0-a6
	moveq	#1,d3	;code for 'disc not found'
	rts
;	bra	searchdiscl1

searchdiscl2:
	move.w	opendrive,lastdrive
	movem.l	(a7)+,d0-a6
;	lea	trackloaderexc(pc),a2
;	move.l	a2,$80.w
;	trap	#0
	movem.l	d0-a6,-(a7)
	bsr.w	loadtrack
	movem.l	(a7)+,d0-a6

;	jsr	trackloader
move.w	opendrive,d0
lea	$bfd100,a6
move.b	#%11111111,(a6)	;set all bits except dsk-motor

;move.w	#1,d7		;number of rasterlines to wait...
;jsr	timewait
bsr.w	waitawhile	;;james 5
bclr.b	d0,(a6)	;bit 3=drive0select
;;alfred
bsr.w	waitawhile	;;james 6
bset.b	d0,(a6)	;bit 3=drive0select
moveq	#0,d3
	rts



;########################################################################
;------------------
track_getdrivecode:
	move.b	#%00001000,d7	;df0 always available !
	moveq	#1,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive1
	bset.l	#4,d7
skipdrive1:
	moveq	#2,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive2
	bset.l	#5,d7
skipdrive2:
	moveq	#3,d0
	jsr	drive_check
	tst.w	d1
	bne.b	skipdrive3
	bset.l	#6,d7
skipdrive3:
	lea	availdrives,a0
	move.b	d7,(a0)
	rts
;----------
;-----------
trackdecoder:;V2.3, 931016 ,code by Moon/ABYSS
movem.l	d0-a6,-(a7)
	move.l	trackbuffer(pc),a1
	moveq	#10,d7		;1 track = 11 sectors
	move.l	#$55555555,d6	;mascbits
trackdecoderl1:
	cmp.w	#$4489,(a1)+	;search syncword
	bne.b	trackdecoderl1
	cmp.w	#$4489,(a1)+	;second syncword
	beq.b	trackdecoderl2
	subq.l	#2,a1		;no second sync
	eor.l	d2,d0
trackdecoderl2:
	subq.l	#8,a1
	move.l	60(a1),d0	;data chksum:ONLY the odd bits are used
	and.l	d6,d0		;clear even

;normaly the saved mfm-checksum will be decoded, then simply compared
;with the calculated one.
;the calculated checksum is built by EORing all longwords, startvalue
;is zero.
;I use the decoded mfm-checksum as startvalue, the solution must be
;zero....nice coding, eh?

	lea	64(a1),a2	;data block adress
	moveq	#63,d5		;64*4*4=1024 mfm-bytes=512 decoded bytes
trackdecoderl3:
	movem.l	(a2)+,d1/d2/d3/d4
	eor.l	d1,d0
	eor.l	d2,d0
	eor.l	d3,d0
	eor.l	d4,d0
	dbf	d5,trackdecoderl3
	and.l	d6,d0
	bne.b	checksumbug

	move.w	10(a1),d0	;sector number and distance mfm-word1
	move.w	14(a1),d1	;sector number and distance mfm-word2
	and.w	d6,d0
	add.w	d0,d0
	and.w	d6,d1
	or.w	d1,d0		;sector number and distance decoded
	sub.b	d0,d0		;sector number (distance killed)
	add.w	d0,d0		;offset in trackblock (sectornumber*512)

	lea	(a0,d0.w),a3	;data destination
	lea	64(a1),a5	;data mfm part1
	lea	512(a5),a2	;data mfm part2

	moveq	#127,d5		;1 sector =128 decoded longwords
decodeloop:
	move.l	(a5)+,d0
	move.l	(a2)+,d1
	and.l	d6,d0
	add.l	d0,d0
	and.l	d6,d1
	or.l	d1,d0
	move.l	d0,(a3)+
	dbf	d5,decodeloop
	lea	1088(a1),a1	;64 header-bytes and 1024 databytes
	dbf	d7,trackdecoderl1	;next sector

;	lea	readerror(pc),a1	;******************************
;	move.w	#0,(a1)			;******************************

	movem.l	(a7)+,d0-a6
	moveq	#0,d2
	rts			;track checked and decoded

checksumbug:
;	lea	readerror(pc),a1	;******************************
;	addq.w	#1,(a1)			;******************************
;	addq.w	#1,allbugs		;******************************

	movem.l	(a7)+,d0-a6
	moveq	#-1,d2
	rts
;----------
drive_check:
movem.l	d0/d2-a6,-(a7)
	addq.b	#3,d0
	moveq	#0,d1
 	move.b	#%10000011,$bfd100	;motor off (all drives)
	jsr	waitawhile

 	move.b	#%01111011,$bfd100	;deselect all drives+motorbit lo
	jsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor on
	jsr	waitawhile

	move.b	#%11111011,$bfd100	;deselect all drives+motorbit hi
	jsr	waitawhile

	bclr.b	d0,$bfd100		;select drive(d0), motor off
	jsr	waitawhile

	bset.b	d0,$bfd100		;deselect drive
	jsr	waitawhile

	moveq	#1,d2
getidcode:
	bclr.b	d0,$bfd100		;select drive
	jsr	waitawhile
	move.b	$bfe001,d4		;get drive status (CIA-A)
	roxl.b	#3,d4
	roxl.b	#1,d1			;get DSKRDY-bit
	bset.b	d0,$bfd100		;deselect drive
	jsr	waitawhile

	dbf	d2,getidcode
movem.l	(a7)+,d0/d2-a6
rts



;------------------------------------------------------------------------
;---	      BYTESTRING decrunchroutine by Moon, april 1991		-
;------------------------------------------------------------------------
determ:
;a0=adress of memory to decrunch
;a1=adress of crunched data

move.l	(a1)+,d1	;crunched length
move.l	(a1)+,d2	;decrunched length
tst.b	(a1)+		;routine-code
move.b	(a1)+,d0	;codebyte

sub.l	#4+4+1+1,d1

decrunchl1:
ifne	determblink
move.w	#$0990,$dff180
endif
cmp.b	(a1)+,d0
bne.b	decrunchl2
moveq	#0,d2
move.b	(a1)+,d2
move.b	(a1)+,d3
ifne	determblink
move.w	#$0009,$dff180
endif

decrunchl4:
move.b	d3,(a0)+
dbf	d2,decrunchl4
subq.l	#3,d1
bra.b	decrunchl3

decrunchl2:
move.b	-1(a1),(a0)+
subq.l	#1,d1

decrunchl3:
bne.b	decrunchl1

ifne	determblink
move.l	#0,$dff180
endif
rts



;------------------------------------------------------------------------
;-                               RELOCATOR 2                            -
;-                              -------------                           -
;-                                                                      -
;- Support:                                                             -
;-  Hunk code (chip/fast/public)                                        -
;-  Hunk reloc 32                                                       -
;-  Hunk data                                                           -
;-  Hunk bss                                                            -
;-                                                                      -
;-                                                                      -
;- Usage:                                                               -
;-   lea	program,a0	;adress of reloc-file                           -
;-   lea	chip,a1		;free chipmemory                                -
;-   lea	fast,a2		;free fastmemory                                -
;-   jsr	relocator                                                   -
;-   tst	d0		;error ?                                            -
;-   bne	error                                                       -
;-   jmp	chip/fast	;position of first code segment                 -
;-                                                                      -
;-  its your turn to make sure that both memoryblocks (chip/fast)       -
;-  are big enough!                                                     -
;-  if you want to force all to chipmem, set a2 to zero: sub.l	a2,a2	-
;-                                                                      -
;-                                                                      -
;-                                                                      -
;- code by Moon/ABYSS                                          May 1994 -
;------------------------------------------------------------------------
relocator2:
movem.l	d0-a6,-(a7)
	move.l	a1,memorypoint_chip
	move.l	a2,memorypoint_fast
	move.w	#0,hunk_work

	cmp.l	#$000003f3,(a0)+	;hunk header
	bne.w	bug2			;not executable or file damaged

	cmp.l	#0,(a0)+		;hunkname
	bne.w	bug2			;bug if there's a hunkname
					;(not supported yet)


	move.l	(a0)+,hunk_quant	;number of hunks
	move.l	(a0)+,hunk_first	;first hunknumber
	move.l	(a0)+,hunk_last		;last hunknumber

	move.l	hunk_quant,d7		;number of hunks
	subq.w	#1,d7
	move.l	a2,d6			;fastmem to test if valid
	move.l	a1,d5			;test if hunktable valid
	bne.b	reloc_nohunktab

	moveq	#0,d6
reloc_nohunktab:

	lea	hunk_lengths(pc),a1	;memory for hunk-lengths
reloc_copylengths:
	move.l	(a0)+,d0		;next hunk length
	tst.l	d6
	beq.b	reloc_takechip		;no fastmem=force all to chipmem
	btst.l	#30,d0			;chipmem?
	bne.b	reloc_takechip
;	btst.l	#31,d0			;fastmem or public->take fast
;	bne	reloc_takefast
reloc_takepublic:
reloc_takefast:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length
	move.l	memorypoint_fast,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_fast
	bra.b	reloc_memorytaken

reloc_takechip:
	lsl.l	#2,d0
	move.l	d0,(a1)+		;store length

	tst.l	d5
	beq.b	reloc_gethunktable

	move.l	memorypoint_chip,d1
	move.l	d1,(a1)+		;store startadress
	add.l	d0,d1
	move.l	d1,memorypoint_chip
	bra.b	reloc_memorytaken

reloc_gethunktable:
	move.l	memorypoint_fast,a3
	move.l	(a3)+,(a1)+		;store startadress
	move.l	a3,memorypoint_fast

reloc_memorytaken:
	dbf	d7,reloc_copylengths
	lea	hunk_lengths(pc),a1	;memory for hunk-lengths

;-------------------------

reloc_mainloop:
	move.l	(a0)+,d0		;new hunk
	cmp.l	#$000003e9,d0		;hunk code ?
	beq.b	hunk_code

	cmp.l	#$000003ec,d0		;hunk reloc 32 ?
	beq.b	hunk_reloc32

	cmp.l	#$000003ea,d0		;hunk data ?
	beq.b	hunk_data

	cmp.l	#$000003eb,d0		;hunk bss ?
	beq.b	hunk_bss

	cmp.l	#$000003f2,d0		;hunk end ?
	beq.b	hunk_end

bug2:
;	move.w	#$0f00,$dff180
;	move.w	#$0ff0,$dff180
;	btst	#6,$bfe001
;	bne	bug2
	moveq	#-1,d0
	move.l	d7,bugcode
	movem.l	(a7)+,d0-a6
	rts
depp:	dc.w	0
;------------------------------------------------------------------------
;---------
hunk_code:
	move.l	(a0)+,d7		;hunk code length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_code_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
	bne.b	hunk_code_copy
	bra.b	reloc_mainloop
;-----------------------------
hunk_reloc32:
	move.l	(a0)+,d7		;hunk reloc 32 offsets length
	beq.b	reloc_mainloop
	move.l	(a0)+,d6		;hunknumber of offsets
	lsl.w	#3,d6
	move.l	4(a1,d6.w),d1		;hunkadress of offsets
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_reloc32_loop:
	move.l	(a0)+,d2		;next offset
	add.l	d1,(a2,d2.l)		;add hunk startadress
	subq.l	#1,d7
	bne.b	hunk_reloc32_loop
	bra.b	hunk_reloc32
;---------------------------------
hunk_data:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.b	reloc_mainloop		;length 0 is possible...
	move.w	hunk_work,d6		;number of this hunk
	lsl.w	#3,d6
	move.l	4(a1,d6.w),a2		;hunk adress
hunk_data_copy:
	move.l	(a0)+,(a2)+
	subq.l	#1,d7
furz:
	bne.b	hunk_data_copy
	bra.w	reloc_mainloop

;-----------------------------
hunk_bss:
	move.l	(a0)+,d7		;hunk data length (longwords)
	beq.w	reloc_mainloop		;length 0 is possible...
	bra.w	reloc_mainloop
;-----------------------------
hunk_end:
	addq.w	#1,hunk_work
	subq.l	#1,hunk_quant
	bne.w	reloc_mainloop
	movem.l	(a7)+,d0-a6
	moveq	#0,d0			;no bug
	rts				;;finished
;----------


hunk_maximum=100
hunk_quant:	dc.l	0
hunk_first:	dc.l	0
hunk_last:	dc.l	0
hunk_lengths:	dcb.l	hunk_maximum*2,0

hunk_work:	dc.w	0

memorypoint_chip:	dc.l	0
memorypoint_fast:	dc.l	0



bugcode:	dc.l	0

drivecountstore:	dc.w	0
lastdrive:	dc.w	3
trys:		dc.w	0
rereadcount:	dc.w	0
trackbuffer:	dc.l	0
availdrives:	dc.b	0
even
opendrive:	dc.w	0


;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------



discname:	dc.l	0



Discerrorcode:	incbin	"/code/Error.term"
ifne	music
player:	incbin	"data/player60.code"
P60_init=player+40
P60_music=player+738
P60_end=player+626
P60_master=player+16

b:


codec_e:

;------------------------------------------------------------------------
ifne	UseSection
section	BSSC,bss_c
endif
bssc_s:

chipmemory:
Chip_Memory:
	ds.b	446000
Chip_Memoryend:
bssc_e:
;------------------------------------------------------------------------
ifne	UseSection
section	BSSP,bss_p
endif
bssp_s:

fastmemory:
Fast_Memory:
	ds.b	466000
Fast_Memoryend:
bssp_e:



PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
Printblock=0
include	"/include/DiscPosLen.i"
;----------
;Disc names
DrugstoreDisc1="drg1"
DiscNam_LoMem=DrugstoreDisc1
DiscNam_PDNote=DrugstoreDisc1
DiscNam_Module1=DrugstoreDisc1
DiscNam_Jaul=DrugstoreDisc1
DiscNam_Drugstore=DrugstoreDisc1
DiscNam_Abyss=DrugstoreDisc1
DiscNam_Dotpic=DrugstoreDisc1
DiscNam_Sinedots=DrugstoreDisc1
DiscNam_Dialog1=DrugstoreDisc1
DiscNam_Colvec=DrugstoreDisc1
DiscNam_Dialog2=DrugstoreDisc1
DiscNam_SCScroll=DrugstoreDisc1
DiscNam_Dialog3=DrugstoreDisc1
DiscNam_Glasvec=DrugstoreDisc1
DiscNam_Insdisc2=DrugstoreDisc1
DiscNam_James=DrugstoreDisc1
DiscNam_Module2=DrugstoreDisc1
;-------------------------------
DrugstoreDisc2="drg2"
DiscNam_Starscroll=DrugstoreDisc1
DiscNam_RGB=DrugstoreDisc1
DiscNam_Cloud=DrugstoreDisc1
;-------------------------------
printt	"---------------"
printt	"DiscPos_Pdnote:"
printv	DiscPos_Pdnote
printt	"DiscLen_Pdnote:"
printv	DiscLen_Pdnote
printt	"---------------"


;-----
LoadMem_LoMem=Fast_Memory
TermMem_LoMem=Chip_Memory
DiscBuf_LoMem=Chip_Memory
;----------------------------
LoadMem_PDNote=Fast_Memory
TermMem_PDNote=Chip_Memory+12000
DiscBuf_PDNote=Chip_Memoryend-100000
;----------------------------
Loadmem_Block1:	set	Fast_Memoryend-338000	;#1#
DiscBuf_Block1=Chip_Memoryend-100000

DiscNam_Block1=DrugstoreDisc1
;----------------------------
printt	"---------------"
printt	"DiscPos_Block1:"
printv	DiscPos_Block1
printt	"DiscLen_Block1:"
printv	DiscLen_Block1
printt	"Distance Block1 to Fast_Memory:"
printv	LoadMem_Block1-Fast_Memory
printt	"---------------"


;-------------------------------
;#m1#
Loadmem_Module1=Loadmem_Block1
TermMem_Module1=Chip_Memoryend-144000	;#2#  	look to #3# when changing
;----------
LoadMem_Jaul=Loadmem_Module1+($1600*DiscLen_Module1)
TermMem_Jaul=Chip_Memory+12000+152000
;----------
LoadMem_Drugstore=Loadmem_Jaul+($1600*DiscLen_Jaul)
TermMem_Drugstore=Chip_Memory+12000+152000+8000
;----------
LoadMem_Abyss=Loadmem_Drugstore+($1600*DiscLen_Drugstore)
TermMem_Abyss=Chip_Memory+12000
;----------
LoadMem_Dotpic=LoadMem_Abyss+($1600*DiscLen_Abyss)
TermMemCF_Dotpic=Fast_Memory
TermMemCC_Dotpic=Chip_Memory
TermMemBC_Dotpic=TermMem_Abyss+10000	;10000=memneed abyss when waiting
TermMemBF_Dotpic=Fast_Memory+26000
;----------
LoadMem_Sinedots=LoadMem_Dotpic+($1600*DiscLen_Dotpic)
CopyMem_Sinedots=Chip_memoryend-144000-29000	;#3#
TermMem_Sinedots=chip_memory
;----------
LoadMem_Dialog1=LoadMem_Sinedots+($1600*DiscLen_Sinedots)
TermMem_Dialog1=chip_memory
;-----------------



;----------------------------
LoadMem_Block2=Fast_Memory
DiscBuf_Block2=Chip_Memory+250000
DiscNam_Block2=DrugstoreDisc1
;----------------------------
printt	"---------------"
printt	"DiscPos_Block2:"
printv	DiscPos_Block2
printt	"DiscLen_Block2:"
printv	DiscLen_Block2
printt	"Distance Block2 to Fast_Memory_End:"
printv	Fast_Memoryend-($1600*DiscLen_Block2)
printt	"---------------"




LoadMem_Colvec=LoadMem_Block2
TermMem_Colvec=chip_memory
;-----------------
LoadMem_Dialog2=LoadMem_Colvec+($1600*DiscLen_Colvec)
TermMem_Dialog2=chip_memory
;-----------------
LoadMem_SCScroll=LoadMem_Dialog2+($1600*DiscLen_Dialog2)
TermMem_SCScroll=chip_memory
;-----------------
LoadMem_Dialog3=LoadMem_SCScroll+($1600*DiscLen_SCScroll)
TermMem_Dialog3=chip_memory
;-----------------
LoadMem_Glasvec=LoadMem_Dialog3+($1600*DiscLen_Dialog3)
TermMem_Glasvec=chip_memory
;-----------------
LoadMem_InsDisc2=LoadMem_Glasvec+($1600*DiscLen_Glasvec)
TermMem_InsDisc2=chip_memory+110000-49152	;110000=memusage_c james
;-----------------
LoadMem_James=LoadMem_InsDisc2+($1600*DiscLen_Insdisc2)
TermMem_James=chip_memory
;-----------------
;-----------------



;-----


;---------------------------------------


LoadMem_Module2=Fast_Memory
TermMem_Module2=Chip_Memoryend-95000	;#7#
DiscBuf_Module2=Chip_Memoryend-50000-144000	;(module1)

;----------------------------
;----------------------------
LoadMem_Block3=Fast_Memoryend-203000;  #4#
DiscBuf_Block3=Chip_Memoryend-50000-144000	;(module1)
DiscNam_Block3=DrugstoreDisc2
;----------------------------
printt	"---------------"
printt	"DiscPos_Block3:"
printv	DiscPos_Block3
printt	"DiscLen_Block3:"
printv	DiscLen_Block3
printt	"Size Block3:"
printv	($1600*DiscLen_Block3)
printt	"---------------"

;----------------------------
;----------------------------
LoadMem_Block4=Fast_Memoryend-96000; #5#
DiscBuf_Block4=Chip_Memory+240000	;position IN clown!!
DiscNam_Block4=DrugstoreDisc2
;----------------------------
printt	"---------------"
printt	"DiscPos_Block4:"
printv	DiscPos_Block4
printt	"DiscLen_Block4:"
printv	DiscLen_Block4
printt	"Size Block4:"
printv	($1600*DiscLen_Block4)
printt	"---------------"




LoadMem_Starscroll=LoadMem_Block3
TermMem_Starscroll=chip_memory
;-----------------
LoadMem_RGB=LoadMem_Starscroll+($1600*DiscLen_Starscroll)
TermMemC_RGB=chip_memory+152000;	=chipmemusage star
TermMemF_RGB=fast_memory
;important notes:
;RGB determ to fastmem coz relocfile is bigger than chiphunk!
;RGB chip=chip+160000 ;160000= memusage STAR
;    fast=fast, to fast+350000(RGB fastusage
;-----------------
LoadMem_Cloud=LoadMem_RGB+($1600*DiscLen_RGB)
;CopyMem_Cloud=TermMemC_RGB+165000	;(165000=chipusage RGB)
TermMem_Cloud=chip_memory+55000
;-----------------
LoadMem_Spiral=LoadMem_Cloud+($1600*DiscLen_Cloud)
TermMemC_Spiral=chip_memory
TermMemF_Spiral=fast_memory
;-----------------
LoadMem_Text1=LoadMem_Spiral+($1600*DiscLen_Spiral)
CopyMem_Text1=chip_memory+310000	;(+ memusage chip clown)
TermMem_Text1=chip_memory+320000	;(+ memusage chip clown)
;-----------------
LoadMem_Clown=LoadMem_Text1+($1600*DiscLen_Text1)
CopyMem_Clown=chip_memory+210000	;+chipmemusage spiral
TermMemC_Clown=chip_memory
TermMemF_Clown=fast_memory
;-----------------
LoadMem_Child=LoadMem_Block4
TermMem_Child=chip_memory+285000-110000	;(+cmemusage_mont-bbsc_mont)
;-----------------
LoadMem_Text2=LoadMem_Child+($1600*DiscLen_Child)
TermMem_Text2=chip_memory+290000
;-----------------
LoadMem_Mont=LoadMem_Text2+($1600*DiscLen_Text2)
TermMemC_Mont=chip_memory
TermMemF_Mont=fast_memory
;-----------------
LoadMem_Text3=LoadMem_Mont+($1600*DiscLen_Mont)
TermMem_Text3=chip_memory
;-----------------

;#m3#
LoadMem_Module3=Fast_Memory
TermMem_Module3=Chip_Memoryend-175000	;#6#
DiscNam_Module3=DrugstoreDisc2
DiscBuf_Module3=Chip_Memory+100000

LoadMem_Endpart=Fast_Memory+320000
TermMemC_Endpart=Chip_Memory+11000
TermMemF_Endpart=Fast_Memory
DiscNam_Endpart=DrugstoreDisc2
DiscBuf_Endpart=Chip_Memory+100000

;-----------------
;LoadMem_=LoadMem_+($1600*DiscLen_)
;TermMem_=chip_memory
;-----------------
;-----------------


	







ifne	UseSection
;section	DataC,data_c
endif
datac_s:
datac_e:


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

ifne	Printmem
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
endif

ifne	onlydisc
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
printt	"!!!             DANGER             !!!"
printt	"!!! Harddisc-support code disabled !!!"
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
endif
