(require 'company)
(require 'company-quickhelp)


;; Config for company mode.
(add-hook 'prog-mode-hook 'company-mode)
(setq company-idle-delay 0.2)   ; set the completion menu pop-up delay
(setq company-minimum-prefix-length 1) ; pop up a completion menu by tapping a character
(setq company-show-numbers nil)   ; do not display numbers on the left
(setq company-require-match nil) ; allow input string that do not match candidate words

(after-load 'company
  (dolist (backend '(company-eclim company-semantic))
    (delq backend company-backends)))

(define-key company-mode-map (kbd "M-/") 'company-complete)
(define-key company-active-map (kbd "M-/") 'company-other-backend)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "M-h") 'company-quickhelp-manual-begin)
(setq-default company-dabbrev-other-buffers 'all
             company-tooltip-align-annotations t)
(global-set-key (kbd "M-C-/") 'company-complete)

(setq company-quickhelp-delay nil)  ;; manually popup
(add-hook 'company-mode-hook 'company-quickhelp-mode)



;; Suspend page-break-lines-mode while company menu is active
;; (see https://github.com/company-mode/company-mode/issues/416)
(after-load 'company
  (after-load 'page-break-lines
    (defvar-local lew/page-break-lines-on-p nil)

    (defun lew/page-break-lines-disable (&rest ignore)
      (when (setq lew/page-break-lines-on-p (bound-and-true-p page-break-lines-mode))
        (page-break-lines-mode -1)))

    (defun lew/page-break-lines-maybe-reenable (&rest ignore)
      (when lew/page-break-lines-on-p
        (page-break-lines-mode 1)))

    (add-hook 'company-completion-started-hook 'lew/page-break-lines-disable)
    (add-hook 'company-after-completion-hook 'lew/page-break-lines-maybe-reenable)))



;; Add yasnippet support for all company backends.
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(provide 'init-company)
