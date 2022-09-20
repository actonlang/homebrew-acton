class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "028cd83698d136377c27a73e116e52c35c486943efca733fc7e92e85ec199c57"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.11.6"
    sha256 cellar: :any_skip_relocation, monterey:     "40544b1254ade3ff2e1bbba0c5f1e742a18c2a4e1a06f0391753fde2e782b3af"
    sha256 cellar: :any_skip_relocation, big_sur:      "740faaedb4cc683c9849c9ae1ec011c60a60c058d07742c07f9a09a5700f5192"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20f26d9178916670d9929401f96f0bc978abd89bc5177056334e3ab2f8eb9709"
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
