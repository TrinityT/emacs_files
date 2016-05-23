;;; NOTICE: 新規環境構築する場合のコマンド例
;;; $ rm -rf ~/.emacs
;;; $ rm -rf ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/elisp ~/.emacs.d
;;; $ ln -fns ~/Dropbox/development/emacs_files/init.el ~/.emacs.d/init.el
;;; $ sudo apt-get install elscreen emacs-goodies-el xsel php-elisp lv

;;; デフォルトload-path
(add-to-list 'load-path "~/.emacs.d/elisp/")

;;; 初期ディレクトリ
;(cd "/home/takakura/")
(cd "/home/takakura/development/bdff/server")

;; memory-size
(setq max-lisp-eval-depth 3000)
(setq max-specpdl-size 6000)

;;; auto-install設定
(require 'auto-install)
;  (setq auto-install-directory "~/.emacs.d/elisp/")
;  (auto-install-update-emacswiki-package-name t)
;  (auto-install-compatibility-setup)

;;M-nで別窓でファイルを開く
(global-set-key "\M-n" 'find-file-other-frame)

;;M-gで業ジャンプ
(global-set-key "\M-g" 'goto-line)

;;; grep設定
(setq grep-host-defaults-alist nil)
(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e grep -nH -e <R>")
;;; ※grepにlgrepを使用する場合
;(setq grep-template "lgrep <C> -n <R> <F> <N>")
;(setq grep-find-template "find . <X> -type f <F> -print0 | xargs -0 -e lgrep -n -Ou8 <R>")

;;; 大文字小文字区別有効
(setq-default case-fold-search nil)

;;; デフォルト文字コード設定
;(set-default-coding-systems 'sjis)
;(setq auto-coding-functions nil)

;;スクロール量を1にする
(defun sane-next-line (arg)
  "Goto next line by ARG steps with scrolling sanely if needed."
  (interactive "p")
  ;;(let ((newpt (save-excursion (line-move arg) (point))))
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

;;; 基本操作設定
(setq line-number-mode t) ;;カーソル行番号表示
(setq column-number-mode t) ;;カーソル列番号表示
(setq inhibit-startup-message t) ;;スタートアップメッセージ非表示
(display-time) ;;auto-compression-mode t) ;;日本語info文字化け防止
(show-paren-mode 1) ;;対応括弧ハイライト
(setq make-backup-files nil) ;; *.~ とかのバックアップファイルを作らない
(setq auto-save-default nil) ;; .#* とかのバックアップファイルを作らない
(global-set-key "\C-h" 'delete-backward-char) ;; backspace
(setq-default transient-mark-mode t)

;; 行末の(タブ・半角スペース)を削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 起動時のサイズ,表示位置
(setq default-frame-alist
      (append (list
         '(font . "Ricty-10")
         '(width . 200)
	       '(height . 60)
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

;;; tramp明示指定
;;; ※ 指定しないと「Recursive load: "/usr/share/emacs/23.2/lisp/net/tramp.elc",〜」が時々発生
;;; ※ http://xahlee.org/emacs/emacs_on_ubuntu_linux.html
(require 'tramp)

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

;;; Undoバッファを無限にする
(setq undo-outer-limit nil)

;;; ウィンドウ切り替えをShift+矢印でできるようにする
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;; ウィンドウ切り替えをCtrl+tでできるようにする
(define-key global-map (kbd "C-t") 'other-window)

;;; undo-redo
(require 'redo+)
(setq undo-no-redo t)
(global-set-key "\C-\\" 'redo)

;;; indent-region別名設定
(define-key global-map (kbd "C-c i") 'indent-region)

;;; タブ設定
(setq-default tab-width 2 indent-tabs-mode nil)

;;; クリップボード共有設定(xselを使用している。)
;(setq interprogram-paste-function
;    (lambda ()
;       (shell-command-to-string "xsel -b -o")))
;(setq interprogram-cut-function
;    (lambda (text &optional rest)
;       (let* ((process-connection-type nil)
;              (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
;         (process-send-string proc text)
;         (process-send-eof proc))))
;;; clipboard
(if (display-graphic-p)
    (progn
      ;; if on window-system
      (setq x-select-enable-clipboard t)
      (global-set-key "\C-y" 'x-clipboard-yank))
  ;; else (on terminal)
  (setq interprogram-paste-function
        (lambda ()
          (shell-command-to-string "xsel -b -o")))
  (setq interprogram-cut-function
        (lambda (text &optional rest)
          (let* ((process-connection-type nil)
                 (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
            (process-send-string proc text)
            (process-send-eof proc)))))

;;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;;; dsvn設定
(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)

;;; magit設定
(require 'magit)
(fset 'mg (symbol-function 'magit-status))
;; git blame
;(add-to-list 'load-path "~/.emacs.d/elisp/mo-git-blame")
;(autoload 'mo-git-blame-file "mo-git-blame" nil t)
;(autoload 'mo-git-blame-current "mo-git-blame" nil t)

;;; メニューを日本語化
(require 'menu-tree)

;;; grep-edit
(require 'grep-edit)

;;; line-number表示
(require 'linum)
(global-linum-mode t)
(setq linum-format "%5d ")

;;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)

;;; elscreen
(add-to-list 'load-path "~/.emacs.d/elisp/elscreen")
(require 'elscreen)

;;; 矩形用cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止
(global-set-key "\C-r" 'cua-set-rectangle-mark) ;; Ctrl+rで起動

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
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(set-face-foreground 'whitespace-tab "yellow")
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "yellow")
(set-face-background 'whitespace-space "red")
(set-face-underline  'whitespace-space t)
(put 'upcase-region 'disabled nil)

;; Yasnippet
;(add-to-list 'load-path "~/.emacs.d/elisp")
;(require 'yasnippet)
;(add-hook 'cake-hook
;              #'(lambda ()
;                  (setq yas/mode-symbol 'cake)))
;(yas/initialize)
;(yas/load-directory "~/.emacs.d/plugins/yasnippet/snippets")
;(yas/load-directory "~/.emacs.d/elisp/emacs-cake/snippets")

; Windowサイズ変更
; M-x my-window-ctrl
;; C-p:上に移動
;; C-n:下に移動
;; C-f:右に移動
;; C-b:左に移動
;; p:サイズ縮小
;; n:サイズ拡大
;; f:サイズ拡大
;; b:サイズ縮小
;; C-a:画面左端へ移動
;; q:終了．適当な位置，サイズになったら，q
(defun my-window-ctrl ()
   "Window size and position control."
   (interactive)
   (let* ((rlist (frame-parameters (selected-frame)))
          (tMargin (cdr (assoc 'top rlist)))
          (lMargin (cdr (assoc 'left rlist)))
          (displaywidth (x-display-pixel-width))
          (displayheight (x-display-pixel-height))
          (fObj (selected-frame))
          (nCHeight (frame-height))
          (nCWidth (frame-width))
          endFlg
          c)
     (catch 'endFlg
       (while t
         (message "locate[%d:%d] size[%dx%d] display[%dx%d]"
                  lMargin tMargin nCWidth nCHeight
                  displaywidth displayheight)
         (set-mouse-position
          (if (featurep 'meadow)
              (selected-frame) (selected-window)) nCWidth 0)
         (setq c (read-char))
         (cond ((= c ?f)
                (set-frame-width fObj (setq nCWidth (+ nCWidth 2))))
               ((= c ?b)
                (set-frame-width fObj (setq nCWidth (- nCWidth 2))))
               ((= c ?n)
                (set-frame-height fObj (setq nCHeight (+ nCHeight 2))))
               ((= c ?p)
                (set-frame-height fObj (setq nCHeight (- nCHeight 2))))
               ((= c 6)
                (modify-frame-parameters
                 nil (list (cons 'left (setq lMargin (+ lMargin 20))))))
               ((= c 2)
                (modify-frame-parameters
                 nil (list (cons 'left (setq lMargin (- lMargin 20))))))
               ((= c 14)
                (modify-frame-parameters
                 nil (list (cons 'top (setq tMargin (+ tMargin 20))))))
               ((= c 16)
                (modify-frame-parameters
                 nil (list (cons 'top (setq tMargin (- tMargin 20))))))
               ((= c 1)
                (modify-frame-parameters
                 nil (list (cons 'left (setq lMargin 0)))))
               ((= c 5)
                (modify-frame-parameters
                 nil
                 (list
                  (cons 'left
                        (setq lMargin
                              (- displaywidth (frame-pixel-width)))))))
               ((= c ?q) (message "quit") (throw 'endFlg t)))))))


;;# Ruby #########################################################################
;; rvm読み込み
(require 'rvm)
(defadvice ido-completing-read (around invaild-ido-completing-read activate)
  "ido-completing-read -> completing-read"
  (complete-read))
(rvm-use-default)

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
(custom-set-variables '(rspec-use-rake-flag nil))

;; ruby-electric.el --- ダブルクォートのみ無効
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
(defun ruby-electric-setup-keymap()
  (define-key ruby-mode-map " " 'ruby-electric-space)
;;;   (define-key ruby-mode-map "{" 'ruby-electric-curlies)
;;;   (define-key ruby-mode-map "(" 'ruby-electric-matching-char)
;;;   (define-key ruby-mode-map "[" 'ruby-electric-matching-char)
;;;   (define-key ruby-mode-map "\"" 'ruby-electric-matching-char)
;;;   (define-key ruby-mode-map "\'" 'ruby-electric-matching-char)
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
(setq rsense-home "/home/takakura/.emacs.d/elisp/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
;; (add-hook 'ruby-mode-hook
;;           '(lambda ()
;;              ;; .や::を入力直後から補完開始
;;              (add-to-list 'ac-sources 'ac-source-rsense-method)
;;              (add-to-list 'ac-sources 'ac-source-rsense-constant)
;;              ;; C-x .で補完出来るようキーを設定
;;              (define-key ruby-mode-map (kbd "C-x .") 'ac-complete-rsense)))

;;# YAML ########################################################################
(require 'yaml-mode) (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;# PHP #########################################################################
;;; php-mode
(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-hook
          '(lambda ()
             (setq tab-width 4)
             (setq indent-tabs-mode nil)
             (setq c-basic-offset 4)
             (c-set-offset 'arglist-intro '+)
             (c-set-offset 'arglist-close 0)))
(add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))
(add-hook 'php-mode-hook '(lambda () (set-default-coding-systems     'Shift_Jis)))
(add-hook 'php-mode-hook '(lambda () (set-buffer-file-coding-system  'Shift_Jis)))
(add-hook 'php-mode-hook '(lambda () (set-terminal-coding-system     'Shift_Jis)))

;;; emacs-cake
(add-to-list 'load-path "~/.emacs.d/elisp/emacs-cake")
(require 'cake)
(global-cake t)
(require 'anything-c-cake)
(setq anything-sources (list anything-c-source-cake))
(require 'ac-cake)
(add-hook 'php-mode-hook
          (lambda ()
            (make-local-variable 'ac-sources)
            (setq ac-sources '(ac-source-cake
                               ac-source-gtags
                               ac-source-yasnippet
                               ac-source-php-completion
                               ))))


(put 'downcase-region 'disabled nil)

;;# Scala #######################################################################
(add-to-list 'load-path "~/.emacs.d/elisp/scala-mode")
(require 'scala-mode-auto)

;;# ActionScript #######################################################################
(require 'actionscript-mode)
(setq auto-mode-alist
      (append '(("\\.\\(as\\|mxml\\)" . actionscript-mode))
              auto-mode-alist))

;;# JavaScript #######################################################################
;;; js2-mode
(add-to-list 'load-path "~/.emacs.d/elisp/js2-mode")
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)$" . js2-mode))

; fixing indentation
; refer to http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
;; (autoload 'espresso-mode "espresso")

;; (defun my-js2-indent-function ()
;;   (interactive)
;;   (save-restriction
;;     (widen)
;;     (let* ((inhibit-point-motion-hooks t)
;;            (parse-status (save-excursion (syntax-ppss (point-at-bol))))
;;            (offset (- (current-column) (current-indentation)))
;;            (indentation (espresso--proper-indentation parse-status))
;;            node)

;;       (save-excursion

;;         ;; I like to indent case and labels to half of the tab width
;;         (back-to-indentation)
;;         (if (looking-at "case\\s-")
;;             (setq indentation (+ indentation (/ espresso-indent-level 2))))

;;         ;; consecutive declarations in a var statement are nice if
;;         ;; properly aligned, i.e:
;;         ;;
;;         ;; var foo = "bar",
;;         ;;     bar = "foo";
;;         (setq node (js2-node-at-point))
;;         (when (and node
;;                    (= js2-NAME (js2-node-type node))
;;                    (= js2-VAR (js2-node-type (js2-node-parent node))))
;;           (setq indentation (+ 4 indentation))))

;;       (indent-line-to indentation)
;;       (when (> offset 0) (forward-char offset)))))

;; (defun my-indent-sexp ()
;;   (interactive)
;;   (save-restriction
;;     (save-excursion
;;       (widen)
;;       (let* ((inhibit-point-motion-hooks t)
;;              (parse-status (syntax-ppss (point)))
;;              (beg (nth 1 parse-status))
;;              (end-marker (make-marker))
;;              (end (progn (goto-char beg) (forward-list) (point)))
;;              (ovl (make-overlay beg end)))
;;         (set-marker end-marker end)
;;         (overlay-put ovl 'face 'highlight)
;;         (goto-char beg)
;;         (while (< (point) (marker-position end-marker))
;;           ;; don't reindent blank lines so we don't set the "buffer
;;           ;; modified" property for nothing
;;           (beginning-of-line)
;;           (unless (looking-at "\\s-*$")
;;             (indent-according-to-mode))
;;           (forward-line))
;;         (run-with-timer 0.5 nil '(lambda(ovl)
;;                                    (delete-overlay ovl)) ovl)))))

;; (defun my-js2-mode-hook ()
;;   (require 'espresso)
;;   (setq espresso-indent-level 4
;;         indent-tabs-mode nil
;;         c-basic-offset 4)
;;   (c-toggle-auto-state 0)
;;   (c-toggle-hungry-state 1)
;;   (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
;;   ; (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
;;   (define-key js2-mode-map "\C-\M-\\"
;;     '(lambda()
;;        (interactive)
;;        (insert "/* -----[ ")
;;        (save-excursion
;;          (insert " ]----- */"))
;;        ))
;;   (define-key js2-mode-map "\C-m" 'newline-and-indent)
;;   ; (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
;;   ; (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
;;   (define-key js2-mode-map "\C-\M-q" 'my-indent-sexp)
;;   (if (featurep 'js2-highlight-vars)
;;       (js2-highlight-vars-mode))
;;   (message "My JS2 hook"))

;; (add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;# anything.el #######################################################################
(setq anything-mode-line-string nil)

;; package.el
(require 'package)
;;リポジトリ
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "vendor/elpa"))
;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)

;;; dired を使って、一気にファイルの coding system (漢字) を変換する
;; m でマークして T で一括変換
;; (require 'dired-aux)
;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (define-key (current-local-map) "T"
;;               'dired-do-convert-coding-system)))

;; (defvar dired-default-file-coding-system nil
;;   "*Default coding system for converting file (s).")

;; (defvar dired-file-coding-system 'no-conversion)

;; (defun dired-convert-coding-system ()
;;   (let ((file (dired-get-filename))
;;         (coding-system-for-write dired-file-coding-system)
;;         failure)
;;     (condition-case err
;;         (with-temp-buffer
;;           (insert-file file)
;;           (write-region (point-min) (point-max) file))
;;       (error (setq failure err)))
;;     (if (not failure)
;;         nil
;;       (dired-log "convert coding system error for %s:\n%s\n" file failure)
;;       (dired-make-relative file))))

;; (defun dired-do-convert-coding-system (coding-system &optional arg)
;;   "Convert file (s) in specified coding system."
;;   (interactive
;;    (list (let ((default (or dired-default-file-coding-system
;;                             buffer-file-coding-system)))
;;            (read-coding-system
;;             (format "Coding system for converting file (s) (default, %s): "
;;                     default)
;;             default))
;;          current-prefix-arg))
;;   (check-coding-system coding-system)
;;   (setq dired-file-coding-system coding-system)
;;   (dired-map-over-marks-check
;;    (function dired-convert-coding-system) arg 'convert-coding-system t))
