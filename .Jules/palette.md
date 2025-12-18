## 2024-05-23 - [PDF Accessibility in LaTeX]
**Learning:** Even when the build environment is restricted (no xelatex), standard LaTeX packages like `hyperref` allow for significant accessibility improvements (metadata, language, bookmarks) that remain invisible to the visual layout but crucial for digital consumption.
**Action:** Always check `\hypersetup` for `pdftitle`, `pdfauthor`, `pdflang`, and `pdfdisplaydoctitle`. Ensure custom section commands add to the TOC via `\addcontentsline`.
