class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://acton.now/"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "4f0cdc597f20743a5f9a9fe566a0794c8572c00d357f4e02022848aa68589328"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.30.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "812fdb7636583906d553c9fbe014a3a8d1fb22f4ce0a6bc30ddc540fab06d19c"
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
