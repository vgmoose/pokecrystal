Route61GateSouth_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route61GateSouthNPC1:
	faceplayer
	opentext
	writetext Route61GateSouthNPC1_Text_330ecc
	endtext

Route61GateSouthNPC1_Text_330ecc:
	ctxt "Wild #mon"
	line "still roam the"
	cont "Power Plant!"

	para "Convenient, am I"
	line "right or am I"
	cont "right?"
	done

Route61GateSouth_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 9, 4, 2, ROUTE_61
	warp_def 9, 5, 2, ROUTE_61
	warp_def 0, 5, 3, ROUTE_60

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 1
	person_event SPRITE_OFFICER, 3, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_OW_BROWN, 0, 0, Route61GateSouthNPC1, -1
