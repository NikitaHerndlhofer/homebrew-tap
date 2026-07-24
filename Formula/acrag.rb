class Acrag < Formula
  desc "Local SQL archive for your agentic coding chat history (Cursor first)"
  homepage "https://github.com/NikitaHerndlhofer/acrag"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.1.0/acrag-darwin-arm64.tar.gz"
      sha256 "6f9c11c30e454477e492a61c635df277f364c50d5b1387a978770af3de2eb7ca"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.1.0/acrag-darwin-x64.tar.gz"
      sha256 "944a88b4b8f33a5ad7710effb01ad861c41b66fe3c3cde415a2831b1a02d654c"
    end
  end

  depends_on "sqlite"
  depends_on "ollama"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "acrag-darwin-#{arch}" => "acrag"
  end

  def caveats
    <<~EOS
      Finish setup:
        ollama pull bge-m3      # ~2 GB, one-time — the embed model
        acrag bootstrap         # check Ollama, create the archive DB, print status
        acrag install-hooks     # wire Cursor hooks -> detached background ingest
        acrag install-skill     # install the retrieval recipes for Cursor's agent

      The archive is auto-created on first use at
        ~/.acrag/acrag.sqlite

      Cursor hooks fire `acrag` on Stop / SubagentStop / SubagentStart /
      WorkspaceOpen and spawn a detached background ingest/sweep so the agent
      never blocks on embedding. `acrag install-hooks` writes
      ~/.cursor/hooks/hooks.json; `acrag install-skill` writes the recipe
      SKILL.md to ~/.cursor/skills/acrag/ (manual-invocation only — type
      @acrag in Cursor; the agent cannot reach for it autonomously).

      Each step is independently invokable too:
        acrag index             # sweep ~/.acrag/transcripts for *.jsonl
        acrag sql               # pipe SQL (vec preloaded, archive read-only)
        acrag embed             # pipe text -> vec blob literal for vec_search
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/acrag --version"))
  end
end
