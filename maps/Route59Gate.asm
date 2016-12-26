Route59Gate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route59GateNPC1:
	jumptext Route59GateNPC1_Text_177f43

Route59GateNPC2:
	jumptext Route59GateNPC1_Text_177f43

Route59GateNPC1_Text_177f43:
	ctxt "Sorry, Botan City"
	line "is quarantined"
	cont "until the boss"
	cont "says it's OK."

	para "Oh, you're stuck"
	line "in there?"

	para "Oh well, not my"
	line "problem."
	done

Route59Gate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $3, $0, 2, ROUTE_59
	warp_def $4, $0, 2, ROUTE_59
	warp_def $3, $5, 2, BOTAN_CITY
	warp_def $4, $5, 2, BOTAN_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route59GateNPC1, EVENT_ROUTE_59_TRAINER_1
	person_event SPRITE_OFFICER, 4, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route59GateNPC2, EVENT_ROUTE_59_TRAINER_1
