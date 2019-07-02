;#######################################################################
;# Star coins defines.
;#
;# This file makes the end user to not worry about not placing files
;# where they need to go and get a bunch of errors due to that.
;# It makes my life easier.

if canreadfile1("../star_coins_defs.asm", 1) == 1
	incsrc ../star_coins_defs.asm
else
	!max_star_coins		= read1($00F2E4)
	!perma_coins		= read1($00F2E5)&$01
	!save_on_misc_exit	= (read1($00F2E5)&$02)>>1
	!remember_midway	= (read1($00F2E5)&$04)>>2
	!keep_midway		= (read1($00F2E5)&$08)>>3
	!star_coin_sfx_port	= $1DF9+(read1($00F2E6)&$03)
	!star_coin_give_coins	= (read1($00F2E6)&$04)>>2
	!star_coin_outline	= (read1($00F2E6)&$08)>>3
	!star_coin_glitter	= (read1($00F2E6)&$10)>>4
	!star_coin_give_points	= (read1($00F2E6)&$20)>>5
	!star_coin_sfx		= read1($00F2E7)
	!star_coin_coin_amount	= read1($00F2E8)
	!star_coins_page	= read1($00F2E9)&$7F
	!use_conditional_map16	= (read1($00F2E9)&$80)>>7
	!star_coin_dynamic	= read1($00F2EA)&$01
	!star_coin_ram		= read3($00F2EB)
	!level_star_coins	= !star_coin_ram+$00
if !max_star_coins >= 9
	!midway_star_coins	= !star_coin_ram+$02
	!previous_ow_level	= !star_coin_ram+$04
	!level_star_coins_num	= !star_coin_ram+$05
	!level_total_star_coins	= !star_coin_ram+$06
	!game_total_star_coins	= !star_coin_ram+$07
	!star_coin_level_flags	= !star_coin_ram+$09
	!star_coin_midway_flags	= !star_coin_ram+$C9
	!star_coin_all_flags	= !star_coin_ram+$189
else
	!midway_star_coins	= !star_coin_ram+$01
	!previous_ow_level	= !star_coin_ram+$02
	!level_star_coins_num	= !star_coin_ram+$03
	!level_total_star_coins	= !star_coin_ram+$04
	!game_total_star_coins	= !star_coin_ram+$05
	!star_coin_level_flags	= !star_coin_ram+$07
	!star_coin_midway_flags	= !star_coin_ram+$67
	!star_coin_all_flags	= !star_coin_ram+$C7
endif
	
	!mmp = 0
if read1($05D842) == $5C	; Detects Multi Midway Patch 1.7
	!mmp = 1
	!RAM_Midway = read3($05DA9F)
endif
endif