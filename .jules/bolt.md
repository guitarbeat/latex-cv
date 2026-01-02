# Bolt's Journal

## 2024-05-22 - Initial Setup
**Learning:** This is a LaTeX-based project using XeLaTeX and `tabularray`. `tabularray` typically requires multiple compilation passes to calculate column widths correctly. The current `Makefile` naively runs `xelatex` twice.
**Action:** Investigate if `latexmk` can optimize the build process by running the exact number of times needed (no more, no less).
