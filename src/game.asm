game_start: 
	; nextreg $15,%00000011
		
    call background_paint

	ld b,SPRITE_COUNT
    ld hl,Sprite0
    call init_sprites
	
    ret

game_update:
	ld b,1
	call WaitRasterLine
  	
    call check_keys

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