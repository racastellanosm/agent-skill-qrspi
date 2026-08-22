# Container Security Hardening & Supply Chain Protection

Container security is not an afterthought; it is built into the base image selection, user privileges, dependency locking, and audit targets.

---

## 🛡️ Security Invariants Checklist

| Invariant | Implementation Rule | Why? |
| :--- | :--- | :--- |
| **SEC-01: Non-Root Execution** | `USER 1000:1000` or `USER nonroot` in production stage. | Prevents container breakout exploits from gaining host root access. |
| **SEC-02: Zero Production Shell** | Use Distroless or Scratch for final stage. | Eliminates `/bin/sh`, `curl`, `wget`, preventing attackers from executing reverse shells. |
| **SEC-03: Supply Chain Protection** | `--ignore-scripts` during npm/bun install; `--frozen-lockfile`. | Blocks malicious postinstall scripts from untrusted packages. |
| **SEC-04: Automated Audit Target** | Every project must implement `make audit`. | Scans dependencies (`bun pm untrusted`, `npm audit`, `composer audit`). |
| **SEC-05: Ephemeral Test Isolation** | `--rm --no-deps` on all test runner commands. | Prevents test pollution, side-effects, and credential leakage across test runs. |
| **SEC-06: No Hardcoded Secrets** | Pass secrets via environment variables or Docker secrets. | Never bake API keys, DB passwords, or tokens into image layers. |
| **SEC-07: Container Vulnerability Scanning** | Scan production images with `docker scout` or Trivy. | Detects OS-level and application CVEs before deployment. |

---

## 🔒 Layer-by-Layer Hardening Rules

### 1. User Privileges (Non-Root)
Never run the containerized process as UID 0 (`root`):
```dockerfile
# Debian / Distroless
USER nonroot:nonroot

# Alpine / Custom UID
RUN addgroup -g 1000 appgroup && adduser -u 1000 -G appgroup -D appuser
USER 1000:1000
```

### 2. Supply Chain & Lifecycle Scripts
Dependencies should never be trusted to run arbitrary scripts on install:
```bash
# Bun
bun install --frozen-lockfile --ignore-scripts

# npm
npm ci --ignore-scripts

# Composer
composer install --no-interaction --no-scripts
```

### 3. Supply Chain Security Auditing in Makefile
Integrate an audit target directly into the Makefile verification pipeline:
```makefile
audit: ## Runs dependency security & supply chain audit inside container
	$(DOCKER_RUN) api bun pm untrusted
	$(DOCKER_RUN) api bun pm audit
```

### 4. Container Image Vulnerability Scanning (Docker Scout & SBOM)
Before shipping images to a registry or production environment, audit the built image for Known Vulnerabilities (CVEs) and generate a Software Bill of Materials (SBOM):

```bash
# Quick overview of vulnerabilities and base image health
docker scout quickview <image-name>:<tag>

# Deep CVE analysis filtered by Critical and High severities
docker scout cves --only-severity critical,high <image-name>:<tag>

# Get actionable base image update recommendations
docker scout recommendations <image-name>:<tag>
```

#### Dedicated Makefile Target Pattern:
```makefile
audit-image: build ## Audits the production image for CVEs using Docker Scout
	@echo "$(BLUE)==> Scanning image for vulnerabilities with Docker Scout...$(NC)"
	docker scout cves --only-severity critical,high $(APP_NAME):latest
```
