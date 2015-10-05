;;; init-github --- github configuration
;;; Commentary:
;;; Code:
(require 'init-git)

(require-package 'yagist)
(require-package 'github-browse-file)
(require-package 'bug-reference-github)
(add-hook 'prog-mode-hook 'bug-reference-prog-mode)

(when (eval-when-compile (> emacs-major-version 23))
  (require-package 'github-clone)
  (require-package 'magit-gh-pulls))
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)


(provide 'init-github)
;;; init-github.el ends here
