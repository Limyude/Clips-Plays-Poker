; ; This is the Clips Plays Poker bot!!!

; ; Say "Hello world" upon doing (reset) and (run)
(defrule hello_world
	(initial-fact)
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
	(slot round (type INTEGER) (default 0))			; the rounds are as follows: 0) pre-flop, 1) flop, 2) turn, 3) river (final round)
	(slot pot (type FLOAT) (default 0.0))			; the pot starts with no money, and fills up with player bets as the game progresses through the rounds
	(slot call_amount (type FLOAT) (default 0.0))	; amount being called
	(slot fold_amount (type FLOAT) (default 0.0))) 	; amount needed to fold
	