;;; NOTICE: 新規環境構築する場合のコマンド例
;;; ● Linux系
;;; $ rm -rf ~/.emacs
;;; $ rm -rf ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/elisp ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/init.el ~/.emacs.d/init.el
;;; $ sudo apt-get install emacs-goodies-el xsel php-elisp lv

;;; ● Mac
;;; $ rm -rf ~/.emacs
;;; $ rm -rf ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/elisp ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/init.el ~/.emacs.d/init.el

;; 追加パッケージリスト
;; magit dired+ elscreen elscreen-persist mmm-mode undo-tree

;; package.el

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(setq package-user-dir (concat user-emacs-directory "vendor/elpa"))

;;; パッケージ初期化前に行う必要がある設定値はここに書く ######################################################################
;; Dired+
(setq diredp-hide-details-initially-flag nil)

(package-initialize)
;#######################################################################################################################

(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;; デフォルト文字色
(set-face-background 'fringe "#151515")

;;; デフォルトload-path
(add-to-list 'load-path "~/.emacs.d/elisp/")

;;; 初期ディレクトリ
(cd "~/development/bdff/server")

;; memory-size
(setq max-lisp-eval-depth 3000)
(setq max-specpdl-size 6000)

;;# ディレクトリ操作関連 #############################################################################
;;; Dired+
(diredp-toggle-find-file-reuse-dir 1)

;; 文字数インジケータ
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
(setq-default fci-rule-column 120)
(setq fci-rule-width 1)
(setq fci-rule-color "darkblue")

;;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
(setq ido-auto-merge-work-directories-length -1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
(when (boundp 'confirm-nonexistent-file-or-buffer)
  (setq confirm-nonexistent-file-or-buffer nil))
(global-set-key (kbd "C-x f") 'ido-find-file-other-window)

;;; 矩形用cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止
(global-set-key "\C-r" 'cua-set-rectangle-mark) ;; Ctrl+rで起動

;;; grep設定
(require 'wgrep)
(setf wgrep-enable-key "e")
(require 'grep-edit)

;;; 文字列置換
(fset 'rs (symbol-function 'replace-string))

;;; 大文字小文字区別有効
(setq-default case-fold-search nil)

;;; C-zを無効化する(elscreen用に再バインドするため)
(global-set-key "\C-z" nil)

;;; C-cを無効化してexitコマンドを追加
(global-unset-key (kbd "C-x C-c"))
(defalias 'exit 'save-buffers-kill-emacs)

;;スクロール量を1にする
(defun sane-next-line (arg)
  "Goto next line by ARG steps with scrolling sanely if needed."
  (interactive "p")
  (let ((newpt (save-excursion (next-line arg) (point))))
    (while (null (pos-visible-in-window-p newpt))
      (if (< arg 0) (scroll-down 1) (scroll-up 1)))
    (goto-char newpt)
    (setq this-command 'next-line)
    ()))
(defun sane-previous-line (arg)
  "Goto previous line by ARG steps with scrolling back sanely if needed."
  (interactive "p")
  (sane-next-line (- arg))
  (setq this-command 'previous-line)
  ())
(defun sane-newline (arg)
  "Put newline\(s\) by ARG with scrolling sanely if needed."
  (interactive "p")
  (let ((newpt (save-excursion (newline arg) (indent-according-to-mode) (point))))
    (while (null (pos-visible-in-window-p newpt)) (scroll-up 1))
    (goto-char newpt)
    (setq this-command 'newline)
    ()))
(global-set-key [up] 'sane-previous-line)
(global-set-key [down] 'sane-next-line)
(global-set-key "\C-m" 'newline-and-indent)
(define-key global-map "\C-n" 'sane-next-line)
(define-key global-map "\C-p" 'sane-previous-line)

;; スクロールバー非表示
(scroll-bar-mode -1)

;;; 基本操作設定
(setq line-number-mode t) ;;カーソル行番号表示
(setq column-number-mode t) ;;カーソル列番号表示
(setq inhibit-startup-message t) ;;スタートアップメッセージ非表示
(display-time) ;;auto-compression-mode t) ;;日本語info文字化け防止
(show-paren-mode 1) ;;対応括弧ハイライト
(setq make-backup-files nil) ;; *.~ とかのバックアップファイルを作らない
(setq auto-save-default nil) ;; .#* とかのバックアップファイルを作らない
(global-set-key "\C-h" 'delete-backward-char) ;; backspace
(setq-default tab-width 2 indent-tabs-mode nil) ;;; タブ設定
(setq-default transient-mark-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の(タブ・半角スペース)を削除
(global-set-key "\M-g" 'goto-line) ;; M-gで指定行ジャンプ

;; 起動時のサイズ,表示位置
(setq default-frame-alist
      (append (list
         '(width . 360)
         '(height . 95)
         '(top . 0)
         '(left . 0)
         )
        default-frame-alist))

;;; F11でfullscreenを切り替えられるようにする
(defun my-fullscreen ()
  (interactive)
  (let ((fullscreen (frame-parameter (selected-frame) 'fullscreen)))
    (cond
     ((null fullscreen)
      (set-frame-parameter (selected-frame) 'fullscreen 'fullboth))
     (t
      (set-frame-parameter (selected-frame) 'fullscreen 'nil))))
  (redisplay))
(global-set-key [f11] 'my-fullscreen)

;;; タイトルのファイル名を「 ディレクトリ名/ファイル名 」という表示形式にする
(setq frame-title-format (concat "%b - emacs@" (system-name)))
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-min-dir-content 1)

;;; emacs -nw で起動した時にメニューバーを消す
(if window-system (menu-bar-mode 1) (menu-bar-mode -1))

;;; ツールバー削除
(tool-bar-mode 0)

;;; 全バッファを閉じる関数
(defun killallbuffer ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;; ウィンドウ切り替えをShift+矢印でできるようにする
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;; ウィンドウ切り替えをCtrl+tでできるようにする
(define-key global-map (kbd "C-t") 'other-window)

;;; Undoバッファを無限にする
(setq undo-outer-limit nil)
;;; undo-tree
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-redo)

;;; indent-regionのバインド
(define-key global-map (kbd "C-c i") 'indent-region)

;;; クリップボード共有設定
;;; 設定_Linux(xselを使用している。)
;; (setq interprogram-paste-function
;;     (lambda ()
;;        (shell-command-to-string "xsel -b -o")))
;; (setq interprogram-cut-function
;;     (lambda (text &optional rest)
;;        (let* ((process-connection-type nil)
;;               (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
;;          (process-send-string proc text)
;;          (process-send-eof proc))))
;; clipboard
;; (if (display-graphic-p)
;;     (progn
;;       ;; if on window-system
;;       (setq x-select-enable-clipboard t)
;;       (global-set-key "\C-y" 'x-clipboard-yank))
;;   ;; else (on terminal)
;;   (setq interprogram-paste-function
;;         (lambda ()
;;           (shell-command-to-string "xsel -b -o")))
;;   (setq interprogram-cut-function
;;         (lambda (text &optional rest)
;;           (let* ((process-connection-type nil)
;;                  (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
;;             (process-send-string proc text)
;;             (process-send-eof proc)))))
;;; 設定_OSX
(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

;;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;;; magit設定
(fset 'mg 'magit-status)
;; magitウィンドウをどのバッファに開くかの設定
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode
                                 mg)))
                    nil
                  '(display-buffer-same-window)))))

;;; line-number表示
(require 'linum)
(global-linum-mode t)
(setq linum-format "%5d ")

;;; color
(require 'color-theme)
(color-theme-initialize)
(load "~/.emacs.d/elisp/color-theme-t2j.el")
(color-theme-t2j)

;; タブ, 全角スペース、改行直前の半角スペースを表示する
(global-whitespace-mode 1)
(setq whitespace-space-regexp "\\(\u3000\\)")
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(set-face-foreground 'whitespace-tab "yellow")
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "yellow")
(set-face-background 'whitespace-space "red")
(set-face-underline  'whitespace-space t)
(put 'upcase-region 'disabled nil)

;;# Ruby #########################################################################
;; ruby-modeでMagicComment抑制
(require 'ruby-mode)
(defun ruby-mode-set-encoding () ())
(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)
                                ("[Rr]akefile" . ruby-mode)
                                ("\\.rake$" . ruby-mode))
                              auto-mode-alist))
;; Rinari
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(require 'rinari)

;;; rhtml-mode
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
(lambda () (rinari-launch)))

;;; rspec-mode
(require 'rspec-mode)

;; ruby-electric.el --- ダブルクォートのみ無効
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(defun ruby-electric-setup-keymap()
  (define-key ruby-mode-map " " 'ruby-electric-space)
)

;;; ruby-mode-indent
(add-hook 'ruby-mode-hook
    '(lambda ()
         (setq tab-width 2)
))

(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle 'overlay)

;; rsense
(setq rsense-home "/Users/takakura/.emacs.d/elisp/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)

;;# YAML ##############################################################################################################
(require 'yaml-mode) (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))


;;# ActionScript ######################################################################################################
;; web-modeの設定
(require 'web-mode)
(defun web-mode-hook ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  )
(add-hook 'web-mode-hook  'web-mode-hook)

;; actionscript-modeの設定
(require 'actionscript-mode)

(add-hook 'actionscript-mode-hook 'asmode-setup)
(defun asmode-setup()
  (setq c-basic-offset 2)
  (setq tab-width 2)
  )
(setq auto-mode-alist (append '(
                                ("\\.as$" . actionscript-mode)
                                )
                              auto-mode-alist))
;; mmm-modeでmxmlでモードを混在させる
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(set-face-background 'mmm-default-submode-face nil)
(mmm-add-classes
 '((actionscript-mxml-mode
    :submode actionscript-mode
    :face mmm-code-submode-face
    :front "<!\\[CDATA\\["
    :back "\\]\\]>"
    )))
(mmm-add-mode-ext-class nil "\\.mxml\\'" 'actionscript-mxml-mode)

;;# JavaScript #######################################################################
;;; js2-mode
(add-to-list 'load-path "~/.emacs.d/elisp/js2-mode")
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)$" . js2-mode))

;;# elscreen #######################################################################
;;; プレフィクスキーはC-z
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)
(elscreen-persist-mode 1)

;;# helm.el #######################################################################
(require 'helm-config)
(helm-mode 1)
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "C-x b") 'helm-for-files)
(elscreen-separate-buffer-list-mode 1)
(setq helm-buffer-max-length 50)

;;# Windowリサイズ #####################################################################
;; ウィンドウが上のほうにあれば縦に縮小し、下のほうにあれば縦に拡大する
(defun resize-window-up ()
  (interactive)
  (let* ((edges (window-edges (selected-window)))
         (end-y (cadddr edges)))
    (if (< end-y (frame-height))
        (shrink-window 1)
      (enlarge-window 1))))

;; ウィンドウが上のほうにあれば縦に拡大し、下のほうにあれば縦に縮小する
(defun resize-window-down ()
  (interactive)
  (let* ((edges (window-edges (selected-window)))
         (end-y (cadddr edges)))
    (if (< end-y (frame-height))
        (enlarge-window 1)
      (shrink-window 1))))

;; ウィンドウが左のほうにあれば横に拡大し、右のほうにあれば横に縮小する
(defun resize-window-right ()
  (interactive)
  (let* ((edges (window-edges (selected-window)))
         (end-x (caddr edges)))
    (if (< end-x (frame-width))
        (enlarge-window-horizontally 1)
      (shrink-window-horizontally 1))))

;; ウィンドウが左のほうにあれば横に縮小し、右のほうにあれば横に拡大する
(defun resize-window-left ()
  (interactive)
  (let* ((edges (window-edges (selected-window)))
         (end-x (caddr edges)))
    (if (< end-x (frame-width))
        (shrink-window-horizontally 1)
      (enlarge-window-horizontally 1))))

(global-set-key (kbd "<M-up>") 'resize-window-up)
(global-set-key (kbd "<M-down>") 'resize-window-down)
(global-set-key (kbd "<M-right>") 'resize-window-right)
(global-set-key (kbd "<M-left>") 'resize-window-left)


(custom-set-variables

 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (elscreen-persist elscreen mmm-mode magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
