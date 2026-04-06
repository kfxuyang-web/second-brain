# Search Second Brain

Tell me what you want to search for, e.g. "Search my second brain for content about AI agents"

## How it works

1. Check if qmd is available for semantic search
2. Search the wiki/ directory
3. Return relevant pages with summaries
4. **IMPORTANT**: After returning results, ask user if they want to save the analysis/conclusions to wiki

## Examples

- "Search my second brain for attention economy"
- "Find content about LLM Wiki in my second brain"
- "Search in projects for deadline-related items"

## Post-Search: Always Ask to Save

**After returning search results, ask:**
> "要把这个分析存到 wiki 吗？"

If yes:
1. Create `wiki/resources/YYYY-MM-DD-search-{topic}.md`
2. Update `wiki/index.md` and `wiki/log.md`
3. Link to source pages

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
