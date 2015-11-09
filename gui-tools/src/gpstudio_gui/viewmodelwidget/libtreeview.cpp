#include "libtreeview.h"

#include <QDebug>
#include <QDrag>
#include <QMimeData>
LibTreeView::LibTreeView(QWidget *parent) :
    QTreeView(parent)
{
    _model = new LibItemModel(this);
    setModel(_model);

    setSelectionMode(QAbstractItemView::SingleSelection);
    setDragEnabled(true);
    setDragDropMode(QAbstractItemView::DragOnly);
}

void LibTreeView::setLib(const Lib *lib)
{
    _model->setLib(lib);

    resizeColumnToContents(0);
    resizeColumnToContents(1);
}

void LibTreeView::startDrag(Qt::DropActions supportedActions)
{
    Q_UNUSED(supportedActions);

    QDrag *drag = new QDrag(this);
    QMimeData *mimeData = new QMimeData;

    ProcessLib proc = _model->processList()[currentIndex().data(Qt::UserRole).toInt()];

    mimeData->setText(proc.name());
    drag->setMimeData(mimeData);
    drag->setPixmap(proc.icon().pixmap(32,32));

    drag->exec();
}
