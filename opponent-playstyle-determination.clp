; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
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
	(close wf))