Route56_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route56HiddenItem_1:
	dw EVENT_ROUTE_56_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route56HiddenItem_2:
	dw EVENT_ROUTE_56_HIDDENITEM_SILVER_EGG
	db SILVER_EGG

Route56_Trainer_1:
	trainer EVENT_ROUTE_56_TRAINER_1, SWIMMERM, 7, Route56_Trainer_1_Text_2f8166, Route56_Trainer_1_Text_2f8182, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route56_Trainer_1_Script_Text_2f81b8

Route56_Trainer_2:
	trainer EVENT_ROUTE_56_TRAINER_2, SWIMMERF, 6, Route56_Trainer_2_Text_2f80f4, Route56_Trainer_2_Text_2f810c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route56_Trainer_2_Script_Text_2f8132

Route56_Trainer_3:
	trainer EVENT_ROUTE_56_TRAINER_3, SWIMMERM, 8, Route56_Trainer_3_Text_2f8050, Route56_Trainer_3_Text_2f8059, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route56_Trainer_3_Script_Text_2f808f

Route56_Trainer_1_Text_2f8166:
	ctxt "Guess how many"
	line "laps I did!"
	done

Route56_Trainer_1_Text_2f8182:
	ctxt "I swamp back and"
	line "forth hundreds"
	cont "of times."

	para "Seriously!"
	done

Route56_Trainer_1_Script_Text_2f81b8:
	ctxt "I'll shave my"
	line "hair next time,"

	para "it's supposed to"
	line "make me swim"
	cont "faster, right?"
	done

Route56_Trainer_2_Text_2f80f4:
	ctxt "Look at me"
	line "backstroke!"
	done

Route56_Trainer_2_Text_2f810c:
	ctxt "Swimming while"
	line "battling is"
	cont "exciting!"
	done

Route56_Trainer_2_Script_Text_2f8132:
	ctxt "Come practice with"
	line "me sometime."
	done

Route56_Trainer_3_Text_2f8050:
	ctxt "Stroke!"
	done

Route56_Trainer_3_Text_2f8059:
	ctxt "That battle"
	line "almost gave me"

	para "the other kind"
	line "of stroke!"
	done

Route56_Trainer_3_Script_Text_2f808f:
	ctxt "Swimming will"
	line "keep you fit."

	para "When you surf,"
	line "your #mon get"
	cont "the exercise,"
	cont "not you!"
	done

Route56_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $3, $23, 2, ROUTE_56_GATE_UNDERGROUND
	warp_def $b, $5d, 1, ROUTE_56_GATE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 0, 77, SIGNPOST_ITEM, Route56HiddenItem_1
	signpost 17, 52, SIGNPOST_ITEM, Route56HiddenItem_2

	;people-events
	db 3
	person_event SPRITE_SWIMMER_GUY, 9, 72, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route56_Trainer_1, -1
	person_event SPRITE_SWIMMER_GIRL, 11, 42, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route56_Trainer_2, -1
	person_event SPRITE_SWIMMER_GUY, 7, 23, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route56_Trainer_3, -1
