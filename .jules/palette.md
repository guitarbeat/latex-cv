# Palette Journal

## 2026-01-08 - Accessible PDF Metadata & Links
**Learning:** In LaTeX documents (like CVs), visual structure does not equal accessibility. `\href` and `\hypersetup` metadata are critical for screen readers and searchability, even if the visual output (black text) remains unchanged. `pdfinfo` is a vital tool for verifying "invisible" UX.
**Action:** Always verify `pdftitle`, `pdflang` (for screen readers), and clickable `\href` links in LaTeX templates, ensuring `colorlinks=true, linkcolor=black` maintains design integrity.

## 2026-01-12 - PDF Outline and Navigation
**Learning:** Custom section commands in LaTeX (like `\sectionheading`) do not generate PDF bookmarks by default, making navigation difficult for screen readers and reviewers. Adding `\phantomsection` and `\addcontentsline` manually is required.
**Action:** When creating custom headings in LaTeX, always pair them with PDF bookmark generation code and verify using `*.out` files.
