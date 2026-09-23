; escreva uma função q2 em lisp que recbea uma lista de inteiros e
; subtrai 1 dos elementos maiores que 7 e somar 1 aos elementos menores ou iguais a 7.

(defun q2 (lst)
    (cond
        ((null lst) nil) ; se a lista for vazia
        ((> (car lst) 7) ; se a cabeça for maior que 7
            (cons (- (car lst) 1) ; SUBTRAI em 1 a cabeça e chama a função de novo com a cauda
                  (q2 (cdr lst))))
        (t ; se for menor ou igual (else)
            (cons (+ (car lst) 1) ; SOMA em 1 a cabeça e chama a função de novo com a cauda
                  (q2 (cdr lst))))))

(write (q2 '(3 15 7 8 2 -55)))