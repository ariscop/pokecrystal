	object_const_def ; object_event constants
	const GOLDENRODPOKECENTER1F_NURSE
	const GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST

GoldenrodPokecenter1F_MapScripts:
	db 2
	scene_script script671d
	scene_script script671d

	db 1
	callback MAPCALLBACK_OBJECTS, script6735

script671d:
	setval $10
	special BattleTowerAction
	iffalse .script6729
	prioritysjump script686f
	end
.script6729
	setval $0e
	special BattleTowerAction
	iffalse .script6734
	prioritysjump script68b5
.script6734
	end

script6735:
	special Mobile_DummyReturnFalse
	iftrue .script6750
	moveobject $05, $10, $09
	moveobject $0A, $00, $07
	moveobject $04, $08, $0D
	moveobject $07, $1b, $0D
	moveobject $08, $15, $06
	return
.script6750
	setevent EVENT_33F
	return

GoldenrodPokecenter1FNurseScript:
	setevent EVENT_WELCOMED_TO_POKECOM_CENTER
	jumpstd pokecenternurse

GoldenrodPokecenter1FLinkReceptionistScript
	special SetBitsForLinkTradeRequest
	opentext
	writetext UnknownText_0x61072 ; 6a2d
	promptbutton
	checkitem EGG_TICKET
	iftrue script687c
	special Function11b879
	ifequal $01, .script67f6
	ifequal $02, .script6869
	readvar $01
	ifequal $01, .script67cf
	writetext UnknownText_0x610ce ; 6a72
	yesorno
	iffalse .script67d5
	writetext UnknownText_0x616fb ; 6e75
	yesorno
	iffalse .script67d5
	;special TryQuickSave
	iffalse .script67d5
	writetext UnknownText_0x61727 ; 6e8f
	waitbutton
	special BillsGrandfather
	ifequal $00, .script67d5
	ifequal $fd, .script67ea
	ifgreater $fb, .script67f0
	special Function11ba38
	ifnotequal $00, .script67e4
	writetext UnknownText_0x61111 ; 6a9e
	promptbutton
	special Function11ac3e    ; $00 cancel
	ifequal $00, .script67d5  ; $01 Chosen mon
	ifequal $02, .script67bb  ; $02 Unseen mon?
	writetext UnknownText_0x6113b ; 6ab9
	sjump .script67be
.script67bb
	writetext UnknownText_0x611c9 ; 6b1e
.script67be
	special Function11b444
	ifequal $0a, .script67d5
	ifnotequal $00, .script67db
	writetext UnknownText_0x61271 ; 6b8a
	waitbutton
	closetext
	end
.script67cf
	writetext UnknownText_0x612d8 ; 6bd7
	waitbutton
	closetext
	end

.script67d5
	writetext UnknownText_0x61344 ; 6c0f
	waitbutton
	closetext
	end

.script67db
	special BattleTowerMobileError
	writetext UnknownText_0x61749 ; 6eaa
	waitbutton
	closetext
	end

.script67e4
	writetext UnknownText_0x61375 ; 6c2c
	waitbutton
	closetext
	end

.script67ea
	writetext UnknownText_0x613a9 ; 6c51
	waitbutton
	closetext
	end

.script67f0
	writetext UnknownText_0x613c8 ; 6c6f
	waitbutton
	closetext
	end

.script67f6
	writetext UnknownText_0x616fb ; 6e75
	yesorno
	iffalse .script67d5
	;special TryQuickSave
	iffalse .script67d5
	writetext UnknownText_0x61409 ; 6c89
	promptbutton
	readvar 01
	ifequal $06, .script6838
	writetext UnknownText_0x61438 ; 6ca5
	special Function11b5e8
	ifequal $0a, .script67d5
	ifnotequal $00, .script67db
	setval $0f
	special BattleTowerAction
	ifequal $00, .script683e
	ifequal $01, .script682b
	sjump .script6856
