����  9�                                    ;------------------------------------------------------------------------
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
dc.b	"f1*sweet seduction     91296"
dc.b	"f2 led storm           42672"
dc.b	"f3 personal fairlights 86650"
dc.b	"f4 bionic impressions 152254"
dc.b	"f5 just to funk        37076"
dc.b	"f6 kunitokys theme     70162"
dc.b	"f7 walk a bout-remix   76032"
dc.b	"f8 mr.delay is back ?  25612"
dc.b	"f9 chippy story remix  31048"
dc.b	"f0 lament for atlantis 82516"

;;welcome
dc.b	"�\�\�\�\�\�\�\�\�\�\�\�\�\�\"
dc.b	"\                          �"
dc.b	"�    diznee-land  gold     \"
dc.b	"\       (issue no.5)       �"
dc.b	"�                          \"
dc.b	"\   released at party 4    �"
dc.b	"�         1 9 9 4          \"
dc.b	"\                          �"
dc.b	"�                          \"
dc.b	"\    press help 4 help     �"
dc.b	"�                          \"
dc.b	"\�\�\�\�\�\�\�\�\�\�\�\�\�\�"

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
dc.b	"       f1-f7 by pink        "
dc.b	"       f8-f0 by mem'o'ree   "
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

dc.b	"       *� write 2 �*        "
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
dc.b "  *�>  size: 28*12  <�*     "
dc.b "                            "
dc.b "  don't forget to vote for  "
dc.b "  the swap'n'dance charts!  "
dc.b "     votesheet on disc!     "

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
dc.b "      diznee-land gold      " ; 1
dc.b "         -issue 5-          " ; 2
dc.b "            or              " ; 3
dc.b " the most stressed guys in  " ; 4
dc.b " the amiga scene are back!  " ; 5
dc.b " -------------------------  " ; 6
dc.b "the abyss picknickforces did" ; 7
dc.b "it once again.brillant code," ; 8
dc.b "genius grafix and some lousy" ; 9
dc.b "music found its way to your " ; 10
dc.b "'girlfriend'. this is da    " ; 11
dc.b "first time that diznee-land " ; 12

dc.b "was released two times a    " ; 1
dc.b "month. we decided to release" ; 2
dc.b "the january issue at the    " ; 3
dc.b "party iv in denmark.        " ; 4
dc.b "                            " ; 5
dc.b "also another dream has come " ; 6
dc.b "true. >> pretracker 1.5 <<  " ; 7
dc.b "<<< first public version >>>" ; 8
dc.b "                            " ; 9
dc.b "this fantastic programm     " ; 10
dc.b "which was used to create    " ; 11
dc.b "almost every instrument you " ; 12

dc.b "hear in diznee-land is now  " ; 1
dc.b "available 4 every chipmusi- " ; 2
dc.b "cian. just contact me (pink)" ; 3
dc.b "under the address at the end" ; 4
dc.b "of this text.               " ; 5
dc.b "                            " ; 6
dc.b "                            " ; 7
dc.b "now  some words about       " ; 8
dc.b "the actual diznee-tunes:    " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "      sweet seduction       " ; 1
dc.b "      ---------------       " ; 2
dc.b "original composed by pink   " ; 3
dc.b "especially done as introtune" ; 4
dc.b "for this issue. i used in   " ; 5
dc.b "this mods some special      " ; 6
dc.b "technics to create the      " ; 7
dc.b "powerful drums. they're     " ; 8
dc.b "using fm-modulations and    " ; 9
dc.b "white-noise together on     " ; 10
dc.b "two channels. sounds really " ; 11
dc.b "different to my normal kind " ; 12

dc.b "of snaredrums.              " ; 1
dc.b " (i'm cool, am i?).         " ; 2
dc.b "(yep, we all love you! ed.) " ; 3
dc.b "                            " ; 4
dc.b "         led storm          " ; 5
dc.b "         ---------          " ; 6
dc.b "covered by pink. original   " ; 7
dc.b "composed by tim follin      " ; 8
dc.b "on c64. tim follin is really" ; 9
dc.b "one of the best muscians in " ; 10
dc.b "time. covering his tunes is " ; 11
dc.b "really a pleasure!          " ; 12

