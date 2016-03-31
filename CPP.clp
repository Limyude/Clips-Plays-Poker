; ; This is the Clips Plays Poker bot!!!


; ; ; ; ; ; ; ;
; ; CONSTANTS ;
; ; ; ; ; ; ; ;

; ; NOTE THAT CONSTANTS SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT THEM

; ; STRATEGY CONSTANTS
(defglobal ?*CUTLOSSES_STRATEGY* = cut-losses)						; moves to take: check/fold (like when the villain obviously has a monster hand)
(defglobal ?*DEFENSIVE_STRATEGY* = defensive)						; moves to take: small bet/check/fold if necessary (like when playing against a possibly strong marginal/monster hand with a marginal hand)
(defglobal ?*INDUCEFOLDS_STRATEGY* = induce-folds)					; moves to take: bluff (like when playing against a possibly weak marginal hand with an air hand)
(defglobal ?*INDUCEBETS_STRATEGY* = induce-bets)					; moves to take: small bet/check (like when against an air hand)

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



; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; MAIN MODULE ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ;
	
	
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
	

; ; Self template
(deftemplate MAIN::self
	(slot player_id (type INTEGER) (default 0))						; player id that should be unique
	(slot name (type STRING) (default "me"))						; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))							; money that I have to play, including the bet I have made
	(slot bet (type FLOAT) (default 0.0))							; the bet that I have made at the moment (which must be forfeited when folding)
	(slot strategy (type SYMBOL) (default ?*DEFENSIVE_STRATEGY*)))	; the strategy being adopted by myself

	
; ; Player template (players other than myself)
(deftemplate MAIN::player
	(slot player_id (type INTEGER) (default 0)) 		; player id that should be unique
	(slot name (type STRING) (default "nameless"))		; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))				; money that the player has to play, excluding the bet they have made
	(slot bet (type FLOAT) (default 0.0))				; the bet that the player has made at the moment
	(slot move (type SYMBOL)))							; the move that was taken by the player

	
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

; ; NOTE THAT CONSTANTS SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT/IMPORT THEM

; ; MODULE DEFINITIONS
(defmodule MAIN (export ?ALL))
(defmodule OPPONENT-HAND-DETERMINATION (import MAIN ?ALL))
(defmodule OWN-HAND-DETERMINATION (import MAIN ?ALL))
(defmodule STRONGEST-OPPONENT-DETERMINATION (import MAIN ?ALL))
(defmodule STRATEGY-SELECTION (import MAIN ?ALL))
(defmodule POSSIBLE-MOVE-DETERMINATION (import MAIN ?ALL))
(defmodule MOVE-SELECTION (import MAIN ?ALL))




	
; ; Control facts
(deffacts MAIN::control
	(module-sequence 
		OPPONENT-HAND-DETERMINATION 
		OWN-HAND-DETERMINATION 
		STRONGEST-OPPONENT-DETERMINATION 
		STRATEGY-SELECTION 
		POSSIBLE-MOVE-DETERMINATION 
		MOVE-SELECTION))

	
; ; Control rule to change focus
(defrule MAIN::change-focus
	(declare (salience -1))		; ; Changing focus is least important
	?list <- (module-sequence ?next-module $?other-modules)
	=>
	(printout t "In module " ?next-module " now" crlf)
	(focus ?next-module)
	(retract ?list)
	(assert (module-sequence $?other-modules)))
	
	
; ; The initial facts
(deffacts MAIN::the-facts
	(self (player_id 0) (name "The Bot") (money 13.37) (bet 0.0) (strategy ?*INDUCEBETS_STRATEGY*))
	(player (player_id 1) (name "Bad Guy 1") (money 13.36) (bet 0.0) (move nil))
	(strongest_player (player_id 1) (lose_to_cpp_probability 0.0) (likely_type_of_hand ?*MARGINAL_HAND*))
	(game (round 0) (pot 0.0) (current_bet 0.0) (min_allowed_bet 1.0)))
	
	
	

	
; ; ; ; ; ; ; ; ; ; ; ; ; ; 
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
	
	

; ; Induce folds strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::induce-folds-strategy
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*INDUCEFOLDS_STRATEGY* crlf))


; ; Induce bets strategy
; ; When able to do both check/bet, randomly pick one, favouring value bet over check
(defrule MOVE-SELECTION::induce-bets-strategy-randomly-value-bet-or-check
	(not (move))							; ; Have not made a move
	?self <- (self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	(can_bet)
	(can_check)
	(game (min_allowed_bet ?minbet))
	=>
	(bind ?roll (mod (random) 4))
	; ; ; (printout t "Rolled [0-3] a " ?roll crlf)	; ; For debugging purposes
	(if (>= ?roll 3)	; ; 1 in 4 chance to check instead of value bet
		then
		(assert (move (move_type ?*CHECK*)))
		else
		(assert (move (move_type ?*BET*) (current_bet ?minbet)))
		(modify ?self (bet ?minbet))))
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
	(game (min_allowed_bet ?minbet))
	=>
	(assert (move (move_type ?*BET*) (current_bet ?minbet)))
	(modify ?self (bet ?minbet)))
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
	
; ; Print out the strategy we are using to select a move
(defrule MOVE-SELECTION::print-strategy-used
	(declare (salience 1))
	(self (strategy ?strat))
	=>
	(printout t "My strategy: " ?strat crlf))

	
; ; Print out the move selected
(defrule MOVE-SELECTION::print-move
	(declare (salience -5000))	; ; Printing out a move should be done only when we are actually done selecting, so it is of least concern
	(move (move_type ?move_type) (current_bet ?current_bet))
	=>
	(printout t "Move selected is: " ?move_type)
	(if (subsetp (create$ ?move_type) (create$ ?*FOLD* ?*CALL* ?*BET* ?*RAISE* ?*ALL_IN*)) ; ; Each of these moves will have a meaningful current-bet value, so print it
		then
		(printout t " $" ?current_bet))
	(printout t crlf))
	

	
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
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