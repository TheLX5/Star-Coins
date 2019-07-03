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
	tay
	asl
	tax

	%star_coin_shared()

	pei ($03)
if !star_coin_outline == !no
	%erase_block()
	rep #$20
	pla
	and #$0010
	beq .is_top
.is_bottom
	lda $98
	sec
	sbc #$0010
	bra .tile_erase
.is_top	
	lda $98
	clc
	adc #$0010
.tile_erase
	sta $98
	sep #$20
	%erase_block()
	rep #$20
	
else
	ldy #$00
	rep #$20
.next_tile
	phy
	rep #$10
	lda $02,s
	clc
	adc #$0100
	tax
	%change_map16()
	sep #$10
	ply
	iny
	cpy #$02
	bcs .end_tile_change
	lda $01,s
	and #$0010
	bne .is_top
.is_bottom
	lda $01,s
	sec
	sbc #$0010
	sta $01,s
	lda $98
	sec
	sbc #$0010
	bra .tile_change
.is_top	
	lda $01,s
	clc
	adc #$0010
	sta $01,s
	lda $98
	clc
	adc #$0010
.tile_change
	sta $98
	bra .next_tile
	
.end_tile_change
endif	
	pla
	sta $03
	sep #$20

	ply
	plx
	
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
	rtl

if !max_star_coins >= 9
reverse_bits:
	dw $0001,$0002,$0004,$0008
	dw $0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800
	dw $1000,$2000,$4000,$8000
else
reverse_bits:
	db $01,$02,$04,$08
	db $10,$20,$40,$80
endif

print "Medium Star Coin. It's ID/Number depends on the Map16 tile."