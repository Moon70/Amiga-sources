;------------------------------------------------------------------------
;|									|
;|			     MoonLib V1.0				|
;|			    --------------				|
;|									|
;|  Various routines in a kind of library, to make coding a bit easier	|
;|									|
;|	    'MoonLib.doc' contains all informations you need		|
;|									|
;|									|
;| NOTE: all routines are PC-relative coded				|
;|									|
;| coded by Moon/ABYSS					      July 1995	|
;------------------------------------------------------------------------
s:
Offset_Table:			;offset
	bra.w	Determ_Code	;   0
	bra.w	Reloc_Code	;   4


	dc.b	"$VER: MoonLib V1.0",0
even





Determ_Code:	include	"Sources/Determinator/Determinator_V1.1.s"
Reloc_Code:	include	"Sources/Relocator/Relocator_V2.5.s"
e:
