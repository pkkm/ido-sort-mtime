;;; ido-sort-mtime.el --- Sort Ido's file list by modification time

;; Copyright (C) 2013 Paweł Kraśnicki

;; Author: Paweł Kraśnicki
;; Created: 24 Apr 2013
;; Version: 0.1
;; Keywords: convenience, files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Display recently modified files at the beginning of Ido's file list.
;;
;; To activate, add the following lines to ~/.emacs:
;;   (require 'ido-sort-mtime)
;;   (ido-sort-mtime-mode 1)
;;
;; To put TRAMP files before local ones, use:
;;   (setq ido-sort-mtime-tramp-files-at-end t)
;;
;; See also: M-x customize-group RET ido-sort-mtime RET

;;; Code:

(require 'ido)

(defcustom ido-sort-mtime-tramp-files-at-end t
  "Non-nil causes files handled by TRAMP to appear at the end of the file list.
Nil causes them to appear at the beginning.
(Checking modification time for TRAMP files is not yet supported.)"
  :type 'boolean
  :group 'ido-sort-mtime)

(define-minor-mode ido-sort-mtime-mode
  "Sort files in Ido's file list by modification time."
  nil nil nil :global t
  (if ido-sort-mtime-mode
      (progn
        (add-hook 'ido-make-file-list-hook 'ido-sort-mtime--sort)
        (add-hook 'ido-make-dir-list-hook 'ido-sort-mtime--sort))
    (remove-hook 'ido-make-file-list-hook 'ido-sort-mtime--sort)
    (remove-hook 'ido-make-dir-list-hook 'ido-sort-mtime--sort)))

(defun ido-sort-mtime--file-modtime (file)
  "Get the last modification time of FILE.
If FILE cannot be read, return nil."
  (let ((attributes (file-attributes file)))
    (if attributes
        (nth 5 attributes)
      nil)))

(defun ido-sort-mtime--file-modified-later-p (file-a file-b)
  "Return t if FILE-A was modified later than FILE-B.
If FILE-B cannot be read, return t. If FILE-A cannot be read, nil."
  (let ((modtime-a (ido-sort-mtime--file-modtime file-a))
        (modtime-b (ido-sort-mtime--file-modtime file-b)))
    (cond
     ((not modtime-b) t)
     ((not modtime-a) nil)
     (t (time-less-p modtime-b modtime-a)))))

(defun ido-sort-mtime--sort ()
  "Sort Ido's file list by modification time (most recent first).
Display TRAMP files after or before local files, depending on `ido-sort-mtime-tramp-files-at-end`."
  (setq ido-temp-list
        (sort ido-temp-list
              (lambda (a b)
                (cond
                 ;; TRAMP files: don't check mtime, display at the end (after local files).
                 ;; They will be sorted alphabetically (because `ido-temp-list` is sorted to start with).
                 ;; `concat` instead of `expand-file-name`, because the latter will try to access the file.
                 ((string-match tramp-file-name-regexp (concat ido-current-directory a))
                  (not ido-sort-mtime-tramp-files-at-end))
                 ((string-match tramp-file-name-regexp (concat ido-current-directory b))
                  ido-sort-mtime-tramp-files-at-end)

                 ;; Local files: display the most recently modified first.
                 (t (ido-sort-mtime--file-modified-later-p
                     (expand-file-name a ido-current-directory)
                     (expand-file-name b ido-current-directory))))))))

(provide 'ido-sort-mtime)
;;; ido-sort-mtime.el ends here.
