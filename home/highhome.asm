; A little space between Joypad intterupt and ROM header that could
HBlankCopy2bpp::
	di
	ld [hSPBuffer], sp
	ld hl, hRequestedVTileDest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; destination

	ld a, [hli] ; source
	ld h, [hl]
	ld l, a
	ld sp, hl ; set source to sp
	ld a, h ; save source high byte for later
	ld h, d ; exchange hl and de
	ld l, e
; vram to vram copy check:
	cp VTiles0 / $100 ; is source in RAM?
	jr c, .innerLoop
	cp SRAM_Begin / $100 ; is source past VRAM
	jr nc, .innerLoop
	jp VRAMToVRAMCopy
.outerLoop
	ld a, [rLY]
	cp $88
	jp nc, ContinueHBlankCopy
.innerLoop
	pop bc
	pop de
.waitNoHBlank
	ld a, [rSTAT]
	and 3
	jr z, .waitNoHBlank
.waitHBlank
	ld a, [rSTAT]
	and 3
	jr nz, .waitHBlank
; preloads r us
	ld a, c ; 1
	ld [hli], a ; 3
	ld a, b ; 4
	ld [hli], a ; 6
	ld a, e ; 7
	ld [hli], a ; 9
	ld a, d ; 10
	ld [hli], a ; 12
	rept 5
	pop de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	endr ; 47 (12 + 7 * 5)
	pop de ; 50
	ld a, e ; 51
	ld [hli], a ; 53
	ld [hl], d ; 55
	inc hl
	ld a, [hTilesPerCycle]
	dec a
	ld [hTilesPerCycle], a
	jr nz, .outerLoop
	jp DoneHBlankCopy
