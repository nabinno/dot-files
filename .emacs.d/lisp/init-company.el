;;; init-company -- company configuration
;;; Commentary:
;;; Code:
(use-package company
  :straight t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  (setq company-selection-wrap-around t)
  (setq company-global-modes '(not eshell-mode)))



(provide 'init-company)
;;; init-company.el ends here
