game_start: 
    call background_paint
    call player_start
    call enemy_start
    ret

game_update:
    ld bc,WAITING_TIME
	call wait

    call check_keys


    
	call player_update
    call enemy_update

	ret

game_draw:
    call enemy_draw
	call player_draw
    
	ret



WAITING_TIME equ 10000