class Acrag < Formula
  desc "Local SQL archive for your agentic coding chat history (Cursor first)"
  homepage "https://github.com/NikitaHerndlhofer/acrag"
  version "0.2.0"
  license "MIT"

  depends_on "ollama"
  depends_on "sqlite"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.2.0/acrag-darwin-arm64.tar.gz"
      sha256 "220dfc6d854f92a8726a8222b6ed0e03b1fe7d82165b3cb44fb3d624c25fb721"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/acrag/releases/download/v0.2.0/acrag-darwin-x64.tar.gz"
      sha256 "365ccadaaae7f2f245d371340250245b97689fe5bf1c82ee0587aa47e1cf4c17"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "acrag-darwin-#{arch}" => "acrag"
  end

  def caveats
    <<~EOS
      Finish setup (interactive wizard — pulls the model, migrates, prompts to
      install Cursor hooks + skill, and runs an initial sweep):
        acrag bootstrap

      The archive is auto-created at
        ~/.acrag/acrag.sqlite

      `acrag bootstrap` pulls bge-m3 (~2 GB, one-time) automatically when
      missing, and prompts (Y/n) to install:
        - Cursor hooks  -> ~/.cursor/hooks/hooks.json
          (fires `acrag` on Stop / SubagentStop / SubagentStart /
          WorkspaceOpen; detached background ingest so the agent never blocks)
        - the agent skill -> ~/.cursor/skills/acrag/SKILL.md
          (manual-invocation only — type @acrag in Cursor; the agent cannot
          reach for it autonomously)
      Each step is idempotent and skipped when already done; re-run any time.

      Each step is independently invokable too:
        acrag index             # sweep ~/.acrag/transcripts for *.jsonl
        acrag install-hooks     # (re)write ~/.cursor/hooks/hooks.json
        acrag install-skill     # (re)write the SKILL.md
        acrag sql               # pipe SQL (vec preloaded, archive read-only)
        acrag embed             # pipe text -> vec blob literal for vec_search
    EOS
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}/acrag --version"))
  end
end
