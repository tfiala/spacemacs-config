;; LLVM coding style guidelines in emacs
;; Maintainer: LLVM Team, http://llvm.org/
;;
;; From git:/http://llvm.org/git/llvm.git utils/emacs/emacs.el

(provide 'llvm-c++)

;; Add a cc-mode style for editing LLVM/LLDB C and C++ code
(c-add-style "llvm.org"
             '("gnu"
	       (fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)
	       (c-offsets-alist . ((arglist-intro . ++)
				   (innamespace . 0)
				   (member-init-intro . ++)))))

;; Files with "llvm" or "lldb" in their names will automatically be set to the
;; llvm.org coding style.
(add-hook 'c-mode-common-hook
	  (function
	   (lambda nil
	     (if (or (string-match "llvm" buffer-file-name)
               (string-match "lldb" buffer-file-name))
           (progn
            (message "setting llvm C++ style") 
            (c-set-style "llvm.org"))))))
