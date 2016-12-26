PhloxBingo_MapScriptHeader ;trigger count
	db 0
 ;callback count
	db 0

PhloxBingoGranny:
	copybytetovar wBingoCurrentCard
	iffalse .firstcard
	callasm GetNextPendingBingoLine
	sif true
		jumptextfaceplayer PhloxBingoGranny_Text_PrizeWaiting
	callasm GetBingoCardStatus
	anonjumptable
	dw .notdone
	dw .nextcard
	dw .gameover
.notdone
	jumptextfaceplayer PhloxBingoGranny_Text_Instructions
.gameover
	faceplayer
	checkevent EVENT_PHLOX_BINGO_GOT_CARD
	sif true
		scall .completedcard
	jumptext PhloxBingoGranny_Text_NoMoreCards
.nextcard
	faceplayer
	checkevent EVENT_PHLOX_BINGO_GOT_CARD
	sif true
		scall .completedcard
	opentext
	writetext PhloxBingoGranny_Text_WantAnotherCard
	yesorno
	iftrue .givecard
.wontplay
	writetext PhloxBingoGranny_Text_WontPlay
	endtext
.firstcard
	faceplayer
	opentext
	writetext PhloxBingoGranny_Text_NoCard
	yesorno
	iffalse .wontplay
.givecard
	writetext PhloxBingoGranny_Text_GiveCard
	setevent EVENT_PHLOX_BINGO_GOT_CARD
	playsound SFX_DEX_FANFARE_50_79
	appear 4
	scriptstartasm
	ld hl, wBingoCurrentCard
	inc [hl]
	inc hl
	ld bc, 5 ; 2 for wBingoAwardedPrizes and 3 for wBingoMarkedCells
	xor a
	call ByteFill
	scriptstopasm
	waitsfx
	writetext PhloxBingoGranny_Text_Instructions
	endtext
.completedcard
	showemote EMOTE_SHOCK, 2, 40
	opentext
	writetext PhloxBingoGranny_Text_CompletedCard
	closetext
	clearevent EVENT_PHLOX_BINGO_GOT_CARD
	disappear 4
	pause 15
	end

PhloxBingoAttendant:
	checkevent EVENT_PHLOX_BINGO_GOT_CARD
	sif false
		jumptextfaceplayer PhloxBingoAttendant_Text_NoCard
	callasm GetNextPendingBingoLine
	copyvartobyte wTemporaryScriptVariable
	copybytetovar wBingoCurrentCard
	addvar -1
	anonjumptable
	dw .first_card
	dw .second_card
	dw .third_card

.first_card
	copybytetovar wTemporaryScriptVariable
	anonjumptable
	dw .noprize
	dw .get_item ;1st line
	dw .get_TM ;2nd line
	dw .get_gold_token ;3rd line
	dw .get_item ;4th line
	dw .get_item ;5th line
	dw .get_TM ;1st column
	dw .get_item ;2nd column
	dw .get_item ;3rd column
	dw .get_item ;4th column
	dw .get_item ;5th column
	dw .get_item ;down diagonal
	dw .get_item ;up diagonal
	dw .get_item ;full card

.prizes_1
	db AMULET_COIN ;1st line
	db 40 ;2nd line
	db 0 ;3rd line
	db RARE_CANDY ;4th line
	db MAX_ELIXIR ;5th line
	db 18 ;1st column
	db PP_UP ;2nd column
	db WHITE_FLUTE ;3rd column
	db HEART_SCALE ;4th column
	db SUN_STONE ;5th column
	db MAX_REVIVE ;down diagonal
	db EXP_SHARE ;up diagonal
	db SHINY_BALL ;full card

.second_card
	copybytetovar wTemporaryScriptVariable
	anonjumptable
	dw .noprize
	dw .get_item ;1st line
	dw .get_item ;2nd line
	dw .get_gold_token ;3rd line
	dw .get_TM ;4th line
	dw .get_item ;5th line
	dw .get_TM ;1st column
	dw .get_item ;2nd column
	dw .get_TM ;3rd column
	dw .get_item ;4th column
	dw .get_item ;5th column
	dw .get_item ;down diagonal
	dw .get_item ;up diagonal
	dw .get_item ;full card

.prizes_2
	db RARE_CANDY ;1st line
	db PINK_BOW ;2nd line
	db 1 ;3rd line
	db 75 ;4th line
	db YELLOW_FLUTE ;5th line
	db 96 ;1st column
	db CAGE_KEY ;2nd column
	db 36 ;3rd column
	db BIG_NUGGET ;4th column
	db TRADE_STONE ;5th column
	db MAX_ELIXIR ;down diagonal
	db PP_UP ;up diagonal
	db GRAPPLE_HOOK ;full card

