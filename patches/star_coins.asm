@asar 1.71

;#######################################################################
;# Star coins patch v2.0.0
;# By lx5
;# 
;# Enables the usage of Star coins similar to the ones in NSMB.
;# Not an exact replica.
;# 
;#######################################################################
;# This file:
;# - Handles SA-1, Multiple Midway Points and SRAM/BW-RAM Plus patch detection.
;# - Saves (some) of the patch configuration into ROM to avoid copying
;#   star_coins_defs.asm into multiple directories.
;# - Can insert code to make midway points save the Star coins collected
;#   to the RAM buffer.
;# - Can insert code to display the Star coins collected in the LAYER 3
;#   status bar/HUD.

if read1($00FFD5) == $23        ; Detects SA-1.
    sa1rom
    !sa1 = 1
    !bank = $000000
    !addr = $6000
else    
    lorom
    !sa1 = 0
    !bank = $800000
    !addr = $0000
endif

if getfilestatus("star_coins_defs.asm") == 1
    error "star_coins_defs.asm not detected. The file should be in the same folder as star_coins.asm!"
else
    incsrc star_coins_defs.asm

    if !create_numeric_counter == !yes
            !create_symbol_counter = !no
    else
            if !create_symbol_counter == !no
                    !create_counter = !no
            endif
    endif

    !insert = !no

    if !remember_midway == !yes
            !insert = !yes
    endif

    if !create_counter == !yes
            !insert = !yes
    endif

if !config_bytes_pts&$7F0000 >= $100000
    error "The configuration bytes pointer must not be stored in freespace."
endif

org !config_bytes_pts
autoclean dl config_bytes

    print "Star Coins v2.0.0 patch"
    print " "


;###############################
;# Inserts mandatory ASM.

freedata

    print "Config bytes location: $",pc
    print " "

;# ----SSSS OtYsKRMP pg-qocxx yyyyyyyy zzzzzzzz llllllll 
;# Cbbbbbbb D---dddd rrrrrrrr rrrrrrrr rrrrrrrr iiiiiiii
;# SSSS     - !max_star_coins
;# P        - !perma_coins
;# M        - !save_on_misc_exit
;# R        - !remember_midway
;# K        - !keep_midway_coins
;# s        - !create_counter
;# Y        - !yoshi_coins_counter
;# t        - !create_symbol_counter
;# O        - !numeric_leading_zeroes or !symbol_reverse_order (depends on !create_symbol_counter)
;# xx       - !star_coin_sfx_port
;# c        - !star_coin_give_coins
;# o        - !star_coin_outline
;# g        - !star_coin_glitter
;# p        - !star_coin_give_points
;# q        - !star_coin_outine_2
;# yyyyyyyy - !star_coin_sfx
;# zzzzzzzz - !star_coin_coin_amount
;# llllllll - !star_coin_points_collected
;# bbbbbbbb - !star_coins_page
;# C        - !use_conditional_map16
;# D        - !star_coin_dynamic
;# dddd     - !conditional_map16_flag
;# r        - !star_coin_ram
;# i        - points-config_bytes

config_bytes:
    db !max_star_coins
if !create_symbol_counter == !yes
    db ((!perma_coins)|(!save_on_misc_exit<<1)|(!remember_midway<<2)|(!keep_midway_coins<<3)|(!create_counter<<4)|(!yoshi_coins_counter<<5)|(!create_symbol_counter<<6)|(!symbol_reverse_order<<7))
else
    db ((!perma_coins)|(!save_on_misc_exit<<1)|(!remember_midway<<2)|(!keep_midway_coins<<3)|(!create_counter<<4)|(!yoshi_coins_counter<<5)|(!create_symbol_counter<<6)|(!numeric_leading_zeroes<<7))
endif
    db ((!star_coin_sfx_port-$1DF9)|(!star_coin_give_coins<<2)|(!star_coin_outline<<3)|(!star_coin_glitter<<4)|(!star_coin_give_points<<5))
    db !star_coin_sfx
    db !star_coin_coin_amount
    db !star_coin_points_collected
    db (!use_conditional_map16<<7)|(!star_coins_page)
    db ((!star_coin_dynamic)<<7)|(!conditional_map16_flag>>3)
    dl !star_coin_ram
    db points-config_bytes

points:
    db !first_coin_points
    db !second_coin_points
    db !third_coin_points
    db !fourth_coin_points
    db !fifth_coin_points
    db !sixth_coin_points
    db !seventh_coin_points
    db !eighth_coin_points
    db !ninth_coin_points
    db !tenth_coin_points
    db !eleventh_coin_points
    db !twelfth_coin_points
    db !thirteenth_coin_points
    db !fourteenth_coin_points
    db !fifteenth_coin_points
    db !sixteenth_coin_points
        
pushpc

if !insert == !no
    print "Only important stuff was inserted."

if !mmp == 1
org $05DA9B
    autoclean JML new_no_yoshi              ; make secondary exits compatible with no yoshi intros
