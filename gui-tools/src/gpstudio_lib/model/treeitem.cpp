#include "treeitem.h"

#include <QDebug>

TreeItem::TreeItem()
{
}
QString TreeItem::fromblock() const
{
    return _fromblock;
}

void TreeItem::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}
QString TreeItem::fromflow() const
{
    return _fromflow;
}

void TreeItem::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}
uint TreeItem::size() const
{
    return _size;
}

void TreeItem::setSize(const uint &size)
{
    _size = size;
}
QString TreeItem::order() const
{
    return _order;
}

void TreeItem::setOrder(const QString &order)
{
    _order = order;
}
uint TreeItem::muxvalue() const
{
    return _muxvalue;
}

void TreeItem::setMuxvalue(const uint &muxvalue)
{
    _muxvalue = muxvalue;
}

TreeItem *TreeItem::fromNodeGenerated(const QDomElement &domElement)
{
    TreeItem *treeItem=new TreeItem();
    bool ok=false;

    treeItem->setFromblock(domElement.attribute("fromblock",""));
    treeItem->setFromflow(domElement.attribute("fromflow",""));

    int size = domElement.attribute("size","0").toInt(&ok);
    if(ok && size>=0) treeItem->setSize(size); else treeItem->setSize(0);

    treeItem->setOrder(domElement.attribute("order",""));

    int muxvalue = domElement.attribute("muxvalue","0").toInt(&ok);
    if(ok && muxvalue>=0) treeItem->setMuxvalue(muxvalue); else treeItem->setMuxvalue(0);

    return treeItem;
}

QList<TreeItem *> TreeItem::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<TreeItem *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="tree_item") list.append(TreeItem::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
