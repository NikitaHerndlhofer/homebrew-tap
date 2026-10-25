class Memindex < Formula
  desc "Universal local search archive with plugins: Super Whisper, Cursor, Claude Code"
  homepage "https://github.com/NikitaHerndlhofer/memindex"
  version "0.1.5"
  license "MIT"

  depends_on "ollama"
  depends_on "supabase"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.1.5/memindex-darwin-arm64.tar.gz"
      sha256 "1eb2bc9f89ea99a3ee2a749bfd5c60abd1615a95532881e34ec9505a60a5429c"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.1.5/memindex-darwin-x64.tar.gz"
      sha256 "f5661785581aaaa2250a4fe2de29a9f1c83efe5f0835186001f53d8f59a95e30"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    bin.install "memindex-darwin-#{arch}" => "memindex"
  end

  def caveats
    <<~EOS
      memindex needs a Postgres database with pgvector >= 0.8, pg_trgm,
      unaccent and btree_gin: a Supabase project or any Postgres you run.
      For a local one, the repository ships a docker-compose.yml:
        docker compose up -d   # then use postgres://memindex:memindex@127.0.0.1:54329/memindex

      Finish setup (checks the database and migrates it, pulls bge-m3 into
      Ollama, installs the background watcher, agent hooks and skill):
        memindex install

      The watcher runs as a low-priority background process. Embedding runs
      in short slices and waits while the Mac is on battery.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memindex --version")
  end
end
