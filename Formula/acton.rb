class Acton < Formula
  desc "Safe actor-based programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "e58487e8c5b17a669080714a2b9940e02f2e26c86e7a549b0fdcbde92ea866ae"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.7.1"
    sha256 cellar: :any,                 big_sur:      "784e0f86058d82d9aaba09a7d8b6b1b32703f2b23702a6b3496af5f61c8f98f2"
    sha256 cellar: :any,                 catalina:     "80163b514ef237119209b75848e718ae0699a580709172f7f68331a073d26298"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8182bd70952c8a817ec2749f2eaf3ceb12cfadaae7a2668fb78439ccffe85960"
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
