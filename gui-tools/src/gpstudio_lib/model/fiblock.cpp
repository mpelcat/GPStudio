#include "fiblock.h"

#include <QDebug>

FIBlock::FIBlock()
{
}

FIBlock::~FIBlock()
{
}

QString FIBlock::type() const
{
    return "fi";
}

QList<FlowConnect *> FIBlock::flowConnects()
{
    return _flowConnects;
}

const QList<FlowConnect *> FIBlock::flowConnects() const
{
    return _flowConnects;
}

void FIBlock::addFlowConnect(FlowConnect *flowConnect)
{
    _flowConnects.append(flowConnect);
}

void FIBlock::addFlowConnects(const QList<FlowConnect *> &flowConnects)
{
    foreach (FlowConnect *flowConnect, flowConnects)
    {
        addFlowConnect(flowConnect);
    }
}

QList<TreeConnect *> FIBlock::treeConnects()
{
    return _treeConnects;
}

const QList<TreeConnect *> FIBlock::treeConnects() const
{
    return _treeConnects;
}

void FIBlock::addTreeConnect(TreeConnect *treeConnect)
{
    _treeConnects.append(treeConnect);
}

void FIBlock::addTreeConnects(const QList<TreeConnect *> &treeConnects)
{
    foreach (TreeConnect *treeConnect, treeConnects)
    {
        addTreeConnect(treeConnect);
    }
}

FIBlock *FIBlock::fromNodeGenerated(const QDomElement &domElement, FIBlock *fiBlock)
{
    if(fiBlock==NULL) fiBlock = new FIBlock();

    Block::fromNodeGenerated(domElement, fiBlock);


    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connects") fiBlock->addFlowConnects(FlowConnect::listFromNodeGenerated(e));
            if(e.tagName()=="tree_connects") fiBlock->addTreeConnects(TreeConnect::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return fiBlock;
}

