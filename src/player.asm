current_direction db LEFT
current_anim_frame db 0
TOTAL_ANIM_FRAMES equ 2

PLAYER_Y equ 191-16
px db 160



player_update:
	call increment_anim_frame


	ld a,(keypressed_A)
    cp TRUE
    jp z,move_left

	ld a,(keypressed_D)
	cp TRUE
	jp z,move_right


	

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
	ld bc, $303b
	out (c), a

	ld bc, $57
	;attr 0
	ld a, (px)
	out (c), a    

	;attr 1                                  
	ld a,PLAYER_Y
	out (c), a                                      

	;attr 2
	ld a,(current_direction)
	cp LEFT
	push af
	call z,reset_flip_bit
	pop af
	cp RIGHT 
	push af
	call z,set_flip_bit
	pop af

	;attr 3
	ld a,%11000001
	out (c),a

	;attr 4
	ld a,%00100000
	out (c),a

	ret




load_anim_frame_0:
	ld hl,Sprite0
	ret

load_anim_frame_1:
	ld hl,Sprite1
	ret



set_flip_bit:
	ld a, %00001000 ;todo set only that bit
	out (c), a
	ret

reset_flip_bit:
	ld a, %00000000
	out (c), a
	ret








move_right:
	ld a,(px)
	add a,1
	cp 254
	jp nc, flip_direction
	ld (px),a
	ret


move_left:
	ld a,(px)
	sub 1
	cp 17
	jp c, flip_direction
	ld (px),a
	ret




flip_direction:
	ld a,(current_direction)
	cp LEFT
	jp z,set_direction_right
	cp RIGHT
	jp z,set_direction_left
	ret

set_direction_right:
	ld a,RIGHT
	ld (current_direction),a
	ret

set_direction_left:
	ld a,LEFT
	ld (current_direction),a
	ret
