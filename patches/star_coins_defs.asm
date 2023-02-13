;#######################################################################
;# Customization

	!yes = 1		; Used for options below.
	!no = 0

;###############################
;# Features customization.

!max_star_coins		= 5	; How many Star Coins will be in each
				; level. Up to 16 Star Coins.
				; Using more than 8 coins will end up
				; in higher RAM usage, check the RAMs
				; section below for more information.

!perma_coins		= !no	; Directly saves the coins to the save
				; buffer without needing to complete 
				; the level. Dying on the level won't
				; reset the already collected coins.

!save_on_misc_exit	= !no	; Enable saving Star Coins to the 
				; save buffer when exiting the level
				; via start + select combo, dying
				; or using the side exit sprite.

!remember_midway	= !yes	; Remembers the amount of Star Coins
				; the player had if they hit a midway
				; point and they die later in the level.
				; Star coin count gets reset and the
				; backup created is discarded if the
				; player enters to different level
				; where they just died.

!keep_midway_coins	= !yes	; Midway Star coin count won't get reset upon
				; changing overworld levels.

;###############################
;# Original HUD/Status bar.

!create_counter		= !yes	; Overrides both counters explained
				; below with a single define.
				; Set it to !no if you use another HUD
				; that isn't the LAYER 3 HUD.

!yoshi_coins_counter	= !no	; Keeps the Yoshi Coins counter if
				; enabled.

!create_symbol_counter	= !yes	; Creates a counter in LAYER 3 HUD
				; using the same method as the Yoshi
				; Coins in the original game.
				; Not recommended if !max_star_coins
				; is more than 6.

!symbol_counter_pos	= $0EFF	; Position of the counter in the HUD.
				; Check RAM $7E0EF9 on the RAM Map.

!symbol_blank_tile	= $FC	; Tile number for the blank tile in the
				; LAYER 3 HUD.
!symbol_full_tile	= $2E	; Tile number for the full tile in the
				; LAYER 3 HUD.
!symbol_reverse_order	= !no	; Reverse the order the Star Coins are
				; filled into the HUD.

!create_numeric_counter	= !no	; Creates a numeric counter in LAYER 3
				; HUD displaying how many coins are 
				; already collected in the level.
				; Has priority over the symbol counter
				; if both are enabled.

!numeric_counter_pos	= $0EFF	; Position of the counter in the HUD.
				; Requires 5 consecutive tiles.
				; Check RAM $7E0EF9 on the RAM Map.

!numeric_leading_zeroes	= !no	; Draws leading zeroes if enabled.

;###############################
;# Star Coins collectibles

!star_coin_sfx		= #$1C	; SFX played when collecting a Star Coin.
!star_coin_sfx_port	= $1DF9	; Port of the SFX above.

!star_coin_give_coins	= !no	; Enable Star Coins giving coins.
!star_coin_coin_amount	= $05	; How many coins a Star Coin will give.

!star_coin_outline	= !yes	; Enable Star Coins leaving an outline
				; upon collecting them.
				; For blocks: the outline tile used is:
				; Map16 number + 0x100

!star_coin_outline_2	= !yes	; Enable collected Star Coins being shown
				; as an outline after loading a level.
				; If disabled, they won't be drawn.

!star_coin_glitter	= !yes	; Enables Star Coins creating a glitter
				; trail effect when collecting them.

!star_coin_give_points	= !yes	; Enable Star Coins giving points.

!first_coin_points	= $09	; Valid values:
!second_coin_points	= $0A	; $00 = Null/0
!third_coin_points	= $0B	; $01 = 10
!fourth_coin_points	= $0C	; $02 = 20
!fifth_coin_points	= $0D	; $03 = 40
!sixth_coin_points	= $0D	; $04 = 80
!seventh_coin_points	= $0D	; $05 = 100
!eighth_coin_points	= $0D	; $06 = 200
!ninth_coin_points	= $0E	; $07 = 400
!tenth_coin_points	= $0E	; $08 = 800
!eleventh_coin_points	= $0E	; $09 = 1000
!twelfth_coin_points	= $0E	; $0A = 2000
!thirteenth_coin_points	= $0E	; $0B = 4000
!fourteenth_coin_points	= $0E	; $0C = 8000
!fifteenth_coin_points	= $0E	; $0D = 1up
!sixteenth_coin_points	= $0F	; $0E = 2up
				; $0F = 3up
				; $10 = 5up (may glitch)

;###############################
;# Star coin sprite specific defines. (NOT IMPLEMENTED/INCLUDED)

!star_coin_dynamic	= !yes	; Makes the Star Coin sprite dynamic.

;###############################
;# Star coin blocks specific defines.