.third_card
	copybytetovar wTemporaryScriptVariable
	anonjumptable
	dw .noprize
	dw .get_TM ;1st line
	dw .get_item ;2nd line
	dw .get_TM ;3rd line
	dw .get_item ;4th line
	dw .get_item ;5th line
	dw .get_gold_token ;1st column
	dw .get_item ;2nd column
	dw .get_TM ;3rd column
	dw .get_item ;4th column
	dw .get_item ;5th column
	dw .get_item ;down diagonal
	dw .get_item ;up diagonal
	dw .get_item ;full card

.prizes_3
	db 64 ;1st line
	db SACRED_ASH ;2nd line
	db 7 ;3rd line
	db PURPLE_FLUTE ;4th line
	db PP_UP ;5th line
	db 2 ;1st column
	db SHELL_BELL ;2nd column
	db 13 ;3rd column
	db SAFE_GOGGLES ;4th column
	db MAX_ELIXIR ;5th column
	db BLACK_FLUTE ;down diagonal
	db ORANGE_FLUTE ;up diagonal
	db MASTER_BALL ;full card

.noprize
	copybytetovar wBingoAwardedPrizes + 1
	sif >=, $10
		jumptextfaceplayer PhloxBingoAttendant_Text_Congratulations
	jumptextfaceplayer PhloxBingoAttendant_Text_NoPrize

.get_item
	scall .get_prize
	itemtotext 0, 0
	writetext PhloxBingoAttendant_Text_GotItem
	playsound SFX_ITEM
	giveitem ITEM_FROM_MEM, 1
	waitsfx
	waitbutton
	anonjumptable
	dw .noRoomForPrize
	dw .got_prize

.get_TM
	scall .get_prize
	writetext PhloxBingoAttendant_Text_GotTM
	playsound SFX_ITEM
	givetmnomessage 0
	waitsfx
	waitbutton
	sif false
.noRoomForPrize
		jumptext PhloxBingoAttendant_Text_NoRoomForPrize
.got_prize
	copybytetovar wTemporaryScriptVariable
	addvar -1
	callasm MarkBingoPrizeAwarded
	sif =, 12, then
		writetext PhloxBingoAttendant_Text_Congratulations
	selse
		writetext PhloxBingoAttendant_Text_EndPrize
	sendif
	endtext

.get_gold_token
	scall .get_prize
	pushvar
	writetext PhloxBingoAttendant_Text_GotGoldToken
	playsound SFX_ITEM
	giveitem GOLD_TOKEN, 1
	waitsfx
	waitbutton
	sif false, then
		popvar
		jumptext PhloxBingoAttendant_Text_NoRoomForPrize
	sendif
	popvar
	readhalfwordbyindex .gold_token_event_flags
	setevent -1
	jump .got_prize

.gold_token_event_flags
	dw EVENT_FIRST_BINGO_CARD_GOLD_TOKEN
	dw EVENT_SECOND_BINGO_CARD_GOLD_TOKEN
	dw EVENT_THIRD_BINGO_CARD_GOLD_TOKEN

.get_prize
	addvar -1
	pushvar
	copybytetovar wBingoCurrentCard
	scall .get_prize_list
	popvar
	loadarray -1, 1
	faceplayer
	opentext
	writetext PhloxBingoAttendant_Text_GotPrize
	waitbutton
	readarray 0
	end

.get_prize_list
	writehalfword .prizes_1
	sif =, 1
		end
	writehalfword .prizes_2
	sif =, 2
		end
	writehalfword .prizes_3
	end

PhloxBingoCard:
	checkevent EVENT_PHLOX_BINGO_GOT_CARD
	sif false
		end
	callasm PlayBingo
	reloadmap
	end

PhloxBingoGranny_Text_NoCard:
	ctxt "Bingo! Bingo!"
	line "BINGO!"

	para "It's great to"
	line "play some bingo."

	para "It would mean the"
	line "world to me if you"
	para "played a quick"
	line "round of bingo"
	cont "with me!"

	para "You can mark a"
	line "square for every"
	para "accomplishment"
	line "you fulfill. And"
	para "don't think you"
	line "can lie to me<...>"

	para "I'm a mother, a"
	line "grandmother, and"
	para "a great-"
	line "grandmother too,"
	cont "hehehe<...>"

	para "<...>so I can tell"
	line "when young kids"
	para "like you are lying"
	line "about something!"

	para "So, do you want"
	line "a card?"
	done

PhloxBingoGranny_Text_GiveCard:
	ctxt "Thanks for playing"
	line "with me! Here is"
	cont "your card!"
	done

PhloxBingoGranny_Text_Instructions:
	ctxt "When you complete"
	line "a line, talk to"
	para "my husband behind"
	line "the counter to"
	cont "get your prize."
	done

PhloxBingoGranny_Text_WontPlay:
	ctxt "Won't you play with"
	line "me? I have nothing"
	cont "else to do<...>"
	done

PhloxBingoGranny_Text_PrizeWaiting:
	ctxt "You made a line!"
	line "Congratulations!"

	para "Head to the coun-"
	line "ter over there to"
	cont "claim your prize!"
	done

