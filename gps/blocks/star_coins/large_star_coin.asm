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

;xxx4 321x
;xxx4 321x
	
	phx
	phy

	lda $03
	and #$0E
	sta $05
	lda $03
	sec
	sbc #$10
	lsr #2
	and #$10
	ora $05
	and #$1E
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

	pei ($98)
	pei ($9A)
	pei ($03)
if !star_coin_blk_outline == !no
	ldy #$00
	ldx #$00
.loop	
	%erase_block()
	iny
	cpy #$04
	bcs .end_tile
	rep #$20
	lda $01,s
	and #$0010
	bne .is_top
.is_bottom
	cpy #$02
	bcc .shared_tile
	lda $05,s
	sec
	sbc #$0010
	sta $98
	bra .shared_tile
.shared_tile
	lda $01,s
	lsr
	lda $9A
	bcs .is_bottom_right
.is_bottom_left
	adc #$0010
	sta $9A
	lda $01,s
	inc
	bra .is_bottom_end
.is_bottom_right
	sbc #$0010
	sta $9A
	lda $01,s
	dec
.is_bottom_end
	sta $01,s
	sep #$20
	bra .loop

.is_top
	cpy #$02
	bcc .shared_tile
	lda $05,s
	clc
	adc #$0010
	sta $98
	bra .shared_tile

else


	ldy #$00
	ldx #$00
.loop
	phy
	phx
	rep #$30
	lda $03,s
	clc
	adc #$0100
	tax
	sep #$20
	%change_map16()
	sep #$10
	plx
	ply
	iny
	cpy #$04
	bcs .end_tile
	rep #$20
	lda $01,s
	and #$0010
	bne .is_top
.is_bottom
	cpy #$02
	bcc .shared_tile
	cpx #$00
	bne .shared_tile
	inx
	lda $01,s
	sec
	sbc #$0010
	sta $01,s
	lda $05,s
	sec
	sbc #$0010
	sta $98
	bra .shared_tile
.shared_tile
	lda $01,s
	lsr
	lda $9A
	bcs .is_bottom_right
.is_bottom_left
	adc #$0010
	sta $9A
	lda $01,s
	inc
	bra .is_bottom_end
.is_bottom_right
	sbc #$0010
	sta $9A
	lda $01,s
	dec
.is_bottom_end
	sta $01,s
	sep #$20
	bra .loop

.is_top
	cpy #$02
	bcc .shared_tile
	cpx #$00
	bne .shared_tile
	inx
	lda $01,s
	clc
	adc #$0010
	sta $01,s
	lda $05,s
	clc
	adc #$0010
	sta $98
	bra .shared_tile
	
endif	
.end_tile
	rep #$20
	pla
	sta $03
	pla
	sta $9A
	pla
	sta $98
	sep #$20

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

print "Large Star Coin. It's ID/Number depends on the Map16 tile."