!use_conditional_map16	= !yes	; Enables the usage of Conditional Map16 
				; instead of Objectool for the Star Coin
				; collectibles.
 
				; Objectool specific defines.
!star_coins_page	= $03	; Map16 page where the Star Coins blocks
				; are inserted to.

;#######################################################################
;# RAMs
;# Requires 211 bytes of free RAM + 204 bytes of SRAM (BW-RAM on SA-1).
;# If the maximum amount of Star coins is 9 or greater, it requires 
;# 405 bytes of free RAM + 396 bytes of SRAM (BW-RAM on SA-1).

!star_coin_ram		= $7FB539	; RAM define for non SA-1 ROMs.

!star_coin_ram_sa1	= $40C500	; RAM define for SA-1 ROMs.

					; Don't modify any define below.

if !sa1 == 1
	!star_coin_ram = !star_coin_ram_sa1
endif

;# !level_star_coins [8-bit or 16-bit | 1 or 2 bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected in the current OW level.
;# Modified on OW->level fade and upon collecting a Star Coin.

!level_star_coins		= !star_coin_ram+$00

;# !midway_star_coins [8-bit or 16-bit | 1 or 2 bytes]
;# Format: FEDCBA98 76543210
;# Copy of !level_coins created upon touching a midway.

if !max_star_coins >= 9
	!midway_star_coins	= !star_coin_ram+$02
else
	!midway_star_coins	= !star_coin_ram+$01
endif

;# !previous_ow_level [8-bit | 1 byte]
;# Has the previous OW level number accessed.
;# Initialized to $FF on title screen and recalculated on level load.

if !max_star_coins >= 9
	!previous_ow_level	= !star_coin_ram+$04
else
	!previous_ow_level	= !star_coin_ram+$02
endif

;# !level_star_coins_num [8-bit | 1 byte]
;# Holds number of Star Coins collected in the current playthrough of
;# the level. This number is added to !total_coins_num on OW load if a
;# level was beaten (and start+select through an option).
;# Modified upon collecting a Star Coin.
;# Gets reset on level load, ow load and death.

if !max_star_coins >= 9
	!level_star_coins_num	= !star_coin_ram+$05
else
	!level_star_coins_num	= !star_coin_ram+$03
endif

;# !level_total_star_coins [8-bit | 1 byte]
;# Has the total number of coins collected in the level, counting those
;# that already were taken on previous playthroughs of the level.
;# Modified on OW->level fade and collecting a Star Coin.

if !max_star_coins >= 9
	!level_total_star_coins	= !star_coin_ram+$06
else
	!level_total_star_coins	= !star_coin_ram+$04
endif

;# !game_total_coins_num [16-bit | 2 bytes]
;# Has the total number of Star Coins collected in the current save file.
;# Gets reset on file load and updated on ow load.

if !max_star_coins >= 9
	!game_total_star_coins	= !star_coin_ram+$07
else
	!game_total_star_coins	= !star_coin_ram+$05
endif

;# !star_coin_level_flags [8-bit or 16-bit | 0x60 (96) or 0xC0 (192) bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected in each level.

if !max_star_coins >= 9
	!star_coin_level_flags	= !star_coin_ram+$09
else
	!star_coin_level_flags	= !star_coin_ram+$07
endif

;# !star_coin_midway_flags [8-bit or 16-bit | 0x60 (96) or 0xC0 (192) bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected at the midway of each level.

if !max_star_coins >= 9
	!star_coin_midway_flags	= !star_coin_ram+$C9
else
	!star_coin_midway_flags	= !star_coin_ram+$67
endif

;# !star_coin_all_flags [8-bit | 0xC (12) bytes]
;# Format: Same as 3up Moons and related stuff in SMW.
;# "Collected every Star Coin in a level" bits. Each bit corresponds to every
;# Overworld level. Updated on ow load.

if !max_star_coins >= 9
	!star_coin_all_flags = !star_coin_ram+$189
else
	!star_coin_all_flags = !star_coin_ram+$C7
endif

;#######################################################################
;# Internal defines, don't touch anything here.

if read1($05D842) == $5C	; Detects Multi Midway Patch 1.7
	!mmp = 1
	if canreadfile1("multi_midway_defines.asm", 1) == 1
		incsrc multi_midway_defines.asm
		if !sa1 == 1
			!RAM_Midway = !RAM_Midway_SA1
		endif
	else
		error "multi_midway_defines.asm needs to be in the same folder as star_coins_defs.asm!"
	endif
else	
	!mmp = 0
	!RAM_Midway = $000000
endif	

!max_star_coins_bits = 0
!i = 0
while !i != !max_star_coins
	!max_star_coins_bits #= (!max_star_coins_bits<<1)|1
	!i #= !i+1
endif