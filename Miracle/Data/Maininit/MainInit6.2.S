;EXIT-possibilities changed, no-exit was not possible
;------------------------------------------------------------------------
;|                                                                      |
;|                          MAIN INIT ROUTINE V6.2                      |
;|                         ------------------------                     |
;|                                                                      |
;| Purpose:                                                             |
;|         -Standard startup-code-stuff					|
;|         -Easy timing/handling of any	'actions' in one program	|
;|         -Easy handling of more subprograms (slaves) from		|
;|           one mainprogram (master)					|
;|           Each program may be coded and tested as			|
;|           'stand-alone'-executable and then connected		|
;|           to a 'project' without any recoding/reassembling		|
;|                                                                      |
;|                                                                      |
;| code by Moon/ABYSS                            last update: July 1995 |
;------------------------------------------------------------------------
;Main_ShowParameter=0
;Main_Status=0


;------------------------------------------------------------------------
ifd	Main_ShowParameter
include	"data/maininit/data/MainInit6.ParLst.i"
endif
;------------------------------------------------------------------------

test=0
ifne	test
main_init:
main_program:
main_Back:
commands:
endif



;------------------------------------------------------------------------
if2
ifnd	Main_Init
printt	"ERROR:   Main_Init:  is missing!!!"
end
endif

ifnd	Main_Program
printt	"ERROR:   Main_Program:  is missing!!!"
end
endif

ifnd	Main_Back
printt	"ERROR:   Main_Back:  is missing!!!"
end
endif

ifne	Main_CallCommander
ifnd	Commands
printt	"ERROR:   Main_CallCommander enabled, but no commandslist found"
end
endif
endif

endif


ifnd	Main_InitCall
Main_InitCall=1
endif

ifnd	Main_SkipWBStartTest
Main_SkipWBStartTest=0
endif

ifnd	Main_ProgramID
Main_ProgramID=1
endif

if	Main_ProgramID>127
printt	"ERROR:   Program_ID wrong size   -->  0<=Program_ID<=127"
endif
if	0>Main_ProgramID
printt	"ERROR:   Program_ID wrong size   -->  0<=Program_ID<=127"
endif

ifnd	Main_CallCommander
Main_CallCommander=0
endif


ifnd	Main_Cache
Main_Cache=0
endif

ifnd	Main_ExitLMB
Main_ExitLMB=1
endif

ifnd	Main_ExitRMB
Main_ExitRMB=0
endif

ifnd	Main_ExitJB
Main_ExitJB=0
endif

ifnd	Main_Joyhold
Main_Joyhold=0
endif

ifnd	Main_ShowTime
Main_ShowTime=0
endif


ifd	Main_Status
ifne	Main_Status
printt	"Main_SkipWBStartTest:"
printv	Main_SkipWBStartTest
printt	"Main_InitCall:"
printv	Main_InitCall
printt	"Main_Showtime:"
printv	Main_Showtime
printt	"Main_ProgramID:"
printv	Main_ProgramID
printt	"Main_Cache:"
printv	Main_Cache
printt	"Main_CallCommander:"
printv	Main_CallCommander
printt	"Main_ExitLMB:"
printv	Main_ExitLMB
printt	"Main_ExitRMB:"
printv	Main_ExitRMB
printt	"Main_ExitJB:"
printv	Main_ExitJB
printt	"Main_Joyhold:"
printv	Main_Joyhold
endif
endif

if	Main_ExitLMB+Main_ExitRMB+Main_ExitJB=0
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
printt	"!!!         TAKE CARE, EXIT DISABLED        !!!"
printt	"!!!   user may not interrupt this program   !!!"
printt	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
endif
;------------------------------------------------------------------------




AttnFlags=296	;struct ExecBase
ThisTask=276	;struct ExecBase
Copinit=38	;struct GfxBase

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

;------------------------------------------------------------------------
	jmp	Main_Start
	jmp	Main_Init
	jmp	Main_Program
	jmp	Main_Back
