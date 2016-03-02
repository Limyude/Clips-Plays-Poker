; ; This is the Clips Plays Poker bot!!!

; ; Say "Hello world" upon doing (reset) and (run)
(defrule hello-world
	=>
	(printout t "Hello world" crlf))    
	

; ; Self template
(deftemplate self
	(slot player_id (type INTEGER) (default 0))	; player id that should be unique
	(slot name (type STRING) (default "me"))	; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))		; money that I have to play, excluding the bet I have made
	(slot bet (type FLOAT) (default 0.0)))		; the bet that I have made at the moment

	
; ; Player template (players other than myself)
(deftemplate player
	(slot player_id (type INTEGER) (default 0)) 	; player id that should be unique
	(slot name (type STRING) (default "nameless"))	; name MIGHT NOT be unique
	(slot money (type FLOAT) (default 0.0))			; money that the player has to play, excluding the bet they have made
	(slot bet (type FLOAT) (default 0.0)))			; the bet that the player has made at the moment

	
; ; Game template (keeps the game information)
(deftemplate game
	(slot round (type INTEGER) (default 0))					; the rounds are as follows: 0) pre-flop, 1) flop, 2) turn, 3) river (final round)
	(slot pot (type FLOAT) (default 0.0))					; the pot starts with no money, and fills up with player bets as the game progresses through the rounds
	(slot call_amount (type FLOAT) (default 0.0))			; amount being called
	(slot fold_amount (type FLOAT) (default 0.0)) 			; amount needed to fold
	(slot max_allowed_bet (type FLOAT) (default 10.00)))	; maximum bet allowed in the game
	
	
; ; The initial facts
(deffacts the-facts
	(self (player_id 0) (name "Allwin Baby") (money 13.37))
	(player (player_id 1) (name "Bad Guy 1") (money 13.36))
	(game (round 0) (pot 0.0) (call_amount 3.35) (fold_amount 0.02)))
	
	
; ; Function - Check if there is not enough money to continue until the end of the game,
; ; given a number of rounds left all played with a certain call amount, and the player's remaining money.
(deffunction nomoney (?roundsleft ?callamt ?money)
	(bind ?need (* ?roundsleft ?callamt))
	(if (< ?money ?need)
		then
			TRUE
		else
			FALSE))
		
	
	
; ; Rule - no money to play the remaining rounds FOR SURE, so its time to fold.
; ; This could happen! E.g. Round 0 now, $1.00 in hand, need to pay $0.30 for a call from now,
; ; so 4 rounds = 4 * $0.30 = $1.20... NOT ENOUGH!
(defrule no-money-fold
	(game (call_amount ?callamt) (round ?round))
	(self (money ?mymoney) (bet ?mybet))
	(or (test (< (- ?mymoney (- ?callamt ?mybet)) 0.0))	; Check if I can even match the call
		(test (nomoney (- 3 ?round) ?callamt (- ?mymoney (- ?callamt ?mybet))))) ; Check if I can match the call for the remaining rounds after this
	=>
	(printout t "To match the current call amount of $" ?callamt 
				", I need to add $" (- ?callamt ?mybet) 
				" to my current bet of $" ?mybet "." crlf)
	(printout t "I should fold, because I do not have enough money to finish the remaining " (- 3 ?round)
				" rounds of the game assuming $" ?callamt " per call, after this round." crlf))