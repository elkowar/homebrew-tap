class Yolk < Formula
  desc "Templated dotfile management without template files"
  homepage "https://elkowar.github.io/yolk"
  version "0.3.2"
  if OS.mac?
    url "https://github.com/elkowar/yolk/releases/download/v0.3.2/yolk_dots-x86_64-apple-darwin.tar.xz"
    sha256 "c3f9d0765e4687603a7c15d9cd1f5894f982aadec1d5e35e174a73b88cc8ee0b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/elkowar/yolk/releases/download/v0.3.2/yolk_dots-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b011578d25c18ccbd2181c87f30c9c87139df5b934ff674ed175e355d9192034"
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
