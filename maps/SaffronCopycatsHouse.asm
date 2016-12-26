SaffronCopycatsHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SaffronCopycatsHouseNPC1:
	jumptextfaceplayer SaffronPikachuDollText

SaffronCopycatsHouseNPC2:
	jumptextfaceplayer SaffronGengarDollText

SaffronCopycatsHouseNPC3:
	jumptextfaceplayer SaffronCaterpieDollText

SaffronCopycatsHouseNPC4:
	jumptextfaceplayer SaffronCopycatsHouseNPC1_Text_16d1ac

SaffronCopycatNPC:
	jumptextfaceplayer SaffronCopycatNPCText

SaffronCopycatNPCText:
	ctxt "Hi there!"

	para "I'm called Copycat."

	para "I don't mimic many"
	line "people anymore,"

	para "but I collect"
	line "#mon dolls!"
	done


SaffronPikachuDollText:
	ctxt "It's a Pikachu"
	line "doll!"
	done

SaffronGengarDollText:
	ctxt "It's a Gengar"
	line "doll!"
	done

SaffronCaterpieDollText:
	ctxt "It's a Caterpie"
	line "doll!"
	done

SaffronCopycatsHouseNPC1_Text_16d1ac:
	ctxt "It's a Larvitar"
	line "doll!"

	para "Ah, memories<...>"
	done

SaffronCopycatsHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $7, $2, 16, SAFFRON_CITY
	warp_def $7, $3, 16, SAFFRON_CITY
	warp_def $0, $2, 4, SAFFRON_COPYCATS_HOUSE
	warp_def $e, $3, 3, SAFFRON_COPYCATS_HOUSE

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 4
	person_event SPRITE_LASS, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronCopycatNPC, -1
	person_event SPRITE_PIKACHU, 15, 2, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronCopycatsHouseNPC1, -1
	person_event SPRITE_GENGAR, 15, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_RED, 0, 0, SaffronCopycatsHouseNPC2, -1
	person_event SPRITE_CATERPIE, 15, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaffronCopycatsHouseNPC3, -1
	person_event SPRITE_LARVITAR, 19, 4, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SaffronCopycatsHouseNPC4, -1
