## 2025-12-25 - PDF Metadata for Accessibility
**Learning:** Default LaTeX `hyperref` settings often miss critical accessibility metadata (`pdftitle`, `pdflang`). Without `pdflang`, screen readers may not pronounce the text correctly (e.g., using default voice instead of English). `pdfdisplaydoctitle` is also crucial for window title readability.
**Action:** Always explicitly set `pdftitle`, `pdfauthor`, `pdflang={en-US}`, and `pdfdisplaydoctitle={true}` in `\hypersetup` for any public-facing PDF.
