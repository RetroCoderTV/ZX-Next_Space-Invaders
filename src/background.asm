BG_COLOURS equ %00110001


;0x5B00
background_paint:
    ld a,3
    call 0x229b

    ld hl,0x5B00
    ld b,BG_COLOURS
bg_paint:
    ld (hl),b
    inc hl
    ld a,h
    cp 0x5E
    jp c,bg_paint
    ret