game_start: 
	
		
    call background_start

	ld b,SPRITE_COUNT
    ld hl,rpg_pack1
    call init_sprites

	
	
    ret

game_update:
	ld b,1
	call WaitRasterLine
  	
    call check_keys
	call background_update
	call bullet_update
	call player_update
	call enemy_update


	ret

game_draw:
    
	call bullet_draw
	call player_draw
	call enemy_draw
    
	ret



WAITING_TIME equ 10000