; Functions used in displaying and handling menus.

Script_loadmenudata:
	call GetScriptHalfwordOrVar
	ld h, d
	ld l, e
	ld a, [ScriptBank]
	call StackCallInBankA

.Function
	call LoadMenuDataHeader
	jp UpdateSprites

CopyMenuDataHeader::
	ld de, wMenuDataHeader
	ld bc, wMenuDataHeaderEnd - wMenuDataHeader
	rst CopyBytes
	ld a, [hROMBank]
	ld [wMenuDataBank], a
	ret

MenuTextBox::
	push hl
	call LoadMenuTextBox
	pop hl
	jp PrintText

MenuTextBoxBackup::
	call MenuTextBox
	jp CloseWindow

LoadMenuTextBox::
	ld hl, MenuTextBoxDataHeader
	jr LoadMenuDataHeader

LoadStandardMenuDataHeader::
	ld hl, StandardMenuDataHeader
; fallthrough

LoadMenuDataHeader::
	call CopyMenuDataHeader
	jp PushWindow

StandardMenuDataHeader:
	db $40 ; tile backup
	db 0, 0 ; start coords
	db 17, 19 ; end coords
	dw 0
	db 1 ; default option

MenuTextBoxDataHeader:
	db $40 ; tile backup
	db 12, 0 ; start coords
	db 17, 19 ; end coords
	dw VTiles0
	db 0 ; default option

VerticalMenu::
	xor a
	ld [hBGMapMode], a
	call MenuBox
	call UpdateSprites
	call PlaceVerticalMenuItems
	call ApplyTilemap
	call CopyMenuData2
	ld a, [wMenuData2Flags]
	bit 7, a
	jr z, .cancel
	call InitVerticalMenuCursor
	call DoMenuJoypadLoop
	call MenuClickSound
	bit 1, a
	jr z, .okay
.cancel
	scf
	ret
.okay
	and a
	ret

GetMenu2::
	call LoadMenuDataHeader
	call VerticalMenu
	call CloseWindow
	ld a, [wMenuCursorY]
	ret

CopyNameFromMenu::
	push hl
	push bc
	push af
	ld hl, wMenuData2Pointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	pop af
	call GetNthString
	ld d, h
	ld e, l
	call CopyName1
	pop bc
	pop hl
	ret

PlaceGenericTwoOptionBox::
	call LoadMenuDataHeader
	jr InterpretTwoOptionMenu

YesNoBox::
	lb bc, SCREEN_WIDTH - 6, 7
	; fallthrough

PlaceYesNoBox::
; Return nc (yes) or c (no).
	push bc
	ld hl, YesNoMenuDataHeader
	call CopyMenuDataHeader
	pop bc
; This seems to be an overflow prevention, but
; it was coded wrong.
	ld a, b
	cp SCREEN_WIDTH - 6
	jr nz, .okay ; should this be "jr nc"?
	ld a, SCREEN_WIDTH - 6
	ld b, a

.okay
	ld a, b
	ld [wMenuBorderLeftCoord], a
	add 5
	ld [wMenuBorderRightCoord], a
	ld a, c
	ld [wMenuBorderTopCoord], a
	add 4
	ld [wMenuBorderBottomCoord], a
	call PushWindow

InterpretTwoOptionMenu::
	call VerticalMenu
	push af
	ld c, $f
	call DelayFrames
	call CloseWindow
	pop af
	jr c, .no
	ld a, [wMenuCursorY]
	cp 2 ; no
	jr z, .no
	and a
	ret

.no
	ld a, 2
	ld [wMenuCursorY], a
	scf
	ret

YesNoMenuDataHeader::
	db $40 ; tile backup
	db 5, 10 ; start coords
	db 9, 15 ; end coords
	dw .MenuData2
	db 1 ; default option

.MenuData2
	db $c0 ; flags
	db 2
	db "Yes@"
	db "No@"

OffsetMenuDataHeader::
	call _OffsetMenuDataHeader
	jp PushWindow

_OffsetMenuDataHeader::
	push de
	call CopyMenuDataHeader
	pop de
	ld a, [wMenuBorderLeftCoord]
	ld h, a
	ld a, [wMenuBorderRightCoord]
	sub h
	ld h, a
	ld a, d
	ld [wMenuBorderLeftCoord], a
	add h
	ld [wMenuBorderRightCoord], a
	ld a, [wMenuBorderTopCoord]
	ld l, a
	ld a, [wMenuBorderBottomCoord]
	sub l
	ld l, a
	ld a, e
	ld [wMenuBorderTopCoord], a
	add l
	ld [wMenuBorderBottomCoord], a
	ret

DoNthMenu::
	call MenuFunc_1e7f
	call MenuWriteText
	call Function1eff
	call Function1f23
	call GetMenuJoypad
	jp MenuClickSound

SetUpMenu::
	call MenuFunc_1e7f ; ???
	call MenuWriteText
	call Function1eff ; set up selection pointer
	ld hl, w2DMenuFlags1
	set 7, [hl]
	ret

