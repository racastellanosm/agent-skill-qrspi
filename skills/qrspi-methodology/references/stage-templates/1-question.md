# Stage 1: Question (Scope, Socratic Stress-Testing & Alignment)

- **Feature:** `<feature-slug>`
- **Date & Time:** `YYYY-MM-DD HH:MM:SS UTC`
- **Author/Agent:** `<Agent / User Name>`
- **Cognitive Load / Model Tier:** `MEDIUM (Standard Reasoning)`
- **Status:** `[DRAFT | IN_STRESS_TEST | ALIGNED]`

---

## 1.1 Problem Statement
- **User Prompt Summary:**
- **Core Objective:**

## 1.2 Requirements Breakdown
- **Functional Requirements (FRs):**
  - [ ] `FR-1`: 
  - [ ] `FR-2`: 
- **Non-Functional Requirements (NFRs):**
  - [ ] `NFR-1` (Performance/Latency): 
  - [ ] `NFR-2` (Backward Compatibility): 
  - [ ] `NFR-3` (Security/Permissions): 

## 1.3 Autonomous Codebase Pre-Check ("Zero Lazy Questions")
*Document what was already verified in the repository before prompting the user:*
- **Existing Conventions & Types Located:** 
- **Current Runtime / Package Constraints Verified:** 
- **Pre-answered Questions (from code exploration):** 

## 1.4 Foundational Interrogation Matrix (Zero Assumptions Rule)
| Foundation Pillar | Inquired / Explored Question | User Decision / Strategy | Status |
| :--- | :--- | :--- | :--- |
| **1. Stack & Ecosystem** | *Target language, runtime version, zero-dep vs packages?* | e.g. TypeScript 5+ (Node 22) / zero-dep stdlib | `[PENDING | CONFIRMED]` |
| **2. Architecture & Design** | *Design paradigm (DDD, Clean Architecture, OOP, Functional)?* | e.g. Domain-Driven Design / Modular Monolith | `[PENDING | CONFIRMED]` |
| **3. Testing Methodology** | *Test strategy (TDD, unit vs integration, mock strategy)?* | e.g. Strict Test-Driven Development (TDD) | `[PENDING | CONFIRMED]` |
| **4. Concurrency & Invariants** | *Thread safety, sync/async, memory vs persistence, error modeling?* | e.g. Mutex-protected in-memory + Result types | `[PENDING | CONFIRMED]` |

## 1.5 Socratic Stress-Testing & Failure Vectors
| Failure Vector | Stress Question / Probe Scenario | Mitigating Strategy / Decision |
| :--- | :--- | :--- |
| **Failure Modes & Fallbacks** | *What if downstream/database fails?* | |
| **Concurrency & Idempotency** | *What if simultaneous parallel requests occur?* | |
| **Backward Compatibility** | *Will this break existing clients or data schemas?* | |
| **Boundary Conditions** | *What happens with nulls, empty lists, or 100x payload?* | |

## 1.6 Decision Trees & Trade-Offs (Branch Exploration)
```
Decision Tree:
├── Option A (Recommended): [e.g. TypeScript + TDD + Zero Dependencies] -> Trade-off: [High portability vs stdlib complexity]
└── Option B (Alternative): [e.g. Python 3.12 + PyTest + LRU Dict]       -> Trade-off: [Rapid implementation vs runtime speed]
```

## 1.7 Ambiguities & Clarifications Resolution Table
| Ambiguity / Assumption | User / Code Confirmation | Resolution Status |
| :--- | :--- | :--- |
| e.g. Target Node.js version | Confirmed: Node.js >= 20 LTS | `RESOLVED` |

## 1.8 Acceptance Criteria & Hard Gate
- [ ] Criterion 1:
- [ ] Criterion 2:
- [ ] **Hard Gate Passed:** Problem statement, failure mode mitigations, and decision branches are 100% deterministic and aligned.

## 1.9 Mandatory User Alignment & Approval Gate
> 🛑 **MANDATORY HARD STOP:** The agent must present the questions and requirements breakdown above to the user, STOP calling tools, and END ITS TURN. Do not proceed to Phase 2 until user approval is confirmed below.
- [ ] **User Approval Confirmed:** `[PENDING | APPROVED]`
- **Approved by:** `<User Name / Handle>`
- **Approval Timestamp:** `YYYY-MM-DD HH:MM:SS UTC`
