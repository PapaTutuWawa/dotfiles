(custom-set-variables
 '(package-selected-packages
   (quote
    (nlinum undo-tree ag dockerfile-mode js2-mode web-mode avy-flycheck company use-package tide smartparens smart-mode-line neotree monokai-theme ivy indent-guide all-the-icons))))

(custom-set-faces )

(defun init-repositories()
  (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                           ("melpa" . "https://melpa.org/packages/")
                           ("marmalade" . "https://marmalade-repo.org/packages/")))
  )

;; Enable and configure the package manager
(require 'package)
(package-initialize)
(init-repositories)

;; Use use-package to load needed packages
(eval-when-compile
(require 'use-package))

;;;;;; Visuals
;; Show a file sidebar (with fancy icons)
(use-package all-the-icons)
(use-package neotree
  :config
  (defvar neotree-smart-open t)
  (setq neo-window-width 35)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (neotree-show)
  )
;; Spacemacs-y undo tree
(use-package undo-tree
  :config
  ;; Be always accessible
  (global-undo-tree-mode)
  ;; Show only the undo tree
  (setq undo-tree-visualizer-diff nil)
  )
;; Use monokai
(load-theme 'monokai t)
;; Display line numbers
(use-package nlinum
  :config
  (global-nlinum-mode)
  (setq nlinum-highlight-current-line 1)
  )
;; Initialize the modeline
;(defvar sml/mode-with 'full)
;(add-hook 'after-init-hook 'sml/setup)
;; Spacemacs-y autocomplete
(ivy-mode 1)
(defvar ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; Hide the Splash Screen
(setq inhibit-startup-screen t)
;; Disable the tool-, menu- and scrollbar
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;;;;;; Keyboard shortcuts
;; Reload the .emacs file
(defun reload(arg)
  (interactive "p")
  (load-file "~/.emacs")
  )
(global-set-key (kbd "C-x w") 'reload)
(global-set-key (kbd "C-c k") 'ag)

;;;;;; Programming
;; If not otherwise specified, indent using 4 spaces
(setq-default
 indent-tabs-mode nil
 tab-width 4)
;; Show lines visualizing the indentation
(use-package indent-guide
  :config
  ;; Enable indent-guide globally...
  (indent-guide-global-mode)
  ;; ... except for these modes
  (setq indent-guide-inhibit-modes '(org-mode text-mode neotree-mode))
  )
;; Autocompletion (and other stuff) of parentheses
(use-package smartparens-config
  :config
  ;; Always enable smartparens
  (smartparens-global-mode t))
;; Syntax checking
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save new-line))
  (setq flycheck-global-modes '(not org-mode text-mode neotree-mode))
  ;; Also enable flycheck to work with .tsx files
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  :init (global-flycheck-mode))

;;;;;; Modes
;; Yaml Mode for *.yml and *.yaml
;; (Needs to be cloned https://github.com/yoshiki/yaml-mode)
(add-to-list 'load-path "~/.emacs.d/yaml/")
(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
          (lambda()
            (define-key 'yaml-mode-map "\C-m" 'newline-and-indent)))
;; Go Mode
(add-to-list 'load-path "~/.emacs.d/go-mode")
(use-package go-mode)
;; Dockerfile mode
(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
  )

;;;;;; Typescript
;; Setup tide for further usage
(defun setup-tide-mode()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save-mode-enabled))
  (eldoc-mode +1)
  (smartparens-mode)
  (tide-hl-identifier-mode +1))
;; Use tide when we open a .tsx file
(use-package web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; Prevent Emacs from doing shit with the clipboard, which leads to Emacs freezing
(setq x-select-enable-clipboard-manager nil)
(setq select-enable-primary nil)

(provide '.emacs)
;;; .emacs ends here
