(in-package #:cl-user)
(defpackage cobblestone/test/main
  (:use #:cl #:rove #:cobblestone/main))

(in-package #:cobblestone/test/main)

(defparameter *test-validator-spec*
  `(("id"
     (:validate ,#'integerp
      :message "id must be a integer"))
    ("name"
     (:validate ,#'stringp
      :message "name must be a string"))))

(defparameter *test-validator*
  (compile-validator *test-validator-spec*
                     :key-test #'equal
                     :required-keys '("id" "name")
                     :required-message (lambda (key)
                                         (format nil "~a is required" key))))

(deftest validator-test
  (testing "missing keys"
    (let ((params '()))
      (ok (equalp (multiple-value-list
                   (validate *test-validator* params))
                  `((("id" . "id is required")
                     ("name" . "name is required"))
                    nil)))))
  (testing "pass"
    (let ((params '(("id" . 1)
                    ("name" . "motoshira"))))
      (ok (equalp (multiple-value-list
                   (validate *test-validator* params))
                  `(nil ,params))))))
