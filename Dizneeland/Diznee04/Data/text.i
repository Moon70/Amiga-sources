;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;size=28*12
;						                  /\|-"
chars:	
dc.b	" abcdefghijklmnopqrstuvwxyz0123456789!?-:ß.,()*#/=+'><%§&¹\|@"
;§=big ball
charsend:
even
textpoint:	dc.w	0;	|
text:;				|
;;music
;	 1234567890123456789012345678
dc.b	"          musica            "
dc.b	"   name               length"
dc.b	"f1*beyond voyage      88066b"
dc.b	"f2 xality             75648b"
dc.b	"f3 classic tunes      51116b"
dc.b	"f4 springtime         76118b"
dc.b	"f5 hysteria 94-remix  42620b"
dc.b	"f6 lsd ninja          58782b"
dc.b	"f7 journey part 2     79240b"
dc.b	"f8 summertime part 2  47826b"
dc.b	"f9 november '64       30064b"
dc.b	"f0 path of harmony    18162b"

;;welcome
dc.b	"§*§*§*§*§*§*§*§*§*§*§*§*§*§*"
dc.b	"*                          §"
dc.b	"§   diznee-land issue 4    *"
dc.b	"*                          §"
dc.b	"§                          *"
dc.b	"*   released in december   §"
dc.b	"§         1 9 9 4          *"
dc.b	"*                          §"
dc.b	"§                          *"
dc.b	"*    press help 4 help     §"
dc.b	"§                          *"
dc.b	"*§*§*§*§*§*§*§*§*§*§*§*§*§*§"

;;help
dc.b	"     diznee land manual     "
dc.b	"                            "
dc.b	"mouse control:              "
dc.b	"move menuball to an item    "
dc.b	"and select with lmb.        "
dc.b	"rmb=next page, except in    "
dc.b	"musica-menu, where rmb      "
dc.b	"toggles between mainselector"
dc.b	"and musicselector.          "
dc.b	"                            "
dc.b	" hold both buttons to exit! "
dc.b	"                          ->"

dc.b	"keyboard control:           "
dc.b	"press first letter of item  "
dc.b	"to select or use cursor keys"
dc.b	"to move menuball and select "
dc.b	"with return.                "
dc.b	"cursor left=prev page       "
dc.b	"csr right=next page, except "
dc.b	"in musica menu where it     "
dc.b	"toggles between mainselector"
dc.b	"and musicselector.          "
dc.b	"use f-keys to select tunes. "
dc.b	"     press esc to quit      "

;;credits
dc.b	"        the credits         "
dc.b	"       -------------        "
dc.b	"                            "
dc.b	"            code            "
dc.b	"             by             "
dc.b	"            moon            "
dc.b	"                            "
dc.b	"           music:           "
dc.b	"                            "
dc.b	"     f1-f8 by pink          "
dc.b	"     f9-f0 by mem'o'ree     "
dc.b	"                          ->"

dc.b	"                            "
dc.b	"                            "
dc.b	"             gfx:           "
dc.b	"                            "
dc.b	"    main gfx by mem'o'ree   "
dc.b	"                            "
dc.b	"     title pic by toxic     "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                          ->"

dc.b	"       *§ write 2 §*        "
dc.b	"pink                        "
dc.b	"manfred linzner             "
dc.b	"rupert-mayer-str. 6         "
dc.b	"81379 muenchen              "
dc.b	"germany                     "
dc.b	"                            "
dc.b	"mem'o'ree                   "
dc.b	"gregory engelhardt          "
dc.b	"am weiherbach 6             "
dc.b	"89361 landensberg           "
dc.b	"germany                   ->"

dc.b	"toxic                       "
dc.b	"sven dedek                  "
dc.b	"gruenewaldstrasse 6         "
dc.b	"84453 muehldorf             "
dc.b	"germany                     "
dc.b	"                            "
dc.b	"moon                        "
dc.b	"po box 162                  "
dc.b	"5400 hallein                "
dc.b	"austria                     "
dc.b	"                          ->"

dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"the duke                    "
dc.b	"markus knauer               "
dc.b	"fritz-bender-strasse 9      "
dc.b	"85402 kranzberg             "
dc.b	"germany                     "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "


;;adverts
dc.b "                            "
dc.b "      wanna see your        "
dc.b "       advert here?         "
dc.b "                            "
dc.b "     then send it to:       "
dc.b "       pink, toxic,         "
dc.b "    mem'o'ree  or moon      "
dc.b "                            "
dc.b "  *§>  size: 28*12  <§*     "
dc.b "                            "
dc.b "  don't forget to vote for  "
dc.b "  the swap'n'dance charts!  "
dc.b "     votesheet on disc!     "

dc.b " **§§ felix of speedy §§**  "
dc.b "                            "
dc.b "    karsten l. fischer      "
dc.b "     sorgenfrigt. 21a       "
dc.b "        0365  oslo          "
dc.b "          norway            "
dc.b "                            "
dc.b "    get in touch with a     "
dc.b "      aga speedy dude       "
dc.b "                            "
dc.b "no elite without friendship "
dc.b " get our productions first  "

dc.b "                            "
dc.b "                            "
dc.b "   for swapping the l8est   "
dc.b "                            "
dc.b "       enzyme/saints        "
dc.b "     koelentajankatu 1      "
dc.b "       33900 tampere        "
dc.b "          finland           "
dc.b "                            "
dc.b "     disk->100% answer      "
dc.b "                            "
dc.b "                            "

dc.b "                            " ; 1
dc.b "           r a m            " ; 2
dc.b "             -              " ; 3
dc.b "           j a m            " ; 4
dc.b "                            " ; 5
dc.b "    taste the difference    " ; 6
dc.b "                            " ; 7
dc.b "          cybergod          " ; 8
dc.b "        faltharev. 9        " ; 9
dc.b "         72243 v-as         " ; 10
dc.b "           sweden           " ; 11
dc.b "                            " ; 12

dc.b "                            " ; 2
dc.b "   4 elite mail trading!    " ; 3
dc.b "       try this one:        " ; 4
dc.b "      paperboy/simplex      " ; 5
dc.b "      jarkko tarnanen       " ; 6
dc.b "       harakankatu 5b       " ; 7
dc.b "        15610 lahti         " ; 8
dc.b "          finland           " ; 9
dc.b "                            " ; 1
dc.b "                            " ; 10
dc.b "    illegal wares rules!    " ; 11
dc.b "                            " ; 12

dc.b "                            " ; 2
dc.b " -) beyond the mind eyes (- " ; 3
dc.b "                            " ; 4
dc.b "   vader / mador      g     " ; 5
dc.b "   ulrich becker      e     " ; 6
dc.b "   weserstr.48        r     " ; 7
dc.b "   49661 cloppenburg  m     " ; 8
dc.b "                      a     " ; 9
dc.b "   disc(s) and letter n     " ; 10
dc.b "     100 % replay     y     " ; 11
dc.b "                            " ; 12
dc.b "                            " ; 1

dc.b "                            " ; 1
dc.b "                            " ; 2
dc.b "                            " ; 3
dc.b "     4 elite swapping       " ; 4
dc.b "       try this one         " ; 5
dc.b "                            " ; 6
dc.b "       tuura/spedes         " ; 7
dc.b "      harakankatu 5b        " ; 8
dc.b "        15610 lahti         " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12
q:

dc.b "      nuke of manitou       " ; 2
dc.b "                            " ; 3
dc.b "    is searching 4 sum      " ; 4
dc.b "       cool contacts        " ; 5
dc.b "      just write to:        " ; 1
dc.b "                            " ; 6
dc.b "        p.o. box 37         " ; 7
dc.b "      a-5411 oberalm        " ; 8
dc.b "          austria           " ; 9
dc.b "                            " ; 10
dc.b "        § manitou §         " ; 11
dc.b " *only we give the quality* " ; 12