org $05DA9F
    dl !RAM_Midway
endif

if !mmp == 1
new_no_yoshi:
    stz $1B93|!addr
    stz $1414|!addr
    stz $1411|!addr
    stz $5B
    lda.l $05D78A|!bank,x
    jml $05DAA7|!bank 
endif
else

;#######################################################################
;# Hijacks

if !mmp == 1
org $05DA9B
    JML new_no_yoshi              ; make secondary exits compatible with no yoshi intros
endif

if !remember_midway == !yes
org $00F2CD|!bank
    jml midway_add_up
endif

if !create_counter == !yes
org $008FD8|!bank
    jsl status_bar_counters
    rts

if !create_symbol_counter == !yes
    !i = 0
    while !i != !max_star_coins
        org ($008C8A+((!symbol_counter_pos-$0EF9)*2)+(!i*2))|!bank
        db $3C
        !i #= !i+1
    endif
endif

if !create_numeric_counter == !yes
    org ($008C89+((!numeric_counter_pos-$0EF9)*2))|!bank
        db $2E,$3C
        db $26,$38
        db $FC,$38
        db $FC,$38
endif
endif

pullpc

if !remember_midway == !yes
midway_add_up:
    ldx $13BF|!addr
    lda $1EA2|!addr,x
    ora #$40
    sta $1EA2|!addr,x
if !max_star_coins >= 9
    rep #$30
    txa
    asl
    tax
    lda !level_star_coins
    sta !midway_star_coins
    sta !star_coin_midway_flags,x
    sep #$30
else
    lda !level_star_coins
    sta !midway_star_coins
    sta !star_coin_midway_flags,x
endif
    LDA #$02
    STA $9C
    jml $00F2D1|!bank
endif

if !create_counter == !yes
status_bar_counters:

if !yoshi_coins_counter == !yes
    lda $1422|!addr
    cmp #$05
    phk
    pea.w .yc_counter-1
    pea $84CE
    jml $008FDD|!bank
.yc_counter
endif   

if !create_symbol_counter == !yes
    rep #$20
    ldx.b #(!max_star_coins-1)*2
if !symbol_reverse_order == !yes
    ldy #$00
else    
    ldy.b #!max_star_coins-1
endif
-       
    lda !level_star_coins
    and.l reverse_bits,x
    sep #$20
    beq +
    lda #!symbol_full_tile
    bra ++
+       
    lda #!symbol_blank_tile
++      
    sta !symbol_counter_pos|!addr,y
    rep #$20
if !symbol_reverse_order == !yes
    iny
else    
    dey
endif
    dex #2
    bpl -
    sep #$20
endif

if !create_numeric_counter == !yes

    if !max_star_coins >= 10
        lda !level_total_star_coins
        jsl $009045|!bank
        sta.w (!numeric_counter_pos+3)|!addr
    if !numeric_leading_zeroes == !yes
        cpx #$00
        beq .no_leading_zeroes
    endif
        stx.w (!numeric_counter_pos+2)|!addr
    .no_leading_zeroes
    else
        lda !level_total_star_coins
        sta.w (!numeric_counter_pos+2)|!addr
    endif
endif
    rtl
        

if !mmp == 1
new_no_yoshi:
    stz $1B93|!addr
    stz $1414|!addr
    stz $1411|!addr
    stz $5B
    lda.l $05D78A|!bank,x
    jml $05DAA7|!bank 
endif

if !create_symbol_counter == !yes
reverse_bits:
    dw $0001,$0002,$0004,$0008
    dw $0010,$0020,$0040,$0080
    dw $0100,$0200,$0400,$0800
    dw $1000,$2000,$4000,$8000
endif

endif

endif

namespace sram_plus

if getfilestatus("sram_plus/sram_plus.asm") == 0 && !sa1 == 0
	print "Installing SRAM Plus..."
	
	incsrc sram_plus/sram_plus.asm
elseif getfilestatus("bwram_plus/bwram_plus.asm") == 0 && !sa1 == 1
	print "Installing BW-RAM Plus..."
	
	incsrc bwram_plus/bwram_plus.asm
endif

namespace off

print "Inserted ",freespaceuse," bytes."
; This doesn't work, actually, since Asar only reads the bytes of the input ROM,
; now that of the output.
; print " "
; print "Star Coins configuration bytes:"
; print "0x",hex(read1(config_bytes+0)),", 0x",hex(read1(config_bytes+1)),", 0x",hex(read1(config_bytes+2)),", 0x",hex(read1(config_bytes+3)),", 0x",hex(read1(config_bytes+4))
; print "0x",hex(read1(config_bytes+5)),", 0x",hex(read1(config_bytes+6)),", 0x",hex(read1(config_bytes+7)),", 0x",hex(read1(config_bytes+8)),", 0x",hex(read1(config_bytes+9))
; print "0x",hex(read1(config_bytes+10))

endif