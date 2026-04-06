# Search Second Brain

Tell me what you want to search for, e.g. "Search my second brain for content about AI agents"

## How it works

1. Check if qmd is available for semantic search
2. Search the wiki/ directory
3. Return relevant pages with summaries

## Examples

- "Search my second brain for attention economy"
- "Find content about LLM Wiki in my second brain"
- "Search in projects for deadline-related items"

## Tips

- Use specific keywords for better results
- Mention the PARA category if you know it: "search resources for X"
- qmd semantic search is more accurate than keyword search when available

## Install qmd for better search (optional)

```bash
npm install -g @tobilu/qmd
qmd collection add $(pwd)/wiki --name wiki
qmd embed
```

Without qmd, grep is used as fallback.
