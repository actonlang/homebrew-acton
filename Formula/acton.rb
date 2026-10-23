class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://acton.now/"
  license "BSD-3-Clause"

  head do
    url "https://github.com/actonlang/acton.git", branch: "main"

    depends_on "ghc@9.8" => :build
    depends_on "haskell-stack" => :build
  end

  # Stable installs use the release tarballs produced by actonlang/acton CI, to
  # avoid rebuilding the Acton compiler itself (Haskell dep). The
  # update-homebrew job sets the placeholder values before pushing to
  # actonlang/homebrew-acton repo
  on_macos do
    on_arm do
      url "https://github.com/actonlang/acton/releases/download/v0.31.0/acton-macos-aarch64-0.31.0.tar.xz"
      sha256 "5d62bf29bb360e3bca4f964ffbefe653719002c1c8d648d54e06957766691f4c"
    end
    on_intel do
      url "https://github.com/actonlang/acton/releases/download/v0.31.0/acton-macos-x86_64-0.31.0.tar.xz"
      sha256 "5ff87561ec57cab1b6453765f226551433a364ac04428c394b6c20c840ebc32f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/actonlang/acton/releases/download/v0.31.0/acton-linux-aarch64-0.31.0.tar.xz"
      sha256 "506d0ba6febbe14832bdb9ba5551efd02f7e95cae1dcbc1901ec1b766f2edacd"
    end
    on_intel do
      url "https://github.com/actonlang/acton/releases/download/v0.31.0/acton-linux-x86_64-0.31.0.tar.xz"
      sha256 "988bd17f5cd766678cee4d56634daf23cdc5b97be195dac79836714515c61dcb"
    end
  end

  def install
    if build.head?
      # Fix up stack config to not install project local GHC and use system GHC
      # which is idiomatic for Homebrew. Disable GHC version check as we want to
      # allow for minor version mismatches.
      inreplace "compiler/stack.yaml", "# system-ghc: true", <<~EOS
        system-ghc: true
        install-ghc: false
        allow-newer: true
        skip-ghc-check: true
      EOS

      ENV["BUILD_RELEASE"] = "1"
      system "make"
      # make puts the same layout in dist/ as the release tarball has at its root
      cd "dist"
    end

    bin.install "bin/acton"
    bin.install_symlink "acton" => "actonc"
    bin.install "bin/actondb"
    bin.install "bin/runacton"
    bin.install "bin/lsp-server-acton"
    prefix.install Dir["*"] - ["bin"]
    [:bash, :zsh, :fish].each do |shell|
      generate_completions_from_executable(bin/"acton", "--#{shell}-completion-script", opt_bin/"acton",
                                           shells: [shell], shell_parameter_format: :none)
    end
  end

  test do
    # On macOS, brew test puts the SDK include directory in CPATH. clang, which
    # zig runs, then finds the SDK C headers before the libc++ headers, and the
    # C++ files of snappy-c do not compile.
    ENV.delete "CPATH"

    testapp = (testpath/"hello.act")
    testapp.write <<~EOS
      #!/usr/bin/env runacton
      actor main(env):
          print("Hello World!")
          env.exit(0)
    EOS
    testapp.chmod 0755
    assert_equal "Hello World!\n", shell_output(testapp)
  end
end
