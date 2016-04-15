; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; OWN-HAND-DETERMINATION MODULE ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

; ; ; ; ; ; ;
; ; ; ; ; ; ;
; ; Pairs ; ;
; ; ; ; ; ; ;
; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-AA
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_AA*))
	(printout t "Hand is: AA" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KK
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_KK*))
	(printout t "Hand is: KK" crlf))	
(defrule OWN-HAND-DETERMINATION::determine-handtype-QQ
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_QQ*))
	(printout t "Hand is: QQ" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-JJ
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_JJ*))
	(printout t "Hand is: JJ" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-TT
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_TT*))
	(printout t "Hand is: TT" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-99-22
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	?card1 <- (card (value ?v&:(and (<= ?v 9) (>= ?v 2))) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	?card2 <- (card (value ?v) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(test (neq ?card1 ?card2))
	=>
	(modify ?self (hand_type ?*HAND_99-22*))
	(printout t "Hand is: 99-22" crlf))
	
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;
; ; Ace-X Hands ; ;
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-AKs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AKs*))
	(printout t "Hand is: AKs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AKo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AKo*))
	(printout t "Hand is: AKo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AQs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AQs*))
	(printout t "Hand is: AQs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AQo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AQo*))
	(printout t "Hand is: AQo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AJs*))
	(printout t "Hand is: AJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-AJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_AJo*))
	(printout t "Hand is: AJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-ATs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_ATs*))
	(printout t "Hand is: ATs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-ATo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_ATo*))
	(printout t "Hand is: ATo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-A9s-A2s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 14) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value ?v2&:(and (<= ?v2 9) (>= ?v2 2))) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_A9s-A2s*))
	(printout t "Hand is: A9s-A2s" crlf))

; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; 
; ; Playable Hands;
; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-KQs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KQs*))
	(printout t "Hand is: KQs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KQo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KQo*))
	(printout t "Hand is: KQo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KJs*))
	(printout t "Hand is: KJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KJo*))
	(printout t "Hand is: KJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QJs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QJs*))
	(printout t "Hand is: QJs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KTs*))
	(printout t "Hand is: KTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-KTo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 13) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_KTo*))
	(printout t "Hand is: KTo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QJo
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s1) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ~?s1) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QJo*))
	(printout t "Hand is: QJo" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-QTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_QTs*))
	(printout t "Hand is: QTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-Q9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 12) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_Q9s*))
	(printout t "Hand is: Q9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-JTs
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_JTs*))
	(printout t "Hand is: JTs" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-J9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_J9s*))
	(printout t "Hand is: J9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-J8s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 11) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_J8s*))
	(printout t "Hand is: J8s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-T9s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_T9s*))
	(printout t "Hand is: T9s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-T8s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 10) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_T8s*))
	(printout t "Hand is: T8s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-98s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 9) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_98s*))
	(printout t "Hand is: 98s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-87s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 8) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 7) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_87s*))
	(printout t "Hand is: 87s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-76s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 7) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 6) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_76s*))
	(printout t "Hand is: 76s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-65s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 6) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 5) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_65s*))
	(printout t "Hand is: 65s" crlf))
(defrule OWN-HAND-DETERMINATION::determine-handtype-54s
	?self <- (self (hand_type nil))							; ; Determine hand type only once
	(card (suit ?s) (value 5) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	(card (suit ?s) (value 4) (location ?loc&:(eq ?loc ?*LOCATION_HOLE*)))
	=>
	(modify ?self (hand_type ?*HAND_54s*))
	(printout t "Hand is: 54s" crlf))
	
	
	
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; Set hand type to a bad hand if no other rule set it ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;
; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;

(defrule OWN-HAND-DETERMINATION::determine-handtype-badhand
	(declare (salience -1))			; ; Least salient (since it is a default fail-safe value)
	?self <- (self (hand_type nil))
	=>
	(modify ?self (hand_type ?*HAND_BADHAND*))
	(printout t "Hand is: bad_hand" crlf))