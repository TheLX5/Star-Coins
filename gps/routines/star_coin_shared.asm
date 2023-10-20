;#######################################################################
;# Star Coins shared routine for blocks.
;# 
;# 

if !perma_coins == !no
if !max_star_coins >= 9
    rep #$20
    lda !level_star_coins
    and.l reverse_bits,x    ; bit can't access long addressing *sad noises*
    bne ?collected_coin
    lda.l reverse_bits,x
    ora !level_star_coins
    sta !level_star_coins
    sep #$20
else
    lda !level_star_coins
    and.l reverse_bits,x
    bne ?collected_coin
    lda.l reverse_bits,x
    ora !level_star_coins
    sta !level_star_coins
endif
    
    lda !level_star_coins_num
    inc
    sta !level_star_coins_num
    
    lda !level_total_star_coins
    inc
    sta !level_total_star_coins
else    
if !max_star_coins >= 9
    rep #$20
    lda.l reverse_bits,x
    pha
    rep #$10
    lda $13BF|!addr
    and #$00FF
    asl
    tax
    pla
    ora !level_star_coins
    sta !level_star_coins
    sta !star_coin_level_flags,x
else
    tyx
    lda.l reverse_bits,x
    ldx $13BF|!addr
    ora !level_star_coins
    sta !level_star_coins
    sta !star_coin_level_flags,x
    rep #$30
endif

    lda !game_total_star_coins
    inc
    sta !game_total_star_coins
    
    sep #$30
    
    lda !level_total_star_coins
    inc
    sta !level_total_star_coins
endif   

if !star_coin_give_points == !yes
    lda !level_total_star_coins
    tax
    lda.l !star_coins_points_table-1,x
    bra +
?collected_coin:
    sep #$20
    lda #!star_coin_points_collected
+
    JSL $00F38A|!bank
    ;%spawn_score_sprite()
else
?collected_coins:
    sep #$20
endif   




if !star_coin_give_coins == !yes
    lda #!star_coin_coin_amount
    jsl $05B329|!bank
endif


    lda.b #!star_coin_sfx
    sta !star_coin_sfx_port|!addr


if !star_coin_glitter == !yes
    %glitter()
endif   

if !max_star_coins >= 9
    rep #$20
    lda !level_star_coins
    eor.w #!max_star_coins_bits
    sep #$20
else    
    lda !level_star_coins
    eor.b #!max_star_coins_bits
endif   
    bne ?dont_set_bit
    lda $13BF|!addr
    and #$07
    tax
    lda $05B35B|!bank,x
    pha
    lda $13BF|!addr
    lsr #3
    tax
    pla
    ora !star_coin_all_flags,x
    sta !star_coin_all_flags,x
?dont_set_bit:

    rtl
