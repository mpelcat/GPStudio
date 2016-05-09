/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "model_fiblock.h"

#include <QDebug>

ModelFIBlock::ModelFIBlock()
{
    _name = "fi";
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
    if(fiBlock==NULL)
        fiBlock = new ModelFIBlock();

    ModelBlock::fromNodeGenerated(domElement, fiBlock);


    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connects")
                fiBlock->addFlowConnects(ModelFlowConnect::listFromNodeGenerated(e));
            if(e.tagName()=="tree_connects")
                fiBlock->addTreeConnects(ModelTreeConnect::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return fiBlock;
}

ModelFIBlock *ModelFIBlock::fromNodeDef(const QDomElement &domElement, ModelFIBlock *fiBlock)
{
    if(fiBlock==NULL)
        fiBlock = new ModelFIBlock();

    ModelBlock::fromNodeGenerated(domElement, fiBlock);

    fiBlock->setName("fi");

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="connects")
                fiBlock->addFlowConnects(ModelFlowConnect::listFromNodeDef(e));
        }
        n = n.nextSibling();
    }

    return fiBlock;
}
