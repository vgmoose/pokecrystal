MysteryZoneLeagueLobby_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

MysteryZoneLeagueNurse:
	jumpstd pokecenternurse

MysteryZoneLeagueMerchant:
	faceplayer
	opentext
	pokemart 0, 14
	closetext
	end

MysteryZoneLeagueLobby_MapEventHeader:: db 0, 0

.Warps: db 3
	warp_def 9, 8, 3, MYSTERY_ZONE
	warp_def 9, 9, 3, MYSTERY_ZONE
	warp_def 0, 9, 1, MYSTERY_ZONE_BROWN

.CoordEvents: db 0

.BGEvents: db 0

.ObjectEvents: db 2
	person_event SPRITE_NURSE, 1, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MysteryZoneLeagueNurse, -1
	person_event SPRITE_CLERK, 1, 14, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_OW_RED, 0, 0, MysteryZoneLeagueMerchant, -1
