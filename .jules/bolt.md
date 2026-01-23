## 2024-01-17 - [Conditional LaTeX Compilation]
**Learning:** LaTeX builds often default to double compilation to resolve references, but for incremental builds or stable content, this is redundant. Parsing the log file for specific "Rerun" messages allows for conditional compilation, saving ~50% build time.
**Action:** In future LaTeX Makefiles, implement a log grep check (e.g., `grep -E "Rerun|Please rerun|Label\\(s\\) may have changed"`) to conditionally trigger the second pass.
