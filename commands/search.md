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

## Post-Search: Save Valuable Insights

**After returning search results, always ask:**
> "Would you like to save this analysis to your wiki?"

**Why this matters:**
- Search results often contain synthesized insights
- These insights are valuable and shouldn't disappear into chat history
- Saving them to wiki compounds your knowledge over time

**What to save:**
- Synthesized conclusions from multiple sources
- Comparisons and analyses you asked for
- Connections discovered between topics
- Questions answered that might help future searches

**How to save:**
1. If user says yes, create a new wiki page
2. Classify using PARA (usually resources or archives)
3. Write to wiki/{para}/YYYY-MM-DD-search-{topic}.md
4. Update index.md and log.md
5. Link to the source pages that contributed to the analysis

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
