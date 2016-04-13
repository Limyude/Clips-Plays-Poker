; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; STRATEGY-SELECTION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

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