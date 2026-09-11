(defun tam (lst)   ;; tam: nome da funcao, lista: parametro da funcao (tudo em lisp sao listas)
    (cond  ;; permite testar varias condicoes (if eh para maricas).
    ((null lst) 0) ;; lista vazia, tamanho = 0 
    (t (+ 1 (tam (cdr lst))))) ;; t: significa true. Eh como um else para um cond
)


(defun somal (lst)
    (cond 
    ((null lst) 0)
    (t (+ (car lst) 
        (somal (cdr lst))))))


;; Obs: Tudo que responde com true ou false é um predicado! 
;; zeroP, listP, numberP, memberP. P eh de predicate. zeroP -> testa se eh zero 

;; elt: parametro - elementro a ser buscado
;; nil: O false dos cara
;; eql: equal dos cara. Testa se um valor eh igual ao outro
(defun membro (elt lst)
    (cond
    ((null lst) nil) ;; nil eh o false dos caras
    ((eql elt (car lst)) t)
    (t (membro elt (cdr lst)))
    )
)

(defun intersec (l1 l2)
    (cond 
    ((null l1) nil)
    ((membro (car l1) l2) 
        (cons (car l1) (intersec (cdr l1) l2))) ; cons -> insere na lista, fds

    (t (intersec (cdr l1) l2))
    )
)



(defun deleteFirst (elt lst)
    (cond
        ((null lst) nil)
        ((eql elt (car lst)) (cdr lst))
        (t (cons (car lst) (deleteFirst elt (cdr lst))))
    )
)

(defun deleteAll (elt lst)
    (cond
        ((null lst) nil)
        ((eql elt (car lst)) (deleteAll elt (cdr lst)))
        (t (cons (car lst) (deleteAll elt (cdr lst))))
    )
)


(write (deleteAll 4 '(1 2 3 4 4 4 5)))
