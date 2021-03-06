;;; init-markdown.el --- Insert description here -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'markdown-mode)

(defun markdown-imenu-index ()
  (let* ((patterns '((nil "^#\\([# ]*[^#\n\r]+\\)" 1))))
    (save-excursion
      (imenu--generic-function patterns))))

(defun markdown-mode-hook-setup ()
  ;; Stolen from http://stackoverflow.com/a/26297700
  ;; makes markdown tables saner via orgtbl-mode
  ;; Insert org table and it will be automatically converted
  ;; to markdown table
  (unless (featurep 'org-table) (require 'org-table))
  (defun cleanup-org-tables ()
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "-+-" nil t) (replace-match "-|-"))))
  (add-hook 'after-save-hook 'cleanup-org-tables nil 'make-it-local)
  (orgtbl-mode 1) ; enable key bindings
  ;; don't wrap lines because there is table in `markdown-mode'
  (setq truncate-lines t)
  (setq imenu-create-index-function 'markdown-imenu-index))
(add-hook 'markdown-mode-hook 'markdown-mode-hook-setup)

(with-eval-after-load 'markdown-mode
     ;; `pandoc' is better than obsolete `markdown'
     ;; Temporarily not installed，Maybe need an absolute path to verify the pandoc if exited.
     (when (executable-find "pandoc")
       (setq markdown-command "pandoc -f markdown -t html -s --mathjax")))

;; taken from https://emacs.stackexchange.com/questions/5465/how-to-migrate-markdown-files-to-emacs-org-mode-format
(defun jl-markdown-convert-buffer-to-org ()
    "Convert the current buffer's content from markdown to orgmode format
and save it with the current buffer's file name but with .org extension."
    (interactive)
    (shell-command-on-region (point-min) (point-max)
                             (format "pandoc -f markdown -t org -o %s"
                                     (concat (file-name-sans-extension (buffer-file-name)) ".org"))))


(provide 'init-markdown)
;;; init-markdown.el ends here
