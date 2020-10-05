
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
    db FACE,80,60,2
    db FACE,120,60,3
    db 255
ENEMIES_DATA_LENGTH equ 4



enemy_draw:
    ld ix,enemies
e_draw:
	ld a,(ix)
	cp 255
	ret z
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
	ld a, %00000000
	out (c), a
	;attr 3
	ld a,%11000010
	out (c),a
	;attr 4
	ld a,%00100000
	out (c),a

    ld de,ENEMIES_DATA_LENGTH
	add ix,de
	jp e_draw




