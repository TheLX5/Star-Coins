New Super Mario Bros - Star Coins v1.99 (v2.0.0 beta)
------------------------------------
This set of blocks recreates the star coins from the New Super Mario Bros series which take the idea of SMW's dragon coins
but improve them by making them individually collectible and saving the progress when the level has been beaten.

They come in the sizes of 16x16 (a smaller star coin), 16x32 (which is an SMW Dragon Coin) and 32x32 (which is the most comparable to an NSMB star coin).

Like in the game they're based of, they're only collected temporarily until the player reaches a midway point or beat a level.
In fact, if the player has reached the midway point only, the progress will be reset should they change the level
(only recommend if the midway point flag also is reset when changing a level).
However, you can also disable these behaviours and make the coins permanently collected.

The coins are individually kept track of and will appear in status bar in the position they're placed in (or at least, the ID you've assigned the coins).
You can, however, also fill them up like vanilla Dragon Coins or use a numerical counter instead.


Comparison with Individual Dragon Coin Save
------------------------------------
Both patches fill in a similar niche by individually keeping track of SMW's secondary collectibles i.e. Dragon Coins,
making it easier for the player to collect all of them without replying the whole level.
However, they have fundamentally different approaches:
- The biggest difference is that IDCS uses the vanilla dragon coins and so doesn't require any external resource. This makes it easier to use but also less flexible.
- However, all the coins are practically the same and the star coins fills up the like in vanilla SMW so it is impossible to determine where one has missed a Dragon Coin or not.
- IDCS also makes use of item memory for further identification which comes with various limitations (e.g. no saved coins when item memory 3 is used, rooms with item memory indices).
- It also makes it impossible to check whether a specific coin has been collected or not.
- Good news is that custom status bars don't have to be modified to be compatible with them, nor the patches which depend on the "get all DC flag"
  (though the latter can be modified for star coins).
- IDCS also comes with the downside of making custom Dragon Coins practically unusable (without easy ways of calling its code)
  while the Star Coins can be easily modified for one's own needs.
- As of now, IDCS is limited to five coins per level and getting all of them is permanent.
- Furthermore (albeit not an inherent limitation as well), IDCS doesn't keep track of the coins individually like star coins do.
- You can also use the vanilla DC with star coins for whatever reason.

Which one you want to chose depends on how complex the system is and whether unique collectibles are really necessary or you just want to give the player some QoL with the Dragon Coin hunt.
If all you care, go with Individual Dragon Coin Save but if you really need individually saved coins, go with star coins.

Installation
------------------------------------
Because of the complexity, the star coins depend on multiple external resources.

You must patch star_coins.asm in the "patches" folder to your ROM. That one stores the configuration into ROM and also modifies the star bar to display the star coins.

NOTE THAT IT MOVES THE MIDWAY POINT CODE TO FREESPACE IN ORDER TO MAKE SPACE FOR THE CONFIGURATION BYTES.
ANY PATCH WHICH MODIFIES THIS SECTION WILL BREAK THIS PATCH UNLESS MODIFIED ACCORDINGLY, THOUGH IT IS COMPATIBLE WITH KAIJYUU'S MMP PATCH.


Once you've done that, you can insert the remaining resources.

In order to insert the blocks themselves, you first must insert "incsrc star_coins_defs.asm" (without quotes) into GPS's defines.asm, preferably at the beginnin.
Then you can use the existing list.txt. In case you already have other blocks, simply copy its content into your list.txt.
Most of the blocks including the coins themselves check for the Map16 number.
The 16x16 and 16x32 coins as well as the passable with X coins blocks check for the rightmost digit of the Map16 number while the 32x32 also check for current row.
Furthermore, the 16x32 and 32x32 coins to determine which half is which with odd rows being the top half and (for the 32x32 coins) even columns the left half.
Because of technical reasons, these blocks reserve two complete Map16 pages so make sure you have this much space free.
Note that if you change the page of the coins and use ObjecTool, you also must change !star_coins_page in star_coins_defs.asm.

The main bulk of the blocks comes from UberASM.
It handles the load code (e.g. remembering the midway point state, setting up Conditional Direct Map16) and also preserves the currently collect coins on overworld load.

In case you already have some codes for gamemodes 0C, 0E or 11, you must modify them to call the star coin code as well.
In order to do this, take the "jsl star_coins_xxx" code and transplant it into the (preferably at the start of the relevant labels).
Alternatively, you can use Fernap's UberASM 2.0 which supports multiple codes for a single level/submap/gamemode.

