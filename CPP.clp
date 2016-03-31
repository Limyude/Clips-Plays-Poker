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
(defglobal ?*CALL* = call)
(defglobal ?*BET* = bet)
(defglobal ?*RAISE* = raise)
(defglobal ?*ALL_IN* = all-in)

; ; POSSIBLE-TO-MOVE? CONSTANTS
; ; These will be asserted as stand-alone facts, so the bot keeps track of the moves it can take
; ; (fold & all_in are always possible to do, so they are not included here)
(defglobal ?*CAN_CHECK* = can_check)
(defglobal ?*CAN_CALL* = can_call)
(defglobal ?*CAN_BET* = can_bet)
(defglobal ?*CAN_RAISE* = can_raise)



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
; ; 6) all-in (amount all-ed in)
(deftemplate MAIN::move
	(slot move_type (type SYMBOL) (default ?DERIVE))
	(slot current_bet (type FLOAT) (default 0.0)))
	

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
	(multislot move (type SYMBOL) (default ?DERIVE)))	; the move that was taken by the player

	
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
(defmodule MOVE-SELECTION (import MAIN ?ALL))




	
; ; Control facts
(deffacts MAIN::control
	(module-sequence OPPONENT-HAND-DETERMINATION OWN-HAND-DETERMINATION STRONGEST-OPPONENT-DETERMINATION SRATEGY-SELECTION MOVE-SELECTION))

	
; ; Control rule to change focus
(defrule MAIN::change-focus
	(declare (salience -1))		; ; Changing focus is least important
	?list <- (module-sequence ?next-module $?other-modules)
	=>
	(printout t "In module " ?next-module " now" crlf)
	(focus ?next-module)
	(retract ?list)
	(assert (module-sequence $?other-modules)))
	

; ; Say "Hello world" upon doing (reset) and (run)
(defrule MAIN::hello-world
	=>
	(printout t "Hello world, we are in the MAIN module!" crlf))    
	
	
; ; The initial facts
(deffacts MAIN::the-facts
	(self (player_id 0) (name "The Bot") (money 13.37))
	(player (player_id 1) (name "Bad Guy 1") (money 13.36))
	(strongest_player (player_id 1))
	(game (round 0) (pot 0.0) (current_bet 0.0) (min_allowed_bet 0.0)))
	
	
	

	
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
	(game (current_bet ?current_bet))
	?self <- (self (money ?mymoney))
	=>
	(assert (move (move_type ?*ALL_IN*) (current_bet ?current_bet)))
	(modify ?self (bet ?mymoney)))
		

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules for selecting move by strategy  ; 
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Cut losses strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::cut-losses-strategy
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*CUTLOSSES_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*CUTLOSSES_STRATEGY* crlf))
	
	
; ; Defensive strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::defensive-strategy
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*DEFENSIVE_STRATEGY* crlf))
	

; ; Induce folds strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::induce-folds-strategy
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*INDUCEFOLDS_STRATEGY* crlf))


; ; Induce bets strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::induce-bets-strategy
	(not (move))							; ; Have not made a move
	(self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*INDUCEBETS_STRATEGY* crlf))

; ; ; ; ; ; ; ; ; ; 
; ; ; ; ; ; ; ; ; ; 
; ; Utility rules ;
; ; ; ; ; ; ; ; ; ; 
; ; ; ; ; ; ; ; ; ; 

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules to determine if can play a certain move (fold/check/all-in/bet/call/raise)  ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Determine if can play fold (can ALWAYS fold)
(defrule MOVE-SELECTION::check-can-fold
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	=>
	(assert (can_fold)))

; ; Determine if can play check
(defrule MOVE-SELECTION::check-can-check
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	(game (current_bet 0.0))		; ; We can only check if nobody has yet placed a bet
	=>
	(assert (can_check)))
	
; ; Determine if can play all-in (can ALWAYS all-in)
(defrule MOVE-SELECTION::check-can-all-in
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	=>
	(assert (can_all_in)))

; ; Determine if can play bet
(defrule MOVE-SELECTION::check-can-bet
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	(game (current_bet 0.0) (min_allowed_bet ?min_allowed_bet))		; ; We can only bet if nobody has yet placed a bet
	(self (money ?money&:(>= ?money ?min_allowed_bet)))				; ; We must have enough money to play at least the minimum bet
	=>
	(assert (can_bet)))

; ; Determine if can play call
(defrule MOVE-SELECTION::check-can-call
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	(game (current_bet ?current_bet&:(> ?current_bet 0.0)))	; ; We can only call if there has been a bet
	(self (money ?money&:(>= ?money ?current_bet)))			; ; We must have enough money to call the bet
	=>
	(assert (can_call)))

; ; Determine if can play raise
(defrule MOVE-SELECTION::check-can-raise
	(declare (salience 5000))		; ; Before selecting a move, it is important to know what moves are legal
	(game (current_bet ?current_bet&:(> ?current_bet 0.0)) (min_allowed_bet ?min_allowed_bet))	; ; We can only raise if there has been a bet
	(self (money ?money&:(>= (- ?money ?current_bet) ?min_allowed_bet)))	; ; We can only raise if we have sufficient money to raise the bet at least by the min_allowed_bet
	=>
	(assert (can_raise)))

	
; ; Print out the move selected
(defrule MOVE-SELECTION::print-move
	(declare (salience -5000))	; ; Printing out a move should be done only when we are actually done selecting, so it is of least concern
	(move (move_type ?move_type) (current_bet ?current_bet))
	=>
	(printout t "Move selected is: " ?move_type)
	(if (subsetp (create$ ?move_type) (create$ ?*FOLD* ?*CALL* ?*BET* ?*RAISE*)) ; ; Each of these moves will have a meaningful current-bet value, so print it
		then
		(printout t " " ?current_bet))
	(printout t crlf))