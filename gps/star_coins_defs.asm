;#######################################################################
;# Star coins defines.
;#
;# This file makes the end user to not worry about not placing files
;# where they need to go and get a bunch of errors due to that.
;# It makes my life easier.

!config_bytes_pts = $01FFFD

if canreadfile1("../star_coins_defs.asm", 1) == 1
        incsrc ../star_coins_defs.asm
else
        !config_bytes               #= read3(!config_bytes_pts)
        !yes = 1
        !no = 0
        !max_star_coins             #= read1(!config_bytes+0)
        !perma_coins                #= read1(!config_bytes+1)&$01
        !save_on_misc_exit          #= (read1(!config_bytes+1)&$02)>>1
        !remember_midway            #= (read1(!config_bytes+1)&$04)>>2
        !keep_midway_coins          #= (read1(!config_bytes+1)&$08)>>3
        !star_coin_sfx_port         #= $1DF9+(read1(!config_bytes+2)&$03)
        !star_coin_give_coins       #= (read1(!config_bytes+2)&$04)>>2
        !star_coin_outline          #= (read1(!config_bytes+2)&$08)>>3
        !star_coin_glitter          #= (read1(!config_bytes+2)&$10)>>4
        !star_coin_give_points      #= (read1(!config_bytes+2)&$20)>>5
        !star_coin_sfx              #= read1(!config_bytes+3)
        !star_coin_coin_amount      #= read1(!config_bytes+4)
        !star_coin_points_collected #= read1(!config_bytes+5)
        !star_coins_page            #= read1(!config_bytes+6)&$7F
        !use_conditional_map16      #= (read1(!config_bytes+6)&$80)>>7
        !star_coin_dynamic          #= (read1(!config_bytes+7)&$80)>>7
        !conditional_map16_flag     #= (read1(!config_bytes+7)&$0F)
        !star_coin_ram              #= read3(!config_bytes+8)
        !level_star_coins           #= !star_coin_ram+$00
if !max_star_coins >= 9
        !midway_star_coins          #= !star_coin_ram+$02
        !previous_ow_level          #= !star_coin_ram+$04
        !level_star_coins_num       #= !star_coin_ram+$05
        !level_total_star_coins     #= !star_coin_ram+$06
        !game_total_star_coins      #= !star_coin_ram+$07
        !star_coin_level_flags      #= !star_coin_ram+$09
        !star_coin_midway_flags     #= !star_coin_ram+$C9
        !star_coin_all_flags        #= !star_coin_ram+$189
else
        !midway_star_coins          #= !star_coin_ram+$01
        !previous_ow_level          #= !star_coin_ram+$02
        !level_star_coins_num       #= !star_coin_ram+$03
        !level_total_star_coins     #= !star_coin_ram+$04
        !game_total_star_coins      #= !star_coin_ram+$05
        !star_coin_level_flags      #= !star_coin_ram+$07
        !star_coin_midway_flags     #= !star_coin_ram+$67
        !star_coin_all_flags        #= !star_coin_ram+$C7
endif
        !star_coins_points_table    #= !config_bytes+read1(!config_bytes+11)
        
        !mmp = 0
if read1($05D842) == $5C        ; Detects Multi Midway Patch 1.7
        !mmp = 1
        !RAM_Midway = read3($05DA9F)
endif
        !max_star_coins_bits = 0
        !i = 0
        while !i != !max_star_coins
                !max_star_coins_bits #= (!max_star_coins_bits<<1)|1
                !i #= !i+1
        endif
endif