## 2024-05-23 - Missing latexmk in environment
**Learning:** The memory states that `latexmk` is required and used, but it is not installed in the environment (`command not found`). The `Makefile` currently uses a hardcoded double `xelatex` execution.
**Action:** When optimizing LaTeX builds without `latexmk`, implement a script to check the log for "Rerun" requests to avoid unnecessary passes or ensure sufficient passes.
