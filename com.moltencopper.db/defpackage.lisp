(in-package :cl-user)

;(push :db-debug *features*)

(defpackage :com.moltencopper.db
  (:nicknames :db)
  (:documentation "Database interface functions.")
  (:use :cl :cl-user :clsql  :sb-thread)
  (:export

   ;; classes
   #:mcuser
   
   ;; accessors
   #:username
   #:password

   ;; methods

   ;; functions
   #:connect-to-mocu
   #:disconnect-from-mocu

   #:get-mocu-user
   #:get-mocu-users

   ;; variables
   ))
