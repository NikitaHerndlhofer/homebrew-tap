class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.4.1/swrag-darwin-arm64.tar.gz"
      sha256 "d71579ba5b3ded0fc66bcb70bbdbb9f3cd2b779a11eacf633ca2de02dbdd1671"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.4.1/swrag-darwin-x64.tar.gz"
      sha256 "3bcd7c104512e2508c723e64d84b61115b480dcc32b28d8d0f03fecfeb9d6d81"
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
    assert_match(version.to_s, shell_output("#{bin}/swrag --version"))
  end
end
