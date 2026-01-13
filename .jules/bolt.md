## 2024-05-23 - [Optimize Makefile]
**Learning:** LaTeX builds often run `xelatex` multiple times unnecessarily. `latexmk` handles this automatically, but adding it as a dependency isn't always feasible. A simple bash script or makefile logic can check the log file for "Rerun" warnings to conditionally trigger a second pass.
**Action:** When working with raw Makefiles for LaTeX, always implement conditional re-runs instead of hardcoded multiple passes.

## 2024-05-23 - [Optimize XeLaTeX Fonts]
**Learning:** `xelatex` attempts to generate font metrics (`mktextfm`) for missing fonts (like Calibri or Arial on Linux) which can significantly slow down the build (up to 40% slower on cold builds). Setting `MKTEXTFM=0` prevents this futile attempt without breaking the build (assuming fallback fonts are handled in LaTeX).
**Action:** When running `xelatex` in CI/CD or Linux environments where proprietary fonts might be missing, set `MKTEXTFM=0` to speed up the build.

## 2024-05-23 - [Makefile Delegation Caching]
**Learning:** When Makefile targets delegate to shell scripts (e.g., `extract: ./script.sh`), Make loses visibility into the script's input/output dependencies. If the script performs expensive operations (like `pandoc`), it runs every time.
**Action:** Scripts called by Make should implement their own timestamp-based caching (using `-nt`) to skip redundant work, ensuring the "up-to-date" behavior users expect from Make.
