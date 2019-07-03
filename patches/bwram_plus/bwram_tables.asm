;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file is where you put the BW-RAM addresses that will be saved
;; to BW-RAM and their default values.
;; 
;; How to add a BW-RAM address to save.
;; 1) Select which things you want to save in a save file, for example,
;; Mario and Luigi coins, lives, powerup, item box and yoshi color.
;; 
;; 2) Go to bw_ram_table and add the BW-RAM address AND the amount of
;; bytes to save:
;;
;;		dl $400DB4 : dw $000A
;; 
;; Like SRAM Plus, you need to be sure that those RAM addresses aren't
;; cleared automatically when loading a save file.
;; 
;; 3) Then go to bw_ram_defaults and put the default values of your
;; BW-RAM address when loading a new file. Make sure that the default
;; values are in the same order as bw_ram_table to not get weird values
;; when loading a save file.
;; 
;; There is a maximum amount of bytes that you can save per save file
;; and that value is 2370 bytes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc ../star_coins_defs.asm

bw_ram_table:
;Put save ram addresses here, not after .end.

if !mmp == 1 : dl !RAM_Midway : dw $0060
if !max_star_coin >= 9 : dl !star_coin_ram+$07 : dw $018E	;Star coins ram
if !max_star_coin < 9 : dl !star_coin_ram+$05 : dw $00CE	


.end
		
bw_ram_defaults:
;Format: db $xx,$xx,$xx...
;^valid sizes: db (byte), dw (word, meaning 2 bytes: $xxxx), and dl
;(long, 3-bytes: $xxxxxx). The $ (dollar) symbol isn't mandatory,
;just represents hexadecimal type of value.

if !mmp == 1 : fillbyte $00 : fill $0060		;Multiple Midway Points
		dw $0000				;!game_total_star_coins
		fillbyte $00 : fill $00C0		;flags
if !max_star_coin >= 9 : fillbyte $00 : fill $00C0	;extra flags
		fillbyte $00 : fill $000C		;all star coins flags