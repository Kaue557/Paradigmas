(defun bsort (lst) (bsort* lst lst))

(defun bsort* (lst lac)
    (cond
        ((null lst) lac)
        (t (bsort* (cdr lst) (levamaior lac)))))

(defun levamaior (lst)
    (cond
        ((null lst) nil)
        ((null (cdr lst)) lst)
        (t (let* ((e1 (car lst))
                (e2 (cadr lst)))
            (cond
                ((<= e1 e2) (cons e1 (levamaior (cdr lst))))
                (t (cons e2 (levamaior (cons e1 (cddr lst))))))))))

(write (bsort '(90 12 34 56 78 8 0)))
(terpri)