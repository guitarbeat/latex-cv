## 2024-05-23 - [Optimize Makefile]
**Learning:** LaTeX builds often run `xelatex` multiple times unnecessarily. `latexmk` handles this automatically, but adding it as a dependency isn't always feasible. A simple bash script or makefile logic can check the log file for "Rerun" warnings to conditionally trigger a second pass.
**Action:** When working with raw Makefiles for LaTeX, always implement conditional re-runs instead of hardcoded multiple passes.
