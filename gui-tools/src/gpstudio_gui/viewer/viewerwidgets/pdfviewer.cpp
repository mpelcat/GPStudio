/****************************************************************************
** Copyright (C) 2016 Dream IP
**
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "pdfviewer.h"

#if (QT_VERSION >= QT_VERSION_CHECK(5, 0, 0))
 #include <poppler/qt5/poppler-qt5.h>
#else
 #include <poppler/qt4/poppler-qt4.h>
#endif

PdfViewer::PdfViewer(QWidget *parent, QString file)
    : QLabel(parent)
{
    _currentPage = 0;

    _doc = Poppler::Document::load(file);
    showPage(0);
}

void PdfViewer::showPage(int page)
{
    if(!_doc)
        return;
    if(_doc->page(page))
    {
        QImage image = _doc->page(_currentPage)->renderToImage(
                /*scaleFactor **/ physicalDpiX(),
                /*scaleFactor **/ physicalDpiY());
        setPixmap(QPixmap::fromImage(image));
    }
}
