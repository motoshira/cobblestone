(cl:in-package #:cl-user)
(defpackage #:cobblestone/test/validators
  (:use #:cl #:rove #:cobblestone #:cobblestone/validators))

(in-package #:cobblestone/test/validators)

(deftest uuid-validator-test
  (let* ((schema `(("id" . (,(uuid)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (let ((params '(("id" . "invalid-format-string"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    '((("id" . "Invalid uuid format"))
                      nil)))))
    (testing "pass"
      (let ((params '(("id" . "8B0F6081-CC5D-4C67-A815-A16A3C2C8153"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    `(nil ,params)))))))
