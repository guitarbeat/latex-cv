## 2026-01-04 - [PDF Accessibility Metadata]
**Learning:** `hyperref` does not automatically populate `pdftitle`, `pdfauthor`, or `pdflang` even if `colorlinks` and other settings are configured. These must be explicitly set for screen readers and professional document properties.
**Action:** Always verify `\hypersetup` includes `pdflang`, `pdftitle`, and `pdfauthor` when working with LaTeX documents, as these are invisible but critical for accessibility.
