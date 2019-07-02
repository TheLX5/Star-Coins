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


if !star_coin_outline == !no
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