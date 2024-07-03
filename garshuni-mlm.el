;;; garshuni-mlm.el --- Provides Syriac Input Methods  -*- lexical-binding:t -*-

;; Copyright (C) 2024 carn181

;; Author: carn181
;; Version: 0.1
;; Keywords: input, syriac, malayalam, languages


;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'ind-util)
(require 'indian)

(defvar garshuni-mlm-base-table
  '(
    (;; VOWELS
     ("ܐܲ" nil) ("ܐܵ" ?ܵ) ("ܐܝܼ" "ܝܼ") ("ܐܝܼ" "ܝܼ") ("ܐܘܼ" "ܘܼ") ("ܐܘܼ" "ܘܼ")
     (?ܪ ?ܪ) ("ܐܸ" ?ܸ) ("ܐܹ" ?ܹ) ("ܐܵܝ" "ܵܝ")
     nil ("ܐܘܿ" "ܘܿ") ("ܐܘܿ" "ܘܿ") ("ܐܵܘ" "ܵܘ") (?݈ ?݇))
    (;; CONSONANTS
     ?ܟ ?ܟ ?ܓ ?ܓ ?ࡠ                  ;; GUTTRULS
     ?ܫ ?ܫ ?ࡡ ?ࡡ ?ࡢ                  ;; PALATALS
     ?ࡣ ?ࡣ ?ࡣ ?ࡣ ?ࡤ                  ;; CEREBRALS
     ?ܬ ?ܬ ?ܕ ?ܕ ?ܢ nil              ;; DENTALS
     ?ܒ ?ܒ ?ܒ ?ࡦ ?ܡ                  ;; LABIALS
     ?ܝ ?ܪ ?ܪ ?ܠ ?ࡨ ?ࡩ ?ܒ          ;; SEMIVOWELS
     ?ܫ ?ࡪ ?ܣ ?ܗ                    ;; SIBILANTS
     )
    (;; Misc Symbols
     nil nil nil nil ?݈ nil nil)))

(defvar garshuni-mlm-table
  '(;; for encode/decode
    (;; vowels -- 18
     "a" ("aa" "A") "i" ("ii" "I") "u" ("uu" "U")
     "R" ("E" "ae") "e" "ai"
     nil  "o"   "O"   "au"  "~")
    (;; consonants -- 40
     ("k" "c")   "kh"  "g"   "gh"  "ng"
     "ch" ("Ch" "chh") "j" "jh" "nj"
     "T"   "Th"  "D"   "Dh"  "N"
     "th"  "thh" "d"   "dh"  "n"   nil
     "p"   ("ph" "f")  "b"   "bh"  "m"
     "y"   "r"   "rr"  "l"  "L" "zh" ("v" "w")
     ("S" "z") "sh" "s" "h"
     )
    ))

;; Overwriting ind-util's function to fix consonant vowel pairs
(defun indian--puthash-cv (c trans-c v trans-v hashtbls)
  (indian--map
   (lambda (c trans-c)
     (indian--map
      (lambda (v trans-v)
	(when (and c trans-c  v trans-v)
	  (if (characterp c) (setq c (char-to-string c)))
	  ;; When matra is a string, don't make it nil like the default indian--puthash-cv
	  (setq v (if (characterp (cadr v)) (char-to-string (cadr v)) (cadr v)))
	  (if (stringp trans-c) (setq trans-c (list trans-c)))
	  (if (stringp trans-v) (setq trans-v (list trans-v)))
	  (indian--puthash-char
	   (concat c v)
	   (mapcar (lambda (x) (apply 'concat x))
		  (combinatorial trans-c trans-v))
	   hashtbls)))
      v trans-v))
   c trans-c))

(defvar garshuni-mlm-hash
  (indian-make-hash garshuni-mlm-base-table
		    garshuni-mlm-table))

(quail-define-indian-trans-package
 garshuni-mlm-hash "garshuni-malayalam" "Malayalam" "Ga-Mlm"
 "Garshuni Malayalam Test.")

(provide 'garshuni-mlm)
;;; garshuni-mlm.el ends here
