PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
Printblock=0

include	"include/DiscPosLen.i"
BeforeBAM_s:
Drugstore_Disc2:
;---------------
Boot2_s:	incbin	"code/Bootblock2.code"
Boot2_d:	;always ultra, always 1024
Boot2_e:
Wrong_s:		incbin	"code/Wrong.head"
Wrong_d:		dcb.b	(DiscLen_Wrong*$1600)-(Boot2_e-Boot2_s)-(Wrong_d-Wrong_s),0
Wrong_e:
;---------------
Starscroll_s:	incbin	"code/Starscroll.term"
Starscroll_d:	dcb.b	(DiscLen_Starscroll*$1600)-(Starscroll_d-Starscroll_s),0
Starscroll_e:
;---------------
RGB_s:	incbin	"code/RGB.term"
RGB_d:	dcb.b	(DiscLen_RGB*$1600)-(RGB_d-RGB_s),0
RGB_e:
;---------------
Cloud_s:	incbin	"code/Cloud.term"
Cloud_d:	dcb.b	(DiscLen_Cloud*$1600)-(Cloud_d-Cloud_s),0
Cloud_e:
;---------------
Spiral_s:	incbin	"code/Spiral.term"
Spiral_d:	dcb.b	(DiscLen_Spiral*$1600)-(Spiral_d-Spiral_s),0
Spiral_e:
;---------------
Text1_s:	incbin	"code/Text1.term"
Text1_d:	dcb.b	(DiscLen_Text1*$1600)-(Text1_d-Text1_s),0
Text1_e:
;---------------
Clown_s:	incbin	"code/Clown.term"
Clown_d:	dcb.b	(DiscLen_Clown*$1600)-(Clown_d-Clown_s),0
Clown_e:
BeforeBAM_e:
dcb.b	$1600*50,0	;20 tracks space dor dos-files
AfterBAM_s:
;---------------
Child_s:	incbin	"code/Child.term"
Child_d:	dcb.b	(DiscLen_Child*$1600)-(Child_d-Child_s),0
Child_e:
;---------------
Text2_s:	incbin	"code/Text2.term"
Text2_d:	dcb.b	(DiscLen_Text2*$1600)-(Text2_d-Text2_s),0
Text2_e:
;---------------
Mont_s:	incbin	"code/Mont.term"
Mont_d:	dcb.b	(DiscLen_Mont*$1600)-(Mont_d-Mont_s),0
Mont_e:
;---------------
Text3_s:	incbin	"code/Text3.term"
Text3_d:	dcb.b	(DiscLen_Text3*$1600)-(Text3_d-Text3_s),0
Text3_e:
;---------------
Module3_s:	incbin	"code/Module3_P60.term"
Module3_d:	dcb.b	(DiscLen_Module3*$1600)-(Module3_d-Module3_s),0
Module3_e:
;---------------
Endpart_s:	incbin	"code/Endpart.term"
Endpart_d:	dcb.b	(DiscLen_Endpart*$1600)-(Endpart_d-Endpart_s),0
Endpart_e:
;---------------
;---------------
;---------------
AfterBAM_e:
Drugstore_Dataend:
dcb.b	$1600*160+Drugstore_Disc2-Drugstore_Dataend

Drugstore_Disc2end:



printt	"Bootblock2 and Wrong:"
printv	(Boot2_s-Drugstore_Disc2)/$1600
printv	(Wrong_e-Boot2_s)/$1600
;-------
printt	"Starscroll:"
printv	(Starscroll_s-Drugstore_Disc2)/$1600
printv	(Starscroll_e-Starscroll_s)/$1600
;-------
printt	"RGB:"
printv	(RGB_s-Drugstore_Disc2)/$1600
printv	(RGB_e-RGB_s)/$1600
;-------
printt	"Cloud:"
printv	(Cloud_s-Drugstore_Disc2)/$1600
printv	(Cloud_e-Cloud_s)/$1600
;-------
printt	"Spiral:"
printv	(Spiral_s-Drugstore_Disc2)/$1600
printv	(Spiral_e-Spiral_s)/$1600
;-------
printt	"Text1:"
printv	(Text1_s-Drugstore_Disc2)/$1600
printv	(Text1_e-Text1_s)/$1600
;-------
printt	"Child:"
printv	(Child_s-Drugstore_Disc2)/$1600
printv	(Child_e-Child_s)/$1600
;-------
printt	"Text2:"
printv	(Text2_s-Drugstore_Disc2)/$1600
printv	(Text2_e-Text2_s)/$1600
;-------
printt	"Mont:"
printv	(Mont_s-Drugstore_Disc2)/$1600
printv	(Mont_e-Mont_s)/$1600
;-------
printt	"Text3:"
printv	(Text3_s-Drugstore_Disc2)/$1600
printv	(Text3_e-Text3_s)/$1600
;-------
printt	"Module3:"
printv	(Module3_s-Drugstore_Disc2)/$1600
printv	(Module3_e-Module3_s)/$1600
;-------
printt	"Endpart:"
printv	(Endpart_s-Drugstore_Disc2)/$1600
printv	(Endpart_e-Endpart_s)/$1600
;-------
;-------

printt	"BeforeBAM:"
printv	(BeforeBAM_s-Drugstore_Disc2)/$1600
printv	(BeforeBAM_e-BeforeBAM_s)/$1600
;-------
printt	"AfterBAM:"
printv	(AfterBAM_s-Drugstore_Disc2)/$1600
printv	(AfterBAM_e-AfterBAM_s)/$1600
;-------





a=Drugstore_Disc2
b=Drugstore_Disc2end
printt
printt	"Number of tracks:"
printv	(Drugstore_Disc2end-Drugstore_Disc2)/$1600


