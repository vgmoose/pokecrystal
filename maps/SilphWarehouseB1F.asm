SilphWarehouseB1F_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SilphWarehouseB1F_Item_1:
	db UP_GRADE, 1

SilphWarehouseB1F_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def 14, 15, 3, SILPH_WAREHOUSE_F1

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_POKE_BALL, 5, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_PURPLE, 3, TM_TOXIC, 0, EVENT_SILPH_WAREHOUSE_B1F_NPC_1
	person_event SPRITE_POKE_BALL, 8, 11, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_YELLOW, 1, 0, SilphWarehouseB1F_Item_1, EVENT_SILPH_WAREHOUSE_B1F_ITEM_1
