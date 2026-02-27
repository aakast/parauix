;;; ═══════════════════════════════════════════════════════════════════════════════
;;;  Display Manager Package Definitions
;;;  TUI/GUI login managers not in official Guix
;;; ═══════════════════════════════════════════════════════════════════════════════

(define-module (packages display-managers)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages zig)
  #:use-module (guix gexp))

;;; ═══════════════════════════════════════════════════════════════════════════════
;;; LY — TUI DISPLAY MANAGER
;;; ═══════════════════════════════════════════════════════════════════════════════

(define ly-vendor-source
  (origin
    (method url-fetch)
    (uri "https://codeberg.org/fairyglade/ly/releases/download/v1.3.2/vendor.tar.zst")
    (sha256
     (base32 "1swhd3z19kzhjn5vr5wz3j14r0gm8fb201y7ixs12ra2zwmr5v2b"))))

(define-public ly
  (package
    (name "ly")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri "https://codeberg.org/fairyglade/ly/archive/v1.3.2.tar.gz")
       (sha256
        (base32 "1rjplwqx9mf30xmvrc75p7wy9bj7hpn10ajmj0l4pimcvk19q1nv"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'unpack-vendor
            (lambda _
              (invoke "tar" "--zstd" "-xf" #$ly-vendor-source)
              (setenv "ZIG_GLOBAL_CACHE_DIR" (string-append (getcwd) "/vendor"))))
          (replace 'build
            (lambda _
              (invoke "zig" "build"
                      "-Doptimize=ReleaseSafe"
                      "-Denable_x11_support=true")))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (invoke "zig" "build" "install"
                        "-Doptimize=ReleaseSafe"
                        "-Denable_x11_support=true"
                        (string-append "--prefix=" out))))))))
    (native-inputs
     (list git pkg-config zig-0.15 zstd))
    (inputs (list libxcb linux-pam))
    (home-page "https://codeberg.org/fairyglade/ly")
    (synopsis "TUI display manager")
    (description "Ly is a lightweight TUI display manager for Linux and BSD.
It supports X11 and Wayland sessions, configurable UI theming, and runs on a
virtual terminal with minimal resource usage.")
    (license license:wtfpl2)))
