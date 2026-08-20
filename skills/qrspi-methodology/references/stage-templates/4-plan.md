# Stage 4: Plan (Atomic Step-by-Step Checklist)

- **Feature:** `<feature-slug>`
- **Date & Time:** `YYYY-MM-DD HH:MM:SS UTC`
- **Cognitive Load / Model Tier:** `HIGH (Deep Reasoning / Extended Thinking)`
- **Status:** `[DRAFT | READY_FOR_EXECUTION]`

---

## 4.1 Step-by-Step Atomic Checklist

- [ ] **Step 1: Declare Contracts & Types**
  - *Action:* Add interface definitions in `src/types/index.ts`.
  - *Verification Command:* `pnpm tsc --noEmit`
- [ ] **Step 2: Test-First Harness (TDD)**
  - *Action:* Write test suite in `tests/feature.test.ts`.
  - *Verification Command:* `pnpm test tests/feature.test.ts` (Expected: Fail / Red)
- [ ] **Step 3: Core Implementation**
  - *Action:* Implement logic in `src/core/feature.ts`.
  - *Verification Command:* `pnpm test tests/feature.test.ts` (Expected: Pass / Green)
- [ ] **Step 4: Integration & Full Suite**
  - *Action:* Wire exports into `src/main.ts`.
  - *Verification Command:* `pnpm test && pnpm lint`

## 4.2 Rollback / Checkpoint Strategy
- If Step 3 breaks backward compatibility: revert to checkpoint commit or fallback adapter.

## 4.3 Hard Gate Confirmation
- [ ] **Gate Passed:** Plan verified with atomic steps and automated validation commands.
