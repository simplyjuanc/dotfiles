# Backend Engineering Agent Team — Orchestration Configuration

## Team Composition

| Agent | File | Role | Model |
|---|---|---|---|
| Tech Lead | `backend-tech-lead` | Orchestrator, decomposition, integration review | Opus |
| API Architect | `backend-api-architect` | REST contract, OpenAPI spec, webhook schemas | Sonnet |
| Domain Specialist | `backend-domain-specialist` | DDD, aggregates, commands, domain events | Sonnet |
| Infrastructure Specialist | `backend-infrastructure-specialist` | DB, migrations, messaging, webhook delivery | Sonnet |

## Architecture

Hub-and-spoke. The Tech Lead is the sole hub. Specialists never communicate with each other — all routing goes through the Tech Lead.

```
                    ┌──────────────────────┐
                    │      Tech Lead       │
                    │   (Orchestrator)     │
                    └──┬───────┬───────┬───┘
          ┌────────────┘       │       └────────────┐
          ▼                    ▼                    ▼
 ┌────────────────┐  ┌──────────────────┐  ┌────────────────────┐
 │  API Architect │  │ Domain Specialist│  │  Infra Specialist  │
 └────────┬───────┘  └────────┬─────────┘  └──────────┬─────────┘
          └───────────────────┴───────────────────────┘
                  All responses route back to Tech Lead
```

## Execution Phases

### Phase 1 — Decomposition (Tech Lead only)
Tech Lead produces a `TaskDecomposition` JSON sent simultaneously to all three specialists.

### Phase 2 — Parallel Execution (all three specialists concurrently)
All agents work in parallel from the same `TaskDecomposition`. Each declares `dependencies` when they need something from another agent.

**What each agent can do independently (no dependencies required):**

| Agent | Independent Work |
|---|---|
| API Architect | Full OpenAPI spec, contract tests, idempotency requirements, webhook event schemas |
| Domain Specialist | Aggregates, entities, value objects, invariants, domain events, unit tests |
| Infrastructure Specialist | DB schema, migrations, messaging topology, testcontainer setup, security middleware skeleton |

**Common cross-agent dependencies:**

| Requesting | Needs From | What | Default if unblocked |
|---|---|---|---|
| Domain Specialist | API Architect | Exact DTO shapes for translation layer | Define domain types first; adapt translation layer later |
| Infra Specialist | Domain Specialist | Repository interface signatures | Scaffold from TaskDecomposition resource shapes |
| Infra Specialist | API Architect | Cursor fields for index design | Default to `created_at` |
| API Architect | Domain Specialist | Aggregate command names for entity actions | Infer from TaskDecomposition naming |
| Infra Specialist | API Architect | Which POST endpoints require idempotency | Default to all creation endpoints |
| Infra Specialist | API Architect | Webhook event contracts | Scaffold from TaskDecomposition domainEvents |

### Phase 3 — Integration Review (Tech Lead only)
Tech Lead validates all three outputs against the cross-layer checklist and writes end-to-end acceptance tests. Re-invokes only the agents with blocking findings.

## Cross-Layer Validation Checklist

The Tech Lead must pass all 10 checks before marking a feature approved:

1. **Envelope consistency** — `data`/`pagination`/`error` shapes match across OpenAPI spec, code, and tests
2. **Casing consistency** — kebab-case URIs, snake_case query params, camelCase body fields everywhere
3. **Domain leak check** — no domain internals (aggregate names, command types) in API responses or DB schemas
4. **Pagination index check** — DB indexes cover the cursor fields used in paginated endpoints
5. **Webhook contract check** — event `data`/`eventType`/`eventId` and required headers match the standard
6. **Idempotency check** — all required POST endpoints have idempotency implemented end-to-end
7. **Security masking check** — 404 (not 403) returned to unauthenticated users for protected resources
8. **Versioning check** — no unversioned breaking changes; major version present in URI
9. **Monetary value check** — currency + minor-units pattern used everywhere monetary values appear
10. **Ubiquitous language check** — consistent naming across API, domain model, and persistence layers

## Circular Dependency Resolution

When two agents are mutually blocked on each other:
1. Tech Lead identifies the minimal information each needs to unblock.
2. Makes a provisional design decision based on the `TaskDecomposition` and standard conventions.
3. Sends the provisional answer to both agents flagged with `provisional: true`.
4. During integration review, validates that provisional decisions held or reconciles any drift.

Never wait indefinitely — always resolve with a provisional decision.

## How to Invoke the Team

Use the `backend-tech-lead` agent with a plain-language feature request:

```
Implement an expense tagging system:
- Users can create, update, delete, and list tags scoped to a company
- Multiple tags can be attached to an expense
- Tags support bulk search by name
- A webhook fires when a tag is attached or detached from an expense
```

The Tech Lead will decompose the request, invoke the three specialists in parallel, resolve dependencies, and produce an integration-reviewed, fully-tested, shippable feature package.

## Pleo API Standard Reference

All agents fetch the live standard at session start:
```
https://raw.githubusercontent.com/pleo-io/api-standard/main/API-STANDARD.asciidoc
```

The API Architect fetches the full standard. Domain and Infrastructure Specialists fetch the sections relevant to their concerns.
