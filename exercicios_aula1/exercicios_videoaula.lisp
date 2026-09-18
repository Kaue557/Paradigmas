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

; (write (delpri 4 '(1 3 4 4 5 6)))
; (format t "~%")

; DELETA TODAS AS OCORRÊNCIAS
(defun delall (elt lst)
    (progn ; parada do macro, ignorar
        (deb lst) ; parada do macro, ignorar
        (cond
            ((null lst) nil)
            ; "se o elemento (elt) for igual a cabeça da lista, pula ele e não coloca no resultado -> (delall elt (cdr lst))"
            ((eql elt (car lst)) (delall elt (cdr lst)))
            ; senão, coloca o valor (que nao será deletado) na cabeça do resultado e chama a função recursivamente
            (t (cons (car lst) (delall elt (cdr lst)))))))

; (write (delall 5 '(3 5 6 4 5 5 7 8 2 5 5)))
; (format t "~%")

; INVERTER A LISTA
; NAO EXISTE EM LISP CONCATENAÇÃO (APPEND) ENTRE LISTA E ELEMENTO, APENAS ENTRE LISTAS
(defun inverte (lst) ; esse é o jeito vagabundo e fazer, o correto é com acumulador 
    (cond
        ((null lst) nil)
        ; inverte o restante da lista e coloca o cabeça no final
        (t (append (inverte (cdr lst))
                    (list (car lst))))))

; (write (inverte '(a b c d e)))
; (format t "~%")

; PRIMEIROS NATURAIS
(defun n_nat (n) (n_nat* 1 n)) ; n_nat* é o nome do prog. auxiliar (recebe 1(i) e 'n'), nada a ver com ponteiro!!

(defun n_nat* (i n) ; 'i' começa em 1, definido lá em cima
    (cond
        ((> i n) nil)
        (t (cons i (n_nat* (+ i 1) n)))))
    
; (write (n_nat 30))
; (format t "~%")

; ATÉ O K-ÉSIMO (testando organização diferente de código)
(defun ate (k lst)
    (cond
        ((or (null lst) (eql k 0)) nil)
        (t
            (cons
                (car lst)
                (ate (- k 1) (cdr lst))))))

(write (ate 2 '(3 2 1)))