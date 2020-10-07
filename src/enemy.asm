
;Enemy sprite types:
FACE equ 62
INVADER equ 59
HAT equ 52

ENEMY_PALETTE equ %00000000

enemy_direction db RIGHT
ENEMY_SPEED equ 8

ENEMY_MIN_X equ 32 ;X8 not set
ENEMY_MAX_X equ 17 ;X8 set






;attr_3,x,y, attri slot, 
enemies:
    dw VISIBILITY+INVADER,32,	20,1
    dw VISIBILITY+INVADER,64,	20,2
    dw VISIBILITY+INVADER,96,	20,3
    dw VISIBILITY+INVADER,128,	20,4
    dw VISIBILITY+INVADER,160,	20,5
    dw VISIBILITY+INVADER,192,	20,6
    dw VISIBILITY+INVADER,224,	20,7
    dw VISIBILITY+FACE,32,		40,8
    dw VISIBILITY+FACE,64,		40,9
    dw VISIBILITY+FACE,96,		40,10
    dw VISIBILITY+FACE,128,		40,11
    dw VISIBILITY+FACE,160,		40,12
    dw VISIBILITY+FACE,192,		40,13
    dw VISIBILITY+FACE,224,		40,14
	dw VISIBILITY+HAT,32,		60,15
    dw VISIBILITY+HAT,64,		60,16
    dw VISIBILITY+HAT,96,		60,17
    dw VISIBILITY+HAT,128,		60,18
    dw VISIBILITY+HAT,160,		60,19
    dw VISIBILITY+HAT,192,		60,20
    dw VISIBILITY+HAT,224,		60,21
	dw 255
ENEMIES_DATA_LENGTH equ 4*2
ENEMY_ATTR_2 equ 0


enemy_need_toggle db FALSE
enemy_need_movedown db FALSE


ENEMY_MIN_INTERVAL equ 17
enemy_move_interval db 32
enemy_move_counter db 0
enemy_moved db FALSE



ENEMY_INTERVAL_DECREASE equ 4
ENEMY_DOWNWARD_AMOUNT equ 8


enemy_update:
	ld a,FALSE
	ld (enemy_need_toggle),a
	ld (enemy_moved),a

	ld a,(enemy_move_counter)
	add a,1
	ld (enemy_move_counter),a

	ld ix,enemies
e_update:
	ld a,(ix)
	cp 255
	jp z, e_update_end
	cp DEAD
	jp z,e_update_next

	;Update Loop:
	

	ld a,(enemy_move_interval)
	ld b,a
	ld a,(enemy_move_counter)
	cp b
	call nc, enemy_move

	ld a,(enemy_need_movedown)
	cp TRUE
	call z, enemy_move_down

	call enemy_check_collision_bullet

e_update_next:
	ld de,ENEMIES_DATA_LENGTH
	add ix,de
	jp e_update
e_update_end:
	ld a,FALSE
	ld (enemy_need_movedown),a

	ld a,(enemy_need_toggle)
	cp TRUE
	call z,enemy_toggle_direction

	ld a,(enemy_moved)
	cp TRUE
	call z,enemy_reset_move_counter
	ret
	

enemy_reset_move_counter:
	xor a
	ld (enemy_move_counter),a
	ret



enemy_draw:
    ld ix,enemies
e_draw:
	ld a,(ix)
	cp 255
	ret z

    ;select slot 
	ld a,(ix+6)
	ld bc, $303b
	out (c), a
	
	ld bc, $57
	;attr 0
	ld a, (ix+2)
	out (c), a   
	;attr 1
	ld a,(ix+4)
	out (c), a                                      
    ;attr 2
	ld a, ENEMY_ATTR_2
	or ENEMY_PALETTE
	ld b,a
	ld a,(ix+3)
	or b
	out (c),a
	;attr 3
	ld a,(ix)
	out (c),a
	
e_draw_next:
    ld de,ENEMIES_DATA_LENGTH
	add ix,de
	jp e_draw
;





;IX=current enemy
enemy_check_collision_bullet:
	ld a,(bullet_alive)
	cp TRUE
	ret nz

    ;passed the right side of enemy
    ld a,(bx)
	add a,6 ;bullet transparency offset
    ld b,a
    ld a,(ix+2)
    add a,16
    cp b
    ret c

    ;passed the left side of enemy
    ld a,(ix+2)
    ld b,a
    ld a,(bx)
    add a,10
    cp b
    ret c

    ;passed the bottom of enemy
    ld a,(by)
    ld b,a
    ld a,(ix+4)
    add a,16 ;enemy height
    cp b
    ret c

    ;passed the top of enemy
    ld a,(ix+4)
    ld b,a
    ld a,(by)
    add a,16 ;ph
    cp b
    ret c

	ld a,(ix+3)
	ld b,a
	ld hl,bx
	inc hl
	ld a,(hl)
	cp b
	ret nz

    ; collision...
    call enemy_kill
	call bullet_kill

	ret
;

enemy_kill:
	ld a,(ix)
	bit 7,a
	ret z

	ld (ix),DEAD

	call background_start2

	ret
;
enemy_move:
	ld a,(enemy_direction)
	cp LEFT
	push af
	call z,enemy_move_left
	pop af
	cp RIGHT
	push af
	call z,enemy_move_right
	pop af

	ld a,TRUE
	ld (enemy_moved),a
	
	ret
;

enemy_move_left:
	ld a,(ix+3)
	bit 0,a
	jp z,e_check_left_edge
e_do_move_left:
	ld hl,(ix+2)
	ld de,-ENEMY_SPEED
	add hl,de
	ld (ix+2),hl
	ret
e_check_left_edge:
	ld a,(ix+2)
	cp ENEMY_MIN_X
	call c,enemy_set_need_toggle
	jp e_do_move_left



enemy_move_right:
	ld a,(ix+3)
	bit 0,a
	jp nz,e_check_right_edge
e_do_move_right:
	ld hl,(ix+2)
	ld de,ENEMY_SPEED
	add hl,de
	ld (ix+2),hl
	ret
e_check_right_edge:
	ld a,(ix+2)
	cp ENEMY_MAX_X
	call nc,enemy_set_need_toggle
	jp e_do_move_right



enemy_set_need_toggle:
	ld a,TRUE
	ld (enemy_need_toggle),a

	ret

enemy_toggle_direction:
	ld a,(enemy_direction)
	cp RIGHT
	push af
	call z,enemy_set_direction_left
	pop af
	cp LEFT
	push af
	call z,enemy_set_direction_right
	pop af

	ld a,TRUE
	ld (enemy_need_movedown),a

	ld a,(enemy_move_interval)
	cp ENEMY_MIN_INTERVAL
	ret c
	sub ENEMY_INTERVAL_DECREASE
	ld (enemy_move_interval),a
	ret

enemy_move_down:
	ld a,(ix+4)
	add a,ENEMY_DOWNWARD_AMOUNT
	ld (ix+4),a

	ret

enemy_set_direction_left:
	ld a,LEFT
	ld (enemy_direction),a
	ret

enemy_set_direction_right:
	ld a,RIGHT
	ld (enemy_direction),a
	ret