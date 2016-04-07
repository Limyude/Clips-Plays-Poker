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
	
; ; Print out the strategy we are using to select a move
(defrule MOVE-SELECTION::print-strategy-used
	(declare (salience 1))
	(not (printed_strategy))
	(self (strategy ?strat))
	=>
	(assert (printed_strategy))
	(printout t "My strategy: " ?strat crlf))

	
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
	(printout t crlf))