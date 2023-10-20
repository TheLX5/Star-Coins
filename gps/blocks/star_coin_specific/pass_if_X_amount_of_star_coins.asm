db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

!star_coins_needed = 3      ; Number of Star Coins needed to pass
                            ; through the block.

!global_star_coins = !yes   ; Checks the game's total star coins
                            ; Set to !no to make it check the level's
                            ; total star coins instead.

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
    
    rep #$20
if !global_star_coins == !yes
    lda !game_total_star_coins
else    
    lda !level_total_star_coins
    and #$000F
endif   
    cmp.w #!star_coins_needed
    sep #$20
    bcc .no_collected
    ldy #$00
    lda #$25
    sta $1693|!addr
.no_collected
SpriteV:
SpriteH:
MarioFireball:
MarioCape:
    rtl

if !global_star_coins == !yes
    print "Passable if the player has over ",dec(!star_coins_needed)," Star Coins in the game. Uses the Acts Like setting to determine the other behavior (including sprites and fireballs)."
else    
    print "Passable if the player has over ",dec(!star_coins_needed)," Star Coins in the level. Uses the Acts Like setting to determine the other behavior (including sprites and fireballs)."
endif