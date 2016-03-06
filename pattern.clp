; ; Diagnosis Program for Poker
; ; TEMPLATES

; ; individual card
(deftemplate card
(slot suit (type SYMBOL))
(slot value (type INTEGER)))

; ; poker hand
(deftemplate hand
(slot pattern (type SYMBOL) (default NIL)))

; ; The initial facts
; ; i.e. Player reads his cards
(deffacts the-facts
(card (suit i) (value 9))
(card (suit i) (value 10))
(card (suit i) (value 11))
(card (suit i) (value 12))
(card (suit i) (value 13)))

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
(card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?suit))
(card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?suit))
(card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?suit))
(card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?suit))
=>
(assert (hand (pattern straight-flush))))

; ; Detection of four-of-a-kind
(defrule four-of-a-kind
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b&:(neq ?a ?b)))
(card (value ?num)(suit ?c&:(and (neq ?a ?c)(neq ?b ?c))))
(card (value ?num)(suit ?d&:(and (neq ?a ?d)(neq ?b ?d)(neq ?c ?d))))
=>
(assert (hand (pattern four-of-a-kind))))

; ; Print hand
(defrule print-hand
(hand (pattern ?x))
=>
(printout t crlf "Your pattern is: " ?x "." crlf crlf)(halt))