;printdisc1len=0
;printdisc1pos=0
;printdisc2len=0
;printdisc2pos=0
;printblock=1

DosSpace=50

;Disc Positions and Disc lengths
DiscPos_Main=0	;Except bootblock!
DiscLen_Main=5
;---
DiscPos_PDNote=5
DiscLen_PDNote=3
;---
DiscPos_Module1=8
DiscLen_Module1=25
;---
DiscPos_Jaul=33
DiscLen_Jaul=1
;---
DiscPos_Drugstore=34
DiscLen_Drugstore=15
;---
DiscPos_Abyss=49
DiscLen_Abyss=4
;---
DiscPos_Dotpic=53
DiscLen_Dotpic=6
;---
DiscPos_Sinedots=59
DiscLen_Sinedots=5
;---
DiscPos_Dialog1=64
DiscLen_Dialog1=4
;---
DiscPos_Colvec=68
DiscLen_Colvec=16
;---
DiscPos_Dialog2=84
DiscLen_Dialog2=3
;---
DiscPos_SCScroll=87
DiscLen_SCScroll=9
;---
DiscPos_Dialog3=96
DiscLen_Dialog3=4
;---
DiscPos_Glasvec=100
DiscLen_Glasvec=10
;---
DiscPos_Insdisc2=110
DiscLen_Insdisc2=2
;---
DiscPos_James=112
DiscLen_James=5
;---
DiscPos_Module2=117
DiscLen_Module2=17
;---
DiscPos_LoMem=134
DiscLen_LoMem=2



;---DISC2---
DiscPos_Wrong=0
DiscLen_Wrong=3
;---
DiscPos_Starscroll=3
DiscLen_Starscroll=5
;---
DiscPos_RGB=8
DiscLen_RGB=10
;---
DiscPos_Cloud=18
DiscLen_Cloud=10
;---
DiscPos_Spiral=28
DiscLen_Spiral=6
;---
DiscPos_Text1=34
DiscLen_Text1=1
;---
DiscPos_Clown=35
DiscLen_Clown=4
;---
DiscPos_Child=39+DosSpace
DiscLen_Child=4
;---
DiscPos_Text2=43+DosSpace
DiscLen_Text2=2
;---
DiscPos_Mont=45+DosSpace
DiscLen_Mont=10
;---
DiscPos_Text3=55+DosSpace
DiscLen_Text3=1
;---
DiscPos_Module3=56+DosSpace
DiscLen_Module3=30
;---
DiscPos_Endpart=86+DosSpace
DiscLen_Endpart=3
;---
;DiscPos_=
;DiscLen_
;---

DiscPos_Block1=DiscPos_Module1
DiscLen_Block1:	set	DiscLen_Module1+DiscLen_Jaul+DiscLen_Drugstore
DiscLen_Block1:	set	DiscLen_Block1+DiscLen_Abyss+DiscLen_Dotpic
DiscLen_Block1:	set	DiscLen_Block1+Disclen_Sinedots+Disclen_Dialog1

DiscPos_Block2=Discpos_Colvec
DiscLen_Block2:	set	0
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_Colvec
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_Dialog2
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_SCScroll
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_Dialog3
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_Glasvec
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_InsDisc2
DiscLen_Block2:	set	DiscLen_Block2+DiscLen_James

DiscPos_Block3=Discpos_Starscroll
DiscLen_Block3:	set	0
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_Starscroll
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_RGB
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_Cloud
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_Spiral
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_Text1
DiscLen_Block3:	set	DiscLen_Block3+DiscLen_Clown

DiscPos_Block4=Discpos_Child
DiscLen_Block4:	set	0
DiscLen_Block4:	set	DiscLen_Block4+DiscLen_Child
DiscLen_Block4:	set	DiscLen_Block4+DiscLen_Text2
DiscLen_Block4:	set	DiscLen_Block4+DiscLen_Mont
DiscLen_Block4:	set	DiscLen_Block4+DiscLen_Text3


ifne	printblock
printt	"DiscPos_Block1"
printv	DiscPos_Block1
printt	"DiscLen_Block1"
printv	DiscLen_Block1
printt
printt	"DiscPos_Block2"
printv	DiscPos_Block2
printt	"DiscLen_Block2"
printv	DiscLen_Block2
printt
printt	"DiscPos_Block3"
printv	DiscPos_Block3
printt	"DiscLen_Block3"
printv	DiscLen_Block3
printt
printt	"DiscPos_Block4"
printv	DiscPos_Block4
printt	"DiscLen_Block4"
printv	DiscLen_Block4
printt
endif




