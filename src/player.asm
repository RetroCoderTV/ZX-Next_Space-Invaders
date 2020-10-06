current_anim_frame db 0
TOTAL_ANIM_FRAMES equ 2

PLAYER_Y equ 191
px dw 160


PLAYER_SPEED equ 2
PLAYER_ATTR_SLOT equ 127
player_attribute_2 db %00000000
player_attribute_3 db %11000000
player_attribute_4 db %00100000


GUTTER equ 32


player_update:
	call increment_anim_frame

	ld a,(keypressed_Space)
	cp TRUE
	call z, fire_photon_torpedos

	ld a,(keypressed_A)
    cp TRUE
    jp z,move_left

	ld a,(keypressed_D)
	cp TRUE
	jp z,move_right

	

    ret





fire_photon_torpedos:
	ld a,(keypressed_Space_Held)
	cp TRUE
	ret z
	call bullet_spawn
	ret




increment_anim_frame:
	ld a,(current_anim_frame)
	add a,1
	ld (current_anim_frame),a
	cp TOTAL_ANIM_FRAMES
	ret c

	xor a
	ld (current_anim_frame),a
	ret

player_draw:
	;select slot
	ld a,PLAYER_ATTR_SLOT
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0
	ld a,(px)
	out (c), a    

	;attr 1                                  
	ld a,PLAYER_Y
	out (c), a                                      

	;attr 2
	ld a,(player_attribute_2)
	ld b,a
	ld hl,px
	inc hl
	ld a,(hl)
	or b
	out (c),a

	;attr 3
	ld a,(player_attribute_3)
	out (c),a

	;attr 4
	ld a,(player_attribute_4)
	out (c),a

	ret

move_right:
	ld hl,px
	inc hl
	ld a,(hl)
	bit 0,a
	jp nz,check_right_edge
do_move_right:
	ld hl,(px)
	ld de,PLAYER_SPEED
	add hl,de
	ld (px),hl
	ret
check_right_edge:
	dec hl
	ld a,(hl)
	cp 12 ;screen right
	ret nc
	jp do_move_right


move_left:
	ld hl,px
	inc hl
	ld a,(hl)
	bit 0,a
	jp z,check_left_edge	
do_move_left:
	ld hl,(px)
	ld de,-PLAYER_SPEED
	add hl,de
	ld (px),hl
	ret
check_left_edge:
	dec hl
	ld a,(hl)
	cp GUTTER+5
	ret c
	jp do_move_left
	