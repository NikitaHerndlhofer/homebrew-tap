class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.1.0/swrag-darwin-arm64.tar.gz"
      sha256 "02f89287f40306a8a9085b16c48d0a8d9ba15d2b834d5f45ae90c505c4fbf0ef"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.1.0/swrag-darwin-x64.tar.gz"
      sha256 "1206c8f06e3729fe95fa4c377fc19efe6663395dc3f8785d0ba51cbadf312aa9"
    end
  end

  depends_on "sqlite"
  depends_on "ollama" => :recommended

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "swrag-darwin-#{arch}" => "swrag"
  end

  def caveats
    <<~EOS
      The archive is auto-created on first use at
        ~/Library/Application Support/superwhisper-rag/swrag.sqlite

      To use semantic search:
        ollama pull bge-m3

      Optional, entirely opt-in:
        swrag enable-sync                # hourly background sync
        swrag install-skill              # ~/.cursor/skills + ~/.claude/skills
                                         # (manual-invocation only; the agent
                                         #  cannot reach for it autonomously)
    EOS
  end

  test do
    assert_match(/0\.1\.0/, shell_output("#{bin}/swrag --version"))
  end
end
