class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "91e562b53f3ca0b42e11aeb70373d5084093caa4086744334a405ccf065dffa7"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.20.1"
    sha256 cellar: :any_skip_relocation, monterey: "44e0b8339749a72a3a9608046a8e0044d924b49a96f0e771218927d5b21d66c8"
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
