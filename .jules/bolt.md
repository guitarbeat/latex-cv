# Bolt's Journal

## 2025-01-04 - LaTeX Compilation Redundancy and Font Lookups
**Learning:** The default `Makefile` runs `xelatex` twice unconditionally to ensure cross-references are resolved. This doubles the compilation time even for minor edits where one pass might suffice, or no-op builds. Additionally, the fallback font logic (`\IfFontExistsTF`) triggers expensive `mktextfm` calls when system fonts (Calibri, Helvetica, Arial) are missing, as `kpathsea` tries to generate them from Metafont sources, causing significant delays and log noise.

**Action:** Use `latexmk` to manage the build process. It intelligently determines the number of runs needed (often just one) and handles dependencies, significantly reducing build time for incremental changes. While the font lookup cost is structural to the fallback logic on Linux, `latexmk` minimizes the impact by running fewer times.
