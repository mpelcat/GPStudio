MAINDOC=gpproc

LC=pdflatex
LFLAGS=-interaction=nonstopmode

HTMLC=htlatex
HTMLFLAGS= "" "" "" "--interaction=nonstopmode"

all: pdf

pdf: ../../doc/$(MAINDOC).pdf

html: ../../doc/$(MAINDOC).html ../../doc/$(MAINDOC).css

$(MAINDOC).aux: $(MAINDOC).tex ../gpdevice/gpblock.tex ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null

$(MAINDOC).pdf: $(MAINDOC).aux $(MAINDOC).tex ../gpdevice/gpblock.tex ../../version.txt ../gpstudio_doc.tex
	$(LC) $(LFLAGS) $(MAINDOC).tex > /dev/null

../../doc/$(MAINDOC).pdf: $(MAINDOC).pdf
	cp $(MAINDOC).pdf ../../doc/

$(MAINDOC).html: $(MAINDOC).tex ../../version.txt ../gpstudio_doc.tex
	$(HTMLC) $(MAINDOC).tex > /dev/null

../../doc/$(MAINDOC).html: $(MAINDOC).html
	cp $(MAINDOC).html ../../doc/
../../doc/$(MAINDOC).css: $(MAINDOC).css
	cp $(MAINDOC).css ../../doc/

clean:
	rm -rf *.log *.aux *.synctex.gz $(MAINDOC).pdf *.4ct *.4tc *.dvi *.html *.css *.idv *.lg *.log *.tmp *.xref *.man *.cfg *.xml *-fig*.tex *-fig*.dot *.cache *.out

