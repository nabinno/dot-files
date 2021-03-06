;;; init-html --- initial html-mode configuration
;;; Commentary:
;;; Code:
(leaf tidy
  :el-get lwiechec/tidy.el
  :config
  (add-hook 'html-mode-hook
            (lambda () (tidy-build-menu html-mode-map))))


(leaf tagedit :ensure t)
(after-load 'sgml-mode
  (tagedit-add-paredit-like-keybindings)
  (add-hook 'sgml-mode-hook (lambda () (tagedit-mode 1))))

(add-auto-mode 'html-mode "\\.(jsp|tmpl)\\'")

;; Note: ERB is configured in init-ruby-mode


(provide 'init-html)
;;; init-html ends here
