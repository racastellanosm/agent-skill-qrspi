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

## 1.4 Socratic Stress-Testing & Failure Vectors
| Failure Vector | Stress Question / Probe Scenario | Mitigating Strategy / Decision |
| :--- | :--- | :--- |
| **Failure Modes & Fallbacks** | *What if downstream/database fails?* | |
| **Concurrency & Idempotency** | *What if simultaneous parallel requests occur?* | |
| **Backward Compatibility** | *Will this break existing clients or data schemas?* | |
| **Boundary Conditions** | *What happens with nulls, empty lists, or 100x payload?* | |

## 1.5 Decision Trees & Trade-Offs (Branch Exploration)
```
Decision Tree:
└── Option A (Chosen / Explored) -> Trade-off: [Speed vs Complexity]
└── Option B (Alternative)       -> Trade-off: [Memory vs Latency]
```

## 1.6 Ambiguities & Clarifications Resolution Table
| Ambiguity / Assumption | User / Code Confirmation | Resolution Status |
| :--- | :--- | :--- |
| e.g. Target Node.js version | Confirmed: Node.js >= 20 LTS | `RESOLVED` |

## 1.7 Acceptance Criteria & Hard Gate
- [ ] Criterion 1:
- [ ] Criterion 2:
- [ ] **Hard Gate Passed:** Problem statement, failure mode mitigations, and decision branches are 100% deterministic and aligned.
