;!!!
; NOTE: after drugstore, recode the initcall-handling to enable
; multiple init-calls, now-to avoid incompatiblity- its just a switch
; to call twice or not
;!!!
test=0
ifne	test
showtime=0
program_id=1
Main_Enable_Jp60music=1
Main_Enable_SetIntflag=1
Main_Enable_JCommander=1
Main_Enable_Exit=1
main_init:
main_program:
main_Back:
commands:
p60_music:
main_initcall2=0
endif
;------------------------------------------------------------------------
;|									|
;|			    MAIN INIT ROUTINE				|
;|									|
;|									|
;|									|
;| code by Moon/ABYSS							|
;------------------------------------------------------------------------
;talk message syntax:
;$ xxxx yy zz
;  xxxx :not sed yet
;    yy :message
;    zz :program id


;used talk messages:
;$00 	:	endcode-->exit               	program-->maininit

Main_Status=1
;changes:
;941122: changed position of jsr Main_Back, now before vector restoring
;        (because diznee land calls p60_end in Main_Back, this caused
;        a system-crash when using damned CIA-replayer

;941127: exit on talk command
;        bra main_startcli disabled

;941128: EXT IR enabled on Main_Back to avoid system-hang-on on nonAGA

;941203: bra main_startcli enabled

;941209: Main_Initcall2, calling Main_Init twice enabled
;        source is reporting the missing constants

ifnd	Main_InitCall2
printt	"Message from Maininit:     Main_InitCall2=  is missing!!!"
end
endif

ifnd	Showtime
printt	"Message from Maininit:     Showtime=  is missing!!!"
end
endif

;ifnd	Main_Init
;printt	"Message from Maininit:     Main_Init:  is missing!!!"
;end
;endif

;ifnd	Main_Program
;printt	"Message from Maininit:     Main_Program:  is missing!!!"
;end
;endif

;ifnd	Main_Back
;printt	"Message from Maininit:     Main_Back:  is missing!!!"
;end
;endif

ifnd	Program_ID
printt	"Message from Maininit:     Program_ID=  is missing!!!"
end
endif

ifnd	Main_Enable_Jp60music
printt	"Message from Maininit:     Main_Enable_Jp60music=  is missing!!!"
end
endif

ifnd	Main_Enable_SetIntflag
printt	"Message from Maininit:     Main_Enable_SetIntflag=  is missing!!!"
end
endif

ifnd	Main_Enable_JCommander
printt	"Message from Maininit:     Main_Enable_JCommander=  is missing!!!"
end
endif
;ifnd	Commands
;printt	"Message from Maininit:     Commands:  is missing!!!"
;end
;endif

ifnd	Main_Enable_Exit
printt	"Message from Maininit:     Main_Enable_Exit=  is missing!!!"
end
endif

ifeq	Main_Enable_Exit
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
printt	"!!! TAKE CARE, left mouse-exit disabled !!!"
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
endif

AttnFlags=296	;struct ExecBase
ThisTask=276	;struct ExecBase
Copinit=38	;struct GfxBase

mainplanesize=40*256	;40*256*7r
forbid=-132
permit=-138
ciaapra=$bfe001
dmacon=$96
intena=$09a
intenar=$01c
OpenLibrary=-552
CloseLibrary=-414
FindTask=-294
GetMsg=-372
ReplyMsg=-378
WaitPort=-384
joy0dat=$00a
vposr=$004
loadview=-222
waittof=-270
actiview=34
LVO_Supervisor=-30

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

;--------
	jmp	Main_Start
	jmp	Main_Init
	jmp	Main_Program
	jmp	Main_Back

Main_Start:
	move.l	a6,-(a7)
	lea	Main_Register(pc),a6
	movem.l	d0-a5,(a6)
	move.l	(a7)+,14*4(a6)
	move.l	a7,15*4(a6)

	move.l	4.w,a6
	move.w	AttnFlags(a6),d0
	btst.l	#0,d0
	beq	Main_Vectorsokay
	lea	Main_GetVBR(pc),a5
	jsr	LVO_Supervisor(a6)
	bra	Main_Vectorsokay

Main_GetVBR:
	move.l	d0,-(a7)
	dc.l	$4e7a0801
	move.l	d0,Main_VBR
	dc.l	$4e7a0002
	bclr	#0,d0
	bclr	#4,d0
	bclr	#8,d0
	bclr	#12,d0
	dc.l	$4e7b0002
	move.l	(a7)+,d0
	rte

Main_Vectorsokay:
	move.l	4.w,a6
	lea	Main_GraphicsName(pc),a1
	moveq	#0,d0
	jsr	OpenLibrary(a6)
	move.l	d0,Main_GraphicsBase
	move.l	d0,a6
	move.l	ActiView(a6),Main_OldView
	sub.l	a1,a1	
	jsr	Loadview(a6)
	jsr	WaitTOF(a6)
	jsr	WaitTOF(a6)
bra	Main_StartCLI	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	move.l	4.w,a6
	move.l	ThisTask(a6),a4
	tst.l	$ac(a4)
	bne	Main_StartCLI
	lea	$5c(a4),a0
	jsr	WaitPort(a6)
	lea	$5c(a4),a0
	jsr	GetMSG(a6)
	move.l	d0,Main_Message

Main_StartCLI:
	move.l	4.w,a6
	jsr	Forbid(a6)

	lea	$dff000,a5
	move.w	#%0000001111100000,dmacon(a5)
	move.w	intenar(a5),Main_OldIntena
	move.w	#%0111111111111111,intena(a5)	;BLT,VBI,,CIA
	move.l	Main_VBR(pc),a0
	move.l	$6c(a0),Main_OldVBIVector
	move.l	$78(a0),Main_OldExIVector
	move.l	#Main_VBI,$6c(a0)
	lea	Main_EmptyCopperlist(pc),a1
	move.l	a1,Cop1lch(a5)
	move.w	#0,Copjmp1(a5)

	moveq	#0,d0
	move.l	d0,spr0data(a5)
	move.l	d0,spr1data(a5)
	move.l	d0,spr2data(a5)
	move.l	d0,spr3data(a5)
	move.l	d0,spr4data(a5)
	move.l	d0,spr5data(a5)
	move.l	d0,spr6data(a5)
	move.l	d0,spr7data(a5)
	move.w	d0,spr0pos(a5)
	move.w	d0,spr1pos(a5)
	move.w	d0,spr2pos(a5)
	move.w	d0,spr3pos(a5)
	move.w	d0,spr4pos(a5)
	move.w	d0,spr5pos(a5)
	move.w	d0,spr6pos(a5)
	move.w	d0,spr7pos(a5)

	move.w	#%0000001000000000,Bplcon0(a5)
	move.w	#%1100000000100000,Intena(a5)

;	move.w	#0,$106(a5)

;---
	move.w	#0,$1fc(a5)
	move.w	#%0000000000000000,$102(a5)	;bplcon1
	move.w	#%0000000000000000,$104(a5)	;bplcon2
	move.w	#%0000110000000000,$106(a5)	;bplcon3
;	move.w	#%0000000011110000,$10c(a5)	;bplcon4
	move.w	#%0000000000010001,$10c(a5)	;bplcon4
;---

	move.w	#%1000001111000000,dmacon(a5)

 	lea	Main_FakeVBI(pc),a0
	lea	Main_FakeCopperList(pc),a1
	lea	Main_FakeTalk(pc),a2
	bsr	Main_Init
ifne	Main_InitCall2
	bsr	Main_Init
endif
	bsr	Main_Program
Main_Wait:
	move.w	#Program_ID,d0
	lsl.w	#8,d0
	move.l	Main_Talk(pc),a0
	cmp.w	2(a0),d0
	beq	Main_Exit

;bra	Main_Exit	;!!!!!!!!!!!;;;;;;;;;;;;;
ifne	Main_Enable_Exit
	btst.b	#6,ciaapra
	beq	Main_Exit
endif
	bra	Main_Wait

Main_Exit:
	bsr	Main_Back	;;;;;;;;;;;;;

	move.l	Main_VBR(pc),a0
	move.l	Main_OldVBIVector(pc),$6c(a0)
	move.l	Main_OldExIVector(pc),$78(a0)
;	bsr	Main_Back	;;;;;;;;;;;;;
	move.l	4.w,a6
	move.l	Main_GraphicsBase(pc),a1
	lea	$dff000,a5
	move.l	Copinit(a1),Cop1lch(a5)
	move.w	#0,Copjmp1(a5)
	jsr	CloseLibrary(a6)

	lea	$dff000,a5
	move.w	#%0111111111111111,intena(a5)	;BLT,VBI,,CIA
	move.w	Main_OldIntena(pc),d0
	bset	#15,d0
	move.w	d0,Intena(a5)	;BLT,VBI,,CIA
	move.w	#%1000001111100000,Dmacon(a5)

	move.l	Main_GraphicsBase(pc),a6
	move.l	Main_Oldview(pc),a1
	jsr	LoadView(a6)

	move.l	4.w,a6
	jsr	Permit(a6)
	move.l	Main_Message(pc),d0
	beq	Main_NoReply
	move.l	d0,a1
	jsr	ReplyMsg(a6)
Main_Noreply:
	moveq	#0,d0
	rts

;--------------------------------------------------------
;--------------------------------------------------------
Main_Message:		dc.l	0
Main_VBR:		dc.l	0
Main_GraphicsBase:	dc.l	0
Main_OldView:		dc.l	0
Main_OldVBIVector:	dc.l	0
Main_OldExIVector:	dc.l	0
Main_VBIVector:		dc.l	0
Main_Copperlist:	dc.l	0
Main_Talk:		dc.l	0
Main_FakeVBI:		dc.l	0
Main_FakeCopperlist:	dc.l	Main_EmptyCopperlist
Main_FakeTalk:		dc.l	0
Main_OldIntena:		dc.w	0
Main_GraphicsName:	dc.b	"graphics.library",0,0

Main_EmptyCopperlist:	dc.l	-2

maincommand:		dc.l	-1

Main_Register:		dcb.l	16,0
;----------------------------------------------------------------
Main_VBI:
	btst.b	#5,$dff01f
	beq	main_vbiback
	movem.l	d0-a6,-(a7)

	lea	$dff000,a5
	move.l	Main_VBIVector(pc),a0
	tst.l	(a0)
	beq	Main_NoNewVBI
	move.l	(a0),a0
	jsr	(a0)
Main_NoNewVBI:
	move.l	Main_Copperlist(pc),a0
	tst.l	(a0)
	beq	Main_NoCopperlist
	bpl	Main_NoEmptyCopperlist
	lea	Main_EmptyCopperlist(pc),a1
	move.l	a1,Cop1lch(a5)
	clr.l	(a0)
	bra	Main_NoCopperlist
Main_NoEmptyCopperlist:
	move.l	(a0),Cop1lch(a5)
	clr.l	(a0)
Main_NoCopperlist:

ifne	Main_Enable_Jp60music
	tst.w	f_skipmusic
	bne	skip_music
	move.l	a5,a6
	jsr	P60_Music
	lea	$dff000,a5
skip_music:
endif

ifne	Main_Enable_SetIntflag
	move.w	#1,intflag
	move.w	#0,intflag2
endif

ifne	Main_Enable_JCommander
	bsr	Commander
endif

ifne	showtime
	move.w	#$0fff,$180(a5)
endif
	movem.l	(a7)+,d0-a6
ifne	showtime
	move.w	#$0000,$dff180
endif
main_vbiback:
	move.w	#%0000000001100000,$dff09c
	rte

;------------------------------------------------------------------------
f_skipmusic:	dc.w	1
intflag:	dc.w	0
intflag2:	dc.w	0
;------------------------------------------------------------------------
Commander:
	lea	Commander_Sleep(pc),a0
	subq.w	#1,(a0)+
	beq.b	Commander_NewCommand
	rts
Commander_NewCommand:
	move.w	(a0),d0
	addq.w	#8,(a0)
	lea	Commands+2(pc),a1
	add.w	d0,a1
	move.w	(a1)+,-(a0)
	move.l	(a1)+,a0
	jmp	(a0)
Commander_Sleep:	dc.w	1	;|
Commander_Point:	dc.w	0	;|
;------------------------------------------------------------------------


