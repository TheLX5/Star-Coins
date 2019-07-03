db $42		; enable corner and inside offsets
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

	!MIDWAY_POINT_NUMBER = $01	; 00 = regular midway point, 01 = midway point 2, ect

MarioBelow:
MarioAbove:
MarioSide:
MarioCorner:
HeadInside:
BodyInside:
	LDX $13BF|!addr			; get translevel number
	LDA !RAM_Midway,x		; get current midway point number
	CMP #!MIDWAY_POINT_NUMBER	; compare with which midway point number we're setting
	BCS DONT_SET_MIDWAY		; if higher or equal, don't set the midway point number
	LDA #!MIDWAY_POINT_NUMBER	; otherwise set the midway point number
	STA !RAM_Midway,x		;
DONT_SET_MIDWAY:

SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
	LDA #$38
	STA $1693|!addr			; act like midway point bar no matter what it's set to act like
	LDY #$00
	RTL

print "First EXTRA midway point."