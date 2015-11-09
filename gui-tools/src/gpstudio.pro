TEMPLATE = subdirs

SUBDIRS = gpstudio_com \
          gpstudio_lib \
          gpstudio_gui \
          gpviewer \
          gpnode

# SUBDIRS += ../thirdparts

# doxygen rules
dox.target = doc
dox.commands = doxygen $$PWD/Doxyfile
doxclean.target = doc-clean
doxclean.commands = rm -rf $$PWD/../doc/*
QMAKE_EXTRA_TARGETS += dox doxclean

QMAKE_CLEAN += $(shell find ../doc/ -type f)
