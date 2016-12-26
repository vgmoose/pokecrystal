ClathriteB2F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ClathriteB2FHiddenItem_1:
	dw EVENT_CLATHRITE_B2F_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

ClathriteB2FNPC1:
ClathriteB2FNPC2:
ClathriteB2FNPC3:
	jumpstd strengthboulder

ClathriteB2F_Item_1:
	db DRAGON_FANG, 1

ClathriteB2F_Trainer_1:
	trainer EVENT_CLATHRITE_B2F_TRAINER_1, BOARDER, 3, ClathriteB2F_Trainer_1_Text_11ac35, ClathriteB2F_Trainer_1_Text_11ac5c, $0000, .Script

.Script:
	end_if_just_battled
	jumptext ClathriteB2F_Trainer_1_Script_Text_11ac72

ClathriteB2F_Trainer_2:
	trainer EVENT_CLATHRITE_B2F_TRAINER_2, SKIER, 6, ClathriteB2F_Trainer_2_Text_11acd4, ClathriteB2F_Trainer_2_Text_11acf0, $0000, .Script

.Script:
	end_if_just_battled
	jumptext ClathriteB2F_Trainer_2_Script_Text_11ad13

ClathriteB2F_Trainer_1_Text_11ac35:
	ctxt "These puzzles are"
	line "super exciting,"
	cont "don't you think?"
	done

ClathriteB2F_Trainer_1_Text_11ac5c:
	ctxt "You don't think"
	line "they're exciting?"
	done

ClathriteB2F_Trainer_1_Script_Text_11ac72:
	ctxt "The city to the"
	line "west used to be"
	para "fully submerged"
	line "under water."

	para "How is that even"
	line "remotely possible?"
	done

ClathriteB2F_Trainer_2_Text_11acd4:
	ctxt "This cave is oh"
	line "so beautiful!"
	done

ClathriteB2F_Trainer_2_Text_11acf0:
	ctxt "My #mon are"
	line "beautiful too,"
	cont "right<...>?"
	done

ClathriteB2F_Trainer_2_Script_Text_11ad13:
	ctxt "What about me, am"
	line "I beautiful then?"

	para "Come on!"
	line "Talk to me!"
	done

ClathriteB2F_MapEventHeader:: db 0, 0

.Warps: db 9
	warp_def 15, 3, 1, CLATHRITE_B1F
	warp_def 13, 47, 6, CLATHRITE_B2F
	warp_def 53, 57, 3, CLATHRITE_B1F
	warp_def 53, 27, 8, CLATHRITE_B2F
	warp_def 5, 55, 7, CLATHRITE_B2F
	warp_def 31, 15, 2, CLATHRITE_B2F
	warp_def 45, 43, 5, CLATHRITE_B2F
	warp_def 35, 17, 4, CLATHRITE_B2F
	warp_def 29, 55, 1, CLATHRITE_KYOGRE

.CoordEvents: db 0

.BGEvents: db 1
	signpost 28, 15, SIGNPOST_ITEM, ClathriteB2FHiddenItem_1

.ObjectEvents: db 7
	person_event SPRITE_BOULDER, 44, 44, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ClathriteB2FNPC1, -1
	person_event SPRITE_BOULDER, 35, 25, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ClathriteB2FNPC2, -1
	person_event SPRITE_BOULDER, 12, 47, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ClathriteB2FNPC3, -1
	person_event SPRITE_POKE_BALL, 20, 39, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 1, 0, ClathriteB2F_Item_1, EVENT_CLATHRITE_B2F_ITEM_1
	person_event SPRITE_POKE_BALL, 24, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BLUE, 3, TM_DRAGON_CLAW, 0, EVENT_GOT_TM07
	person_event SPRITE_BOARDER, 41, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BLUE, 2, 4, ClathriteB2F_Trainer_1, -1
	person_event SPRITE_BUENA, 18, 30, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_OW_RED, 2, 4, ClathriteB2F_Trainer_2, -1
