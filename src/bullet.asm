bullets:
    db FALSE,0,0,2
    db FALSE,0,0,5
    db FALSE,0,0,6
    db FALSE,0,0,7
    db 255
BULLET_DATA_LENGTH equ 4

BULLET_ATTR_2 equ 0
BULLET_ATTR_3 db %10000011

BULLET_SPEED equ 2




bullet_spawn:
    ld ix,bullets
b_spawn:
    ld a,(ix)
    cp 255
    ret z
    cp FALSE
    jp nz,b_spawn_next

    ; BREAKPOINT
    ; spawn a bullet now...
    ld a,TRUE
    ld (ix),a

    ld a,(px)
    ld (ix+1),a

    ld a,PLAYER_Y
    ld (ix+2),a

    ret
b_spawn_next:
    ld de,BULLET_DATA_LENGTH
    add ix,de
    jp b_spawn


bullet_update:
    ld ix,bullets
b_update:
    ld a,(ix)
    cp 255
    ret z
    cp FALSE
    jp z, b_update_next

    ;Update loop...
    call bullet_move
b_update_next:
    ld de,BULLET_DATA_LENGTH
    add ix,de
    jp b_update
    



;IX=current bullet
bullet_move:
    ld a,(ix+2)
    sub BULLET_SPEED
    cp 10 ;min y
    ret c
    ld (ix+2),a
    ret






bullet_draw:
    ld ix,bullets
b_draw:
    ld a,(ix)
	cp 255
	ret z
    cp FALSE
    jp z,b_draw_next

    ;select slot 
	ld a,(ix+3)
	ld bc, $303b
	out (c), a
	
	ld bc, $57
	;attr 0
	ld a, (ix+1)
	out (c), a   
	;attr 1
	ld a,(ix+2)
	out (c), a                                      
    ;attr 2
	ld a, BULLET_ATTR_2
	out (c), a
	;attr 3
	ld a,BULLET_ATTR_3
	out (c),a
b_draw_next:
    ld de,BULLET_DATA_LENGTH
	add ix,de
	jp b_draw