.script682b
	writetext UnknownText_0x6145c ; 6cc4
	promptbutton
	special Function11b7e5
	writetext UnknownText_0x6149a ; 6ce6
	waitbutton
	closetext
	end
.script6838
	writetext UnknownText_0x614ed ; 6d21
	waitbutton
	closetext
	end
.script683e
	writetext UnknownText_0x61544 ; 6d57
	yesorno
	iffalse .script6863
	special Function11b920
	ifequal $0a, .script67d5
	ifnotequal $00, .script67db
	writetext UnknownText_0x615a5 ; 6d8a
	waitbutton
	closetext
	end
.script6856
	writetext UnknownText_0x615c2 ; 6d9a
	promptbutton
	special Function11b93b
	writetext UnknownText_0x6166e ; 6e01
	waitbutton
	closetext
	end
.script6863
	writetext UnknownText_0x61689 ; 6e17
	waitbutton
	closetext
	end
.script6869
	writetext UnknownText_0x616b4 ; 6e30
	waitbutton
	closetext
	end

script686f:
	setscene 1
	opentext
	writetext UnknownText_0x6145c ; 6cc4
	promptbutton
	writetext UnknownText_0x6149a ; 6ce6
	waitbutton
	closetext
	end

script687c:
	writetext UnknownText_0x6176f ; 6ecd
	waitbutton
	readvar 1
	ifequal $06, GoldenrodPokecenter1FLinkReceptionistScript.script6838
	writetext UnknownText_0x616fb ; 6e75
	yesorno
	iffalse GoldenrodPokecenter1FLinkReceptionistScript.script67d5
	;special TryQuickSave
	iffalse GoldenrodPokecenter1FLinkReceptionistScript.script67d5
	writetext UnknownText_0x6191f ; 6fcc
	special GiveOddEgg
	setval 0 ; TODO: odd egg event no longer sets the script value
	         ;       So lets pretend it succeeds for now
	ifequal $0b, .script68af
	ifequal $0a, GoldenrodPokecenter1FLinkReceptionistScript.script67d5
	ifnotequal $00, GoldenrodPokecenter1FLinkReceptionistScript.script67db
.script68a9
	writetext UnknownText_0x61936 ; 6fe6
	waitbutton
	closetext
	end
.script68af
	writetext UnknownText_0x61996 ; 7022
	waitbutton
	closetext
	end

script68b5:
	opentext
	sjump script687c.script68a9
	end ;temp

PokeComInfoSign:
	jumptext UnknownText_0x62370

PokeComNewsMachine:
	special Mobile_DummyReturnFalse
	iftrue .script68c2
	jumptext UnknownText_0x623c7
.script68c2
	opentext
	writetext UnknownText_0x619db
	promptbutton
	setval $14
	special BattleTowerAction
	ifnotequal $00, .script68d9
	setval $15
	special BattleTowerAction
	writetext UnknownText_0x61a11
	waitbutton
.script68d9
	writetext UnknownText_0x61c4b
	yesorno
	iffalse .script68ff
	;special TryQuickSave
	iffalse .script68ff
	setval $15
	special BattleTowerAction
.script68eb
	writetext UnknownText_0x619f5
	setval 0
	special Menu_ChallengeExplanationCancel
	ifequal 1, .script6908
	ifequal 2, .script691d
	ifequal 3, .script6901
.script68ff
	closetext
	end
.script6901
	writetext UnknownText_0x61a11
	waitbutton
	sjump .script68eb
.script6908
	writetext UnknownText_0x61b7c
	yesorno
	iffalse .script68eb
	writetext UnknownText_0x61b9d
	special Function17d2b6
	ifequal $a, .script68eb
	ifnotequal $0, .script6935
	special Function17d2ce
	iffalse .script6932
	ifequal 1, .script692e
	writetext UnknownText_0x61b7c
	yesorno
	iffalse .script68eb
	writetext UnknownText_0x61b9d
	special Function17d2b6
	ifequal $0a, .script68eb
	ifnotequal $0, .script6935