PhloxBingoGranny_Text_CompletedCard:
	ctxt "Wow! You completed"
	line "the whole card and"
	para "claimed all the"
	line "prizes! Well done!"

	para "Let me put this"
	line "card away now."
	prompt

PhloxBingoGranny_Text_WantAnotherCard:
	ctxt "I can give you"
	line "another card with"
	para "more goals for you"
	line "to complete."

	para "Do you want"
	line "another card?"
	done

PhloxBingoGranny_Text_NoMoreCards:
	ctxt "I'm all out of"
	line "cards!"

	para "Thanks for playing"
	line "bingo with me!"
	done

PhloxBingoAttendant_Text_NoCard:
	ctxt "Welcome to the"
	line "Bingo Hall!"

	para "Grab yourself a"
	line "card, and win some"
	cont "fabulous prizes!"

	para "The lady sitting"
	line "over there grabbed"
	para "our last cards<...>"
	line "but she'll probably"
	cont "share them."
	done

PhloxBingoAttendant_Text_GotPrize:
	start_asm
	ld a, [hScriptVar]
	cp 12
	ld hl, .full_card_text
	ret z
	push bc
	ld bc, wStringBuffer3 - wStringBuffer1
	ld hl, wStringBuffer1
	push hl
	push af
	ld a, "@"
	call ByteFill
	pop af
	ld c, 5
	call SimpleDivide
	bit 1, b
	ld hl, .ordinals
	jr z, .selected_list
	ld hl, .diagonal_names
.selected_list
	call GetNthString
	ld e, l
	ld d, h
	pop hl
	push bc
	call PlaceString
	pop af
	ld hl, .kinds
	call GetNthString
	ld e, l
	ld d, h
	ld hl, wStringBuffer2
	call PlaceString
	pop bc
	ld hl, .text
	ret
.text
	ctxt "Congratulations!"
	line "You completed the"
	para "<STRBF1> <STRBF2>!"
	done
.full_card_text
	ctxt "You finished the"
	line "whole card! Well"
	cont "done!"
	done
.ordinals
	db "first@"
	db "second@"
	db "third@"
	db "fourth@"
	db "fifth@"
.kinds
	db "row@"
	db "column@"
	db "diagonal@"
.diagonal_names
	db "down@"
	db "up@"

PhloxBingoAttendant_Text_NoPrize:
	ctxt "If you complete a"
	line "line in your card,"
	cont "come here to get"
	cont "your prize!"
	done

PhloxBingoAttendant_Text_GotItem:
	start_asm
	push bc
	ld hl, wStringBuffer1
	ld [hl], "a"
	inc hl
	ld a, "@"
	ld [hli], a
	ld [hld], a
	push hl
	ld a, [wStringBuffer3]
	ld hl, .vowels
	call IsInSingularArray
	pop hl
	jr nc, .not_vowel
	ld [hl], "n"
.not_vowel
	pop bc
	ld hl, .text
	ret
.vowels
	db "AEIOUaeiou", -1
.text
	ctxt "You won <STRBF1>"
	line "<STRBF3>!"
	done

PhloxBingoAttendant_Text_EndPrize:
	ctxt "Come back when you"
	line "complete another"
	cont "line!"
	done

PhloxBingoAttendant_Text_NoRoomForPrize:
	ctxt "But you have no"
	line "room for your"
	cont "prize<...>"

	para "I'll keep it for"
	line "you for a while,"
	cont "so come back after"
	cont "making some room."
	done

PhloxBingoAttendant_Text_GotTM:
	start_asm
	push bc
	ld a, [hScriptVar]
	ld c, 10
	call SimpleDivide
	push af
	ld a, b
	add a, "0"
	ld hl, wStringBuffer1
	ld [hli], a
	pop af
	add a, "0"
	ld [hli], a
	ld [hl], "@"
	ld hl, .text
	pop bc
	ret
.text
	ctxt "You won a TM<STRBF1>!"
	done

PhloxBingoAttendant_Text_GotGoldToken:
	ctxt "You won a"
	line "Gold Token!"
	done

PhloxBingoAttendant_Text_Congratulations:
	ctxt "Congratulations on"
	line "finishing your"
	cont "bingo card!"
	done

PhloxBingo_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $6, 5, PHLOX_TOWN
	warp_def $9, $7, 5, PHLOX_TOWN

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_GRANNY, 5, 9, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, PERSONTYPE_SCRIPT, 0, PhloxBingoGranny, -1
	person_event SPRITE_GRAMPS, 6, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, PERSONTYPE_SCRIPT, 0, PhloxBingoAttendant, -1
	person_event SPRITE_POKEDEX, 5, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, PERSONTYPE_SCRIPT, 0, PhloxBingoCard, EVENT_PHLOX_BINGO_GOT_CARD | $8000
