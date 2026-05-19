class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/super-whisper-rag"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/super-whisper-rag/releases/download/v0.1.0/swrag-darwin-arm64.tar.gz"
      sha256 "21875e6e6119c495e6bc95c706d6ce455be8aa8d2180e72966167225d467ee8c"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/super-whisper-rag/releases/download/v0.1.0/swrag-darwin-x64.tar.gz"
      sha256 "089468fea9ea858d3cf22849832fb296836544a84e7513ac62680be75c153e40"
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
