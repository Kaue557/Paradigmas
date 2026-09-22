(defun ind< (lst)
    (cond
        ((null lst) nil)
        (t (ind<* (cdr lst) (car lst) 1 1))))

(defun ind<* (lst elt i im)
    (cond
        ((null lst) im)
        ((< (car lst) elt) (ind<* (cdr lst) (car lst) (+ i 1) (+ i 1)))
        (t (ind<* (cdr lst) elt (+ i 1) im))))
