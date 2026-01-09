# Palette's Journal

## 2026-01-09 - PDF Metadata Accessibility
**Learning:** LaTeX documents often default to generic PDF metadata (Creator: LaTeX) which is bad for accessibility (screen readers) and professional presentation (window titles showing filenames).
**Action:** Always check `\hypersetup` configuration in LaTeX projects. Ensure `pdftitle`, `pdfauthor`, `pdflang` (usually `en-US`), and `pdfdisplaydoctitle=true` are set.
