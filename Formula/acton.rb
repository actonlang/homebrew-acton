class Acton < Formula
  desc "Awesome Programming Language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "846c0afac447626a6507f2492b82e07caefaf5a1c627fec8e49d280b9fd10df3"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.6.4"
    rebuild 2
    sha256 cellar: :any,                 big_sur:      "dcd2e11af67353a7684e49cf242b5ec8a14b08d5e4ff1cf1274e7b15ab8fc8c7"
    sha256 cellar: :any,                 catalina:     "75e8ef2ad89a4d77157ffd3893a6bd21d2427f8427277fff9d2776c10fad94ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "27b8c348cae783b8ad5bbb31d379ad6eea3d2e377e7c50db23a68afba2f5f8b3"
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
    depends_on "gcc"
    depends_on "gmp"
    depends_on "libbsd" => :build
  end

  def install
    ENV["BUILD_RELEASE"] = "1"
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
