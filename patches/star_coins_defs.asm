;#######################################################################
;# Internal defines, don't touch anything here.

	!yes = 1
	!no = 0

if read1($00FFD5) == $23
	!sa1 = 1
	!bank = $000000
	!addr = $6000
else	
	!sa1 = 0
	!bank = $800000
	!addr = $0000
endif

;#######################################################################
;# Customization


;###############################
;# Features customization.

!max_star_coins		= 16	; How many Star Coins will be in each
				; level. Up to 16 Star Coins.

!perma_coins		= !no	; Directly saves the coins to the save
				; file without needing to complete the
				; level. Dying on the level won't reset
				; the already collected coins.
				; Works best with !autosave enabled.

!autosave		= !no	; Automatically saves the Star Coins
				; collected and the whole save file
				; on OW load.

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

;###############################
;# Original HUD/Status bar.

!create_counter		= !yes	; Overrides both counters explained
				; below with a single define.
				; Disable it if you use another HUD
				; that isn't the VANILLA LAYER 3 HUD.

!yoshi_coins_counter	= !no	; Keeps the Yoshi Coins counter if
				; enabled.

!create_symbol_counter	= !yes	; Creates a counter in VANILLA HUD
				; using the same method as the Yoshi
				; Coins in the original game.
				; Not available if !max_star_coins is
				; over 6 Star Coins.

!symbol_counter_pos	= $0EFF	; Position of the counter in the HUD.
				; Check RAM $7E0EF9.

!symbol_blank_tile	= $FC	; Tile number for the blank tile in the
				; VANILLA HUD.
!symbol_full_tile	= $2E	; Tile number for the full tile in the
				; VANILLA HUD.
!symbol_reverse_order	= !no	; Reverse the order the Star Coins are
				; filled into the HUD.

				; NOT IMPLEMENTED YET
!create_numeric_counter	= !no	; Creates a numeric counter in VANILLA
				; HUD displaying how many coins are 
				; already collected in the level.
				; Has priority over the symbol counter
				; if both are enabled.

!numeric_counter_pos	= $0EFF	; Position of the counter in the HUD.
				; Requires 5 consecutive tiles.
				; Check RAM $7E0EF9.

!numeric_leading_zeroes	= !no	; Draws leading zeroes if enabled.

;###############################
;# Star Coins collectibles

!star_coin_sfx		= #$1C	; SFX played when collecting a Star Coin.
!star_coin_sfx_port	= $1DF9	; Port of the SFX above.

!star_coin_give_coins	= !no	; Enable Star Coins giving coins.
!star_coin_coin_amount	= $05	; How many coins a Star Coin will give.

!star_coin_blk_outline	= !yes	; Enable Star Coins leaving an outline
				; upon collecting them.
				; The outline tile used is:
				; Map16 number + 0x100

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

				; Defines below are unused if you don't
				; use the sprite collectible.
				
!star_coin_dynamic	= !yes	; Makes the Star Coin sprite dynamic.

				; Defines below are unused if Objectool
				; or Conditional Map16 isn't being used.

!use_conditional_map16	= !yes	; Enables the usage of Conditional Map16 
				; instead of Objectool for the Star Coin
				; collectibles.
				; ONLY CONDITIONAL MAP16 IS SUPPORTED
 
				; Objectool specific defines.
!star_coins_page	= $03	; Map16 page where the Star Coins blocks
				; are inserted to.

				; The defines below are automatically
				; calculated based on !star_coins_page.
!small_coin_tile_start	= $00+!star_coins_page<<8
!medium_coin_tile_start	= $10+!star_coins_page<<8
!large_coin_tile_start	= $30+!star_coins_page<<8


;#######################################################################
;# RAMs
;# Requires 392 bytes of free RAM + 386 bytes of SRAM (BW-RAM on SA-1).

!star_coin_ram		= $7FB408	; RAM define for non SA-1 ROMs.

!star_coin_ram_sa1	= $400000	; RAM define for SA-1 ROMs.

					; Don't modify any define below.

if !sa1 == 1
	!star_coin_ram = !star_coin_ram_sa1
endif

;# !level_star_coins [16-bit | 2 bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected in the current OW level.
;# Modified on OW->level fade and upon collecting a Star Coin.

!level_star_coins	= !star_coin_ram+$00

;# !midway_star_coins [16-bit | 2 bytes]
;# Format: FEDCBA98 76543210
;# Copy of !level_coins created upon touching a midway.

!midway_star_coins	= !star_coin_ram+$02

;# !previous_ow_level [8-bit | 1 byte]
;# Has the previous OW level number accessed.

!previous_ow_level	= !star_coin_ram+$04

;# !level_star_coins_num [8-bit | 1 byte]
;# Holds number of Star Coins collected in the current playthrough of
;# the level. This number is added to !total_coins_num on OW load if a
;# level was beaten (and start+select through an option).
;# Modified upon collecting a Star Coin.
;# Gets reset on level load, ow load and death.

!level_star_coins_num	= !star_coin_ram+$05

;# !level_total_coins_num [8-bit | 1 byte]
;# Has the total number of coins collected in the level, counting those
;# that already were taken on previous playthroughs of the level.
;# Modified on OW->level fade and collecting a Star Coin.

!level_total_star_coins	= !star_coin_ram+$06

;# !game_total_coins_num [16-bit | 2 bytes]
;# Has the total number of Star Coins collected in the current save file.
;# Gets reset on file load and updated on ow load.

!game_total_star_coins	= !star_coin_ram+$07

;# !star_coin_level_flags [16-bit | 0xC0 (192) bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected in each level.

!star_coin_level_flags	= !star_coin_ram+$09

;# !star_coin_midway_flags [16-bit | 0xC0 (192) bytes]
;# Format: FEDCBA98 76543210
;# Holds the flags of the Star Coins collected at the midway of each level.

!star_coin_midway_flags	= !star_coin_ram+$C9

;# !star_coin_all_flags [8-bit | 0xC (12) bytes]
;# Format: 76543210
;# "Collected every Star Coin in a level" bits. Each bit corresponds to every
;# Overworld level. Updated on ow load.

!star_coin_all_flags = !star_coin_ram+$189
