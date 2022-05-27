(use gauche.test)
(test-start "Rheingau")
(load "./lib/rheingau")
(import rheingau)

(load "./testlib/test-utils")

(test-section "rheingau-add-module")

(test-behavior
 "add a single-depth path to empty tree"
 (^[]
   (let ((result (rheingau-add-module '() 'a)))
     (assert-equal
      '(("a"))
      result))))

(test-behavior
 "add a path to empty tree"
 (^[]
   (let ((result (rheingau-add-module '() 'a.b.c)))
     (assert-equal
      '(("a" ("b" ("c"))))
      result))))

(test-behavior
 "add a path to non-empty tree"
 (^[]
   (let ((result (rheingau-add-module '(("a")) 'b.c)))
     (assert-equal
      '(("a")
        ("b" ("c")))
      result))))

(test-behavior
 "add a path to non-empty tree with full overlap"
 (^[]
   (let ((result (rheingau-add-module '(("a")) 'a)))
     (assert-equal
      '(("a"))
      result))))

(test-behavior
 "add a path to non-empty tree with full overlap"
 (^[]
   (let ((result (rheingau-add-module '(("a" ("b"))) 'a.b)))
     (assert-equal
      '(("a" ("b")))
      result))))

(test-behavior
 "add a path to non-empty tree with overlap"
 (^[]
   (let ((result (rheingau-add-module '(("a")) 'a.b)))
     (assert-equal
      '(("a" ("b")))
      result))))

(test-behavior
 "add a path to non-empty tree with partial overlap"
 (^[]
   (let ((result (rheingau-add-module '(("a" ("b" ("c")))) 'a.b.d)))
     (assert-equal
      '(("a" ("b" ("c") ("d"))))
      result))))

(test-behavior
 "add path to the module tree"
 (^[]
   (let ((result (rheingau-add-module '(("a" ("b" ("c")))
                                        ("e")
                                        ("f" ("g" ("h" ("i")))))
                                      'a.b.d)))
     (assert-equal
      '(("a" ("b" ("c") ("d")))
        ("e")
        ("f" ("g" ("h" ("i")))))
      result))))

;; a b c
;; a b d
;; e
;; f g
;; f h i
