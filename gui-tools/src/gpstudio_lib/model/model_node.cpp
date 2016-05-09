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

#include "model_node.h"

#include <QFile>
#include <QFileInfo>
#include <QDebug>

#include "model_ciblock.h"
#include "model_fiblock.h"
#include "model_piblock.h"

ModelNode::ModelNode()
{
    _valid = false;
    _board = NULL;
}

ModelNode::~ModelNode()
{
    for(int i=0; i<_blocks.size(); i++)
        delete _blocks[i];
}

QString ModelNode::name() const
{
    return _name;
}

void ModelNode::setName(const QString &name)
{
    _name = name;
}

bool ModelNode::isValid() const
{
    return _valid;
}

QList<ModelBlock *> &ModelNode::blocks()
{
    return _blocks;
}

const QList<ModelBlock *> &ModelNode::blocks() const
{
    return _blocks;
}

void ModelNode::addBlock(ModelBlock *block)
{
    _blocks.append(block);
}

ModelFIBlock *ModelNode::getFIBlock() const
{
    for(int i=0; i<this->blocks().size(); i++)
    {
        ModelBlock *block = this->blocks().at(i);
        if(block->type()=="fi")
            return (ModelFIBlock*)block;
    }
    return NULL;
}

ModelCIBlock *ModelNode::getCIBlock() const
{
    for(int i=0; i<this->blocks().size(); i++)
    {
        ModelBlock *block = this->blocks().at(i);
        if(block->type()=="ci")
            return (ModelCIBlock*)block;
    }
    return NULL;
}

ModelPIBlock *ModelNode::getPIBlock() const
{
    for(int i=0; i<this->blocks().size(); i++)
    {
        ModelBlock *block = this->blocks().at(i);
        if(block->type()=="pi")
            return (ModelPIBlock*)block;
    }
    return NULL;
}

ModelIOCom *ModelNode::getIOCom() const
{
    for(int i=0; i<this->blocks().size(); i++)
    {
        ModelBlock *block = this->blocks().at(i);
        if(block->type()=="iocom")
            return (ModelIOCom*)block;
    }
    return NULL;
}

ModelNode *ModelNode::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    ModelNode *node;
    QFile file(fileName);

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file))
        {
            qDebug()<<"Cannot parse"<<file.fileName();
            return NULL;
        }
        if(!doc.documentElement().firstChildElement("blocks").isNull())
            node = ModelNode::fromNodeGenerated(doc.documentElement());
        else
            node = ModelNode::fromNodeDef(doc.documentElement());
        file.close();
        return node;
    }
    return NULL;
}

ModelNode *ModelNode::fromNodeGenerated(const QDomElement &domElement)
{
    ModelNode *node = new ModelNode();
    node->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="board")
            {
                if(node->_board==NULL)
                    node->_board = ModelBoard::fromNodeGenerated(e);
            }
            if(e.tagName()=="blocks")
                node->_blocks.append(ModelBlock::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    node->_valid=true;
    return node;
}

ModelNode *ModelNode::fromNodeDef(const QDomElement &domElement)
{
    ModelNode *node = new ModelNode();
    node->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="board")
            {
                if(node->_board==NULL)
                {
                    node->_board = ModelBoard::fromNodeDef(e);
                    node->_blocks.append(ModelBoard::listIosFromNodeDef(e));
                }
            }
            if(e.tagName()=="process")
                node->_blocks.append(ModelBlock::listFromNodeDef(e));
            if(e.tagName()=="flow_interconnect")
                node->_blocks.append(ModelFIBlock::fromNodeDef(e));
        }
        n = n.nextSibling();
    }

    node->_valid=true;
    return node;
}

ModelBoard *ModelNode::getBoard() const
{
    return _board;
}
