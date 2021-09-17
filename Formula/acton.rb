class Acton < Formula
  desc "Awesome Programming Language"
  homepage "http://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "aeacfe6ca13d8a7d8f41fddc944e3ca421448c9ebe68b3d10772664430a9b0ef"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.5.3"
    rebuild 1
    sha256 cellar: :any, big_sur:  "5e5e08d9d2d2ab3369e54de45d7d74d9ad87954de5fe6d415f32efca16ed73a7"
    sha256 cellar: :any, catalina: "64aaeeff618cd7c19e6e03d441b58d5f2358f007f7bfb87a1a6f749729f4f6d6"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "utf8proc" => :build

  depends_on "protobuf-c"
  depends_on "util-linux"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    ENV.deparallelize
    system "make"
    bin.install "dist/bin/actonc"
    bin.install "dist/bin/actondb"
    prefix.install Dir["dist/*"]
  end

  test do
    # For Homebrew/homebrew-core this will need to be a test that verifies the
    # functionality of the software. Run the test with `brew test acton`.
    # Options passed to `brew install` such as `--HEAD` also need to be
    # provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end
