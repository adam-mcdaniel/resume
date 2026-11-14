# Resume build.
#
#   make           public PDF        -> build/Resume.pdf
#   make private   full PDF          -> build/Resume-private.pdf (needs private.tex)
#   make site      public web page   -> build/site/ (what GitHub Pages serves)
#   make check     fail if the public PDF contains private details
#   make clean
#
# The public build compiles from src/, where private.tex is not visible.
# The private build adds the repository root to TEXINPUTS so that
# \InputIfFileExists{private.tex} in src/resume.tex picks it up.

LATEXMK := latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error
SRC     := src/resume.tex

.PHONY: all public private site check clean

all: public

public: build/Resume.pdf

private: build/Resume-private.pdf

build/Resume.pdf: $(SRC)
	cd src && $(LATEXMK) -outdir=../build/public -jobname=Resume resume.tex
	cp build/public/Resume.pdf $@

build/Resume-private.pdf: $(SRC) private.tex
	cd src && TEXINPUTS="..:" $(LATEXMK) -outdir=../build/private -jobname=Resume-private resume.tex
	cp build/private/Resume-private.pdf $@

private.tex:
	@echo "private.tex not found: copy private.example.tex to private.tex and fill it in." >&2
	@exit 1

site: build/Resume.pdf
	scripts/make-site.sh build/Resume.pdf build/site

check: build/Resume.pdf
	scripts/check-public.sh build/Resume.pdf

clean:
	rm -rf build
