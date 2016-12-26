HeathHouseWeaver_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HeathShrineNPC1:
	checkflag EVENT_VARANEOUS_REVIVED
	sif false
		jumptextfaceplayer HeathShrineNPCTextLegendsAsleep
	jumptextfaceplayer HeathShrineNPCText

HeathShrinePodium:
	jumptext HeathShrinePodiumText

HeathShrineNPCTextLegendsAsleep:
	ctxt "It would be truly"
	line "exciting if the"
	cont "legends woke up."

	para "When I was a boy,"
	line "my grandfather"

	para "told me how life"
	line "was when they"
	cont "were around."

	para "Life was simpler,"
	line "but happier."
	done

HeathShrinePodiumText:
	ctxt "Centuries ago,"
	line "Naljo was nothing"
	cont "but ocean."

	para "During the great"
	line "wars, the legends"

	para "created new"
	line "isolated islands"

	para "free of wars and"
	line "where everyone"

	para "would be able to"
	line "live in peace."

	para "Varaneous and the"
	line "others came from"

	para "around the world"
	line "to build our home"

	para "and protect us"
	line "from outsiders."

	para "#mon and people"
	line "lived in peace"

	para "and harmony for"
	line "centuries until"

	para "a deranged man"
	line "stole their orbs."

	para "The orbs were the"
	line "source of their"
	cont "powers."

	para "Without the orbs,"
	line "the Guardians"

	para "fell into a deep"
	line "sleep."

	para "They continue to"
	line "sleep up to this"
	cont "very day."

	para "With the region"
	line "unprotected,"

	para "people around the"
	line "world moved into"

	para "our region and"
	line "began tearing down"

	para "the nature that"
	line "the Guardians"

	para "created in order"
	line "to build cities"
	cont "and towns."

	para "They bring the"
	line "many stresses"

	para "and complications"
	line "of the modern"
	cont "world over to us."

	para "Many Naljo natives"
	line "welcome outsiders"

	para "with open arms,"
	line "but there are some"

	para "who dedicate their"
	line "lives to seeking"
	cont "out the lost orbs."

	para "If an orb is"
	line "returned to a"

	para "Guardian, it will"
	line "awaken!"

	para "Our Guardian"
	line "will be able to"

	para "preserve our"
	line "culture and"

	para "protect us from"
	line "outsiders once"
	cont "again."
	done

HeathShrineNPCText:
	ctxt "The legends have"
	line "awoken!"

	para "I can't wait to"
	line "be alive while"

	para "experiencing the"
	line "vision of our"
	cont "Guardians!"
	done

HeathHouseWeaver_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $5, 6, HEATH_VILLAGE
	warp_def $9, $6, 6, HEATH_VILLAGE

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 4, 7, SIGNPOST_READ, HeathShrinePodium
	signpost 4, 8, SIGNPOST_READ, HeathShrinePodium

	;people-events
	db 1
	person_event SPRITE_GRAMPS, 3, 2, SPRITEMOVEDATA_WANDER, 3, 3, -1, -1, PAL_OW_RED, 0, 0, HeathShrineNPC1, -1
