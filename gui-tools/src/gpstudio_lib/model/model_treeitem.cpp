#include "model_treeitem.h"

#include <QDebug>

ModelTreeItem::ModelTreeItem()
{
}
QString ModelTreeItem::fromblock() const
{
    return _fromblock;
}

void ModelTreeItem::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}
QString ModelTreeItem::fromflow() const
{
    return _fromflow;
}

void ModelTreeItem::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}
uint ModelTreeItem::size() const
{
    return _size;
}

void ModelTreeItem::setSize(const uint &size)
{
    _size = size;
}
QString ModelTreeItem::order() const
{
    return _order;
}

void ModelTreeItem::setOrder(const QString &order)
{
    _order = order;
}
uint ModelTreeItem::muxvalue() const
{
    return _muxvalue;
}

void ModelTreeItem::setMuxvalue(const uint &muxvalue)
{
    _muxvalue = muxvalue;
}

ModelTreeItem *ModelTreeItem::fromNodeGenerated(const QDomElement &domElement)
{
    ModelTreeItem *treeItem=new ModelTreeItem();
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

QList<ModelTreeItem *> ModelTreeItem::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelTreeItem *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="tree_item") list.append(ModelTreeItem::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
