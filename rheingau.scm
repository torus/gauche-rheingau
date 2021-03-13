(define-module rheingau
  (use rfc.http)
  (use rfc.json)
  (use srfi-11)
  (use file.util)
  (use util.match)

  (export rheingau-install rheingau-use)
  )

(select-module rheingau)

(define (rheingau-install pkg)
  (define dest-dir (build-path "gosh-modules" pkg))

  (unless (file-type dest-dir)

    (print #`"Installing ,pkg")

    ;; https://stackoverflow.com/questions/46762667/firebase-firestore-rest-example
    (let* ((server "firestore.googleapis.com")
           (project "project-6711518500697978711")
           (uri #`"/v1beta1/projects/,|project|/databases/(default)/documents/rheingau/,|pkg|"))
      (let-values (((status header body) (http-get server uri :secure #t)))
        (unless (string=? status "200") (error #`"Couldn't find the package: ,|pkg|."))

        (let* ((port (open-input-string body))
               (data (parse-json port))
               (fields (cdr (assoc "fields" data string=?)))
               (repo-elem (cdr (assoc "repo" fields string=?)))
               (repo (cdr (assoc "stringValue" repo-elem string=?))))

          (let ((script-path #f))
            (create-directory-tree
             "gosh-modules"
             `(".build"
               ((,pkg
                 (("build.sh"
                   ,(lambda (path)
                      (print #`"git clone ,repo ,dest-dir")
                      (set! script-path path))))))))
            (sys-system #`"sh ,script-path")))))))

(define-syntax rheingau-use
  (er-macro-transformer
    (^[form rename id=?]
      (match form
        [(_ pkg)
         `(begin (require ,(build-path "." "gosh-modules"
                                       (symbol->string pkg) (symbol->string pkg)))
                 (import ,pkg)
                 )]
        [_ (error "malformed rheingau-use:" form)]))))
