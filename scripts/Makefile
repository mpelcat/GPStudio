include ../gpstudio.mk

SRC_BACKEND = $(wildcard *.php) $(wildcard */*.php) $(wildcard $(GPS_PATH)/support/toolchain/)

all: dox

dox: $(GPS_PATH)/doc/backend.pdf
$(GPS_PATH)/doc/backend/latex/refman.pdf: Doxyfile $(SRC_BACKEND)
	@test -d $(GPS_PATH)/doc/backend || mkdir -p $(GPS_PATH)/doc/backend
	@echo "$(GREEN)building doc-backend ...$(RESET)"
	doxygen > /dev/null
	cd $(GPS_PATH)/doc/backend/latex/ && make -f Makefile > /dev/null
$(GPS_PATH)/doc/backend.pdf: $(GPS_PATH)/doc/backend/latex/refman.pdf
	cp $(GPS_PATH)/doc/backend/latex/refman.pdf $(GPS_PATH)/doc/backend.pdf

doc-backend-clean:
	@echo
	@echo "$(GREEN)cleaning doc-backend ...$(RESET)"
	rm -rf $(GPS_PATH)/doc/backend