dc.b "                            " ; 1
dc.b "     tooons of pictures     " ; 2
dc.b "    including aga pixels    " ; 3
dc.b "                            " ; 4
dc.b "     happy gfx trade at     " ; 5
dc.b "                            " ; 6
dc.b "      distortion/storm      " ; 7
dc.b "   ul. koszalinska 32i/20   " ; 8
dc.b "      78-105 kolobrzeg      " ; 9
dc.b "           poland           " ; 10
dc.b "   graphican means answer   " ; 11
dc.b "                            " ; 12

dc.b "     fast & non elite       " ; 3
dc.b "       mailtrading          " ; 4
dc.b "    aga wares possible !    " ; 5
dc.b "                            " ; 6
dc.b "     freyon/storm           " ; 7
dc.b "     sebastina budzis       " ; 8
dc.b "     ul. a. struga 6        " ; 9
dc.b "     76-200 slupsk          " ; 10
dc.b "     poland                 " ; 11
dc.b "                            " ; 1
dc.b "  you don't have to worry   " ; 1
dc.b "  about my answer.....      " ; 2

dc.b "      groggy of storm       " ; 6
dc.b "                            " ; 7
dc.b "     one more contact ?     " ; 8
dc.b "     well.... why not ?     " ; 9
dc.b "                            " ; 10
dc.b "     tommy johansson        " ; 11
dc.b "     pilvagen 18 c          " ; 12
dc.b "     34176 ryssby           " ; 1
dc.b "     sweden                 " ; 2
dc.b "                            " ; 3
dc.b "answer? you know the rules? " ; 4
dc.b "                            " ; 5

dc.b "                            "
dc.b "                            "
dc.b "  for friendly swapping     "
dc.b "        + rave tape trading "
dc.b "                            "
dc.b "     duke of abyss          "
dc.b "     fr. bender str. 9      "
dc.b "     85402 kranzberg        "
dc.b "     germany                "
dc.b "                            "
dc.b "  hardcore will never die   "
dc.b "                            "

dc.b "                            " ; 1
dc.b "      fukk a letta 2        " ; 2
dc.b "     d-coy/giants whq       " ; 3
dc.b "                            " ; 4
dc.b "     tomas mortensen        " ; 5
dc.b "     hagergatan 140         " ; 6
dc.b "     692 36 kumla           " ; 7
dc.b "     sweden                 " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b " tits to all my contacts    " ; 11
dc.b "                            " ; 12

dc.b "                            " ; 1
dc.b "        4 swapping!         " ; 2
dc.b "                            " ; 3
dc.b "        stratos/qkd         " ; 4
dc.b "       -------------        " ; 5
dc.b "        tom haukland        " ; 6
dc.b "       skysetveien 1a       " ; 7
dc.b "        1481 hagan          " ; 8
dc.b "          norway            " ; 9
dc.b "                            " ; 10
dc.b "        0nly legal!!        " ; 11
dc.b "                            " ; 12

dc.b "    4 friendly swapping     " ; 1
dc.b "                            " ; 2
dc.b "          contact:          " ; 3
dc.b "                            " ; 4
dc.b "      javair/tmg            " ; 5
dc.b "                            " ; 6
dc.b "      jan chr. meyer        " ; 7
dc.b "      lehmsiek 1            " ; 8
dc.b "      25876 schwabstedt     " ; 9
dc.b "      germany               " ; 10
dc.b "                            " ; 11
dc.b "  letter and disc=answer    " ; 12

dc.b "    read da kewlest mag     " ; 2
dc.b "       in da scene!!!       " ; 3
dc.b "                            " ; 4
dc.b "        oepir risti         " ; 6
dc.b "                            " ; 7
dc.b "    c/o alvar andersson     " ; 8
dc.b "         halliden 2         " ; 9
dc.b "        436 39 askim        " ; 10
dc.b "           sweden           " ; 11
dc.b "                            " ; 12
dc.b "     all we want is your    " ; 1
dc.b "      support and ideas     " ; 2

