TrainerHouseB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

TrainerHouseB1FNPC1:
	jumptextfaceplayer TrainerHouseB1FNPC1_Text_18400d

TrainerHouseB1F_Item_1:
	db STICK, 1

TrainerHouseB1FNPC1_Text_18400d:
	ctxt "A word of advice"
	line "just for you, kid."

	para "It's better to"
	line "train multiple"
	cont "#mon instead"
	cont "of just one."
	done

TrainerHouseB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $5, $3, 3, TRAINER_HOUSE
	warp_def $5, $11, 2, TRAINER_HOUSE
	warp_def $5, $1d, 10, TRAINER_HOUSE
	warp_def $5, $27, 7, TRAINER_HOUSE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_BLACK_BELT, 8, 13, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 8 + PAL_OW_BLUE, 0, 0, TrainerHouseB1FNPC1, -1
	person_event SPRITE_POKE_BALL, 8, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, TrainerHouseB1F_Item_1, EVENT_TRAINER_HOUSE_B1F_ITEM_1
