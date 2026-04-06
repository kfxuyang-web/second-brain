# Health Check Second Brain

Run a health check on your second brain. Say "run the health check" or "check my second brain"

## Examples

- "Run the health check on my second brain"
- "Check if my second brain is healthy"
- "Run the second brain doctor"
- "Run a full lint on my wiki"

## Two-Level Checks

### Structural (Automated)
```bash
./tools/doctor.sh        # Quick check
./tools/doctor.sh --fix  # Auto-fix
```
- Directory structure
- Core files existence
- Index/log synchronization
- Orphan pages
- Git status

### Content (AI-Powered) — Run with this command

Say "Run a full lint on my wiki" or ask AI to check:

1. **Contradictions** — Find pages with conflicting claims
2. **Stale claims** — Check if newer sources have superseded old claims
3. **Orphan pages** — Pages with no inbound links
4. **Missing cross-references** — Concepts mentioned but not linked
5. **Data gaps** — Important topics not yet covered

## How often

- Quick check (doctor.sh): Weekly
- Full lint (AI-powered): Monthly
