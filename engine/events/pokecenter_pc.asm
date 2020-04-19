PokemonCenterPC:
	call PC_CheckPartyForPokemon
	ret c
	call PC_PlayBootSound
	ld hl, PokecenterPCTurnOnText
	call PC_DisplayText
	ld hl, PokecenterPCWhoseText
	call PC_DisplayTextWaitMenu
	ld hl, .TopMenu
	call LoadMenuHeader
.loop
	xor a
	ldh [hBGMapMode], a
	call .ChooseWhichPCListToUse
	ld [wWhichIndexSet], a
	call DoNthMenu
	jr c, .shutdown
	ld a, [wMenuSelection]
	ld hl, .JumpTable
	call MenuJumptable
	jr nc, .loop

.shutdown
	call PC_PlayShutdownSound
	call ExitMenu
	call CloseWindow
	ret

.TopMenu:
	db MENU_BACKUP_TILES | MENU_NO_CLICK_SFX ; flags
	menu_coords 0, 0, 15, 12
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP ; flags
	db 0 ; items
	dw .WhichPC
	dw PlaceNthMenuStrings
	dw .JumpTable

PCPC_PLAYERS_PC   EQU 0
PCPC_BILLS_PC     EQU 1
PCPC_OAKS_PC      EQU 2
PCPC_HALL_OF_FAME EQU 3
PCPC_TURN_OFF     EQU 4

.JumpTable:
; entries correspond to PCPC_* constants
	dw PlayersPC,    .String_PlayersPC
	dw BillsPC,      .String_BillsPC
	dw OaksPC,       .String_OaksPC
	dw HallOfFamePC, .String_HallOfFame
	dw TurnOffPC,    .String_TurnOff

IF !DEF(_CRYSTAL_JP)
.String_PlayersPC:  db "<PLAYER>'s PC@"
.String_BillsPC:    db "BILL's PC@"
.String_OaksPC:     db "PROF.OAK's PC@"
.String_HallOfFame: db "HALL OF FAME@"
.String_TurnOff:    db "TURN OFF@"
ELSE
.String_PlayersPC:  db "<PLAYER>の <PC>@"
.String_BillsPC:    db "マサキの <PC>@"
.String_OaksPC:     db "ォーキドの <PC>@"
.String_HallOfFame: db "でんどういり@"
.String_TurnOff:    db "スイッチを きる@"
ENDC

.WhichPC:
	; before Pokédex
	db 3
	db PCPC_BILLS_PC
	db PCPC_PLAYERS_PC
	db PCPC_TURN_OFF
	db -1 ; end

	; before Hall Of Fame
	db 4
	db PCPC_BILLS_PC
	db PCPC_PLAYERS_PC
	db PCPC_OAKS_PC
	db PCPC_TURN_OFF
	db -1 ; end

	; postgame
	db 5
	db PCPC_BILLS_PC
	db PCPC_PLAYERS_PC
	db PCPC_OAKS_PC
	db PCPC_HALL_OF_FAME
	db PCPC_TURN_OFF
	db -1 ; end

.ChooseWhichPCListToUse:
	call CheckReceivedDex
	jr nz, .got_dex
	ld a, 0 ; before Pokédex
	ret

.got_dex
	ld a, [wHallOfFameCount]
	and a
	ld a, 1 ; before Hall Of Fame
	ret z
	ld a, 2 ; postgame
	ret

PC_CheckPartyForPokemon:
	ld a, [wPartyCount]
	and a
	ret nz
	ld de, SFX_CHOOSE_PC_OPTION
	call PlaySFX
	ld hl, .PokecenterPCCantUseText
	call PC_DisplayText
	scf
	ret

.PokecenterPCCantUseText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterPCCantUseText
	text_end
ELSE
	db $0, "ピーッ!", $4f
	db "#を もっていない", $55
	db "ひとは つかうことが できません!", $58
ENDC

BillsPC:
	call PC_PlayChoosePCSound
	ld hl, PokecenterBillsPCText
	call PC_DisplayText
	farcall _BillsPC
	and a
	ret

