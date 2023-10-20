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
    lda $13BF|!addr
    and #$07
    tax
    lda $05B35B|!bank,x
    sta $00
    lda $13BF|!addr
    lsr #3
    tax
    lda !star_coin_all_flags,x
    and $00
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

print "Passable if the player has collected every single Star Coin in the level. Uses the Acts Like setting to determine the other behavior (including sprites and fireballs)."