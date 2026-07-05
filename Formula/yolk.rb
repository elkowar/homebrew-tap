class Yolk < Formula
  desc "Templated dotfile management without template files"
  homepage "https://elkowar.github.io/yolk"
  version "0.3.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/elkowar/yolk/releases/download/v0.3.9/yolk_dots-aarch64-apple-darwin.tar.xz"
      sha256 "10c53d08d2cc7a35d9d8dcd219234c029334fed22b7013bcf9592b6609a1c4b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/elkowar/yolk/releases/download/v0.3.9/yolk_dots-x86_64-apple-darwin.tar.xz"
      sha256 "822b958dc7a787c59a1b5f08259fa443b3b8a435ab2a22f786b6eae65b5ffe0e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/elkowar/yolk/releases/download/v0.3.9/yolk_dots-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "acafb108f8064955ebf81838660d6642c03a1279667708ec1f799de4d6958203"
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
    generate_completions_from_executable(bin/"yolk", shell_parameter_format: :clap)

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
