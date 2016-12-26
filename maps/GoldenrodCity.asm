GoldenrodCity_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 1

	dbw 5, GoldenrodCity_SetFlyFlag

GoldenrodCity_SetFlyFlag:
	setflag ENGINE_FLYPOINT_GOLDENROD_CITY
	return

GoldenrodCityHiddenItem_1:
	dw EVENT_GOLDENROD_CITY_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

GoldenrodCitySignpost1:
	ctxt "Magnet Train"
	next "Station"
	done

GoldenrodCitySignpost2:
	opentext
	qrcode 2
	waitbutton
	checkitem QR_READER
	iffalse GoldenrodCity_1c2a1c
	farwritetext UsingQRScannerText
	playwaitsfx SFX_CALL
	jumptext GoldenrodCitySignpost2_Text_1c2a3f

GoldenrodCitySignpost4:
	ctxt "#mon Gym"
	next "Leader: Whitney"
	nl  ""
	next "The Incredibly"
	next "Pretty Girl!"
	done

GoldenrodCitySignpost5:
	ctxt "The Festive City"
	next "of Opulent Charm"
	done

GoldenrodCitySignpost6:
	ctxt "<LEFT> Goldenrod Cape"
	done

GoldenrodCitySignpost7:
	ctxt "Goldenrod Game"
	next "Corner"
	nl ""
	next "Your Playground!"
	done

GoldenrodCitySignpost8:
GoldenrodCitySignpost9:
	ctxt "Underground"
	next "Entrance"
	done

GoldenrodCitySignpost10:
	jumpstd pokecentersign

GoldenrodCityNPC1:
	jumptextfaceplayer GoldenrodCityNPC1_Text_1c287a

GoldenrodCityNPC2:
	jumptextfaceplayer GoldenrodCityNPC2_Text_1c25c4

GoldenrodCityNPC3:
	jumptextfaceplayer GoldenrodCityNPC3_Text_1c2979

GoldenrodCityNPC4:
	jumptextfaceplayer GoldenrodCityNPC4_Text_1c27eb

GoldenrodCityNPC5:
	jumptextfaceplayer GoldenrodCityNPC5_Text_1c28e3

GoldenrodCityNPC6:
	jumptextfaceplayer GoldenrodCityNPC6_Text_1c266a

GoldenrodCityNPC7:
	jumptextfaceplayer GoldenrodCityNPC7_Text_1c2797

GoldenrodCityNPC8:
	jumptextfaceplayer GoldenrodCityNPC8_Text_1c26d8

GoldenrodCity_1c2a1c:
	closetext
	end

GoldenrodCitySignpost2_Text_1c2a3f:
	ctxt "Emerald Egg -"
	line "Rock in small"
	cont "lake"
	done

GoldenrodCitySignpost9_Text_1c244b:


GoldenrodCityNPC1_Text_1c287a:
	ctxt "This magnet train"
	line "is amazing!"

	para "It goes up"
	line "mountains, under"

	para "the ocean, and"
	line "everywhere in"
	cont "between!"
	done

GoldenrodCityNPC2_Text_1c25c4:
	ctxt "I was sad when the"
	line "department store"
	cont "was destroyed."

	para "However, they're"
	line "building a new"
	cont "one!"

	para "The basement"
	line "should be fine,"

	para "but nobody has"
	line "been down there"
	cont "in years."
	done

GoldenrodCityNPC3_Text_1c2979:
	ctxt "If your #mon"
	line "is happy enough,"

	para "a woman will teach"
	line "it a special move."

	para "Most #mon won't"
	line "be able to learn"

	para "that move from"
	line "leveling up, or"
	cont "even TMs!"
	done

GoldenrodCityNPC4_Text_1c27eb:
	ctxt "There used to be"
	line "a Radio Tower."

	para "DJ Ben was the"
	line "coolest!"

	para "I heard he'll"
	line "start a new show"

	para "when they rebuild"
	line "the Radio Tower."

	para "I can't wait!"
	done

GoldenrodCityNPC5_Text_1c28e3:
	ctxt "I remember when"
	line "Team Rocket"

	para "tried to take"
	line "over the town."

	para "A child named Gold"
	line "saved everybody."
	done

