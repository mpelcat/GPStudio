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

#include "blockscene.h"

#include "blockitem.h"

BlockScene::BlockScene()
{
    _lib = NULL;
}

BlockScene::~BlockScene()
{
}

Lib *BlockScene::lib() const
{
    return _lib;
}

void BlockScene::setLib(Lib *lib)
{
    _lib = lib;
}

bool BlockScene::loadFromNode(const ModelNode *node)
{
    clear();
    if(_lib==NULL) return false;

    foreach (ModelBlock *block, node->blocks())
    {
        if(block->type()=="io")
        {
            IOLib *ioLib = _lib->io(block->driver());
            if(ioLib)
            {
                BlockItem *proc = new BlockItem(ioLib);
                proc->setName(block->name());
                proc->setPos(block->xPos(), block->yPos());
                addItem(proc);
            }
        }
        if(block->type()=="process")
        {
            ProcessLib *processLib = _lib->process(block->driver());
            if(processLib)
            {
                BlockItem *proc = new BlockItem(processLib);
                proc->setName(block->name());
                proc->setPos(block->xPos(), block->yPos());
                addItem(proc);
            }
        }
    }

    return true;
}
