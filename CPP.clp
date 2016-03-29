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


; ; ; ; ; ; ; ; ; ; ; ; ;
; ; MODULE DEFINITIONS  ;
; ; ; ; ; ; ; ; ; ; ; ; ;

; ; NOTE THAT CONSTANTS SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT THEM

; ; MODULE DEFINITIONS
(defmodule MAIN (export ?ALL))
(defmodule MOVE-SELECTION (import MAIN ?ALL))





; ; ; ; ; ; ; ; ;
; ; MAIN MODULE ;
; ; ; ; ; ; ; ; ;

	
; ; Control facts
(deffacts MAIN::control
	(module-sequence MOVE-SELECTION))

	
; ; Control rule to change focus
(defrule MAIN::change-focus
	(declare (salience -1))		; ; Changing focus is least important
	?list <- (module-sequence ?next-module $?other-modules)
	=>
	(focus ?next-module)
	(retract ?list)
	(assert (module-sequence $?other-modules)))
	

; ; Say "Hello world" upon doing (reset) and (run)
(defrule MAIN::hello-world
	=>
	(printout t "Hello world" crlf))    
	

; ; Self template
(deftemplate MAIN::self
	(slot player_id (type INTEGER) (default 0))						; player id that should be unique
	(slot name (type STRING) (default "me"))						; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))							; money that I have to play, including the bet I have made
	(slot bet (type FLOAT) (default 0.0))							; the bet that I have made at the moment
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
	(slot current_bet (type FLOAT) (default 0.0))			; the current bet
	(slot min_allowed_bet (type FLOAT) (default 0.0)))		; the minimum bet/raise allowed in the game

	
; ; The strongest player template (contains information filled in by CPP after evaluation of all players except itself)
(deftemplate MAIN::strongest-player
	(slot player_id (type INTEGER) (default 0))								; player id of the strongest player
	(slot lose-to-cpp-probability (type FLOAT) (default 0.0))				; probability of the strongest player losing to me
	(slot likely-type-of-hand (type SYMBOL) (default ?*MARGINAL_HAND*)))	; likely type of hand of the strongest player
	
	
; ; The initial facts
(deffacts MAIN::the-facts
	(self (player_id 0) (name "Allwin Baby") (money 13.37))
	(player (player_id 1) (name "Bad Guy 1") (money 13.36))
	(strongest-player (player_id 1))
	(game (round 0) (pot 0.0) (current_bet 3.35) (min_allowed_bet 0.0)))
	
	
	
	
	
	
; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; MOVE-SELECTION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Rules for selecitng move  ; 
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; Cut losses strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::cut-losses-strategy
	(self (strategy ?strat&:(eq ?strat ?*CUTLOSSES_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*CUTLOSSES_STRATEGY* crlf))
	
	
; ; Defensive strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::defensive-strategy
	(self (strategy ?strat&:(eq ?strat ?*DEFENSIVE_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*DEFENSIVE_STRATEGY* crlf))
	

; ; Induce folds strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::induce-folds-strategy
	(self (strategy ?strat&:(eq ?strat ?*INDUCEFOLDS_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*INDUCEFOLDS_STRATEGY* crlf))


; ; Induce folds strategy
; ; *********** TO DO ***********
(defrule MOVE-SELECTION::induce-bets-strategy
	(self (strategy ?strat&:(eq ?strat ?*INDUCEBETS_STRATEGY*)))
	=>
	(printout t "My strategy: " ?*INDUCEBETS_STRATEGY* crlf))