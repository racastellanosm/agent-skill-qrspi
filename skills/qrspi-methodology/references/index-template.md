# QRSPI Architecture Decision & Session Index (Living ADR)

**Configured Session Root:** `<session-root>` *(e.g. `.qrspi/`, `.docs/`, `.implementations/`, `.sessions/`)*  
**Purpose:** Centralized repository index and living architecture decision registry for all QRSPI feature sessions.

---

## 📚 Session Registry

| Date | Feature / Ticket | Session Path | Status | Key Architectural Decision | Handoff |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `YYYY-MM-DD` | `auth-v2-migration` | [`YYYY-MM-DD-auth-v2-migration/`](YYYY-MM-DD-auth-v2-migration/) | `COMPLETED` | Migrated from JWT to session-tokens with Redis cache | `@dev-lead` |
| `YYYY-MM-DD` | `payments-webhook` | [`YYYY-MM-DD-payments-webhook/`](YYYY-MM-DD-payments-webhook/) | `IN_PROGRESS` | Added idempotency keys in Postgres | `@backend-team` |

---

## 🔄 Quick Handoff Guide for Agents & Developers
1. To inspect decisions of a feature: Navigate to its folder under `<session-folder>/`.
2. To resume an in-progress feature:
   - Read `3-structure.md` for architectural context.
   - Read `4-plan.md` for the remaining steps.
   - Update `5-implement.md` with execution results.
