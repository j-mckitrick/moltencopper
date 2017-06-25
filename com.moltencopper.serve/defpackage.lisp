(in-package :cl-user)

;(push :server-debug *features*)

(defpackage :com.moltencopper.serve
  (:nicknames :serve)
  (:documentation "Hunchentoot functionality for molten copper demo web app.")
  (:use :cl :cl-user :hunchentoot :xml-emitter :split-sequence
	:cl-who :json
	;:html-template
	:com.moltencopper.db)
  (:export
   #:mocu-web-start
   #:mocu-web-stop

   ;; functions
   #:verify-user-and-password
   
   ;; variables
   #:*users*

   ;; constants
   #:+server-port+
   
   #:+url-login+
   #:+url-logout+

   ))
