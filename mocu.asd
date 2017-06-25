;; -*- mode: lisp; encoding: utf-8 -*-
;; Copyright © 2007 Jonathon McKitrick.  All Rights Reserved.

(defpackage :mocu-system (:use :cl :asdf))
(in-package :mocu-system)

(defsystem mocu
  :name "moltencopper"
  :version "1.0"
  :author "Jonathon McKitrick"
  :description "Molten Copper CL Demo"
  :components
  ((:file "start" :depends-on ("com.moltencopper.serve"))
   (:module "com.moltencopper.serve" :depends-on ("com.moltencopper.db") :serial t
	    :components ((:file "defpackage")
			 (:file "server-authentication")
			 (:file "hunchentoot-conf")
			 (:file "form-handlers")
			 (:file "hunchentoot-handlers")))
   (:module "com.moltencopper.db" :serial t
	    :components ((:file "defpackage")
			 (:file "db-classes")
			 (:file "db-sql"))))
  :depends-on (:hunchentoot :net-telent-date :split-sequence :cl-who :html-template
			    :clsql :cl-json :rfc2388 :xml-emitter))

