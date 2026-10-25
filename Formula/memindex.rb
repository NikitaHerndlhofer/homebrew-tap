class Memindex < Formula
  desc "Universal local search archive with plugins: Super Whisper, Cursor, Claude Code"
  homepage "https://github.com/NikitaHerndlhofer/memindex"
  version "0.1.1"
  license "MIT"

  depends_on "ollama"
  depends_on "supabase"

  on_macos do
    on_arm do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.1.1/memindex-darwin-arm64.tar.gz"
      sha256 "d4c4fe6a6f87e33469c638a87cb6883cb8b1a9e1d0eae5b7ebb702b43793288f"
    end
    on_intel do
      url "https://github.com/NikitaHerndlhofer/memindex/releases/download/v0.1.1/memindex-darwin-x64.tar.gz"
      sha256 "5bd680432fe1dec4bcedb93cae9291fe3533770336b6d514efcd520e0e0443ee"
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
