����                                        s:
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
dc.b	"f1*terraforming        57870"
dc.b	"f2 inner voyage         9264"
dc.b	"f3 eclipse             35104"
dc.b	"f4 cradle of the future42504"
dc.b	"f5 afternoon voyage ii 37622"
dc.b	"f6 fo(o)llin around    12844"
dc.b	"f7 alleyway chat       49652"
dc.b	"f8 exoneration         12568"
dc.b	"f9 steel breeze        18020"
dc.b	"f0 through the riots    9524"

;;welcome
dc.b	"���� ��� ��  �  �  *   *    "
dc.b	"�                           "
dc.b	"�                          *"
dc.b	"    diznee-land issue 8     "
dc.b	"�                          *"
dc.b	"�                           "
dc.b	"       december 1995       �"
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
dc.b	"    music by pink           "
dc.b	"                            "
dc.b	"    main gfx by luka        "
dc.b	"                            "
dc.b	"    title pic by toxic      "
dc.b	"                            "
dc.b	"                          ->"

dc.b	"       contact us at:       "
dc.b	"      ----------------      "
dc.b	"                            "
dc.b	"        neurodancer         "
dc.b	"                            "
dc.b	"      highvolt.gun.de       "
dc.b	"                            "
dc.b	"            bbs:            "
dc.b	"                            "
dc.b	"      �  the ambush  �      "
dc.b	"    � +49-08621-64260  �    "
dc.b	"                          ->"

dc.b	"sting                       "
dc.b	"dirk dallmann               "
dc.b	"steinfurthstr.12            "
dc.b	"45884 gelsenkirchen         "
dc.b	"germany                     "
dc.b	"                            "
dc.b	"                            "
dc.b	"pink                        "
dc.b	"manfred linzner             "
dc.b	"rupert-mayer-str. 6         "
dc.b	"81379 muenchen              "
dc.b	"germany                   ->"

dc.b	"moon                        "
dc.b	"po box 162                  "
dc.b	"5400 hallein                "
dc.b	"austria                     "
dc.b	"                            "
dc.b	"                            "
dc.b	"qwerty                      "
dc.b	"adrian dolny                "
dc.b	"62-850 liskow               "
dc.b	"woj.kaliskie                "
dc.b	"poland                      "
dc.b	"                            "


;;adverts
dc.b "                            "
dc.b "                            "
dc.b "       wanna see your       "
dc.b "        advert here?        "
dc.b "                            "
dc.b "      then send it to       "
dc.b "        pink or moon        "
dc.b "                            "
dc.b "                            "
dc.b "   *�>  size: 28*12  <�*    "
dc.b "                            "
dc.b "                            "

;-----
dc.b "  felix/massive & avocado   "
dc.b "                            "
dc.b "    karsten lange fischer   "
dc.b "     gamle hovseterv 2d     "
dc.b "         o768  oslo         "
dc.b "           norway           "
dc.b "                            "
dc.b "  here  is your everlasting "
dc.b "    and  reliable contact   "
dc.b "                            "
dc.b "   this address is for all  "
dc.b "  kinda friendship swapping "

dc.b "                            "
dc.b "         �  neo  �          "
dc.b "                            "
dc.b "   ! for pure friendship !  "
dc.b "                            "
dc.b "         enzyme/neo         "
dc.b "      koelentajankatu 1     "
dc.b "        33900 tampere       "
dc.b "          finland           "
dc.b "                            "
dc.b "     100% reply to all      "
dc.b "                            "

dc.b "  a   v   o   c   a   d  o  "
dc.b "     we are looking for     "
dc.b "     more coders + gfxs     "
dc.b "     swappers  to  join     "
dc.b "     feel high to write     "
dc.b "                            "
dc.b "     substance**avocado     "
dc.b "     urheilijanp.6 as13     "
dc.b "       33720  tampere       "
dc.b "          finland           "
dc.b "                            "
dc.b "     *� aga required �*     "

dc.b "                            "
dc.b " for a fast & friendly swap "
dc.b "                            "
dc.b " devistator/eltech*twisted! "
dc.b "     9 leaholme gardens     "
dc.b "         whitchurch         "
dc.b "          bristol           "
dc.b "          bs14 olq          "
dc.b "        e.n.g.l.a.n.d       "
dc.b "                            "
dc.b " ---->  overseas only  <----"
dc.b "                            "

dc.b "you need thrill, adventure  "
dc.b "and fear ? you love to risc "
dc.b "your live? you need mystery?"
dc.b " so if you dare-contact me: "
dc.b "         sunny/act          "
dc.b "        sonja felber        "
dc.b "       alemannenstr.1       "
dc.b "      78315 radolfzell      "
dc.b "           germany          "
dc.b "                            "
dc.b "        but remember        "
dc.b " curiosity killed the cat ! "

