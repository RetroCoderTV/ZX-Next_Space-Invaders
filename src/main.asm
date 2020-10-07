    org 0x6000

    DEVICE ZXSPECTRUMNEXT
	
start:
	call game_start	

	jp main_loop

main_loop:
	call game_update
	call game_draw

	jp main_loop

STACK_SIZE equ 20
stack_bottom ds STACK_SIZE, 0
stack_top db 0  


	include 'background.asm'
	include 'constants.asm'
	include 'game.asm'
	include 'sprites.asm'
	include 'player.asm'
	include 'retrotools\keycacher.asm'
	include 'retrotools\spritetools.asm'
	include 'retrotools\tools.asm'
	include 'enemy.asm'
	include 'bullet.asm'


	MMU 7 n,0x20*2 ;MMU <first slot number> [<last slot number>|<single slot option>], <page number>[,<address>]
	org 0xE000
	incbin "space.bmp",1078

	MMU 7 n,0x23*2 ;MMU <first slot number> [<last slot number>|<single slot option>], <page number>[,<address>]
	org 0xE000
	incbin "space2.bmp",1078


	SAVENEX OPEN "main.nex", start , stack_top
    SAVENEX CORE 3, 0, 0      
    SAVENEX CFG 0, 0            
	SAVENEX AUTO
    SAVENEX CLOSE 

