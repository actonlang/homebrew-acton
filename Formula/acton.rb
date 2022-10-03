class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "980db27886eb441b885e884a757fb9d1e772a227c1490bf95fe0625951075520"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.11.7"
    sha256 cellar: :any_skip_relocation, monterey:     "825770e5216d8364a2a36b67a8a4aebfc001715e7a0a2a37f2633287879cd77a"
    sha256 cellar: :any_skip_relocation, big_sur:      "150a38b290f2f842b92f6ca8f202a65cc1a4d775115d6dded757a62dbd94ba79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a960c698d3c5a165329d95f5312426314fe7bc421248d53673d69b1d030dcfc5"
  end

  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "libuv" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf-c" => :build
  depends_on "utf8proc" => :build

  on_macos do
    depends_on "argp-standalone" => :build
  end

  on_linux do
    depends_on "libbsd" => :build
    depends_on "gcc"
    depends_on "gmp"
    depends_on "util-linux"
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
