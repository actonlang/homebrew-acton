class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "4eeff777332d569e22e02499fb2af7f0901821c30b042eeff7e2b15568255867"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.14.1"
    sha256 cellar: :any_skip_relocation, monterey:     "7b81ab4aa8f419b309d0d1ddbec99f68754ee571abbe4573ac94418bd41f467f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe799b9222b0c9a1192b2a3e36cbf01bf90e82671a0aaaf8092a70f78f750f7d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "ghc@8.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf-c" => :build

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
