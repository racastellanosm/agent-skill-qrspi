# Stage 3: Structure (Architectural Design & Contracts)

- **Feature:** `<feature-slug>`
- **Date & Time:** `YYYY-MM-DD HH:MM:SS UTC`
- **Cognitive Load / Model Tier:** `HIGH (Deep Reasoning / Extended Thinking)`
- **Status:** `[DRAFT | APPROVED]`

---

## 3.1 Proposed Topology Changes
| File Path | Action | Description |
| :--- | :--- | :--- |
| `src/core/feature.ts` | `CREATE` | Core logic implementation |
| `src/types/index.ts` | `MODIFY` | Export new contracts |
| `src/legacy/old_mod.ts` | `DEPRECATE` | Mark old module deprecated |

## 3.2 Interface & Type Contracts
```typescript
// Target interfaces, schemas, or data structures
export interface FeatureContract {
  id: string;
  execute(params: ExecutionParams): Promise<ExecutionResult>;
}
```

## 3.3 Architectural Decisions & Trade-Offs (ADR Notes)
- **Decision:** 
- **Rationale / Justification:** 
- **Alternatives Considered & Rejected:** 
- **Invariants & Error Modes:** 

## 3.4 Hard Gate Confirmation
- [ ] **Gate Passed:** Architecture satisfies Phase 1 requirements and Phase 2 codebase constraints.

## 3.5 Mandatory User Review & Architecture Approval Gate
> 🛑 **MANDATORY HARD STOP:** The agent must present the architectural design, contracts, and trade-offs to the user, STOP calling tools, and END ITS TURN. Do not proceed to Phase 4 until user approval is confirmed below.
- [ ] **User Approval Confirmed:** `[PENDING | APPROVED]`
- **Approved by:** `<User Name / Handle>`
- **Approval Timestamp:** `YYYY-MM-DD HH:MM:SS UTC`
