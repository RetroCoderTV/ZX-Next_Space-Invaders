
;Enemy sprite types:
DEAD equ 0
FACE equ 1
INVADER equ 2

enemy_current_direction db LEFT
enemy_current_anim_frame db 0
ENEMY_TOTAL_ANIM_FRAMES equ 2




;isalive,x,y
enemies:
    db FACE,40,60,1
    db FACE,60,60,2
    db FACE,80,60,3
    db 255
ENEMIES_DATA_LENGTH equ 3


enemy_update:
	call increment_anim_frame

    
    ret


enemy_increment_anim_frame:
	ld a,(enemy_current_anim_frame)
	add a,1
	ld (enemy_current_anim_frame),a
	cp TOTAL_ANIM_FRAMES
	ret c

	xor a
	ld (enemy_current_anim_frame),a
	ret



enemy_draw:
    ld ix,enemies
e_drw:
    ld a,(ix)
    cp 255
    ret z
	;TODO: What TF!!!!! is the 'slot' for ???
	;select slot 
	ld a,(ix+3)
	ld bc, $303b
	out (c), a

	;send pattern data
	; call enemy_set_sprite
    ld hl,Sprite2
	ld bc,0x005b
	otir


	;out 0x57, 32:  x position in 32
	;out 0x57, 32:  y position in 32
	;out 0x57, 0:  no palette offset and no rotate and mirrors flags
	;out 0x57, 130:  sprite visible and show pattern #0
	ld bc, $57
	ld a, (ix+1)
	out (c), a                                      ; x pos is 16 bit number, if over 255 msb stored below
	ld a,(ix+2)
	out (c), a                                      ; y pos


    ;flip
	ld a, %00000000
	out (c), a

	
	;vis
	ld a,%11000000
	out (c),a

	;zoom
	ld a,%00101000
	out (c),a

    ld de,ENEMIES_DATA_LENGTH
    add ix,de
    jp e_drw
	





enemy_set_sprite:
    ld a,(ix)
    cp FACE 
	jp z,load_sprite_face
	cp INVADER 
	jp z,load_sprite_invader
	ret

load_sprite_face:
	ld hl,Sprite2
	ret

load_sprite_invader:
	ld hl,Sprite1
	ret

