:------------------------
; MENOR DA LISTA
:------------------------
(defun menor (lst) (menor* (cdr lst) (car lst)))

(defun menor* (lst men)
    (cond
        ((null lst) men)
        ((< (car lst) men) (menor* (cdr lst) (car lst)))
        (t (menor* (cdr lst) men))))

;(menor '(5 2 8)) 
;(menor* (2 8) 5)
;(menor* '(8) 5)
(write (menor '(2 3 4)))

(format t "~%")

:------------------------
; MEDIA ACUM
:------------------------
(defun media (lst) (media* lst 0 0))

(defun media* (lst soma n)
    (cond
        ((null lst) (/ soma n))
        (t (media* (cdr lst) (+ soma (car lst)) (+ n 1)))))

(write (media '(1 2 3 4 5)))

(format t "~%")

:------------------------
; INVERTER LISTA
:------------------------
(defun rev (lst) (rev* lst nil))

(defun rev* (lst lac)
    (cond
        ((null lst) lac)
        (t (rev* (cdr lst) (cons (car lst) lac)))))

(write (rev '(1 2 3)))

(format t "~%")

:------------------------
; PRIMEIROS NATURAIS
:------------------------
(defun nat (n) (nat* n nil))

(defun nat* (n lac)
    (cond
        ((eql n 0) lac)
        (t (nat* (- n 1) (cons n lac)))))

(write (nat 50))