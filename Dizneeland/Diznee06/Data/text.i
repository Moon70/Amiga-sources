;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;size=28*12
;						                  /\|-"
chars:	
dc.b	" abcdefghijklmnopqrstuvwxyz0123456789!?-:�.,()*#/=+'><%�&�\|@"
;�=big ball
charsend:
even
textpoint:	dc.w	0;	|
text:;				|


;;music
;	 1234567890123456789012345678
dc.b	"          musica            "
dc.b	"   name               length"
dc.b	"f1*diznee moods        97716"
dc.b	"f2 2 years crest       91470"
dc.b	"f3 last ninja moods    22816"
dc.b	"f4 deeper gates of doh 76498"
dc.b	"f5 mazemania           77576"
dc.b	"f6 gone too soon...   123060"
dc.b	"f7 enough memory?      28990"
dc.b	"f8 an apology          19738"
dc.b	"f9 backbackbackback    19702"
dc.b	"f0 time to forget      75832"

;;welcome
dc.b	"���� ��� ��  �  �  *   *    "
dc.b	"�                           "
dc.b	"�    diznee-land issue 6   *"
dc.b	"                            "
dc.b	"�                          *"
dc.b	"�     released in april     "
dc.b	"          1 9 9 5          �"
dc.b	"*                          �"
dc.b	"                            "
dc.b	"*    press help 4 help     �"
dc.b	"                           �"
dc.b	"    *   *  �  �  �� ��� ����"

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
dc.b	"    code by moon            "
dc.b	"                            "
dc.b	"    music:                  "
dc.b	"                            "
dc.b	"    f1-f5 by pink/abyss     "
dc.b	"    f6-f7 by luka/abyss     "
dc.b	"    f8-f9 by kb-zip/tesko   "
dc.b	"    f0    by aix/us         "
dc.b	"                          ->"

dc.b	"                            "
dc.b	"                            "
dc.b	"            gfx:            "
dc.b	"                            "
dc.b	"      main gfx by luka      "
dc.b	"                            "
dc.b	"     title pic by toxic     "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                          ->"

dc.b	"       *� write 2 �*        "
dc.b	"pink                        "
dc.b	"manfred linzner             "
dc.b	"rupert-mayer-str. 6         "
dc.b	"81379 muenchen              "
dc.b	"germany                     "
dc.b	"                            "
dc.b	"luka                        "
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
dc.b	"                            "
dc.b	"moon                        "
dc.b	"po box 162                  "
dc.b	"5400 hallein                "
dc.b	"austria                     "
dc.b	"                          ->"

dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"qwerty                      "
dc.b	"adrian dolny                "
dc.b	"62-850 liskow               "
dc.b	"woj.kaliskie                "
dc.b	"poland                      "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "


;;adverts
dc.b "                            "
dc.b "                            "
dc.b "      wanna see your        "
dc.b "       advert here?         "
dc.b "                            "
dc.b "     then send it to:       "
dc.b "       pink, toxic,         "
dc.b "       luka or moon         "
dc.b "                            "
dc.b "  *�>  size: 28*12  <�*     "
dc.b "                            "
dc.b "                            "

dc.b "  dr.avalanche of illusion  "
dc.b "     and bizarre arts!!     "
dc.b "                            "
dc.b "     rene kueppers          "
dc.b "     am kammerbusch 38      "
dc.b "     41812 erkelenz         "
dc.b "     germany                "
dc.b "                            "
dc.b "  for friendly gfx-swap!!   "
dc.b "fast greets: fadeone,kimba, "
dc.b "splatterhead,kurczak,radavi "
dc.b "tnt,dodger,fashion,pennie!! "

dc.b "                            "
dc.b "----------------------------"
dc.b "  flying cows incororation  "
dc.b "----------------------------"
dc.b "            zibi            "
dc.b "         okrzei  34         "
dc.b "        61406 poznan        "
dc.b "           poland           "
dc.b "----------------------------"
dc.b "  flying cows incororation  "
dc.b "----------------------------"
dc.b "                            "

dc.b "     for happy trading      "
dc.b "            try:            "
dc.b "                            "
dc.b "        fate/outlaws        "
dc.b "      thorbeckestr.13       "
dc.b "      6971 da brummen       "
dc.b "          holland           "
dc.b "                            "
dc.b "                            "
dc.b "      support my pack       "
dc.b "      called'bacardy'       "
dc.b "                            "