.script691d
	special Function17d2ce
	iffalse .script6932
	ifequal 1, .script692e
	writetext UnknownText_0x61bdb
	waitbutton
	sjump .script68eb
.script692e
	writetext UnknownText_0x61bc4
	waitbutton
.script6932
	sjump .script68eb
.script6935
	special BattleTowerMobileError
	closetext
	end


GoldenrodPokecenter1F_GSBallSceneLeft:
	setval BATTLETOWERACTION_CHECKMOBILEEVENT
	special BattleTowerAction
	iffalse .cancel
	checkevent EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER
	iftrue .cancel
	moveobject GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST, $c, $b
	sjump script6967
.cancel
	end

GoldenrodPokecenter1F_GSBallSceneRight:
	setval BATTLETOWERACTION_CHECKMOBILEEVENT
	special BattleTowerAction
	iffalse .cancel
	checkevent EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER
	iftrue .cancel
	moveobject GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST, $d, $b
	sjump script6967
.cancel
	end

script6967: ; gsball event
	disappear GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST
	playmusic MUSIC_SHOW_ME_AROUND
	applymovement GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST, .movement6a0f
	turnobject PLAYER, UP
	opentext
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText ; 7577
	waitbutton
	verbosegiveitem GS_BALL
	setevent EVENT_GOT_GS_BALL_FROM_POKECOM_CENTER
	setevent EVENT_CAN_GIVE_GS_BALL_TO_KURT
	writetext GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText ; 75c9
	waitbutton
	closetext
	applymovement GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST, .movement6a19
	special RestartMapMusic
	moveobject GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST, $10, $8
	disappear GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST
	appear GOLDENRODPOKECENTER1F_LINK_RECEPTIONIST
	end

.movement6a0f
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step DOWN
	step DOWN
	step_end

.movement6a19
	step UP
	step UP
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step_end


GoldenrodPokecenter1FSuperNerdScript:
	special Mobile_DummyReturnFalse
	iftrue .script69a1
	jumptextfaceplayer UnknownText_0x61c89 ; 71e0
.script69a1
	jumptextfaceplayer UnknownText_0x61cef ; 721e

GoldenrodPokecenter1FYoungsterScript:
	special Mobile_DummyReturnFalse
	iftrue .script69df
	jumptextfaceplayer UnknownText_0x61efa ; 7354
.script69df
	jumptextfaceplayer UnknownText_0x6202c ; 7410

GoldenrodPokecenter1FTeacherScript:
	special Mobile_DummyReturnFalse
	iftrue .script69eb
	jumptextfaceplayer UnknownText_0x61f48 ; 7382
.script69eb
	jumptextfaceplayer UnknownText_0x6206d ; 7432

GoldenrodPokecenter1FRockerScript:
	special Mobile_DummyReturnFalse
	iftrue .script69f7
	jumptextfaceplayer UnknownText_0x61fc9 ; 73d0
.script69f7
	jumptextfaceplayer UnknownText_0x620a1 ; 7454

GoldenrodPokecenter1FGameboyKidScript:
	jumptextfaceplayer GoldenrodPokecenter1FGameboyKidText

GoldenrodPokecenter1FGrampsScript:
	special Mobile_DummyReturnFalse
	iftrue .script6a06
	jumptextfaceplayer UnknownText_0x62173 ; 74D6
.script6a06
	jumptextfaceplayer UnknownText_0x62222 ; 7518

GoldenrodPokecenter1FLassScript:
	jumptextfaceplayer GoldenrodPokecenter1FLassText

GoldenrodPokecenter1FBlockingLassScript:
	special Mobile_DummyReturnFalse
	iftrue .script69ad
	jumptextfaceplayer UnknownText_0x61dfd ; 72ad
.script69ad
	checkevent EVENT_33F ; Because this event is set in the scene
	iftrue .script69d3   ; script, this code never runs
	faceplayer           ; unused in JP too it seems
	opentext
	writetext UnknownText_0x61e5c ; 72eb
	waitbutton
	closetext
	readvar 9
	ifequal 2, .script69c7
	applymovement 5, .movement6a23
	sjump .script69cb
.script69c7
	applymovement 5, .movement6a72
.script69cb
	setevent EVENT_33F
	moveobject 5, 12, 9
	end
.script69d3
	jumptextfaceplayer UnknownText_0x61eb2

.movement6a23
	slow_step RIGHT
	slow_step RIGHT
	turn_head UP
	step_end
.movement6a72
	slow_step DOWN
	slow_step RIGHT
	slow_step RIGHT
	slow_step UP
	turn_head UP
	step_end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtLeftDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromLeftDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistApproachPlayerAtRightDoorwayTileMovement:
	step UP
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head DOWN
	step_end

GoldenrodPokeCenter1FLinkReceptionistWalkToStairsFromRightDoorwayTileMovement:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step_end

; unused
UnknownText_0x61072:
	text "Hello! Welcome to"
	line "#COM CENTER"
	cont "TRADE CORNER."

	para "You can trade"
	line "#MON with other"
	cont "people far away."
	done

UnknownText_0x610ce:
	text "To make a trade,"
	line "we must hold your"
	cont "#MON."

	para "Would you like to"
	line "trade?"
	done

UnknownText_0x61111:
	text "What kind of"
	line "#MON do you"
	cont "want in return?"
	done

UnknownText_0x6113b:
	text "Fine. We will try"
	line "to trade your"

	para "@"
	text_ram wStringBuffer3
	text " for"
	line "@"
	text_ram wStringBuffer4
	text "."

	para "We'll have to hold"
	line "your #MON"
	cont "during the trade."

	para "Please wait while"
	line "we prepare the"
	cont "room for it."
	done

UnknownText_0x611c9:
	text "Fine. We will try"
	line "to trade your"

	para "@"
	text_ram wStringBuffer3
	text " for a"
	line "#MON that you"
	cont "have never seen."

	para "We'll have to hold"
	line "your #MON"
	cont "during the trade."

	para "Please wait while"
	line "we prepare the"
	cont "room for it."
	done

UnknownText_0x61271:
	text "Your trade #MON"
	line "has been received."

	para "It will take time"
	line "to find a trade"

	para "partner. Please"
	line "come back later."
	done

UnknownText_0x612d8:
	text "Oh? You have only"
	line "one #MON in"
	cont "your party. "

	para "Please come back"
	line "once you've in-"
	cont "creased the size"
	cont "of your party."
	done

UnknownText_0x61344:
	text "We hope to see you"
	line "again."
	done

UnknownText_0x6135f:
	text "Communication"
	line "error…"
	done

UnknownText_0x61375:
	text "If we accept that"
	line "#MON, what will"
	cont "you battle with?"
	done

UnknownText_0x613a9:
	text "Sorry. We can't"
	line "accept an EGG."
	done

UnknownText_0x613c8:
	text "Sorry, but your"
	line "#MON appears to"

	para "be abnormal. We"
	line "can't accept it."
	done

UnknownText_0x61409:
	text "Oh? Aren't we"
	line "already holding a"
	cont "#MON of yours?"
	done

UnknownText_0x61438:
	text "We'll check the"
	line "rooms."

	para "Please wait."
	done

UnknownText_0x6145c:
	text "Thank you for your"
	line "patience."

	para "A trade partner"
	line "has been found."
	done

UnknownText_0x6149a:
	text "It's your new"
	line "partner."

	para "Please take care"
	line "of it with love."

	para "We hope to see you"
	line "again."
	done

UnknownText_0x614ed:
	text "Uh-oh. Your party"
	line "is already full."

	para "Please come back"
	line "when you have room"
	cont "in your party."
	done

UnknownText_0x61544:
	text "It's unfortunate,"
	line "but no one has"

	para "come forward as a"
	line "trade partner."

	para "Would you like"
	line "your #MON back?"
	done

