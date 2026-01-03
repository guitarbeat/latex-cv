# Bolt's Journal

## 2024-05-22 - [Latex Build Optimization]
**Learning:** `latexmk` is the preferred build tool for LaTeX projects as it automatically handles dependency tracking and multiple compilation passes, avoiding unnecessary recompilations and significantly speeding up the build loop compared to manual `pdflatex` calls.
**Action:** Always prefer `latexmk` over manual invocation of latex engines.

## 2024-05-22 - [Font Loading Performance]
**Learning:** Using `fontspec` with `Numbers=Lining` requires careful font selection. If the primary font isn't found, XeLaTeX can fail or produce ugly output. A fallback strategy (Calibri -> Helvetica -> Arial -> TeX Gyre Heros) ensures the build works on different environments (Linux vs. Windows/macOS) without failing, which is critical for CI/CD pipelines.
**Action:** Implement robust font fallbacks in LaTeX templates.
