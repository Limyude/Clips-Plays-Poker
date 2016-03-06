; ; Diagnosis Program for Poker
; ; TEMPLATES

; ; individual card
(deftemplate card
(slot suit (type SYMBOL))
(slot value (type INTEGER)))

; ; poker hand
(deftemplate hand
(slot pattern (type SYMBOL)))

; ; Detection of Royal-Flush
(defrule royal-flush
(card (value 10)(suit ?suit))
(card (value 11)(suit ?suit)) ; J ;
(card (value 12)(suit ?suit)) ; Q ;
(card (value 13)(suit ?suit)) ; K ;
(card (value 14)(suit ?suit)) ; A ;
=>
(assert (hand (pattern royal-flush))))

; ; Detection of Straight-Flush
(defrule straight-flush
(card (value ?num&:(< ?num 10))(suit ?suit))
(card (value ?num+1)(suit ?suit))
(card (value ?num+2)(suit ?suit))
(card (value ?num+3)(suit ?suit))
(card (value ?num+4)(suit ?suit))
=>
(assert (hand (pattern straight-flush))))

