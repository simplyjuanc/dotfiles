---
name: gh-pleo-search
description: Search code across Pleo's GitHub organization using gh CLI. Use when researching patterns, finding implementation examples, understanding how features are built across repos, or looking for usage of specific libraries/patterns in the organization.
---

# Search Pleo GitHub Organization

Search across Pleo repositories using `gh search code --owner pleo-io`.

## Common patterns

```bash
# By language
gh search code --owner pleo-io --language kotlin "Either<"

# By path
gh search code --owner pleo-io --path "domain" "sealed interface"

# By repo
gh search code --repo pleo-io/repo-name "DomainError"

# Combined filters
gh search code --owner pleo-io --language kotlin --path "test" "Arb."
```

## Useful flags

- `--limit N` - Results limit (default 30, max 1000)
- `--json` - Machine-readable output

## Delegate to Task agent

For exploratory research requiring multiple search rounds or synthesis across results, use Task agent with `subagent_type="Explore"`:

```
"Search org repos for Kotlin metrics patterns using gh search code.
Find examples of counters, timers, and gauges.
Return summary with 2-3 best practice examples."
```

Use Task agent when:
- Answering research questions ("how do services implement X?")
- Synthesizing patterns from multiple searches
- Iteratively refining search terms
- Keeping main conversation context clean
