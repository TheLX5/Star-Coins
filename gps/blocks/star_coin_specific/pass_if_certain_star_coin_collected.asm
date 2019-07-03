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
	lda $03
	and #$0F
	tax
	lda !level_star_coins
	and.l reverse_bits,x
	beq .no_collected
	ldy #$00
	lda #$25
	sta $1693|!addr
.no_collected
SpriteV:
SpriteH:
MarioFireball:
MarioCape:
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

print "Passable if the player has collected a certain Star Coin in the level. The Star Coin number depends on the Map16 number."