PlayersPC:
	call PC_PlayChoosePCSound
	ld hl, PokecenterPlayersPCText
	call PC_DisplayText
	ld b, $0
	call _PlayersPC
	and a
	ret

OaksPC:
	call PC_PlayChoosePCSound
	ld hl, PokecenterOaksPCText
	call PC_DisplayText
	farcall ProfOaksPC
	and a
	ret

HallOfFamePC:
	call PC_PlayChoosePCSound
	call FadeToMenu
	farcall _HallOfFamePC
	call CloseSubmenu
	and a
	ret

TurnOffPC:
	ld hl, PokecenterPCOaksClosedText
	call PrintText
	scf
	ret

PC_PlayBootSound:
	ld de, SFX_BOOT_PC
	jr PC_WaitPlaySFX

PC_PlayShutdownSound:
	ld de, SFX_SHUT_DOWN_PC
	call PC_WaitPlaySFX
	call WaitSFX
	ret

PC_PlayChoosePCSound:
	ld de, SFX_CHOOSE_PC_OPTION
	jr PC_WaitPlaySFX

PC_PlaySwapItemsSound:
	ld de, SFX_SWITCH_POKEMON
	call PC_WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON

PC_WaitPlaySFX:
	push de
	call WaitSFX
	pop de
	call PlaySFX
	ret

_PlayersHousePC:
	call PC_PlayBootSound
	ld hl, PlayersPCTurnOnText
	call PC_DisplayText
	ld b, $1
	call _PlayersPC
	and a
	jr nz, .asm_156f9
	call OverworldTextModeSwitch
	call ApplyTilemap
	call UpdateSprites
	call PC_PlayShutdownSound
	ld c, $0
	ret

.asm_156f9
	call ClearBGPalettes
	ld c, $1
	ret

PlayersPCTurnOnText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCTurnOnText
	text_end
ELSE
	db $0, $52, "は", $4f
	db $5b, "の スイッチを いれた!", $58
ENDC

_PlayersPC:
	ld a, b
	ld [wWhichIndexSet], a
	ld hl, PlayersPCAskWhatDoText
	call PC_DisplayTextWaitMenu
	call Function15715
	call ExitMenu
	ret

Function15715:
	xor a
	ld [wPCItemsCursor], a
	ld [wPCItemsScrollPosition], a
	ld hl, PlayersPCMenuData
	call LoadMenuHeader
.asm_15722
	call UpdateTimePals
	call DoNthMenu
	jr c, .asm_15731
	call MenuJumptable
	jr nc, .asm_15722
	jr .asm_15732

.asm_15731
	xor a

.asm_15732
	call ExitMenu
	ret

PlayersPCMenuData:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 15, 12
	dw .PlayersPCMenuData
	db 1 ; default selected option

.PlayersPCMenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP ; flags
	db 0 ; # items?
	dw .PlayersPCMenuList1
	dw PlaceNthMenuStrings
	dw .PlayersPCMenuPointers

PLAYERSPC_WITHDRAW_ITEM EQU 0
PLAYERSPC_DEPOSIT_ITEM  EQU 1
PLAYERSPC_TOSS_ITEM     EQU 2
PLAYERSPC_MAIL_BOX      EQU 3
PLAYERSPC_DECORATION    EQU 4
PLAYERSPC_TURN_OFF      EQU 5
PLAYERSPC_LOG_OFF       EQU 6

.PlayersPCMenuPointers:
; entries correspond to PLAYERSPC_* constants
	dw PlayerWithdrawItemMenu, .WithdrawItem
	dw PlayerDepositItemMenu,  .DepositItem
	dw PlayerTossItemMenu,     .TossItem
	dw PlayerMailBoxMenu,      .MailBox
	dw PlayerDecorationMenu,   .Decoration
	dw PlayerLogOffMenu,       .LogOff
	dw PlayerLogOffMenu,       .TurnOff

