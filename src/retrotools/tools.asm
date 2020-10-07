;MACROS
	MACRO BREAKPOINT 
		DW $01DD 
	ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wait for n clock cycles
;; Inputs: BC=n
;; Outputs: none
;; Destroys: A,BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait:
	dec bc
	ld a,b
	cp 0
	jp nz, wait
	ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wait for vertical blank
;; Inputs: B=frames delay count
;; Outputs: 
;; Destroys: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitRasterLine:
	call RastererWait
	djnz WaitRasterLine
	ret
RastererWait: 
	push bc 
	ld e,190 : ld a,$1f : ld bc,$243b : out (c),a : inc b 
WaitForLinea: 
	in a,(c) : cp e : jr nz,WaitForLinea 
	pop bc 
	ret




; ; very simple BMP loader, image needs to be 256*192 256 indexed RGB333 colour 
; ; image in a bmp is store upside down, so needs flipping before hand 
;     device zxspectrumnext
;     org $8000
 
; main_prog: 
    
;     nextreg $69,%10000000           ; turns on layer 2 
;     nextreg $7,3                    ; cpu speed 28, set to 0 to see in slow, 
;     xor a : out ($fe),a             ; border black 
;     nextreg $12,$20                 ; this now sets the layer 2 ram to 16kb ram $20 (so $40 in 8kb banks)
;     jp $
        
    
;     ; this bit places code inside the NEX that is loaded into RAM > 65536
;     MMU 7 n,$20*2                   ; $20*2 is our 8kn bank $40 
;     org $e000 
;     incbin "1.bmp",1078             ; skip the palette + header 
    
;     SAVENEX OPEN "test.nex", main_prog , $5ffe
;     SAVENEX CORE 3, 0, 0      
;     SAVENEX CFG 0, 0            
;     SAVENEX AUTO 
;     SAVENEX CLOSE   