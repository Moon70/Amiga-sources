PrintDisc1Len=0
PrintDisc1Pos=0
PrintDisc2Len=0
PrintDisc2Pos=0

include	"/include/DiscPosLen.i"

Pos=DiscPos_sinedots
Len=DiscLen_sinedots

Drugstore_Disc2:
s:	incbin	"/code/sinedots.term"
d:	dcb.b	(Len*$1600)-(d-s),0
e:
;---------------
printt	"Pos:"
printv	Pos
printt	"Len:"
printv	Len
;-------

auto wt\s\Pos\Len\



printt
printt	"Hope DISC 1 is in drive DF0: and CHIPMEM allocated"

