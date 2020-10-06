
;Enemy sprite types:
FACE equ 1
INVADER equ 2





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
	out (c), a
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