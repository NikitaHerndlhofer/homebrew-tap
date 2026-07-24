# NikitaHerndlhofer/homebrew-tap

Homebrew tap for my tools.

## Available formulae

| Formula            | What it is                                                                                                                           | Source                                                   |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| `superwhisper-rag` | Local SQL archive for your Super Whisper dictation history. Thin sqlite3 wrapper + multilingual semantic search via bge-m3 / Ollama. | <https://github.com/NikitaHerndlhofer/superwhisper-rag> |
| `acrag` | Local SQL archive for your agentic coding chat history (Cursor first). Thin sqlite3 wrapper + full-text/fuzzy/semantic search via bge-m3 / Ollama. | <https://github.com/NikitaHerndlhofer/acrag> |

## Install

```bash
brew install NikitaHerndlhofer/tap/superwhisper-rag
brew install NikitaHerndlhofer/tap/acrag
```

(Or `brew tap NikitaHerndlhofer/tap` once, then `brew install superwhisper-rag` / `brew install acrag`.)

## License

The tap itself (this repo) is MIT. Each formula's source project has its own license — see the source repo linked above.
