current_anim_frame db 0
TOTAL_ANIM_FRAMES equ 2

PLAYER_Y equ 191-16
px db 160


ANCHORED equ %00100000
VISIBILITY equ %10000000
EXTENDED equ %01000000
MIRROR_X equ %00001000
MIRROR_Y equ %00000100

player_attribute_2 db %00000000
player_attribute_3 db %11000000
player_attribute_4 db %00100000


player_update:
	call increment_anim_frame

	ld a,(keypressed_A)
    cp TRUE
    jp z,move_left

	ld a,(keypressed_D)
	cp TRUE
	jp z,move_right

	ld a,(keypressed_Space)
	cp TRUE
	jp z, fire_photon_torpedos

    ret





fire_photon_torpedos:
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
	ld a,0
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0
	ld a, (px)
	out (c), a    

	;attr 1                                  
	ld a,PLAYER_Y
	out (c), a                                      

	;attr 2
	ld a,(player_attribute_2)
	out (c),a

	;attr 3
	ld a,(player_attribute_3)
	out (c),a

	;attr 4
	ld a,(player_attribute_4)
	out (c),a

	ret

move_right:
	ld a,(px)
	add a,1
	cp 250
	ret nc
	ld (px),a
	ret


move_left:
	ld a,(px)
	sub 1
	cp 8
	ret c
	ld (px),a
	ret

