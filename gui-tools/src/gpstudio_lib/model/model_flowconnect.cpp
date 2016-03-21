/****************************************************************************
** Copyright (C) 2014 Dream IP
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

ModelFlowConnect::ModelFlowConnect()
{
}

QString ModelFlowConnect::fromblock() const
{
    return _fromblock;
}

void ModelFlowConnect::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}

QString ModelFlowConnect::fromflow() const
{
    return _fromflow;
}

void ModelFlowConnect::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}

QString ModelFlowConnect::toblock() const
{
    return _toblock;
}

void ModelFlowConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

QString ModelFlowConnect::toflow() const
{
    return _toflow;
}

void ModelFlowConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

QString ModelFlowConnect::order() const
{
    return _order;
}

void ModelFlowConnect::setOrder(const QString &order)
{
    _order = order;
}

ModelFlowConnect *ModelFlowConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ModelFlowConnect *flowConnect=new ModelFlowConnect();

    flowConnect->setFromflow(domElement.attribute("fromblock",""));
    flowConnect->setFromflow(domElement.attribute("fromflow",""));
    flowConnect->setToblock(domElement.attribute("toblock",""));
    flowConnect->setToflow(domElement.attribute("toflow",""));
    flowConnect->setOrder(domElement.attribute("order",""));

    return flowConnect;
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
            if(e.tagName()=="flow_connect") list.append(ModelFlowConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
