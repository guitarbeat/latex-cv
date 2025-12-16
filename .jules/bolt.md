## 2024-05-23 - [Makefile] Conditional LaTeX Compilation
**Learning:** Unconditional double compilation in Makefiles is a common source of wasted build time (often 50%+ overhead) in LaTeX projects, especially when cross-references are stable.
**Action:** Use `grep` on the log file to conditionally trigger a second pass only when "Rerun" is requested by the engine.
