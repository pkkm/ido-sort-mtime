ido-sort-mtime
==============

Emacs minor mode that displays recently modified files at the beginning of Ido's file list.

To activate after installing, add to `~/.emacs.d/init.el`:

    (ido-sort-mtime-mode 1)

To display TRAMP files before local ones, use:

    (setq ido-sort-mtime-tramp-files-at-end nil)

(Checking modification time for TRAMP files is not supported.)

To display `.` at the beginning of the list, use:

    (setq ido-sort-mtime-dot-at-beginning t)
    
If sorting by modification time is too slow in large directories, you can limit the number of files for which it will be used:

    (setq ido-sort-mtime-limit 2000)

See also: `M-x customize-group RET ido-sort-mtime RET`.
