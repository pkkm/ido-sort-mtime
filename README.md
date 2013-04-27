ido-sort-mtime
==============

Emacs minor mode that displays recently modified files at the beginning of Ido's file list.

To activate after installing, add to ~/.emacs:

	(ido-sort-mtime-mode 1)

To put TRAMP files before local ones, use:

	(setq ido-sort-mtime-tramp-files-at-end t)

See also: `M-x customize-group RET ido-sort-mtime RET`.
