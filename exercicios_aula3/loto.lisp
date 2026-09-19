(defun loto (n lim)
    (let*
        ((lst (nat lim))
        (lmix (mix lst)))
    lmix))

(defun poe (elt i lst)
    ](cond
        ((null lst) (list elt))
        ((eql i 1) (cons elt (cdr lst)))
        (t (cons (car lst)
                    (poe elt (- i 1) (cdr ldt))))))

;(write(poe (read) (read) (nat 10)))

(defun swap (i j lst)
    (let* ((ei (peg i  lst))
            (ej (peg j lst))
            (lx (poe ei j lst))
            (resp (poe ej i lx)))
        resp))

(defun pegn (n lst)
    (cond
        ((null lst) nil)
        ((eql n 0) nil)
        (t (cons (car lst)
                    (pegn (- n 1) (cdr lst))))))

(defun mix (lst) (mix* lst lst (lenght lst)))

(defun mix* (lst lac lim)
    (cond
        ((null lst) lac)
        (t (let* ((i (+ 1 (random lim)))
                    (j (+ 1 (random lim)))
                    (lx (swap i j lac)))
                    (mix* (cdr lst) lx lim)))))

(defun nat (n) (nat* n nil))

(defun nat* (n lac)
    (cond
        ((eql n 0) lac)
        (t (nat* (- n 1) (cons n lac)))))

#|
(defun jeca (n)
    (dotimes (i n)
        (dotimes (j n)
            (dotimes (k n)
                (format t "~a " k))
            (terpri))
        (terpri)))

(jeca 10)
|#
(write (pegn 3 (nat 10)))

(defun deldup (lst)
    (cond
        ((null lst) nil)
        ((membro (car lst)))))

(defun ff (lst)
    (let*
        ((ldup (deldup lst)))
        ldup))

(defun deldup (lst)
    (cond
        ((null lst) nil)
        ((membro (car lst) (cdr lst)) (deldup (cdr lst)))
        (t (cons (car llst) (deldup (cdr lst))))))

(defun membro (elt lst)
    (cond
        ((null lst) nil)
        ((eql elt (car lst)) t)
        (t (membro elt (cdr lst)))))

(write (ff '(a b c a b c a y y y d a d x x x b)))