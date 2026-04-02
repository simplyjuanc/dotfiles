---
name: backend-engineering-team
description: |
  Invokes the full backend engineering agent team (Tech Lead + API Architect + Domain Specialist + Infrastructure Specialist) to implement a backend feature end-to-end, following the Pleo API Standard.

  TRIGGER this skill when:
  - User asks to implement a new backend feature, endpoint, or service
  - A task requires API design + domain modelling + data layer work together
  - User mentions resources, endpoints, domain events, webhooks, or idempotency in the same request
  - User wants a Pleo API Standard-compliant implementation from scratch

  DO NOT TRIGGER when:
  - Only a single layer is needed (e.g. "fix this SQL query", "update the OpenAPI spec", "refactor this aggregate") — invoke the relevant specialist agent directly instead
  - The task is purely investigative (use codebase-research-architect instead)
---

# Backend Engineering Team

Invoke the `backend-tech-lead` agent with the feature request. The Tech Lead will:

1. **Decompose** the request into a `TaskDecomposition` covering resources, endpoints, domain events, and cross-cutting concerns.
2. **Invoke in parallel**: `backend-api-architect` (OpenAPI spec + contract tests), `backend-domain-specialist` (aggregates + domain events + repo interfaces), `backend-infrastructure-specialist` (DB schema + migrations + messaging + webhook delivery).
3. **Resolve dependencies** between agents (routes questions, resolves circular dependencies with provisional decisions).
4. **Review and gate** the integrated output against the Pleo API Standard cross-layer checklist before approving.

## How to invoke

```
Use the Agent tool with subagent_type="backend-tech-lead" and pass the feature description as the prompt.
```

Example prompt to the Tech Lead:
```
Implement a tag management system:
- Companies can create, update, delete, and list tags
- Tags can be attached to and detached from expenses
- Searching tags by name must support unbounded filter lists
- A webhook fires when a tag is attached or detached
```

## When to invoke specialist agents directly (skip the Tech Lead)

| Need | Agent |
|---|---|
| API contract only | `backend-api-architect` |
| Domain model only | `backend-domain-specialist` |
| DB/infra only | `backend-infrastructure-specialist` |
| Full feature (API + domain + infra) | `backend-tech-lead` (this skill) |

## Reference

Orchestration architecture and cross-layer validation checklist: `~/.claude/agents/backend-team-orchestration.md`