;;texts
dc.b "                            " ; 1
dc.b "   the chiping forces are   " ; 2
dc.b "     back! (once again)     " ; 3
dc.b "                            " ; 4
dc.b "   caused by your! great    " ; 5
dc.b "response on diznee #3, here " ; 6
dc.b "  is the fourth edition of  " ; 7
dc.b " mem'o'ree & pinks abnormal " ; 8
dc.b "         chipsounds!        " ; 9
dc.b "                            " ; 10
dc.b "following text typed by pink" ; 11
dc.b "                          ->" ; 12

dc.b "first some words about the  " ; 1
dc.b "unnormal size of my ßchipß- " ; 2
dc.b "tunes in this issue:        " ; 3
dc.b "almost every tune is bigger " ; 4
dc.b "than 50kb and this is caused" ; 5
dc.b "by very big samps (really?!)" ; 6
dc.b "all instruments in diz tunes" ; 7
dc.b "were generated using        " ; 8
dc.b "pretracker(tm) v1.7beta.    " ; 9
dc.b "this prog calculates for you" ; 10
dc.b "c64-sid sounding samples.   " ; 11
dc.b "                          ->" ; 12

dc.b "if you pack this instruments" ; 1
dc.b "you get a pack ratio about  " ; 2
dc.b "80-95%. so i think there is " ; 3
dc.b "nothing against using this  " ; 4
dc.b "(lame?) method for creating " ; 5
dc.b "ßchipmodulesß.              " ; 6
dc.b "                            " ; 7
dc.b "but now 4 something more(?) " ; 8
dc.b "interresting.               " ; 9
dc.b "some information about the  " ; 10
dc.b "tunes in this issue:        " ; 11
dc.b "                          ->" ; 12

dc.b "  tunename: beyond voyage   " ; 1
dc.b "  -----------------------   " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "especially as moody intro-  " ; 5
dc.b "tune for diznee #4.         " ; 6
dc.b "using mixed hat+bass samples" ; 7
dc.b "(like j. hippel did in his  " ; 8
dc.b "ßlethal excessß maintune).  " ; 9
dc.b "by the way: jogeir liljedahl" ; 10
dc.b "has stolen this idea for his" ; 11
dc.b "ßlove-endtuneß too.       ->" ; 12

dc.b "      tunename: xality      " ; 1
dc.b "      ----------------      " ; 2
dc.b "original composed by laxity/" ; 3
dc.b "vibrants (c64). converted by" ; 4
dc.b "pink. i think this is a very" ; 5
dc.b "ßclose to the orignalßsound-" ; 6
dc.b "ding conversion (but only a " ; 7
dc.b "few patterns are taken out  " ; 8
dc.b "of da original song, sorry!)" ; 9
dc.b "it was a very easy conver-  " ; 10
dc.b "sion (only 1 hour) cause the" ; 11
dc.b "accords are more than simple" ; 12

dc.b "  tunename: classic tunes   " ; 1
dc.b "  -----------------------   " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "especially done 4 an intro  " ; 5
dc.b "by *classic*.               " ; 6
dc.b "hmmm....  nothing special at" ; 7
dc.b "all. simple bass, melody,   " ; 8
dc.b "drums and accords.          " ; 9
dc.b "sounds very c64-introtune   " ; 10
dc.b "like (hope so!).            " ; 11
dc.b "                          ->" ; 12

dc.b "    tunename: springtime    " ; 1
dc.b "    --------------------    " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "no! it's not a conversion!  " ; 5
dc.b "not my normal style but not " ; 6
dc.b "bad at all.                 " ; 7
dc.b "this tune is a little bit   " ; 8
dc.b "vibrants(c64) styled.       " ; 9
dc.b "(mr. petersen rulez!).      " ; 10
dc.b "using cia-timing for getting" ; 11
dc.b "slower arpeggios.         ->" ; 12

dc.b "tunename: hysteria 94-remix " ; 1
dc.b "--------------------------- " ; 2
dc.b "                            " ; 3
dc.b "orignal composed by f. gray " ; 4
dc.b "on c64. converted by pink.  " ; 5
dc.b "this conversion was a little" ; 6
dc.b "bit harder to get it 98%    " ; 7
dc.b "sounding like on c64.       " ; 8
dc.b "just decide by yourself if i" ; 9
dc.b "succeeded.notice that i used" ; 10
dc.b "only 4! instruments 2 finish" ; 11
dc.b "this song.                ->" ; 12