IF !DEF(_CRYSTAL_JP)
.WithdrawItem: db "WITHDRAW ITEM@"
.DepositItem:  db "DEPOSIT ITEM@"
.TossItem:     db "TOSS ITEM@"
.MailBox:      db "MAIL BOX@"
.Decoration:   db "DECORATION@"
.TurnOff:      db "TURN OFF@"
.LogOff:       db "LOG OFF@"
ELSE
.WithdrawItem: db "どうぐを ひきだす@"
.DepositItem:  db "どうぐを あずける@"
.TossItem:     db "どうぐを すてる@"
.MailBox:      db "メールボックス@"
.Decoration:   db "もようがえ@"
.TurnOff:      db "スイッチを きる@"
.LogOff:       db "せつぞくをきる@"
ENDC

.PlayersPCMenuList1:
	db 5
	db PLAYERSPC_WITHDRAW_ITEM
	db PLAYERSPC_DEPOSIT_ITEM
	db PLAYERSPC_TOSS_ITEM
	db PLAYERSPC_MAIL_BOX
	db PLAYERSPC_TURN_OFF
	db -1 ; end

.PlayersPCMenuList2:
	db 6
	db PLAYERSPC_WITHDRAW_ITEM
	db PLAYERSPC_DEPOSIT_ITEM
	db PLAYERSPC_TOSS_ITEM
	db PLAYERSPC_MAIL_BOX
	db PLAYERSPC_DECORATION
	db PLAYERSPC_LOG_OFF
	db -1 ; end

PC_DisplayTextWaitMenu:
	ld a, [wOptions]
	push af
	set NO_TEXT_SCROLL, a
	ld [wOptions], a
	call MenuTextbox
	pop af
	ld [wOptions], a
	ret

PlayersPCAskWhatDoText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCAskWhatDoText
	text_end
ELSE
	db $0, "なにを しますか?", $57
ENDC

PlayerWithdrawItemMenu:
	call LoadStandardMenuHeader
	farcall ClearPCItemScreen
.loop
	call PCItemsJoypad
	jr c, .quit
	call .Submenu
	jr .loop

.quit
	call CloseSubmenu
	xor a
	ret

.Submenu:
	; check if the item has a quantity
	farcall _CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr z, .askquantity

	; items without quantity are always ×1
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	jr .withdraw

.askquantity
	ld hl, .PlayersPCHowManyWithdrawText
	call MenuTextbox
	farcall SelectQuantityToToss
	call ExitMenu
	call ExitMenu
	jr c, .done

.withdraw
	ld a, [wItemQuantityChangeBuffer]
	ld [wBuffer1], a ; quantity
	ld a, [wCurItemQuantity]
	ld [wBuffer2], a
	ld hl, wNumItems
	call ReceiveItem
	jr nc, .PackFull
	ld a, [wBuffer1]
	ld [wItemQuantityChangeBuffer], a
	ld a, [wBuffer2]
	ld [wCurItemQuantity], a
	ld hl, wNumPCItems
	call TossItem
	predef PartyMonItemName
	ld hl, .PlayersPCWithdrewItemsText
	call MenuTextbox
	xor a
	ldh [hBGMapMode], a
	call ExitMenu
	ret

.PackFull:
	ld hl, .PlayersPCNoRoomWithdrawText
	call MenuTextboxBackup
	ret

.done
	ret

.PlayersPCHowManyWithdrawText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCHowManyWithdrawText
	text_end
ELSE
	db $0, "いくつ ひきだしますか?", $57
ENDC

.PlayersPCWithdrewItemsText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCWithdrewItemsText
	text_end
ELSE
	text_from_ram $d066
	db $0, "を @"

	deciram $d0cc, 1, 2
	db $0, "こ ", $4f
	db "ひきだしました", $58

ENDC

.PlayersPCNoRoomWithdrawText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCNoRoomWithdrawText
	text_end
ELSE
	db $0, "もちものが いっぱいなので", $4f
	db "ひきだせません!", $58
ENDC

PlayerTossItemMenu:
	call LoadStandardMenuHeader
	farcall ClearPCItemScreen
