Rheingau - a Package Manager for Gauche
=======================================

### Synopsis

```
$ gosh reingau.scm install makiki
```

To load the installed module, add `gosh-modules/<pkgname>` to the `*load-path*` like:

```scheme
(use file.util)
(use util.match)

(define-syntax rheingau-use
  (er-macro-transformer
    (^[form rename id=?]
      (match form
        [(_ pkg)
         `(begin (add-load-path ,(build-path "." "gosh-modules" (symbol->string pkg)))
                 (use ,pkg)
                 )]
        [_ (error "malformed rheingau-use:" form)]))))

(rheingau-use makiki)
```
