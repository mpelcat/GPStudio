include ../../config

ifeq ($(VHDL_SUPPORT),yes)
ifeq ($(USE_VHDL_FP_LIB),yes)
all: lib-core lib-fp
install: install-core install-fp
else
all: lib-core
install: install-core
endif
else
all:
	@echo "Warning: VHDL library not built (run ../../configure with [--vhdl_support])"
install:
	@echo "Warning: VHDL library not installed (run ../../configure with [--vhdl_support])"
endif

COMPONENTS=stream_out.vhd stream_in.vhd port_in.vhd port_out.vhd port_buffer.vhd fifo_fb.vhd fifo_fb_t.vhd single_clock_ram.vhd split.vhd

components: $(COMPONENTS)
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) stream_out.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) stream_in.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) port_in.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) port_out.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) port_buffer.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) fifo_fb.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) fifo_fb_t.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) single_clock_ram.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) split.vhd

lib-core: components caph.vhd
	$(GHDL) -a --work=caph --workdir=. $(GHDLOPTS) caph.vhd

lib-fp: components caph_fp.vhd
	$(GHDL) -a --work=caph_fp --workdir=. $(GHDLOPTS) -P$(VHDL_FP_LIB) caph_fp.vhd

install-core: lib-core
	$(INSTALL) -d $(CAPH_VHDL_LIB)
	(for f in $(COMPONENTS); do $(CP) $$f $(CAPH_VHDL_LIB); done)
	$(CP) caph.vhd $(CAPH_VHDL_LIB)
	$(CP) caph-obj93.cf $(CAPH_VHDL_LIB)
	$(CP) README $(CAPH_VHDL_LIB)

install-fp: lib-fp
	$(INSTALL) -d $(CAPH_VHDL_LIB)
	$(CP) caph_fp.vhd $(CAPH_VHDL_LIB)
	$(CP) caph_fp-obj93.cf $(CAPH_VHDL_LIB)

clean:
	\rm -f *.cf

realclean: clean
	\rm -f *~

clobber: realclean
