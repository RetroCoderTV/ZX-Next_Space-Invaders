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