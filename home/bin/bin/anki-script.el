#!/usr/bin/env -S emacs --script
(require 'cl-lib)
(require 'use-package)
(package-initialize)
(setq-default anki-editor-latex-style 'mathjax)
(require 'anki-editor)
(anki-editor-sync-collection)

;; To convert the list of argument folders into a list of files
(let* ((args (cdr (cdr (cdr command-line-args))))
			 (ForDs (if (eq args '()) '(".") args))
			 (files (mapcan (lambda (ForD)
												(if (file-directory-p ForD)
														(directory-files-recursively ForD "^[^.#].*\\.org$")
													`(,ForD)))
											ForDs)))
	(cl-map 'list (lambda (file)
									(find-file file)
									(if (eq major-mode 'org-mode) ;; Don't trust the file name
											(progn
												(anki-editor-mode)
												(anki-editor-push-notes)
												(save-buffer))))
					files))
(anki-editor-sync-collection)
