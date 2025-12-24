## 2024-05-23 - LaTeX Metadata and Link Accessibility
**Learning:** In LaTeX-based CVs, metadata (title, author, language) and clickable links are often overlooked but crucial for screen readers and digital consumption. `hyperref` can be configured to provide these without visible design changes.
**Action:** Always check `\hypersetup` for `pdftitle`, `pdfauthor`, `pdflang` and ensure contact info is wrapped in `\href`.
