GREEN := $(shell tput setaf 2)
RESET := $(shell tput sgr0)

DOCS_PATH = $(sort $(dir $(wildcard */Makefile)))
DOCS = $(patsubst %/,%,$(DOCS_PATH))

SRC_BACKEND = $(wildcard ../scripts/*.php) $(wildcard ../scripts/*/*.php) $(wildcard ../support/toolchain/)

all: $(addsuffix -build, $(DOCS)) doc-backend

clean: $(addsuffix -clean, $(DOCS)) doc-backend-clean

doc-backend: ../doc/backend.pdf
../doc/backend/latex/refman.pdf: ../scripts/Doxyfile $(SRC_BACKEND)
	@test -d ../doc/backend || mkdir -p ../doc/backend
	cd ../scripts && doxygen > /dev/null
	cd ../doc/backend/latex/ && make -f Makefile > /dev/null
../doc/backend.pdf: ../doc/backend/latex/refman.pdf
	cp ../doc/backend/latex/refman.pdf ../doc/backend.pdf

doc-backend-clean:
	@echo
	@echo "$(GREEN)cleaning doc-backend ...$(RESET)"
	cd ../doc || rm -rf backend

%-clean: FORCE
	@echo
	@echo "$(GREEN)cleaning doc $* ...$(RESET)"
	@cd $*/ && make clean -f Makefile

%-build: FORCE
	@test -d ../doc/ || mkdir -p ../doc/
	@echo
	@echo "$(GREEN)building doc $* ...$(RESET)"
	@cd $*/ && make -f Makefile

FORCE:
