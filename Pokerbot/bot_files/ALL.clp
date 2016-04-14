; ; ; ; ; ; ; ;
; ; CONSTANTS ;
; ; ; ; ; ; ; ;

; ; NOTE THAT CONSTANTS/TEMPLATES SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT THEM

; ; FILENAME CONSTANTS
(defglobal ?*PLAYER_MOVECOUNT_FILENAME* = player_move_count.txt)
(defglobal ?*PREVIOUS_STRATEGY_FILENAME* = previous_strategy.txt)

; ; PLAYER ATTRIBUTE CONSTANTS
(defglobal ?*TIGHT* = tight)
(defglobal ?*LOOSE* = loose)
(defglobal ?*AGGRESSIVE* = aggressive)
(defglobal ?*PASSIVE* = passive)

; ; STRATEGY CONSTANTS
(defglobal ?*CUTLOSSES_STRATEGY* = cut-losses)						; moves to take: check/fold (like when the villain obviously has a monster hand)
(defglobal ?*DEFENSIVE_STRATEGY* = defensive)						; moves to take: small bet/check/fold if necessary (like when playing against a possibly strong marginal/monster hand with a marginal hand)
(defglobal ?*INDUCEFOLDS_STRATEGY* = induce-folds)					; moves to take: bluff (like when playing against a possibly weak marginal hand with an air hand)
(defglobal ?*INDUCEBETS_STRATEGY* = induce-bets)					; moves to take: value bet/check (like when against an air hand)

; ; WIN PROBABILITY THRESHOLD CONSTANTS
(defglobal ?*WINPROB_THRESHOLD_CUTLOSSES* = 0.3)		; below 0.3, always cut losses
(defglobal ?*WINPROB_THRESHOLD_DEFENSIVE* = 0.4)		; (0.3, 0.4] & have raisers, defensive
(defglobal ?*WINPROB_THRESHOLD_INDUCEBETS* = 0.7)		; above 0.7, always induce bets

; ; TYPE OF HAND CONSTANTS
(defglobal ?*AIR_HAND* = air-hand)
(defglobal ?*MARGINAL_HAND* = marginal-hand)
(defglobal ?*MONSTER_HAND* = monster-hand)

; ; TYPE OF MOVE CONSTANTS
(defglobal ?*FOLD* = fold)
(defglobal ?*CHECK* = check)
(defglobal ?*BET* = bet)
(defglobal ?*CALL* = call)
(defglobal ?*RAISE* = raise)
(defglobal ?*ALL_IN* = all-in)

; ; LOCATION CONSTANTS
(defglobal ?*LOCATION_HOLE* = hole)		; ; Hole cards are the face-down cards (in your hand)
(defglobal ?*LOCATION_BOARD* = board)	; ; Board cards are the face-up cards

; ; POSITION TYPE CONSTANTS (for use when selecting strategy)
(defglobal ?*POSITION_EARLY* = early)
(defglobal ?*POSITION_MID* = mid)
(defglobal ?*POSITION_LATE* = late)
(defglobal ?*POSITION_SMALLBLIND* = small_blind)
(defglobal ?*POSITION_BIGBLIND* = big_blind)

; ; HAND TYPE CONSTANTS
(defglobal ?*HAND_AA* = AA)
(defglobal ?*HAND_QQ* = KK)
(defglobal ?*HAND_KK* = QQ)

(defglobal ?*HAND_JJ* = JJ)
(defglobal ?*HAND_TT* = TT)

(defglobal ?*HAND_99-22* = 99-22)

(defglobal ?*HAND_AKs* = AKs)
(defglobal ?*HAND_AKo* = AKo)

(defglobal ?*HAND_AQs* = AQs)
(defglobal ?*HAND_AQo* = AQo)
(defglobal ?*HAND_AJs* = AJs)

(defglobal ?*HAND_AJo* = AJo)
(defglobal ?*HAND_ATs* = ATs)
(defglobal ?*HAND_ATo* = ATo)

(defglobal ?*HAND_A9s-A2s* = A9s-A2s)

(defglobal ?*HAND_KQs* = KQs)
(defglobal ?*HAND_KQo* = KQo)
(defglobal ?*HAND_KJs* = KJs)
(defglobal ?*HAND_KJo* = KJo)
(defglobal ?*HAND_QJs* = QJs)

(defglobal ?*HAND_KTs* = KTs)
(defglobal ?*HAND_KTo* = KTo)
(defglobal ?*HAND_QJo* = QJo)
(defglobal ?*HAND_QTs* = QTs)
(defglobal ?*HAND_Q9s* = Q9s)
(defglobal ?*HAND_JTs* = JTs)
(defglobal ?*HAND_J9s* = J9s)
(defglobal ?*HAND_J8s* = J8s)
(defglobal ?*HAND_T9s* = T9s)
(defglobal ?*HAND_T8s* = T8s)
(defglobal ?*HAND_98s* = 98s)
(defglobal ?*HAND_87s* = 87s)
(defglobal ?*HAND_76s* = 76s)
(defglobal ?*HAND_65s* = 65s)
(defglobal ?*HAND_54s* = 54s)

(defglobal ?*HAND_BADHAND* = bad_hand); ; This is the Clips Plays Poker bot!!!
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
	(slot win_probability (type FLOAT) (default -1.0))	; Calculated probability of winning the game
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

; ; Template used for storing the strategy used in the previous betting round
(deftemplate MAIN::previous_strategy
	(slot prev_round (type INTEGER) (default 0))
	(slot prev_strat (type SYMBOL)))




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
; (deffacts MAIN::the-facts
; 	(card (suit a) (value 5) (location ?*LOCATION_HOLE*))
; 	(card (suit a) (value 4) (location ?*LOCATION_HOLE*))
; 	(player (player_id 2) (name "Bad Guy 1") (money 23.35) (bet 1.0) (position 0) (move bet))
; 	(player (player_id 4) (name "Bad Guy 2") (money 19.0) (bet 0.0) (position 1) (move fold))
; 	(player (player_id 6) (name "Bad Guy 3") (money 19.0) (bet 0.0) (position 2) (move fold))
; 	(self (player_id 0) (name "The Bot") (money 33.37) (bet 0.0) (position 3) (win_probability 0.5)) ; ; (strategy ?*INDUCEFOLDS_STRATEGY*))
; 	(player (player_id 1) (name "Bad Guy 4") (money 13.37) (bet 0.0) (position 4) (move nil))
; 	(player (player_id 3) (name "Bad Guy 5") (money 40.0) (bet 0.0) (position 5) (move nil))
; 	(player (player_id 5) (name "Bad Guy 6") (money 40.0) (bet 0.0) (position 6) (move nil))
; 	(player (player_id 7) (name "Bad Guy 7") (money 13.37) (bet 0.0) (position 7) (move nil))
; 	(player (player_id 8) (name "Bad Guy 8") (money 40.0) (bet 0.0) (position 8) (move nil))
; 	(player (player_id 9) (name "Bad Guy 9") (money 40.0) (bet 0.0) (position 9) (move nil))
; 	(strongest_player (player_id 1) (lose_to_cpp_probability 0.0) (likely_type_of_hand ?*MARGINAL_HAND*))
; 	(game (round 3) (pot 1.0) (current_bet 1.0) (min_allowed_bet 1.0))); ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; MOVE-SELECTION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules for selecting default move  ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Default move selection announcement (when no other strategy works, just check/call/all-in (in this order))
(defrule MOVE-SELECTION::default-move-selection-announcement
	(declare (salience -1))		; ; Default move selection should be done only after all else fails
	(not (move))				; ; Got no moves asserted!
	=>
	(printout t "Performing default-move-selection because we could not perform any good move according to the rules!" crlf)
	(assert (should_perform_default_move)))

; ; This rule is to retract the default move selection announcement (when we already have chosen a rule)
(defrule MOVE-SELECTION::default-move-selection-announcement-retraction
	(declare (salience -1))		; ; Default move selection should be retracted once there is a move so that we don't select more than 1 move
	(move)
	?announcement <- (should_perform_default_move)
	=>
	(retract ?announcement))

; ; Check happens before call/all-in
(defrule MOVE-SELECTION::default-move-selection-check
	(declare (salience -2))				; ; Less importance than the default move selection announcement & retraction rules
	(should_perform_default_move)		; ; Asserted by other rules
	(can_check)							; ; Asserted by other rules
	=>
	(assert (move (move_type ?*CHECK*))))

; ; Call happens if check could not happen
(defrule MOVE-SELECTION::default-move-selection-call
	(declare (salience -2))				; ; Less importance than the default move selection announcement & retraction rules
	(should_perform_default_move)		; ; Asserted by other rules
	(can_call)							; ; Asserted by other rules
	(not (can_check))					; ; Asserted by other rules
	(game (current_bet ?current_bet))
	?self <- (self)
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (bet ?current_bet)))

; ; All-in happens if both check and call could not happen
(defrule MOVE-SELECTION::default-move-selection-all-in
	(declare (salience -2))				; ; Less importance than the default move selection announcement & retraction rules
	(should_perform_default_move)		; ; Asserted by other rules
	(can_all_in)						; ; Asserted by other rules
	(not (can_check))					; ; Asserted by other rules
	(not (can_call))					; ; Asserted by other rules
	?self <- (self (money ?mymoney))
	=>
	(assert (move (move_type ?*ALL_IN*) (current_bet ?mymoney)))
	(modify ?self (bet ?mymoney)))


; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules for selecting move by strategy  ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Cut losses strategy (check/fold);
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule MOVE-SELECTION::cut-losses-strategy-check
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*CUTLOSSES_STRATEGY*)))
	(can_check)
	=>
	(assert (move (move_type ?*CHECK*))))
(defrule MOVE-SELECTION::cut-losses-strategy-fold
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*CUTLOSSES_STRATEGY*)) (bet ?mybet))
	(can_fold)
	(not (can_check))
	=>
	(assert (move (move_type ?*FOLD*) (current_bet ?mybet))))

; ; ; ; ; ; ; ; ; ; ; ;
; ; Defensive strategy;
; ; ; ; ; ; ; ; ; ; ; ;
; ; When able to do both check/small bet, randomly pick one, favouring check over small bet
(defrule MOVE-SELECTION::defensive-strategy-randomly-check-or-small-bet
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	(can_check)
	(can_small_bet)
	(game (min_allowed_bet ?minbet))
	=>
	(bind ?roll (mod (random) 4))
	; ; ; (printout t "Rolled [0-3] a " ?roll crlf)	; ; For debugging purposes
	(if (>= ?roll 3)	; ; 1 in 4 chance to make a small bet
		then
		(assert (move (move_type ?*BET*) (current_bet ?minbet)))
		(modify ?self (bet ?minbet))
		else
		(assert (move (move_type ?*CHECK*)))))
; ; When unable to small bet but can check, just do the check
(defrule MOVE-SELECTION::defensive-strategy-check
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	(can_check)
	(not (can_small_bet))
	=>
	(assert (move (move_type ?*CHECK*))))
; ; When unable to check but able to small bet, just do the small bet (NORMALLY THIS SHOULD NOT HAPPEN, but just capture the case anyway)
(defrule MOVE-SELECTION::defensive-strategy-small-bet
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	(can_small_bet)
	(not (can_check))
	(game (min_allowed_bet ?minbet))
	=>
	(assert (move (move_type ?*BET*) (current_bet ?minbet)))
	(modify ?self (bet ?minbet)))
; ; When unable to do check/small bet but able to do small call, do it
(defrule MOVE-SELECTION::defensive-strategy-small-call
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	(can_small_call)
	(not (can_check))
	(not (can_small_bet))
	(game (current_bet ?current_bet))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (bet ?current_bet)))
; ; When unable to do check/small bet/small call, just fold
(defrule MOVE-SELECTION::defensive-strategy-fold
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)) (bet ?mybet))
	(can_fold)
	(not (can_check))
	(not (can_small_bet))
	(not (can_small_call))
	=>
	(assert (move (move_type ?*FOLD*) (current_bet ?mybet))))


; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Induce folds strategy ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; When able to bet, perform a big bet to induce fold
(defrule MOVE-SELECTION::induce-folds-strategy-big-bet
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)) (money ?mymoney))
	(can_bet)
	(game (min_allowed_bet ?minbet) (pot ?pot) (round ?round))
	(bet_sizing_help (preflop_bet_size ?preflop_bet_size) (postflop_bet_size ?postflop_bet_size))
	=>
	(bind ?high_amount (max ?preflop_bet_size ?postflop_bet_size ?minbet))
	(if (>= ?high_amount ?mymoney)		; ; Not enough money, all-in!
		then
		(assert (move (move_type ?*ALL_IN*) (current_bet ?mymoney)))
		(modify ?self (bet ?mymoney))
		else 							; ; Enough money, so place the bet
		(assert (move (move_type ?*BET*) (current_bet ?high_amount)))
		(modify ?self (bet ?high_amount))))
; ; When unable to bet but able to raise, perform a big raise to induce fold
(defrule MOVE-SELECTION::induce-folds-strategy-big-raise
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)) (money ?mymoney))
	(can_raise)
	(not (can_bet))
	(game (current_bet ?current_bet) (min_allowed_bet ?minbet) (pot ?pot) (round ?round))
	(bet_sizing_help (preflop_bet_size ?preflop_bet_size) (postflop_bet_size ?postflop_bet_size))
	=>
	(bind ?raise_amount (max ?preflop_bet_size ?postflop_bet_size ?minbet))
	(bind ?new_bet (+ ?current_bet ?raise_amount))
	(if (>= ?new_bet ?mymoney)
		then
		(assert (move (move_type ?*ALL_IN*) (current_bet ?mymoney)))
		(modify ?self (bet ?mymoney))
		else
		(assert (move (move_type ?*RAISE*) (current_bet ?new_bet)))
		(modify ?self (bet ?new_bet))))
; ; When unable to bet AND unable to raise, perform all in
(defrule MOVE-SELECTION::induce-folds-strategy-all-in
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)) (money ?mymoney))
	(can_all_in)
	(not (can_bet))
	(not (can_raise))
	=>
	(assert (move (move_type ?*ALL_IN*) (current_bet ?mymoney)))
	(modify ?self (bet ?mymoney)))

; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Induce bets strategy;
; ; ; ; ; ; ; ; ; ; ; ; ;
; ; When able to do both check/bet, randomly pick one, favouring value bet over check
(defrule MOVE-SELECTION::induce-bets-strategy-randomly-value-bet-or-check
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	(can_bet)
	(can_check)
	(game (min_allowed_bet ?minbet) (round ?round))
	(bet_sizing_help (preflop_bet_size ?preflop_bet_size) (postflop_bet_size ?postflop_bet_size))
	=>
	(if (> ?round 0)
		then
		(bind ?bet_amount ?postflop_bet_size)
		else
		(bind ?bet_amount ?preflop_bet_size))
	(bind ?bet_amount (max ?bet_amount ?minbet))
	(bind ?roll (mod (random) 4))
	; ; ; (printout t "Rolled [0-3] a " ?roll crlf)	; ; For debugging purposes
	(if (>= ?roll 3)	; ; 1 in 4 chance to check instead of value bet
		then
		(assert (move (move_type ?*CHECK*)))
		else
		(assert (move (move_type ?*BET*) (current_bet ?bet_amount)))
		(modify ?self (bet ?bet_amount))))
; ; When unable to bet but able to check, just check
(defrule MOVE-SELECTION::induce-bets-strategy-check
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	(can_check)
	(not (can_bet))
	=>
	(assert (move (move_type ?*CHECK*))))
; ; When unable to check but able to bet (should NOT happen, normally)
(defrule MOVE-SELECTION::induce-bets-strategy-value-bet
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	(can_bet)
	(not (can_check))
	(game (min_allowed_bet ?minbet) (round ?round))
	(bet_sizing_help (preflop_bet_size ?preflop_bet_size) (postflop_bet_size ?postflop_bet_size))
	=>
	(if (> ?round 0)
		then
		(bind ?bet_amount ?postflop_bet_size)
		else
		(bind ?bet_amount ?preflop_bet_size))
	(bind ?bet_amount (max ?bet_amount ?minbet))
	(assert (move (move_type ?*BET*) (current_bet ?bet_amount)))
	(modify ?self (bet ?bet_amount)))
; ; When unable to do check/bet but able to call, then we should call
(defrule MOVE-SELECTION::induce-bets-strategy-call
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	(can_call)
	(not (can_bet))
	(not (can_check))
	(game (current_bet ?current_bet))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (bet ?current_bet)))
; ; When unable to do any of check/bet/call, we still want to stay in the game! So, all in!!!
(defrule MOVE-SELECTION::induce-bets-strategy-all-in
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)) (money ?mymoney))
	(can_all_in)
	(not (can_bet))
	(not (can_check))
	(not (can_call))
	=>
	(assert (move (move_type ?*ALL_IN*) (current_bet ?mymoney)))
	(modify ?self (bet ?mymoney)))


; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;
; ; Utility rules ;
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;


; ; Print out the move selected
(defrule MOVE-SELECTION::print-move
	(declare (salience -5000))	; ; Printing out a move should be done only when we are actually done selecting, so it is of least concern
	(not (printed_move))
	(move (move_type ?move_type) (current_bet ?current_bet))
	=>
	(assert (printed_move))
	(printout t "Move selected is: " ?move_type)
	(if (subsetp (create$ ?move_type) (create$ ?*FOLD* ?*CALL* ?*BET* ?*RAISE* ?*ALL_IN*)) ; ; Each of these moves will have a meaningful current-bet value, so print it
		then
		(printout t " $" ?current_bet))
	(printout t crlf)); ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; OPPONENT-PLAYSTYLE-DETERMINATION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Load the players' move count facts from a file;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Load the players' move count facts
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::load-player-move-count-from-file
	(declare (salience 1))		; ; Loading the player move count facts from the file should be done first
	=>
	(if (eq (open ?*PLAYER_MOVECOUNT_FILENAME* rf) FALSE)
		then
		(open ?*PLAYER_MOVECOUNT_FILENAME* wf "w")
		(printout wf "")
		(close wf)
		(open ?*PLAYER_MOVECOUNT_FILENAME* rf))
	(while (neq (bind ?line (readline rf)) EOF)
		(assert-string ?line))
	(close rf))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Update the facts with the current moves made by each player ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; If no player move count facts even though there is such a player, create a new player move count from scratch
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::create-new-player-move-count
	(player (player_id ?pid))
	(not (player_move_count (player_id ?pid)))
	=>
	(assert (player_move_count (player_id ?pid))))

; ; Update the player move counts with the current moves of each player who has checked/folded in pre-flop
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::update-player-move-count-preflop-checks-folds
	(player (player_id ?pid) (move ?move&:(or (eq ?move ?*FOLD*) (eq ?move ?*CHECK*))))
	(not (updated_player_move_count_preflop ?pid))
	?pmc <- (player_move_count (player_id ?pid) (preflop_checks_folds ?preflop_checks_folds)
								(preflop_total_moves ?preflop_total_moves))
	(game (round 0))		; ; pre-flop
	=>
	(assert (updated_player_move_count_preflop ?pid))
	(modify ?pmc (preflop_checks_folds (+ ?preflop_checks_folds 1)) (preflop_total_moves (+ ?preflop_total_moves 1))))

; ; Update the player move counts with the current moves of each player who has done something other than check/fold in pre-flop
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::update-player-move-count-preflop-non-checks-folds
	(player (player_id ?pid) (move ?move&:(and (neq ?move ?*FOLD*) (neq ?move ?*CHECK*))))
	(not (updated_player_move_count_preflop ?pid))
	?pmc <- (player_move_count (player_id ?pid) (preflop_checks_folds ?preflop_checks_folds)
								(preflop_total_moves ?preflop_total_moves))
	(game (round 0))		; ; pre-flop
	=>
	(assert (updated_player_move_count_preflop ?pid))
	(modify ?pmc (preflop_total_moves (+ ?preflop_total_moves 1))))

; ; Update the player move counts with the current moves of each player who has checked/called in any round
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::update-player-move-count-checks-calls
	(player (player_id ?pid) (move ?move&:(or (eq ?move ?*CHECK*) (eq ?move ?*CALL*))))
	(not (updated_player_move_count_general ?pid))
	?pmc <- (player_move_count (player_id ?pid) (checks_calls ?checks_calls))
	=>
	(assert (updated_player_move_count_general ?pid))
	(modify ?pmc (checks_calls (+ ?checks_calls 1))))

; ; Update the player move counts with the current moves of each player who has betted/raised in any round
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::update-player-move-count-bets-raises
	(player (player_id ?pid) (move ?move&:(or (eq ?move ?*BET*) (eq ?move ?*RAISE*))))
	(not (updated_player_move_count_general ?pid))
	?pmc <- (player_move_count (player_id ?pid) (bets_raises ?bets_raises))
	=>
	(assert (updated_player_move_count_general ?pid))
	(modify ?pmc (bets_raises (+ ?bets_raises 1))))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine the players' playstyles ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Determine if player is tight
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::determine-playstyles-tight
	(declare (salience -1))		; ; Determination done after updating of player move counts
	?player <- (player (player_id ?pid) (tight_loose nil))
	(player_move_count (player_id ?pid) (preflop_checks_folds ?preflop_checks_folds)
						(preflop_total_moves ?preflop_total_moves&:(<= (* 2 ?preflop_checks_folds) ?preflop_total_moves)))
	=>
	(modify ?player (tight_loose ?*TIGHT*)))

