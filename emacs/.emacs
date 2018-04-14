(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (js2-mode web-mode avy-flycheck company use-package tide smartparens smart-mode-line neotree monokai-theme ivy indent-guide all-the-icons))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun init-repositories ()
  "Add all required repositories."
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives
               '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives
               '("marmalade" . "https://marmalade-repo.org/packages/") t)
  )

;; Enable and configure the package manager
(require 'package)
(package-initialize)
(init-repositories)

;; Check if all packages are installed and up-to-date
(require 'cl-lib)

(defvar my-packages
  '(monokai-theme web-mode js2-mode company neotree all-the-icons flycheck ivy indent-guide smartparens tide)
  "A list of packages to ensure are installed at launch.")

(defun my-packages-installed-p ()
  (cl-loop for p in my-packages
           when (not (package-installed-p p)) do (cl-return nil)
           finally (cl-return t)))

(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; Use use-package to load needed packages
(eval-when-compile
  (require 'use-package))
;; Load the packages
(use-package all-the-icons)
(use-package neotree
  :config
  (defvar neotree-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (neotree-show)
  )
(use-package indent-guide)

;; Themes
;; Use monokai
(load-theme 'monokai t)
;; Initialize the modeline
;(defvar sml/mode-with 'full)
;(add-hook 'after-init-hook 'sml/setup)
;; Use Ivy
(ivy-mode 1)
(defvar ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; Hide the Splash Screen
(setq inhibit-startup-screen t)

;; Disable the tool-, menu- and scrollbar
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; Keyboard shortcuts
;; Reload the .emacs file
(defun reload(arg)
  (interactive "p")
  (load-file "~/.emacs")
  )
(global-set-key (kbd "C-x w") 'reload)

;; Programming
;; If not otherwise specified, indent using 4 spaces
(setq-default
 indent-tabs-mode nil
 tab-width 4)
;; Autocompletion (and other stuff) of parentheses
;; (I always want that)
(use-package smartparens-config
  :config
  ;; Always enable smartparens
  (smartparens-global-mode t))

;; Syntax checking
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save new-line))
  (setq flycheck-global-modes '(not org-mode text-mode))
  ;; Also enable flycheck to work with .tsx files
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  :init (global-flycheck-mode))

;; Use tide when we open a .tsx file
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; Setup tide for further usage
(defun setup-tide-mode()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save-mode-enabled))
  (eldoc-mode +1)
  (smartparens-mode)
  (tide-hl-identifier-mode +1))

(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; Prevent Emacs from doing shit with the clipboard, which leads to Emacs freezing
(setq x-select-enable-clipboard-manager nil)
(setq select-enable-primary nil)

(provide '.emacs)
;;; .emacs ends here