UnknownText_0x615a5:
	text "We have returned"
	line "your #MON."
	done

UnknownText_0x615c2:
	text "It's unfortunate,"
	line "but no one has"

	para "come forward as a"
	line "trade partner."

	para "We've held your"
	line "#MON for a long"

	para "time. As a result,"
	line "it is very lonely."

	para "Sorry, but we must"
	line "return it to you."
	done

UnknownText_0x6166e:
	text "We hope to see you"
	line "again."
	done

UnknownText_0x61689:
	text "Fine. We will"
	line "continue to hold"
	cont "your #MON."
	done

UnknownText_0x616b4:
	text "Oh? You left your"
	line "#MON with us"
	cont "only recently."

	para "Please come back"
	line "later."
	done

UnknownText_0x616fb:
	text "We'll SAVE before"
	line "connecting to the"
	cont "CENTER."
	done

UnknownText_0x61727:
	text "Which #MON do"
	line "you want to trade?"
	done

UnknownText_0x61749:
	text "Sorry, but we must"
	line "cancel the trade."
	done

UnknownText_0x6176f:
	text "Oh!"

	para "I see you have an"
	line "EGG TICKET!"

	para "It's a coupon that"
	line "special people can"

	para "redeem for a"
	line "special #MON!"
	done

UnknownText_0x617d2:
	text "Let me give you a"
	line "quick briefing."

	para "Trades held at the"
	line "TRADE CORNER are"

	para "between two"
	line "trainers who don't"

	para "know each other's"
	line "identity."

	para "As a result, it"
	line "may take time."

	para "However, an ODD"
	line "EGG is available"
	cont "just for you."

	para "It will be sent to"
	line "you right away."

	para "Please choose one"
	line "of the rooms in"

	para "the CENTER."
	line "An ODD EGG will be"

	para "sent from the"
	line "chosen room."
	done

UnknownText_0x6191f:
	text "Please wait a"
	line "moment."
	done

UnknownText_0x61936:
	text "Thank you for"
	line "waiting."

	para "We received your"
	line "ODD EGG."

	para "Here it is!"

	para "Please raise it"
	line "with loving care."
	done

UnknownText_0x61996:
	text "I'm awfully sorry."

	para "The EGG TICKET"
	line "exchange service"
	cont "isn't running now."
	done

UnknownText_0x619db:
	text "It's a #MON"
	line "NEWS MACHINE."
	done

UnknownText_0x619f5:
	text "What would you"
	line "like to do?"
	done

UnknownText_0x61a11:
	text "#MON NEWS is"
	line "news compiled from"

	para "the SAVE files of"
	line "#MON trainers."

	para "When reading the"
	line "NEWS, your SAVE"

	para "file may be sent"
	line "out."

	para "The SAVE file data"
	line "will contain your"

	para "adventure log and"
	line "mobile profile."

	para "Your phone number"
	line "will not be sent."

	para "The contents of"
	line "the NEWS will vary"

	para "depending on the"
	line "SAVE files sent by"

	para "you and the other"
	line "#MON trainers."

	para "You might even be"
	line "in the NEWS!"
	done

UnknownText_0x61b7c:
	text "Would you like to"
	line "get the NEWS?"
	done

UnknownText_0x61b9d:
	text "Reading the latest"
	line "NEWS… Please wait."
	done

UnknownText_0x61bc4:
	text "There is no old"
	line "NEWS…"
	done

UnknownText_0x61bdb:
	text "The NEWS data is"
	line "corrupted."

	para "Please download"
	line "the NEWS again."
	done

UnknownText_0x61c18:
	text "We're making"
	line "preparations."

	para "Please come back"
	line "later."
	done

UnknownText_0x61c4b:
	text "We will SAVE your"
	line "progress before"

	para "starting the NEWS"
	line "MACHINE."
	done

UnknownText_0x61c89:
	text "Whoa, this #MON"
	line "CENTER is huge."

	para "They just built"
	line "this place. They"

	para "installed lots of"
	line "new machines too."
	done

