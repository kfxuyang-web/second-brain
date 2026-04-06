# Second Brain — Personal Knowledge Base Powered by LLM Wiki + PARA

> Build your second brain with OpenClaw or Claude Code. Let AI automatically maintain your knowledge base.

## Core Concept

This project integrates two powerful theories:

1. **Karpathy's LLM Wiki** — AI incrementally builds and maintains your knowledge base. Instead of retrieving everything every time, knowledge accumulates continuously.
2. **PARA Method** (Tiago Forte) — Organize all information into four categories: Projects, Areas, Resources, Archives.

## Features

- **3-Layer Memory Architecture** — Token-efficient; no need to send all content to LLM every time
- **Automatic Classification** — All content is automatically classified using PARA
- **Local Storage** — All data stays local, never uploaded to the cloud
- **AI-Assisted** — Paste content to AI, it references documents and processes automatically

---

## Quick Start

### Prerequisites

- [OpenClaw](https://github.com/opencodeai/openclaw) or [Claude Code](https://claude.ai/code)
- Optional: Ollama/Whisper (speech recognition)
- Optional: exiftool (image metadata)
- Optional: yt-dlp (YouTube/Bilibili subtitle download)
- Optional: [Agent-Reach](https://github.com/Panniantong/Agent-Reach) (Twitter/WeChat Official Account/Xiaohongshu)
- Optional: Obsidian (visual wiki browsing)

### Installation

```bash
git clone https://github.com/YOUR_USERNAME/second-brain.git
cd second-brain
./setup.sh
```

### Launch Second Brain

**Method 1: In Claude Code (Recommended)**

```bash
cd second-brain
claude
# Claude Code will automatically read CLAUDE.md
```

**Method 2: In OpenClaw**

```bash
cd second-brain
openclaw
# OpenClaw will automatically read CLAUDE.md
```

**Method 3: Copy & Paste**

1. Open `MEMORY.md` and copy all content
2. Paste to AI: "Please use this MEMORY.md as reference to process my content"

### Test

After launching, say:

```
Please ingest this URL into my second brain: https://example.com/article
```

AI will read MEMORY.md, process it according to the workflow, and write to wiki.

---

## Usage

Paste content to OpenClaw/Claude Code, AI will automatically process it referencing MEMORY.md:

```
# Ingest a web article
"Please ingest https://example.com/article into my second brain"

# Save an idea
"Please record this thought in second brain: I want to research AI Agent design patterns"

# Save an image
"Please save this image to second brain" [attach image]

# Set a schedule
"I have a product review meeting next Wednesday at 2pm, please record it in second brain"

# Search knowledge base
"Search second brain for AI Agent related content"

# Health check
"Please run ./tools/doctor.sh to check second brain status"
```

---

## Directory Structure

```
second-brain/
├── CLAUDE.md              # AI configuration (tells AI what this project is)
├── MEMORY.md              # Layer 1: Entry router
├── reference.md           # Layer 2: LLM Wiki + PARA rules
├── README.md              # This file
│
├── wiki/                  # Your knowledge base
│   ├── index.md         # Content index
│   ├── log.md           # Operation log
│   ├── projects/        # PARA: Projects
│   ├── areas/           # PARA: Areas
│   ├── resources/       # PARA: Resources
│   └── archives/        # PARA: Archives
│
├── raw/                  # Raw materials (not tracked by git)
│   ├── articles/
│   ├── tweets/
│   ├── voice/
│   ├── images/
│   └── files/
│
├── process/              # Layer 3: Type-specific processors
│   ├── article.md
│   ├── tweet.md
│   ├── voice.md
│   ├── image.md
│   ├── file.md
│   ├── chat.md
│   └── task.md          # Schedule/TODO
│
├── tools/                # CLI utilities
│   ├── doctor.sh        # Health check + self-healing
│   ├── backup.sh        # Backup raw/
│   ├── voice_to_text.sh # Speech to text
│   ├── extract_exif.sh  # Extract image EXIF
│   ├── extract_file_meta.sh # Extract file metadata
│   ├── fetch_url.sh    # Fetch web pages
│   └── extract_pdf_text.sh # Extract PDF text
│
└── .claude/
    └── commands/         # Command reference docs
```

---

## Content Types (7 Types)

| Type | Processor | Key Metadata |
|------|-----------|--------------|
| article | `process/article.md` | source URL |
| tweet/text | `process/tweet.md` | — |
| voice | `process/voice.md` | `duration`, `transcript` |
| image | `process/image.md` | `taken_at`, `location`, `camera` |
| file | `process/file.md` | `created_at`, `size`, `pages` |
| chat | `process/chat.md` | `participants`, `platform` |
| task | `process/task.md` | `due`, `deadline`, `status` |

---

## PARA Classification

| Type | Definition | Examples |
|------|------------|----------|
| **Projects** | Goals + deadlines | Product launch, learning plan |
| **Areas** | Ongoing responsibilities, no deadline | Health, finances, career development |
| **Resources** | Interested, no action yet | Research topics, articles to read |
| **Archives** | Completed/abandoned/dormant | Old projects, historical data |

---

## Tool Usage

### Install Agent-Reach (Twitter/WeChat/Xiaohongshu support)

```bash
# Tell Claude Code/OpenClaw:
# "Please install Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md"

# Verify after installation:
agent-reach doctor
```

### Health Check (Run Regularly)

```bash
# Check
./tools/doctor.sh

# Auto-fix issues
./tools/doctor.sh --fix
```

### Speech to Text

```bash
./tools/voice_to_text.sh recording.m4a transcript.txt
```

### Extract Image EXIF

```bash
./tools/extract_exif.sh photo.jpg
```

### Backup raw/ Directory

```bash
./tools/backup.sh                      # Backup to ~/second-brain-backups
./tools/backup.sh /path/to/backups     # Backup to specified location
```

---

## raw/ File Backup

The raw/ directory contains original materials (images, audio, files, etc.) and is ignored by .gitignore by default. It will not be pushed to Git.

**Backup Options:**

1. **Local Backup**: Run `./tools/backup.sh` regularly
2. **Cloud Backup**: Configure rclone to backup to cloud storage (Google Drive, S3, etc.)
3. **Git LFS**: Change raw/ to use Git LFS tracking (suitable for small number of files)

**Recommended Workflow:**
```bash
# 1. Regular backup
./tools/backup.sh

# 2. Set up cron job (auto backup every Sunday at 2am)
(crontab -l 2>/dev/null; echo "0 2 * * 0 cd $PWD && ./tools/backup.sh") | crontab -
```

---

## Integration with Obsidian

Obsidian is the best tool for browsing your wiki:

1. Open `second-brain/` directory with Obsidian
2. Enjoy the graph view
3. Install recommended plugins:
   - **Dataview** — Query wiki data (filter by date/tag/PARA)
   - **Templater** — Automated templates

### Obsidian Dataview Query Examples

```dataview
-- Photos from last week
TABLE taken_at, location, para
FROM "wiki"
WHERE type = "image" AND taken_at >= 2026-03-25
SORT taken_at DESC

-- All pending tasks
TABLE due, deadline, status, para
FROM "wiki"
WHERE type = "task" AND status != "completed"
SORT due ASC
```

---

## FAQ

**Q: How does AI know to read these files?**
A: Claude Code automatically reads CLAUDE.md in the project directory. OpenClaw needs the working directory set to second-brain.

**Q: Can it process content automatically?**
A: Currently it's "Reference Document Mode" — paste content to AI, AI references MEMORY.md and processes automatically. True automation requires MCP server or file watcher configuration.

**Q: Will raw/ files be tracked by git?**
A: No by default (.gitignore is configured). Run `./tools/backup.sh` for separate backups.

**Q: Does it support English?**
A: Yes. All documentation is bilingual. PARA classification, image EXIF, and speech recognition (SenseVoice/Whisper) all support English.

---

## Theoretical References

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

## License

MIT

---

*Build knowledge with AI, let knowledge produce wisdom.*
