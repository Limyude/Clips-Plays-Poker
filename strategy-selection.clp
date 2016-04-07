; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; STRATEGY-SELECTION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule STRATEGY-SELECTION::count-players
	=>
	(assert (num_players (+ (length$ (find-all-facts ((?p player)) TRUE)) (length$ (find-all-facts ((?s self)) TRUE))))))

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
	

; ; ; ; ; ; ; ; ; ; ; ;
; ; Select strategies ;
; ; ; ; ; ; ; ; ; ; ; ;