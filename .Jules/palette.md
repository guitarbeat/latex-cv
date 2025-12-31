## 2024-05-22 - [Accessible PDF Metadata and Links]
**Learning:** LaTeX templates often default to minimal metadata and non-clickable text, missing easy accessibility wins. Adding `pdflang`, `pdftitle`, and `\href` wrappers significantly improves the screen reader experience and usability without changing the visual design.
**Action:** Always check `\hypersetup` for missing metadata and ensure contact info (email/web) is wrapped in `\href` in CV/document templates.
