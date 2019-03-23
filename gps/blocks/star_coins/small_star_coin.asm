incsrc ../../star_coins_defs.asm

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
	
	phx
	phy

	lda $03
	and #$0F
	asl
	tax
	tay
	rep #$20
	lda.l reverse_bits,x

if !perma_coins == !no
	ora !level_star_coins
	sta !level_star_coins
	sep #$20
	
	lda !level_star_coins_num
	inc
	sta !level_star_coins_num
	
	lda !level_total_star_coins
	inc
	sta !level_total_star_coins
else	
	pha
	rep #$10
	lda $13BF|!addr
	asl
	tax
	pla
	ora !star_coin_level_flags,x
	sta !star_coin_level_flags,x

	lda !game_total_star_coins
	inc
	sta !game_total_star_coins
	sep #$30
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


if !star_coin_blk_outline == !no
	%erase_block()
else	
	rep #$10
	lda $04
	inc
	xba
	lda $03
	tax
	%change_map16()
	sep #$10
endif	

	ply
	plx
	
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
	rtl

reverse_bits:
	dw $0001,$0002,$0004,$0008
	dw $0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800
	dw $1000,$2000,$4000,$8000

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

print "Small Star Coin. It's ID/Number depends on the Map16 tile."