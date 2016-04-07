; ; This is the Clips Plays Poker bot!!!
; ; We currently only assume no-limit Texas Hold'em played with 3 - 10 players!

; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; MAIN MODULE ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;

; ; Card template
(deftemplate MAIN::card
	(slot suit (type SYMBOL))
	(slot value (type INTEGER))
	(slot location (type SYMBOL)))	; ; Could be hole or board (use ?*LOCATION_HOLE* or ?*LOCATION_BOARD*)
	
	
; ; Move template
; ; Can be one of the following:
; ; 1) fold xx.xx (the amount to be paid off when folding)
; ; 2) check (no value, because checking is always 0 cost)
; ; 3) call xx.xx (the amount called, which should be equivalent to the current bet)
; ; 4) bet xx.xx (the amount betted)
; ; 5) raise xx.xx (the amount raised to)
; ; 6) all-in xx.xx (amount all-ed in)

(deftemplate MAIN::move
	(slot move_type (type SYMBOL) (default ?DERIVE))
	(slot current_bet (type FLOAT) (default 0.0)))
	

; ; Possible move templates
(deftemplate MAIN::can_fold)
(deftemplate MAIN::can_check)
(deftemplate MAIN::can_bet)
(deftemplate MAIN::can_small_bet)
(deftemplate MAIN::can_call)
(deftemplate MAIN::can_small_call)
(deftemplate MAIN::can_raise)
(deftemplate MAIN::can_all_in)
	
	
; ; Bet-sizing helper fact template
(deftemplate MAIN::bet_sizing_help
	(slot limpers (type INTEGER) (default -1))	; -1 signifies not yet counted
	(slot preflop_bet_size (type FLOAT) (default -1.0))	; -1.0 signifies not yet calculated
	(slot postflop_bet_size (type FLOAT) (default -1.0)))	; -1.0 signifies not yet calculated

; ; Self template
(deftemplate MAIN::self
	(slot player_id (type INTEGER) (default 0))			; player id that should be unique
	(slot name (type STRING) (default "me"))			; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))				; money that I have to play, including the bet I have made
	(slot bet (type FLOAT) (default 0.0))				; the bet that I have made at the moment (which must be forfeited when folding)
	(slot position (type INTEGER) (default 0))			; Position in the round of betting (should be unique)
	(slot position_type (type SYMBOL))					; Position type (early/mid/late/sb/bb)
	(slot hand_type (type SYMBOL))						; Hand type (AA, KK, QQ, AKs, AKo, etc.)
	(slot strategy (type SYMBOL)))						; the strategy being adopted by myself

	
; ; Player template (players other than myself)
(deftemplate MAIN::player
	(slot player_id (type INTEGER) (default 0)) 			; player id that should be unique
	(slot name (type STRING) (default "nameless"))			; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))					; money that the player has to play, excluding the bet they have made
	(slot bet (type FLOAT) (default 0.0))					; the bet that the player has made at the moment
	(slot tight_loose (type SYMBOL) (default nil))			; is the player tight or loose with starting hand selection?
	(slot aggressive_passive (type SYMBOL) (default nil))	; is the player aggressive or passive?
	(slot position (type INTEGER) (default 0))				; Position in the round of betting (should be unique)
	(slot move (type SYMBOL)))								; the move that was taken by the player

	
; ; Players' move count template (for determining their playing styles)
; ; The facts of this template will be written into a file ?*PLAYER_MOVECOUNT_FILENAME*
(deftemplate MAIN::player_move_count
	(slot player_id (type INTEGER) (default 0))				; player id that should be unique
	(slot preflop_checks_folds (type INTEGER) (default 0))	; the number of checks/folds made by the player in pre-flop only
	(slot preflop_total_moves (type INTEGER) (default 0))	; the total number of moves made by the player in pre-flop only
	(slot checks_calls (type INTEGER) (default 0))			; the number of checks/calls made by the player in all rounds
	(slot bets_raises (type INTEGER) (default 0)))			; the number of bets/raises made by the player in all rounds

	
