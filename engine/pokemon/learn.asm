LearnMove:
	call LoadTilemapToTempTilemap
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNick
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, MON_NAME_LENGTH
	call CopyBytes

.loop
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld b, NUM_MOVES
; Get the first empty move slot.  This routine also serves to
; determine whether the Pokemon learning the moves already has
; all four slots occupied, in which case one would need to be
; deleted.
.next
	ld a, [hl]
	and a
	jr z, .learn
	inc hl
	dec b
	jr nz, .next
; If we're here, we enter the routine for forgetting a move
; to make room for the new move we're trying to learn.
	push de
	call ForgetMove
	pop de
	jp c, .cancel

	push hl
	push de
	ld [wNamedObjectIndexBuffer], a

	ld b, a
	ld a, [wBattleMode]
	and a
	jr z, .not_disabled
	ld a, [wDisabledMove]
	cp b
	jr nz, .not_disabled
	xor a
	ld [wDisabledMove], a
	ld [wPlayerDisableCount], a
.not_disabled

	call GetMoveName
	ld hl, Text_1_2_and_Poof ; 1, 2 and…
	call PrintText
	pop de
	pop hl

.learn
	ld a, [wPutativeTMHMMove]
	ld [hl], a
	ld bc, MON_PP - MON_MOVES
	add hl, bc

	push hl
	push de
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop de
	pop hl

	ld [hl], a

	ld a, [wBattleMode]
	and a
	jp z, .learned

	ld a, [wCurPartyMon]
	ld b, a
	ld a, [wCurBattleMon]
	cp b
	jp nz, .learned

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jp nz, .learned

	ld h, d
	ld l, e
	ld de, wBattleMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	ld bc, wPartyMon1PP - (wPartyMon1Moves + NUM_MOVES)
	add hl, bc
	ld de, wBattleMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	jp .learned

.cancel
	ld hl, StopLearningMoveText
	call PrintText
	call YesNoBox
	jp c, .loop

	ld hl, DidNotLearnMoveText
	call PrintText
	ld b, 0
	ret

.learned
	ld hl, LearnedMoveText
	call PrintText
	ld b, 1
	ret

ForgetMove:
	push hl
	ld hl, AskForgetMoveText
	call PrintText
	call YesNoBox
	pop hl
	ret c
	ld bc, -NUM_MOVES
	add hl, bc
	push hl
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	call CopyBytes
	pop hl
.loop
	push hl
	ld hl, MoveAskForgetText
	call PrintText
	hlcoord 5, 2
	ld b, NUM_MOVES * 2
	ld c, MOVE_NAME_LENGTH
	call Textbox
	hlcoord 5 + 2, 2 + 2
	ld a, SCREEN_WIDTH * 2
	ld [wBuffer1], a
	predef ListMoves
	; w2DMenuData
	ld a, $4
	ld [w2DMenuCursorInitY], a
	ld a, $6
	ld [w2DMenuCursorInitX], a
	ld a, [wNumMoves]
	inc a
	ld [w2DMenuNumRows], a
	ld a, $1
	ld [w2DMenuNumCols], a
	ld [wMenuCursorY], a
	ld [wMenuCursorX], a
	ld a, $3
	ld [wMenuJoypadFilter], a
	ld a, $20
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $20
	ld [w2DMenuCursorOffsets], a
	call StaticMenuJoypad
	push af
	call SafeLoadTempTilemapToTilemap
	pop af
	pop hl
	bit 1, a
	jr nz, .cancel
	push hl
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	push af
	push bc
	call IsHMMove
	pop bc
	pop de
	ld a, d
	jr c, .hmmove
	pop hl
	add hl, bc
	and a
	ret

.hmmove
	ld hl, MoveCantForgetHMText
	call PrintText
	pop hl
	jr .loop

.cancel
	scf
	ret

LearnedMoveText:
IF !DEF(_CRYSTAL_JP)
	text_far _LearnedMoveText
	text_end
ELSE
	text_from_ram wMonOrItemNameBuffer
	db $0, "は あたらしく", $4f
	db "@"
	text_from_ram wStringBuffer2
	db $0, "を おぼえた!@"
	sound_dex_fanfare_50_79
	text_promptbutton
	db "@"
ENDC

MoveAskForgetText:
IF !DEF(_CRYSTAL_JP)
	text_far _MoveAskForgetText
	text_end
ELSE
	db $0, "どの わざを", $4e, "わすれさせたい?", $57
ENDC

StopLearningMoveText:
IF !DEF(_CRYSTAL_JP)
	text_far _StopLearningMoveText
	text_end
ELSE
	db $0, "それでは", $56, " @"
	text_from_ram $d066
	db $0, "を", $4f
	db "おぼえるのを あきらめますか?", $57
ENDC

DidNotLearnMoveText:
IF !DEF(_CRYSTAL_JP)
	text_far _DidNotLearnMoveText
	text_end
ELSE
	text_from_ram $d046
	db $0, "は @"
	text_from_ram $d066
	db $0, "を", $4f
	db "おぼえずに おわった!", $58
ENDC

AskForgetMoveText:
IF !DEF(_CRYSTAL_JP)
	text_far _AskForgetMoveText
	text_end
ELSE
	text_from_ram $d046
	db $0, "は あたらしく", $4f
	db "@"
	text_from_ram $d066
	db $0, "を おぼえたい", $56, "!", $51
	db "しかし @"
	text_from_ram $d046
	db $0, "は わざを 4つ", $4f
	db "おぼえるので せいいっぱいだ!", $51
	db "@"
	text_from_ram $d066
	db $0, "の かわりに", $4f
	db "ほかの わざを わすれさせますか?", $57
ENDC

Text_1_2_and_Poof:
IF !DEF(_CRYSTAL_JP)
	text_far Text_MoveForgetCount ; 1, 2 and…
ELSE
	db $0, "1 2の ", $56, "@"
	text_pause
ENDC
	text_asm
	push de
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	pop de
	ld hl, .MoveForgotText
	ret

.MoveForgotText:
IF !DEF(_CRYSTAL_JP)
	text_far _MoveForgotText
	text_end
ELSE
	db $0, " ポカン!@"
	text_pause
	db $0, $51
	db "@"
	text_from_ram $d046
	db $0, "は @"
	text_from_ram $d05b
	db $0, "の", $4f
	db "つかいかたを きれいに わすれた!", $51
	db "そして", $56, "!", $58
ENDC

MoveCantForgetHMText:
IF !DEF(_CRYSTAL_JP)
	text_far _MoveCantForgetHMText
	text_end
ELSE
	db $0, "それは たいせつなわざです", $4f
	db "わすれさせることは できません!", $58
ENDC
