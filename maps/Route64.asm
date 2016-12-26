Route64_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route64HiddenItem_1:
	dw EVENT_ROUTE_64_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route64Signpost1:
	ctxt "Silph Warehouse"
	done

Route64Signpost2:
	ctxt "Naljo border"
	next "entrance"
	done

Route64Signpost3:
	ctxt "The path to"
	next "Naljo."
	done

Route64_Item_1:
	db SMOOTH_ROCK, 1

Route64NPC1:
	jumpstd smashrock

Route64_MapEventHeader ;filler
	db 0, 0

;warps
	db 1
	warp_def $5, $30, 2, NALJO_BORDER_EAST

	;xy triggers
	db 0

	;signposts
	db 4
	signpost 15, 3, SIGNPOST_LOAD, Route64Signpost1
	signpost 9, 49, SIGNPOST_LOAD, Route64Signpost2
	signpost 13, 79, SIGNPOST_LOAD, Route64Signpost3
	signpost 6, 39, SIGNPOST_ITEM, Route64HiddenItem_1

	;people-events
	db 2
	person_event SPRITE_POKE_BALL, 6, 40, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 1, 0, Route64_Item_1, EVENT_ROUTE_64_ITEM_1
	person_event SPRITE_ROCK, 6, 43, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route64NPC1, -1
