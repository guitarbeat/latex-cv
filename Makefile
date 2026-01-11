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
	# Check log for rerun requests and re-compile if necessary (combined grep for efficiency)
	if grep -q -F -e "Rerun to get" -e "Rerun LaTeX" -e "rerunfilecheck Warning" $(OUT)/latex/CV.log; then \
		xelatex -output-directory=$(OUT)/latex $(LATEX_TEX); \
	fi

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: latex
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
