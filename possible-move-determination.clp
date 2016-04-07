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
	(printout t "Number of limpers: " ?limper_count crlf))
	
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
	(modify ?bsh (postflop_bet_size (* 0.75 ?pot))))