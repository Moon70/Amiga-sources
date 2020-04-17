WriteHardfile=1

PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"include/DiscPosLen.i"


HardFile_s:
;---------------
Block0_s:
Main_s:		incbin	"code/Mainloader.head"
Main_d:		dcb.b	(DiscLen_Main*$1600)-(Main_d-main_s),0
Main_e:
PDNote_s:	incbin	"code/PDNote.term"
PDNote_d:	dcb.b	(DiscLen_PDNote*$1600)-(PDNote_d-PDNote_s),0
PDNote_e:
Block0_e:
;---------------

;---------------
Block1_s:
Module_s:	incbin	"code/Module1_P60.term"
Module_d:	dcb.b	(DiscLen_Module1*$1600)-(Module_d-Module_s),0
Module_e:
Jaul_s:		incbin	"code/Jaul.term"
Jaul_d:		dcb.b	(DiscLen_Jaul*$1600)-(Jaul_d-Jaul_s),0
Jaul_e:
Drugstore_s:	incbin	"code/Drugstore.term"
Drugstore_d:	dcb.b	(DiscLen_Drugstore*$1600)-(Drugstore_d-Drugstore_s),0
Drugstore_e:
Abyss_s:	incbin	"code/Abyss.term"
Abyss_d:	dcb.b	(DiscLen_Abyss*$1600)-(Abyss_d-Abyss_s),0
Abyss_e:
Dotpic_s:	incbin	"code/Dotpic.term"
Dotpic_d:	dcb.b	(DiscLen_Dotpic*$1600)-(Dotpic_d-Dotpic_s),0
Dotpic_e:
Sinedots_s:	incbin	"code/Sinedots.term"
Sinedots_d:	dcb.b	(DiscLen_Sinedots*$1600)-(Sinedots_d-Sinedots_s),0
Sinedots_e:
Dialog1_s:	incbin	"code/Dialog1.term"
Dialog1_d:	dcb.b	(DiscLen_Dialog1*$1600)-(Dialog1_d-Dialog1_s),0
Dialog1_e:
;---------------
Block1_e:
HardFile_e:

printt	"Block0:"
printv	(Block0_s-HardFile_s)/$1600
printv	(Block0_e-Block0_s)/$1600

printt	"Block1:"
printv	(Block1_s-HardFile_s)/$1600
printv	(Block1_e-Block1_s)/$1600
printv	(Block1_e-Block1_s)-(DiscLen_Block1*$1600)


printt	"HardFile1:"
printv	(HardFile_s-HardFile_s)/$1600
printv	(HardFile_e-HardFile_s)/$1600
printv	(HardFile_e-HardFile_s)






ifne	WriteHardfile
auto	wb\dh0:Drugstore1.dat\HardFile_s\HardFile_e\
endif


