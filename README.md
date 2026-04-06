# Second Brain

> Your personal knowledge base, maintained by AI.
> Just say what you want to save — AI handles the rest.

[**🇨🇳 中文说明**](README_ZH.md) · [**Twitter:** @zhiwehu](https://twitter.com/zhiwehu)

---

## One-Command Install

**In OpenClaw or Claude Code, just say:**

```
Please install Second Brain from https://github.com/zhiwehu/second-brain
```

AI will automatically: clone → setup → inject → done.

---

## Features at a Glance

| What to Say | What Happens |
|-------------|-------------|
| `Save this to my second brain: [content]` | Stores and classifies the content |
| `Save this link: [URL]` | Fetches, summarizes, saves |
| `Search my second brain for [topic]` | Semantic search across all your knowledge |
| `Save this screenshot` | Extracts text, saves image + metadata |
| `Save this voice memo` | Transcribes, summarizes, stores |
| `Save this meeting notes` | Extracts decisions, action items,存档 |
| `Run health check` | Checks wiki health, fixes issues |
| `Compile schema` | Builds knowledge graph from your wiki |

**7 content types:** Tweets · Articles · Images · Voice · Files · Chats · Tasks

---

## How It Works

```
You say "save this" → AI processes → Stored in your knowledge base
         ↓
    Raw file saved (images, audio, documents)
         ↓
    AI extracts key information
         ↓
    Classified into PARA (Projects/Areas/Resources/Archives)
         ↓
    Written to wiki + cross-linked + logged
```

**PARA Classification:** AI automatically decides where content belongs:
- **Projects** — Active goals with deadlines
- **Areas** — Ongoing responsibilities
- **Resources** — Topics you're interested in
- **Archives** — Completed or abandoned items

---

## Three-Layer Architecture

```
Layer 1: raw/          → Original files (images, audio, tweets)
Layer 2: wiki/         → Processed knowledge (summaries, links)
Layer 3: wiki/schema/  → Concepts & relationships (weekly compile)
```

---

## How to Use

After installation, just talk to AI:

```
Save this to my second brain: [content]
Save this link to second brain: [URL]
Search my second brain for AI related content
Save that screenshot to second brain
Save today's meeting notes to second brain
```

---

## Supported Content Types

| Type | Examples |
|------|----------|
| Tweets | Twitter posts, Weibo, short thoughts |
| Articles | Blog posts, news, web pages |
| Images | Screenshots, photos (EXIF extracted) |
| Voice | Audio recordings (transcribed) |
| Files | PDF, Word, Excel, text documents |
| Chat | Meeting notes, chat logs |
| Tasks | Schedules, TODOs with deadlines |

---

## Upgrade

```
Please upgrade my second brain
```

---

## Health Check

```
Run the second brain health check
```

Or manually:

```bash
./tools/doctor.sh
./tools/doctor.sh --fix  # auto-fix issues
```

---

## Scheduled Reminders

Set up automatic reminders using OpenClaw cron:

```bash
# Daily todo reminder (9 AM)
openclaw cron add \
  --name "Second Brain - Daily Review" \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "Read wiki/log.md and list all pending tasks for today" \
  --announce --channel <your-channel> --to "<target>"

# Weekly health check (Sunday 8 PM)
openclaw cron add \
  --name "Second Brain - Weekly Check" \
  --cron "0 20 * * 0" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "Run ./tools/doctor.sh and report the results" \
  --announce --channel <your-channel> --to "<target>"
```

---

## Schema Compilation

Layer 3 of the architecture — extract concepts and relationships from your wiki:

```
Compile my second brain schema
```

This extracts:
- **Concepts** (people, products, methods, technologies)
- **Relations** (influences, supports, uses, part_of)
- **Properties** (domain, type, first_seen)

Run manually when your wiki accumulates content:

```bash
./tools/compile_schema.sh --status  # check status
./tools/compile_schema.sh --incremental  # compile new content only
./tools/compile_schema.sh --full  # full recompile
```

---

## Directory Structure

```
second-brain/
├── wiki/           # Your knowledge (organized by PARA)
│   ├── projects/   # Active projects
│   ├── areas/     # Ongoing responsibilities
│   ├── resources/ # Interesting topics
│   ├── archives/  # Completed/archived
│   └── schema/    # Layer 3: Concepts & relationships
├── raw/            # Raw materials (images/audio/files)
├── process/       # AI templates (don't edit)
├── tools/         # Utilities (health check/compile/etc)
└── CLAUDE.md      # AI config (don't edit)
```

---

## Obsidian Integration

Use **Obsidian** to visually browse your wiki:

1. Open Obsidian
2. Click "Open Vault" → select the `second-brain/` folder
3. Obsidian will display all `.md` files in `wiki/`
4. Non-markdown files (`.sh`, images in `raw/`, etc.) are automatically hidden

**Recommended Obsidian plugins:**
- **Dataview** — Query wiki data with dynamic tables
- **Templater** — Automated templates
- **Obsidian Git** — Auto-backup to Git

**Tip:** Both OpenClaw/Claude Code and Obsidian work in the same `second-brain/` folder. OpenClaw manages AI processing, Obsidian provides the visual graph view.

---

## Optional Tools

Install these for full functionality:

| Tool | Function | Install |
|------|----------|---------|
| Whisper | Speech-to-text | `pip3 install whisper` |
| exiftool | Image metadata | `brew install exiftool` |
| yt-dlp | YouTube/Bilibili subtitles | `brew install yt-dlp` |
| agent-reach | Twitter/Xiaohongshu/WeChat | see below |
| qmd | Semantic search (recommended) | `npm install -g @tobilu/qmd` |

**agent-reach install:**

```
Please install agent-reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

**qmd setup:**

```bash
npm install -g @tobilu/qmd
qmd collection add $(pwd)/wiki --name second-brain
qmd embed
```

---

## Recommended Browser Extensions

### Obsidian Web Clipper

Convert web articles to markdown with one click:

1. Install [Obsidian Web Clipper](https://obsidian.md/clipper) extension
2. Configure to save to `second-brain/raw/articles/`
3. Clip articles while browsing → they go directly to raw/

This makes ingestion much faster — clip first, process later.

### Image Download Hotkey

After clipping an article with images:
1. In Obsidian Settings → Files and links → set "Attachment folder path" to `raw/assets/`
2. Bind hotkey: Search "Download" → "Download attachments for current file"
3. After clipping, press the hotkey → all images download locally

This ensures LLMs can view images directly from local files.

---

## Generate Slides from Wiki

Use [Marp](https://marp.app/) to create presentations from wiki content:

1. Install Marp plugin in Obsidian
2. Write markdown with Marp syntax
3. Export to PPT/PDF

Example:
```markdown
---
marp: true
theme: default
---

# My Presentation

- Point 1
- Point 2
```

This lets you generate slide decks directly from your accumulated knowledge.

---

## FAQ

**Q: Where is my data stored?**
A: In `wiki/` and `raw/` directories, all local, never uploaded to cloud.

**Q: Do I need to maintain it manually?**
A: No. AI automatically updates index and log.

**Q: How is this different from regular notes?**
A: Second Brain automatically classifies using PARA, remembers relationships between content, and runs regular health checks.

**Q: What is Schema and when should I compile it?**
A: Schema is Layer 3 — it extracts concepts and relationships from your wiki content. Compile when your wiki has accumulated significant content (weekly recommended). Use `@compile` command or run `./tools/compile_schema.sh --incremental`.

---

## Fork & Contribute

**Want to stay updated with the latest changes?**

If you fork this repo, you can receive updates from the original:

### Step 1: Fork on GitHub
Click the "Fork" button on [github.com/zhiwehu/second-brain](https://github.com/zhiwehu/second-brain)

### Step 2: Clone your fork
```bash
git clone https://github.com/YOUR_USERNAME/second-brain.git
cd second-brain
```

### Step 3: Add upstream remote
```bash
git remote add upstream https://github.com/zhiwehu/second-brain.git
```

### Step 4: Upgrade
When updates are available, run:
```bash
./upgrade.sh
```
This will fetch latest changes from the original repo and merge them into yours.

### Step 5: Contribute (optional)
If you fix a bug or add a feature, submit a Pull Request on GitHub!

---

## Theoretical References

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

---

## For Developers

For manual installation or contributing, see [README_DEV.md](README_DEV.md).

For Chinese version, see [README_ZH.md](README_ZH.md) / [README_DEV_ZH.md](README_DEV_ZH.md).
