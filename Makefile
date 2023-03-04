# Makefile for Learning MD with LAMMPS

SHELL          = /bin/bash
HAS_BASH       = YES
ifeq (,$(wildcard $(SHELL)))
OSHELL         := $(SHELL)
override SHELL = /bin/sh
HAS_BASH       = NO
endif
BUILDDIR       = ${CURDIR}
RSTDIR         = $(BUILDDIR)/src
VENV           = $(BUILDDIR)/docenv
ANCHORCHECK    = $(VENV)/bin/rst_anchor_check
SPHINXCONFIG   = $(BUILDDIR)/sphinx-config
MATHJAX        = $(SPHINXCONFIG)/_static/mathjax
MATHJAXTAG     = 3.2.2

PYTHON         = $(word 3,$(shell type python3))
HAS_PYTHON3    = NO
HAS_PDFLATEX   = NO

ifeq ($(shell type python3 >/dev/null 2>&1; echo $$?), 0)
HAS_PYTHON3    = YES
endif

ifeq ($(shell type pdflatex >/dev/null 2>&1; echo $$?), 0)
ifeq ($(shell type latexmk >/dev/null 2>&1; echo $$?), 0)
HAS_PDFLATEX = YES
endif
endif

# override settings for PIP commands
# PIP_OPTIONS = --cert /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt --proxy http://proxy.mydomain.org

SPHINXEXTRA = -j $(shell $(PYTHON) -c 'import multiprocessing;print(multiprocessing.cpu_count())')

.PHONY: help clean-all clean clean-spelling epub mobi html pdf spelling anchor_check char_check role_check fasthtml

# ------------------------------------------

help:
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html          create HTML pages in html dir"
	@echo "  pdf           create Learning_MD.pdf in this dir"
	@echo "  epub          create ePUB format manual for e-book readers"
	@echo "  mobi          convert ePUB to MOBI format manual for e-book readers (e.g. Kindle)"
	@echo "                      (requires ebook-convert tool from calibre)"
	@echo "  fasthtml      approximate HTML page creation in fasthtml dir (for development)"
	@echo "  clean         remove all intermediate files"
	@echo "  clean-all     reset the entire build environment"
	@echo "  anchor_check  scan for duplicate anchor labels"
	@echo "  spelling      spell-check the manual"

# ------------------------------------------

clean-all: clean
	rm -rf $(BUILDDIR)/docenv $(MATHJAX) $(BUILDDIR)/Learning_MD.mobi $(BUILDDIR)/Learning_MD.epub $(BUILDDIR)/Learning_MD.pdf

clean: clean-spelling
	rm -rf $(BUILDDIR)/html $(BUILDDIR)/epub $(BUILDDIR)/latex $(BUILDDIR)/doctrees $(BUILDDIR)/fasthtml

clean-spelling:
	rm -rf $(BUILDDIR)/spelling

