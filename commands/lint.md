# Health Check Second Brain

Run a health check on your second brain. Say "run the health check" or "check my second brain"

## Examples

- "Run the health check on my second brain"
- "Check if my second brain is healthy"
- "Run the second brain doctor"

## What it checks

### Quick checks
- wiki/index.md is synchronized with actual pages
- wiki/log.md format is correct
- No orphan pages (pages with no inbound links)
- No stale pages (not updated in 30+ days)

### Full checks
- Search for contradictions between pages
- Check if newer sources have superseded old claims
- Identify orphan pages
- Check for missing cross-references
- Find data gaps that could be filled

## Run manually

```bash
./tools/doctor.sh        # Quick check
./tools/doctor.sh --fix  # Auto-fix issues
```

## How often

Run a quick check weekly. Run a full check monthly or when you notice issues.