;---------------------------
Main_Start:
	move.l	a6,-(a7)		;saving d0-a6 in a list...
	lea	Main_Register(pc),a6	;...they could be parameter...
	movem.l	d0-a5,(a6)		;...when program started with...
	move.l	(a7)+,14*4(a6)		;...Main_Start from a Master!
	move.l	a7,15*4(a6)

	move.l	4.w,a6
	move.w	AttnFlags(a6),d0
	btst.l	#0,d0			;MC68000 ?
	beq	Main_VBRokay		;yep-->there's no VBR-register
	lea	Main_GetVBR(pc),a5	;code to get VBR is privileged...
	jsr	LVO_Supervisor(a6)	;...so do it from supervisor
	bra	Main_VBRokay

;Cache of MC68020:
;256 byte, 64 entrys (32 bit)
;CACR of MC68020:
;bit 0 = E   (enable)
;bit 1 = F   (freeze)
;bit 2 = CE  (clear entry)
;bit 3 = C   (clear)

;Cache of MC68030:
;256 byte, 16 entrys (128 bit)
;CACR of MC68030:
;bit  0 = EI   (enable instruction)
;bit  1 = FI   (freeze instruction)
;bit  2 = CEI  (clear entry instruction)
;bit  3 = CI   (clead instruction)
;bit  4 = IBE  (instruction burst enable)

;bit  8 = ED   (enable data)
;bit  7 = FD   (freeze data)
;bit 10 = CED  (clear entry data)
;bit 11 = CD   (clear data)
;bit 12 = DBE  (data burst enable)
;bit 13 = WA   (write allocation)

Main_GetVBR:
	move.l	d0,-(a7)
	dc.l	$4e7a0801		;movec	VBR,d0
	move.l	d0,Main_VBR
	dc.l	$4e7a0002		;movec	CACR,d0
ifeq	Main_Cache
	bclr	#0,d0			;disable instruction cache
	bclr	#8,d0			;disable data cache
else
	bset	#0,d0			;enable instruction cache
	bclr	#8,d0			;enable data cache
endif
	bclr	#4,d0			;disable instruction burst
	bclr	#12,d0			;disable data burst
	dc.l	$4e7b0002		;movec	d0,CACR
	move.l	(a7)+,d0
	rte

Main_VBRokay:
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

ifeq	Main_SkipWBStartTest
	move.l	4.w,a6
	move.l	ThisTask(a6),a4
	tst.l	$ac(a4)
	bne	Main_StartCLI
	lea	$5c(a4),a0
	jsr	WaitPort(a6)
	lea	$5c(a4),a0
	jsr	GetMSG(a6)
	move.l	d0,Main_Message
endif

Main_StartCLI:
	move.l	4.w,a6
	jsr	Forbid(a6)

	lea	$dff000,a5
	move.w	intenar(a5),Main_OldIntena
	move.w	#%0111111111111111,intena(a5)
	move.w	#%0000011111100000,dmacon(a5)	;blt/cop/bpl/dma/bltpri
	move.l	Main_VBR(pc),a0
	move.l	$6c(a0),Main_OldVBIVector
	move.l	$78(a0),Main_OldExIVector
	move.l	#Main_VBI,$6c(a0)

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

	move.w	#%0000001000000000,bplcon0(a5)
	move.w	#%1100000000100000,intena(a5)	;intena/vbl

;---
	move.w	#0,$1fc(a5)
	move.w	#%0000000000000000,$102(a5)	;bplcon1
	move.w	#%0000000000000000,$104(a5)	;bplcon2
	move.w	#%0000110000000000,$106(a5)	;bplcon3, pf2of1/pf2of2
	move.w	#%0000000000010001,$10c(a5)	;bplcon4, esprm4/osprm4
;---

;	move.w	#%1000001111000000,dmacon(a5)	;dma/bpl

 	lea	Main_FakeVBI(pc),a0
	lea	Main_FakeCopperList(pc),a1
	lea	Main_FakeTalk(pc),a2
	lea	Main_FakeMasterCommand(pc),a3

if Main_InitCall>1
rept	Main_InitCall
	bsr	Main_Init
endr
else
	bsr	Main_Init
endif


ifne	Main_Joyhold
Main_Joyholdsleep:
	btst.b	#7,ciaapra
	beq	Main_Joyholdsleep
endif
	bsr	Main_Program