GoldenrodCityNPC6_Text_1c266a:
	ctxt "Not even an"
	line "earthquake can"
	cont "stop us."

	para "No matter what"
	line "happens, we will"

	para "always stand tall"
	line "and stay gold."
	done

GoldenrodCityNPC7_Text_1c2797:
	ctxt "I heard that, far"
	line "away, a special"

	para "ring will open up"
	line "a portal to"
	cont "another dimension."

	para "That would be so"
	line "interesting to"
	cont "visit!"
	done

GoldenrodCityNPC8_Text_1c26d8:
	ctxt "I'm sorry, I can't"
	line "allow you to pass"

	para "unless you're a"
	line "Johto citizen."

	para "We had to crack"
	line "down on security,"

	para "because rumor"
	line "has it that a"

	para "criminal from a"
	line "faraway region"

	para "is hiding out"
	line "here."
	done


GoldenrodCity_MapEventHeader ;filler
	db 0, 0

;warps
	db 13
	warp_def $7, $8, 1, GOLDENROD_GYM
	warp_def $17, $17, 1, GOLDENROD_MART
	warp_def $17, $f, 1, GOLDENROD_POKECENTER
	warp_def $5, $21, 1, GOLDENROD_BILL
	warp_def $d, $9, 1, GOLDENROD_MAGNET_TRAIN
	warp_def $10, $4, 3, GOLDENROD_CAPE_GATE
	warp_def $11, $4, 4, GOLDENROD_CAPE_GATE
	warp_def $17, $1f, 1, GOLDENROD_HAPPINESS_MOVE_TEACHER
	warp_def $23, $9, 9, SAXIFRAGE_POKECENTER
	warp_def $23, $18, 1, GOLDENROD_MAGNET_TRAIN
	warp_def $17, $7, 1, GOLDENROD_GAME_CORNER
	warp_def $5, $d, 1, GOLDENROD_UNDERGROUND_ENTRY_A
	warp_def $1d, $b, 1, GOLDENROD_UNDERGROUND_ENTRY_B

	;xy triggers
	db 0

	;signposts
	db 10
	signpost 14, 8, SIGNPOST_LOAD, GoldenrodCitySignpost1
	signpost 26, 26, SIGNPOST_READ, GoldenrodCitySignpost2
	signpost 10, 33, SIGNPOST_ITEM, GoldenrodCityHiddenItem_1
	signpost 8, 10, SIGNPOST_LOAD, GoldenrodCitySignpost4
	signpost 18, 22, SIGNPOST_LOAD, GoldenrodCitySignpost5
	signpost 18, 6, SIGNPOST_LOAD, GoldenrodCitySignpost6
	signpost 24, 6, SIGNPOST_LOAD, GoldenrodCitySignpost7
	signpost 6, 14, SIGNPOST_LOAD, GoldenrodCitySignpost8
	signpost 30, 12, SIGNPOST_LOAD, GoldenrodCitySignpost9
	signpost 23, 16, SIGNPOST_READ, GoldenrodCitySignpost10

	;people-events
	db 8
	person_event SPRITE_POKEFAN_M, 10, 34, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_OW_RED, 0, 0, GoldenrodCityNPC1, -1
	person_event SPRITE_YOUNGSTER, 16, 12, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, 0, 0, 0, GoldenrodCityNPC2, -1
	person_event SPRITE_COOLTRAINER_F, 18, 29, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 8 + PAL_OW_GREEN, 0, 0, GoldenrodCityNPC3, -1
	person_event SPRITE_COOLTRAINER_F, 26, 9, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodCityNPC4, -1
	person_event SPRITE_YOUNGSTER, 28, 27, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodCityNPC5, -1
	person_event SPRITE_LASS, 8, 18, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, 8 + PAL_OW_GREEN, 0, 0, GoldenrodCityNPC6, -1
	person_event SPRITE_GRAMPS, 25, 19, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_OW_RED, 0, 0, GoldenrodCityNPC7, -1
	person_event SPRITE_OFFICER, 4, 19, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, GoldenrodCityNPC8, -1