.loop
	call PCItemsJoypad
	jr c, .quit
	ld de, wNumPCItems
	farcall TossItemFromPC
	jr .loop

.quit
	call CloseSubmenu
	xor a
	ret

PlayerDecorationMenu:
	farcall _PlayerDecorationMenu
	ld a, c
	and a
	ret z
	scf
	ret

PlayerLogOffMenu:
	xor a
	scf
	ret

PlayerDepositItemMenu:
	call .CheckItemsInBag
	jr c, .nope
	call DisableSpriteUpdates
	call LoadStandardMenuHeader
	farcall DepositSellInitPackBuffers
.loop
	farcall DepositSellPack
	ld a, [wPackUsedItem]
	and a
	jr z, .close
	call .TryDepositItem
	farcall CheckRegisteredItem
	jr .loop

.close
	call CloseSubmenu

.nope
	xor a
	ret

.CheckItemsInBag:
	farcall HasNoItems
	ret nc
	ld hl, .PlayersPCNoItemsText
	call MenuTextboxBackup
	scf
	ret

.PlayersPCNoItemsText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCNoItemsText
	text_end
ELSE
	db $0, "どうぐを ひとつも", $4f
	db "もっていない!", $58
ENDC

.TryDepositItem:
	ld a, [wSpriteUpdatesEnabled]
	push af
	ld a, $0
	ld [wSpriteUpdatesEnabled], a
	farcall CheckItemMenu
	ld a, [wItemAttributeParamBuffer]
	ld hl, .dw
	rst JumpTable
	pop af
	ld [wSpriteUpdatesEnabled], a
	ret

.dw
; entries correspond to ITEMMENU_* constants
	dw .tossable ; ITEMMENU_NOUSE
	dw .no_toss
	dw .no_toss
	dw .no_toss
	dw .tossable ; ITEMMENU_CURRENT
	dw .tossable ; ITEMMENU_PARTY
	dw .tossable ; ITEMMENU_CLOSE

.no_toss
	ret

.tossable
	ld a, [wBuffer1]
	push af
	ld a, [wBuffer2]
	push af
	call .DepositItem
	pop af
	ld [wBuffer2], a
	pop af
	ld [wBuffer1], a
	ret

.DepositItem:
	farcall _CheckTossableItem
	ld a, [wItemAttributeParamBuffer]
	and a
	jr z, .AskQuantity
	ld a, $1
	ld [wItemQuantityChangeBuffer], a
	jr .ContinueDeposit

.AskQuantity:
	ld hl, .PlayersPCHowManyDepositText
	call MenuTextbox
	farcall SelectQuantityToToss
	push af
	call ExitMenu
	call ExitMenu
	pop af
	jr c, .DeclinedToDeposit

.ContinueDeposit:
	ld a, [wItemQuantityChangeBuffer]
	ld [wBuffer1], a
	ld a, [wCurItemQuantity]
	ld [wBuffer2], a
	ld hl, wNumPCItems
	call ReceiveItem
	jr nc, .NoRoomInPC
	ld a, [wBuffer1]
	ld [wItemQuantityChangeBuffer], a
	ld a, [wBuffer2]
	ld [wCurItemQuantity], a
	ld hl, wNumItems
	call TossItem
	predef PartyMonItemName
	ld hl, .PlayersPCDepositItemsText
	call PrintText
	ret

.NoRoomInPC:
	ld hl, .PlayersPCNoRoomDepositText
	call PrintText
	ret

.DeclinedToDeposit:
	and a
	ret

.PlayersPCHowManyDepositText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCHowManyDepositText
	text_end
ELSE
	db $0, "いくつ あずけますか?", $57
ENDC

.PlayersPCDepositItemsText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCDepositItemsText
	text_end
ELSE
	text_from_ram $d066
	db $0, "を @"
	deciram $d0cc, 1, 2
	db $0, "こ ", $4f
	db "あずけました", $58
ENDC

.PlayersPCNoRoomDepositText:
IF !DEF(_CRYSTAL_JP)
	text_far _PlayersPCNoRoomDepositText
	text_end
