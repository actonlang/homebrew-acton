class Acton < Formula
  desc "Delightful distributed programming language"
  homepage "https://www.acton-lang.org"
  url "https://github.com/actonlang/acton/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "9c075ef3c3ca50a14e39f8279d45716af57ca044b003b657ed7e1ef040e65905"
  license "BSD-3-Clause"
  head "https://github.com/actonlang/acton.git", branch: "main"

  bottle do
    root_url "https://github.com/actonlang/homebrew-acton/releases/download/acton-0.18.1"
    sha256 cellar: :any_skip_relocation, ventura:      "ff1b8c9b713ef60f9190576cd971480cd52f0ae4cda652554cb9266e1af65d6e"
    sha256 cellar: :any_skip_relocation, monterey:     "efbcac7c3b4b05c4e11f85b9959785ccb824e31b4cf02a4e82f16379b3ec1e02"
    sha256                               x86_64_linux: "c5576b2cb6c86ce54d2d0c895c9cccd34bbf7ac31e13a35a4d97f04e7d3fd59d"
  end

  depends_on "ghc@9.4" => :build
  depends_on "haskell-stack" => :build

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
          env.exit(0)
    EOS
    testapp.chmod 0755
    assert_equal "Hello World!\n", shell_output(testapp)
  end
end
