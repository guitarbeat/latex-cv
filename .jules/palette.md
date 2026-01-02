## 2026-01-02 - [PDF Accessibility Metadata]
**Learning:** LaTeX documents (via `hyperref`) need explicit `pdflang` configuration for screen readers to work correctly. Without this, some readers default to the system locale or fail to read content correctly.
**Action:** Always include `pdflang={en-US}` (or appropriate locale) in `\hypersetup` for any LaTeX document intended for digital distribution. Also, explicitly setting `pdftitle` and `pdfauthor` ensures the window title is informative rather than showing a raw filename.