dc.b "*=--                    --=*"
dc.b "          contact           "
dc.b "        thrym / neo         "
dc.b "     for fast swapping!     "
dc.b "     modules and normal     "
dc.b "       elite-swapping       "
dc.b "----------------------------"
dc.b "         espen fossen       "
dc.b "         hyllbergv.7        "
dc.b "         7520 hegra         "
dc.b "           norway           "
dc.b "----------------------------"

dc.b "     wanna join avocado     "
dc.b "        in germany ?        "
dc.b "                            "
dc.b "    easy if youre a good    "
dc.b "  coder/graphician/swapper  "
dc.b "                            "
dc.b "       base / avocado       "
dc.b "       postfach  1102       "
dc.b "       24585  nortorf       "
dc.b "          germany           "
dc.b "                            "
dc.b "     *� aga required �*     "


dc.b "                            "
dc.b "     ------------------     "
dc.b "                            "
dc.b "       sting / abyss        "
dc.b "       dirk dallmann        "
dc.b "     steinfurthstr. 12      "
dc.b "    45884 gelsenkirchen     "
dc.b "         germany            "
dc.b "                            "
dc.b "     ------------------     "
dc.b "   the deepest experience   "
dc.b "                            "

dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "          randy/neo         "
dc.b "        robert ekberg       "
dc.b "          ymersg. 2         "
dc.b "       s-941 51 pitea       "
dc.b "           sweden!          "
dc.b "                            "
dc.b "                            "
dc.b "                            "
dc.b "                            "

dc.b "----------------------------"
dc.b "      payday / freezers!    "
dc.b "----------------------------"
dc.b "for the best of swapping try"
dc.b "                            "
dc.b "                            "
dc.b "      payday / freezers     "
dc.b "        badstrandsv.6       "
dc.b "      s-136 49  haninge     "
dc.b "            sweden          "
dc.b "                            "
dc.b "----------------------------"

dc.b "                            "
dc.b "----------------------------"
dc.b "          why not?          "
dc.b "                            "
dc.b "  mindphaser/freezers       "
dc.b "  snackstigen 2             "
dc.b "  58258 linkoping           "
dc.b "  sweden                    "
dc.b "                            "
dc.b "     only for friendly      "
dc.b "     and lazy trading       "
dc.b "----------------------------"

dc.b "     wanna join avocado     "
dc.b "        in norway ?         "
dc.b "    easy if youre a good    "
dc.b "  coder/graphician/swapper  "
dc.b "                            "
dc.b "       felix**avocado       "
dc.b "     karsten l. fischer     "
dc.b "      gml.hovseterv.2d      "
dc.b "         0768  oslo         "
dc.b "           norway           "
dc.b "                            "
dc.b "     *� aga required �*     "

dc.b "----------------------------"
dc.b " yo! do u wanna swap latesz "
dc.b "   on amy + mpegs & othas   "
dc.b "     also with beginnas!    "
dc.b "                            "
dc.b "splatterhead/scoopex+fanatic"
dc.b "           pl 62            "
dc.b "   fin - 15141 lahti        "
dc.b "          finland        '95"
dc.b "                            "
dc.b "    disk(s)+letta = reply   "
dc.b "----------------------------"

dc.b "..tristar and red sector inc"
dc.b "........                    "
dc.b "...|..... friendship'n'elite"
dc.b "---+-------- mail-trading:  "
dc.b "   |                        "
dc.b "   |      norby of trsi     "
dc.b "   |       p.o. box 20      "
dc.b "          56-300 milicz   | "
dc.b "             poland       | "
dc.b "                          | "
dc.b "send your support for ----+-"
dc.b "'it' mag-pack by trsi     | "

dc.b "    get in touch with da    "
dc.b "    best around             "
dc.b "                            "
dc.b "     crack of neo(nhq)      "
dc.b "     thomas hoven           "
dc.b "     hyllbergvn.22          "
dc.b "     7520 hegra             "
dc.b "     norway                 "
dc.b "                            "
dc.b "      swap,module swap,     "
dc.b "      and for joining.      "
dc.b "                            "

dc.b "                            "
dc.b "      for swapping          "
dc.b "      try this shortie:     "
dc.b "                            "
dc.b "      crack/neo (nhq)       "
dc.b "      hyllbergvn.22         "
dc.b "      7520 hegra            "
dc.b "      norway                "
dc.b "                            "
dc.b "      also for joining!     "
dc.b "                            "
dc.b "                            "

