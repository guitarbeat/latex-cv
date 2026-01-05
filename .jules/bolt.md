## 2024-05-22 - Environment Dependencies and Makefiles
**Learning:** Makefiles often rely on external tools (like `latexmk`) that must be present in the environment. When optimizing build scripts to use better tools, ensure those tools are installed or documented as dependencies. In this case, switching to `latexmk` required installing it, but it provides significant benefits for incremental builds and correctness.
**Action:** Always check `which <tool>` or `<tool> --version` before adding it to a script, and update environment setup instructions if needed.
