(in-package #:cl-user)
(defpackage cobblestone/test/main
  (:use #:cl #:rove #:cobblestone/main))

(in-package #:cobblestone/test/main)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *test-validator-spec*
    '(("id"
       (:required t
        :message "id is required")
       (:validate #'integerp
        :message "id must be a integer"))
      ("name"
       (:required t
        :message "name is required")
       (:validate #'stringp
        :message "name must be a string")))))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *test-validator* (compile-validator #.*test-validator-spec*)))

(deftest validator-test
  (testing "missing keys"
    (let ((params '()))
      (ok (equalp (multiple-value-list
                   (validate *test-validator* params))
                  `(nil (("id" . "id is required")
                         ("name" . "name is required")))))))
  (testing "pass"
    (let ((params '(("id" . 1)
                    ("name" . "motoshira"))))
      (ok (equalp (multiple-value-list
                   (validate *test-validator* params))
                  `(,params nil))))))
