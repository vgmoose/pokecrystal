Route34_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route34Signpost1:
	ctxt "<UP> Goldenrod City"
	next "<DOWN> Ilex Forest"
	next "<DOWN><RIGHT> Azalea Town"
	done

Route34Signpost2:
	jumptext Route34Signpost2_Text_3232ec

Route34Signpost3:
	signpostheader 1
	ctxt "Talented Trainers"
	nl   "can make their"
	nl   "own #balls!"

	next "Search through"
	nl   "Rijon to find"
	nl   "apricorn trees."
	done

Route34_Item_1:
	db PP_UP, 1

Route34_Trainer_1:
	trainer EVENT_ROUTE_34_TRAINER_1, PICNICKER, 6, Route34_Trainer_1_Text_32344f, Route34_Trainer_1_Text_323494, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route34_Trainer_1_Script_Text_3234a6

Route34_Trainer_2:
	trainer EVENT_ROUTE_34_TRAINER_2, YOUNGSTER, 5, Route34_Trainer_2_Text_3234f1, Route34_Trainer_2_Text_32352a, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route34_Trainer_2_Script_Text_32355f

Route34_Trainer_3:
	trainer EVENT_ROUTE_34_TRAINER_3, POKEFANM, 3, Route34_Trainer_3_Text_3233e6, Route34_Trainer_3_Text_323404, $0000, .Script

.Script:
	end_if_just_battled
	jumptext Route34_Trainer_3_Script_Text_323420

Route34Signpost2_Text_3232ec:
	ctxt "For Sale"

	para "Looks like nobody"
	line "lives here<...>"
	done

Route34_Trainer_1_Text_32344f:
	ctxt "Are you the Rijon"
	line "champion?"

	para "Let me have a"
	line "practice battle"
	cont "with you."
	done

Route34_Trainer_1_Text_323494:
	ctxt "I can never win!"
	done

Route34_Trainer_1_Script_Text_3234a6:
	ctxt "I won't give up"
	line "just because a"

	para "strong Trainer"
	line "beat me!"
	done

Route34_Trainer_2_Text_3234f1:
	ctxt "I graduated at"
	line "the top of my"
	cont "class!"

	para "The class was"
	line "#mon!"
	done

Route34_Trainer_2_Text_32352a:
	ctxt "I may not be the"
	line "best, but I"

	para "enjoy the sport"
	line "of it!"
	done

Route34_Trainer_2_Script_Text_32355f:
	ctxt "I gotta keep"
	line "trying."

	para "After all, a life"
	line "without failure"

	para "is a life without"
	line "experience."
	done

Route34_Trainer_3_Text_3233e6:
	ctxt "Keep on training,"
	line "yeah yeah!"
	done

Route34_Trainer_3_Text_323404:
	ctxt "Keep on trying,"
	line "yeah yeah!"
	done

Route34_Trainer_3_Script_Text_323420:
	ctxt "Never give up,"
	line "yeah yeah!"
	done

Route34_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $25, $d, 3, ROUTE_34_GATE
	warp_def $25, $e, 4, ROUTE_34_GATE

	;xy triggers
	db 0

	;signposts
	db 3
	signpost 6, 12, SIGNPOST_LOAD, Route34Signpost1
	signpost 13, 10, SIGNPOST_READ, Route34Signpost2
	signpost 33, 13, SIGNPOST_LOAD, Route34Signpost3

	;people-events
	db 4
	person_event SPRITE_POKE_BALL, 48, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, Route34_Item_1, EVENT_ROUTE_34_ITEM_1
	person_event SPRITE_LASS, 22, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 2, 4, Route34_Trainer_1, -1
	person_event SPRITE_YOUNGSTER, 10, 9, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route34_Trainer_2, -1
	person_event SPRITE_POKEFAN_M, 27, 19, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, Route34_Trainer_3, -1