; ; Game template (keeps the game information)
(deftemplate MAIN::game
	(slot round (type INTEGER) (default 0))					; the rounds are as follows: 0) pre-flop, 1) flop, 2) turn, 3) river (final round)
	(slot pot (type FLOAT) (default 0.0))					; the pot starts with no money, and fills up with player bets as the game progresses through the rounds
	(slot current_bet (type FLOAT) (default 0.0))			; the current bet (amount every player must call, unless they do all-in)
	(slot min_allowed_bet (type FLOAT) (default 1.0)))		; the minimum bet/raise allowed currently (raises must be at least as big as the previous raise; default sets the minimum starting bet for every betting roun)

	
; ; The strongest player template (contains information filled in by CPP after evaluation of all players except itself)
(deftemplate MAIN::strongest_player
	(slot player_id (type INTEGER) (default 0))								; player id of the strongest player
	(slot lose_to_cpp_probability (type FLOAT) (default 0.0))				; probability of the strongest player losing to me
	(slot likely_type_of_hand (type SYMBOL) (default ?*MARGINAL_HAND*)))	; likely type of hand of the strongest player
	
	



; ; ; ; ; ; ; ; ; ; ; ; ;
; ; MODULE DEFINITIONS  ;
; ; ; ; ; ; ; ; ; ; ; ; ;

; ; NOTE THAT CONSTANTS/TEMPLATES SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT/IMPORT THEM

; ; MODULE DEFINITIONS
(defmodule MAIN (export ?ALL))
(defmodule OPPONENT-PLAYSTYLE-DETERMINATION (import MAIN ?ALL))
(defmodule OPPONENT-HAND-DETERMINATION (import MAIN ?ALL))
(defmodule OWN-HAND-DETERMINATION (import MAIN ?ALL))
(defmodule STRONGEST-OPPONENT-DETERMINATION (import MAIN ?ALL))
(defmodule STRATEGY-SELECTION (import MAIN ?ALL))
(defmodule POSSIBLE-MOVE-DETERMINATION (import MAIN ?ALL))
(defmodule MOVE-SELECTION (import MAIN ?ALL))




	
; ; Control facts
(deffacts MAIN::control
	(module-sequence 
		OPPONENT-PLAYSTYLE-DETERMINATION
		OPPONENT-HAND-DETERMINATION 
		OWN-HAND-DETERMINATION 
		STRONGEST-OPPONENT-DETERMINATION 
		POSSIBLE-MOVE-DETERMINATION 
		STRATEGY-SELECTION 
		MOVE-SELECTION))

	
; ; Control rule to change focus
(defrule MAIN::change-focus
	(declare (salience -1))		; ; Changing focus is least important
	?list <- (module-sequence ?next-module $?other-modules)
	=>
	(printout t crlf "In module " ?next-module " now" crlf)
	(focus ?next-module)
	(retract ?list)
	(assert (module-sequence $?other-modules)))
	
	
; ; The initial facts
(deffacts MAIN::the-facts
	(card (suit a) (value 14) (location ?*LOCATION_HOLE*))
	(card (suit b) (value 11) (location ?*LOCATION_HOLE*))
	(player (player_id 2) (name "Bad Guy 1") (money 23.35) (bet 1.0) (position 0) (move bet))
	(player (player_id 4) (name "Bad Guy 2") (money 19.0) (bet 0.0) (position 1) (move fold))
	(player (player_id 6) (name "Bad Guy 3") (money 19.0) (bet 0.0) (position 2) (move fold))
	(self (player_id 0) (name "The Bot") (money 33.37) (bet 0.0) (position 3)) ; ; (strategy ?*INDUCEFOLDS_STRATEGY*))
	(player (player_id 1) (name "Bad Guy 4") (money 13.37) (bet 0.0) (position 4) (move nil))
	(player (player_id 3) (name "Bad Guy 5") (money 40.0) (bet 0.0) (position 5) (move nil))
	(player (player_id 5) (name "Bad Guy 6") (money 40.0) (bet 0.0) (position 6) (move nil))
	(player (player_id 7) (name "Bad Guy 7") (money 13.37) (bet 0.0) (position 7) (move nil))
	(player (player_id 8) (name "Bad Guy 8") (money 40.0) (bet 0.0) (position 8) (move nil))
	(player (player_id 9) (name "Bad Guy 9") (money 40.0) (bet 0.0) (position 9) (move nil))
	(strongest_player (player_id 1) (lose_to_cpp_probability 0.0) (likely_type_of_hand ?*MARGINAL_HAND*))
	(game (round 0) (pot 1.0) (current_bet 1.0) (min_allowed_bet 1.0)))