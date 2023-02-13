incsrc star_coins_defs.asm

star_coin_main:
	pha
if !max_star_coins >= 9
	and #$0F
	rep #$20
else
	and #$07
endif
	sta $0E
	tax
	
	ldy.b #!star_coins_page
	lda reverse_bits,x
	and !level_star_coins
if !max_star_coins >= 9
	sep #$20
endif
	beq +
	iny
+	sty $0F
	
	pla
	lsr #3
	and #$06
	tax
	ldy $57
	jmp (.sizes,x)

.sizes
dw .16x16
dw .16x32
dw .32x32
dw .return					; Failsafe

.16x16
	lda $0E
	;clc : adc #$00			; Tile number for first 16x16 Star Coin
	sta [$6B],y
	lda $0F
	sta [$6E],y
	rts

.16x32
	lda $0E
	clc : ADC #$10			; Tile number for first 16x32 Star Coin
	pha
	sta [$6B],y
	lda $0F
	sta [$6E],y
	jsr ShiftObjDown
	pla
	clc : adc #$10
	sta [$6B],y
	lda $0F
	sta [$6E],y
	rts

.32x32
	lda $0E
if !max_star_coins >= 9
	pha
	and #$07
	asl
	sta $0e
	pla
	and #$08
	asl #2
	ora $0e
else
	and #$07
	asl
endif
	clc : adc #$30			; Tile number for first 32x32 Star Coin
	sta $0e
	lda $0E
	sta [$6B],y
	lda $0F
	sta [$6E],y
	jsr ShiftObjRight
	lda $0E
	inc
	sta [$6B],y
	lda $0F
	sta [$6E],y
	jsr ShiftObjDown
	lda $0e
	clc : adc #$10
	sta [$6B],y
	lda $0F
	sta [$6E],y
	jsr ShiftObjRight
	lda $0e
	clc : adc #$11
	sta [$6B],y
	lda $0F
	sta [$6E],y

.return
	rts

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

macro star_coin_small(id)
	lda.b #(<id>-1)
	jmp star_coin_main
endmacro

macro star_coin_medium(id)
	lda.b #(<id>-1)|$10
	jmp star_coin_main
endmacro

macro star_coin_large(id)
	lda.b #(<id>-1)|$20
	jmp star_coin_main
endmacro

macro star_coin_variable()
	lda $58
	jmp star_coin_main
endmacro
