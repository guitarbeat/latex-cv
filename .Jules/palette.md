## 2024-05-23 - PDF Metadata and Interaction
**Learning:** Even in static documents like PDFs, UX matters. Missing metadata prevents screen readers from identifying the document language and title, and static text for contacts frustrates users expecting interactivity.
**Action:** Always add `\hypersetup` with `pdftitle`, `pdfauthor`, `pdflang` and wrap contacts in `\href` for LaTeX CVs.
