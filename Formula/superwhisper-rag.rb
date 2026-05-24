class SuperwhisperRag < Formula
  desc "Local SQL archive for your Super Whisper dictation history"
  homepage "https://github.com/NikitaHerndlhofer/superwhisper-rag"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.9.0/swrag-darwin-arm64.tar.gz"
      sha256 "db6f1498eafc855a5d2cd785d58c2db5149fb6921231cf3d1c9dbd3b88bd6502"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/superwhisper-rag/releases/download/v0.9.0/swrag-darwin-x64.tar.gz"
      sha256 "a47f780b0b8a5b4f532309c7e05e8d78323d90f7b1f67fa94568e421f72cdb11"
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
