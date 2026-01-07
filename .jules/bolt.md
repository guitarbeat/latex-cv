## 2024-05-23 - LaTeX Build Optimization
**Learning:** Compiling LaTeX documents unconditionally multiple times is a common inefficiency. Using `grep` to check the log file for "Rerun" requests allows skipping the second pass when the document is already stable, significantly reducing build times for minor edits.
**Action:** Use conditional compilation logic in Makefiles for LaTeX projects to check if a rerun is truly needed.
