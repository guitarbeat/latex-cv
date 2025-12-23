## 2025-12-23 - LaTeX PDF Accessibility
**Learning:** Adding `pdflang={en-US}` (or other code) to `hypersetup` is critical for PDF accessibility. Screen readers rely on this to know which language pronunciation rules to use. It is invisible to sighted users but essential for a11y.
**Action:** Always check `hypersetup` in LaTeX documents intended for digital distribution and ensure language, title, and author metadata are set.

## 2025-12-23 - XeLaTeX Font Fallbacks
**Learning:** When developing locally on Linux without proprietary fonts (like Calibri/Arial), `fontspec` fallbacks (e.g., to `TeX Gyre Heros`) allow the build to succeed while maintaining layout integrity.
**Action:** When working on LaTeX templates that might be built in CI or Linux environments, ensure robust fallback fonts are defined.
