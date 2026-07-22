class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://acton.now/"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "2dfd750f43ceab39678d26a86789ea6c7e2a85e80bedb400279c89b9417faf5c"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.29.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f36596dff8595a781ef97dba0cb7717034727d5892cbb26b5a3a901affadecb4"
  end

  depends_on "ghc@9.8" => :build
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
    bin.install_symlink "acton" => "actonc"
    bin.install "dist/bin/actondb"
    bin.install "dist/bin/runacton"
    bin.install "dist/bin/lsp-server-acton"
    prefix.install Dir["dist/*"] - ["dist/bin"]
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
