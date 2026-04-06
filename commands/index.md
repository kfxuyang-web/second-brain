# Second Brain Commands

Natural language commands for interacting with your second brain.

## Available Commands

| Command | Description | Example |
|--------|-------------|---------|
| **ingest** | Save content to second brain | "Save this to my second brain" |
| **search** | Search wiki content | "Search my second brain for X" |
| **lint** | Health check | "Run health check on my second brain" |
| **compile** | Compile Schema (Layer 3) | "Compile my second brain schema" |

## Quick Reference

### Ingest content
Say: "Save [content] to my second brain"
- Supports: tweets, articles, images, voice, files, chats, tasks

### Search
Say: "Search my second brain for [topic]"
- Uses qmd semantic search when available

### Health check
Say: "Run health check on my second brain"
- Checks index, log, orphans, stale pages

### Compile Schema
Say: "Compile my second brain schema"
- Extracts concepts and relationships
- Run weekly recommended

## Three-Layer Architecture

```
Layer 1: raw/ - Original files
         ↓ (every ingest)
Layer 2: wiki/ - Processed knowledge
         ↓ (weekly compile)
Layer 3: wiki/schema/ - Concepts & relationships
```

## Directory Structure

```
second-brain/
├── wiki/           # Layer 2: Knowledge base
│   ├── projects/  # Active projects
│   ├── areas/     # Ongoing responsibilities
│   ├── resources/ # Interesting topics
│   ├── archives/  # Completed items
│   └── schema/   # Layer 3: Concepts
├── raw/            # Layer 1: Original files
├── process/       # AI processing templates
├── tools/         # Utilities
└── commands/      # This directory
```