UnknownText_0x61cef:
	text "I thought up a fun"
	line "new thing for the"
	cont "TRADE CORNER!"

	para "I make a PIDGEY"
	line "hold MAIL, then"

	para "put it up for"
	line "trade for another"
	cont "one!"

	para "If everyone did"
	line "that, MAIL could"

	para "be traded with all"
	line "sorts of people!"

	para "I call it PIDGEY"
	line "MAIL!"

	para "If it becomes"
	line "popular, I might"

	para "make lots of new"
	line "friends!"
	done

UnknownText_0x61dfd:
	text "They said you can"
	line "trade #MON with"

	para "total strangers up"
	line "here."

	para "But they're still"
	line "adjusting things."
	done

UnknownText_0x61e5c:
	text "Some girl I don't"
	line "know sent me her"

	para "HOPPIP."
	line "You should trade"

	para "for a #MON that"
	line "you want."
	done

UnknownText_0x61eb2:
	text "I received a"
	line "female HOPPIP, but"
	cont "its named STANLEY!"

	para "That's my dad's"
	line "name!"
	done

UnknownText_0x61efa:
	text "What is the NEWS"
	line "MACHINE?"

	para "Does it get news"
	line "from a wider area"
	cont "than the radio?"
	done

UnknownText_0x61f48:
	text "The #COM CENTER"
	line "will link with all"

	para "#MON CENTERS in"
	line "a wireless net."

	para "That must mean"
	line "I'll be able to"

	para "link with all"
	line "sorts of people."
	done

UnknownText_0x61fc9:
	text "The machines here"
	line "can't be used yet."

	para "Still, it's nice"
	line "coming to a trendy"

	para "place before other"
	line "people."
	done

UnknownText_0x6202c:
	text "My friend was in"
	line "the NEWS a while"

	para "back. I was really"
	line "surprised!"
	done

UnknownText_0x6206d:
	text "I get anxious if I"
	line "don't check out"
	cont "the latest NEWS!"
	done

UnknownText_0x620a1:
	text "If I get in the"
	line "NEWS and become"

	para "famous, I bet I'll"
	line "be adored."

	para "I wonder how I"
	line "could get in the"
	cont "NEWS?"
	done

GoldenrodPokecenter1FGameboyKidText:
	text "The COLOSSEUM"
	line "upstairs is for"
	cont "link battles."

	para "Battle records are"
	line "posted on the"

	para "wall, so I can't"
	line "afford to lose."
	done

UnknownText_0x62173:
	text "I came over here"
	line "when I got word"

	para "that GOLDENROD's"
	line "#MON CENTER has"

	para "new machines that"
	line "no one's ever seen"
	cont "before."

	para "But it looks like"
	line "they're still busy"

	para "with all their"
	line "preparations…"
	done

UnknownText_0x62222:
	text "Just seeing all"
	line "these new things"

	para "here makes me feel"
	line "younger!"
	done

GoldenrodPokecenter1FLassText:
	text "A higher level"
	line "#MON doesn't"
	cont "always win."

	para "After all, it may"
	line "have a type dis-"
	cont "advantage."

	para "I don't think"
	line "there is a single"

	para "#MON that is"
	line "the toughest."
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseAcceptGSBallText:
	text "<PLAYER>, isn't it?"

	para "Congratulations!"

	para "As a special deal,"
	line "a GS BALL has been"
	cont "sent just for you!"

	para "Please accept it!"
	done

GoldenrodPokeCenter1FLinkReceptionistPleaseDoComeAgainText:
	text "Please do come"
	line "again!"
	done

UnknownText_0x62370:
	text "#COM CENTER"
	line "1F INFORMATION"

	para "Left:"
	line "ADMINISTRATION"

	para "Center:"
	line "TRADE CORNER"

	para "Right:"
	line "#MON NEWS"
	done

UnknownText_0x623c7:
	text "It's a #MON"
	line "NEWS MACHINE!"

	para "It's not in"
	line "operation yet…"
	done

