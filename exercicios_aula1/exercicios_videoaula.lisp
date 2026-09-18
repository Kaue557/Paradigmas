(defmacro deb (&rest args)
    `(progn
        ,@(mapcar (lambda (x) `(format t "~a: ~s~%" ',x ,x))
            args)))

; SOMA DA LISTA
(defun soma_lst (lst)
    (cond
        ((null lst) 0) ; se lista vazia 
        (t (+ (car lst) (soma_lst (cdr lst)))))) ; cabeça da lista + restante da lista recursivamente

; (write (soma_lst '(1 2 3)))
; (format t "~%")

; MEMBRO DA LISTA
(defun membrop (elt lst)  ; "membro predicado (p) recebe o elemento procurado e a lista"
    (cond
        ((null lst) nil)
        ((eql elt (car lst)) t) ; "se o elemento (elt) for igual (eql) à cabeça da lista retorna true"
        (t (membrop elt (cdr lst)))))

; (write (membrop 3 '(1 2 3)))
; (format t "~%")

; INTERSECÇÃO entre duas listas
(defun inters (l1 l2)
    (cond
        ((null l1) nil)
        ; "a cabeça de l1 está em l2? se sim, coloca na resposta (cons) a cabeça de l1"->
        ; resposta essa que esta sendo criada pelas chamadas recursivas (inters (cdr l1) l2)
        ((membrop (car l1) l2) (cons (car l1) (inters (cdr l1) l2)))
        ; quando a cabeça não é membro de l2, só segue com a chamada recursiva
        (t (inters (cdr l1) l2))))

; (write (inters '(1 2 3 4) '(3 4 5 6)))
; (format t "~%")

; DELETA A PRIMEIRA OCORRÊNCIA
(defun delpri (elt lst)
    (progn ; parada do macro, ignorar
        (deb lst) ; parada do macro, ignorar
        (cond
            ((null lst) nil)
            ; "se o elemento (elt) for igual a cabeça da lista, responda com a cauda" (mesma coisa que deletar)
            ((eql elt (car lst)) (cdr lst))
            ; colocar a cabeça de volta (cons) no começo
            (t (cons (car lst) (delpri elt (cdr lst)))))))

(write (delpri 4 '(1 3 4 4 5 6)))