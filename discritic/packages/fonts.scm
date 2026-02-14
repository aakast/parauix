;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  Font Package Definitions
;;;  Fonts not in official Guix
;;;
;;;  NOTE: Most proprietary fonts cannot be packaged due to licensing.
;;;  This module contains documentation and any free fonts we can package.
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (packages fonts)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses) #:prefix license:))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; PROPRIETARY FONTS - Cannot be packaged (licensing)
;;; Install manually from purchased licenses
;;; ═══════════════════════════════════════════════════════════════════════════════
;;;
;;; PragmataPro     - https://fsd.it/shop/fonts/pragmatapro/
;;; MonoLisa        - https://www.monolisa.dev/
;;; Berkeley Mono   - https://berkeleygraphics.com/typefaces/berkeley-mono/
;;; Minerva         - Manual installation
;;;
;;; Installation location: ~/.local/share/fonts/
;;; After installing: fc-cache -fv
;;;
;;; ═══════════════════════════════════════════════════════════════════════════════

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; FREE FONTS AVAILABLE IN OFFICIAL GUIX
;;; ═══════════════════════════════════════════════════════════════════════════════
;;;
;;; These are in the main manifest - listed here for reference:
;;;   - font-iosevka         ; Iosevka
;;;   - font-iosevka-term    ; Iosevka Term
;;;   - font-juliamono       ; JuliaMono
;;;   - font-inter           ; Inter
;;;   - font-space-grotesk   ; Space Grotesk
;;;   - font-commit-mono     ; Commit Mono
;;;   - font-liberation      ; Liberation fonts
;;;
;;; ═══════════════════════════════════════════════════════════════════════════════
