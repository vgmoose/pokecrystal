Route58_MapScriptHeader;trigger count
	db 0
 ;callback count
	db 0

Route58HiddenItem_1:
	dw EVENT_ROUTE_58_HIDDENITEM_GOLD_TOKEN
	db GOLD_TOKEN

Route58Signpost1:
	ctxt "<UP> Botan City"
	next "<DOWN> Castro Valley"
	done

Route58_MapEventHeader ;filler
	db 0, 0

;warps
	db 4
	warp_def $1, $a, 1, ROUTE_58_GATE
	warp_def $1, $b, 2, ROUTE_58_GATE
	warp_def $7, $a, 3, ROUTE_58_GATE
	warp_def $d, $4, 7, LONG_TUNNEL_PATH

	;xy triggers
	db 0

	;signposts
	db 2
	signpost 31, 9, SIGNPOST_LOAD, Route58Signpost1
	signpost 33, 6, SIGNPOST_ITEM, Route58HiddenItem_1

	;people-events
	db 0
