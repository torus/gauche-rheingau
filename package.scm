;;
;; Package rheingau
;;

(define-gauche-package "rheingau"
  ;; 
  :version "1.0"

  ;; Description of the package.  The first line is used as a short
  ;; summary.
  :description "A dumb package manager for Gauche."

  ;; List of dependencies.
  ;; Example:
  ;;     :require (("Gauche" (>= "0.9.5"))  ; requires Gauche 0.9.5 or later
  ;;               ("Gauche-gl" "0.6"))     ; and Gauche-gl 0.6
  :require ()

  ;; List name and contact info of authors.
  ;; e.g. ("Eva Lu Ator <eval@example.com>"
  ;;       "Alyssa P. Hacker <lisper@example.com>")
  :authors ("Toru Hisai <toru@torus.jp>")

  ;; List name and contact info of package maintainers, if they differ
  ;; from authors.
  ;; e.g. ("Cy D. Fect <c@example.com>")
  :maintainers ()

  ;; List licenses
  ;; e.g. ("BSD")
  :licenses ("BSD")

  ;; Homepage URL, if any.
  ; :homepage "http://example.com/rheingau/"

  ;; Repository URL, e.g. github
  :repository "https://github.com/torus/gauche-rheingau"
  )
