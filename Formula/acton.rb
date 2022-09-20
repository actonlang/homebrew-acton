class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "a7f4bb269143fdb5480eb04ddb9d55e86a6a33b8eea5c24dcbd7fdd3a1f3dbdc"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.11.5"
    sha256 cellar: :any_skip_relocation, monterey:     "597d7c07056367078554ad00cbe00408406b6b5d63447aedd05788de7ab1ba0b"
    sha256 cellar: :any_skip_relocation, big_sur:      "ad6f8a23104889ece00f52c1c7ec2016d7326a9d84cf095510ce1840613dd47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "960889be7f6ca4cbe3e00a34fee37ea3d67069622c3f5fa9d5be8fb0fee3c0be"
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