ifne	printDisc1Len
printt	"DISC 1"
printt	"DiscLen_Main"
printv	DiscLen_Main
printt	"DiscLen_PDNote"
printv	DiscLen_PDNote
printt	"DiscLen_Module1"
printv	DiscLen_Module1
printt	"DiscLen_Jaul"
printv	DiscLen_Jaul
printt	"DiscLen_Drugstore"
printv	DiscLen_Drugstore
printt	"DiscLen_Abyss"
printv	DiscLen_Abyss
printt	"DiscLen_Dotpic"
printv	DiscLen_Dotpic
printt	"DiscLen_Sinedots"
printv	DiscLen_Sinedots
printt	"DiscLen_Dialog1"
printv	DiscLen_Dialog1
printt	"DiscLen_Colvec"
printv	DiscLen_Colvec
printt	"DiscLen_Dialog2"
printv	DiscLen_Dialog2
printt	"DiscLen_SCScroll"
printv	DiscLen_SCScroll
printt	"DiscLen_Dialog3"
printv	DiscLen_Dialog3
printt	"DiscLen_Glasvec"
printv	DiscLen_Glasvec

printt	"DiscLen_Insdisc2"
printv	DiscLen_Insdisc2
printt	"DiscLen_James"
printv	DiscLen_James
printt	"DiscLen_Module2"
printv	DiscLen_Module2
endif



ifne	PrintDisc1Pos
printt	"DISC 1"
printt	"DiscPos_Main"
printv	DiscPos_Main
printt	"DiscPos_PDNote"
printv	DiscPos_PDNote
printt	"DiscPos_Module1"
printv	DiscPos_Module1
printt	"DiscPos_Jaul"
printv	DiscPos_Jaul
printt	"DiscPos_Drugstore"
printv	DiscPos_Drugstore
printt	"DiscPos_Abyss"
printv	DiscPos_Abyss
printt	"DiscPos_Dotpic"
printv	DiscPos_Dotpic
printt	"DiscPos_Sinedots"
printv	DiscPos_Sinedots
printt	"DiscPos_Dialog1"
printv	DiscPos_Dialog1
printt	"DiscPos_Colvec"
printv	DiscPos_Colvec
printt	"DiscPos_Dialog2"
printv	DiscPos_Dialog2
printt	"DiscPos_SCScroll"
printv	DiscPos_SCScroll
printt	"DiscPos_Dialog3"
printv	DiscPos_Dialog3
printt	"DiscPos_Glasvec"
printv	DiscPos_Glasvec

printt	"DiscPos_Insdisc2"
printv	DiscPos_Insdisc2
printt	"DiscPos_James"
printv	DiscPos_James
printt	"DiscPos_Module2"
printv	DiscPos_Module2
endif





ifne	printDisc2Len
printt	"DISC 2"
printt	"DiscLen_Starscroll"
printv	DiscLen_Starscroll
printt	"DiscLen_RGB"
printv	DiscLen_RGB
printt	"DiscLen_Cloud"
printv	DiscLen_Cloud
printt	"DiscLen_Spiral"
printv	DiscLen_Spiral

printt	"DiscLen_Text1"
printv	DiscLen_Text1
printt	"DiscLen_Clown"
printv	DiscLen_Clown

printt	"DiscLen_Child"
printv	DiscLen_Child
printt	"DiscLen_Text2"
printv	DiscLen_Text2
printt	"DiscLen_Mont2"
printv	DiscLen_Mont
printt	"DiscLen_Endpart"
printv	DiscLen_Endpart
printt	"DiscLen_Module3"
printv	DiscLen_Module3

;printt	
;printv	
endif


ifne	PrintDisc2Pos
printt	"DISC 2"
printt	"DiscPos_Starscroll"
printv	DiscPos_Starscroll
printt	"DiscPos_RGB"
printv	DiscPos_RGB
printt	"DiscPos_Cloud"
printv	DiscPos_Cloud
printt	"DiscPos_Spiral"
printv	DiscPos_SPiral

printt	"DiscPos_Text1"
printv	DiscPos_Text1
printt	"DiscPos_Clown"
printv	DiscPos_Clown

printt	"DiscPos_Child"
printv	DiscPos_Child
printt	"DiscPos_Text2"
printv	DiscPos_Text2
printt	"DiscPos_Mont"
printv	DiscPos_Mont
printt	"DiscPos_Endpart"
printv	DiscPos_Endpart
printt	"DiscPos_Module3"
printv	DiscPos_Module3
;printt	
;printv	
endif




