## 2024-05-23 - LaTeX Build Optimization
**Learning:** Naive Makefiles often run `xelatex` or `pdflatex` multiple times (2-3x) unconditionally to resolve references. This is inefficient for stable builds or incremental changes.
**Action:** Use `latexmk` with appropriate flags (e.g., `-xelatex`, `-pdf`) to automatically detect if re-runs are needed. It significantly speeds up incremental builds (from ~17s to <0.5s) and avoids unnecessary work.
