#ifndef TREEITEM_H
#define TREEITEM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT TreeItem
{
public:
    TreeItem();

    QString fromblock() const;
    void setFromblock(const QString &fromblock);

    QString fromflow() const;
    void setFromflow(const QString &fromflow);

    uint size() const;
    void setSize(const uint &size);

    QString order() const;
    void setOrder(const QString &order);

    uint muxvalue() const;
    void setMuxvalue(const uint &muxvalue);

public:
    static TreeItem *fromNodeGenerated(const QDomElement &domElement);
    static QList<TreeItem *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _fromblock;
    QString _fromflow;
    uint _size;
    QString _order;
    uint _muxvalue;
};

#endif // TREEITEM_H
