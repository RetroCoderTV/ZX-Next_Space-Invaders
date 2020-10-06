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