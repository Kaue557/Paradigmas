; CODIGO QUE NAO SEI DE ONDE É
; FALTA O DELDUP, RESTO DO quantif* E ALGO MAIS(?)
(defun quantif (lst) (quantif* (deldup lst) lst))

(defun quantif* (lst lor)
    (cond
        ((null lst) nil)))


;FF -> NÃO SEI O QUE É ISSO
(defun ff(lst)
    (let* ((lqua (quantif lst))
        (lord (ms lqua))
        (lgru (agrupa lord)))
    lgru))

;AGRUPA
(defun agrupa (lst)
    (cond
        ((null lst) nil)
        (t (agrupa* (cdr lst) (list (car lst))))))

;AGRUPA*
(defun agrupa* (lst lac)
    (cond
        ((null lst) (list lac))
        (t (let* ((d1 (car lst))
        (d2 (car lac))
        (n1 (cadr d1))
        (n2 (cadr d2)))
    (cond
        ((eql n1 n2) (agrupa* (cdr lst) (cons d1 lac)))
        (t (cons lac (agrupa* (cdr lst) (list d1)))))))))
