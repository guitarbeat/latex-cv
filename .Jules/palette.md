## 2025-12-26 - PDF Metadata for Accessibility
**Learning:** Standard LaTeX CV templates often miss PDF metadata (Title, Author, Language), which is critical for screen readers and search indexing.
**Action:** Always verify PDF metadata using `pdfinfo` and add `pdftitle`, `pdfauthor`, `pdflang`, and `pdfdisplaydoctitle` to `\hypersetup`.
