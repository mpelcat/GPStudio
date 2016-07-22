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

#include "gpnodeproject.h"

#include <QDebug>
#include <QFileInfo>
#include <QFileDialog>
#include <QMessageBox>

#include "undostack/blockcommands.h"

#include <model/model_fiblock.h>

#include "lib_parser/lib.h"

GPNodeProject::GPNodeProject(QObject *parent)
    : QObject(parent)
{
    _node = NULL;
    _modified = false;
    _undoStack = new QUndoStack();
}

GPNodeProject::~GPNodeProject()
{
    delete _undoStack;
    delete _node;
}

QString GPNodeProject::name() const
{
    if(_path.isEmpty())
        return QString("new node");
    else
        return QFileInfo(_path).baseName();
}

QString GPNodeProject::path() const
{
    return _path;
}

bool GPNodeProject::isModified() const
{
    return _modified;
}

ModelNode *GPNodeProject::node() const
{
    return _node;
}

void GPNodeProject::newProject()
{
    closeProject();

    setPath("");
    setNode(new ModelNode("new_project"));
    setModified(false);
}

bool GPNodeProject::openProject(const QString &nodeFileName)
{
    ModelNode *node;
    QString fileName;

    closeProject();

    if(nodeFileName.isEmpty())
    {
        fileName = QFileDialog::getOpenFileName(0, "Open node project", "", "Node project (*.node)");
        if(fileName.isEmpty())
        {
            newProject();
            return false;
        }
    }
    else
        fileName = nodeFileName;

    if(!QFile::exists(fileName))
    {
        qDebug()<<"Cannot find file "<<fileName;
        return false;
    }

    node = ModelNode::readFromFile(fileName);
    if(!node)
        return false;

    // load library with project IPs
    foreach (ModelBlock *block, node->blocks())
    {
        if(block->driver().endsWith(".proc") || block->driver().endsWith(".io"))
        {
            Lib::getLib().addIp(block->path() + "/" + block->driver());
        }
    }

    setPath(fileName);
    setModified(false);
    setNode(node);

    return true;
}

bool GPNodeProject::saveProject()
{
    return saveProjectAs(_path);
}

bool GPNodeProject::saveProjectAs(const QString &nodeFileName)
{
    QString fileName;

    if(nodeFileName.isEmpty())
    {
        fileName = QFileDialog::getSaveFileName(0, "Save node project", "", "Node project (*.node)");
        if(fileName.isEmpty())
            return false;
    }
    else
        fileName = nodeFileName;

    setPath(fileName);

    _node->saveToFile(_path);
    setModified(false);
    return true;
}

void GPNodeProject::closeProject()
{
    if(_modified)
    {
        if(QMessageBox::question(0, "Project modified", "Would you like to save the project before close it ?", QMessageBox::Save | QMessageBox::Cancel)==QMessageBox::Save)
            saveProject();
    }

    _modified = false;
    _undoStack->clear();
    setNode(NULL);
    delete _node;
}

void GPNodeProject::setBoard(QString boardName, QStringList iosName)
{
    cmdSetBoard(boardName, iosName);
}

void GPNodeProject::setPath(const QString &path)
{
    _path = path;
    if(_node)
        _node->setName(name());
    emit nodePathChanged(_path);
}

void GPNodeProject::setModified(bool modified)
{
    _modified = modified;
    emit nodeModified(_modified);
}

void GPNodeProject::cmdRenameBlock(ModelBlock *block, const QString &name)
{
    block->setName(name);
    emit blockUpdated(block);
}

void GPNodeProject::cmdMoveBlockTo(ModelBlock *block, QPoint pos)
{
    block->setPos(pos);
    emit blockUpdated(block);
    setModified(true);
}

void GPNodeProject::cmdAddBlock(ModelBlock *block)
{
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }

    _node->addBlock(block);
    emit blockAdded(block);
    setModified(true);
}

void GPNodeProject::cmdRemoveBlock(ModelBlock *block)
{
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }

    foreach (ModelFlowConnect *flowConnect, fiBlock->flowConnects(block->name()))
    {
        cmdDisconnectFlow(*flowConnect);
    }

    _node->removeBlock(block);
    emit blockRemoved(block);
    setModified(true);
    delete block;
}

void GPNodeProject::cmdConnectFlow(const ModelFlowConnect &flowConnect)
{
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }

    fiBlock->connectFlow(flowConnect);
    emit blockConnected(flowConnect);
    setModified(true);
}

void GPNodeProject::cmdDisconnectFlow(const ModelFlowConnect &flowConnect)
{
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }

    fiBlock->disConnectFlow(flowConnect);
    emit blockDisconected(flowConnect);
    setModified(true);
}

void GPNodeProject::cmdSetBoard(QString boardName, QStringList iosName)
{
    BoardLib *boardLib = Lib::getLib().board(boardName);
    if(!boardLib)
        return;

    ModelBoard *board = new ModelBoard(*boardLib->modelBoard());
    _node->setBoard(board);

    foreach (QString ioName, iosName)
    {
        if(_node->getBlock(ioName) == NULL)
        {
            QString ioDriver = boardLib->io(ioName)->driver();
            BlockLib *ioLib = Lib::getLib().io(ioDriver);
            if(ioLib)
            {
                ModelIO *io = ioLib->modelIO();
                io->setName(ioName);
                cmdAddBlock(io);
            }
        }
    }
}

QUndoStack *GPNodeProject::undoStack() const
{
    return _undoStack;
}

void GPNodeProject::setNode(ModelNode *node)
{
    _node = node;
    emit nodeChanged(_node);
}

void GPNodeProject::moveBlock(ModelBlock *block, const QPoint &newPos)
{
    _undoStack->push(new BlockCmdMove(this, block, block->pos(), newPos));
}

void GPNodeProject::renameBlock(ModelBlock *block, const QString &newName)
{
    _undoStack->push(new BlockCmdRename(this, block, block->name(), newName));
}

void GPNodeProject::addBlock(ModelBlock *block)
{
    if(block->name().isEmpty())
        block->setName(QString("%1_%2").arg(block->driver()).arg(_node->blocks().count()));
    if(block->name()==block->driver())
        block->setName(QString("%1_%2").arg(block->driver()).arg(_node->blocks().count()));
    _undoStack->push(new BlockCmdAdd(this, block));
}

void GPNodeProject::removeBlock(ModelBlock *block)
{
    _undoStack->push(new BlockCmdRemove(this, block));
}

void GPNodeProject::connectBlockFlows(const ModelFlowConnect &flowConnect)
{
    _undoStack->push(new BlockCmdConnectFlow(this, flowConnect));
}

void GPNodeProject::disConnectBlockFlows(const ModelFlowConnect &flowConnect)
{
    _undoStack->push(new BlockCmdDisconnectFlow(this, flowConnect));
}
