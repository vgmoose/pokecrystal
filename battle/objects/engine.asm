QueueBattleAnimation:
	ld hl, ActiveAnimObjects
	ld e, 10
.loop
	ld a, [hl]
	and a
	jr z, .done
	ld bc, BATTLEANIMSTRUCT_LENGTH
	add hl, bc
	dec e
	jr nz, .loop
	scf
	ret

.done
	ld c, l
	ld b, h
	ld hl, wNumActiveBattleAnims
	inc [hl]
	; fallthrough

InitBattleAnimation:
	ld a, [wBattleAnimTemp0]
	ld l, a
	ld h, 0
	ld e, l
	ld d, h
	add hl, hl ; x2
	add hl, de ; x3
	add hl, hl ; x6
	ld de, BattleAnimObjects
	add hl, de
	ld e, l
	ld d, h
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld a, [wNumActiveBattleAnims]
	ld [hli], a ; Index
	ld a, [de]
	inc de
	ld [hli], a ; 01
	ld a, [de]
	inc de
	ld [hli], a ; 02
	ld a, [de]
	inc de
	ld [hli], a ; Frameset ID
	ld a, [de]
	inc de
	ld [hli], a ; Function
	ld a, [de]
	inc de
	ld [hli], a ; Palette
	ld a, [de]
	call GetBattleAnimTileOffset
	ld [hli], a ; Tile ID
	ld a, [wBattleAnimTemp1]
	ld [hli], a ; X Coord
	ld a, [wBattleAnimTemp2]
	ld [hli], a ; Y Coord
	xor a
	ld [hli], a ; X Offset
	ld [hli], a ; Y Offset
	ld a, [wBattleAnimTemp3]
	ld [hli], a ; Param
	xor a
	ld [hli], a ; 0c
	dec a
	ld [hli], a ; 0d
	xor a
	ld [hli], a ; 0e
	ld [hli], a ; 0f
	ld [hl], a  ; 10
	ret

DeinitBattleAnimation:
	ld hl, BATTLEANIMSTRUCT_INDEX
	add hl, bc
	ld [hl], $0
	ret

BattleAnimOAMUpdate:
	call InitBattleAnimBuffer
	call GetBattleAnimFrame
	cp -3
	jp z, .done
	cp -4
	jp z, .delete
	push af
	ld hl, wBattleAnimTempOAMFlags
	ld a, [wBattleAnimTemp7]
	xor [hl]
	and $e0
	ld [hl], a
	pop af
	push bc
	call GetBattleAnimOAMPointer
	ld a, [wBattleAnimTempTileID]
	add [hl]
	ld [wBattleAnimTempTileID], a
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wBattleAnimOAMPointerLo]
	ld e, a
	ld d, Sprites / $100
.loop
	ld a, [wBattleAnimTempYCoord]
	ld b, a
	ld a, [wBattleAnimTempYOffset]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, wBattleAnimTempOAMFlags
	bit 6, [hl]
	jr z, .no_yflip
	add $8
	xor $ff
	inc a

.no_yflip
	pop hl
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wBattleAnimTempXCoord]
	ld b, a
	ld a, [wBattleAnimTempXOffset]
	add b
	ld b, a
	push hl
	ld a, [hl]
	ld hl, wBattleAnimTempOAMFlags
	bit 5, [hl]
	jr z, .no_xflip
	add $8
	xor $ff
	inc a

.no_xflip
	pop hl
	add b
	ld [de], a
	inc hl
	inc de
	ld a, [wBattleAnimTempTileID]
	add $31
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [wBattleAnimTempOAMFlags]
	ld b, a
	ld a, [hl]
	xor b
	and $e0
	ld b, a
	ld a, [hl]
	and $10
	or b
	ld b, a
	ld a, [wBattleAnimTempPalette]
	and $f
	or b
	ld [de], a
	inc hl
	inc de
	ld a, e
	ld [wBattleAnimOAMPointerLo], a
	cp $a0
	jr nc, .exit_set_carry
	dec c
	jr nz, .loop
	pop bc
	jr .done

.delete
	call DeinitBattleAnimation

.done
	and a
	ret

.exit_set_carry
	pop bc
	scf
	ret

InitBattleAnimBuffer:
	ld hl, BATTLEANIMSTRUCT_FLAGS
	add hl, bc
	ld a, [hl]
	and %10000000
	ld [wBattleAnimTempOAMFlags], a
	xor a
	ld [wBattleAnimTemp7], a
	ld hl, BATTLEANIMSTRUCT_PALETTE
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTempPalette], a
	ld hl, BATTLEANIMSTRUCT_YFIX
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTemp1], a
	ld hl, BATTLEANIMSTRUCT_TILEID
	add hl, bc
	ld a, [hli]
	ld [wBattleAnimTempTileID], a
	ld a, [hli]
	ld [wBattleAnimTempXCoord], a
	ld a, [hli]
	ld [wBattleAnimTempYCoord], a
	ld a, [hli]
	ld [wBattleAnimTempXOffset], a
	ld a, [hli]
	ld [wBattleAnimTempYOffset], a
	; Is this the enemy's turn?
	ld a, [hBattleTurn]
	and a
	ret z
	; Is coord fixing enabled?
	ld hl, BATTLEANIMSTRUCT_FLAGS
	add hl, bc
	ld a, [hl]
	ld [wBattleAnimTempOAMFlags], a
	bit 0, [hl]
	ret z
	; Fix the X coord
	ld hl, BATTLEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, [hli]
	ld d, a
	ld a, (-10 * 8) + 4
	sub d
	ld [wBattleAnimTempXCoord], a
	; Fix the Y coord
	ld a, [hli]
	ld d, a
	; if this is -1, move 5 tiles down
	ld a, [wBattleAnimTemp1]
	cp $ff
	jr nz, .check_kinesis_softboiled_milkdrink
	ld a, 5 * 8
	add d
	jr .done

.check_kinesis_softboiled_milkdrink
	; negate the Y coordinate
	sub d
	; if using softboiled, subtract 1 more tile
	push af
	ld a, [FXAnimIDHi]
	or a
	jr nz, .no_sub
	ld a, [FXAnimIDLo]
	cp SOFTBOILED
	jr nz, .no_sub
	pop af
	sub 1 * 8
	jr .done

.no_sub
	pop af
.done
	ld [wBattleAnimTempYCoord], a
	ld a, [hli]
	xor $ff
	inc a
	ld [wBattleAnimTempXOffset], a
	ret

GetBattleAnimTileOffset:
	push hl
	push bc
	ld hl, wBattleAnimTileDict
	ld b, a
	ld c, 10 / 2
.loop
	ld a, [hli]
	cp b
	jr z, .load
	inc hl
	dec c
	jr nz, .loop
	xor a
	jr .done

.load
	ld a, [hl]
.done
	pop bc
	pop hl
	ret
