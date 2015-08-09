(unless (require 'jinari nil 'noerror)
  (el-get-bundle nabinno/jinari))

(after-load 'jinari
  (diminish 'jinari-minor-mode " J"))
(global-jinari-mode)

(defun update-express-ctags ()
  (interactive)
  (let ((default-directory (or (jinari-root) default-directory)))
    (shell-command
     (concat "ctags -a -e -f "
             jinari-tags-file-name
             " --langmap=JAVASCRIPT:.js --tag-relative -R node_modules src lib vendor test"))))

;; Jinari-rgrep
(setq jinari-rgrep-file-endings
      "*.rb *.erb *.yml *.yaml *.coffee *.js *.jade *.es6 *.json *.scss *.tag *.rake")
(eval-after-load "grep"
  '(progn
     (add-to-list 'grep-find-ignored-directories ".old")
     (add-to-list 'grep-find-ignored-directories ".sass-cache")
     (add-to-list 'grep-find-ignored-directories "bin")
     (add-to-list 'grep-find-ignored-directories "bower_components")
     (add-to-list 'grep-find-ignored-directories "commons")
     (add-to-list 'grep-find-ignored-directories "commons.min")
     (add-to-list 'grep-find-ignored-directories "db")
     (add-to-list 'grep-find-ignored-directories "fonts")
     (add-to-list 'grep-find-ignored-directories "log")
     (add-to-list 'grep-find-ignored-directories "tmp")
     (add-to-list 'grep-find-ignored-directories "vendor")))

;; Jinari-rgrep--todo
(defun jinari-rgrep--todo ()
  (interactive)
  (rgrep "TODO:" jinari-rgrep-file-endings (jinari-root)))
(define-key jinari-minor-mode-map (kbd "M-6") 'jinari-rgrep--todo)

;;; Dispatch other-window-or-split on Jinari
(defun jinari--other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (let ((current-buffer-name (buffer-name (current-buffer))))
      (if (string-match-p "^\*eshell" current-buffer-name)
          (if (< (window-body-width) 110)
              (progn
                (split-window-vertically-x)
                (sr-speedbar-toggle)
                (other-window 1)
                (switch-to-buffer current-buffer-name))
            (if (>= (window-body-width) 200)
                (progn
                  (sr-speedbar-toggle)
                  (split-window-vertically-x)
                  (split-window-horizontally-n 3)
                  (other-window 3) (switch-to-buffer current-buffer-name)
                  (other-window 1) (or (jinari-find-test-functional) (jinari-find-test-unit))
                  (other-window 1) (or (jinari-find-controller) (jinari-find-routes) (jinari-find-gulp) (jinari-find-application))
                  (other-window 1) (or (jinari-find-component) (jinari-find-view) (jinari-find-model)))
              (split-window-horizontally)))
        (if (< (window-body-width) 110)
            (progn
              (split-window-vertically-x)
              (sr-speedbar-toggle)
              (other-window 1)
              (multi-eshell--kill-all)
              (multi-eshell 1) (eshell/cdp) (eshell-send-input))
          (if (>= (window-body-width) 200)
              (progn
                (sr-speedbar-toggle)
                (split-window-vertically-x)
                (split-window-horizontally-n 3)
                (multi-eshell--kill-all)
                (other-window 3) (multi-eshell 1) (eshell/cdp) (eshell-send-input)
                (other-window 1) (or (jinari-find-test-functional) (jinari-find-test-unit))
                (other-window 1) (or (jinari-find-controller) (jinari-find-routes) (jinari-find-gulp) (jinari-find-application))
                (other-window 1) (or (jinari-find-component) (jinari-find-view) (jinari-find-model)))
            (split-window-horizontally))))))
  (other-window 1))
(add-hook 'jinari-minor-mode-hook
          (lambda () (global-set-key (kbd "M-[ 1 ; 5 i") 'jinari--other-window-or-split)))

;; ;; Projectile
;; (add-hook 'jinari-minor-mode-hook 'projectile-mode)


;;; GulpJs
(el-get-bundle stevenremot/emacs-gulpjs)

(fset 'gulpjs--save-buffer-and-protractor "xsave-bufferxgulpjs-start-taskprotractorxquit-window")
(fset 'gulpjs--protractor    "xgulpjs-start-taskprotractor0")
(fset 'gulpjs--test          "xgulpjs-start-tasktest0")
(fset 'gulpjs--serve         "xgulpjs-start-taskserve0")
(fset 'gulpjs--build         "xgulpjs-start-taskbuild0")
(fset 'gulpjs--switch-buffer "xido-switch-buffer*gulp*")
(global-set-key (kbd "\C-cgs") 'gulpjs--serve)
(global-set-key (kbd "\C-cgt") 'gulpjs--test)
(global-set-key (kbd "\C-cgp") 'gulpjs--protractor)
(global-set-key (kbd "\C-cgb") 'gulpjs--build)
(global-set-key (kbd "\C-cgg") 'gulpjs--switch-buffer)
(global-set-key (kbd "")   'gulpjs--switch-buffer)

(add-hook 'jinari-minor-mode-hook
          (lambda ()
            (mapc (lambda (pair)
                    (let ((key (car pair))
                          (func (cdr pair)))
                      (define-key jinari-minor-mode-map
                        (read-kbd-macro key) func)))
                  '(("" . gulpjs--save-buffer-and-protractor))
                    )))


;;; Jade-mode
(eval-after-load 'jade-mode
  (add-hook 'jade-mode-hook 'page-break-lines-mode))
(require-package 'jade-mode)
(add-auto-mode 'jade-mode "\\.tag\\'")


;; ;;; Unit Testing
;; ;; Karma
;; (require-package 'karma)

;; ;; Jasmine-mode
;; (eval-after-load 'jasminejs-mode
;;   '(jasminejs-install-snippets))
;; (require-package 'jasminejs-mode)

;; ;; Unit testing: Jst/Mocha
;; (require-package 'jst)
;; ;; (add-hook 'js2-mode-hook 'jst-enable-appropriate-mode)
;; ;; (add-hook 'coffee-mode-hook 'jst-enable-appropriate-mode)
;; ;; (add-hook 'what-ever-js-mode-hook 'jst-enable-appropriate-mode)

;; ;; for node.js
;; (jst-declare-project :type "nodejs" :testing-framework "mocha"
;;                      :spec-dir nil :source-dir nil :command-ci nil
;;                      :command-browser nil :browser-url: nil
;;                      :target-to-spec (lambda () "testSuites.js")
;;                      :spec-to-target (lambda () "myLib.js"))

;; ;; If you created your own JS cluster language
;; (jst-remember-language :extension "qs" :name "MyQScript")
;; ;; If you name your spec dirs BlaBlaSuite
;; (jst-remember-spec-dir-pattern "\\(Suite\\)")
;; ;; If you are using darcs
;; (jst-remember-dominating-file ".darcs")


(provide 'init-express)
