#include "treeconnect.h"

#include <QDebug>

TreeConnect::TreeConnect()
{
}

QString TreeConnect::toblock() const
{
    return _toblock;
}

void TreeConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

QString TreeConnect::toflow() const
{
    return _toflow;
}

void TreeConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

uint TreeConnect::size() const
{
    return _size;
}

void TreeConnect::setSize(const uint &size)
{
    _size = size;
}

QString TreeConnect::order() const
{
    return _order;
}

void TreeConnect::setOrder(const QString &order)
{
    _order = order;
}

QString TreeConnect::muxname() const
{
    return _muxname;
}

void TreeConnect::setMuxname(const QString &muxname)
{
    _muxname = muxname;
}

QList<TreeItem *> TreeConnect::treeitems()
{
    return _treeitems;
}

const QList<TreeItem *> TreeConnect::treeitems() const
{
    return _treeitems;
}

void TreeConnect::addTreeItem(TreeItem *treeItem)
{
    _treeitems.append(treeItem);
}

void TreeConnect::addTreeItems(const QList<TreeItem *> &treeItems)
{
    foreach (TreeItem *treeItem, treeItems)
    {
        addTreeItem(treeItem);
    }
}

TreeConnect *TreeConnect::fromNodeGenerated(const QDomElement &domElement)
{
    TreeConnect *treeConnect=new TreeConnect();
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
            if(e.tagName()=="tree_items") treeConnect->addTreeItems(TreeItem::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return treeConnect;
}

QList<TreeConnect *> TreeConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<TreeConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="tree_connect") list.append(TreeConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
