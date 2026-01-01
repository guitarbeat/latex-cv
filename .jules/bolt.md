## 2024-05-23 - LaTeX Build Optimization
**Learning:** Hardcoded double-compilation in Makefiles is a common anti-pattern in LaTeX projects. It wastes time on incremental edits.
**Action:** Use `latexmk` to automatically handle dependency resolution and rerun logic, optimizing the "hot loop" of editing.
