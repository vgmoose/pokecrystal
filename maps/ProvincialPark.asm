ProvincialPark_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ProvincialPark_Item_1:
	db PP_UP, 2

ProvincialPark_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $8, $21, 1, PROVINCIAL_PARK_GATE
	warp_def $9, $21, 2, PROVINCIAL_PARK_GATE
	warp_def $2f, $16, 3, MAGMA_ITEMROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_POKE_BALL, 9, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 1, 0, ProvincialPark_Item_1, EVENT_PROVINCIAL_PARK_ITEM_1
