## 2024-05-23 - [Optimize Makefile]
**Learning:** LaTeX builds often run `xelatex` multiple times unnecessarily. `latexmk` handles this automatically, but adding it as a dependency isn't always feasible. A simple bash script or makefile logic can check the log file for "Rerun" warnings to conditionally trigger a second pass.
**Action:** When working with raw Makefiles for LaTeX, always implement conditional re-runs instead of hardcoded multiple passes.

## 2024-05-23 - [Optimize XeLaTeX Fonts]
**Learning:** `xelatex` attempts to generate font metrics (`mktextfm`) for missing fonts (like Calibri or Arial on Linux) which can significantly slow down the build (up to 40% slower on cold builds). Setting `MKTEXTFM=0` prevents this futile attempt without breaking the build (assuming fallback fonts are handled in LaTeX).
**Action:** When running `xelatex` in CI/CD or Linux environments where proprietary fonts might be missing, set `MKTEXTFM=0` to speed up the build.

## 2024-05-23 - [Optimize Tooling Scripts]
**Learning:** Helper scripts that perform expensive conversions (like `pandoc` or `pdftotext`) often run unconditionally in build/validation loops. Adding simple file timestamp checks (`-nt`) to skip redundant operations can significantly reduce cycle time for non-code changes.
**Action:** Always wrap expensive conversion commands in timestamp checks (Make-like logic) within bash scripts if they are called frequently.
