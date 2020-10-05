game_start: 
    call background_paint

    
    call init_sprites
    ret

game_update:
    ld bc,WAITING_TIME
	call wait
	
    call check_keys

	call bullet_update
	call player_update


	ret

game_draw:
    call enemy_draw
	call bullet_draw
	call player_draw
    
	ret


init_sprites:
	ld a,0							
	ld bc,$303b					
	out (c),a
						
	ld b,SPRITE_COUNT	
	ld hl,Sprite0
is_loop:
	push bc							
	ld bc,$005b						
	otir							
	pop bc 							
	djnz is_loop					
	ret 							




WAITING_TIME equ 10000