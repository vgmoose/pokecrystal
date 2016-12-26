HaywardMartElevator_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

HaywardMartElevatorSignpost1:
	opentext
	elevator HaywardMartElevatorHeader
	closetext
	iffalse HaywardMartElevator_1789d9
	pause 5
	playsound SFX_ELEVATOR
	earthquake 60
	waitsfx
	end

HaywardMartElevator_1789d9:
	end

HaywardMartElevatorHeader:
	db 6 ; floors
	elevfloor _1F, 4, HAYWARD_MART_F1
	elevfloor _2F, 3, HAYWARD_MART_F2
	elevfloor _3F, 3, HAYWARD_MART_F3
	elevfloor _4F, 3, HAYWARD_MART_F4
	elevfloor _5F, 3, HAYWARD_MART_F5
	elevfloor _6F, 2, HAYWARD_MART_F6
	db -1

HaywardMartElevator_MapEventHeader ;filler
	db 0, 0

;warps
	db 2
	warp_def $3, $1, 255, ROUTE_77_DAYCARE_GARDEN
	warp_def $3, $2, 255, ROUTE_77_DAYCARE_GARDEN

	;xy triggers
	db 0

	;signposts
	db 1
	signpost 0, 3, SIGNPOST_READ, HaywardMartElevatorSignpost1

	;people-events
	db 0
