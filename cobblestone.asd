(asdf:defsystem cobblestone
  :author "motoshira"
  :license "MIT"
  :version "0.0.3"
  :class :package-inferred-system
  :depends-on ("cobblestone/all" "cl-ppcre")
  :in-order-to ((test-op (test-op cobblestone/test))))

(asdf:defsystem cobblestone/test
  :depends-on ("rove"
               "cobblestone")
  :pathname "test/"
  :serial t
  :components
  ((:file "main")
   (:file "validators"))
  :perform (asdf:test-op (o c) (symbol-call :rove :run-system :cobblestone/test)))
