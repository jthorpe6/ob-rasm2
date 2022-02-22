;;; ob-rasm2.el --- org-babel functions for generating shellcode

;;; Commentary:

;; Org-Babel support for generating shellcode using rasm2.
;;
;; fixed version of https://vishnudevtj.github.io/notes/wrting-shellcode-in-emacs
;;

;;; Requirements:
;;
;; - you must have rasm2 installed, which is part of radare2.
;;

;;; Code:

(require 'ob)

(defconst org-babel-header-args:rasm2
  '((:arch . :any)
    (:bits . :any)
    (:disasm . :any)
    )
  "Rasm2 specfic header arguments.")

(defun org-babel-execute:rasm2 (body params)
  "Execute a block with Org Babel.
BODY is the source inside the block.
PARAMS is the configuration.
This function is called by 'org-babel-execute-src-block'."
  (let* ((arch (cdr (assq :arch params)))
	 (bits (cdr (assq :bits params))))
    (if (assq :disam params)
	(shell-command-to-string
	 (concat "rasm2 -a " arch " -b " (number-to-string bits) "-d \"" body "\""))
      (with-temp-buffer
	(insert (shell-command-to-string
		 (concat "rasm2 -C -a " arch " -b " (number-to-string bits) " \"" body "\"" )))
	(goto-char (point-min))
	(while (re-search-forward "\"" nil t )
	  (replace-match ""))
	(goto-char (point-min))
	(while (re-search-forward "\n" nil t )
	  (replace-match ""))
	(buffer-string)
	)))
  )


(provide 'ob-rasm2)
;;; ob-rasm2 ends here
