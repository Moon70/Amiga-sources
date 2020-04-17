PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0
PrintBlock=0

include	"/include/DiscPosLen.i"

Pos=DiscPos_Main
Len=DiscLen_Main

Drugstore_Disc2:
s:	incbin	"/code/Bootblock1.code"
	incbin	"/code/Mainloader.head"
d:	dcb.b	(Len*$1600)-(d-s),0
e:
;---------------
printt	"Pos:"
printv	Pos
printt	"Len:"
printv	Len
;-------

auto wt\s\Pos\Len\cc\



printt
printt	"Hope DISC 1 was in drive DF0: and CHIPMEM allocated"



