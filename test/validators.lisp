(cl:in-package #:cl-user)
(defpackage #:cobblestone/test/validators
  (:use #:cl #:rove #:cobblestone  #:cobblestone/validators)
  (:shadowing-import-from #:cobblestone/validators #:integer #:string))

(in-package #:cobblestone/test/validators)

(deftest string-validator-test
  (let* ((schema `(("name" . (,(string)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (let ((params '(("name" . 1))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    '((("name" . "name must be a string"))
                      nil)))))
    (testing "pass"
      (let ((params '(("name" . "motoshira"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    `(nil ,params)))))))

(deftest integer-validator-test
  (let* ((schema `(("age" . (,(integer)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (let ((params '(("age" . "1"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    '((("age" . "age must be an integer"))
                      nil)))))
    (testing "pass"
      (let ((params '(("age" . 1))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    `(nil ,params)))))))

(deftest integer-str-validator-test
  (let* ((schema `(("age" . (,(integer-str)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (let ((params '(("age" . "hoge"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    '((("age" . "age must be an integer"))
                      nil)))))
    (testing "pass"
      (testing "an integer"
        (let ((params '(("age" . 1))))
          (ok (equalp (multiple-value-list
                       (validate validator params))
                      `(nil ,params)))))
      (testing "a string of an integer"
        (let* ((params '(("age" . "1"))))
          (ok (equalp (multiple-value-list
                       (validate validator params))
                      '(nil (("age" . 1))))))))))

(deftest not-nil-validator-test
  (let* ((schema `(("name" . (,(not-nil)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (let ((params '(("name" . nil))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    '((("name" . "name cannot be nil"))
                      nil)))))
    (testing "pass"
      (let ((params '(("name" . "motoshira"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    `(nil ,params)))))))

(deftest uuid-validator-test
  (let* ((schema `(("id" . (,(uuid)))))
         (validator (compile-validator schema)))
    (testing "fail"
      (testing "some string"
        (let ((params '(("id" . "invalid-format-string"))))
          (ok (equalp (multiple-value-list
                       (validate validator params))
                      '((("id" . "Invalid uuid format"))
                        nil)))))
      (testing "some garbage after uuid"
        (let ((params '(("id" . "8B0F6081-CC5D-4C67-A815-A16A3C2C8153garbage"))))
          (ok (equalp (multiple-value-list
                       (validate validator params))
                      '((("id" . "Invalid uuid format"))
                        nil))))))
    (testing "pass"
      (let ((params '(("id" . "8B0F6081-CC5D-4C67-A815-A16A3C2C8153"))))
        (ok (equalp (multiple-value-list
                     (validate validator params))
                    `(nil ,params)))))))
