## 2025-12-20 - Switch to tabularx
**Learning:** `tabularray` is extremely slow to compile due to its complex calculation engine. `tabularx` provides similar functionality (auto-width columns) with significantly faster compilation times, especially for documents with many tables.
**Action:** Use `tabularx` for CV layouts. Use custom column types (e.g., `Y`, `Z`) to achieve proportional column widths (e.g., 3:1 ratio).
