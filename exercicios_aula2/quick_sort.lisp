(defun qs (lst)
    (cond
        ((null lst) nil)
        ((null (cdr lst)) lst)
        (t (let* ((p (car lst))
                (dupla (partit p (cdr lst)))
                (lmen (first dupla))
                (lmai (second dupla)))
            (append (qs lmen) (list p) (qs lmai))))))

(defun partit (p lst) (partit* p lst nil nil))

(defun partit* (p lst lmen lmai)
    (cond
        ((null lst ) (list lmen lmai))
        ((<= (car lst) p) (partit* p (cdr lst) (cons (car lst) lmen) lmai))
        (t (partit* p (cdr lst) lmen (cons (car lst) lmai)))))

(write (partit 10 '(12 1 6 7 78 34 21 9 10)))
(terpri)