;-----

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

dc.b "                     i      "
dc.b "   contact:          m      "
dc.b "                            "
dc.b "    qwerty/abyss     b      "
dc.b "     adrian dolny    a      "
dc.b "      62-850 liskow  c      "
dc.b "       woj.kaliskie  k      "
dc.b "           poland    !!!!   "
dc.b "                        !   "
dc.b " !the deepest experience!   "
dc.b " !                          "
dc.b " !!!!!!!!!                  "

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

dc.b "     wanna join avocado     "
dc.b "        in austria ?        "
dc.b " it's easy if you're a good "
dc.b "  coder/graphician/swapper  "
dc.b "                            "
dc.b "                            "
dc.b "     moon/abyss+avocado     "
dc.b "         po-box 162         "
dc.b "        5400 hallein        "
dc.b "          austria           "
dc.b "                            "
dc.b "     *� aga required �*     "

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
dc.b "                            " ; 2
dc.b " sometimes they chip back!  " ; 3
dc.b "                            " ; 4
dc.b "                            " ; 5
dc.b " after many chipless weeks  " ; 6
dc.b "  dizneeland no. 8 is now   " ; 7
dc.b "ready 2 bring you once again" ; 8
dc.b "   the feeling of good'ol   " ; 9
dc.b "      synthetic-music.      " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "something new has happen in " ; 1
dc.b "the land of diznee. from now" ; 2
dc.b "on, dizneeland supports also" ; 3
dc.b "'art of noise' modules.     " ; 4
dc.b "                            " ; 5
dc.b "this means:                 " ; 6
dc.b "- smaller tune size         " ; 7
dc.b "- better quality            " ; 8
dc.b "- new effects!              " ; 9
dc.b "                            " ; 10
dc.b "but there will be also the  " ; 11
dc.b "'normal' pretracker-tunes!  " ; 12

dc.b "some facts about the mods:  " ; 1
dc.b "                            " ; 2
dc.b "terraforming:               " ; 3
dc.b "-------------               " ; 4
dc.b "                            " ; 5
dc.b "originally done for some    " ; 6
dc.b "trsi intro.                 " ; 7
dc.b "simple but pushing-         " ; 8
dc.b "no further comment.         " ; 9
dc.b "                            " ; 10
dc.b "format: protracker          " ; 11
dc.b "                            " ; 12

dc.b "inner voyage:               " ; 1
dc.b "-------------               " ; 2
dc.b "                            " ; 3
dc.b "smooth and moody. the only  " ; 4
dc.b "bad thing on this tune is   " ; 5
dc.b "its duration...             " ; 6
dc.b "to get the tune as small as " ; 7
dc.b "possible, i used only       " ; 8
dc.b "fm-drums. (wicked, eh?)     " ; 9
dc.b "                            " ; 10
dc.b "format: art of noise        " ; 11
dc.b "                            " ; 12

dc.b "eclipse:                    " ; 1
dc.b "--------                    " ; 2
dc.b "                            " ; 3
dc.b "my 1st song created with    " ; 4
dc.b "pretracker. curiously it was" ; 5
dc.b "never released.             " ; 6
dc.b "don't blame me for the crazy" ; 7
dc.b "lead-performance, coz' this " ; 8
dc.b "song is about 1 year old.   " ; 9
dc.b "                            " ; 10
dc.b "format: protracker          " ; 11
dc.b "                            " ; 12

dc.b "cradle of the future:       " ; 1
dc.b "---------------------       " ; 2
dc.b "                            " ; 3
dc.b "really a special one. this  " ; 4
dc.b "songs uses the special      " ; 5
dc.b "features of 'aon' to get    " ; 6
dc.b "some smooth and not c64     " ; 7
dc.b "sounding synths.            " ; 8
dc.b "                            " ; 9
dc.b "format: art of noise        " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "afternoon voyage ii:        " ; 1
dc.b "--------------------        " ; 2
dc.b "                            " ; 3
dc.b "especially done for an abyss" ; 4
dc.b "intro wich was coded for    " ; 5
dc.b "�the prodigy�.              " ; 6
dc.b "fast & freaky. mixes nice   " ; 7
dc.b "arpreggios with a technolike" ; 8
dc.b "synth bassline.             " ; 9
dc.b "                            " ; 10
dc.b "format: protracker          " ; 11
dc.b "                            " ; 12

