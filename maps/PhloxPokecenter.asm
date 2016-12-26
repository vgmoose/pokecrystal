PhloxPokecenter_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhloxPokecenterNPC1:
	jumptextfaceplayer PhloxPokecenterNPC1_Text_1d2aab

PhloxPokecenterNPC2:
	jumptextfaceplayer PhloxPokecenterNPC2_Text_1d2a44

PhloxPokecenterNPC3:
	jumpstd pokecenternurse

PhloxPokecenterNPC1_Text_1d2aab:
	ctxt "I'm going to stay"
	line "in here until it"
	cont "warms up outside."
	done

PhloxPokecenterNPC2_Text_1d2a44:
	ctxt "I say, this quiet"
	line "mountain town is"
	cont "intoxicating."

	para "I may just buy a"
	line "house and move"
	cont "here to Phlox!"
	done

PhloxPokecenter_MapEventHeader ;filler
	db 0, 0

;warps
	db 3
	warp_def $7, $4, 1, PHLOX_TOWN
	warp_def $7, $5, 1, PHLOX_TOWN
	warp_def $0, $7, 1, POKECENTER_BACKROOM

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 3
	person_event SPRITE_ROCKER, 4, 1, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_PURPLE, 0, 0, PhloxPokecenterNPC1, -1
	person_event SPRITE_GENTLEMAN, 6, 8, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_BROWN, 0, 0, PhloxPokecenterNPC2, -1
	person_event SPRITE_NURSE, 1, 4, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhloxPokecenterNPC3, -1
