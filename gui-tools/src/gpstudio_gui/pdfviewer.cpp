#include "pdfviewer.h"

#if (QT_VERSION >= QT_VERSION_CHECK(5, 0, 0))
 #include <poppler/qt5/poppler-qt5.h>
#else
 #include <poppler/qt4/poppler-qt4.h>
#endif

PdfViewer::PdfViewer(QWidget *parent)
    : QWidget(parent)
{
    /*Poppler::Document *doc = Poppler::Document::load(path);
    doc->page(0)->renderToPainter();*/
}
