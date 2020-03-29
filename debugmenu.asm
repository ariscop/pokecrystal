DebugMenu::
	farcall EnableScriptMode
	ld a, BANK(NewsDebugScript)
	ld [wScriptBank], a
	ld a, LOW(NewsDebugScript)
	ld [wScriptPos], a
	ld a, HIGH(NewsDebugScript)
	ld [wScriptPos + 1], a
	ret

NewsDebugScript:
	opentext
	writetext .opentext
	yesorno
	iffalse .endmenu
	loadmenu .NewsTestMenu
	verticalmenu
	closewindow
	ifequal 1, .one
	ifequal 2, .two
	ifequal 3, .three
	sjump .endmenu

.NewsTestMenu
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 2, 15, TEXTBOX_Y - 1
	dw .NewsTestMenu_Entries
	db 1 ; default option

.NewsTestMenu_Entries
	db STATICMENU_CURSOR ; flags
	db 4 ; items
	db "One@"
	db "Two@"
	db "Three@"
	db "Exit@"

.opentext
	text "Load Test News?"
	done

.one
	callasm Unreferenced_Function1f4003
	sjump .success
.two
	callasm Unreferenced_Function1f4dbe
	sjump .success
.three
	callasm Function1f5d9f
.success
	waitsfx
	playsound SFX_SAVE
.endmenu
	closetext
	end
