#include "model_fiblock.h"

#include <QDebug>

ModelFIBlock::ModelFIBlock()
{
}

ModelFIBlock::~ModelFIBlock()
{
}

QString ModelFIBlock::type() const
{
    return "fi";
}

QList<ModelFlowConnect *> ModelFIBlock::flowConnects()
{
    return _flowConnects;
}

const QList<ModelFlowConnect *> ModelFIBlock::flowConnects() const
{
    return _flowConnects;
}

void ModelFIBlock::addFlowConnect(ModelFlowConnect *flowConnect)
{
    _flowConnects.append(flowConnect);
}

void ModelFIBlock::addFlowConnects(const QList<ModelFlowConnect *> &flowConnects)
{
    foreach (ModelFlowConnect *flowConnect, flowConnects)
    {
        addFlowConnect(flowConnect);
    }
}

QList<ModelTreeConnect *> ModelFIBlock::treeConnects()
{
    return _treeConnects;
}

const QList<ModelTreeConnect *> ModelFIBlock::treeConnects() const
{
    return _treeConnects;
}

void ModelFIBlock::addTreeConnect(ModelTreeConnect *treeConnect)
{
    _treeConnects.append(treeConnect);
}

void ModelFIBlock::addTreeConnects(const QList<ModelTreeConnect *> &treeConnects)
{
    foreach (ModelTreeConnect *treeConnect, treeConnects)
    {
        addTreeConnect(treeConnect);
    }
}

ModelFIBlock *ModelFIBlock::fromNodeGenerated(const QDomElement &domElement, ModelFIBlock *fiBlock)
{
    if(fiBlock==NULL) fiBlock = new ModelFIBlock();

    ModelBlock::fromNodeGenerated(domElement, fiBlock);


    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connects") fiBlock->addFlowConnects(ModelFlowConnect::listFromNodeGenerated(e));
            if(e.tagName()=="tree_connects") fiBlock->addTreeConnects(ModelTreeConnect::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return fiBlock;
}

