(add-load-path "./lib")
(use rheingau)

;; Command line interface
(define (main args)
  (let ((command (cadr args)))
    (case (string->symbol command)
      ((install i)
       (let ((pkg (caddr args)))
         (rheingau-install pkg))))))