dc.b "                            "
dc.b "   contact:          i      "
dc.b "                     m      "
dc.b "    qwerty/abyss            "
dc.b "     adrian dolny    b      "
dc.b "      62-850 liskow  a      "
dc.b "       woj.kaliskie  c      "
dc.b "           poland    k      "
dc.b "                     !!!!   "
dc.b "  the deepest experience!   "
dc.b "                            "
dc.b "                            "

dc.b "                            "
dc.b "     why not swap with      "
dc.b "                            "
dc.b "        tft of iris         "
dc.b "      skaarabrekka 11       "
dc.b "       4370 egersund        "
dc.b "          norway            "
dc.b "                            "
dc.b "        (also vhs)          "
dc.b " fast greetz:pow,zany,mj,   "
dc.b " perry,evapour8er..the rest "
dc.b "                            "

dc.b "       for swapping!!!      "
dc.b "                            "
dc.b "       splatterhead of      "
dc.b "       triflex+addonic      "
dc.b "                            "
dc.b "       vesa kivisilta       "
dc.b "       lepolank.3 b 22      "
dc.b "       15210 lahti          "
dc.b "       finland              "
dc.b "                            "
dc.b "       disk(s)=answer       "
dc.b "                            "

dc.b " **�� felix of speedy ��**  "
dc.b "                            "
dc.b "    karsten l. fischer      "
dc.b "     gml.hovseterv 2d       "
dc.b "        0768  oslo          "
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
dc.b "        � manitou �         " ; 11
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
dc.b "after some years of no delay" ; 2
dc.b " we're back with some fresh " ; 3
dc.b " stuff for all brothers in  " ; 4
dc.b "   chip around da globe.    " ; 5
dc.b "                            " ; 6
dc.b " some special information:  " ; 7
dc.b "                            " ; 8
dc.b "    mem'o'ree renamed to    " ; 9
dc.b "                            " ; 10
dc.b "          l u k a           " ; 11
dc.b "                            " ; 12

dc.b "now (as always) some words 2" ; 1
dc.b "  the songs in this issue:  " ; 2
dc.b "      diznee moods:         " ; 3
dc.b "  especially composed as    " ; 4
dc.b "  introtune for issue #6    " ; 5
dc.b " this song consists of two  " ; 6
dc.b "parts. part one joins a nice" ; 7
dc.b " melody with simple chords  " ; 8
dc.b "and leads in2 the very short" ; 9
dc.b "     part two (sorry!).     " ; 10
dc.b "                            " ; 11
dc.b "original composed by: pink  " ; 12

dc.b "         mazemania          " ; 1
dc.b "                            " ; 2
dc.b "  covered from the classic  " ; 3
dc.b "m.o.n. tune. featuring some " ; 4
dc.b "  really interesting bass-  " ; 5
dc.b " lines and a groovy percus- " ; 6
dc.b " sion. really one of my fa- " ; 7
dc.b "   vourite m.o.n. tunes.    " ; 8
dc.b "                            " ; 9
dc.b "original composed by: m.o.n " ; 10
dc.b "     conversion by: pink    " ; 11
dc.b "                            " ; 12

dc.b "    deeper gates of doh:    " ; 1
dc.b "   nice arpeggios and some  " ; 2
dc.b " boring melodie. only a low " ; 3
dc.b "       budget tune.         " ; 4
dc.b "                            " ; 5
dc.b "     last ninja moods:      " ; 6
dc.b "based on various songs from " ; 7
dc.b " last ninja 1. i did this   " ; 8
dc.b "tune because i'm a big fan  " ; 9
dc.b "  of the ninja melodies     " ; 10
dc.b "                            " ; 11
dc.b "   both composed by: pink   " ; 12

dc.b "       2 years crest        " ; 1
dc.b "                            " ; 2
dc.b "once again a c64 conversion." ; 3
dc.b "this time taken from an old " ; 4
dc.b "'crest' demo.               " ; 5
dc.b "                            " ; 6
dc.b "original composed by: zardax" ; 7
dc.b " conversion & mix by: pink  " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "all songs are created using " ; 11
dc.b "    pretracker v1.7!!       " ; 12

