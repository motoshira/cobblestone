(asdf:defsystem cobblestone
  :author "motoshira"
  :license "MIT"
  :version "0.0.1"
  :class :package-inferred-system
  :depends-on ("cobblestone/main")
  :in-order-to ((test-op (test-op cobblestone/test))))

(asdf:defsystem cobblestone/test
  :depends-on ("rove"
               "cobblestone")
  :pathname "test/"
  :components
  ((:file "main"))
  :perform (asdf:test-op (o c) (symbol-call :rove :run-system :cobblestone/test)))
