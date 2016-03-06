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
(card (suit c) (value 9))
(card (suit b) (value 10))
(card (suit d) (value 12))
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

; ; Detection of straight
(defrule straight
(card (value ?num&:(< ?num 10))(suit ?suit))
(card (value ?num1&:(eq ?num1 (+ ?num 1))))
(card (value ?num2&:(eq ?num2 (+ ?num 2))))
(card (value ?num3&:(eq ?num3 (+ ?num 3))))
(card (value ?num4&:(eq ?num4 (+ ?num 4))))
=>
(assert (hand (pattern straight))))

; ; Detection of three-of-a-kind
(defrule three-of-a-kind
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b&:(neq ?a ?b)))
(card (value ?num)(suit ?c&:(and (neq ?a ?c)(neq ?b ?c))))
=>
(assert (hand (pattern three-of-a-kind))))

; ; Detection of two-pair
(defrule two-pair
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b&:(neq ?a ?b)))
(card (value ?num1&:(neq ?num1 ?num))(suit ?c))
(card (value ?num1&:(neq ?num1 ?num))(suit ?d&:(neq ?c ?d)))
=>
(assert (hand (pattern two-pair))))

; ; Detection of one-pair
(defrule one-pair
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b&:(neq ?a ?b)))
=>
(assert (hand (pattern one-pair))))

; ; Print hand
(defrule print-hand
(hand (pattern ?x))
=>
(printout t crlf "Your pattern is: " ?x "." crlf crlf)(halt))