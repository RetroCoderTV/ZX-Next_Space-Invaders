game_start: 
    call background_paint
    ret

game_update:
    ld bc,WAITING_TIME
	call wait

    call check_keys


    call enemy_update
	call player_update
    

	ret

game_draw:
    call enemy_draw
	call player_draw
    
	ret



WAITING_TIME equ 10000