# Palette's Journal

## 2024-05-22 - PDF Accessibility in Legacy Workflows
**Learning:** Even without full tagging support in older LaTeX environments, adding `pdflang`, `pdftitle`, and `pdfdisplaydoctitle` provides immediate accessibility wins for screen readers and window titles.
**Action:** Always check `\hypersetup` for metadata and language definition in LaTeX documents.

## 2024-05-22 - Visual-Only Headings
**Learning:** Custom visual headings in LaTeX (`\newcommand{\sectionheading}`) often miss semantic structure (`\section` or `\addcontentsline`), resulting in PDFs with no navigation outline.
**Action:** Ensure custom headings always include `\phantomsection` and `\addcontentsline{toc}{...}` to generate bookmarks.
