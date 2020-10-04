    org 0x6000

    DEVICE ZXSPECTRUMNEXT
    CSPECTMAP "project.map"

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
	include 'retrotools\tools.asm'
	include 'enemy.asm'


    SAVENEX OPEN "main.nex", start, stack_top
    SAVENEX CORE 2,0,0 ;Next core 2.0.0 required as minimum
    SAVENEX CFG 4 ;Border color (seems to not work!!)
    SAVENEX AUTO
    SAVENEX CLOSE