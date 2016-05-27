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

#include "model_flowconnect.h"

#include "model_fiblock.h"
#include "model_node.h"

ModelFlowConnect::ModelFlowConnect()
{
    _parent = NULL;
    _order = "msb";
}

ModelFlowConnect::~ModelFlowConnect()
{
}

ModelBlock *ModelFlowConnect::fromModelBlock() const
{
    if(!parent())
        return NULL;

    if(!parent()->node())
        return NULL;
    ModelNode *node = parent()->node();
    if(!node)
        return NULL;

    ModelBlock *block = node->getBlock(_fromblock);
    return block;
}

const QString &ModelFlowConnect::fromblock() const
{
    return _fromblock;
}

void ModelFlowConnect::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}

ModelFlow *ModelFlowConnect::fromModelFlow() const
{
    ModelBlock *block = fromModelBlock();
    if(!block)
        return NULL;

    ModelFlow *flow = block->getFlow(_fromflow);
    return flow;
}

const QString &ModelFlowConnect::fromflow() const
{
    return _fromflow;
}

void ModelFlowConnect::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}

ModelBlock *ModelFlowConnect::toModelBlock() const
{
    if(!parent())
        return NULL;

    if(!parent()->node())
        return NULL;
    ModelNode *node = parent()->node();
    if(!node)
        return NULL;

    ModelBlock *block = node->getBlock(_toblock);
    return block;
}

const QString &ModelFlowConnect::toblock() const
{
    return _toblock;
}

void ModelFlowConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

ModelFlow *ModelFlowConnect::toModelFlow() const
{
    ModelBlock *block = toModelBlock();
    if(!block)
        return NULL;

    ModelFlow *flow = block->getFlow(_toflow);
    return flow;
}

const QString &ModelFlowConnect::toflow() const
{
    return _toflow;
}

void ModelFlowConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

const QString &ModelFlowConnect::order() const
{
    return _order;
}

void ModelFlowConnect::setOrder(const QString &order)
{
    _order = order;
}

ModelFlowConnect *ModelFlowConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ModelFlowConnect *flowConnect = new ModelFlowConnect();

    flowConnect->setFromblock(domElement.attribute("fromblock",""));
    flowConnect->setFromflow(domElement.attribute("fromflow",""));
    flowConnect->setToblock(domElement.attribute("toblock",""));
    flowConnect->setToflow(domElement.attribute("toflow",""));
    flowConnect->setOrder(domElement.attribute("order","msb"));

    return flowConnect;
}

ModelFlowConnect *ModelFlowConnect::fromNodeDef(const QDomElement &domElement)
{
    return ModelFlowConnect::fromNodeGenerated(domElement);
}

QList<ModelFlowConnect *> ModelFlowConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelFlowConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connect")
                list.append(ModelFlowConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}

QList<ModelFlowConnect *> ModelFlowConnect::listFromNodeDef(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelFlowConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="connect")
                list.append(ModelFlowConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}

QDomElement ModelFlowConnect::toXMLElement(QDomDocument &doc)
{
    QDomElement element = doc.createElement("connect");

    element.setAttribute("fromblock", _fromblock);
    element.setAttribute("fromflow", _fromflow);
    element.setAttribute("toblock", _toblock);
    element.setAttribute("toflow", _toflow);
    element.setAttribute("order", _order);

    return element;
}

ModelFIBlock *ModelFlowConnect::parent() const
{
    return _parent;
}

void ModelFlowConnect::setParent(ModelFIBlock *parent)
{
    _parent = parent;
}
