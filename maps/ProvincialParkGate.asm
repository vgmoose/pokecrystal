ProvincialParkGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ProvincialParkGateAttendant:
	faceplayer
	opentext
	writetext .introduction_text
.show_options
	getweekday
	iffalse .weekend
	if_equal 6, .weekend
	loadmenudata .regular_menu_header
	verticalmenu
	closewindow
	anonjumptable
	dw .cancelled
	dw .enter
	dw .instructions
	dw .cancelled

.weekend
	loadmenudata .weekend_menu_header
	verticalmenu
	closewindow
	anonjumptable
	dw .cancelled
	dw .enter
	dw .weekend_special
	dw .instructions
	dw .cancelled

.enter
	writetext .which_mode_text
	special PlaceMoneyTopRight
	loadmenudata .game_menu_header
	verticalmenu
	closewindow
	iffalse .cancelled
	addvar -1
	jump .joined

.weekend_special
	writetext .weekend_special_text
	special PlaceMoneyTopRight
	yesorno
	iffalse .cancelled
	writebyte 3

.joined
	farscall StartParkMinigameScript
	sif true
		end
	writetext .no_money_text
	endtext

.instructions
	writetext .instructions_text
	jump .show_options

.cancelled
	writetext .denied_text
	endtext

.regular_menu_header
	db $40 ;flags
	db 4, 1 ;start coordinates; initial y = final y - (2 * items + 1), initial x = final x - (longest item + 3)
	db 11, 19 ;end coordinates, next to the dialogue corner
	dw .regular_menu_options
	db 1 ;default option
.regular_menu_options
	db $80 ;print the text one tile to the right of the border
	db 3 ;option count
	db "Enter challenge@"
	db "Instructions@"
	db "No thanks@"

.weekend_menu_header
	db $40 ;flags
	db 2, 1 ;start coordinates; initial y = final y - (2 * items + 1), initial x = final x - (longest item + 3)
	db 11, 19 ;end coordinates, next to the dialogue corner
	dw .weekend_menu_options
	db 1 ;default option
.weekend_menu_options
	db $80 ;print the text one tile to the right of the border
	db 4 ;option count
	db "Enter challenge@"
	db "Weekend special@"
	db "Instructions@"
	db "No thanks@"

.game_menu_header
	db $40 ;flags
	db 4, 0 ;start coordinates; initial y = final y - (2 * items + 1), initial x = final x - (longest item + 3)
	db 11, 19 ;end coordinates, next to the dialogue corner
	dw .game_menu_options
	db 1 ;default option
.game_menu_options
	db $80 ;print the text one tile to the right of the border
	db 3 ;option count
	db "10 minutes ¥2000@"
	db "20 minutes ¥3500@"
	db "30 minutes ¥5000@"

.introduction_text
	ctxt "There is a chall-"
	line "enge going on here"
	cont "at the park."

	para "Interested?"
	done

.denied_text
	ctxt "Fine then, enjoy"
	line "the park."

	para "<...>"

	para "What do you mean,"
	line "I should sound"
	cont "more interested"
	cont "in my job?"

	para "Look, I'm just told"
	line "what to say, not"
	cont "how to say it."

	para "If you have a"
	line "problem with that,"

	para "take it up with"
	line "the higher-ups."
	done

.which_mode_text
	ctxt "How long do you"
	line "want to play for?"
	done

.weekend_special_text
	ctxt "The weekend's"
	line "special challenge"
	cont "is 15 minutes for"
	cont "¥2500. Interested?"
	done

.no_money_text
	ctxt "Come on, this"
	line "isn't a charity."

	para "If you don't have"
	line "the # bucks,"
	cont "then there's no"
	cont "reason for you to"
	cont "to keep bothering"
	cont "me."
	done

.instructions_text
	ctxt "-sighs-"

	para "Fine... here are"
	line "the instructions."

	para "Each spot might"
	line "contain balls,"
	cont "a #mon, or"
	cont "nothing at all."

	para "If you battle the"
	line "#mon or pick up"
	cont "the items, the"
	cont "spot will become"
	cont "empty for a while."

	para "Empty spots will"
	line "regenerate after"
	cont "a minute or so."

	para "The #mon you'll"
	line "find here are"
	cont "stronger than the"
	cont "ones found in the"
	cont "wild elsewhere,"
	cont "and will be shiny"
	cont "more often."

	para "You cannot use"
	line "your own #"
	cont "Balls here. You"
	cont "will be given a"
	cont "supply of Park"
	cont "Balls, and you can"
	cont "use the balls you"
	cont "find in the park"
	cont "as well."

	para "You will have to"
	line "return the Park"
	cont "Balls you don't"
	cont "use. You cannot"
	cont "take with you the"
	cont "balls you find"
	cont "either, but we'll"
	cont "keep those for"
	cont "your next visits."

	para "You will also have"
	line "a time limit. Once"
	cont "the time is up,"
	cont "the PA will notify"
	cont "you and you will"
	cont "be taken back to"
	cont "the entrance."

	done

ProvincialParkGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $4, $0, 1, PROVINCIAL_PARK
	warp_def $5, $0, 2, PROVINCIAL_PARK
	warp_def $4, $d, 2, ROUTE_81
	warp_def $5, $d, 4, ROUTE_81

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 2, 6, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ProvincialParkGateAttendant, -1
