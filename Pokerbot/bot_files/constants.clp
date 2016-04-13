; ; ; ; ; ; ; ;
; ; CONSTANTS ;
; ; ; ; ; ; ; ;

; ; NOTE THAT CONSTANTS/TEMPLATES SHOULD BE DEFINED BEFORE EXPORT/IMPORT IF WE WANT TO EXPORT THEM

; ; FILENAME CONSTANTS
(defglobal ?*PLAYER_MOVECOUNT_FILENAME* = player_move_count.txt)

; ; PLAYER ATTRIBUTE CONSTANTS
(defglobal ?*TIGHT* = tight)
(defglobal ?*LOOSE* = loose)
(defglobal ?*AGGRESSIVE* = aggressive)
(defglobal ?*PASSIVE* = passive)

; ; STRATEGY CONSTANTS
(defglobal ?*CUTLOSSES_STRATEGY* = cut-losses)						; moves to take: check/fold (like when the villain obviously has a monster hand)
(defglobal ?*DEFENSIVE_STRATEGY* = defensive)						; moves to take: small bet/check/fold if necessary (like when playing against a possibly strong marginal/monster hand with a marginal hand)
(defglobal ?*INDUCEFOLDS_STRATEGY* = induce-folds)					; moves to take: bluff (like when playing against a possibly weak marginal hand with an air hand)
(defglobal ?*INDUCEBETS_STRATEGY* = induce-bets)					; moves to take: value bet/check (like when against an air hand)

; ; TYPE OF HAND CONSTANTS
(defglobal ?*AIR_HAND* = air-hand)
(defglobal ?*MARGINAL_HAND* = marginal-hand)
(defglobal ?*MONSTER_HAND* = monster-hand)

; ; TYPE OF MOVE CONSTANTS
(defglobal ?*FOLD* = fold)
(defglobal ?*CHECK* = check)
(defglobal ?*BET* = bet)
(defglobal ?*CALL* = call)
(defglobal ?*RAISE* = raise)
(defglobal ?*ALL_IN* = all-in)

; ; LOCATION CONSTANTS
(defglobal ?*LOCATION_HOLE* = hole)		; ; Hole cards are the face-down cards (in your hand)
(defglobal ?*LOCATION_BOARD* = board)	; ; Board cards are the face-up cards

; ; POSITION TYPE CONSTANTS (for use when selecting strategy)
(defglobal ?*POSITION_EARLY* = early)
(defglobal ?*POSITION_MID* = mid)
(defglobal ?*POSITION_LATE* = late)
(defglobal ?*POSITION_SMALLBLIND* = small_blind)
(defglobal ?*POSITION_BIGBLIND* = big_blind)

; ; HAND TYPE CONSTANTS
(defglobal ?*HAND_AA* = AA)
(defglobal ?*HAND_QQ* = KK)
(defglobal ?*HAND_KK* = QQ)

(defglobal ?*HAND_JJ* = JJ)
(defglobal ?*HAND_TT* = TT)

(defglobal ?*HAND_99-22* = 99-22)

(defglobal ?*HAND_AKs* = AKs)
(defglobal ?*HAND_AKo* = AKo)

(defglobal ?*HAND_AQs* = AQs)
(defglobal ?*HAND_AQo* = AQo)
(defglobal ?*HAND_AJs* = AJs)

(defglobal ?*HAND_AJo* = AJo)
(defglobal ?*HAND_ATs* = ATs)
(defglobal ?*HAND_ATo* = ATo)

(defglobal ?*HAND_A9s-A2s* = A9s-A2s)

(defglobal ?*HAND_KQs* = KQs)
(defglobal ?*HAND_KQo* = KQo)
(defglobal ?*HAND_KJs* = KJs)
(defglobal ?*HAND_KJo* = KJo)
(defglobal ?*HAND_QJs* = QJs)

(defglobal ?*HAND_KTs* = KTs)
(defglobal ?*HAND_KTo* = KTo)
(defglobal ?*HAND_QJo* = QJo)
(defglobal ?*HAND_QTs* = QTs)
(defglobal ?*HAND_Q9s* = Q9s)
(defglobal ?*HAND_JTs* = JTs)
(defglobal ?*HAND_J9s* = J9s)
(defglobal ?*HAND_J8s* = J8s)
(defglobal ?*HAND_T9s* = T9s)
(defglobal ?*HAND_T8s* = T8s)
(defglobal ?*HAND_98s* = 98s)
(defglobal ?*HAND_87s* = 87s)
(defglobal ?*HAND_76s* = 76s)
(defglobal ?*HAND_65s* = 65s)
(defglobal ?*HAND_54s* = 54s)

(defglobal ?*HAND_BADHAND* = bad_hand)