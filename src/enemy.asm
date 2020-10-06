
;Enemy sprite types:
FACE equ 1
INVADER equ 2



enemy_direction db RIGHT
ENEMY_SPEED equ 2

ENEMY_MIN_X equ 32 ;X8 not set
ENEMY_MAX_X equ 17 ;X8 set



;attr_3,x,y, attri slot, 
enemies:
    dw VISIBILITY+7,32,60,1
    dw VISIBILITY+7,64,60,2
    dw VISIBILITY+7,96,60,3
    dw VISIBILITY+7,128,60,4
    dw VISIBILITY+7,160,60,5
    dw VISIBILITY+7,192,60,6
    dw VISIBILITY+7,224,60,7
    dw VISIBILITY+6,32,80,8
    dw VISIBILITY+6,64,80,9
    dw VISIBILITY+6,96,80,10
    dw VISIBILITY+6,128,80,11
    dw VISIBILITY+6,160,80,12
    dw VISIBILITY+6,192,80,13
    dw VISIBILITY+6,224,80,14
	dw VISIBILITY+5,32,100,15
    dw VISIBILITY+5,64,100,16
    dw VISIBILITY+5,96,100,17
    dw VISIBILITY+5,128,100,18
    dw VISIBILITY+5,160,100,19
    dw VISIBILITY+5,192,100,20
    dw VISIBILITY+5,224,100,21
	dw 255
ENEMIES_DATA_LENGTH equ 4*2

ENEMY_ATTR_2 equ 0



enemy_update:
	ld ix,enemies
e_update:
	ld a,(ix)
	cp 255
	ret z
	cp DEAD
	jp z,e_update_next

	;Update Loop:
	call enemy_check_collision_bullet
	call enemy_move

e_update_next:
	ld de,ENEMIES_DATA_LENGTH
	add ix,de
	jp e_update
	




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










;IX=current enemy
enemy_check_collision_bullet:
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




enemy_kill:
	ld a,(ix)
	bit 7,a
	ret z

	ld a,7
	call 0x229b
	
	ld (ix),DEAD
	ret

enemy_move:
	ld a,(enemy_direction)
	cp LEFT
	jp z,enemy_move_left
	cp RIGHT
	jp z,enemy_move_right
	ret


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
	jp c,enemy_toggle_direction
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
	jp nc,enemy_toggle_direction
	jp e_do_move_right


enemy_toggle_direction:
	ld a,(enemy_direction)
	cp RIGHT
	jp z,enemy_set_direction_left
	cp LEFT
	jp z,enemy_set_direction_right
	ret

enemy_set_direction_left:
	ld a,LEFT
	ld (enemy_direction),a
	ret

enemy_set_direction_right:
	ld a,RIGHT
	ld (enemy_direction),a
	ret