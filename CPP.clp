; ; This is the Clips Plays Poker bot!!!

; ; Say "Hello world" upon doing (reset) and (run)
(defrule hello_world
    (initial-fact)
    =>
    (printout t "Hello world" crlf))