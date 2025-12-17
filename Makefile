OUT=build

# LaTeX CV source
LATEX_TEX=methods/latex/CV.tex

.PHONY: all
all: latex

# LaTeX method (hand-written)
.PHONY: latex
latex: $(OUT)/latex/CV.pdf

$(OUT)/latex:
	mkdir -p $@

$(OUT)/latex/CV.pdf: $(LATEX_TEX) | $(OUT)/latex
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)
	# Only run xelatex again if the log requests a rerun (e.g. for cross-references)
	if grep -q "Rerun to" $(OUT)/latex/CV.log; then xelatex -output-directory=$(OUT)/latex $(LATEX_TEX); fi

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: latex
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