dc.b "                            " ; 1
dc.b "       enough memory?       " ; 2
dc.b "                            " ; 3
dc.b "      yes, of course!       " ; 4
dc.b "   composed by luka alias   " ; 5
dc.b "        mem'o'ree!          " ; 6
dc.b "                            " ; 7
dc.b "      gone to soon...       " ; 8
dc.b "                            " ; 9
dc.b "  pretrackered by luka!     " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "     backbackbackback       " ; 1
dc.b "                            " ; 2
dc.b " composed by kb-zip/tesko   " ; 3
dc.b "                            " ; 4
dc.b "a really genius tune! enjoy " ; 5
dc.b "this extremly groovy song.  " ; 6
dc.b "                            " ; 7
dc.b "i hope more people will put " ; 8
dc.b " their creativity in pro-   " ; 9
dc.b "    ducing such tunes.      " ; 10
dc.b "                            " ; 11
dc.b "follin rules forever.....   " ; 12

dc.b "        an apology          " ; 1
dc.b "                            " ; 2
dc.b " composed by kb-zip/tesko   " ; 3
dc.b "                            " ; 4
dc.b "soul 2 chip.listen carefully" ; 5
dc.b "2 the not-standard chord and" ; 6
dc.b "melody changes.             " ; 7
dc.b "                            " ; 8
dc.b "many thanks r going 2 kb-zip" ; 9
dc.b "for supporting us with such " ; 10
dc.b "superb tunes. we hope 2 hear" ; 11
dc.b "more from u in da next issue" ; 12

dc.b "      time to forget        " ; 1
dc.b "                            " ; 2
dc.b "   composed by aix/us       " ; 3
dc.b "                            " ; 4
dc.b "da-dum la-da. lay back and  " ; 5
dc.b "relax. i like this special  " ; 6
dc.b "kind of module a much.      " ; 7
dc.b "                            " ; 8
dc.b "dna-warrior forever....     " ; 9
dc.b "                            " ; 10
dc.b "btw:  onyly pretracker      " ; 11
dc.b "     makes it possible!     " ; 12

dc.b "if you also want to take    " ; 1
dc.b "part in dizneeland, then    " ; 2
dc.b "write to:                   " ; 3
dc.b "                            " ; 4
dc.b "manfred linzner (pink)      " ; 5
dc.b "rupert-mayer-str. 6         " ; 6
dc.b "81379 muenchen              " ; 7
dc.b "-germany-                   " ; 8
dc.b "                            " ; 9
dc.b "also for buying pretracker  " ; 10
dc.b "or to get a free shareware- " ; 11
dc.b "version.                    " ; 12

dc.b "some pink greetings:        " ; 1
dc.b "                            " ; 2
dc.b "jozz/trsi (tunes 4 diznee?) " ; 3
dc.b "smc/haujobb (next time??)   " ; 4
dc.b "aix/us (thanks eric!)       " ; 5
dc.b "aquafresh/lsd               " ; 6
dc.b "marvin/lasol                " ; 7
dc.b "rahiem/us                   " ; 8
dc.b "astro/movement              " ; 9
dc.b "tice/lego(i'm still waiting)" ; 10
dc.b "                            " ; 11
dc.b "   see u all in diznee 7    " ; 12



;;greets
dc.b "2fast of trsi               " ; 1
dc.b "4 t thieves of alcatraz     " ; 2
dc.b "ace of trance inc.          " ; 3
dc.b "action of energy            " ; 4
dc.b "al bundy of jewels          " ; 5
dc.b "andy of essence             " ; 6
dc.b "animal of union             " ; 7
dc.b "antex of control            " ; 8
dc.b "apeman of anaheim           " ; 9
dc.b "archmage of andromeda       " ; 10
dc.b "astro of movement           " ; 11
dc.b "atheist of freezers         " ; 12

dc.b "avenger of mad elks         " ; 1
dc.b "axel f. of retire           " ; 2
dc.b "backfire of applause        " ; 3
dc.b "bald horse of trsi          " ; 4
dc.b "bbx of orion                " ; 5
dc.b "bfa of suspect              " ; 6
dc.b "bigman of vision soft.      " ; 7
dc.b "bob of scope                " ; 8
dc.b "bodzio of the edge          " ; 9
dc.b "bpm of simplex              " ; 10
dc.b "candyman of giants          " ; 11
dc.b "celtic of mellow            " ; 12

