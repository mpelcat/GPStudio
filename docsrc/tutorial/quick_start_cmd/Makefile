MAINDOC=quick_start_cmd

LC=pdflatex
LFLAGS=-interaction=nonstopmode --shell-escape

HTMLC=htlatex
HTMLFLAGS= "" "" "" "--interaction=nonstopmode"

all: pdf

pdf: $(MAINDOC).pdf

html: $(MAINDOC).html

$(MAINDOC).pdf: $(MAINDOC).tex ../../../version.txt
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null
	cp $(MAINDOC).pdf ../../../doc/

$(MAINDOC).html: $(MAINDOC).tex ../../../version.txt
	$(HTMLC) $(MAINDOC).tex > /dev/null
	cp $(MAINDOC).html $(MAINDOC).css ../../../doc/

clean:
	rm -rf *.log *.aux *.synctex.gz $(MAINDOC).pdf *.4ct *.4tc *.dvi *.html *.css *.idv *.lg *.log *.tmp *.xref *.man *.cfg *.xml *-fig*.tex *-fig*.dot *.cache

