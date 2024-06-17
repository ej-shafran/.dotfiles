;; Company (autocomplete)
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (evil-define-key 'insert 'global (kbd "C-n") 'company-complete)
  (evil-define-key 'insert 'company-mode (kbd "C-y") 'company-complete-selection)
  ;; Disable some default keybindings
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-active-map (kbd "<tab>") nil))

;; Ivy (better command completion)
(use-package ivy
  :ensure t
  :config
  (ivy-mode))