html: $(VENV) $(ANCHORCHECK) $(MATHJAX)
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		sphinx-build -E $(SPHINXEXTRA) -b html -c $(SPHINXCONFIG) -d $(BUILDDIR)/doctrees $(RSTDIR) html ;\
		ln -sf Learning_MD.html html/index.html;\
		echo "############################################" ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		rst_anchor_check src/*.rst ;\
		env LC_ALL=C grep -n '[^ -~]' $(RSTDIR)/*.rst ;\
		env LC_ALL=C grep -n ' :[a-z]\+`' $(RSTDIR)/*.rst ;\
		echo "############################################" ;\
		deactivate ;\
	)
	@rm -rf html/_sources
	@rm -rf html/USER
	@rm -rf html/images
	@echo "Build finished. The HTML pages are in html."

spelling: $(VENV) $(SPHINXCONFIG)/false_positives.txt
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@(\
		. $(VENV)/bin/activate ; \
		cp $(SPHINXCONFIG)/false_positives.txt $(RSTDIR)/;  env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		sphinx-build -b spelling -c $(SPHINXCONFIG) -d $(BUILDDIR)/doctrees $(RSTDIR) spelling ;\
		deactivate ;\
	)
	@echo "Spell check finished."

epub: $(VENV) $(ANCHORCHECK)
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@mkdir -p epub/images
	@rm -f Learning_MD.epub
	@cp src/images/*.* epub/images
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		sphinx-build -E $(SPHINXEXTRA) -b epub -c $(SPHINXCONFIG) -d $(BUILDDIR)/doctrees $(RSTDIR) epub ;\
		deactivate ;\
	)
	@mv  epub/Learning_MD.epub .
	@rm -rf epub
	@echo "Build finished. The ePUB manual file is created."

mobi: epub
	@rm -f Learning_MD.mobi
	@ebook-convert Learning_MD.epub Learning_MD.mobi
	@echo "Conversion finished. The MOBI manual file is created."

pdf: $(VENV) $(ANCHORCHECK)
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@if [ "$(HAS_PDFLATEX)" == "NO" ] ; then echo "PDFLaTeX or latexmk were not found! Please check README for further instructions" 1>&2; exit 1; fi
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		sphinx-build -E $(SPHINXEXTRA) -b latex -c $(SPHINXCONFIG) -d $(BUILDDIR)/doctrees $(RSTDIR) latex ;\
		echo "############################################" ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		rst_anchor_check src/*.rst ;\
		env LC_ALL=C grep -n '[^ -~]' $(RSTDIR)/*.rst ;\
		env LC_ALL=C grep -n ' :[a-z]\+`' $(RSTDIR)/*.rst ;\
		echo "############################################" ;\
		deactivate ;\
	)
	@cd latex && \
		sed 's/\\begin{equation}//g' Learning_MD.tex > tmp.tex && \
		mv tmp.tex Learning_MD.tex && \
		sed 's/\\end{equation}//g' Learning_MD.tex > tmp.tex && \
		mv tmp.tex Learning_MD.tex && \
		sed 's/\\contentsname}{.*}}/\\contentsname}{Learning Molecular Dynamics with LAMMPS}}/g' Learning_MD.tex > tmp.tex && \
		mv tmp.tex Learning_MD.tex && \
		$(MAKE) $(MFLAGS) && \
		mv Learning_MD.pdf ../Learning_MD.pdf && \
		cd ../;
	@rm -rf latex/_sources
	@rm -rf latex/USER
	@echo "Build finished. Learning_MD.pdf is in this directory."

anchor_check : $(ANCHORCHECK)
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		rst_anchor_check src/*.rst ;\
		deactivate ;\
	)

style_check : $(VENV)
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		python utils/check-styles.py -s ../src -d src ;\
		deactivate ;\
	)

package_check : $(VENV)
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		python utils/check-packages.py -s ../src -d src ;\
		deactivate ;\
	)

char_check :
	@( env LC_ALL=C grep -n '[^ -~]' $(RSTDIR)/*.rst && exit 1 || : )

role_check :
	@( env LC_ALL=C grep -n ' :[a-z]\+`' $(RSTDIR)/*.rst && exit 1 || : )

link_check : $(VENV) html
	@(\
		. $(VENV)/bin/activate ; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		linkchecker -F html --check-extern html/Learning_MD.html ;\
		deactivate ;\
	)

# ------------------------------------------

$(VENV):
	@if [ "$(HAS_BASH)" == "NO" ] ; then echo "bash was not found at $(OSHELL)! Please use: $(MAKE) SHELL=/path/to/bash" 1>&2; exit 1; fi
	@if [ "$(HAS_PYTHON3)" == "NO" ] ; then echo "python3 was not found! Please see README for further instructions" 1>&2; exit 1; fi
	@( \
		$(PYTHON) -m venv $(VENV); \
		. $(VENV)/bin/activate; \
		pip $(PIP_OPTIONS) install --upgrade pip; \
		pip $(PIP_OPTIONS) install --upgrade wheel; \
		pip $(PIP_OPTIONS) install -r $(BUILDDIR)/sphinx-config/requirements.txt; \
		deactivate;\
	)

$(MATHJAX):
	@git clone -b $(MATHJAXTAG) -c advice.detachedHead=0 --depth 1 https://github.com/mathjax/MathJax.git $@

$(ANCHORCHECK): $(VENV)
	@( \
		. $(VENV)/bin/activate; env PYTHONWARNINGS= PYTHONDONTWRITEBYTECODE=1 \
		pip $(PIP_OPTIONS) install -e utils;\
		deactivate;\
	)
