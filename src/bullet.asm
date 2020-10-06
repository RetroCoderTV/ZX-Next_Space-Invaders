bullet_alive db FALSE
bx dw 0
by dw 0
bullet_slot db 126
BULLET_DATA_LENGTH equ 4*2

BULLET_ATTR_2 equ 0
BULLET_ATTR_3 equ %10000100
BULLET_ATTR_3_DEAD equ %00000100

BULLET_SPEED equ 3




bullet_spawn:
    ld a,(bullet_alive)
    cp TRUE
    ret z


    ; spawn a bullet now...
    ld a,TRUE
    ld (bullet_alive),a

    ld hl,(px)
    ld (bx),hl

    ld hl,PLAYER_Y
    ld (by),hl

    ; BREAKPOINT

    ret



bullet_update:
    ld a,(bullet_alive)
    cp TRUE
    ret nz

    ;Update loop...
    call bullet_move

    ret

    
bullet_move:
    ld a,(by)
    sub BULLET_SPEED
    cp 8 ;min y
    jp c,bullet_kill
    ld (by),a
    ret


bullet_kill:   
    ld a,DEAD
    ld (bullet_alive),a
    ret




bullet_draw:
    ; ld a,(bullet_alive)
	; cp TRUE
	; ret nz

    ;select slot 
	ld a,(bullet_slot)
	ld bc, $303b
	out (c), a
	
	ld bc, $57
	;attr 0
	ld a,(bx)
	out (c), a   
	;attr 1
	ld a,(by)
	out (c), a                                      
    ;attr 2
	ld a, BULLET_ATTR_2
	ld b,a
	ld hl,bx
	inc hl
	ld a,(hl)
	or b
	out (c),a
	;attr 3
    ld a,(bullet_alive)
    cp TRUE
    jp nz,bullet_load_vis_dead
	ld a,BULLET_ATTR_3
	out (c),a
    

    ret


bullet_load_vis_dead
    ld a,BULLET_ATTR_3_DEAD
    out (c),a
    ret