# Second Brain — Developer Guide

> Detailed instructions for developers who want to manually install or contribute.

---

## Manual Install

### Clone the Repo

```bash
git clone https://github.com/zhiwehu/second-brain.git
cd second-brain
```

### Run Setup Script

```bash
./setup.sh
./setup.sh --fix  # auto-fix directory structure issues
```

The setup script will:
- Check for required tools
- Create `wiki/` and `raw/` directory structure
- Set executable permissions on tools
- Inject Second Brain reference into OpenClaw global MEMORY.md
- Initialize Git repo (optional)

### Launch Second Brain

**In Claude Code:**

```bash
cd second-brain
claude
# Claude Code automatically reads CLAUDE.md
```

**In OpenClaw:**

```bash
cd second-brain
openclaw
# OpenClaw automatically reads CLAUDE.md
```

**Manual Copy & Paste:**

1. Open `MEMORY.md` and copy all content
2. Paste to AI: "Please use this MEMORY.md as reference to process my content"

---

## Directory Structure

```
second-brain/
├── CLAUDE.md              # AI config (Claude Code/OpenClaw specific)
├── MEMORY.md              # Layer 1: Entry router (universal)
├── reference.md           # Layer 2: LLM Wiki + PARA rules
│
├── wiki/                  # Knowledge base (user data, not pushed to Git)
│   ├── index.md         # Content index (updated by AI on each ingest)
│   ├── log.md          # Operation log (append-only)
│   ├── projects/       # PARA: Projects (goals + deadlines)
│   ├── areas/          # PARA: Areas (ongoing responsibilities)
│   ├── resources/      # PARA: Resources (interested, no action yet)
│   └── archives/        # PARA: Archives (completed/abandoned)
│
├── raw/                   # Raw materials (user data, not pushed to Git)
│   ├── articles/       # Web articles
│   ├── tweets/          # Tweets
│   ├── voice/           # Voice memos
│   ├── images/          # Images
│   └── files/           # Documents
│
├── process/              # Layer 3: Content type processors
│   ├── article.md       # Web articles
│   ├── tweet.md         # Tweets/short content
│   ├── voice.md         # Voice
│   ├── image.md         # Images
│   ├── file.md          # Files
│   ├── chat.md          # Chat logs
│   └── task.md          # Schedules/TODOs
│
├── tools/               # CLI utilities
│   ├── doctor.sh        # Health check + auto-fix
│   ├── backup.sh        # raw/ backup
│   ├── voice_to_text.sh # Speech-to-text (SenseVoice/Whisper)
│   ├── extract_exif.sh  # Image EXIF extraction
│   ├── extract_file_meta.sh # File metadata
│   ├── fetch_url.sh    # Web page fetch
│   ├── fetch_content.sh # Smart content fetch
│   └── extract_pdf_text.sh # PDF text extraction
│
└── .claude/
    └── commands/         # OpenClaw command reference
```

---

## 3-Layer Memory Architecture

```
Layer 1: MEMORY.md (entry router)
    ↓ detect type
Layer 2: reference.md (PARA rules + Wiki format)
    ↓ dispatch by type
Layer 3: process/*.md (specific processors)
    ↓ write
wiki/{para}/ (knowledge base)
```

See `reference.md` for details.

---

## PARA Method

| Type | Definition | Examples |
|------|------------|----------|
| **Projects** | Goals + deadlines | Product launch, learning plan |
| **Areas** | Ongoing responsibilities, no deadline | Health, finances, career |
| **Resources** | Interested, no action yet | Research topics, articles to read |
| **Archives** | Completed/abandoned/dormant | Old projects, historical data |

---

## Upgrade

```bash
./upgrade.sh
```

upgrade.sh will:
1. Stash any uncommitted changes
2. `git fetch + pull --rebase` to get latest code
3. Pop stash
4. Re-inject OpenClaw MEMORY.md

**Important:** `wiki/` and `raw/` are in .gitignore — user data is never overwritten.

---

## Tool Details

### Speech to Text

```bash
./tools/voice_to_text.sh recording.m4a transcript.txt
```

Supports: SenseVoice (Ollama), Whisper

### Backup

```bash
./tools/backup.sh                      # Backup to ~/second-brain-backups
./tools/backup.sh /path/to/backups     # Backup to specified location

# Cron backup (every Sunday 2am)
(crontab -l 2>/dev/null; echo "0 2 * * 0 cd $PWD && ./tools/backup.sh") | crontab -
```

### Health Check

```bash
./tools/doctor.sh        # Check
./tools/doctor.sh --fix  # Auto-fix
```

---

## Content Ingest Flow

When user says "save to second brain":

1. **Detect type** → tweet/article/image/etc
2. **Fetch content** → URL / attachment / audio transcription
3. **Generate summary** → LLM generates 50-char summary + key points
4. **PARA classification** → Projects/Areas/Resources/Archives
5. **Write to wiki** → `wiki/{para}/YYYY-MM-DD-slug.md`
6. **Cross-link** → Search existing wiki content, add links
7. **Update index** → Add entry to `wiki/index.md`
8. **Log** → Prepend entry to `wiki/log.md`

---

## Theoretical References

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

---

## License

MIT