The patch also depends on SRAM or BW-RAM Plus which handles the initialisation of the tables (e.g. whether they've been collected and such).
You can automatically install SRAM and BW-RAM Plus with the star coins patch if you place their codes into their respective folders (i.e. "sram_plus" or "bwram_plus").
If you already, make sure you copy the addition.

Optionally, you can also use ObjecTool but you can also use Lunar Magic's Conditional Direct Map16.


Using Conditional Direct Map16
------------------------------------
Although Direct Map16 objects are typically static i.e. they will spawn as they are,
Lunar Magic gives the user the possibility to have conditional Map16 tiles without the use of the somewhat complex to use ObjecTool.
They can be set to either not spawn when a flag has been set (e.g. vanilla Dragon Coins when all have been collected within a level)
or they can be set to place a tile from the next Map16 page instead (e.g. the exclamation mark blocks).

In order to enable this, you have to use !use_conditional_map16 to !yes.

To allow Conditional Direct Map16 objects, select an object you want to affect, go to Edit > Conditional Direct Map16...
The star coins use CDM16 flags 70-7F and for easier use, check "Always show objects..." which will use the following page once a star coin has been collected.
Omitting that means you have to place a collected star coin behind the current coin.
You can check which CDM16 the star coin has by hovering on the tile which mentions at the last two rows the tile number as well as the flag.


Using ObjecTool
------------------------------------
In order to use objects, you have to use download ObjecTool first. It can be found in the patches section of SMWC.

Once you've downloaded it, put all the relevant ObjecTool files into the "objectool" folder,
open up "custobjcode.asm" and put "incsrc star_coins_objects.asm" (without quotes) below "@includefrom objectool.asm".

Once you have done this, you can add a star coin object with certain macros. ObjecTool supports two kinds of custom objects: Normal objects and extended objects.

Normal objects can be resized to the user's wishes and have all the label CustObjXX, though ObjecTool also adds in the ability to use an extra byte.
Put %star_coin_variable() below whichever label you want to insert.
Once ObjecTool and the star coin object are patched, put 2D into "Command", the value you substituted for XX into Extension followed by the extra byte.
It follows the SI format where S is the size (0 = 16x16, 1 = 16x32, 2 = 32x32) and I the zero-indexed (i.e. 0 is the first, 1 is the second, etc.) star coin ID.
The size doesn't do anything here, though you can use it as a guideline as well as fixing the priority should a different object overlap with the star coin object.

Extended objects are singular i.e. they can't be resized and have all the label CustExObjXX in ObjecTool.
%star_coin_small(ID), %star_coin_medium(ID) and %star_coin_large(ID) are all made for extended objects i.e. CustExObjXX. These are singular objects.
"ID" in question is one-indexed i.e. the first first star coin starts from 1 instead of 0.

You can see examples of them below

Because Lunar Magic doesn't support the display of custom objects, they all appear glitched in the editor. They will appear fine in-game, though.

Note that if you use custom extended objects you also have to stop Lunar Magic from warning the level.
You can disable this under Options > General Options and uncheck "Correct Fatal Errors".


Example of extended objects:

CustExObj98:
	%star_coin_small(1)

CustExObj99:
	%star_coin_small(2)

CustExObj9A:
	%star_coin_small(3)

CustExObj9B:
	%star_coin_small(4)

CustExObj9C:
	%star_coin_small(5)

CustExObj9D:
	%star_coin_medium(1)

CustExObj9E:
	%star_coin_medium(2)

CustExObj9F:
	%star_coin_medium(3)

CustExObjA0:
	%star_coin_medium(4)

CustExObjA1:
	%star_coin_medium(5)

CustExObjA2:
	%star_coin_large(1)

CustExObjA3:
	%star_coin_large(2)

CustExObjA4:
	%star_coin_large(3)

CustExObjA5:
	%star_coin_large(4)

CustExObjA6:
	%star_coin_large(5)


Example of normal object:

CustObj20:
	%star_coin_variable()
	rts


Test levels
------------------------------------
The star coins come with two test levels: Level 105 and level 106.

Level 105 is the original test by LX5 and tests the various blocks, from the star coins themselves (using CDM16) to pass through blocks and various exits. It also contains the animation for the 32x32 star coins.

Level 106 is a test by MarioFanGamer which tests out the custom objects as well as the secondary exit to overworld feature.


Credits
------------------------------------
lx5 for creating the initial patch as well revamping the patch (v1.99)
MarioFanGamer for remoderation update (v1.14) as well as finalising the revamp
Blind Devil for remoderation update
Carld923 for the star coin graphics


Changelog
------------------------------------
v1.99 (13/Jan/23)
- C3 Beta Release
- Revamped Star Coins to single blocks
- Modified settings to be stored in the ROM
- Added Conditional Direct Map16 support
- Removal of the star coin sprite
- Removal of the custom sparkle
v1.14 (24/Apr/18)
- Remoderation update (MFG/Blind Devil)
- Added SA-1 support
- Changed animation file to require only one ExAnimation slot.
- Included a custom sprite (PIXI) version of the Star Coin - check out the ASM file for more info.
v1.13 (16/Sep/15)
- Fixed the routine that generates sparkles.
- Fixed the .ips having some weird stuff.
- Included an edited change_map16 routine to make the star coins work correctly on vertical levels
v1.12 (16/May/15)
- Fixed some initialization code
- Removed some jimmy code
- Fixed a define and some descriptions in StarCoinsDefs.asm
v1.11 (4/Jan/15)
- Submitted to SMWC.
- Fixed minor things in the file.
v1.1 (22/Dec/14)
- Now is possible to have eight star coins in each level.
- Added documentation about custom objects.
- Added a small tutorial of how to create more Custom Objects.
- Removed some dumb and useless things from StarCoinsDefs.asm
v1.0 (20/Dec/14)
- C3 RELEASE (yay!).
- Fixed a lot of thigs with the midpoint.
- Translated all files.
v0.2 (14/Dec/14)
- Fixed a crash when you die
- Fixed a bug related to the give points routine.
v0.1 (14/Dec/14)
- Initial release in Fortaleza Reznor (Spanish forum)
