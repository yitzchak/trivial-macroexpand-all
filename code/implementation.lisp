(in-package #:trivial-macroexpand-all)

(eval-when (:compile-toplevel :load-toplevel :execute)
  #+(or abcl ccl cmucl ecl sbcl)
  (pushnew :trivial-macroexpand-all/env *features*)

  #+(or abcl allegro ccl clisp cmucl corman ecl lispwork mkcl sbcl scl)
  (pushnew :trivial-macroexpand-all *features*))

(defun macroexpand-all (form &optional env)
  (declare (ignorable env))
  (values #+abcl
          (ext:macroexpand-all form env)
          #+(and allegro allegro-version>= (version>= 8 0))
          (excl::walk-form form)
          #+(and allegro (or (not allegro-version>=) (not (version>= 8 0))))
          (excl::walk form)
          #+ccl
          (ccl:macroexpand-all form env)
          #+clisp
          (ext:expand-form form)
          #+cmucl
          (walker:macroexpand-all form env)
          #+corman
          (ccl:macroexpand-all form)
          #+ecl
          (walker:macroexpand-all form env)
          #+lispworks
          (walker:walk-form form)
          #+mkcl
          (walker:macroexpand-all form)
          #+sbcl
          (sb-cltl2:macroexpand-all form env)
          #+scl
          (macroexpand form)
          #-(or abcl allegro ccl clisp cmucl corman ecl lispworks mkcl sbcl scl)
          form))
