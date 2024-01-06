;;; makefile-ts.el --- major mode for editing Makefiles with tree-sitter -*- lexical-binding:t -*-

;; Copyright (C) 2024 antlers <antlers@illucid.net>
;; Copyright (C) 2024 Free Software Foundation, Inc.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file defines `makefile-ts-mode' for editing Makefiles with the
;; aid of tree-sitter.

;; For this major mode to work, Emacs has to be compiled with
;; tree-sitter support and the Make grammar has to be compiled and
;; put somewhere Emacs can find it.

;; This mode doesn't associate itself with Makefile files
;; automatically. You can do that either by prepending to the value of
;; `auto-mode-alist', or using `major-mode-remap-alist'.

(require 'make-mode)

;;;###autoload
(define-derived-mode makefile-ts-mode makefile-mode "Makefile[ts]"
  "Major mode for editing Makefiles with tree-sitter."
  :syntax-table makefile-mode-syntax-table

  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'make)
    (treesit-parser-create 'make)
    (makefile-ts-setup)))

(defvar makefile-ts-font-lock-rules
  '(:language make
    :feature comments
    ((comment) @font-lock-comment-face)

    :language make
    :feature targets
    ((targets) @makefile-targets)

    :language make
    :feature variables
    ((automatic_variable) @font-lock-builtin-face
     (variable_reference (word) @font-lock-variable-use-face)
     (shell_text
       (function_call
         function: _ @font-lock-function-call-face)))

    :language make
    :feature directives
    ((define_directive
       "define" @font-lock-keyword-face
       name: (word) @default
       value: (raw_text) @font-lock-string-face
       "endef" @font-lock-keyword-face))))

(defun makefile-ts-setup ()
  "Setup treesit for makefile-ts-mode."

  (setq-local treesit-font-lock-settings
    (apply #'treesit-font-lock-rules
           makefile-ts-font-lock-rules))

  (setq-local treesit-font-lock-feature-list
    '((comments)
      (targets)
      (variables)
      (directives)))

  ;; (setq-local treesit-simple-indent-rules makefile-ts-indent-rules)

  (treesit-major-mode-setup))
