## 2024-05-22 - [Optimizing LaTeX Builds]
**Learning:** `latexmk` is significantly more efficient than hardcoded `xelatex` runs in Makefiles. It handles dependencies and reruns automatically, avoiding unnecessary compilation cycles.
**Action:** Always prefer `latexmk` for LaTeX projects, especially in CI/CD pipelines where build time matters.