MenuFunc_1e7f::
	call CopyMenuData2
	call GetMenuIndexSet
	call Function1ea6
	jp MenuBox

MenuWriteText::
	xor a
	ld [hBGMapMode], a
	call GetMenuIndexSet ; sort out the text
	call Function1eda ; actually write it
	call Function2e31
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call ApplyTilemap
	pop af
	ld [hOAMUpdate], a
	ret

Function1ea6::
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	ld c, a
	ld a, [wMenuData2Items]
	add a
	inc a
	ld b, a
	ld a, [wMenuBorderTopCoord]
	add b
	ld [wMenuBorderBottomCoord], a
	ret

GetMenuIndexSet::
	ld hl, wMenuData2IndicesPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wWhichIndexSet]
	and a
	jr z, .skip
	ld b, a
	ld c, -1
.loop
	ld a, [hli]
	cp c
	jr nz, .loop
	dec b
	jr nz, .loop

.skip
	ld d, h
	ld e, l
	ld a, [hl]
	ld [wMenuData2Items], a
	ret

Function1eda::
	call MenuBoxCoord2Tile
	ld bc, 2 * SCREEN_WIDTH + 2
	add hl, bc
.loop
	inc de
	ld a, [de]
	cp -1
	ret z
	ld [wMenuSelection], a
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, wMenuData2DisplayFunctionPointer
	call CallLocalPointer
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	jr .loop

Function1eff::
	call InitVerticalMenuCursor
	ld hl, wMenuJoypadFilter
	ld a, [wMenuData2Flags]
	bit 3, a
	jr z, .disallow_select
	set START_F, [hl]

.disallow_select
	ld a, [wMenuData2Flags]
	bit 2, a
	ret z
	set D_LEFT_F, [hl]
	set D_RIGHT_F, [hl]
	ret

ReadMenuJoypad::
	call DoMenuJoypadLoop
	ld hl, wMenuJoypadFilter
	and [hl]
	jr FilterMenuJoypad

Function1f23::
	xor a
	ld [wMenuJoypad], a
	call DoMenuJoypadLoop
	; fallthrough

FilterMenuJoypad::
	bit A_BUTTON_F, a
	jr nz, .a_button
	bit B_BUTTON_F, a
	jr nz, .b_start
	bit START_F, a
	jr nz, .b_start
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit D_LEFT_F, a
	jr nz, .d_left
	xor a
	ld [wMenuJoypad], a
	jr .done

.d_right
	ld a, D_RIGHT
	ld [wMenuJoypad], a
	jr .done

.d_left
	ld a, D_LEFT
	ld [wMenuJoypad], a
	jr .done

.a_button
	ld a, A_BUTTON
	ld [wMenuJoypad], a

.done
	call GetMenuIndexSet
	ld a, [wMenuCursorY]
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	ld [wMenuSelection], a
	ld a, [wMenuCursorY]
	ld [wMenuCursorBuffer], a
	and a
	ret

.b_start
	ld a, B_BUTTON
	ld [wMenuJoypad], a
	ld a, -1
	ld [wMenuSelection], a
	scf
	ret

PlaceMenuStrings::
	push de
	ld hl, wMenuData2PointerTableAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMenuSelection]
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	jp PlaceString

PlaceNthMenuStrings::
	push de
	ld a, [wMenuSelection]
	call GetMenuDataPointerTableEntry
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	jp PlaceString

MenuJumptable::
	ld a, [wMenuSelection]
	call GetMenuDataPointerTableEntry
	jp CallLocalPointer

GetMenuDataPointerTableEntry::
	ld e, a
	ld d, $0
	ld hl, wMenuData2PointerTableAddr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret

ClearWindowData::
	ld hl, wWindowStackPointer
	call .bytefill
	ld hl, wMenuDataHeader
	call .bytefill
	ld hl, wMenuData2Flags
	call .bytefill
	ld hl, w2DMenuCursorInitY
	call .bytefill

	ld a, [rSVBK]
	push af
	ld a, $7
	ld [rSVBK], a

	xor a
	ld hl, wWindowStackBottom
	ld [hld], a
	ld [hld], a
	ld a, l
	ld [wWindowStackPointer], a
	ld a, h
	ld [wWindowStackPointer + 1], a

	pop af
	ld [rSVBK], a
	ret

.bytefill
	ld bc, $0010
	xor a
	jp ByteFill

MenuClickSound::
	push af
	and A_BUTTON | B_BUTTON
	jr z, .nosound
	ld hl, wMenuFlags
	bit 3, [hl]
	jr nz, .nosound
	call PlayClickSFX
.nosound
	pop af
	ret

PlayClickSFX::
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret

MenuTextBoxWaitButton::
	call MenuTextBox
	call WaitButton
	jp ExitMenu

_2DMenu::
	ld a, [hROMBank]
	ld [wMenuData2_2DMenuItemStringsBank], a
	callba _2DMenu_
	ld a, [wMenuCursorBuffer]
	ret
