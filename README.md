# cobblestone

Structural validation library for Common Lisp

## Description

Cobblestone is a structural validation library for Common Lisp, inspired by [funcool/struct](https://github.com/funcool/struct).

It provides a way to define a validator for association list and validate it.

This software is in alpha stage. It is not ready for production use.

## Usage

 ```lisp

 (use-package :cobblestone)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defparameter *test-validator-schema*
    ;; A validator schema is a list of (key . validation-specs) pairs. This schema must be compile-time constant.
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

;; Returns params if params is valid, otherwise returns NIL and error messages.

(validate *test-validator* '(("id" . 1) ("name" . "foo")))
;; => (("id" . 1) ("name" . "foo")), NIL

(validate *test-validator* '(("id" . 1)))
;; => NIL, (("name" . "name is required"))

(validate *test-validator* '(("id" . "1") ("name" . "foo")))
;; => NIL, (("id" . "id must be a integer"))
```

## Author

* Kohei Hosoki (koubee473@gmail.com)

## Copyright

Copyright (c) 2023 Kohei Hosoki (koubee473@gmail.com)

# License

MIT
