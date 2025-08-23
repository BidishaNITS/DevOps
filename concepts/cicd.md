# CI/CD — What I Built in This Repo

## Goal
Automate quality + builds on every change, publish images to a registry, and update Kubernetes with the latest version.

---

## CI (Continuous Integration)

### Triggers
- On every **push** to `main` and on every **Pull Request** targeting `main`.

### Jobs (GitHub Actions)
1) **Lint & Build**
   - **Hadolint** lints the `Dockerfile` (best practices).
   - Set up **QEMU + Buildx** for consistent Docker builds.
   - Build a local test image to catch build errors early.

2) **Scan then Push to GHCR (multi‑arch)**
   - Build a temporary image and **scan with Trivy** (HIGH/CRITICAL) — report‑only mode.
   - **Login to GHCR** using the ephemeral `GITHUB_TOKEN`.
   - **Build & push multi‑arch** image (`linux/amd64` + `linux/arm64`) to GHCR.
   - Tags:
     - `ghcr.io/bidishanits/app:latest`
     - `ghcr.io/bidishanits/app:<commit-sha>`

> Why multi‑arch? Apple Silicon (M1/M2/M3) is **arm64**, many servers are **amd64**; one image that works everywhere.

---

## CD (Continuous Delivery / Deployment)

### Image Delivery
- CI publishes the Docker image to **GitHub Container Registry (GHCR)**.
- Package visibility can be **public** (easy pulls) or **private** (use `imagePullSecret`).

### Deployment to Kubernetes (Minikube)
- Deployment uses the GHCR image and always pulls fresh:
  ```yaml
  image: ghcr.io/bidishanits/app:latest
  imagePullPolicy: Always

### Manual rollout command (what I run now)

- kubectl set image deployment/app-deployment myapp=ghcr.io/bidishanits/app:latest
- kubectl rollout status deployment/app-deployment

This is CD‑lite: artifact delivery is automated; deployment is a one‑command manual step.
Full auto‑deploy to Minikube would use a self‑hosted runner on my Mac to run kubectl inside Actions.

⸻

### Security Choices
-	•	No personal tokens in code. Uses GitHub’s short‑lived GITHUB_TOKEN.
-	•	Workflow permissions are minimal:

- permissions:
  - contents: read
  - packages: write


-	•	Hadolint prevents bad Dockerfile patterns; Trivy reports vulnerabilities.
-	•	.dockerignore avoids leaking local files into the image.

⸻

### Quick Commands (cheat‑sheet)

- Trigger CI

- git add .
- git commit -m "change: explain what changed"
- git push

### Watch CI
-	•	Repo → Actions → open the latest run.
-	•	Lint Dockerfile (Hadolint) → see best‑practice warnings.
-	•	Scan image with Trivy → see HIGH/CRITICAL CVEs.
-	•	Build and push (multi‑arch) → confirms image pushed to GHCR.

- Pull & run the pushed image locally

- docker pull ghcr.io/bidishanits/app:latest
- docker run --rm -p 8085:5000 ghcr.io/bidishanits/app:latest

### Deploy newest image to Minikube (manual CD)

- kubectl set image deployment/app-deployment myapp=ghcr.io/bidishanits/app:latest
- kubectl rollout status deployment/app-deployment
- minikube service app-service --url


