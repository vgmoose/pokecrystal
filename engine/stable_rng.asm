StableRandom::
	; in: hl: pointer to 8-byte RNG state
	; out: a: random value; other registers preserved
	push bc
	push de
	push hl
	call .advance_left_register
	call .advance_right_register
	inc hl
	inc hl
	inc hl
	call .advance_selector_register
	pop hl
	push hl
	rlca
	rlca
	ld c, a
	and 3
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	pop hl
	push hl
	ld e, 5
	add hl, de
	ld a, c
	ld c, [hl]
	rlca
	rlca
	and 3
	call .combine_register_values
	pop hl
	pop de
	pop bc
	ret
	
.advance_left_register
	; in: hl: pointer to left register
	; out: hl: pointer to RIGHT register
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
	or c
	or d
	or e
	call z, .reseed_left_register
	ld a, e
	xor d
	ld e, a
	ld a, d
	xor c
	ld d, a
	ld a, c
	xor b
	ld c, a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hld], a
	ld [hl], e
	sla e
	rl d
	rl c
	inc hl
	ld a, [hl]
	xor e
	ld [hli], a
	ld a, [hl]
	xor d
	ld [hli], a
	ld a, [hl]
	xor c
	ld [hld], a
	ld b, a
	ld c, [hl]
	sla c
	rl b
	sbc a
	and 1
	dec hl
	xor [hl]
	ld [hld], a
	ld a, [hl]
	xor b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	ret

.reseed_left_register
	; in: hl: pointer to left register + 2
	; out: hl preserved; bcde new seed
	ld de, 5
	push hl
	add hl, de
	call .advance_selector_register
	ld b, a
	call .advance_selector_register
	ld c, a
	call .advance_selector_register
	ld d, a
	call .advance_selector_register
	ld e, a
	pop hl
	ret

.advance_right_register
	; in: hl: pointer to right register
	; out: hl preserved
	ld a, [hli]
	cp 210
	jr c, .right_carry_OK
	sub 210
.right_carry_OK
	ld d, a
	ld a, [hli]
	ld e, a
	ld c, [hl]
	or c
	or d
	jr z, .right_register_needs_reseed
	ld a, c
	and e
	inc a
	jr nz, .right_register_OK
	ld a, d
	cp 209
	jr nz, .right_register_OK
.right_register_needs_reseed
	call .reseed_right_register
.right_register_OK
	ld a, e
	ld [hld], a
	push hl
	ld b, 0
	ld h, b
	ld l, d
	ld a, 210
	rst AddNTimes
	ld a, l
	ld b, h
	pop hl
	ld [hld], a
	ld [hl], b
	ret

.reseed_right_register
	; in: hl: pointer to right register + 2
	; out: hl preserved, cde new seed
	inc hl
	call .advance_selector_register
	ld c, a
	call .advance_selector_register
	ld d, a
	call .advance_selector_register
	ld e, a
	dec hl
	ret

.advance_selector_register
	; in: hl: pointer to selector register
	; out: all registers but a preserved; a = new selector
	push bc
	ld a, [hl]
	ld b, 0
	rra
	rr b
	rra
	rr b
	ld a, [hl]
	swap a
	rrca
	and $f8
	add a, b
	add a, [hl]
	add a, 29
	ld [hl], a
	pop bc
	ret

.combine_register_values
	and a
	jr z, .add_registers
	dec a
	jr z, .xor_registers
	dec a
	jr z, .subtract_registers
	ld a, c
	ld c, b
	ld b, a
.subtract_registers
	ld a, b
	sub c
	ret
.add_registers
	ld a, b
	add a, c
	ret
.xor_registers
	ld a, b
	xor c
	ret
