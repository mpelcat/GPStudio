#ifndef MODEL_TREECONNECT_H
#define MODEL_TREECONNECT_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QDomElement>

#include "model_treeitem.h"

class GPSTUDIO_LIB_EXPORT ModelTreeConnect
{
public:
    ModelTreeConnect();

    QString toblock() const;
    void setToblock(const QString &toblock);

    QString toflow() const;
    void setToflow(const QString &toflow);

    uint size() const;
    void setSize(const uint &size);

    QString order() const;
    void setOrder(const QString &order);

    QString muxname() const;
    void setMuxname(const QString &muxname);

    QList<ModelTreeItem *> treeitems();
    const QList<ModelTreeItem *> treeitems() const;
    void addTreeItem(ModelTreeItem *treeItem);
    void addTreeItems(const QList<ModelTreeItem *> &treeItems);

public:
    static ModelTreeConnect *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelTreeConnect *> listFromNodeGenerated(const QDomElement &domElement);


protected:
    QString _toblock;
    QString _toflow;
    uint _size;
    QString _order;
    QString _muxname;

    QList<ModelTreeItem *> _treeitems;
};

#endif // MODEL_TREECONNECT_H