dc.b "    tunename: lsd-ninja     " ; 4
dc.b "    -------------------     " ; 5
dc.b "                            " ; 6
dc.b "original composed by pink.  " ; 7
dc.b "inspired by the ßlast ninjaß" ; 8
dc.b "triologie on c64.           " ; 9
dc.b "                            " ; 10
dc.b "maybe the worst tune on this" ; 11
dc.b "disk.                       " ; 12
dc.b "                            " ; 1
dc.b "                            " ; 2
dc.b "                          ->" ; 3

dc.b "  tunename: journey-part 2  " ; 1
dc.b "  ------------------------  " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "especially done for the pack" ; 5
dc.b "from movement called        " ; 6
dc.b "ßthe paqß (hi astro!).      " ; 7
dc.b "message 2 jozz/trsi:        " ; 8
dc.b "i hope u are satisfied with " ; 9
dc.b "this sequel of ßjourneyß !! " ; 10
dc.b "                            " ; 11
dc.b "                          ->" ; 12

dc.b "tunename: summertime-part 2 " ; 1
dc.b "--------------------------- " ; 2
dc.b "                            " ; 3
dc.b "original composed by        " ; 4
dc.b "laxity/vibrants (c64).      " ; 5
dc.b "not laxity's best tune but  " ; 6
dc.b "worth to convert!           " ; 7
dc.b "i think this is the longest " ; 8
dc.b "tune in this issue          " ; 9
dc.b "(length: 52 positions).     " ; 10
dc.b "                            " ; 11
dc.b "                          ->" ; 12

dc.b "this time mem'o'ree did only" ; 1
dc.b "two chiptunes (f9-f10) cause" ; 2
dc.b "he is was involved in some  " ; 3
dc.b "ßreal-musicß projects.      " ; 4
dc.b "maybe you hear something    " ; 5
dc.b "from him in the next issue! " ; 6
dc.b "                            " ; 7
dc.b "btw:  the next issue will   " ; 8
dc.b "not be called diznee 5!     " ; 9
dc.b "it's name is ßdiznee goldß! " ; 10
dc.b "it will be released at the  " ; 11
dc.b "party 4 in herning        ->" ; 12

dc.b "if you want to contact abyss" ; 1
dc.b "then meet us at the party 4!" ; 2
dc.b "                            " ; 3
dc.b "4 musical contacts write to:" ; 4
dc.b "                            " ; 5
dc.b "        pink/abyss          " ; 6
dc.b "           alias            " ; 7
dc.b "      manfred linzner       " ; 8
dc.b "    rupert-mayer-str. 6     " ; 9
dc.b "      81379 muenchen        " ; 10
dc.b "        - germany -         " ; 11
dc.b " bye,bye            urs pink" ; 12

;;greets
dc.b	"2fast of trsi               "                  
dc.b	"ace of trance inc.          "                      
dc.b	"action of energy            "
dc.b	"al bundy of jewels          "
dc.b	"andy of nuance              "
dc.b	"antex of control            "
dc.b	"astro of movement           "
dc.b	"apeman of anaheim           "
dc.b	"avenger of mad elks         "
dc.b	"axel f. of retire           "
dc.b	"backfire of applause        "
dc.b	"bbx of orion              ->"

dc.b	"boozio of the edge          "
dc.b	"bpm of simplex              "
dc.b	"candyman of sardonyx        "
dc.b	"celtic of mellow            "
dc.b	"cesium of balance           "
dc.b	"cetrix of freezers          "
dc.b	"chaos of desire             "
dc.b	"chitin of orion             "
dc.b	"chmiel of status o.k.       "
dc.b	"chris of iris               "
dc.b	"clever of tfd               "
dc.b	"colorbird of razor 1911   ->"

