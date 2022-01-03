class Acton < Formula
  desc "Safe actor-based programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "99eb2180145f6235b3f5fa30862793610114b5bc781ac7740299b65eb356e004"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.7.1"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "b3ae40cf04940dafefc0d26794838c33acc8b1ba6e0e3590eb61fb830164b205"
    sha256 cellar: :any,                 catalina:     "6337dec913568b38985032b62206a122416b922549ab427e9cf4202cf2e0db04"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e434dc6f405a8587ba7c25d44211f6f4e1c448e4bbeb2e2994a2ce3ab23b6bcd"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  depends_on "protobuf-c"
  depends_on "utf8proc"
  depends_on "util-linux"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  on_linux do
    depends_on "libbsd" => :build
    depends_on "gcc"
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
    prefix.install Dir["dist/*"]
  end

  test do
    system "#{bin}/actonc", "--version"
    (testpath/"hello.act").write <<~EOS
      actor main(env):
          print("Hello World!")
          await async env.exit(0)
    EOS
    system "#{bin}/actonc", "--root", "main", "hello.act"
    assert_equal "Hello World!\n", shell_output("./hello")
  end
end
