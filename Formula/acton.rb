class Acton < Formula
  desc "Awesome Programming Language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "e58487e8c5b17a669080714a2b9940e02f2e26c86e7a549b0fdcbde92ea866ae"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.7.0"
    sha256 cellar: :any,                 big_sur:      "b4ef935d2dd3b2d43b2b0f8ed3e13de307fe41f30ea30287ea2c285b3e725f85"
    sha256 cellar: :any,                 catalina:     "e009ed87f2c7d6f3189bea41b7d8c118afd7167844b1e83343e78567971fd273"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d1cc1e2ec897c0e46a73b381a129354c7f4278f92c98321e809bc4bf439b3724"
  end

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
