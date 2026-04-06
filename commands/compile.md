# Compile Second Brain Schema

Compile the Layer 3 Schema from your wiki - extract concepts and relationships.

Say "compile my second brain schema" when your wiki has accumulated content.

## Examples

- "Compile my second brain schema"
- "Build the knowledge graph for my second brain"
- "Extract concepts and relationships from my wiki"

## What it does

1. Read new wiki entries since last compile
2. Extract concepts (people, products, methods, technologies)
3. Identify relationships (influences, supports, uses, part_of)
4. Update wiki/schema/concepts/ files
5. Update wiki/schema/relations.md

## Why compile?

Schema is Layer 3 of the three-layer architecture:

- **Layer 1**: raw/ - Original files (updated every ingest)
- **Layer 2**: wiki/ - Processed knowledge (updated every ingest)
- **Layer 3**: wiki/schema/ - Concepts & relationships (compiled periodically)

Compiling extracts the "knowledge graph" from your accumulated wiki content.

## Run manually

```bash
./tools/compile_schema.sh --status  # Check status
./tools/compile_schema.sh --incremental  # Compile new content only
./tools/compile_schema.sh --full  # Full recompile
```

## When to compile

- After accumulating significant new content
- When search results become less accurate
- Weekly recommended

## Relationship types

- `influences` - A affects B
- `supports` - A backs B
- `contradicts` - A opposes B
- `part_of` - A belongs to B
- `uses` - A uses B
