;; (define (fib n)
;;   (define (fib-iter a b n)
;;     (if (= n 0)
;; 	b
;; 	(fib-iter (+ a b) a (- n 1))))
;;   (fib-iter 1 0 n))

(define (fib n)
  (define (fib-iter a b p q n)
    (cond ((= n 0) b)
	  ((even? n)
	   (fib-iter a
		     b
		     (+ (square p) (square q))
		     (+ (square q) (* 2 p q))
		     (/ n 2)))
	  (else (fib-iter (+ (* b q) (* a q) (* a p))
			  (+ (* b p) (* a q))
			  p
			  q
			  (- n 1)))))
  (fib-iter 1 0 0 1 n))
