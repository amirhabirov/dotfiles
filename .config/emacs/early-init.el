;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

(defconst my-debug nil)
(defconst my-gc-cons-percentage gc-cons-percentage)

(setq
 gc-cons-threshold most-positive-fixnum
 gc-cons-percentage 1)

(defun my-restore-gc-values ()
  "Change the garbage collection variables to their post-startup values."
  (setq
   gc-cons-threshold (* 128 1024 1024) ; 128 MiB
   gc-cons-percentage my-gc-cons-percentage))

(add-hook 'emacs-startup-hook #'my-restore-gc-values)

(setq load-prefer-newer t)

(unless my-debug
  (setq inhibit-message t)
  
  (defun my-restore-inhibit-message ()
    "Restore `inhibit-message` to its default value."
    (setq inhibit-message nil))
  
  (add-hook 'emacs-startup-hook #'my-restore-inhibit-message)

  (setq inhibit-redisplay t)
  
  (defun my-restore-inhibit-redisplay ()
    "Restore `inhibit-redisplay` to its default value."
    (setq inhibit-redisplay nil))
  
  (add-hook 'emacs-startup-hook #'my-restore-inhibit-redisplay)

  (defconst my-mode-line-format mode-line-format)

  (defun my-restore-mode-line-format ()
    "Change `mode-line-format` to its default value."
    (setq mode-line-format my-mode-line-format))

  (add-hook 'emacs-startup-hook #'my-restore-mode-line-format))

(setq ffap-machine-p-known 'reject)

(setq ad-redefinition-action 'accept)

(setq inhibit-compacting-font-caches t)

(setq frame-inhibit-implied-resize t)

(setq frame-resize-pixelwise t)

(dolist (basic-ui-elt
	 '((menu-bar-lines . 0)
	   (tool-bar-lines . 0)
	   (horizontal-scroll-bars . nil)
	   (vertical-scroll-bars . nil)
	   (left-fringe . 0)
	   (right-fringe . 0)
	   (font . "Illinois Mono Medium:pixelsize=28")))
  (push basic-ui-elt default-frame-alist))

(global-font-lock-mode -1)

(setq custom-theme-directory (expand-file-name "themes/" user-emacs-directory))

(load-theme 'buistvo-krasok t)

(setq
 inhibit-startup-screen t
 inhibit-startup-message t
 inhibit-startup-echo-area-message t
 inhibit-startup-buffer-menu t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq package-enable-at-startup nil)

(setq package-quickstart t)

(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq package-archive-priorities
      '(("melpa" . 99)
	("gnu" . 66)
	("nongu" . 33)))

(setq
 use-package-expand-minimally t
 use-package-always-ensure t
 use-package-always-defer t)

(setq
 initial-buffer-choice nil
 initial-major-mode 'fundamental-mode
 initial-scratch-message nil)

(blink-cursor-mode -1)
