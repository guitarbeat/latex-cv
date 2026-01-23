# Palette Journal

## 2026-01-08 - Accessible PDF Metadata & Links
**Learning:** In LaTeX documents (like CVs), visual structure does not equal accessibility. `\href` and `\hypersetup` metadata are critical for screen readers and searchability, even if the visual output (black text) remains unchanged. `pdfinfo` is a vital tool for verifying "invisible" UX.
**Action:** Always verify `pdftitle`, `pdflang` (for screen readers), and clickable `\href` links in LaTeX templates, ensuring `colorlinks=true, linkcolor=black` maintains design integrity.

## 2026-01-12 - PDF Outline and Navigation
**Learning:** Custom section commands in LaTeX (like `\sectionheading`) do not generate PDF bookmarks by default, making navigation difficult for screen readers and reviewers. Adding `\phantomsection` and `\addcontentsline` manually is required.
**Action:** When creating custom headings in LaTeX, always pair them with PDF bookmark generation code and verify using `*.out` files.

## 2026-01-13 - Window Title for PDFs
**Learning:** By default, PDF viewers display the filename (e.g., `CV.pdf`) in the window title bar, which is unhelpful and poor for accessibility. Adding `pdfdisplaydoctitle=true` to `\hypersetup` forces the viewer to use the metadata Title (e.g., "Curriculum Vitae - Name"), which is WCAG compliant and more professional.
**Action:** Always include `pdfdisplaydoctitle=true` in `\hypersetup` configuration for LaTeX documents intended for digital distribution.

## 2026-05-23 - Mailto Subject Lines
**Learning:** Adding `?subject=...` to `mailto:` links in CVs is a low-effort, high-value micro-UX improvement that reduces friction for recruiters. It works perfectly in LaTeX/PDF.
**Action:** Always verify `mailto` links in PDFs have helpful subject lines pre-filled.
