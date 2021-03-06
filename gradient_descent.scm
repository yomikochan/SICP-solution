(define delta 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x delta)) (g x))
       delta)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (fixed-point g first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) delta))
  (define (try guess)
    (let ((next (g guess)))
      (if (close-enough? guess next)
	  guess
	  (try next))))
  (try first-guess))

(define (newton-method g guess)
  (fixed-point (newton-transform g) guess))

(define (minimized g)
  (newton-method (deriv g) 1.0))

(define (gradient-descent g init-vec max-it tolerance)
  (define len (- (length init-vec) 1))
  (define (partial-derivative g)
    (lambda (vec index)
      (let ((d-vec (list-copy vec)))
	(list-set! d-vec index (+ (list-ref d-vec index) delta))
	(/ (- (g d-vec) (g vec)) delta))))
  (define (gradient-vector g vec)
    (define (iter i res)
      (if (< i 0)
	  res
	  (iter (- i 1) (cons ((partial-derivative g) vec i) res))))
    (iter len ()))
  (define (distance vec)
    (define (iter i result)
      (if (< i 0)
	  result
	  (iter (- i 1) (+ result (square (list-ref vec i))))))
    (sqrt (iter len 0)))
  (define (next vec x grad)
    (define (iter i res)
      (if (< i 0)
	  res
	  (iter (- i 1) (cons (- (list-ref vec i) (* x (list-ref grad i))) res))))
    (iter len ()))
  (define (x-transform vec x grad)
    (next vec x grad))
  (define (iter vec i)
    (let ((grad-vec (gradient-vector g vec)))
      (display vec)
      (newline)
      (cond ((< max-it i) vec)
	    ((< (distance grad-vec) tolerance) vec)
	    (else (let ((minimum (minimized
				  (lambda (x)
				    (g (x-transform vec x grad-vec))))))
		    (iter (next vec minimum grad-vec) (+ i 1)))))))
  (iter init-vec 0))