dc.b "    personal fairlights     " ; 1
dc.b "    -------------------     " ; 2
dc.b "covered and remixed by pink." ; 3
dc.b "original composed by laxity " ; 4
dc.b "of vibrants on c64. laxity  " ; 5
dc.b "hasn't composed this 100% at" ; 6
dc.b "his own. it was just a      " ; 7
dc.b "cover-version of an xtremly " ; 8
dc.b "old tune from the           " ; 9
dc.b "'dungeon master(?)'. he     " ; 10
dc.b "remixed this tune into a    " ; 11
dc.b "groovy 'disco song'.        " ; 12

dc.b "     bionic impressions     " ; 1
dc.b "     ------------------     " ; 2
dc.b "                            " ; 3
dc.b "covered & remixed by pink.  " ; 4
dc.b "original composed by tim    " ; 5
dc.b "follin on c64. this module  " ; 6
dc.b "consits of three sub-songs. " ; 7
dc.b "                            " ; 8
dc.b "btw: tim follins arpeggios  " ; 9
dc.b "are really hard to find     " ; 0
dc.b "out.. puh.                  " ; 11
dc.b "                            " ; 12

dc.b "        just to funk        " ; 1
dc.b "        ------------        " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "some funky stuff! really a  " ; 5
dc.b "simple tune but who cares?  " ; 6
dc.b "contains some nice(&new?)   " ; 7
dc.b "lead instruments.           " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "       kunitokys theme      " ; 1
dc.b "       ---------------      " ; 2
dc.b "                            " ; 3
dc.b "orignal composed by pink.   " ; 4
dc.b "could maybe used for the    " ; 5
dc.b "highscore music of last     " ; 6
dc.b "ninja 4? did never heard a  " ; 7
dc.b "word about kunitoky??       " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "     walk about (remix)     " ; 1
dc.b "     ------------------     " ; 2
dc.b "                            " ; 3
dc.b "original composed by pink.  " ; 4
dc.b "                            " ; 5
dc.b "this is really an old tune. " ; 6
dc.b "it was released first in an " ; 7
dc.b "issue of 'chipmania'. coz'  " ; 8
dc.b "this is one of my favourite " ; 9
dc.b "songs i recycled it with    " ; 10
dc.b "some fresh pretracker-samps." ; 11
dc.b "hope you'll like it as i do." ; 12

dc.b "      mr.delay is back?     " ; 1
dc.b "      -----------------     " ; 2
dc.b "                            " ; 3
dc.b "original composed by        " ; 4
dc.b "mem'o'ree. meo is showing   " ; 5
dc.b "once again his abilities in " ; 6
dc.b "                            " ; 7
dc.b "creating nice, fast and     " ; 8
dc.b "breathtaking songs. i really" ; 9
dc.b " like it a much.            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "     chippy story remix     " ; 1
dc.b "     ------------------     " ; 2
dc.b "                            " ; 3
dc.b "original composed by        " ; 4
dc.b "mem'o'ree. do ya remember?  " ; 5
dc.b "diznee land 3 had the       " ; 6
dc.b "orig. version of this tune. " ; 7
dc.b "                            " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "                            " ; 11
dc.b "                            " ; 12

dc.b "    lament for atlantis     " ; 1
dc.b "    -------------------     " ; 2
dc.b "                            " ; 3
dc.b "original composed by        " ; 4
dc.b "mem'o'ree. a really moody   " ; 5
dc.b "song. btw: the first        " ; 6
dc.b "pretrackersong by mem'o'ree." ; 7
dc.b " enjoy!!!!!!                " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "ok guys. did you have heard " ; 11
dc.b "enough to order your        " ; 12

dc.b "registered version of       " ; 1
dc.b "pretracker1.5?              " ; 2
dc.b "                            " ; 3
dc.b "for only 10,- dm or 10,- us " ; 4
dc.b "you will get the tool you   " ; 5
dc.b "ever dreamed off.           " ; 6
dc.b "                            " ; 7
dc.b "send you order to:          " ; 8
dc.b "manfred linzner (pink)      " ; 9
dc.b "rupert-mayer-str. 6         " ; 10
dc.b "81379 muenchen              " ; 11
dc.b "-germany-                   " ; 12

