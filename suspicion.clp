; ; Diagnosis Program for Poker
; ; TEMPLATES

; ; public card
(deftemplate public-card
(slot suit (type SYMBOL))
(slot value (type INTEGER)))

; ; user card
(deftemplate user-card
(slot suit (type SYMBOL))
(slot value (type INTEGER)))

; ; opponent hand suspicion
(deftemplate suspicion
(slot pattern (type SYMBOL) (default one-pair)))

; ; The initial facts
; ; i.e. Player reads his public-cards
(deffacts the-facts
(public-card (suit a) (value 9))
(public-card (suit a) (value 13))
(public-card (suit a) (value 14))
(public-card (suit a) (value 10))
(public-card (suit c) (value 2))
(user-card (suit c) (value 12))
(user-card (suit a) (value 2)))

; ; Suspicion of Royal-Flush
(defrule suspect-royal-flush
(or

(and (public-card (value 10)(suit ?a))(public-card (value 11)(suit ?a))(public-card (value 12)(suit ?a))
(not(user-card (value 13)(suit ?a)))(not(user-card (value 14)(suit ?a))))

(and (public-card (value 10)(suit ?a))(public-card (value 11)(suit ?a))(public-card (value 13)(suit ?a))
(not(user-card (value 12)(suit ?a)))(not(user-card (value 14)(suit ?a))))

(and (public-card (value 10)(suit ?a))(public-card (value 11)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 12)(suit ?a)))(not(user-card (value 13)(suit ?a))))

(and (public-card (value 10)(suit ?a))(public-card (value 12)(suit ?a))(public-card (value 13)(suit ?a))
(not(user-card (value 11)(suit ?a)))(not(user-card (value 14)(suit ?a))))

(and (public-card (value 10)(suit ?a))(public-card (value 12)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 11)(suit ?a)))(not(user-card (value 13)(suit ?a))))

(and (public-card (value 10)(suit ?a))(public-card (value 13)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 11)(suit ?a)))(not(user-card (value 12)(suit ?a))))

(and (public-card (value 11)(suit ?a))(public-card (value 12)(suit ?a))(public-card (value 13)(suit ?a))
(not(user-card (value 10)(suit ?a)))(not(user-card (value 14)(suit ?a))))

(and (public-card (value 11)(suit ?a))(public-card (value 12)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 10)(suit ?a)))(not(user-card (value 13)(suit ?a))))

(and (public-card (value 11)(suit ?a))(public-card (value 13)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 10)(suit ?a)))(not(user-card (value 12)(suit ?a))))

(and (public-card (value 12)(suit ?a))(public-card (value 13)(suit ?a))(public-card (value 14)(suit ?a))
(not(user-card (value 10)(suit ?a)))(not(user-card (value 11)(suit ?a))))

)
=>
(assert (suspicion (pattern suspicion-royal-flush))))

; ; Suspicion of Straight-Flush
(defrule suspect-straight-flush
(or

(and (public-card (value ?num&:(< ?num 10))(suit ?a))
(or
(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))
(not(user-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a)))(not(user-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))))

(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))
(not(user-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a)))(not(user-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))))

(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a)))(not(user-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))))

(and (public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))(public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))
(not(user-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a)))(not(user-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))))

(and (public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a)))(not(user-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))))

(and (public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a)))(not(user-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))))
))

(and (not(user-card (value ?num&:(< ?num 10))(suit ?a)))
(or
(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))(public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))
(not(user-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))))

(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))))

(and (public-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))(public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))))

(and (public-card (value ?num2&:(eq ?num2 (+ ?num 2)))(suit ?a))(public-card (value ?num3&:(eq ?num3 (+ ?num 3)))(suit ?a))(public-card (value ?num4&:(eq ?num4 (+ ?num 4)))(suit ?a))
(not(user-card (value ?num1&:(eq ?num1 (+ ?num 1)))(suit ?a))))

)))
=>
(assert (suspicion (pattern suspicion-straight-flush))))

; ; Suspicion of four-of-a-kind
(defrule suspect-four-of-a-kind
(public-card (value ?num)(suit ?a))
(public-card (value ?num)(suit ?b&:(neq ?a ?b)))
(public-card (value ?num)(suit ?c&:(and (neq ?a ?c)(neq ?b ?c))))
(public-card (value ?num)(suit ?d&:(and (neq ?a ?d)(neq ?b ?d)(neq ?c ?d))))
=>
(assert (suspicion (pattern suspicion-four-of-a-kind))))

; ; Suspicion of full-house
(defrule suspicion-full-house
(public-card (value ?num)(suit ?a))
(public-card (value ?num)(suit ?b&:(neq ?a ?b)))
(public-card (value ?num1&:(neq ?num1 ?num))(suit ?c))
(public-card (value ?num1&:(neq ?num1 ?num))(suit ?d&:(neq ?c ?d)))
(public-card (value ?num1&:(neq ?num1 ?num))(suit ?e&:(and (neq ?c ?e)(neq ?d ?e))))
=>
(assert (suspicion (pattern suspicion-full-house))))

; ; Suspicion of flush
(defrule suspicion-flush
(public-card (suit ?suit)(value ?num1))
(public-card (suit ?suit)(value ?num2&:(neq ?num1 ?num2)))
(public-card (suit ?suit)(value ?num3&:(and (neq ?num3 ?num1)(neq ?num3 ?num2))))
(public-card (suit ?suit)(value ?num4&:(and (and (neq ?num4 ?num1)(neq ?num4 ?num2)) (neq ?num4 ?num3))))
(public-card (suit ?suit)(value ?num5&:(and (and (neq ?num5 ?num1)(neq ?num5 ?num2)) (and (neq ?num5 ?num3) (neq ?num5 ?num4)))))
=>
(assert (suspicion (pattern suspicion-flush))))

; ; Suspicion of straight
(defrule suspicion-straight
(public-card (value ?num&:(< ?num 10))(suit ?suit))
(public-card (value ?num1&:(eq ?num1 (+ ?num 1))))
(public-card (value ?num2&:(eq ?num2 (+ ?num 2))))
(public-card (value ?num3&:(eq ?num3 (+ ?num 3))))
(public-card (value ?num4&:(eq ?num4 (+ ?num 4))))
=>
(assert (suspicion (pattern suspicion-straight))))

; ; Suspicion of three-of-a-kind
(defrule suspicion-three-of-a-kind
(public-card (value ?num)(suit ?a))
(public-card (value ?num)(suit ?b&:(neq ?a ?b)))
(public-card (value ?num)(suit ?c&:(and (neq ?a ?c)(neq ?b ?c))))
=>
(assert (suspicion (pattern suspicion-three-of-a-kind))))

; ; Suspicion of two-pair
(defrule suspicion-two-pair
(public-card (value ?num)(suit ?a))
(public-card (value ?num)(suit ?b&:(neq ?a ?b)))
=>
(assert (suspicion (pattern suspicion-two-pair))))

; ; Print suspicion
(defrule print-suspicion
(suspicion (pattern ?x))
=>
(printout t crlf "Opponent's pattern might be: " ?x "." crlf crlf)(halt))