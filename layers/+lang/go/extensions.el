(setq go-pre-extensions
  '(
    ;; pre extension gos go here
    ))

(setq go-post-extensions
  '(
    ;; post extension gos go here
    go-guru
    go-oracle
    go-rename
    ))

;; For each extension, define a function go/init-<extension-go>
;;
;; (defun go/init-my-extension ()
;;   "Initialize my extension"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun load-gopath-file(gopath name)
  "Search for NAME file in all paths referenced in GOPATH."
  (let* ((sep (if (spacemacs/system-is-mswindows) ";" ":"))
         (paths (split-string gopath sep))
         found)
    (loop for p in paths
          for file = (concat p name) when (file-exists-p file)
          do
          (load-file file)
          (setq found t)
          finally return found)))

(defun go/init-go-guru()
  (let ((go-path (getenv "GOPATH")))
    (if (not go-path)
        (spacemacs-buffer/warning
         "GOPATH variable not found, go-guru configure skipeed.")
      (when (load-gopath-file
             go-path "/src/golang.org/x/tools/cmd/guru/go-guru.el")
        (spacemacs/declare-prefix-for-mode 'go-mode "mj" "go-guru")
        (spacemacs/set-leader-keys-for-major-mode 'go-mode
          "jj" 'go-guru-definition ; j for jump
          "jd" 'go-guru-describe
          "jf" 'go-guru-freevars
          "ji" 'go-guru-implements
          "jc" 'go-guru-peers ; c for channel
          "jr" 'go-guru-referrers
          "jp" 'go-guru-pointsto
          "js" 'go-guru-callstack ; s for stack
          "je" 'go-guru-whicherrs ; e for error
          "j<" 'go-guru-callers
          "j>" 'go-guru-callees
          "jx" 'go-guru-expand-region)))))

(defun go/init-go-oracle()
  (let ((go-path (getenv "GOPATH")))
    (if (not go-path)
        (spacemacs-buffer/warning
         "GOPATH variable not found, go-oracle configuration skipped.")
      (when (load-gopath-file
             go-path "/src/golang.org/x/tools/cmd/oracle/oracle.el")
        (spacemacs/declare-prefix-for-mode 'go-mode "mr" "rename")
        (spacemacs/set-leader-keys-for-major-mode 'go-mode
          "ro" 'go-oracle-set-scope
          "r<" 'go-oracle-callers
          "r>" 'go-oracle-callees
          "rc" 'go-oracle-peers
          "rd" 'go-oracle-definition
          "rf" 'go-oracle-freevars
          "rg" 'go-oracle-callgraph
          "ri" 'go-oracle-implements
          "rp" 'go-oracle-pointsto
          "rr" 'go-oracle-referrers
          "rs" 'go-oracle-callstack
          "rt" 'go-oracle-describe)))))

(defun go/init-go-rename()
  (use-package go-rename
    :init
    (spacemacs/set-leader-keys-for-major-mode 'go-mode "rn" 'go-rename)))
