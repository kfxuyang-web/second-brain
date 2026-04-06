# Second Brain

> Your personal knowledge base, maintained by AI. Just say what you want to save — AI handles the rest.

**Twitter:** [@zhiwehu](https://twitter.com/zhiwehu)

---

## Install (One Command)

**In OpenClaw or Claude Code, just say:**

```
Please install Second Brain from https://github.com/zhiwehu/second-brain
```

AI will automatically:
1. Clone the repo
2. Run the setup script
3. Inject into your AI system
4. Done

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

**Supported content types:**
- Tweets / thoughts / ideas
- Articles / links
- Screenshots / images
- Voice memos
- PDFs / documents
- Chat logs / meeting notes
- Schedules / TODOs

**AI automatically:**
- Fetches content
- Detects type (tweet/article/image/etc)
- Classifies using PARA (Projects/Areas/Resources/Archives)
- Writes to knowledge base
- Updates index and log

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

## Directory Structure

```
second-brain/
├── wiki/           # Your knowledge (organized by PARA)
│   ├── projects/   # Active projects
│   ├── areas/     # Ongoing responsibilities
│   ├── resources/ # Interesting topics
│   └── archives/  # Completed/archived
├── raw/           # Raw materials (images/audio/files)
└── tools/         # Utilities (health check/backup/etc)
```

---

## Optional Tools

Install these for full functionality:

| Tool | Function | Install |
|------|----------|---------|
| Whisper | Speech-to-text | `pip3 install whisper` |
| exiftool | Image metadata | `brew install exiftool` |
| yt-dlp | YouTube/Bilibili subtitles | `brew install yt-dlp` |
| agent-reach | Twitter/Xiaohongshu/WeChat | see below |

**agent-reach install:**

```
Please install agent-reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

---

## FAQ

**Q: Where is my data stored?**
A: In `wiki/` and `raw/` directories, all local, never uploaded to cloud.

**Q: Do I need to maintain it manually?**
A: No. AI automatically updates index and log.

**Q: How is this different from regular notes?**
A: Second Brain automatically classifies using PARA, remembers relationships between content, and runs regular health checks.

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
