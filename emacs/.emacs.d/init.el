;; Constant for the configuration directory
(defconst config-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'config-directory)
         config-directory)
        (t "~/.emacs.d/")))

;; Function that loads a configuration file
(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file config-dir)))

;; UI settings
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)

;; Use other file for `customize` settings
(setq custom-file (expand-file-name "custom.el" config-dir))
;; Load themes directory
(add-to-list 'custom-theme-load-path (expand-file-name "themes" config-dir))
;; Use Tokyo Night theme
(load-theme 'tokyo t)

;; Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Modify used certificates
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
;; Add `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Load `use-package`
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Evil Mode (Vim keybindings)
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-leader nil (kbd "SPC"))
  (load-user-file "keybindings.el"))
;; Evil Mode for other parts of Emacs
(use-package evil-collection
  :config
  (evil-collection-init))

;; Load all packages (from `packages` directory)
(mapc 'load (file-expand-wildcards (concat config-dir "packages/*")))

;; Load additional configuration options and settings
(load-user-file "options.el")
