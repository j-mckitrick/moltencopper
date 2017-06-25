;;;; Hunchentoot form submission handlers.

(in-package :com.moltencopper.serve)

(declaim (optimize debug))

;;; All POSTed forms are handled here.
;;;
;;; Currently, we only use forms for assessment creation and delivery, as well as
;;; user login.  Other data is sent directly via ajax.  Perhaps that approach
;;; could be applied globally in the future.  But for now, with some pages
;;; containing a great deal of data, it's simpler to just POST the data.

;;; Basic non-authenticated handlers

(define-easy-handler
    (handle-login :uri +url-login+ :default-request-type :post)
    (user pass)
  "Login USER with PASS."
  (if (and (> (length user) 0)
	   (> (length pass) 0)
	   (verify-user-and-password user pass))
      (progn
	(start-session)
	(setf (session-value 'user) user)
	;; hash?
	(redirect "/"))
      (progn
	(redirect (concatenate 'string "?auth=fail")))))