dc.b	"coma of dual format         "
dc.b	"condor of jewels            "                    
dc.b	"core of disaster            "
dc.b	"crazy-d of c-lous           "
dc.b	"crusader of depth           "
dc.b	"d-mage of vitual dreams     "
dc.b	"darkside of samba           "
dc.b	"distortion of storm         "
dc.b	"dose of trance              "
dc.b	"double r of intense         "
dc.b	"duffy of iris               "
dc.b	"facets pussy of desire    ->"

dc.b	"fake of equinox             "
dc.b	"felix of speedy             "
dc.b	"fiction of intense          "
dc.b	"flynn of outlaws            "
dc.b	"eightball of s!p            "
dc.b	"enzyme of saints            "
dc.b	"excel of freezers           "
dc.b	"gart of bronx               "
dc.b	"ghandy of rebels            "
dc.b	"gold dragon of unlimited    "
dc.b	"grand duke of diffusion     "
dc.b	"growl of fanatic          ->"

dc.b	"hazel of absolute!          "
dc.b	"hacksaw of chrome           "
dc.b	"howie of essence            "
dc.b	"hunter of boom design       "
dc.b	"izerman of s!p              "
dc.b	"ice cube of manitou         "
dc.b	"javair of tmg               "
dc.b	"kazz of bronx               "
dc.b	"killraven of dcs            "
dc.b	"klf of fate                 "
dc.b	"limbo of razor 1911         "
dc.b	"loony of divine           ->"

dc.b	"lord of absolute!           "
dc.b	"magz of speedy              "
dc.b	"m.a.s.e of ram jam          "
dc.b	"malarky(ind.)               "
dc.b	"maniac of cadaver           "
dc.b	"manik of dual format        "
dc.b	"melvin of scandal           "
dc.b	"mephi of damage             "
dc.b	"mephisto of retire          "
dc.b	"messerschmitt of s!p        "
dc.b	"messiah of eqiunox          "
dc.b	"mike of defiance          ->"

dc.b	"mop of essence              "
dc.b	"mr.keel of nova             "
dc.b	"mr.king of scoopex          "
dc.b	"napoleon of dreamdealers    "
dc.b	"naughty angel(ind.)         "
dc.b	"nick of offence             "
dc.b	"norby of trsi               "
dc.b	"nuke of manitou             "
dc.b	"onix of illegal             "
dc.b	"oxstone of spasm            "
dc.b	"paperboy of simplex         "
dc.b	"paze of rebels            ->"

dc.b	"peace of solitude           "
dc.b	"phuture of saints           "
dc.b	"poke of accession           "
dc.b	"purple haze                 "
dc.b	"python of trsi              "
dc.b	"qba of illusion             "
dc.b	"qwerty of scope             "
dc.b	"ravana of sepultura         "
dc.b	"rave of manitou             "
dc.b	"raze of fanatic             "
dc.b	"reactor of mystic           "
dc.b	"redman of mad elks        ->"

dc.b	"rip of manitou              "
dc.b	"sascha of applause          "
dc.b	"saturn of virtual           "
dc.b	"sir jinx of neoplasia       "
dc.b	"sonic flash of pulse        "
dc.b	"spacehawk of iris           "
dc.b	"spoky of analog             "
dc.b	"squirrel of progress        "
dc.b	"stc of hemoroids            "
dc.b	"sting of alcatraz           "
dc.b	"steffen of speedy           "
dc.b	"stratos of quick design   ->"

dc.b	"the hitcher of diffusion    "
dc.b	"the trader of fear          "
dc.b	"thor of nuance              "
dc.b	"tom of manitou              "
dc.b	"tos of silicon              "
dc.b	"trasher of sanity           "
dc.b	"tyrant of cadaver           "
dc.b	"ultra sur of metro          "
dc.b	"uyanik of trsi              "
dc.b	"vitrue of legacy            "
dc.b	"virus of arise              "
dc.b	"vodka of saturne          ->"

dc.b	"wea (ind.)                  "
dc.b	"wildcat of scania           "
dc.b	"wizard of infect            "
dc.b	"wotw of essence             "
dc.b	"yahoo of old bulls          "
dc.b	"zinko of polka brothers     "
dc.b	"                            "
dc.b	"                            "
dc.b	"   ...and to all sceners    "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
