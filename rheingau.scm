(define-module rheingau
  (use rfc.http)
  (use rfc.json)
  (use srfi-11)
  (use file.util)
  (use util.match)

  (export rheingau-use
          rheingau-add-module
          rheingau-find-module
          rheingau-build-path
          ))

(select-module rheingau)

(define-syntax rheingau-use
  (er-macro-transformer
    (^[form rename id=?]
      (match form
        [(_ pkg . options)
         `(begin (add-load-path ,(module-load-path pkg))
                 (use ,pkg ,@options)
                 )]
        [_ (error "malformed rheingau-use:" form)]))))

(define *index* #f)

(define (rheingau-find-module index mod-path)
  (if (null? index)
      ()
      (if (string=? (symbol->string (caar index))
                    (car mod-path))
          (cons (car mod-path) (rheingau-find-module (cdar index) (cdr mod-path)))
          (rheingau-find-module (cdr index) mod-path))))

(define (rheingau-build-path index mod)
  (let ((pkg (rheingau-find-module index (package-name->path mod))))
    (apply build-path "." "gosh-modules"
           (string-join pkg ".")
           (package-name->path mod))))

(define (rheingau-build-load-path index mod)
  (let ((pkg (rheingau-find-module index (package-name->path mod))))
    (build-path "." "gosh-modules" (string-join pkg "."))))

(define (module-path mod)
  (unless *index*
    (set! *index* (with-input-from-file
                      (build-path "gosh-modules" ".barrel-index.scm")
                    read)))

  (rheingau-build-path *index* mod))

(define (module-load-path mod)
  (unless *index*
    (set! *index* (with-input-from-file
                      (build-path "gosh-modules" ".barrel-index.scm")
                    read)))

  (rheingau-build-load-path *index* mod))

(define (package-name->path name)
  (string-split (symbol->string name) "."))

(define (rheingau-add-module tree name)
  (define (iter branches path)
    (if (null? path)
        branches
        (let loop ((branches branches))
          (if (null? branches)
              (list (cons (car path)
                          (if (null? (cdr path))
                              ()
                              (iter () (cdr path)))))
              (if (string=? (car path) (caar branches))
                  (cons (cons (caar branches)
                              (iter (cdar branches)
                                    (cdr path)))
                        (cdr branches))
                  (cons (car branches) (loop (cdr branches)))
                  )))))
  (iter tree (package-name->path name)))
