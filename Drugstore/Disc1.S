PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"include/DiscPosLen.i"

Drugstore_Disc1:
;---------------
Boot1_s:	incbin	"code/Bootblock1.code"
Boot1_d:	;always ultra, always 1024
Boot1_e:
Main_s:		incbin	"code/Mainloader.head"
Main_d:		dcb.b	(DiscLen_Main*$1600)-(Boot1_e-Boot1_s)-(Main_d-main_s),0
Main_e:
;---------------
PDNote_s:	incbin	"code/PDNote.term"
PDNote_d:	dcb.b	(DiscLen_PDNote*$1600)-(PDNote_d-PDNote_s),0
PDNote_e:
;---------------
Module_s:	incbin	"code/Module1_P60.term"
dc.b "$VER: DRUGSTORE by Moon/Toxic/Jumping Pixel/Neurodancer of ABYSS",0
even
Module_d:	dcb.b	(DiscLen_Module1*$1600)-(Module_d-Module_s),0
Module_e:
;---------------
Jaul_s:	incbin	"code/Jaul.term"
Jaul_d:	dcb.b	(DiscLen_Jaul*$1600)-(Jaul_d-Jaul_s),0
Jaul_e:
;---------------
Drugstore_s:	incbin	"code/Drugstore.term"
Drugstore_d:	dcb.b	(DiscLen_Drugstore*$1600)-(Drugstore_d-Drugstore_s),0
Drugstore_e:
;---------------
Abyss_s:	incbin	"code/Abyss.term"
Abyss_d:	dcb.b	(DiscLen_Abyss*$1600)-(Abyss_d-Abyss_s),0
Abyss_e:
;---------------
Dotpic_s:	incbin	"code/Dotpic.term"
Dotpic_d:	dcb.b	(DiscLen_Dotpic*$1600)-(Dotpic_d-Dotpic_s),0
Dotpic_e:
;---------------

Sinedots_s:	incbin	"code/Sinedots.term"
Sinedots_d:	dcb.b	(DiscLen_Sinedots*$1600)-(Sinedots_d-Sinedots_s),0
Sinedots_e:
;---------------
Dialog1_s:	incbin	"code/Dialog1.term"
Dialog1_d:	dcb.b	(DiscLen_Dialog1*$1600)-(Dialog1_d-Dialog1_s),0
Dialog1_e:
;---------------
Colvec_s:	incbin	"code/Colvec.term"
Colvec_d:	dcb.b	(DiscLen_Colvec*$1600)-(Colvec_d-Colvec_s),0
Colvec_e:
;---------------
Dialog2_s:	incbin	"code/Dialog2.term"
Dialog2_d:	dcb.b	(DiscLen_Dialog2*$1600)-(Dialog2_d-Dialog2_s),0
Dialog2_e:
;---------------
SCScroll_s:	incbin	"code/SCScroll.term"
SCScroll_d:	dcb.b	(DiscLen_SCScroll*$1600)-(SCScroll_d-SCScroll_s),0
SCScroll_e:
;---------------
Dialog3_s:	incbin	"code/Dialog3.term"
Dialog3_d:	dcb.b	(DiscLen_Dialog3*$1600)-(Dialog3_d-Dialog3_s),0
Dialog3_e:
;---------------
Glasvec_s:	incbin	"code/Glasvec.term"
Glasvec_d:	dcb.b	(DiscLen_Glasvec*$1600)-(Glasvec_d-Glasvec_s),0
Glasvec_e:
;---------------
InsDisc2_s:	incbin	"code/Insdisc2.term"
InsDisc2_d:	dcb.b (DiscLen_Insdisc2*$1600)-(InsDisc2_d-Insdisc2_s),0
InsDisc2_e:
;---------------
James_s:	incbin	"code/James.term"
James_d:	dcb.b	(DiscLen_James*$1600)-(James_d-James_s),0
James_e:
;---------------
Module2_s:	incbin	"code/Module2_p60.term"
Module2_d:	dcb.b	(DiscLen_Module2*$1600)-(Module2_d-Module2_s),0
Module2_e:
;---------------
LoMem_s:	incbin	"code/LoMem.term"
LoMem_d:	dcb.b	(DiscLen_LoMem*$1600)-(LoMem_d-LoMem_s),0
LoMem_e:
;---------------
;---------------
Drugstore_Dataend:
dcb.b	$1600*160+Drugstore_Disc1-Drugstore_Dataend

Drugstore_Disc1end:



printt	"Bootblock1 and Mainpart:"
printv	(Boot1_s-Drugstore_Disc1)/$1600
printv	(Main_e-Boot1_s)/$1600
;-------
printt	"PDNote:"
printv	(PDNote_s-Drugstore_Disc1)/$1600
printv	(PDNote_e-PDNote_s)/$1600
;-------
printt	"Module:"
printv	(Module_s-Drugstore_Disc1)/$1600
printv	(Module_e-Module_s)/$1600
;-------
printt	"Jaul:"
printv	(Jaul_s-Drugstore_Disc1)/$1600
printv	(Jaul_e-Jaul_s)/$1600
;-------
printt	"Drugstore:"
printv	(Drugstore_s-Drugstore_Disc1)/$1600
printv	(Drugstore_e-Drugstore_s)/$1600
;-------
printt	"Abyss:"
printv	(Abyss_s-Drugstore_Disc1)/$1600
printv	(Abyss_e-Abyss_s)/$1600
;-------
printt	"Dotpic:"
printv	(Dotpic_s-Drugstore_Disc1)/$1600
printv	(Dotpic_e-Dotpic_s)/$1600
;-------



printt	"Sinedots:"
printv	(Sinedots_s-Drugstore_Disc1)/$1600
printv	(Sinedots_e-Sinedots_s)/$1600
;-------
printt	"Dialog1:"
printv	(Dialog1_s-Drugstore_Disc1)/$1600
printv	(Dialog1_e-Dialog1_s)/$1600
;-------
printt	"Colvec:"
printv	(Colvec_s-Drugstore_Disc1)/$1600
printv	(Colvec_e-Colvec_s)/$1600
;-------
printt	"Dialog2:"
printv	(Dialog2_s-Drugstore_Disc1)/$1600
printv	(Dialog2_e-Dialog2_s)/$1600
;-------
printt	"SCScroll:"
printv	(SCScroll_s-Drugstore_Disc1)/$1600
printv	(SCScroll_e-SCScroll_s)/$1600
;-------
printt	"Dialog3:"
printv	(Dialog3_s-Drugstore_Disc1)/$1600
printv	(Dialog3_e-Dialog3_s)/$1600
;-------
printt	"Glasvec:"
printv	(Glasvec_s-Drugstore_Disc1)/$1600
printv	(Glasvec_e-Glasvec_s)/$1600
;-------
printt	"Insdisc2:"
printv	(Insdisc2_s-Drugstore_Disc1)/$1600
printv	(Insdisc2_e-Insdisc2_s)/$1600
;-------
printt	"James:"
printv	(James_s-Drugstore_Disc1)/$1600
printv	(James_e-James_s)/$1600
;-------
printt	"Module2:"
printv	(Module2_s-Drugstore_Disc1)/$1600
printv	(Module2_e-Module2_s)/$1600
;-------
printt	"LoMem:"
printv	(LoMem_s-Drugstore_Disc1)/$1600
printv	(LoMem_e-LoMem_s)/$1600
;-------






a=Drugstore_Disc1
b=Drugstore_Disc1end
printt
printt	"Number of tracks:"
printv	(Drugstore_Disc1end-Drugstore_Disc1)/$1600
