class Yolk < Formula
  desc "Templated dotfile management without template files"
  homepage "https://elkowar.github.io/yolk"
  version "0.3.1"
  if OS.mac?
    url "https://github.com/elkowar/yolk/releases/download/v0.3.1/yolk_dots-x86_64-apple-darwin.tar.xz"
    sha256 "baeed2c43f4ce60481276e21af4d191348d4a7604def45d5b4a506c7d5065b4d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/elkowar/yolk/releases/download/v0.3.1/yolk_dots-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e0ad8515e6a025ba68b642f7c415073331a3cf1aba525b97691dbe7e91007a18"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "yolk" if OS.mac? && Hardware::CPU.arm?
    bin.install "yolk" if OS.mac? && Hardware::CPU.intel?
    bin.install "yolk" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
