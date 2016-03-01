#include "model_treeconnect.h"

#include <QDebug>

ModelTreeConnect::ModelTreeConnect()
{
}

QString ModelTreeConnect::toblock() const
{
    return _toblock;
}

void ModelTreeConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

QString ModelTreeConnect::toflow() const
{
    return _toflow;
}

void ModelTreeConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

uint ModelTreeConnect::size() const
{
    return _size;
}

void ModelTreeConnect::setSize(const uint &size)
{
    _size = size;
}

QString ModelTreeConnect::order() const
{
    return _order;
}

void ModelTreeConnect::setOrder(const QString &order)
{
    _order = order;
}

QString ModelTreeConnect::muxname() const
{
    return _muxname;
}

void ModelTreeConnect::setMuxname(const QString &muxname)
{
    _muxname = muxname;
}

QList<ModelTreeItem *> ModelTreeConnect::treeitems()
{
    return _treeitems;
}

const QList<ModelTreeItem *> ModelTreeConnect::treeitems() const
{
    return _treeitems;
}

void ModelTreeConnect::addTreeItem(ModelTreeItem *treeItem)
{
    _treeitems.append(treeItem);
}

void ModelTreeConnect::addTreeItems(const QList<ModelTreeItem *> &treeItems)
{
    foreach (ModelTreeItem *treeItem, treeItems)
    {
        addTreeItem(treeItem);
    }
}

ModelTreeConnect *ModelTreeConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ModelTreeConnect *treeConnect=new ModelTreeConnect();
    bool ok=false;

    treeConnect->setToblock(domElement.attribute("toblock",""));
    treeConnect->setToflow(domElement.attribute("toflow",""));

    int size = domElement.attribute("size","0").toInt(&ok);
    if(ok && size>=0) treeConnect->setSize(size); else treeConnect->setSize(0);

    treeConnect->setOrder(domElement.attribute("order",""));
    treeConnect->setMuxname(domElement.attribute("muxname",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="tree_items") treeConnect->addTreeItems(ModelTreeItem::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return treeConnect;
}

QList<ModelTreeConnect *> ModelTreeConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelTreeConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="tree_connect") list.append(ModelTreeConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
