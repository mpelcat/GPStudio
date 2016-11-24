include ../gpstudio.mk

DOCS_PATH = $(sort $(dir $(wildcard */Makefile)))
DOCS = $(patsubst %/,%,$(DOCS_PATH))
DOCS_PDF = $(addprefix $(GPS_PATH)doc/, $(addsuffix .pdf, $(DOCS)))

all: $(DOCS_PDF)
	@echo $(DOCS) $(DOCS_PDF)

clean: $(addsuffix -clean, $(DOCS))

%-clean: FORCE
	@echo "$(GREEN)cleaning doc $* ...$(RESET)"
	@cd $*/ && make clean -f Makefile

$(GPS_PATH)doc/%.pdf: FORCE
	@test -d $(GPS_PATH)/doc/ || mkdir -p $(GPS_PATH)/doc/
	@echo "$(GREEN)building doc $* ...$(RESET)"
	@cd $*/ && make -f Makefile

FORCE:
