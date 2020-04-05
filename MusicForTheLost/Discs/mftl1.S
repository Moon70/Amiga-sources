a:
;track 0
bootblock:
incbin	"dh0:mftl/boot1/code"
bootblockend:

loader:
incbin	"dh0:mftl/loader1/code"
loaderend:

;1+24=25
intro:
incbin	"dh0:mftl/intro/code_p"
introend:
blk.b	24*$1600+intro-introend,0

;25+14=39
main:
incbin	"dh0:mftl/main/code_p"
mainend:
blk.b	14*$1600+main-mainend,0

;39+10=49
blk.b	$1600*10,0


;49+34=83
unit1:
incbin	"dh0:mftl/units/unit1_p"
unit1end:
blk.b	34*$1600+unit1-unit1end,0


;83+40=123
unit2:
incbin	"dh0:mftl/units/unit2_p"
unit2end:
blk.b	40*$1600+unit2-unit2end,0

;123+37=160
unit3:
incbin	"dh0:mftl/units/unit3_p"
unit3end:
blk.b	37*$1600+unit3-unit3end,0

b:
