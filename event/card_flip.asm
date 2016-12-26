CARDFLIP_LIGHT_OFF EQU $ef
CARDFLIP_LIGHT_ON  EQU $f5
CARDFLIP_DECK_SIZE EQU 4 * 6

_CardFlip:
	ld hl, wOptions
	set 4, [hl]
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call DisableLCD
	call LoadStandardFont
	call LoadFontsExtra

	ld hl, CardFlipLZ01
	ld de, VTiles2 tile $00
	call Decompress
	ld hl, CardFlipLZ02
	ld de, VTiles2 tile $3e
	call Decompress
	ld hl, CardFlipLZ03
	ld de, VTiles0 tile $00
	call Decompress
	ld hl, CardFlipOffButtonGFX
	ld de, VTiles1 tile $6f
	ld bc, 1 tiles
	rst CopyBytes
	ld hl, CardFlipOnButtonGFX
	ld de, VTiles1 tile $75
	ld bc, 1 tiles
	rst CopyBytes

	call CardFlip_ShiftDigitsLeftTwoPixels
	call CardFlip_InitTilemap
	call CardFlip_InitAttrPals
	call EnableLCD
	call ApplyAttrAndTilemapInVBlank
	ld a, $e4
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	call DelayFrame
	xor a
	ld [wJumptableIndex], a
	ld a, $2
	ld [wCardFlipCursorY], a
	ld [wCardFlipCursorX], a
	ld de, MUSIC_GAME_CORNER
	call PlayMusic
	jr .handleLoop
.cardFlipLoop
	jumptable .Jumptable
.handleLoop
	ld a, [wJumptableIndex]
	bit 7, a
	jr z, .cardFlipLoop
	call WaitSFX
	ld de, SFX_QUIT_SLOTS
	call PlayWaitSFX
	call ClearBGPalettes
	ld hl, wOptions
	res 4, [hl]
	ret

.Jumptable
	dw .AskPlayWithThree
	dw .DeductCoins
	dw .ChooseACard
	dw .PlaceYourBet
	dw .CheckTheCard
	dw .TabulateTheResult
	dw .PlayAgain
	dw .Quit

.Increment
	ld hl, wJumptableIndex
	inc [hl]
	ret

.AskPlayWithThree
	ld hl, .PlayWithThreeCoinsText
	call CardFlip_UpdateCoinBalanceDisplay
	call YesNoBox
	jr c, .SaidNo
	call CardFlip_ShuffleDeck
	jp .Increment

.SaidNo
	ld a, 7
	ld [wJumptableIndex], a
	ret

.PlayWithThreeCoinsText
	; Play with three coins?
	text_jump UnknownText_0x1c5793

.DeductCoins
	ld a, [Coins]
	ld h, a
	ld a, [Coins + 1]
	ld l, a
	ld a, h
	and a
	jr nz, .deduct ; You have at least 256 coins.
	ld a, l
	cp 3
	jr nc, .deduct ; You have at least 3 coins.
	ld hl, .NotEnoughCoinsText
	call CardFlip_UpdateCoinBalanceDisplay
	ld a, 7
	ld [wJumptableIndex], a
	ret

.deduct
	ld de, -3
	add hl, de
	ld a, h
	ld [Coins], a
	ld a, l
	ld [Coins + 1], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	xor a
	ld [hBGMapMode], a
	call CardFlip_PrintCoinBalance
	ld a, $1
	ld [hBGMapMode], a
	call WaitSFX
	jp .Increment

.NotEnoughCoinsText
	; Not enough coins…
	text_jump UnknownText_0x1c57ab

.ChooseACard
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 12, 9
	call CardFlip_FillGreenBox
	hlcoord 9, 0
	ld bc, SCREEN_WIDTH
	ld a, [wCardFlipNumCardsPlayed]
	rst AddNTimes
	ld [hl], CARDFLIP_LIGHT_ON
	ld a, $1
	ld [hBGMapMode], a
	ld c, 20
	call DelayFrames
	hlcoord 2, 0
	call PlaceCardFaceDown
	ld a, $1
	ld [hBGMapMode], a
	ld c, 20
	call DelayFrames
	hlcoord 2, 6
	call PlaceCardFaceDown
	call ApplyTilemapInVBlank
	ld hl, .ChooseACardText
	call CardFlip_UpdateCoinBalanceDisplay
	xor a
	ld [wCardFlipWhichCard], a
.loop
	call JoyTextDelay
	ld a, [hJoyLast]
	and A_BUTTON
	jr nz, .next
	ld de, SFX_KINESIS
	call PlaySFX
	call PlaceOAMCardBorder
	ld c, 3
	call DelayFrames
	ld hl, wCardFlipWhichCard
	ld a, [hl]
	xor $1
	ld [hl], a
	jr .loop

.next
	ld de, SFX_SLOT_MACHINE_START
	call PlaySFX
	ld a, $3
.loop2
	push af
	call PlaceOAMCardBorder
	ld c, 3
	call DelayFrames
	call ClearSprites
	ld c, 3
	call DelayFrames
	pop af
	dec a
	jr nz, .loop2
	ld hl, wCardFlipWhichCard
	ld a, [hl]
	push af
	xor $1
	ld [hl], a
	call GetCoordsOfChosenCard
	lb bc, 6, 5
	call CardFlip_FillGreenBox
	pop af
	ld [wCardFlipWhichCard], a
	jp .Increment

.ChooseACardText
	; Choose a card.
	text_jump UnknownText_0x1c57be

.PlaceYourBet
	ld hl, .PlaceYourBetText
	call CardFlip_UpdateCoinBalanceDisplay
.betloop
	call JoyTextDelay
	ld a, [hJoyLast]
	and A_BUTTON
	jp nz, .Increment
	call ChooseCard_HandleJoypad
	call CardFlip_UpdateCursorOAM
	call DelayFrame
	jr .betloop

.PlaceYourBetText
	; Place your bet.
	text_jump UnknownText_0x1c57ce

.CheckTheCard
	xor a
	ld [hVBlankCounter], a
	call CardFlip_UpdateCursorOAM
	call WaitSFX
	ld de, SFX_CHOOSE_A_CARD
	call PlayWaitSFX
	ld a, [wCardFlipNumCardsPlayed]
	ld e, a
	ld d, 0
	ld hl, wDeck
	add hl, de
	add hl, de
	ld a, [wCardFlipWhichCard]
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wCardFlipFaceUpCard], a
	ld e, a
	ld hl, wDiscardPile
	add hl, de
	ld [hl], TRUE
	call GetCoordsOfChosenCard
	call CardFlip_DisplayCardFaceUp
	call ApplyAttrAndTilemapInVBlank
	jp .Increment

.TabulateTheResult
	call CardFlip_CheckWinCondition
	call WaitPressAorB_BlinkCursor
	jp .Increment

.PlayAgain
	call ClearSprites
	ld hl, .PlayAgainText
	call CardFlip_UpdateCoinBalanceDisplay
	call YesNoBox
	jr nc, .Continue
	jp .Increment

.Continue
	ld a, [wCardFlipNumCardsPlayed]
	inc a
	ld [wCardFlipNumCardsPlayed], a
	cp 12
	jr c, .KeepTheCurrentDeck
	call CardFlip_InitTilemap
	ld a, $1
	ld [hBGMapMode], a
	call CardFlip_ShuffleDeck
	ld hl, .CardsShuffledText
	call PrintText
	jr .LoopAround

.KeepTheCurrentDeck
	call CardFlip_BlankDiscardedCardSlot

.LoopAround
	ld a, 1
	ld [wJumptableIndex], a
	ret

.PlayAgainText
	; Want to play again?
	text_jump UnknownText_0x1c57df

.CardsShuffledText
	; The cards have been shuffled.
	text_jump UnknownText_0x1c57f4

.Quit
	ld hl, wJumptableIndex
	set 7, [hl]
	ret

CardFlip_ShuffleDeck:
	ld hl, wDeck
	ld bc, CARDFLIP_DECK_SIZE
	xor a
	call ByteFill
	ld de, wDeck
	ld c, CARDFLIP_DECK_SIZE - 1
.loop
	call Random
	and $1f
	cp CARDFLIP_DECK_SIZE
	jr nc, .loop
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	and a
	jr nz, .loop
	ld [hl], c
	dec c
	jr nz, .loop
	xor a
	ld [wCardFlipNumCardsPlayed], a
	ld hl, wDiscardPile
	ld bc, CARDFLIP_DECK_SIZE
	jp ByteFill

CollapseCursorPosition:
	ld hl, 0
	ld bc, 6
	ld a, [wCardFlipCursorY]
	rst AddNTimes
	ld b, $0
	ld a, [wCardFlipCursorX]
	ld c, a
	add hl, bc
	ret

GetCoordsOfChosenCard:
	ld a, [wCardFlipWhichCard]
	and a
	jr nz, .BottomCard
	hlcoord 2, 0
	bcpixel 2, 3
	ret

.BottomCard
	hlcoord 2, 6
	bcpixel 8, 3
	ret

PlaceCardFaceDown:
	xor a
	ld [hBGMapMode], a
	ld de, .FaceDownCardTilemap
	lb bc, 6, 5
	jp CardFlip_CopyToBox

.FaceDownCardTilemap
	db $08, $09, $09, $09, $0a
	db $0b, $28, $2b, $28, $0c
	db $0b, $2c, $2d, $2e, $0c
	db $0b, $2f, $30, $31, $0c
	db $0b, $32, $33, $34, $0c
	db $0d, $0e, $0e, $0e, $0f

CardFlip_DisplayCardFaceUp:
	xor a
	ld [hBGMapMode], a
	push hl
	push hl
	; Flip the card face up.
	ld de, .FaceUpCardTilemap
	lb bc, 6, 5
	call CardFlip_CopyToBox

	; Get the level and species of the upturned card.
	ld a, [wCardFlipFaceUpCard]
	ld e, a
	ld d, 0
	ld hl, .Deck
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]

	; Place the level.
	pop hl
	ld bc, 3 + SCREEN_WIDTH
	add hl, bc
	ld [hl], e

	; Place the Pokepic.
	ld bc, SCREEN_HEIGHT
	add hl, bc
	ld a, d
	ld de, SCREEN_WIDTH
	ld b, 3
.row
	push hl
	ld c, 3
.col
	ld [hli], a
	inc a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	dec b
	jr nz, .row
	pop hl

	; Set the attributes
	ld de, AttrMap - TileMap
	add hl, de
	ld a, [wCardFlipFaceUpCard]
	and 3
	inc a
	lb bc, 6, 5
	jp CardFlip_FillBox

.FaceUpCardTilemap
	db $18, $19, $19, $19, $1a
	db $1b, $35, $7f, $7f, $1c
	db $0b, $28, $28, $28, $0c
	db $0b, $28, $28, $28, $0c
	db $0b, $28, $28, $28, $0c
	db $1d, $1e, $1e, $1e, $1f

.Deck
	; level, pic anchor (3x3)
	db "1",$4e, "1",$57, "1",$69, "1",$60
	db "2",$4e, "2",$57, "2",$69, "2",$60
	db "3",$4e, "3",$57, "3",$69, "3",$60
	db "4",$4e, "4",$57, "4",$69, "4",$60
	db "5",$4e, "5",$57, "5",$69, "5",$60
	db "6",$4e, "6",$57, "6",$69, "6",$60

CardFlip_UpdateCoinBalanceDisplay:
	push hl
	hlcoord 0, 12
	ld b, 4
	ld c, SCREEN_WIDTH - 2
	call TextBox
	pop hl
	call PrintTextBoxText
	; fallthrough

CardFlip_PrintCoinBalance:
	hlcoord 9, 15
	lb bc, 1, 9
	call TextBox
	hlcoord 10, 16
	ld de, .CoinStr
	call PlaceString
	hlcoord 15, 16
	ld de, Coins
	lb bc, PRINTNUM_LEADINGZEROS | 2, 4
	jp PrintNum

.CoinStr
	db "Coin@"

CardFlip_InitTilemap:
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $29
	call ByteFill
	hlcoord 9, 0
	ld de, CardFlipTilemap
	lb bc, 12, 11
	call CardFlip_CopyToBox
	hlcoord 0, 12
	lb bc, 4, 18
	jp TextBox

CardFlip_FillGreenBox:
	ld a, $29
	; fallthrough

CardFlip_FillBox:
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

CardFlip_CopyToBox:
.row
	push bc
	push hl
.col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

CardFlip_CopyOAM:
	ld de, Sprites
	ld a, [hli]
.loop
	push af
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

CardFlip_ShiftDigitsLeftTwoPixels:
	ld de, VTiles1 tile ("0" & $7f)
	ld hl, VTiles1 tile ("0" & $7f) + 2
	ld bc, 10 tiles - 2
	rst CopyBytes
	ld hl, VTiles1 tile $7f + 1 tiles - 2
	xor a
	ld [hli], a
	ld [hl], a
	ret

CardFlip_BlankDiscardedCardSlot:
	xor a
	ld [hBGMapMode], a
	ld a, [wCardFlipFaceUpCard]
	ld e, a
	ld d, 0

	and 3 ; get mon
	ld c, a
	ld b, 0

	ld a, e
	and $1c ; get level
	srl a
	add .Jumptable % $100
	ld l, a
	ld a, 0
	adc .Jumptable / $100
	ld h, a
	jp CallLocalPointer

.Jumptable

	dw .Level1
	dw .Level2
	dw .Level3
	dw .Level4
	dw .Level5
	dw .Level6

.Level1
	ld hl, wDiscardPile + 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded2
	hlcoord 13, 3
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $37
	ret

.discarded2
	hlcoord 13, 3
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3d
	ret

.Level2
	ld hl, wDiscardPile - 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded1
	hlcoord 13, 4
	add hl, bc
	add hl, bc
	ld [hl], $3b
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

.discarded1
	hlcoord 13, 4
	add hl, bc
	add hl, bc
	ld [hl], $3d
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

.Level3
	ld hl, wDiscardPile + 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded4
	hlcoord 13, 6
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $38
	ret

.discarded4
	hlcoord 13, 6
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3d
	ret

.Level4
	ld hl, wDiscardPile - 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded3
	hlcoord 13, 7
	add hl, bc
	add hl, bc
	ld [hl], $3c
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

.discarded3
	hlcoord 13, 7
	add hl, bc
	add hl, bc
	ld [hl], $3d
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

.Level5
	ld hl, wDiscardPile + 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded6
	hlcoord 13, 9
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $39
	ret

.discarded6
	hlcoord 13, 9
	add hl, bc
	add hl, bc
	ld [hl], $36
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3d
	ret

.Level6
	ld hl, wDiscardPile - 4
	add hl, de
	ld a, [hl]
	and a
	jr nz, .discarded5
	hlcoord 13, 10
	add hl, bc
	add hl, bc
	ld [hl], $3c
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

.discarded5
	hlcoord 13, 10
	add hl, bc
	add hl, bc
	ld [hl], $3d
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld [hl], $3a
	ret

CardFlip_CheckWinCondition:
	ld hl, wCardFlipCursorY
	ld a, [hli]
	sub 2
	ld e, a
	ld c, 72
	jr nc, .in_grid_vertically
	ld c, 12
.in_grid_vertically
	ld a, [hl]
	sub 2
	ld d, a
	jr nc, .in_grid_horizontally
	srl c
	srl c
.in_grid_horizontally
	
	ld h, 0
	ld a, [wCardFlipFaceUpCard]
	rra
	rr h
	rra
	rl h
	rl h
	ld l, a
	
	bit 7, d
	jr z, .horizontal_checked
	ld h, 0
	inc d
	jr z, .horizontal_checked
	inc d
	res 0, l
	res 0, e
	srl c
.horizontal_checked
	
	bit 7, e
	jr z, .vertical_checked
	ld l, 0
	inc e
	jr z, .vertical_checked
	inc e
	res 0, h
	res 0, d
	srl c
.vertical_checked
	
	ld a, d
	cp h
	jr nz, .Lose
	ld a, e
	cp l
	jr nz, .Lose

.Payout
	push bc
	ld hl, .Text_Yeah
	call CardFlip_UpdateCoinBalanceDisplay
	ld de, SFX_2ND_PLACE
	call PlayWaitSFX
	pop bc
.loop
	push bc
	call .IsCoinCaseFull
	jr c, .full
	call .AddCoinPlaySFX
.full
	call CardFlip_PrintCoinBalance
	call Delay2
	pop bc
	dec c
	jr nz, .loop
	ret

.Lose
	ld de, SFX_WRONG
	call PlaySFX
	ld hl, .Text_Darn
	call CardFlip_UpdateCoinBalanceDisplay
	jp WaitSFX

.Text_Yeah
	; Yeah!
	text_jump UnknownText_0x1c5813

.Text_Darn
	; Darn…
	text_jump UnknownText_0x1c581a

.AddCoinPlaySFX
	ld a, [Coins]
	ld h, a
	ld a, [Coins + 1]
	ld l, a
	inc hl
	ld a, h
	ld [Coins], a
	ld a, l
	ld [Coins + 1], a
	ld de, SFX_PAY_DAY
	jp PlaySFX

.IsCoinCaseFull
	ld a, [Coins]
	cp 9999 / $100
	jr nz, .checked
.check_low
	ld a, [Coins + 1]
	cp 9999 % $100
.checked
	ccf
	ret

PlaceOAMCardBorder:
	call GetCoordsOfChosenCard
	ld hl, .SpriteData
	jp CardFlip_CopyOAM

.SpriteData
	db 18
	dsprite 0, 0, 0, 0, $04, $00
	dsprite 0, 0, 1, 0, $06, $00
	dsprite 0, 0, 2, 0, $06, $00
	dsprite 0, 0, 3, 0, $06, $00
	dsprite 0, 0, 4, 0, $04, $20

	dsprite 1, 0, 0, 0, $05, $00
	dsprite 1, 0, 4, 0, $05, $20

	dsprite 2, 0, 0, 0, $05, $00
	dsprite 2, 0, 4, 0, $05, $20

	dsprite 3, 0, 0, 0, $05, $00
	dsprite 3, 0, 4, 0, $05, $20

	dsprite 4, 0, 0, 0, $05, $00
	dsprite 4, 0, 4, 0, $05, $20

	dsprite 5, 0, 0, 0, $04, $40
	dsprite 5, 0, 1, 0, $06, $40
	dsprite 5, 0, 2, 0, $06, $40
	dsprite 5, 0, 3, 0, $06, $40
	dsprite 5, 0, 4, 0, $04, $60

ChooseCard_HandleJoypad:
	ld hl, hJoyLast
	bit D_LEFT_F, [hl]
	jr nz, .d_left
	bit D_RIGHT_F, [hl]
	jr nz, .d_right
	bit D_UP_F, [hl]
	jr nz, .d_up
	bit D_DOWN_F, [hl]
	jp nz, .d_down
	ret

.d_left
	ld hl, wCardFlipCursorX
	ld a, [wCardFlipCursorY]
	and a
	jr z, .mon_pair_left
	cp $1
	jr z, .mon_group_left
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jp .play_sound

.mon_group_left
	ld a, [hl]
	cp $3
	jr c, .left_to_number_gp
	dec [hl]
	jp .play_sound

.mon_pair_left
	ld a, [hl]
	and $e
	ld [hl], a
	cp $3
	jr c, .left_to_number_gp
	dec [hl]
	dec [hl]
	jr .play_sound

.left_to_number_gp
	ld a, $2
	ld [wCardFlipCursorY], a
	dec a
	ld [wCardFlipCursorX], a
	jr .play_sound

.d_right
	ld hl, wCardFlipCursorX
	ld a, [wCardFlipCursorY]
	and a
	jr z, .mon_pair_right
	ld a, [hl]
	cp $5
	ret nc
	inc [hl]
	jr .play_sound

.mon_pair_right
	ld a, [hl]
	and $e
	ld [hl], a
	cp $4
	ret nc
	inc [hl]
	inc [hl]
	jr .play_sound

.d_up
	ld hl, wCardFlipCursorY
	ld a, [wCardFlipCursorX]
	and a
	jr z, .num_pair_up
	cp $1
	jr z, .num_gp_up
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jr .play_sound

.num_gp_up
	ld a, [hl]
	cp $3
	jr c, .up_to_mon_group
	dec [hl]
	jr .play_sound

.num_pair_up
	ld a, [hl]
	and $e
	ld [hl], a
	cp $3
	jr c, .up_to_mon_group
	dec [hl]
	dec [hl]
	jr .play_sound

.up_to_mon_group
	ld a, $1
	ld [wCardFlipCursorY], a
	ld a, $2
	ld [wCardFlipCursorX], a
	jr .play_sound

.d_down
	ld hl, wCardFlipCursorY
	ld a, [wCardFlipCursorX]
	and a
	jr z, .num_pair_down
	ld hl, wCardFlipCursorY
	ld a, [hl]
	cp $7
	ret nc
	inc [hl]
	jr .play_sound

.num_pair_down
	ld a, [hl]
	and $e
	ld [hl], a
	cp $6
	ret nc
	inc [hl]
	inc [hl]

.play_sound
	ld de, SFX_POKEBALLS_PLACED_ON_TABLE
	jp PlaySFX

CardFlip_UpdateCursorOAM: ; e0960
	call ClearSprites
	call CollapseCursorPosition
	add hl, hl
	add hl, hl
	ld de, .OAMData
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp CardFlip_CopyOAM

.OAMData
cardflip_cursor: MACRO
if _NARG >= 5
	dbpixel \1, \2, \3, \4
	dw \5
else
	dbpixel \1, \2
	dw \3
endc
endm


	cardflip_cursor 11,  2,       .Impossible
	cardflip_cursor 12,  2,       .Impossible
	cardflip_cursor 13,  2,       .PokeGroupPair
	cardflip_cursor 13,  2,       .PokeGroupPair
	cardflip_cursor 17,  2,       .PokeGroupPair
	cardflip_cursor 17,  2,       .PokeGroupPair

	cardflip_cursor 11,  3,       .Impossible
	cardflip_cursor 12,  3,       .Impossible
	cardflip_cursor 13,  3,       .PokeGroup
	cardflip_cursor 15,  3,       .PokeGroup
	cardflip_cursor 17,  3,       .PokeGroup
	cardflip_cursor 19,  3,       .PokeGroup

	cardflip_cursor 11,  5,       .NumGroupPair
	cardflip_cursor 12,  5,       .NumGroup
	cardflip_cursor 13,  5,       .SingleTile
	cardflip_cursor 15,  5,       .SingleTile
	cardflip_cursor 17,  5,       .SingleTile
	cardflip_cursor 19,  5,       .SingleTile

	cardflip_cursor 11,  5,       .NumGroupPair
	cardflip_cursor 12,  6, 0, 4, .NumGroup
	cardflip_cursor 13,  6, 0, 4, .SingleTile
	cardflip_cursor 15,  6, 0, 4, .SingleTile
	cardflip_cursor 17,  6, 0, 4, .SingleTile
	cardflip_cursor 19,  6, 0, 4, .SingleTile

	cardflip_cursor 11,  8,       .NumGroupPair
	cardflip_cursor 12,  8,       .NumGroup
	cardflip_cursor 13,  8,       .SingleTile
	cardflip_cursor 15,  8,       .SingleTile
	cardflip_cursor 17,  8,       .SingleTile
	cardflip_cursor 19,  8,       .SingleTile

	cardflip_cursor 11,  8,       .NumGroupPair
	cardflip_cursor 12,  9, 0, 4, .NumGroup
	cardflip_cursor 13,  9, 0, 4, .SingleTile
	cardflip_cursor 15,  9, 0, 4, .SingleTile
	cardflip_cursor 17,  9, 0, 4, .SingleTile
	cardflip_cursor 19,  9, 0, 4, .SingleTile

	cardflip_cursor 11, 11,       .NumGroupPair
	cardflip_cursor 12, 11,       .NumGroup
	cardflip_cursor 13, 11,       .SingleTile
	cardflip_cursor 15, 11,       .SingleTile
	cardflip_cursor 17, 11,       .SingleTile
	cardflip_cursor 19, 11,       .SingleTile

	cardflip_cursor 11, 11,       .NumGroupPair
	cardflip_cursor 12, 12, 0, 4, .NumGroup
	cardflip_cursor 13, 12, 0, 4, .SingleTile
	cardflip_cursor 15, 12, 0, 4, .SingleTile
	cardflip_cursor 17, 12, 0, 4, .SingleTile
	cardflip_cursor 19, 12, 0, 4, .SingleTile

.SingleTile
	db 6
	dsprite   0, 0,  -1, 7, $00, $80
	dsprite   0, 0,   0, 0, $02, $80
	dsprite   0, 0,   1, 0, $03, $80
	dsprite   0, 5,  -1, 7, $00, $c0
	dsprite   0, 5,   0, 0, $02, $c0
	dsprite   0, 5,   1, 0, $03, $80

.PokeGroup
	db 26
	dsprite   0, 0,  -1, 7, $00, $80
	dsprite   0, 0,   0, 0, $02, $80
	dsprite   0, 0,   1, 0, $00, $a0
	dsprite   1, 0,  -1, 7, $01, $80
	dsprite   1, 0,   1, 0, $01, $a0
	dsprite   2, 0,  -1, 7, $01, $80
	dsprite   2, 0,   1, 0, $03, $80
	dsprite   3, 0,  -1, 7, $01, $80
	dsprite   3, 0,   1, 0, $03, $80
	dsprite   4, 0,  -1, 7, $01, $80
	dsprite   4, 0,   1, 0, $03, $80
	dsprite   5, 0,  -1, 7, $01, $80
	dsprite   5, 0,   1, 0, $03, $80
	dsprite   6, 0,  -1, 7, $01, $80
	dsprite   6, 0,   1, 0, $03, $80
	dsprite   7, 0,  -1, 7, $01, $80
	dsprite   7, 0,   1, 0, $03, $80
	dsprite   8, 0,  -1, 7, $01, $80
	dsprite   8, 0,   1, 0, $03, $80
	dsprite   9, 0,  -1, 7, $01, $80
	dsprite   9, 0,   1, 0, $03, $80
	dsprite  10, 0,  -1, 7, $01, $80
	dsprite  10, 0,   1, 0, $03, $80
	dsprite  10, 1,  -1, 7, $00, $c0
	dsprite  10, 1,   0, 0, $02, $c0
	dsprite  10, 1,   1, 0, $03, $80

.NumGroup
	db 20
	dsprite   0, 0,  -1, 7, $00, $80
	dsprite   0, 0,   0, 0, $02, $80
	dsprite   0, 0,   1, 0, $02, $80
	dsprite   0, 0,   2, 0, $03, $80
	dsprite   0, 0,   3, 0, $02, $80
	dsprite   0, 0,   4, 0, $03, $80
	dsprite   0, 0,   5, 0, $02, $80
	dsprite   0, 0,   6, 0, $03, $80
	dsprite   0, 0,   7, 0, $02, $80
	dsprite   0, 0,   8, 0, $03, $80
	dsprite   0, 5,  -1, 7, $00, $c0
	dsprite   0, 5,   0, 0, $02, $c0
	dsprite   0, 5,   1, 0, $02, $c0
	dsprite   0, 5,   2, 0, $03, $80
	dsprite   0, 5,   3, 0, $02, $c0
	dsprite   0, 5,   4, 0, $03, $80
	dsprite   0, 5,   5, 0, $02, $c0
	dsprite   0, 5,   6, 0, $03, $80
	dsprite   0, 5,   7, 0, $02, $c0
	dsprite   0, 5,   8, 0, $03, $80

.NumGroupPair
	db 30
	dsprite   0, 0,   0, 0, $00, $80
	dsprite   0, 0,   1, 0, $02, $80
	dsprite   0, 0,   2, 0, $02, $80
	dsprite   0, 0,   3, 0, $03, $80
	dsprite   0, 0,   4, 0, $02, $80
	dsprite   0, 0,   5, 0, $03, $80
	dsprite   0, 0,   6, 0, $02, $80
	dsprite   0, 0,   7, 0, $03, $80
	dsprite   0, 0,   8, 0, $02, $80
	dsprite   0, 0,   9, 0, $03, $80
	dsprite   1, 0,   0, 0, $01, $80
	dsprite   1, 0,   3, 0, $03, $80
	dsprite   1, 0,   5, 0, $03, $80
	dsprite   1, 0,   7, 0, $03, $80
	dsprite   1, 0,   9, 0, $03, $80
	dsprite   2, 0,   0, 0, $01, $80
	dsprite   2, 0,   3, 0, $03, $80
	dsprite   2, 0,   5, 0, $03, $80
	dsprite   2, 0,   7, 0, $03, $80
	dsprite   2, 0,   9, 0, $03, $80
	dsprite   2, 1,   0, 0, $00, $c0
	dsprite   2, 1,   1, 0, $02, $c0
	dsprite   2, 1,   2, 0, $02, $c0
	dsprite   2, 1,   3, 0, $03, $80
	dsprite   2, 1,   4, 0, $03, $80
	dsprite   2, 1,   5, 0, $03, $80
	dsprite   2, 1,   6, 0, $03, $80
	dsprite   2, 1,   7, 0, $03, $80
	dsprite   2, 1,   8, 0, $03, $80
	dsprite   2, 1,   9, 0, $03, $80

