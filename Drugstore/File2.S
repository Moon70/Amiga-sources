WriteHardfile=1

PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"include/DiscPosLen.i"


HardFile_s:
;---------------
Lomem_s:	incbin	"code/Lomem.term"
Lomem_d:	dcb.b	(DiscLen_Lomem*$1600)-(Lomem_d-Lomem_s),0
Lomem_e:
Block2_s:
Colvec_s:	incbin	"code/Colvec.term"
Colvec_d:	dcb.b	(DiscLen_Colvec*$1600)-(Colvec_d-Colvec_s),0
Colvec_e:
Dialog2_s:	incbin	"code/Dialog2.term"
Dialog2_d:	dcb.b	(DiscLen_Dialog2*$1600)-(Dialog2_d-Dialog2_s),0
Dialog2_e:
SCScroll_s:	incbin	"code/SCScroll.term"
SCScroll_d:	dcb.b	(DiscLen_SCScroll*$1600)-(SCScroll_d-SCScroll_s),0
SCScroll_e:
Dialog3_s:	incbin	"code/Dialog3.term"
Dialog3_d:	dcb.b	(DiscLen_Dialog3*$1600)-(Dialog3_d-Dialog3_s),0
Dialog3_e:
Glasvec_s:	incbin	"code/Glasvec.term"
Glasvec_d:	dcb.b	(DiscLen_Glasvec*$1600)-(Glasvec_d-Glasvec_s),0
Glasvec_e:
InsDisc2_s:	incbin	"code/Insdisc2.term"
InsDisc2_d:	dcb.b (DiscLen_Insdisc2*$1600)-(InsDisc2_d-Insdisc2_s),0
InsDisc2_e:
James_s:	incbin	"code/James.term"
James_d:	dcb.b	(DiscLen_James*$1600)-(James_d-James_s),0
James_e:
Block2_e:
;---------------

;---------------
Module2_s:	incbin	"code/Module2_p60.term"
Module2_d:	dcb.b	(DiscLen_Module2*$1600)-(Module2_d-Module2_s),0
Module2_e:
;---------------

;---------------
Block3_s:
Starscroll_s:	incbin	"code/Starscroll.term"
Starscroll_d:	dcb.b	(DiscLen_Starscroll*$1600)-(Starscroll_d-Starscroll_s),0
Starscroll_e:
RGB_s:	incbin	"code/RGB.term"
RGB_d:	dcb.b	(DiscLen_RGB*$1600)-(RGB_d-RGB_s),0
RGB_e:
Cloud_s:	incbin	"code/Cloud.term"
Cloud_d:	dcb.b	(DiscLen_Cloud*$1600)-(Cloud_d-Cloud_s),0
Cloud_e:
Spiral_s:	incbin	"code/Spiral.term"
Spiral_d:	dcb.b	(DiscLen_Spiral*$1600)-(Spiral_d-Spiral_s),0
Spiral_e:
Text1_s:	incbin	"code/Text1.term"
Text1_d:	dcb.b	(DiscLen_Text1*$1600)-(Text1_d-Text1_s),0
Text1_e:
Clown_s:	incbin	"code/Clown.term"
Clown_d:	dcb.b	(DiscLen_Clown*$1600)-(Clown_d-Clown_s),0
Clown_e:
Block3_e:
;---------------

;---------------
Block4_s:
Child_s:	incbin	"code/Child.term"
Child_d:	dcb.b	(DiscLen_Child*$1600)-(Child_d-Child_s),0
Child_e:
Text2_s:	incbin	"code/Text2.term"
Text2_d:	dcb.b	(DiscLen_Text2*$1600)-(Text2_d-Text2_s),0
Text2_e:
Mont_s:	incbin	"code/Mont.term"
Mont_d:	dcb.b	(DiscLen_Mont*$1600)-(Mont_d-Mont_s),0
Mont_e:
Text3_s:	incbin	"code/Text3.term"
Text3_d:	dcb.b	(DiscLen_Text3*$1600)-(Text3_d-Text3_s),0
Text3_e:
Block4_e:
;---------------

;---------------
Module3_s:	incbin	"code/Module3_P60.term"
Module3_d:	dcb.b	(DiscLen_Module3*$1600)-(Module3_d-Module3_s),0
Module3_e:
;---------------
Endpart_s:	incbin	"code/Endpart.term"
Endpart_d:	dcb.b	(DiscLen_Endpart*$1600)-(Endpart_d-Endpart_s),0
Endpart_e:
;---------------
HardFile_e:

printt	"Lomem:"
printv	(Lomem_s-HardFile_s)/$1600
printv	(Lomem_e-Lomem_s)/$1600

printt	"Block2:"
printv	(Block2_s-HardFile_s)/$1600
printv	(Block2_e-Block2_s)/$1600
printv	(Block2_e-Block2_s)-(DiscLen_Block2*$1600)

printt	"Module2:"
printv	(Module2_s-HardFile_s)/$1600
printv	(Module2_e-Module2_s)/$1600

printt	"Block3:"
printv	(Block3_s-HardFile_s)/$1600
printv	(Block3_e-Block3_s)/$1600
printv	(Block3_e-Block3_s)-(DiscLen_Block3*$1600)

printt	"Block4:"
printv	(Block4_s-HardFile_s)/$1600
printv	(Block4_e-Block4_s)/$1600
printv	(Block4_e-Block4_s)-(DiscLen_Block4*$1600)

printt	"Module3:"
printv	(Module3_s-HardFile_s)/$1600
printv	(Module3_e-Module3_s)/$1600

printt	"Endpart:"
printv	(Endpart_s-HardFile_s)/$1600
printv	(Endpart_e-Endpart_s)/$1600


printt	"HardFile:"
printv	(HardFile_s-HardFile_s)/$1600
printv	(HardFile_e-HardFile_s)/$1600
printv	(HardFile_e-HardFile_s)






ifne	WriteHardfile
auto	wb\dh0:Drugstore2.dat\HardFile_s\HardFile_e\
endif

