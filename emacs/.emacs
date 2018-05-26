(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(package-selected-packages
   (quote
    (smart-mode-line-powerline-theme spaceline evil org-brain org-plus-contrib rainbow-delimiters telephone-line markdown-mode nlinum undo-tree ag dockerfile-mode js2-mode web-mode avy-flycheck company use-package tide smartparens smart-mode-line neotree monokai-theme ivy indent-guide all-the-icons)))
 '(sml/theme (quote powerline)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun init-repositories()
  (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                           ("melpa" . "https://melpa.org/packages/")
                           ("marmalade" . "https://marmalade-repo.org/packages/")
                           ("melpa-stable" . "https://stable.melpa.org/packages/")
                           ("org" . "https://orgmode.org/elpa/")))
  )

;; Enable and configure the package manager
;; NOTE: We need to first initialize the repositories, so that
;;       (package-initialize) can... Initialize them.
(require 'package)
(init-repositories)
(package-initialize)

;; Use use-package to load needed packages
(eval-when-compile
  (require 'use-package))

;;;;;; Visuals
;; Show a file sidebar (with fancy icons)
(use-package all-the-icons)
(use-package neotree
  :config
  (setq neo-window-width 35)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
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
;; Display line numbers (only in programming major modes)
(use-package nlinum
  :config
  (setq nlinum-highlight-current-line 1)
  (add-hook 'prog-mode-hook
            (lambda()
              (nlinum-mode t)))
  )
;; Match delimiters of the same level using colors
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook
            (lambda()
              (rainbow-delimiters-mode))))
;; Initialize the modeline
(use-package telephone-line
  :config
  (telephone-line-mode t))

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
;; Always highlight the current line
(hl-line-mode 1)

;;;;;; Keyboard shortcuts
;; Install the evil-mode
(use-package evil
  :config
  (evil-mode 1))
;; Reload the .emacs file
(defun reload(arg)
  (interactive "p")
  (load-file "~/.emacs"))
(defun japanese(arg)
  (interactive "p")
  (set-input-method "japanese"))
(global-set-key (kbd "C-x w") 'reload)
(global-set-key (kbd "C-c k") 'ag)
(global-set-key (kbd "C-c C-j") 'japanese)
(global-set-key (kbd "C-;") 'comment-dwim)
(global-set-key (kbd "<f8>") 'neotree-toggle)

;;; C-c as general purpose escape key sequence.
;;; Taken from https://www.emacswiki.org/emacs/Evil#toc16
(defun my-esc (prompt)
  "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
  (cond
   ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
   ;; Key Lookup will use it.
   ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
   ;; This is the best way I could infer for now to have C-c work during evil-read-key.
   ;; Note: As long as I return [escape] in normal-state, I don't need this.
   ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
   (t (kbd "C-g"))))
(define-key key-translation-map (kbd "C-c") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator state, which
;; doesn't use the key-translation-map.
(define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)

;;;;;; Programming
;; If not otherwise specified, indent using 4 spaces
(setq-default
 indent-tabs-mode nil
 tab-width 4)
;; Show lines visualizing the indentation
;; (use-package indent-guide
;;   :config
;;   ;; Enable indent-guide globally...
;;   (indent-guide-global-mode)
;;   ;; ... except for these modes
;;   (setq indent-guide-inhibit-modes '(org-mode text-mode neotree-mode custom-mode))
;;   )
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
  (setq flycheck-global-modes '(not org-mode text-mode neotree-mode custom-mode))
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
;; Markdown Mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
;; Org Mode
;;(use-package org-drill)
(use-package org-brain :ensure t
  :init
  (setq org-brain-path "directory/path/where-i-want-org-brain")
  :config
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12))

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

;;;;;; Editor Behaviour
;; Prevent Emacs from doing shit with the clipboard, which leads to Emacs freezing
(setq x-select-enable-clipboard-manager nil)
(setq select-enable-primary nil)
;; Don't create backup files
(setq make-backup-files nil)
;; Smooth scrolling
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

(provide '.emacs)
;;; .emacs ends here