.PokeGroupPair
	db 38
	dsprite   0, 0,  -1, 7, $00, $80
	dsprite   0, 0,   3, 0, $00, $a0
	dsprite   1, 0,  -1, 7, $01, $80
	dsprite   1, 0,   3, 0, $01, $a0
	dsprite   2, 0,  -1, 7, $01, $80
	dsprite   2, 0,   3, 0, $01, $a0
	dsprite   3, 0,  -1, 7, $01, $80
	dsprite   3, 0,   1, 0, $03, $80
	dsprite   3, 0,   3, 0, $03, $80
	dsprite   4, 0,  -1, 7, $01, $80
	dsprite   4, 0,   1, 0, $03, $80
	dsprite   4, 0,   3, 0, $03, $80
	dsprite   5, 0,  -1, 7, $01, $80
	dsprite   5, 0,   1, 0, $03, $80
	dsprite   5, 0,   3, 0, $03, $80
	dsprite   6, 0,  -1, 7, $01, $80
	dsprite   6, 0,   1, 0, $03, $80
	dsprite   6, 0,   3, 0, $03, $80
	dsprite   7, 0,  -1, 7, $01, $80
	dsprite   7, 0,   1, 0, $03, $80
	dsprite   7, 0,   3, 0, $03, $80
	dsprite   8, 0,  -1, 7, $01, $80
	dsprite   8, 0,   1, 0, $03, $80
	dsprite   8, 0,   3, 0, $03, $80
	dsprite   9, 0,  -1, 7, $01, $80
	dsprite   9, 0,   1, 0, $03, $80
	dsprite   9, 0,   3, 0, $03, $80
	dsprite  10, 0,  -1, 7, $01, $80
	dsprite  10, 0,   1, 0, $03, $80
	dsprite  10, 0,   3, 0, $03, $80
	dsprite  11, 0,  -1, 7, $01, $80
	dsprite  11, 0,   1, 0, $03, $80
	dsprite  11, 0,   3, 0, $03, $80
	dsprite  11, 1,  -1, 7, $00, $c0
	dsprite  11, 1,   0, 0, $02, $c0
	dsprite  11, 1,   1, 0, $03, $c0
	dsprite  11, 1,   2, 0, $02, $c0
	dsprite  11, 1,   3, 0, $03, $e0

.Impossible
	db 4
	dsprite   0, 0,   0, 0, $00, $80
	dsprite   0, 0,   1, 0, $00, $a0
	dsprite   1, 0,   0, 0, $00, $c0
	dsprite   1, 0,   1, 0, $00, $e0

CardFlip_InitAttrPals:
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill

	hlcoord 12, 1, AttrMap
	lb bc, 2, 2
	ld a, $1
	call CardFlip_FillBox

	hlcoord 14, 1, AttrMap
	lb bc, 2, 2
	ld a, $2
	call CardFlip_FillBox

	hlcoord 16, 1, AttrMap
	lb bc, 2, 2
	ld a, $3
	call CardFlip_FillBox

	hlcoord 18, 1, AttrMap
	lb bc, 2, 2
	ld a, $4
	call CardFlip_FillBox

	hlcoord 9, 0, AttrMap
	lb bc, 12, 1
	ld a, $1
	call CardFlip_FillBox

	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, .palettes
	ld de, UnknBGPals
	ld bc, 9 palettes
	rst CopyBytes
	pop af
	ld [rSVBK], a
	ret

.palettes
	RGB 31, 31, 31
	RGB 17, 07, 31
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 29, 25, 00
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 13, 30
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 08, 17, 30
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 08, 31, 08
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 07, 31
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 07, 31
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 07, 31
	RGB 06, 19, 08
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 00, 00
	RGB 31, 00, 00

CardFlipLZ03:
INCBIN "gfx/unknown/0e0cdb.2bpp.lz"

CardFlipOffButtonGFX:
INCBIN "gfx/unknown/0e0cf6.2bpp"

CardFlipOnButtonGFX:
INCBIN "gfx/unknown/0e0d06.2bpp"

CardFlipLZ01:
INCBIN "gfx/unknown/0e0d16.2bpp.lz"

CardFlipLZ02:
INCBIN "gfx/unknown/0e0ea8.2bpp.lz"

CardFlipTilemap:
	db $ef, $15, $27, $2a, $2a, $06, $27, $2a, $2a, $06, $27
	db $ef, $07, $27, $3e, $3f, $42, $43, $46, $47, $4a, $4b
	db $ef, $17, $26, $40, $41, $44, $45, $48, $49, $4c, $4d
	db $ef, $25, $04, $00, $01, $00, $01, $00, $01, $00, $01
	db $ef, $05, $14, $10, $11, $10, $11, $10, $11, $10, $11
	db $ef, $16, $24, $20, $21, $20, $21, $20, $21, $20, $21
	db $ef, $25, $04, $00, $02, $00, $02, $00, $02, $00, $02
	db $ef, $05, $14, $10, $12, $10, $12, $10, $12, $10, $12
	db $ef, $16, $24, $20, $22, $20, $22, $20, $22, $20, $22
	db $ef, $25, $04, $00, $03, $00, $03, $00, $03, $00, $03
	db $ef, $05, $14, $10, $13, $10, $13, $10, $13, $10, $13
	db $ef, $16, $24, $20, $23, $20, $23, $20, $23, $20, $23
