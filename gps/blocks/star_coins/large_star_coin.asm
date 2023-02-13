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
	and #$0E
if !max_star_coins >= 9
	sta $05
	and #$0F
	lda $03
	sec
	sbc #$10
	lsr #2
	and #$10
	ora $05
	and #$1E
else
	lsr
endif
	tax

	%star_coin_shared()

	pei ($98)
	pei ($9A)
	pei ($03)
if !star_coin_outline == !no
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
if !max_star_coins >= 9
	dw $0001,$0002,$0004,$0008
	dw $0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800
	dw $1000,$2000,$4000,$8000
else
	db $01,$02,$04,$08
	db $10,$20,$40,$80
endif


print "Large Star Coin. It's ID/Number depends on the Map16 tile."