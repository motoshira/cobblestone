(in-package #:cl-user)
(defpackage cobblestone/main
  (:nicknames #:cobblestone)
  (:use #:cl)
  (:export #:compile-validator
           #:validate))

(in-package cobblestone/main)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defstruct (validator (:constructor %make-validator)
                        (:type list))
    required message validate))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun %validate-schema (schema)
    (assert (listp schema))
    (loop for pair in schema
          do (destructuring-bind (key . specs) pair
               (assert (stringp key))
               (assert (listp specs))))))

(defmacro %get-message (v value)
  (etypecase (validator-message v)
    (string (validator-message v))
    (function `(funcall ,(validator-message v) ,value))))

(defmacro %expand-one-spec-forms (spec params result errors next-tag)
  (destructuring-bind (key . validators) spec
    (let ((value (gensym))
          (kv (gensym)))
      `(progn
         (let ((,kv (first ,params)))
           (unless (consp ,kv)
             (push (cons ,key "value is missing")
                   ,errors)
             (go ,next-tag))
           (let ((,value (cdr ,kv)))
             ,@(loop for v in validators
                     ;; treat required
                     unless (validator-required v)
                       collect `(unless (funcall ,(validator-validate v) ,value)
                                  (push (cons ,key (%get-message ,v ,value))
                                        ,errors)
                                  (go ,next-tag)))
             ;; TODO coerce
             (push ,value ,result)
             (go ,next-tag)))))))

(defmacro %expand-forms (schema params key-test)
  (let* ((schema-amount (length schema))
         (tags (loop repeat schema-amount
                     collect (gensym))))
    (destructuring-bind (check-key go-next-pair end result errors kv key) (loop repeat 7 collect (gensym))
      `(let ((,params ,params)
             (,result nil)
             (,errors nil))
         (tagbody
            ,check-key
            (when (null ,params)
              (go ,end))
            (let* ((,kv (first ,params))
                   (,key (car ,kv)))
              (cond
                ,@(loop for (k . vs) in schema
                        for tag in tags
                        collect `((,key-test ,k ,key)
                                  (go ,tag))))
              (setf ,params (rest ,params)))
            ,@(loop for spec in schema
                    for tag in tags
                    append `(,tag
                             (%expand-one-spec-forms ,spec ,params ,result ,errors ,go-next-pair)))
            ,go-next-pair
            (setf ,params (rest ,params))
            (go ,check-key)
            ,end)
         (values (nreverse ,result)
                 (nreverse ,errors))))))

(defmacro compile-validator (schema &key (key-test 'string=))
  "Compile a validator for SCHEMA."
  (%validate-schema schema)
  (let ((params (gensym))
        (schema (loop for (key . validator-specs) in schema
                      collect (cons key (mapcar (lambda (vs)
                                                  (apply #'%make-validator vs))
                                                validator-specs)))))
    `(lambda (,params)
       (%expand-forms ,schema ,params ,key-test))))

(defun validate (validator alist)
  "Perform validation on ALIST using VALIDATOR."
  (funcall validator alist))