dc.b "cesium of balance           " ; 1
dc.b "cetrix of freezers          " ; 2
dc.b "chaos of desire             " ; 3
dc.b "chitin of orion             " ; 4
dc.b "chmiel of status o.k.       " ; 5
dc.b "chris of iris               " ; 6
dc.b "chromag of polka brothers   " ; 7
dc.b "clever of tfd               " ; 8
dc.b "colorbird of razor 1911     " ; 9
dc.b "coma of dual format         " ; 10
dc.b "condor of jewels            " ; 11
dc.b "core of disaster            " ; 12

dc.b "cougar of sanity            " ; 1
dc.b "crazy-d of c-lous           " ; 2
dc.b "crusader of depth           " ; 3
dc.b "d-mage of vitual dreams     " ; 4
dc.b "dalmak of stellar           " ; 5
dc.b "darkside of samba           " ; 6
dc.b "derk of obsession           " ; 7
dc.b "device of infect            " ; 8
dc.b "devilstar of virtual d.     " ; 9
dc.b "disty of storm              " ; 10
dc.b "dose of trance              " ; 11
dc.b "double r of intense         " ; 12

dc.b "dr.jekyll of andromeda      " ; 1
dc.b "dreamer of tpdl             " ; 2
dc.b "duffy of iris               " ; 3
dc.b "easy of focus design        " ; 4
dc.b "eightball of s!p            " ; 5
dc.b "enzyme of saints            " ; 6
dc.b "excel of freezers           " ; 7
dc.b "exciter of rebels           " ; 8
dc.b "exolon of tilt              " ; 9
dc.b "facet of spaceballs         " ; 10
dc.b "facets pussy of desire      " ; 11
dc.b "fake of equinox             " ; 12

dc.b "fashion of static bytes     " ; 1
dc.b "fate of outlaws             " ; 2
dc.b "felix of speedy             " ; 3
dc.b "fiction of intense          " ; 4
dc.b "flynn of nuance             " ; 5
dc.b "fugazi of disorder          " ; 6
dc.b "gart of bronx               " ; 7
dc.b "gato of stearoid            " ; 8
dc.b "ghandy of rebels            " ; 9
dc.b "gold dragon of unlimited    " ; 10
dc.b "goocioo of mayhem           " ; 11
dc.b "grand duke of diffusion     " ; 12

dc.b "growl of fanatic            " ; 1
dc.b "gunmn of mystic             " ; 2
dc.b "hacksaw of chrome           " ; 3
dc.b "hazel of absolute!          " ; 4
dc.b "hijack of parallax          " ; 5
dc.b "howie of essence            " ; 6
dc.b "hunter of boom design       " ; 7
dc.b "ice cube of manitou         " ; 8
dc.b "interphase of andromeda     " ; 9
dc.b "irek p. of union            " ; 10
dc.b "iron of scope               " ; 11
dc.b "izerman of s!p              " ; 12

dc.b "javair of tmg               " ; 1
dc.b "jezo of mystic              " ; 2
dc.b "joy of freezers             " ; 3
dc.b "kazz of bronx               " ; 4
dc.b "killraven of dcs            " ; 5
dc.b "klf of fate                 " ; 6
dc.b "kopara of mad elks          " ; 7
dc.b "kurczak of fci              " ; 8
dc.b "lenin of freezers           " ; 9
dc.b "lenny of gel dezign         " ; 10
dc.b "limbo of razor 1911         " ; 11
dc.b "loony of divine             " ; 12

dc.b "lord of absolute!           " ; 1
dc.b "m.a.s.e of ram jam          " ; 2
dc.b "magz of speedy              " ; 3
dc.b "malarky(ind.)               " ; 4
dc.b "maniac of cadaver           " ; 5
dc.b "manik of dual format        " ; 6
dc.b "mars of mystic              " ; 7
dc.b "melvin of rebels            " ; 8
dc.b "mephi of damage             " ; 9
dc.b "mephisto of retire          " ; 10
dc.b "messerschmitt of ram jam    " ; 11
dc.b "messiah of eqiunox          " ; 12

