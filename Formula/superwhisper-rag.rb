class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.7.0/swrag-darwin-arm64.tar.gz"
      sha256 "e5d21827b1b688f3cc012177e50f1a9371617e13056cdced966be8e5353831a7"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.7.0/swrag-darwin-x64.tar.gz"
      sha256 "adeaafc19e96c153921448aca6c7b9b2c4859b7a1a66eb4717e1af12f8f8bd66"
    end
  end

  depends_on "sqlite"
  depends_on "ollama"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "swrag-darwin-#{arch}" => "swrag"
  end

  def caveats
    <<~EOS
      Run once to finish setup (starts ollama, pulls the embed model,
      warms macOS permissions, installs the meeting watcher, indexes,
      installs the agent skill, verifies):
        swrag bootstrap

      The archive is then auto-created on first use at
        ~/Library/Application Support/superwhisper-rag/swrag.sqlite

      Each bootstrap step is independently invokable too:
        swrag index                      # ingest from Super Whisper
        swrag meeting enable-watcher     # background meeting capture
                                         # (add --system-audio to also
                                         #  record other apps' output;
                                         #  see README for legal note)
        swrag meeting permissions-check --prompt
        swrag install-skill              # ~/.cursor/skills + ~/.claude/skills
                                         # (manual-invocation only; the agent
                                         #  cannot reach for it autonomously)
        swrag doctor
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/swrag --version"))
  end
end