Main_Loop:
	moveq	#Main_ProgramID,d0
	ror.l	#8,d0
	subq.w	#1,d0
	move.l	Main_Talk(pc),a0
	cmp.l	(a0),d0
	beq	Main_Exit

	move.l	Main_MasterCommand(pc),a0
	move.l	(a0),d0		;first priority master command
	clr.l	(a0)+
	tst.l	d0
	bne	Main_ExecuteMC

	move.l	(a0),d0		;second priority master command
	beq	Main_NoMasterCommand

Main_ExecuteMC:
	move.l	d0,a0
	jsr	(a0)

Main_NoMasterCommand:

ifne	Main_ExitLMB
	btst.b	#6,ciaapra
	beq	Main_Exit
endif
ifne	Main_ExitRMB
	btst.b	#10,$16(a5)
	beq	Main_Exit
endif
ifne	Main_ExitJB
	btst.b	#7,ciaapra
	beq	Main_Exit
endif

	bra	Main_Loop
Main_Exit:
	bsr	Main_Back

	lea	$dff000,a5
	move.w	#%0111111111111111,intena(a5)

	move.l	Main_VBR(pc),a0
	move.l	Main_OldVBIVector(pc),$6c(a0)
	move.l	Main_OldExIVector(pc),$78(a0)
	move.l	Main_GraphicsBase(pc),a1

	move.w	Main_OldIntena(pc),d0
	bset.l	#15,d0
	move.w	d0,Intena(a5)
	move.l	Copinit(a1),Cop1lch(a5)
	move.w	#%1000001111100000,dmacon(a5)
	move.w	#0,Copjmp1(a5)

	move.l	Main_GraphicsBase(pc),a6
	move.l	Main_Oldview(pc),a1
	jsr	LoadView(a6)

	move.l	4.w,a6
	jsr	Permit(a6)
ifeq	Main_SkipWBStartTest
	move.l	Main_Message(pc),d0
	beq	Main_NoReply
	move.l	d0,a1
	jsr	ReplyMsg(a6)
endif
Main_Noreply:
	move.l	Main_GraphicsBase(pc),a1
	jsr	CloseLibrary(a6)
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
Main_MasterCommand:	dc.l	0
Main_FakeVBI:		dc.l	0,0
Main_FakeCopperlist:	dc.l	0
Main_FakeTalk:		dc.l	0
Main_FakeMasterCommand:	dc.l	0,0
Main_Register:		dcb.l	16,0
Main_OldIntena:		dc.w	0
Main_GraphicsName:	dc.b	"graphics.library",0,0
;----------------------------------------------------------------
Main_VBI:
	btst.b	#5,$dff01f
	beq	Main_VBIBack
	movem.l	d0-a6,-(a7)

	lea	$dff000,a5

	move.l	Main_Copperlist(pc),a0
	move.l	(a0),d0
	beq	Main_NoCopperlist
	bpl	Main_NoCopDMAoff
	move.w	#%0000000010000000,dmacon(a5)
	clr.l	(a0)
	bra	Main_NoCopperlist

Main_NoCopDMAoff:
	move.l	d0,Cop1lch(a5)
	clr.l	(a0)
	move.w	#%1000000010000000,dmacon(a5)
	move.w	d0,copjmp1(a5)
Main_NoCopperlist:


	move.l	Main_VBIVector(pc),a0
	move.l	(a0)+,d0
	beq	Main_NoVBI1
	move.l	a0,-(a7)
	move.l	d0,a0
	jsr	(a0)
	move.l	(a7)+,a0
Main_NoVBI1:
	move.l	(a0),d0
	beq	Main_NoVBI2
	move.l	d0,a0
	jsr	(a0)
Main_NoVBI2:


ifne	Main_CallCommander
	bsr	Commander
endif

ifne	Main_ShowTime
	move.w	#0,bplcon3(a5)
	move.w	#$0fff,$180(a5)
	nop
	nop
	nop
	move.w	#$0000,$180(a5)
endif

	movem.l	(a7)+,d0-a6
main_vbiback:
	move.w	#%0000000001100000,$dff09c
	rte

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



;version 6.2 not compatible with 6.01
;CHANGES:
;Main_Command changed to Main_Mastercommands
; --> Command now handled from Master-loop
; --> now 2 commands possible


