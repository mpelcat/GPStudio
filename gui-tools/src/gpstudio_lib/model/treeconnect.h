#ifndef TREECONNECT_H
#define TREECONNECT_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QDomElement>

#include "treeitem.h"

class GPSTUDIO_LIB_EXPORT TreeConnect
{
public:
    TreeConnect();

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

    QList<TreeItem *> treeitems();
    const QList<TreeItem *> treeitems() const;
    void addTreeItem(TreeItem *treeItem);
    void addTreeItems(const QList<TreeItem *> &treeItems);

public:
    static TreeConnect *fromNodeGenerated(const QDomElement &domElement);
    static QList<TreeConnect *> listFromNodeGenerated(const QDomElement &domElement);


protected:
    QString _toblock;
    QString _toflow;
    uint _size;
    QString _order;
    QString _muxname;

    QList<TreeItem *> _treeitems;
};

#endif // TREECONNECT_H