dc.b "if you have any suggestions " ; 1
dc.b "for the next update then    " ; 2
dc.b "contact me also!            " ; 3
dc.b "                            " ; 4
dc.b "                            " ; 5
dc.b "thanx for reading... now sit" ; 6
dc.b "back and njoy diznee 'gold'." ; 7
dc.b "                            " ; 8
dc.b "                            " ; 9
dc.b "                            " ; 10
dc.b "pink is signing off....     " ; 11
dc.b "                            " ; 12


;;greets
dc.b	"2fast of trsi               "                  
dc.b	"ace of trance inc.          "                      
dc.b	"action of energy            "
dc.b	"al bundy of jewels          "
dc.b	"andy of essence             "
dc.b	"antex of control            "
dc.b	"astro of movement           "
dc.b	"apeman of anaheim           "
dc.b	"avenger of mad elks         "
dc.b	"axel f. of retire           "
dc.b	"backfire of applause        "
dc.b	"bbx of orion                "

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
dc.b	"colorbird of razor 1911     "

dc.b	"coma of dual format         "
dc.b	"condor of jewels            "                    
dc.b	"core of disaster            "
dc.b	"crazy-d of c-lous           "
dc.b	"crusader of depth           "
dc.b	"d-mage of vitual dreams     "
dc.b	"darkside of samba           "
dc.b	"disty of storm              "
dc.b	"dose of trance              "
dc.b	"double r of intense         "
dc.b	"duffy of iris               "
dc.b	"facets pussy of desire      "

dc.b	"fate of outlaws             "
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

dc.b	"growl of fanatic            "
dc.b	"hazel of absolute!          "
dc.b	"hacksaw of chrome           "
dc.b    "hijack of parallax          "
dc.b	"howie of essence            "
dc.b	"hunter of boom design       "
dc.b	"izerman of s!p              "
dc.b	"ice cube of manitou         "
dc.b	"javair of tmg               "
dc.b	"kazz of bronx               "
dc.b	"killraven of dcs            "
dc.b	"klf of fate                 "

dc.b	"limbo of razor 1911         "
dc.b	"loony of divine             "
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
dc.b	"michael of anathema         "
dc.b	"mike of defiance            "
dc.b	"mop of essence              "
dc.b    "motion of balance           "
dc.b	"mr.keel of nova             "
dc.b	"mr.king of scoopex          "
dc.b	"napoleon of dreamdealers    "
dc.b	"naughty angel               "
dc.b	"nick of offence             "
dc.b	"norby of trsi               "
dc.b	"nuke of manitou             "

dc.b	"onix of illegal             "
dc.b	"oxstone of spasm            "
dc.b	"pagan                       "
dc.b	"paperboy of simplex         "
dc.b	"paze of rebels              "
dc.b	"peace of solitude           "
dc.b	"phuture of saints           "
dc.b	"poke of accession           "
dc.b	"purple haze                 "
dc.b	"python of trsi              "
dc.b	"qba of illusion             "
dc.b	"qwerty of scope             "

dc.b	"ravana of ?                 "
dc.b	"rave of manitou             "
dc.b	"raze of fanatic             "
dc.b	"reactor of mystic           "
dc.b	"redman of mad elks          "
dc.b	"rip of manitou              "
dc.b    "roscoe of ?                 "
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
dc.b	"stratos of quick design     "
dc.b	"substance of saints         "
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
dc.b	"vodka of saturne            "
dc.b	"wea (ind.)                  "
dc.b	"wildcat of scania           "
dc.b	"wizard of infect            "
dc.b	"woober of saints            "
dc.b	"wotw of essence             "

dc.b	"yahoo of old bulls          "
dc.b	"zinko of polka brothers     "
dc.b	"                            "
dc.b	"                            "
dc.b	"   ...and to all sceners    "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
dc.b	"                            "
