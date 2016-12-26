SoutherlyBattleHouse_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

SoutherlyBattleHouseNPC:
	opentext
	writetext SoutherlyStaminaChallengeIntro
	yesorno
	iffalse .no
	writetext SoutherlyStaminaAccepted
	waitbutton
	closetext
	applymovement 2, .GuardMoveOut
	applymovement 0, .PlayerEnterStamina
	setlasttalked 3
	writebyte 0
	pushvar
	jump .handleLoop

.loop
	pushvar
	applymovement 3, .TrainerWalkOut
	scall .guardHealsParty
.handleLoop
	callasm LoadBattleHouseTrainerData
	applymovement 3, .TrainerWalkIn
	opentext
	trainertext $0
	waitbutton
	closetext
	loadmemtrainer
	startbattle
	reloadmap
	iftrue .loseGame
	opentext
	trainertext $2
	waitbutton
	closetext
	popvar
	addvar 1
	if_less_than 7, .loop
	pause 30
	warpfacing UP, SOUTHERLY_BATTLE_HOUSE, 3, 7
	opentext
	writetext SoutherlyWinText
	verbosegiveitem NUGGET
	endtext

.guardHealsParty:
	applymovement 2, .GuardWalkToHeal
	special HealParty
	special Special_BattleTowerFade
	playwaitsfx SFX_HEAL_POKEMON
	special FadeInPalettes
	applymovement 2, .GuardWalkawayHeal
	end

.loseGame
	pause 30
	warpfacing UP, SOUTHERLY_BATTLE_HOUSE, 3, 7
	special HealParty
	jumptext SoutherlyLoseText

.no
	jumptext SoutherlyStaminaDeclined

.GuardWalkawayHeal:
	step_left
	step_left
	step_left
	step_left
	turn_head_right
	step_end

.GuardWalkToHeal:
	step_right
	step_right
	step_right
	step_right
	turn_head_up
	step_end

.TrainerWalkOut
	step_right
	step_right
	step_right
	step_up
	step_end

.TrainerWalkIn
	step_down
	step_left
	step_left
	step_left
	step_end

.GuardMoveOut:
	step_up
	step_up
	turn_head_right
	step_end

.PlayerEnterStamina:
	step_up
	step_up
	step_right
	step_right
	step_right
	step_right
	step_up
	step_up
	turn_head_right
	step_end

SoutherlyStaminaChallengeIntro:
	ctxt "Welcome to the"
	line "Stamina Challenge!"

	para "You will face 7"
	line "tough Trainers"
	cont "in a row."

	para "If you make it all"
	line "the way to the"

	para "end, you'll get a"
	line "special prize!"

	para "Want to give it a"
	line "shot?"
	done

SoutherlyStaminaAccepted:
	ctxt "Good, come on in!"
	done

SoutherlyWinText:
	ctxt "You won!"

	para "Here is your"
	line "prize!"
	prompt

SoutherlyLoseText:
	ctxt "That's a shame."

	para "Try again some"
	line "other time!"
	done

SoutherlyStaminaDeclined:
	ctxt "That's fine, come"
	line "again!"
	done

LoadBattleHouseTrainerData:
	ld a, [hScriptVar]
	ld bc, SoutherlyBattleHouse_TrainerDataEnd - SoutherlyBattleHouse_TrainerData
	ld hl, SoutherlyBattleHouse_TrainerData
	rst AddNTimes
	ld a, [hli]
	ld [Map2ObjectSprite], a
	ld [UsedSprites + $4], a
	ld [hUsedSpriteIndex], a
	ld a, [hli]
	ld [Map2ObjectColor], a
	ld a, [UsedSprites + $5]
	ld [hUsedSpriteTile], a
	ld de, wTempTrainerClass
	ld bc, 8
	rst CopyBytes
	ld a, [ScriptBank]
	ld [wTempTrainerBank], a
	jpba GetUsedSprite

battlehousetrainer: macro
	db SPRITE_\1, PAL_OW_\2 ; sprite, color
	db \3, \4 ; class, id
	dw \5, \6, \7 ; text before, win, after
	endm

SoutherlyBattleHouse_TrainerData:
	battlehousetrainer BEAUTY,    GREEN, BEAUTY,        6, StaminaTrainer1EncounterText, StaminaTrainer1DefeatedText, StaminaTrainer1AfterText
