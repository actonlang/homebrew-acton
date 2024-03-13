class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "bfcdd0cabe3a2d4964dd6c02f8eb1199c55955bcc46174711cfdbf38e2f8c87b"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.21.0"
    sha256 x86_64_linux: "7d41d3d4a28f56670603f347a3f6d2a5df7c1ef3ad1cd2c5cf97837ea3d7de6b"
  end

  depends_on "ghc@9.4" => :build
  depends_on "haskell-stack" => :build

  def install
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
    bin.install "dist/bin/acton"
    bin.install "dist/bin/actonc"
    bin.install "dist/bin/actondb"
    bin.install "dist/bin/runacton"
    prefix.install Dir["dist/*"]
    bash_completion.install "completion/acton.bash-completion"
  end

  test do
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
