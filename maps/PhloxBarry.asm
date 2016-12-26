PhloxBarry_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

PhloxBarrySignpost1:
	opentext
	writetext PhloxBarrySignpost1_Text_25602e
	endtext

PhloxBarryNPC1:
	faceplayer
	opentext
	writetext PhloxBarryNPC1_Text_2558b0
	yesorno
	writetext PhloxBarryNPC1_Text_2559b6
	endtext

PhloxBarrySignpost1_Text_25602e:
	ctxt "Guy Finds Another"
	line "Guy in a Cave:"

	para "Today, in the very"
	line "distant town of"

	para "Phlox, a man was"
	line "found inside a"
	cont "cave."

	para "The man suffered"
	line "from amnesia."

	para "The other man told"
	line "us to write this"
	cont "article for him."

	para "Everyone is okay."

	para "The end."
	done

PhloxBarryNPC1_Text_2558b0:
	ctxt "Oh hello there!"

	para "Another dedicated"
	line "fan who's heard of"
	cont "my fantastic tale,"

	para "echoing across the"
	line "entire region of"
	cont "Naljo, I presume."

	para "Well, my weary"
	line "traveler, be weary"

	para "no more because"
	line "you have found me!"

	para "Myles the Great!"

	para "Let me soothe your"
	line "aching muscles a"

	para "bit with the sound"
	line "of my very own"

	para "tale of great"
	line "heroism."
	done

PhloxBarryNPC1_Text_2559b6:
	ctxt "Splendid!"

	para "There I was."

	para "Navigating through"
	line "the Acqua Mines,"

	para "just to the north"
	line "of Phlox Town."

	para "The cave was wet,"
	line "the air was cold,"

	para "but I pressed on,"
	line "fearlessly into"

	para "the darkness of"
	line "the large cave."

	para "Others stay away"
	line "from the Lonely"

	para "Caverns because"
	line "of vile rumors of"

	para "ghosts and murders"
	line "and other curses."

	para "WHAT FOOLS!"

	para "Fools I say!"

	para "Fools to believe"
	line "an exaggerated"

	para "tale happening to"
	line "spread across the"
	cont "Naljo region."

	para "Lo!"

	para "In the distance"
	line "of the darkened"

	para "cave, I heard the"
	line "soft cries of a"

	para "lamb, separated"
	line "from its Shepherd."

	para "Scared, timid,"
	line "all alone<...>"

	para "So I, Myles the"
	line "Great, like a"
	cont "blind Zubat,"

	para "navigated through"
	line "the darkness of"

	para "the cave using"
	line "nothing but my"

	para "hearing until I"
	line "came upon him!"

	para "It was a lost,"
	line "young traveler,"

	para "who most likely"
	line "had been out there"

	para "for months, accor-"
	line "ding to my profes-"
	cont "sional opinion."

	para "The man was laying"
	line "there, in quiet,"
	cont "inside of a ball."

	para "He accepted this<...>"
	line "'call of death' of"
	cont "his, but I cried!"

	para "Ferociously:"

	para "NAY!, and carried"
	line "him out of the"
	cont "cave by myself."

	para "They even wrote an"
	line "article about it"

	para "in the daily news-"
	line "paper, and since"

	para "then my legend has"
	line "been notable, most"
	cont "notable indeed!"

	para "I do feel sorry"
	line "for the young chap"

	para "that I pulled from"
	line "the very jowls of"

	para "death's ravenous"
	line "dogs because it"

	para "appeared that he'd"
	line "been stricken with"
	cont "severe amnesia."

	para "No recollection"
	line "of his life before"

	para "the cave, and no"
	line "family in town."

	para "He still wanders"
	line "those caves from"

	para "time to time to"
	line "try and remember,"

	para "and as his proud"
	line "guardian savior,"

	para "I hope he does."

	para "If it were up to"
	line "me, that poor"

	para "young man would"
	line "have remembered"

	para "every last detail,"
	line "right down to the"

	para "color of his very"
	line "first diaper;"

	para "but alas, as a"
	line "hero, even I have"
	cont "my limitations."

	para "Maybe you could"
	line "talk to him?"

	para "And if you'd like"
	line "to read about it,"

	para "the newspaper art-"
	line "icle that exposed"

	para "the Naljo region"
	line "to my heroism is"

	para "framed against the"
	line "wall behind me."

	para "Do read it before"
	line "you leave, please."
	done

PhloxBarry_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $7, $2, 6, PHLOX_TOWN
	warp_def $7, $3, 6, PHLOX_TOWN

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, PhloxBarrySignpost1

	;people-events
	db 1
	person_event SPRITE_POKEFAN_M, 3, 2, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_RED, 0, 0, PhloxBarryNPC1, -1