dc.b "metal of funzine            " ; 1
dc.b "michael of anathema         " ; 2
dc.b "mike of defiance            " ; 3
dc.b "mop of essence              " ; 4
dc.b "motion of balance           " ; 5
dc.b "mr.hyde of andromeda        " ; 6
dc.b "mr.keel of nova             " ; 7
dc.b "mr.king of trsi             " ; 8
dc.b "mr.root of union            " ; 9
dc.b "musashi of union            " ; 10
dc.b "mystra of stone arts        " ; 11
dc.b "napoleon of dreamdealers    " ; 12

dc.b "naughty angel               " ; 1
dc.b "nick of offence             " ; 2
dc.b "nighthawk of rebels         " ; 3
dc.b "norby of trsi               " ; 4
dc.b "nuke of manitou             " ; 5
dc.b "onix of illegal             " ; 6
dc.b "orion of masque             " ; 7
dc.b "oxstone of spasm            " ; 8
dc.b "pace of complex             " ; 9
dc.b "pagan                       " ; 10
dc.b "paperboy of simplex         " ; 11
dc.b "paze of rebels              " ; 12

dc.b "peace of solitude           " ; 1
dc.b "phuture of saints           " ; 2
dc.b "poke of accession           " ; 3
dc.b "pride of stellar            " ; 4
dc.b "purple haze                 " ; 5
dc.b "python of tpdl              " ; 6
dc.b "qba of trsi                 " ; 7
dc.b "ra of sanity                " ; 8
dc.b "ravana of ?                 " ; 9
dc.b "rave of manitou             " ; 10
dc.b "raze of fanatic             " ; 11
dc.b "reactor of mystic           " ; 12

dc.b "redman of mad elks          " ; 1
dc.b "rip of manitou              " ; 2
dc.b "rocketeer of ram jam        " ; 3
dc.b "roscoe of ?                 " ; 4
dc.b "sascha of mirage            " ; 5
dc.b "saturn of virtual           " ; 6
dc.b "scorpik of picco            " ; 7
dc.b "sir jinx of neoplasia       " ; 8
dc.b "siracon of defiance         " ; 9
dc.b "sonic flash of pulse        " ; 10
dc.b "spacehawk of iris           " ; 11
dc.b "spoky of analog             " ; 12

dc.b "squirrel of progress        " ; 1
dc.b "stan of illusion            " ; 2
dc.b "stc of hemoroids            " ; 3
dc.b "steady of majic 12          " ; 4
dc.b "steffen of speedy           " ; 5
dc.b "sting of alcatraz           " ; 6
dc.b "stratos of quick design     " ; 7
dc.b "substance of saints         " ; 8
dc.b "supernao of spaceballs      " ; 9
dc.b "taurus od trsi              " ; 10
dc.b "teevan of rebels            " ; 11
dc.b "the hitcher of diffusion    " ; 12

dc.b "the trader of fear          " ; 1
dc.b "the trickster of s!p        " ; 2
dc.b "thor of nuance              " ; 3
dc.b "timeless of urgh!           " ; 4
dc.b "tom of manitou              " ; 5
dc.b "tom of tpdl                 " ; 6
dc.b "tos of silicon              " ; 7
dc.b "trader of fear              " ; 8
dc.b "trash head of mystic        " ; 9
dc.b "trasher of sanity           " ; 10
dc.b "tyrant of cadaver           " ; 11
dc.b "ultra sur of metro          " ; 12

dc.b "uyanik of trsi              " ; 1
dc.b "vaxine of orbital           " ; 2
dc.b "view of andromeda           " ; 3
dc.b "vin of cadaver              " ; 4
dc.b "virus of arise              " ; 5
dc.b "vitrue of legacy            " ; 6
dc.b "vodka of saturne            " ; 7
dc.b "warhawk of obsession        " ; 8
dc.b "watts of dual 4mat          " ; 9
dc.b "wea (ind.)                  " ; 10
dc.b "wildcat of scania           " ; 11
dc.b "wizard of infect            " ; 12

dc.b "wolfman of balance          " ; 1
dc.b "woober of saints            " ; 2
dc.b "wotw of essence             " ; 3
dc.b "xenos of scope              " ; 4
dc.b "yahoo of old bulls          " ; 5
dc.b "zinko of polka brothers     " ; 6
dc.b "                            " ; 7
dc.b "                            " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "   ...and to all sceners    " ; 11
dc.b "                            " ; 12

