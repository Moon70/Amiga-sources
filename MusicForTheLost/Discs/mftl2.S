a:
;track 0
bootblock:
incbin	"dh0:mftl/boot2/code"
bootblockend:

loader:
incbin	"dh0:mftl/loader2/code"
loaderend:

;1+39=40
unit4:
incbin	"dh0:mftl/units/unit4_p"
unit4end:
blk.b	39*$1600+unit4-unit4end,0

;40+1=41
blk.b	$1600,0

;41+34=75
unit5:
incbin	"dh0:mftl/units/unit5_p"
unit5end:
blk.b	34*$1600+unit5-unit5end,0

;75+15=90
unit6:
incbin	"dh0:mftl/units/unit6_p"
unit6end:
blk.b	15*$1600+unit6-unit6end,0

;90+39=129
unit7:
incbin	"dh0:mftl/units/unit7_p"
unit7end:
blk.b	39*$1600+unit7-unit7end,0

;129+17=146
endpart:
incbin	"dh0:mftl/endpart/code_p"
endpartend:
blk.b	17*$1600+endpart-endpartend,0

;146+14=160
wdpart:
incbin	"dh0:mftl/wdpart/code_p"
wdpartend:
blk.b	14*$1600+wdpart-wdpartend,0


b:
