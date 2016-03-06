; ; Diagnosis Program for Poker
; ; TEMPLATES

; ; individual card
(deftemplate card
(slot suit (type SYMBOL))
(slot value (type INTEGER)))

; ; poker hand
(deftemplate hand
(slot pattern (type SYMBOL)))

; ; The initial facts
; ; i.e. Player reads his cards
(deffacts the-facts
(card (suit a) (value 10))
(card (suit b) (value 10))
(card (suit c) (value 10))
(card (suit d) (value 10))
(card (suit a) (value 8)))

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

; ; Detection of four-of-a-kind
(defrule four-of-a-kind
(card (value ?num)(suit ?a))
(card (value ?num)(suit ?b))
(card (value ?num)(suit ?c))
(card (value ?num)(suit ?d))
=>
(assert (hand (pattern four-of-a-kind))))

; ; Print hand
(defrule print-hand
(hand (pattern ?x))
=>
(printout t crlf "Your pattern is: " ?x "." crlf crlf)(halt))