# Amiga Sources

Here are some of the Amiga sources i´ve written in the past millenium, as a member of the [Demoscene](https://en.wikipedia.org/wiki/Demoscene "Wikipedia") group Abyss.

Putting all these old sources to Open Source is like letting my pants down, so please be nice :-)

Language: Motorola 68k Assembler

Assembler: ASM-One

I´d like to say '**thank you**' to everybody who´s preserving Demoscene productions by uploading and maintaining various great sites (don´t want to mention some, so that i can´t forget the others) and to those who create videos for YouTube.

---

## Curious
A 40K Intro released by Abyss at the SEMI Party 1993 in Innsbruck/Austria.
The source contains the Prorunner V2.0 source by Cosmos/Sanity.

[Demozoo](https://demozoo.org/productions/289/)

[Watch on YouTube](https://www.youtube.com/watch?v=u49LqWm34ts)

[Download binary](http://ftp.amigascne.org/pub/amiga/Groups/A/Abyss/ABYSS-Curious)

---

## Pulstar

A Dentro released by Abyss in 1995 at [The Party 5](https://en.wikipedia.org/wiki/The_Party_(demoparty) "Wikipedia") in Fredericia/Denmark.

[Demozoo](https://demozoo.org/productions/7635/)

[Watch on YouTube](https://www.youtube.com/watch?v=BQQ781ALWNI)

[Download binary](http://aminet.net/demo/aga/ays-puls.lha)

---

## Orange8

A Musicdisc with 3 great tunes by Neurodancer, released in summer 1995.

[Demozoo](https://demozoo.org/productions/159675/)

[Download disc](https://files.scene.org/view/demos/groups/abyss/ays-ora8.dms)

---

## Abyss in Wonderland

A 4k Intro released by Abyss in April 1997 at the Mekka & Symposium Demoparty in Fallingbostel/Germany

[Demozoo](https://demozoo.org/productions/18884/)

[Download binary](https://files.scene.org/view/parties/1997/mekka97/amiga/in4k/abyss.zip)

---

## High Anxiety

Demo released by Abyss in summer 1995 at [Assembly 1995](https://en.wikipedia.org/wiki/Assembly_(demoparty))  in Helsinki/Finland.

Dexter is the main coder of this demo. I don´t have his sources, so here are only the parts i´ve contributed.           I remember Dexter and me putting all together at the party, that was great :-)

[Demozoo](https://demozoo.org/productions/7477/)

[Watch on YouTube](https://www.youtube.com/watch?v=Pt4Jv_tc_VA)

[Download binary](http://aminet.net/demo/ta95/a95-abys.lha)

---

## Music For The Lost

2-Disc Musicdisc released by Abyss in July 1993.

Contains the Prorunner V2.0 source by Cosmos/Sanity.

The code also contains (at least) two bugs, unknown at the time of release:

+ A bug in the trackdisc loader, which causes some kind of looping when using low quality or worn discs.
+ When i was creating a HD-Version, i noticed that there must be another bug in the vector graphics code, leading to a system crash when exiting the musicdisc and returning to the operating system. Doesn´t occur when booting from disc, since there´s no exit. Because that was about 1 year after release, i decided not to spend time to fix that.

[Demozoo](https://demozoo.org/productions/203609/)

[Disc1](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-MusicForTheLostA.adf)
[Disc2](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-MusicForTheLostB.adf)

---

## Diznee Land

Combination of 10 great chiptunes and a micro-discmag, mostly advertisments.

Issue 1-8 released from april 1994 to november 1995.

[Demozoo](https://demozoo.org/groups/398/)

[Issue1](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand1)
[Issue2](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand2)
[Issue3](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand3)
[Issue4](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand4)
[Issue5](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand5)
[Issue6](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand6)
[Issue7](https://files.scene.org/view/parties/1995/sih95/misc/sih-dizn.lha)
[Issue8](https://files.scene.org/view/mirrors/amigascne/Groups/A/Abyss/Abyss-DizneeLand8)

---

## Massive BBStro

A very small nameless BBStro made for my friends in Massive, can´t remember when it was done, some time between 1996 and 1997 i guess, who cares.

[Demozoo]()

[Download binary](http://ftp.amigascne.org/pub/amiga/Groups/M/Massive/Massive-DisasterAreaBBS)

---

## Drugstore

A two disc ocs trackmo released in January 1995.

Each part comes with it´s own source file, the binaries were put on disc just one after each other, and relocated by the loader to support dynamic memory management.
Before launching a part from AsmOne, please boot with old chipset and allocate chipmem.

[Demozoo](https://demozoo.org/productions/22896/)

[Disc1](http://ftp.amigascne.org/pub/amiga/Groups/A/Abyss/Abyss-Drugstore_a.dms) 
[Disc2](http://ftp.amigascne.org/pub/amiga/Groups/A/Abyss/Abyss-Drugstore_b.dms)
[HD version](http://ftp.amigascne.org/pub/amiga/Groups/A/Abyss/Abyss-Drugstore.lha)

[Watch on YouTube](https://www.youtube.com/watch?v=0TFlA28P7O8)

---

## Bootblocks

When booting an Amiga from floppy disc, the bootblock (sector 0-1) will be loaded and executed at once. Maximum size is 1k (1024 bytes). A nice place to play around and do the first steps in size coding.

#### Starscroller

![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/StarScroller/Starscroller.gif)

April 1992. Simple scroller with some background stars. Looked even oldschool at time of creation, was just curious if i can squeeze that into a bootblock.

#### Zoomscroller

![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/ZoomScroller/Zoomscroller.gif)

July 1992. Wanted to try this without vectors but copper only. Changing the bitplane register is easy, but goes for 16 pixel. Using two bitplanes and using only one byte of each word is the simple trick to get the copperlike 8 pixel resolution :-)

#### Plasma

![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/Plasma/Plasma.gif)

June 1993.

#### Dottunnel

![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/DotTunnel/Dottunnel0.gif) ![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/DotTunnel/Dottunnel1.gif)

September 1994. Hm, yes, ugly. Where´s the 'tunnel effect'? I really should have spent more time with the tunnel before starting to put it on a bootblock. At least there are a couple of shapes to select in the source. :-)

### Intel Outside

![](https://raw.githubusercontent.com/Moon70/Amiga-sources/master/Bootblocks/IntelOutside/IntelOutside.png)

January 1995. When Intel started their aggressive 'Intel Inside' campagne, someone came up with that 'intel outside' logo. I´ve seen this a couple of times in different releases...and the knew which bootblock i want to make next. One version for Abyss, one for K!nky.

Hm...this screenshot is bigger than the others...no that´s not done by mistake :-)

---

## Miracle

Miracle is an OCS diskmag by Iris.

Please note the sourcecode is **not** exactly issue one of Miracle. After release i did some changes in case we do another issue, but we didn´t. We decided to focus on the AGA version (a total rewrite of the code). Too bad that was never finished. Anyway, i´m still happy that i was part of this project. Greetings to MJ, Darkhawk, Miko63, Notman and the rest of Iris :-)

[Demozoo](https://demozoo.org/productions/247321/)

[Download Disc](ftp://ftp.amigascne.org/pub/amiga/Groups/I/Iris/Iris-Miracle01.dms)

---

## Gallows Megademo

Created 1990/1991. Right after my local friend Duke and I did the very first basic steps in assembly on C64, Duke moved without warning :-) to Amiga, and changed from coder to both musician and graphician. I followed as soon as i could afford an Amiga, too.
Together with Rip, Ice Cube and Nuke, who all lived in Duke´s neighbourhood, we formed 'The Gallows'. Being very impressed of the RSI Megademo, soon the idea of an own Megademo was born.
Here are the four parts i´ve contributed (containing the NoisetrackerV1.0 replayroutine by Mahoney & Kaktus), Rip did the trackloader and the remaining parts.
Both mine and Rip´s sources were written by absolutely beginners who had great fun exploring the fantastic Amiga hardware. When i watch the demo every couple of years, it reminds me of youth and friendship, and fellow A500 of course :-)

[Demozoo](https://demozoo.org/productions/219603/)

[Download Disc](ftp://ftp.amigascne.org/pub/amiga/Groups/G/Gallows/GALLOWS-megademo.dms)

