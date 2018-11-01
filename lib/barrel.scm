(define-module barrel
  (use file.util)
  )

(select-module barrel)

(define (barrel . args)
  (let loop ((args args)
             (obj ()))
    (if (null? args)
        obj
        (loop (cdr args) ((car args) obj)))))

(define (name n)
  (lambda (obj)
    (acons 'name n obj)))

(define (version v)
  (lambda (obj)
    (acons 'version v obj)))

(define (dependencies . args)
  (let loop ((args args)
             (obj ()))
    (if (null? args)
        (lambda (barrel-obj) (acons 'dependencies obj barrel-obj))
        (loop (cdr args) ((car args) obj)))))

(define (from-git name . alist)
  (define dest-dir (build-path "gosh-modules" name))
  (define (thunk)
    (let ((script-path #f))
      (create-directory-tree
       "gosh-modules"
       `(".build"
         ((,name
           (("build.sh"
             ,(lambda (path)
                (let ((repo (cdr (assq 'repo alist)))
                      (branch (cdr (assq 'branch alist))))
                  (let ((branch-option (if branch #`"--branch ,branch" "")))
                    (print #`"rm -rf ,dest-dir")
                    (print #`"git clone --depth 1 ,branch-option ,repo ,dest-dir")
                    (set! script-path path))))))))))
      (sys-system #`"sh ,script-path")))
  (lambda (obj)
    (acons name thunk obj)
))

(define (repo url) (cons 'repo url))
(define (branch br) (cons 'branch br))