; ; Determine if player is loose
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::determine-playstyles-loose
	(declare (salience -1))		; ; Determination done after updating of player move counts
	?player <- (player (player_id ?pid) (tight_loose nil))
	(player_move_count (player_id ?pid) (preflop_checks_folds ?preflop_checks_folds)
						(preflop_total_moves ?preflop_total_moves&:(> (* 2 ?preflop_checks_folds) ?preflop_total_moves)))
	=>
	(modify ?player (tight_loose ?*LOOSE*)))

; ; Determine if player is aggressive
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::determine-playstyles-aggressive
	(declare (salience -1))		; ; Determination done after updating of player move counts
	?player <- (player (player_id ?pid) (aggressive_passive nil))
	(player_move_count (player_id ?pid) (checks_calls ?checks_calls)
						(bets_raises ?bets_raises&:(>= ?bets_raises ?checks_calls)))
	=>
	(modify ?player (aggressive_passive ?*AGGRESSIVE*)))

; ; Determine if player is passive
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::determine-playstyles-passive
	(declare (salience -1))		; ; Determination done after updating of player move counts
	?player <- (player (player_id ?pid) (aggressive_passive nil))
	(player_move_count (player_id ?pid) (checks_calls ?checks_calls)
						(bets_raises ?bets_raises&:(< ?bets_raises ?checks_calls)))
	=>
	(modify ?player (aggressive_passive ?*PASSIVE*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Write the players' move count facts to a file ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Empty the file to write to, in order to prepare for the 'write-player-move-count-to-file' rule to append to the file
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::empty-write-file
	(declare (salience -2))		; ; Emptying should happen before writing, but after determining of the player's attributes
	(not (emptied_write_file))
	=>
	(assert (emptied_write_file))
	(open ?*PLAYER_MOVECOUNT_FILENAME* wf "w")
	(printout wf "")
	(close wf))

; ; Write the players' move count facts to a file
(defrule OPPONENT-PLAYSTYLE-DETERMINATION::write-player-move-count-to-file
	(declare (salience -3))		; ; Write to file only after the determining of the player's attributes
	(player_move_count (player_id ?pid) (preflop_checks_folds ?preflop_checks_folds)
						(preflop_total_moves ?preflop_total_moves)
						(checks_calls ?checks_calls)
						(bets_raises ?bets_raises))
	(not (wrote_player_move_count ?pid))
	=>
	(assert (wrote_player_move_count ?pid))
	(open ?*PLAYER_MOVECOUNT_FILENAME* wf "a")
	(printout wf
		(str-cat
			"(player_move_count"
			" (player_id " ?pid ")"
			" (preflop_checks_folds " ?preflop_checks_folds ")"
			" (preflop_total_moves " ?preflop_total_moves ")"
			" (checks_calls " ?checks_calls ")"
			" (bets_raises " ?bets_raises ")"
			")")
		crlf)
	(close wf)); ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; OWN-HAND-DETERMINATION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ;
; ; ; ; ; ; ;
; ; Pairs ; ;
; ; ; ; ; ; ;
; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-AA
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_AA*))
	(printout t "Hand is: AA" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KK
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_KK*))
	(printout t "Hand is: KK" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QQ
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_QQ*))
	(printout t "Hand is: QQ" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-JJ
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_JJ*))
	(printout t "Hand is: JJ" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-TT
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_TT*))
	(printout t "Hand is: TT" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-99-22
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value ?v&:(and (<= ?v 9) (>= ?v 2))) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value ?v) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_99-22*))
	(printout t "Hand is: 99-22" crlf))

; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;
; ; Ace-X Hands ; ;
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-AKs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AKs*))
	(printout t "Hand is: AKs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AKo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AKo*))
	(printout t "Hand is: AKo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AQs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AQs*))
	(printout t "Hand is: AQs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AQo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AQo*))
	(printout t "Hand is: AQo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AJs*))
	(printout t "Hand is: AJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AJo*))
	(printout t "Hand is: AJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-ATs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_ATs*))
	(printout t "Hand is: ATs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-ATo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_ATo*))
	(printout t "Hand is: ATo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-A9s-A2s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value ?v2&:(and (<= ?v2 9) (>= ?v2 2))) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_A9s-A2s*))
	(printout t "Hand is: A9s-A2s" crlf))

; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;
; ; Playable Hands;
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-KQs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KQs*))
	(printout t "Hand is: KQs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KQo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KQo*))
	(printout t "Hand is: KQo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KJs*))
	(printout t "Hand is: KJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KJo*))
	(printout t "Hand is: KJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QJs*))
	(printout t "Hand is: QJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KTs*))
	(printout t "Hand is: KTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KTo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KTo*))
	(printout t "Hand is: KTo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QJo*))
	(printout t "Hand is: QJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QTs*))
	(printout t "Hand is: QTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-Q9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_Q9s*))
	(printout t "Hand is: Q9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-JTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_JTs*))
	(printout t "Hand is: JTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-J9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_J9s*))
	(printout t "Hand is: J9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-J8s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_J8s*))
	(printout t "Hand is: J8s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-T9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_T9s*))
	(printout t "Hand is: T9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-T8s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_T8s*))
	(printout t "Hand is: T8s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-98s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_98s*))
	(printout t "Hand is: 98s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-87s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 7) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_87s*))
	(printout t "Hand is: 87s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-76s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 7) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 6) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_76s*))
	(printout t "Hand is: 76s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-65s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 6) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 5) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_65s*))
	(printout t "Hand is: 65s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-54s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 5) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 5) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_54s*))
	(printout t "Hand is: 54s" crlf))



; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Set hand type to a bad hand if no other rule set it ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-badhand
	(declare (salience -1))			; ; Least salient (since it is a default fail-safe value)
	?self <- (self (hand_type nil))
	=>
	(modify ?self (hand_type ?*HAND_BADHAND*))
	(printout t "Hand is: bad_hand" crlf)); ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; POSSIBLE-MOVE-DETERMINATION MODULE;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;


; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules to determine if can play a certain move           ;
; ; (fold/check/all-in/bet/small-bet/call/small-call/raise) ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Determine if can play fold (can ALWAYS fold)
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-fold
	=>
	(assert (can_fold)))

; ; Determine if can play check
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-check
	(game (current_bet 0.0))		; ; We can only check if nobody has yet placed a bet
	=>
	(assert (can_check)))

; ; Determine if can play all-in (can ALWAYS all-in)
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-all-in
	=>
	(assert (can_all_in)))

; ; Determine if can play bet
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-bet
	(game (current_bet 0.0) (min_allowed_bet ?minbet))		; ; We can only bet if nobody has yet placed a bet
	(self (money ?money&:(>= ?money ?minbet)))				; ; We must have enough money to play at least the minimum bet
	=>
	(assert (can_bet)))

; ; Determine if can play small bet (small bet is currently defined as min_allowed_bet)
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-small-bet
	(can_bet)						; ; Obviously, to be able to do a small bet we must first satisfy the weaker condition of being able to do a bet
	(game (min_allowed_bet ?minbet))
	(self (money ?mymoney&:(>= ?mymoney ?minbet)))
	=>
	(assert (can_small_bet)))

; ; Determine if can play call
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-call
	(game (current_bet ?current_bet&:(> ?current_bet 0.0)))	; ; We can only call if there has been a bet
	(self (money ?money&:(>= ?money ?current_bet)))			; ; We must have enough money to call the bet
	=>
	(assert (can_call)))

; ; Determine if can play small call (small call is currently defined as <= 10% of player's money)
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-small-call
	(can_call)						; ; Obviously, to be able to do a small call we must first satisfy the weaker condition of being able to do a call
	(game (current_bet ?current_bet))
	(self (money ?mymoney&:(<= ?current_bet (* 0.1 ?mymoney))))	; ; The current bet to call is <= 10% of player's money
	=>
	(assert (can_small_call)))

; ; Determine if can play raise
(defrule POSSIBLE-MOVE-DETERMINATION::check-can-raise
	(game (current_bet ?current_bet&:(> ?current_bet 0.0)) (min_allowed_bet ?min_allowed_bet))	; ; We can only raise if there has been a bet
	(self (money ?money&:(>= (- ?money ?current_bet) ?min_allowed_bet)))	; ; We can only raise if we have sufficient money to raise the bet at least by the min_allowed_bet
	=>
	(assert (can_raise)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Preprocessing stuff for bet-sizing;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Initialize bet_sizing_help fact
(defrule POSSIBLE-MOVE-DETERMINATION::initialize-bet-sizing-help-fact
	(not (bet_sizing_help))
	=>
	(assert (bet_sizing_help)))

; ; Count the number of limpers in this round
(defrule POSSIBLE-MOVE-DETERMINATION::count-limpers
	?bsh <- (bet_sizing_help (limpers -1))	; ; not yet processed
	=>
	(bind ?limper_count
		(length$ (find-all-facts ((?p player)) (or (eq ?p:move ?*CALL*) (eq ?p:move ?*CHECK*)))))
	(modify ?bsh (limpers ?limper_count))
	(printout t "Counted number of limpers: " ?limper_count crlf))

; ; Calculate preflop bet size
(defrule POSSIBLE-MOVE-DETERMINATION::calculate-preflop-bet-size
	?bsh <- (bet_sizing_help (limpers ?limpers&:(>= ?limpers 0)) (preflop_bet_size -1.0))		; ; limpers calculated but not preflop bet size
	(game (min_allowed_bet ?minbet))
	=>
	(modify ?bsh (preflop_bet_size (+ (* 3 ?minbet) (* ?limpers ?minbet)))))

; ; Calculate posflop bet size
(defrule POSSIBLE-MOVE-DETERMINATION::calculate-postflop-bet-size
	?bsh <- (bet_sizing_help (postflop_bet_size -1.0))	; ; postflop bet size not calculated
	(game (pot ?pot))
	=>
	(modify ?bsh (postflop_bet_size (* 0.75 ?pot)))); ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; STRATEGY-SELECTION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::print-win-probability
	(self (win_probability ?win_prob))
	=>
	(printout t "CPP winning probability: " ?win_prob crlf))

(defrule STRATEGY-SELECTION::count-players
	=>
	(bind ?num_players (+ (length$ (find-all-facts ((?p player)) TRUE)) (length$ (find-all-facts ((?s self)) TRUE))))
	(assert (num_players ?num_players))
	(printout t "Counted number of players: " ?num_players crlf))

(defrule STRATEGY-SELECTION::count-raisers
	=>
	(bind ?num_raisers (length$ (find-all-facts ((?p player)) (eq ?p:move ?*RAISE*))))
	(assert (num_raisers ?num_raisers))
	(printout t "Counted number of raisers: " ?num_raisers crlf))

(defrule STRATEGY-SELECTION::count-callers
	=>
	(bind ?num_callers (length$ (find-all-facts ((?p player)) (eq ?p:move ?*CALL*))))
	(assert (num_callers ?num_callers))
	(printout t "Counted number of callers: " ?num_callers crlf))

; ; Consider stacks to be deep if more than half the players (other than myself) have more than or equal to 20 times the min bet
(defrule STRATEGY-SELECTION::check-if-stacks-are-deep
	(num_players ?np)
	(game (min_allowed_bet ?minbet))
	(test 	(> 	(length$ (find-all-facts ((?p player)) 		; ; Number of players (other than self) who has more than 20 times the min bet
										(>= ?p:money (* ?minbet 20.0))))
				(div (- ?np 1) 2)))	; ; Half of the players (other than myself)
	=>
	(assert (stacks_are_deep))
	(printout t "Found that: stacks_are_deep!" crlf))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 3 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-mid-3p
	(num_players 3)
	?self <- (self
				(position 0) 				; ; first bet, but 3 player is small, so consider this as mid position
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-3p
	(num_players 3)
	?self <- (self
				(position 1) 				; ; first bet, but 3 player is small, so consider this as mid position
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-3p
	(num_players 3)
	?self <- (self
				(position 2) 				; ; first bet, but 3 player is small, so consider this as mid position
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 4 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-4p
	(num_players 4)
	?self <- (self
				(position 0)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-4p
	(num_players 4)
	?self <- (self
				(position 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-4p
	(num_players 4)
	?self <- (self
				(position 2)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-4p
	(num_players 4)
	?self <- (self
				(position 3)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 5 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-5p
	(num_players 5)
	?self <- (self
				(position 0)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-5p
	(num_players 5)
	?self <- (self
				(position 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-5p
	(num_players 5)
	?self <- (self
				(position 2)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-5p
	(num_players 5)
	?self <- (self
				(position 3)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-5p
	(num_players 5)
	?self <- (self
				(position 4)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 6 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-6p
	(num_players 6)
	?self <- (self
				(position 0 | 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-6p
	(num_players 6)
	?self <- (self
				(position 2)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-6p
	(num_players 6)
	?self <- (self
				(position 3)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-6p
	(num_players 6)
	?self <- (self
				(position 4)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-6p
	(num_players 6)
	?self <- (self
				(position 5)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 7 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-7p
	(num_players 7)
	?self <- (self
				(position 0 | 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-7p
	(num_players 7)
	?self <- (self
				(position 2 | 3)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-7p
	(num_players 7)
	?self <- (self
				(position 4)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-7p
	(num_players 7)
	?self <- (self
				(position 5)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-7p
	(num_players 7)
	?self <- (self
				(position 6)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 8 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-8p
	(num_players 8)
	?self <- (self
				(position 0 | 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-8p
	(num_players 8)
	?self <- (self
				(position 2 | 3)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-8p
	(num_players 8)
	?self <- (self
				(position 4 | 5)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-8p
	(num_players 8)
	?self <- (self
				(position 6)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-8p
	(num_players 8)
	?self <- (self
				(position 7)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 9 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-9p
	(num_players 9)
	?self <- (self
				(position 0 | 1)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-9p
	(num_players 9)
	?self <- (self
				(position 2 | 3 | 4)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-9p
	(num_players 9)
	?self <- (self
				(position 5 | 6)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-9p
	(num_players 9)
	?self <- (self
				(position 7)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-9p
	(num_players 9)
	?self <- (self
				(position 8)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Determine if position is early/mid/late/small_blind/big_blind (for use when determing strategy) ;
; ; for 10 players																					;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
(defrule STRATEGY-SELECTION::determine-position-type-early-10p
	(num_players 10)
	?self <- (self
				(position 0 | 1 | 2)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_EARLY*)))
(defrule STRATEGY-SELECTION::determine-position-type-mid-10p
	(num_players 10)
	?self <- (self
				(position 3 | 4 | 5)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_MID*)))
(defrule STRATEGY-SELECTION::determine-position-type-late-10p
	(num_players 10)
	?self <- (self
				(position 6 | 7)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))
(defrule STRATEGY-SELECTION::determine-position-type-smallblind-10p
	(num_players 10)
	?self <- (self
				(position 8)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_SMALLBLIND*)))
(defrule STRATEGY-SELECTION::determine-position-type-bigblind-10p
	(num_players 10)
	?self <- (self
				(position 9)
				(position_type nil))		; ; determine position type only once
	=>
	(modify ?self (position_type ?*POSITION_BIGBLIND*)))

; ; Default position (in case it is not a 3-10 player game)
(defrule STRATEGY-SELECTION::determine-position-type-default
	(declare (salience -1))
	?self <- (self (position_type nil))
	=>
	(modify ?self (position_type ?*POSITION_LATE*)))


; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ;
; ; Select strategies ;
; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Pre-flop starting hand selection;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ;
; ; Pairs ;
; ; ; ; ; ;

; ; AA, KK, QQ: raise always (induce folds)
(defrule STRATEGY-SELECTION::select-strategy-preflop-AAKKQQ
	(game (round 0))
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AA*)
							(eq ?ht ?*HAND_KK*)
							(eq ?ht ?*HAND_QQ*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; JJ, TT: induce folds (raise) if no raisers, call if stacks are deep and there are raisers
(defrule STRATEGY-SELECTION::select-strategy-preflop-JJTT-noraisers
	(game (round 0))
	(num_raisers 0)
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_JJ*)
							(eq ?ht ?*HAND_TT*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-JJTT-haveraisers
	(game (round 0) (current_bet ?current_bet))
	(num_raisers ?nr&:(>= ?nr 1))
	(stacks_are_deep)
	(not (move))
	(can_call)
	?self <- (self	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_JJ*)
							(eq ?ht ?*HAND_TT*))))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))		; ; Select move immediately, because this call might not be done in the defensive strategy
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))

; ; 99-22: 	More than 1 raiser, cut losses (fold)
; ;			1 raiser & stacks are deep, call and go defensive
; ;			No raisers & there are callers before me, call and go defensive
; ;			No raisers & no callers before me & early/mid position, cut losses (fold)
; ;			No raisers & no callers before me & late/sb, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-99-22-morethan1raiser
	(game (round 0))
	(num_raisers ?nr&:(> ?nr 1))
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_99-22*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-99-22-1raiser-and-stacks-are-deep
	(game (round 0) (current_bet ?current_bet))
	(num_raisers 1)
	(stacks_are_deep)
	(not (move))
	(can_call)
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_99-22*)))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-99-22-noraisers-and-havecallers-before-me
	(game (round 0) (current_bet ?current_bet))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	(not (move))
	(can_call)
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_99-22*)))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-99-22-noraisers-nocallers-earlymid
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_99-22*))
					(position_type ?pt&:(or
						(eq ?pt ?*POSITION_EARLY*)
						(eq ?pt ?*POSITION_MID*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-99-22-noraisers-nocallers-latesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_99-22*))
					(position_type ?pt&:(or
						(eq ?pt ?*POSITION_LATE*)
						(eq ?pt ?*POSITION_SMALLBLIND*)
						(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; ; ; ; ; ; ; ;
; ; Ace-X hands ;
; ; ; ; ; ; ; ; ;

; ; AKs, AKo: Raise always (induce folds)
(defrule STRATEGY-SELECTION::select-strategy-preflop-AKsAKo
	(game (round 0))
	?self <- (self 	(strategy nil)		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AKs*)
							(eq ?ht ?*HAND_AKo*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; AQs, AQo, AJs: 	Have raisers, cut losses (fold)
; ;					No raisers, have callers, early position, cut losses (fold)
; ;					No raisers, have callers, mid/late/sb/bb position, induce folds (raise)
; ;					No raisers, no callers, early position, cut losses (fold)
; ;					No raisers, no callers, mid/late/sb/bb position, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-AQsAQoAJs-haveraisers
	(game (round 0))
	(num_raisers ?nr&:(>= ?nr 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AQs*)
							(eq ?ht ?*HAND_AQo*)
							(eq ?ht ?*HAND_AJs*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AQsAQoAJs-noraisers-havecallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AQs*)
							(eq ?ht ?*HAND_AQo*)
							(eq ?ht ?*HAND_AJs*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AQsAQoAJs-noraisers-havecallers-midlatesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AQs*)
							(eq ?ht ?*HAND_AQo*)
							(eq ?ht ?*HAND_AJs*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AQsAQoAJs-noraisers-nocallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AQs*)
							(eq ?ht ?*HAND_AQo*)
							(eq ?ht ?*HAND_AJs*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AQsAQoAJs-noraisers-nocallers-midlatesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AQs*)
							(eq ?ht ?*HAND_AQo*)
							(eq ?ht ?*HAND_AJs*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; AJo, ATs, ATo: 	Have raisers, cut losses (fold)
; ;					No raisers, have callers, early position, cut losses (fold)
; ;					No raisers, have callers, mid/late/sb/bb position, induce folds (raise)
; ;					No raisers, no callers, early position, cut losses (fold)
; ;					No raisers, no callers, mid/late/sb/bb position, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-AJoATsATo-haveraisers
	(game (round 0))
	(num_raisers ?nr&:(>= ?nr 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AJo*)
							(eq ?ht ?*HAND_ATs*)
							(eq ?ht ?*HAND_ATo*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AJoATsATo-noraisers-havecallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AJo*)
							(eq ?ht ?*HAND_ATs*)
							(eq ?ht ?*HAND_ATo*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AJoATsATo-noraisers-havecallers-midlatesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AJo*)
							(eq ?ht ?*HAND_ATs*)
							(eq ?ht ?*HAND_ATo*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AJoATsATo-noraisers-nocallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AJo*)
							(eq ?ht ?*HAND_ATs*)
							(eq ?ht ?*HAND_ATo*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-AJoATsATo-noraisers-nocallers-midlatesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
							(eq ?ht ?*HAND_AJo*)
							(eq ?ht ?*HAND_ATs*)
							(eq ?ht ?*HAND_ATo*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; A9s-A2s:	Have raisers, cut losses (fold)
; ;				No raisers, have callers, early/mid position, cut losses (fold)
; ;				No raisers, have callers, late/sb/bb position, call and go defensive
; ;				No raisers, no callers, early/mid position, cut losses (fold)
; ;				No raisers, no callers, late/sb/bb position, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-haveraisers
	(game (round 0))
	(num_raisers ?nr&:(>= ?nr 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_A9s-A2s*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-noraisers-havecallers-earlymid
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_A9s-A2s*))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_EARLY*)
										(eq ?pt ?*POSITION_MID*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-noraisers-havecallers-latesbbb
	(game (round 0) (current_bet ?current_bet))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	(not (move))
	(can_call)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_A9s-A2s*))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-noraisers-nocallers-earlymid
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_A9s-A2s*))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_EARLY*)
										(eq ?pt ?*POSITION_MID*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-noraisers-nocallers-latesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(eq ?ht ?*HAND_A9s-A2s*))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; KQs, KQo, KJs, KJo, QJs:	Have raisers, cut losses (fold)
; ;								No raisers, have callers, early position, cut losses (fold)
; ;								No raisers, have callers, mid/late/sb/bb position, call and go defensive
; ;								No raisers, no callers, early position, cut losses (fold)
; ;								No raisers, no callers, mid/late/sb/bb position, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-KQsKQoKJsKJoQJs-haveraisers
	(game (round 0))
	(num_raisers ?nr&:(>= ?nr 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KQs*)
									(eq ?ht ?*HAND_KQo*)
									(eq ?ht ?*HAND_KJs*)
									(eq ?ht ?*HAND_KJo*)
									(eq ?ht ?*HAND_QJs*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-KQsKQoKJsKJoQJs-noraisers-havecallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KQs*)
									(eq ?ht ?*HAND_KQo*)
									(eq ?ht ?*HAND_KJs*)
									(eq ?ht ?*HAND_KJo*)
									(eq ?ht ?*HAND_QJs*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-KQsKQoKJsKJoQJs-noraisers-havecallers-midlatesbbb
	(game (round 0) (current_bet ?current_bet))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	(not (move))
	(can_call)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KQs*)
									(eq ?ht ?*HAND_KQo*)
									(eq ?ht ?*HAND_KJs*)
									(eq ?ht ?*HAND_KJo*)
									(eq ?ht ?*HAND_QJs*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-KQsKQoKJsKJoQJs-noraisers-nocallers-early
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KQs*)
									(eq ?ht ?*HAND_KQo*)
									(eq ?ht ?*HAND_KJs*)
									(eq ?ht ?*HAND_KJo*)
									(eq ?ht ?*HAND_QJs*)))
					(position_type ?pt&:(eq ?pt ?*POSITION_EARLY*)))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-KQsKQoKJsKJoQJs-noraisers-nocallers-midlatesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KQs*)
									(eq ?ht ?*HAND_KQo*)
									(eq ?ht ?*HAND_KJs*)
									(eq ?ht ?*HAND_KJo*)
									(eq ?ht ?*HAND_QJs*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_MID*)
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))

; ; KTs, KTo,
; ; QJo, QTs,
; ; Q9s, JTs,
; ; J9s, J8s,
; ; T9s, T8s,
; ; 98s, 87s,
; ; 76s, 65s,
; ; 54s:	Have raisers, cut losses (fold)
; ;			No raisers, have callers, early/mid position, cut losses (fold)
; ;			No raisers, have callers, late/sb/bb position, call and go defensive
; ;			No raisers, no callers, early/mid position, cut losses (fold)
; ;			No raisers, no callers, late/sb/bb position, induce folds (raise)
(defrule STRATEGY-SELECTION::select-strategy-preflop-lousyothers-haveraisers
	(game (round 0))
	(num_raisers ?nr&:(>= ?nr 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KTs*) (eq ?ht ?*HAND_KTo*)
									(eq ?ht ?*HAND_QJo*) (eq ?ht ?*HAND_QTs*)
									(eq ?ht ?*HAND_Q9s*) (eq ?ht ?*HAND_JTs*)
									(eq ?ht ?*HAND_J9s*) (eq ?ht ?*HAND_J8s*)
									(eq ?ht ?*HAND_T9s*) (eq ?ht ?*HAND_T8s*)
									(eq ?ht ?*HAND_98s*) (eq ?ht ?*HAND_87s*)
									(eq ?ht ?*HAND_76s*) (eq ?ht ?*HAND_65s*)
									(eq ?ht ?*HAND_54s*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-lousyothers-noraisers-havecallers-earlymid
	(game (round 0))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KTs*) (eq ?ht ?*HAND_KTo*)
									(eq ?ht ?*HAND_QJo*) (eq ?ht ?*HAND_QTs*)
									(eq ?ht ?*HAND_Q9s*) (eq ?ht ?*HAND_JTs*)
									(eq ?ht ?*HAND_J9s*) (eq ?ht ?*HAND_J8s*)
									(eq ?ht ?*HAND_T9s*) (eq ?ht ?*HAND_T8s*)
									(eq ?ht ?*HAND_98s*) (eq ?ht ?*HAND_87s*)
									(eq ?ht ?*HAND_76s*) (eq ?ht ?*HAND_65s*)
									(eq ?ht ?*HAND_54s*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_EARLY*)
										(eq ?pt ?*POSITION_MID*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-lousyothers-noraisers-havecallers-latesbbb
	(game (round 0) (current_bet ?current_bet))
	(num_raisers 0)
	(num_callers ?nc&:(>= ?nc 1))
	(not (move))
	(can_call)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KTs*) (eq ?ht ?*HAND_KTo*)
									(eq ?ht ?*HAND_QJo*) (eq ?ht ?*HAND_QTs*)
									(eq ?ht ?*HAND_Q9s*) (eq ?ht ?*HAND_JTs*)
									(eq ?ht ?*HAND_J9s*) (eq ?ht ?*HAND_J8s*)
									(eq ?ht ?*HAND_T9s*) (eq ?ht ?*HAND_T8s*)
									(eq ?ht ?*HAND_98s*) (eq ?ht ?*HAND_87s*)
									(eq ?ht ?*HAND_76s*) (eq ?ht ?*HAND_65s*)
									(eq ?ht ?*HAND_54s*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(assert (move (move_type ?*CALL*) (current_bet ?current_bet)))
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-lousyothers-noraisers-nocallers-earlymid
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KTs*) (eq ?ht ?*HAND_KTo*)
									(eq ?ht ?*HAND_QJo*) (eq ?ht ?*HAND_QTs*)
									(eq ?ht ?*HAND_Q9s*) (eq ?ht ?*HAND_JTs*)
									(eq ?ht ?*HAND_J9s*) (eq ?ht ?*HAND_J8s*)
									(eq ?ht ?*HAND_T9s*) (eq ?ht ?*HAND_T8s*)
									(eq ?ht ?*HAND_98s*) (eq ?ht ?*HAND_87s*)
									(eq ?ht ?*HAND_76s*) (eq ?ht ?*HAND_65s*)
									(eq ?ht ?*HAND_54s*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_EARLY*)
										(eq ?pt ?*POSITION_MID*))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-preflop-A9s-A2s-noraisers-nocallers-latesbbb
	(game (round 0))
	(num_raisers 0)
	(num_callers 0)
	?self <- (self 	(strategy nil) 		; ; Select strategy once only
					(hand_type ?ht&:(or
									(eq ?ht ?*HAND_KTs*) (eq ?ht ?*HAND_KTo*)
									(eq ?ht ?*HAND_QJo*) (eq ?ht ?*HAND_QTs*)
									(eq ?ht ?*HAND_Q9s*) (eq ?ht ?*HAND_JTs*)
									(eq ?ht ?*HAND_J9s*) (eq ?ht ?*HAND_J8s*)
									(eq ?ht ?*HAND_T9s*) (eq ?ht ?*HAND_T8s*)
									(eq ?ht ?*HAND_98s*) (eq ?ht ?*HAND_87s*)
									(eq ?ht ?*HAND_76s*) (eq ?ht ?*HAND_65s*)
									(eq ?ht ?*HAND_54s*)))
					(position_type ?pt&:(or
										(eq ?pt ?*POSITION_LATE*)
										(eq ?pt ?*POSITION_SMALLBLIND*)
										(eq ?pt ?*POSITION_BIGBLIND*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))



; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Strategy selection during the FLOP;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::select-strategy-flop-induce-bets
	(game (round 1))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(> ?win_prob ?*WINPROB_THRESHOLD_INDUCEBETS*)))
	=>
	(modify ?self (strategy ?*INDUCEBETS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-flop-cut-losses
	(game (round 1))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(and
																(< ?win_prob ?*WINPROB_THRESHOLD_CUTLOSSES*)
																(>= ?win_prob 0.0))))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-flop-continuation-bet
	(game (round 1))
	(previous_strategy (prev_round 0|1) (prev_strat ?prev_strat&:(or (eq ?prev_strat ?*INDUCEBETS_STRATEGY*) (eq ?prev_strat ?*INDUCEFOLDS_STRATEGY*))))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(>= ?win_prob ?*WINPROB_THRESHOLD_CUTLOSSES*)))
	=>
	(modify ?self (strategy ?prev_strat)))
(defrule STRATEGY-SELECTION::select-strategy-flop-bluff
	(game (round 1))
	(previous_strategy (prev_round 0|1) (prev_strat ?prev_strat&:(or
													(eq ?prev_strat ?*CUTLOSSES_STRATEGY*)
													(eq ?prev_strat ?*DEFENSIVE_STRATEGY*))))
	(num_raisers ?nr)
	?self <- (self (strategy nil) (win_probability ?win_prob))
	(or
		(test (and (>= ?win_prob ?*WINPROB_THRESHOLD_DEFENSIVE*) (<= ?win_prob ?*WINPROB_THRESHOLD_INDUCEBETS*)))
		(test (and (>= ?win_prob ?*WINPROB_THRESHOLD_CUTLOSSES*) (< ?win_prob ?*WINPROB_THRESHOLD_DEFENSIVE*)
			(eq ?nr 0))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-flop-defensive
	(game (round 1))
	(num_raisers ?nr&:(> ?nr 0))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(and
																(>= ?win_prob ?*WINPROB_THRESHOLD_CUTLOSSES*)
																(< ?win_prob ?*WINPROB_THRESHOLD_DEFENSIVE*))))
	=>
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))



; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Strategy selection during the RIVER;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::select-strategy-river-induce-bets
	(game (round 3))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(> ?win_prob ?*WINPROB_THRESHOLD_INDUCEBETS*)))
	=>
	(modify ?self (strategy ?*INDUCEBETS_STRATEGY*)))
(defrule STRATEGY-SELECTION::select-strategy-river-bluff
	(game (round 3))
	(previous_strategy (prev_round ~3))
	?self <- (self (strategy nil) (win_probability ?win_prob&:(and
																(> ?win_prob ?*WINPROB_THRESHOLD_DEFENSIVE*)
																(<= ?win_prob ?*WINPROB_THRESHOLD_INDUCEBETS*))))
	=>
	(modify ?self (strategy ?*INDUCEFOLDS_STRATEGY*)))




; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Set strategy to defaults;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::select-strategy-river-default
	(declare (salience -9))		; ; important to cut losses on river as a default
	(game (round 3))
	?self <- (self (strategy nil))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))

; ; If preflop but have no strategy chosen, we should cut losses because we have a bad hand
(defrule STRATEGY-SELECTION::select-strategy-preflop-default
	(declare (salience -10))			; ; Only set default if no other rule set it
	(game (round 0))
	?self <- (self (strategy nil))
	=>
	(modify ?self (strategy ?*CUTLOSSES_STRATEGY*)))



; ; If postflop but have no strategy chosen, follow the previous strategy if there is one
(defrule STRATEGY-SELECTION::select-strategy-postflop-default-previous-strategy
	(declare (salience -10))
	(game (round ?cur_round&:(>= ?cur_round 1)))
	?self <- (self (strategy nil))
	(previous_strategy (prev_round ?prev_round&:(or
													(eq ?prev_round (- ?cur_round 1)) (eq ?prev_round ?cur_round)))
													(prev_strat ?prev_strat))
	=>
	(modify ?self (strategy ?prev_strat)))
; ; If postflop but have no strategy chosen, pick defensive
(defrule STRATEGY-SELECTION::select-strategy-postflop-default
	(declare (salience -11))			; ; Only set default if no other rule set it
	(game (round ?r&:(>= ?r 1)))
	?self <- (self (strategy nil))
	=>
	(modify ?self (strategy ?*DEFENSIVE_STRATEGY*)))



; ; Print out the strategy we are using to select a move
(defrule STRATEGY-SELECTION::print-strategy-used
	(declare (salience -100))
	(not (printed_strategy))
	(self (strategy ?strat&~nil))
	=>
	(assert (printed_strategy))
	(printout t "My strategy: " ?strat crlf))






; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Read the file to 'remember' what    ;
; ; strategy we were using              ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::load-strategy-from-file
	(declare (salience 1))		; ; Loading the previous strategy from the file should be done first
	=>
	(if (eq (open ?*PREVIOUS_STRATEGY_FILENAME* rf) FALSE)
		then
		(open ?*PREVIOUS_STRATEGY_FILENAME* wf "w")
		(printout wf "")
		(close wf)
		(open ?*PREVIOUS_STRATEGY_FILENAME* rf))
	(while (neq (bind ?line (readline rf)) EOF)
		(assert-string ?line))
	(close rf))

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Write the chosen strategy to file   ;
; ; so that in the next rounds we can   ;
; ; remember what we were trying to do  ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::write-strategy-to-file
	(declare (salience -100))
	(not (wrote_strategy_to_file))
	(game (round ?cur_round))
	(self (strategy ?strat&~nil))
	=>
	(assert (wrote_strategy_to_file))
	(open ?*PREVIOUS_STRATEGY_FILENAME* wf "w")
	(printout wf (str-cat
					"(previous_strategy"
					" (prev_round " ?cur_round ")"
					" (prev_strat " ?strat ")"
					")") crlf)
	(close wf))