(use gauche.test)
(test-start "Rheingau")
(load "rheingau")
(import rheingau)
(test-module 'rheingau)

(test-start "barrel")
(load "barrel")
(import barrel)
(test-module 'barrel)
