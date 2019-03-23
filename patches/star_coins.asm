

incsrc star_coins_defs.asm

if !sa1 == 1
	sa1rom
endif

;#######################################################################
;# Exceptions and forcing things.

	if !create_numeric_counter == !yes
		!create_symbol_counter = !no
	else
		if !create_symbol_counter == !no
			!create_counter = !no
		endif
	endif
	
	!insert = !no

	if !remember_midway == !yes
		!insert = !yes
	endif

	if !create_counter == !yes
		!insert = !yes
	endif
		
	print "Star Coins v2.0.0 patch"
	print " "

if !insert == !no
	print "Nothing was inserted."
	print "You didn't enable !","remember_midway or !","create_counter."
else

;#######################################################################
;# Hijacks

if !remember_midway == !yes
org $00F2E8|!bank
	autoclean jsl midway_add_up
endif

if !create_counter == !yes
org $008FD8|!bank
	jsl status_bar_counters
	rts
endif

freecode

if !remember_midway == !yes
midway_add_up:
	ldx $13BF|!addr
	lda $1EA2|!addr,x
	ora #$40
	sta $1EA2|!addr,x
	rep #$30
	txa
	asl
	tax
	lda !level_star_coins
	sta !midway_star_coins
	sta !star_coin_midway_flags,x
	sep #$30
	lda #$05
	sta $1DF9|!addr
	rtl	
endif

if !create_counter == !yes
status_bar_counters:

if !yoshi_coins_counter == !yes
	lda $1422|!addr
	cmp #$05
	phk
	pea.w .yc_counter-1
	pea $84CE
	jml $008FDD|!bank
.yc_counter
endif	

if !create_symbol_counter == !yes
	rep #$20
	ldx.b #(!max_star_coins-1)*2
if !symbol_reverse_order == !yes
	ldy #$00
else	
	ldy.b #!max_star_coins-1
endif
-	
	lda !level_star_coins
	and.l reverse_bits,x
	sep #$20
	beq +
	lda #!symbol_full_tile
	bra ++
+	
	lda #!symbol_blank_tile
++	
	sta !symbol_counter_pos,y
	rep #$20
if !symbol_reverse_order == !yes
	iny
else	
	dey
endif
	dex #2
	bpl -
	sep #$20
endif

if !create_numeric_counter == !yes
	
endif
	rtl



if !create_symbol_counter == !yes
reverse_bits:
	dw $0001,$0002,$0004,$0008
	dw $0010,$0020,$0040,$0080
	dw $0100,$0200,$0400,$0800
	dw $1000,$2000,$4000,$8000
endif

endif


print "Inserted ",freespaceuse," bytes."
endif