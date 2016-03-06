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
(card (suit a) (value 9))
(card (suit a) (value 10))
(card (suit a) (value 11))
(card (suit a) (value 12))
(card (suit a) (value 13)))

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

; ; Detection of full-house
(defrule full-house
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b&:(neq ?a ?b)))
(card (value ?num1)(suit ?c))
(card (value ?num1)(suit ?d&:(neq ?c ?d)))
(card (value ?num1)(suit ?e&:(and (neq ?c ?e)(neq ?d ?e))))
=>
(assert (hand (pattern full-house))))

; ; Detection of flush
(defrule flush
(card (suit ?suit)(value ?num1))
(card (suit ?suit)(value ?num2&:(neq ?num1 ?num2)))
(card (suit ?suit)(value ?num3&:(and (neq ?num3 ?num1)(neq ?num3 ?num2))))
(card (suit ?suit)(value ?num4&:(and (and (neq ?num4 ?num1)(neq ?num4 ?num2)) (neq ?num4 ?num3))))
(card (suit ?suit)(value ?num5&:(and (and (neq ?num5 ?num1)(neq ?num5 ?num2)) (and (neq ?num5 ?num3) (neq ?num5 ?num4)))))
=>
(assert (hand (pattern flush))))

; ; Detection of straight
(defrule straight
(card (value ?num&:(< ?num 10))(suit ?suit))
(card (value ?num1&:(eq ?num1 (+ ?num 1))))
(card (value ?num2&:(eq ?num2 (+ ?num 2))))
(card (value ?num3&:(eq ?num3 (+ ?num 3))))
(card (value ?num4&:(eq ?num4 (+ ?num 4))))
=>
(assert (hand (pattern straight))))

; ; Print hand
(defrule print-hand
(hand (pattern ?x))
=>
(printout t crlf "Your pattern is: " ?x "." crlf crlf)(halt))