SoutherlyBattleHouse_TrainerDataEnd:
	battlehousetrainer SUPER_NERD, BLUE,  SUPER_NERD,   10, StaminaTrainer2EncounterText, StaminaTrainer2DefeatedText, StaminaTrainer2AfterText
	battlehousetrainer YOUNGSTER,  BLUE,  YOUNGSTER,     6, StaminaTrainer3EncounterText, StaminaTrainer3DefeatedText, StaminaTrainer3AfterText
	battlehousetrainer PSYCHIC, BLUE,  PSYCHIC_T,     7, StaminaTrainer4EncounterText, StaminaTrainer4DefeatedText, StaminaTrainer4AfterText
	battlehousetrainer COOLTRAINER_M,  RED,   COOLTRAINERM, 13, StaminaTrainer5EncounterText, StaminaTrainer5DefeatedText, StaminaTrainer5AfterText
	battlehousetrainer FIREBREATHER, BLUE,  FIREBREATHER, 10, StaminaTrainer6EncounterText, StaminaTrainer6DefeatedText, StaminaTrainer6AfterText
	battlehousetrainer COOLTRAINER_M,  RED,   COOLTRAINERM, 14, StaminaTrainer7EncounterText, StaminaTrainer7DefeatedText, StaminaTrainer7AfterText

StaminaTrainer1EncounterText:
	ctxt "I'm trying to let"
	line "my #mon use a"

	para "new move that I"
	line "discovered!"
	done

StaminaTrainer1DefeatedText:
	ctxt "Steel Eater is"
	line "awesome, but you"
	cont "are better!"
	done

StaminaTrainer1AfterText:
	ctxt "Some day I'll find"
	line "even more moves!"
	done

StaminaTrainer2EncounterText:
	ctxt "The star of my"
	line "team is Weavile!"
	done

StaminaTrainer2DefeatedText:
	ctxt "It didn't save me!"
	done

StaminaTrainer2AfterText:
	ctxt "We'll show you"
	line "boss next time!"
	done

StaminaTrainer3EncounterText:
	ctxt "Hmmm? Do I know"
	line "you?"
	done

StaminaTrainer3DefeatedText:
	ctxt "Who are you?"
	done

StaminaTrainer3AfterText:
	ctxt "Really?"

	para "You're Lance's kid?"
	done

StaminaTrainer4EncounterText:
	ctxt "I've been waiting"
	line "for this!"
	done

StaminaTrainer4DefeatedText:
	ctxt "It was worth the"
	line "wait!"
	done

StaminaTrainer4AfterText:
	ctxt "Thank you for not"
	line "giving up!"
	done

StaminaTrainer5EncounterText:
	ctxt "Oh hello."

	para "Let me battle you"
	line "real quick."

	para "It's not like you"
	line "have something"

	para "important to do or"
	line "anything."
	done

StaminaTrainer5DefeatedText:
	ctxt "Oh. Well, I'm not"
	line "impressed."
	done

StaminaTrainer5AfterText:
	ctxt "You certainly must"
	line "have a lot of free"

	para "time to come by"
	line "here."

	para "Go save the world"
	line "or something."
	done

StaminaTrainer6EncounterText:
	ctxt "BURN, BABY, BURN!"

	para "<...> <...> <...>"
	line "<...> <...> <...>"

	para "If I say any more,"
	line "I risk copyright"
	cont "infringement!"
	done

StaminaTrainer6DefeatedText:
	ctxt "Agh! Disco and"
	line "fire don't mix!"
	done

StaminaTrainer6AfterText:
	ctxt "Remember kids,"
	line "breathe fire"
	cont "responsibly!"
	done

StaminaTrainer7EncounterText:
	ctxt "I'm bored."

	para "Let's have a"
	line "battle!"
	done

StaminaTrainer7DefeatedText:
	ctxt "<...>and now I'm bored"
	line "again."
	done

StaminaTrainer7AfterText:
	ctxt "<...>so bored."
	done

SoutherlyBattleHouse_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $9, $6, 3, SOUTHERLY_CITY
	warp_def $9, $7, 3, SOUTHERLY_CITY

	;xy triggers
	db 0

	;signposts
	db 0

	;people-events
	db 2
	person_event SPRITE_OFFICER, 6, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_GREEN, 0, 0, SoutherlyBattleHouseNPC, -1
	person_event SPRITE_TEACHER, 2, 13, SPRITEMOVEDATA_00, 0, 0, -1, -1, PAL_OW_BLUE, 0, 0, ObjectEvent, -1