GoldenrodPokecenter1FPokefanFDoYouHaveEonMailText:
	text "Oh my, your pack"
	line "looks so heavy!"

	para "Oh! Do you happen"
	line "to have something"
	cont "named EON MAIL?"

	para "My daughter is"
	line "after one."

	para "You can part with"
	line "one, can't you?"
	done

GoldenrodPokecenter1FAskGiveAwayAnEonMailText:
	text "Give away an EON"
	line "MAIL?"
	done

GoldenrodPokecenter1FPokefanFThisIsForYouText:
	text "Oh, that's great!"
	line "Thank you, honey!"

	para "Here, this is for"
	line "you in return!"
	done

GoldenrodPokecenter1FPokefanFDaughterWillBeDelightedText:
	text "My daughter will"
	line "be delighted!"
	done

GoldenrodPokecenter1FPokefanFTooBadText:
	text "Oh? You don't have"
	line "one? Too bad."
	done

GoldenrodPokecenter1FPokefanFAnotherTimeThenText:
	text "Oh… Well, another"
	line "time, then."
	done

GoldenrodPokecenter1FPlayerGaveAwayTheEonMailText:
	text "<PLAYER> gave away"
	line "the EON MAIL."
	done

GoldenrodPokecenter1F_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  6,  15, GOLDENROD_CITY, 15
	warp_event  7,  15, GOLDENROD_CITY, 15
	warp_event  0,   6, POKECOM_CENTER_ADMIN_OFFICE_MOBILE, 1
	warp_event  0,  15, POKECENTER_2F, 1

	db 2 ; coord events
	coord_event  6,  15, SCENE_DEFAULT, GoldenrodPokecenter1F_GSBallSceneLeft
	coord_event  7,  15, SCENE_DEFAULT, GoldenrodPokecenter1F_GSBallSceneRight

	db 16 ; bg events
	bg_event 24,  5, BGEVENT_READ, PokeComNewsMachine
	bg_event 24,  6, BGEVENT_READ, PokeComNewsMachine
	bg_event 24,  7, BGEVENT_READ, PokeComNewsMachine
	bg_event 24,  9, BGEVENT_READ, PokeComNewsMachine
	bg_event 24, 10, BGEVENT_READ, PokeComNewsMachine
	bg_event 25, 11, BGEVENT_READ, PokeComNewsMachine
	bg_event 26, 11, BGEVENT_READ, PokeComNewsMachine
	bg_event 27, 11, BGEVENT_READ, PokeComNewsMachine
	bg_event 28, 11, BGEVENT_READ, PokeComNewsMachine
	bg_event 29,  5, BGEVENT_READ, PokeComNewsMachine
	bg_event 29,  6, BGEVENT_READ, PokeComNewsMachine
	bg_event 29,  7, BGEVENT_READ, PokeComNewsMachine
	bg_event 29,  8, BGEVENT_READ, PokeComNewsMachine
	bg_event 29,  9, BGEVENT_READ, PokeComNewsMachine
	bg_event 29, 10, BGEVENT_READ, PokeComNewsMachine
	bg_event  2,  9, BGEVENT_READ, PokeComInfoSign

	db 10 ; object events
	object_event  7,  7, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FNurseScript, -1
	object_event 16,  8, SPRITE_LINK_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FLinkReceptionistScript, -1
	object_event 13,  5, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FSuperNerdScript, -1
	object_event 18,  9, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FBlockingLassScript, -1
	object_event 23,  8, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FYoungsterScript, -1
	object_event 30,  9, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FTeacherScript, -1
	object_event 30,  5, SPRITE_ROCKER, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FRockerScript, -1
	object_event 11, 12, SPRITE_GAMEBOY_KID, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FGameboyKidScript, -1
	object_event 19, 14, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FGrampsScript, -1
	object_event 4,  11, SPRITE_LASS, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GoldenrodPokecenter1FLassScript, -1
