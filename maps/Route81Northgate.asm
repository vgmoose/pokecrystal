Route81Northgate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route81NorthgateNPC1:
	jumptextfaceplayer Route81NorthgateNPC1_Text_14fa45

Route81NorthgateNPC1_Text_14fa45:
	ctxt "The city north is"
	line "still developing."

	para "They saw this big"
	line "piece of ocean and"
	cont "just said, 'Hey!"

	para "Why don't we build"
	line "a city on that?'"

	para "I just find that"
	line "notion hilarious."
	done

Route81Northgate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $0, $4, 3, ACANIA_DOCKS
	warp_def $0, $5, 4, ACANIA_DOCKS
	warp_def $7, $4, 1, ROUTE_81
	warp_def $7, $5, 1, ROUTE_81

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 4, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, Route81NorthgateNPC1, -1
