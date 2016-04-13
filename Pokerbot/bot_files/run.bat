; ; Clear the working memory of everything
(clear)

; ; constants.clp -> CPP.clp order should be retained to properly export stuff (exports/imports happen at the end of CPP.clp)
(load constants.clp)
(load CPP.clp)

; ; Load all modules 
(load opponent-playstyle-determination.clp)
(load own-hand-determination.clp)
(load strategy-selection.clp)
(load possible-move-determination.clp)
(load move-selection.clp)

; ; Insert the facts and rules into working memory, and run it!
(reset)
(run)
