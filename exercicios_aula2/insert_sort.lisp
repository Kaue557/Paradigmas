(defun isort (lst) (isort* lst nil))

(defun isort* (lst lac)
    (cond
        ((null lst) lac)
        (t (isort* (cdr lst) (insere (car lst) lac)))))

(defun insere (elt lst)
    (cond
        ((null lst) (list elt))
        ((<= elt (car lst)) (cons elt lst))
        (t (cons (car lst) (insere elt (cdr lst))))))

(write (isort '(3 5 2 1 78 55)))