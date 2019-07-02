;#######################################################################
;# Star Coins shared routine for blocks.
;# 
;# 

if !perma_coins == !no
if !max_star_coins >= 9
	rep #$20
	lda.l reverse_bits,x
	ora !level_star_coins
	sta !level_star_coins
	sep #$20
else	
	tyx
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
	lda.l points-1,x
	%spawn_score_sprite()
endif	


if !star_coin_give_coins == !yes
	lda #!star_coin_coin_amount
	jsl $05B329|!bank
endif


	lda.b !star_coin_sfx
	sta !star_coin_sfx_port|!addr


if !star_coin_glitter == !yes
	%glitter()
endif	


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
	

	rtl
