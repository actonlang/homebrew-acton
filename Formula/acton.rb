class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "30dd314a5af519ac83bd5db17793aaf9416d95a8f10e98a30bdec9840d9be04c"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

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
    system "#{bin}/actonc", "--version"
    (testpath/"hello.act").write <<~EOS
      #!/usr/bin/env runacton
      actor main(env):
          print("Hello World!")
          await async env.exit(0)
    EOS
    assert_equal "Hello World!\n", shell_output("./hello")
  end
end