ELSE
	db $0, "どうぐが いっぱいです", $4f
	db "もう あずけられません!", $58
ENDC

PlayerMailBoxMenu:
	farcall _PlayerMailBoxMenu
	xor a
	ret

PCItemsJoypad:
	xor a
	ld [wSwitchItem], a
.loop
	ld a, [wSpriteUpdatesEnabled]
	push af
	ld a, $0
	ld [wSpriteUpdatesEnabled], a
	ld hl, .PCItemsMenuData
	call CopyMenuHeader
	hlcoord 0, 0
	ld b, 10
	ld c, 18
	call Textbox
	ld a, [wPCItemsCursor]
	ld [wMenuCursorBuffer], a
	ld a, [wPCItemsScrollPosition]
	ld [wMenuScrollPosition], a
	call ScrollingMenu
	ld a, [wMenuScrollPosition]
	ld [wPCItemsScrollPosition], a
	ld a, [wMenuCursorY]
	ld [wPCItemsCursor], a
	pop af
	ld [wSpriteUpdatesEnabled], a
	ld a, [wSwitchItem]
	and a
	jr nz, .moving_stuff_around
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b_1
	cp A_BUTTON
	jr z, .a_1
	cp SELECT
	jr z, .select_1
	jr .next

.moving_stuff_around
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .b_2
	cp A_BUTTON
	jr z, .a_select_2
	cp SELECT
	jr z, .a_select_2
	jr .next

.b_2
	xor a
	ld [wSwitchItem], a
	jr .next

.a_select_2
	call PC_PlaySwapItemsSound
.select_1
	farcall SwitchItemsInBag
.next
	jp .loop

.a_1
	farcall ScrollingMenu_ClearLeftColumn
	call PlaceHollowCursor
	and a
	ret

.b_1
	scf
	ret

.PCItemsMenuData:
	db MENU_BACKUP_TILES ; flags
	menu_coords 4, 1, 18, 10
	dw .MenuData
	db 1 ; default option

.MenuData:
	db SCROLLINGMENU_ENABLE_SELECT | SCROLLINGMENU_ENABLE_FUNCTION3 | SCROLLINGMENU_DISPLAY_ARROWS ; flags
	db 4, 8 ; rows, columns
	db SCROLLINGMENU_ITEMS_QUANTITY ; item format
	dbw 0, wNumPCItems
	dba PlaceMenuItemName
	dba PlaceMenuItemQuantity
	dba UpdateItemDescription

PC_DisplayText:
	call MenuTextbox
	call ExitMenu
	ret

PokecenterPCTurnOnText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterPCTurnOnText
	text_end
ELSE
	db $0, $52, "は", $4f
	db $5b, "の スイッチを いれた!", $58
ENDC

PokecenterPCWhoseText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterPCWhoseText
	text_end
ELSE
	db $0, "どこの ", $5b, "と つないで", $4f
	db "つうしん しますか?", $57
ENDC

PokecenterBillsPCText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterBillsPCText
	text_end
ELSE
	db $0, "マサキの ", $5b, "と つないだ!", $51
	db "#の あずかり システムを ", $4f
	db "よびだした!", $58
ENDC

PokecenterPlayersPCText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterPlayersPCText
	text_end
ELSE
	db $0, "じぶんの ", $5b, "と つないだ!", $51
	db "どうぐの あずかり システムを", $4f
	db "よびだした!", $58
ENDC

PokecenterOaksPCText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterOaksPCText
	text_end
ELSE
	db $0, "ォーキドの ", $5b, "と つないだ!", $51
	db "# ずかん", $4f
	db "ひょうか システムを よびだした!", $58
ENDC

PokecenterPCOaksClosedText:
IF !DEF(_CRYSTAL_JP)
	text_far _PokecenterPCOaksClosedText
	text_end
ELSE
	db $0, $56, " ", $56, " ", $56, $4f
	db $56, " ", $56, " つうしん しゅうりょう!", $57
ENDC
