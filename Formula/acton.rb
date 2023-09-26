class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "02e9968b1b36cae4d8dce938f39cecb60866b8d89812336852eab566848f3ee1"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.17.0"
    sha256 cellar: :any_skip_relocation, ventura:      "ce13466d971d55155e0acbeef422d3a8191b0d59758d795d430a8a3c0c0e7e46"
    sha256 cellar: :any_skip_relocation, monterey:     "c4b93dcb2f1d6a39323e862b187e023fa74dd036f894509cdaea66bfb66d2af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f40aa9dadb77b1d63832418087da5bf35784494a878dc2dfbb1cf7a62f330df"
  end

  # TODO: can gettext be removed? it was likely necessary when we built deps
  # using autoconf, but might not be needed now that we use build.zig?
  depends_on "gettext" => :build
  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build

  on_linux do
    depends_on "gmp"
  end

  def install
    # Fix up stack config to not install project local GHC
    inreplace "compiler/stack.yaml", "# system-ghc: true", <<~EOS
      system-ghc: true
      install-ghc: false
      allow-newer: true
    EOS

    ENV["BUILD_RELEASE"] = "1"
    system "make"
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
          await async env.exit(0)
    EOS
    testapp.chmod 0755
    assert_equal "Hello World!\n", shell_output(testapp)
  end
end
