OUT=build

# Methods
LATEX_TEX=methods/latex/CV.tex
PANDOC_META=methods/pandoc-common/cv.yaml
PANDOC_FILTER=methods/pandoc-common/render_cv.lua
TPL_CLASSIC=methods/pandoc-classic/template.tex
TPL_ALT=methods/pandoc-alt/template.tex
TPL_DOCX=methods/pandoc-docxlike/template.tex

.PHONY: all
all: latex pandoc-classic pandoc-alt pandoc-docx

# LaTeX method (hand-written)
.PHONY: latex
latex: $(OUT)/latex/CV.pdf

$(OUT)/latex:
	mkdir -p $@

$(OUT)/latex/CV.pdf: $(LATEX_TEX) | $(OUT)/latex
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)
	xelatex -output-directory=$(OUT)/latex $(LATEX_TEX)

# Pandoc methods
.PHONY: pandoc-docx
pandoc-docx:    $(OUT)/pandoc-docxlike/CV.pdf

.PHONY: pandoc-classic
pandoc-classic: $(OUT)/pandoc-classic/CV.pdf

.PHONY: pandoc-alt
pandoc-alt:     $(OUT)/pandoc-alt/CV.pdf

$(OUT)/pandoc-docxlike:
	mkdir -p $@

$(OUT)/pandoc-docxlike/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_DOCX) | $(OUT)/pandoc-docxlike
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_DOCX) \
	  -t latex \
	  --pdf-engine=xelatex \
	  -o $@ </dev/null

$(OUT)/pandoc-classic:
	mkdir -p $@

$(OUT)/pandoc-classic/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_CLASSIC) | $(OUT)/pandoc-classic
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_CLASSIC) \
	  -t latex \
	  --pdf-engine=xelatex \
	  -o $@ </dev/null

$(OUT)/pandoc-alt:
	mkdir -p $@

$(OUT)/pandoc-alt/CV.pdf: $(PANDOC_META) $(PANDOC_FILTER) $(TPL_ALT) | $(OUT)/pandoc-alt
	pandoc --standalone \
	  --metadata-file=$(PANDOC_META) \
	  --lua-filter=$(PANDOC_FILTER) \
	  --template=$(TPL_ALT) \
	  -t latex \
	  --pdf-engine=xelatex \
	  -o $@ </dev/null

# Comparison images (requires ImageMagick and pdftoppm)
.PHONY: compare
compare: all
	./scripts/gen_comparisons.sh

.PHONY: word_pdf
word_pdf: reference/original.docx | $(OUT)
	./scripts/convert_docx.sh reference/original.docx build/word/original.pdf

.PHONY: compare_word
compare_word: word_pdf
	./scripts/gen_comparisons.sh

.PHONY: score
score: compare
	./scripts/score_methods.sh

.PHONY: context extract validate
context: extract validate

extract:
	./scripts/context_tools.sh extract

validate: all
	./scripts/context_tools.sh validate

.PHONY: clean
clean:
	rm -rf $(OUT)