dc.b "fo(o)lin around:            " ; 1
dc.b "----------------            " ; 2
dc.b "                            " ; 3
dc.b "inspired by the ghouls &    " ; 4
dc.b "ghosts soundtrack by tim    " ; 5
dc.b "follin. everything but the  " ; 6
dc.b "intropart was composed by   " ; 7
dc.b "myself. wicked!!            " ; 8
dc.b "                            " ; 9
dc.b "format: art of noise        " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "alleyway chat:              " ; 1
dc.b "--------------              " ; 2
dc.b "                            " ; 3
dc.b "done for �das efx� for there" ; 4
dc.b "snes cracktro.              " ; 5
dc.b "really one of my favourite  " ; 6
dc.b "tunes in this issue.        " ; 7
dc.b "                            " ; 8
dc.b "format: protracker          " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "exoneration:                " ; 1
dc.b "------------                " ; 2
dc.b "                            " ; 3
dc.b "15 years back in time.      " ; 4
dc.b "this tune is covered from   " ; 5
dc.b "the great �captain future�  " ; 6
dc.b "soundtrack.                 " ; 7
dc.b "maybe some more tunes from  " ; 8
dc.b "c.f. will be converted!     " ; 9
dc.b "                            " ; 10
dc.b "format: art of noise        " ; 11
dc.b "                            " ; 12

dc.b "steel breeze:               " ; 1
dc.b "-------------               " ; 2
dc.b "                            " ; 3
dc.b "adlib?                      " ; 4
dc.b "hmmm.. a little bit boring. " ; 5
dc.b "enjoy da really smooth lead " ; 6
dc.b "performance (in adlib style)" ; 7
dc.b "                            " ; 8
dc.b "format: art of noise        " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "trough the riots:           " ; 1
dc.b "-----------------           " ; 2
dc.b "                            " ; 3
dc.b "some little synthetic hymn. " ; 4
dc.b "                            " ; 5
dc.b "format: art of noise        " ; 6
dc.b "                            " ; 7
dc.b "                            " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "all songs composed by pink. " ; 2
dc.b "                            " ; 3
dc.b "contact me for anything     " ; 4
dc.b "about music:                " ; 5
dc.b "                            " ; 6
dc.b "manfred linzner             " ; 7
dc.b "rupert-mayer-str. 6         " ; 8
dc.b "81379 muenchen              " ; 9
dc.b "-germany-                   " ; 10
dc.b "                            " ; 11
dc.b " - see you at the pardy 5 - " ; 12
dc.b "                            " ; 1

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
dc.b "bad cat of italian bad boys "
dc.b "bald horse of trsi          " ; 4
dc.b "bbx of orion                " ; 5
dc.b "bfa of suspect              " ; 6
dc.b "bigman of vision soft.      " ; 7
dc.b "bob of scope                " ; 8
dc.b "bodzio of the edge          " ; 9
dc.b "bpm of simplex              " ; 10
dc.b "candyman of giants          " ; 11

dc.b "celtic of axis              " ; 12
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
dc.b "devilstar of virtual dreams " ; 9
dc.b "disty of storm              " ; 10
dc.b "dose of trance              " ; 11

dc.b "double r of intense         " ; 12
dc.b "dr.jekyll of andromeda      " ; 1
dc.b "dreamer of tpdl             " ; 2
dc.b "duffy of iris               " ; 3
dc.b "easy of focus design        " ; 4
dc.b "eightball of s!p            " ; 5
dc.b "enzyme of neo+avocado       " ; 6
dc.b "excel of freezers           " ; 7
dc.b "exciter of rebels           " ; 8
dc.b "exolon of tilt              " ; 9
dc.b "facet of spaceballs         " ; 10
dc.b "facets pussy of desire      " ; 11

dc.b "fake of equinox             " ; 12
dc.b "fashion of static bytes     " ; 1
dc.b "fate of outlaws             " ; 2
dc.b "felix of massive+avocado    " ; 3
dc.b "fiction of intense          " ; 4
dc.b "flynn of nuance             " ; 5
dc.b "fugazi of disorder          " ; 6
dc.b "gart of bronx               " ; 7
dc.b "gato of stearoid            " ; 8
dc.b "ghandy of gods              " ; 9
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
dc.b "miko63 of iris              "
dc.b "mj of iris                  "
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
dc.b "steffen of parasite         " ; 5
dc.b "stratos of quick design     " ; 7
dc.b "substance of rno+avocado    " ; 8
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
dc.b "woober of technology        " ; 2
dc.b "wotw of essence             " ; 3
dc.b "xenos of scope              " ; 4
dc.b "yahoo of old bulls          " ; 5
dc.b "zinko of polka brothers     " ; 6
dc.b "                            " ; 7
dc.b "   ...and to all sceners    " ; 11
dc.b "                            " ; 8
dc.b "                            " ; 10
dc.b "                            " ; 10
dc.b "                            " ; 10

