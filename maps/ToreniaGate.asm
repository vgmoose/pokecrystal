ToreniaGate_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

ToreniaGateNPC1:
	jumptextfaceplayer ToreniaGateNPC1_Text_2f6f8a

ToreniaGateNPC1_Text_2f6f8a:
	ctxt "People need to"
	line "stop blaming me"
	para "for letting the"
	line "Palette Patrollers"
	cont "through here."

	para "I'm only human!"
	done

ToreniaGate_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $0, $4, 11, TORENIA_CITY
	warp_def $0, $5, 12, TORENIA_CITY
	warp_def $7, $4, 6, ROUTE_77
	warp_def $7, $5, 6, ROUTE_77

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 1
	person_event SPRITE_OFFICER, 3, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, ToreniaGateNPC1, -1
