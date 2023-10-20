;#######################################################################
;# level_load
;# Loads and prepares several RAMs on level load.
;# It also handles the Conditional Map16 bits.
;# (Looks a bit ugly due to heavy usage of if-else conditionals)

level_load:
	lda $141A|!addr
	bne .no_load

.start_load
	phx
	phy

if !remember_midway == !yes
if !keep_midway_coins == !no
	lda !previous_ow_level
	cmp #$FF
	beq .same_ow_level
	cmp $13BF|!addr
	beq .same_ow_level
if !max_star_coins >= 9
	rep #$30
	and #$00FF
	asl
	tax
	lda #$0000
	sta !star_coin_midway_flags,x
	sep #$30
else
	tax
	lda #$00
	sta !star_coin_midway_flags,x
endif	
.same_ow_level
endif

	ldx $13BF|!addr

if !mmp == 1
	lda $1EA2|!addr,x
	and #$40
	bne .handle_midway
	lda !RAM_Midway,x
	beq .handle_new_level
else
	lda $1EA2|!addr,x
	and #$40
	beq .handle_new_level
endif	

.handle_midway
if !max_star_coins >= 9
	rep #$30
	txa
	asl
	tax
endif

	lda !star_coin_midway_flags,x
	sta !midway_star_coins
	bra .load_star_coins
	
endif

.handle_new_level
if !max_star_coins >= 9
	rep #$30
	txa
	asl
	tax
endif	
	
	lda !star_coin_level_flags,x
	sta !midway_star_coins
	
.load_star_coins
	sta !level_star_coins
	
if !use_conditional_map16 == !yes
	sta $7FC060+!conditional_map16_flag
endif
	
	sep #$10
	ldx.b #!max_star_coins-1
	ldy #$00
.loop	
	lsr
	bcc .next
	iny
.next	
	dex
	bpl .loop
.end	
	sep #$20
	tya
	sta !level_total_star_coins
	lda #$00
	sta !level_star_coins_num
	
	lda $13BF|!addr
	sta !previous_ow_level
	ply
	plx

.no_load	
	rtl

;#######################################################################
;# ow_load
;# Saves Star coins collected to RAM and updates !game_total_star_coins
;# if the level was completed.

ow_load:
	phx
if !perma_coins == !no
	
if !save_on_misc_exit == !no
	lda $0DD5|!addr
	bpl .return_level_end
	sec
	sbc #$80
	beq .return_no_exit
endif

.return_level_end
if !max_star_coins >= 9
	rep #$30
	lda $13BF|!addr
	and #$00FF
	asl
	tax
else	
	ldx $13BF|!addr
endif	
	lda !level_star_coins
	ora !star_coin_level_flags,x
	sta !star_coin_level_flags,x
if !remember_midway == !yes
	lda !midway_star_coins
	sta !star_coin_midway_flags,x
endif	
if !max_star_coins <= 8
	rep #$30
endif	
	lda !level_star_coins_num
	and #$00FF
	clc
	adc !game_total_star_coins
	sta !game_total_star_coins
	sep #$30
	
endif	

if !remember_midway == !yes
	ldx $13BF|!addr
	lda $1EA2|!addr,x
	and #$40
	bne .return_no_exit
if !mmp == 1
	lda !RAM_Midway,x
	bne .return_no_exit
endif	
endif	
	lda #$00
	sta !midway_star_coins
	
.return_no_exit
	lda #$00
	sta !level_star_coins
	sta !level_star_coins_num
	sta !level_total_star_coins
	
	plx
	rtl

;#######################################################################
;# ow_main
;# Updates !level_star_coins with the needed information, useful for
;# OW displays. It also updates $13BF, used in level load.

ow_main:
	phx
	phy
	
	ldy $0DD6|!addr
	lda $1F17|!addr,y
	lsr #4
	sta $00
	lda $1F19|!addr,y
	and #$F0
	ora $00
	sta $00
	lda $1F1A|!addr,y
	asl
	ora $1F18|!addr,y
	ldy $0DB3|!addr
	ldx $1F11|!addr,y
	beq +
	clc
	adc #$04
+	
	sta $01
	rep #$10
	ldx $00
if !sa1 == 0
	lda $7ED000,x
else
	lda $40D000,x
endif
	sta $13BF|!addr
	sep #$10
	tax
	
if !remember_midway == !yes
	lda $1EA2|!addr,x
	bmi .load_level_flags
	and #$40
	beq .load_level_flags
if !mmp == 1
	lda !RAM_Midway,x
	beq .load_level_flags
endif	

if !max_star_coins >= 9
	rep #$30
	txa
	asl
	tax
	lda !star_coin_midway_flags,x
	sta !level_star_coins
	sep #$30
else
	lda !star_coin_midway_flags,x
	sta !level_star_coins
endif
	bra .end
endif	

.load_level_flags
if !max_star_coins >= 9
	rep #$30
	txa
	asl
	tax
	lda !star_coin_level_flags,x
	sta !level_star_coins
	sep #$30
else
	lda !star_coin_level_flags,x
	sta !level_star_coins
endif

.end		
	ply
	plx
	rtl
