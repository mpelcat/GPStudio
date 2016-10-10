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

#include "confignodedialog.h"
#include "gpnodeproject.h"

#include <QDebug>
#include <QFileInfo>
#include <QFileDialog>
#include <QMessageBox>
#include <QInputDialog>

#include "undostack/nodecommands.h"
#include "undostack/blockcommands.h"

#include <model/model_fiblock.h>

#include "lib_parser/lib.h"

GPNodeProject::GPNodeProject(QObject *parent)
    : QObject(parent)
{
    _nodeEditorWindow = NULL;
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
        fileName = QFileDialog::getOpenFileName(_nodeEditorWindow, "Open node project", "", "Node project (*.node)");
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
        QFileDialog fileDialog(_nodeEditorWindow);
        fileDialog.setAcceptMode(QFileDialog::AcceptSave);
        fileDialog.setDefaultSuffix(".node");
        fileDialog.setNameFilter("Node project (*.node)");
        fileDialog.setWindowTitle("Save node project");
        if (fileDialog.exec())
            fileName = fileDialog.selectedFiles().first();
        if(fileName.isEmpty())
            return false;
    }
    else
        fileName = nodeFileName;

    if(!fileName.endsWith(".node"))
        fileName.append(".node");
    setPath(fileName);

    _node->saveToFile(_path);
    setModified(false);
    return true;
}

void GPNodeProject::closeProject()
{
    if(_modified)
    {
        if(QMessageBox::question(_nodeEditorWindow, "Project modified", "Would you like to save the project before close it ?", QMessageBox::Save | QMessageBox::Cancel)==QMessageBox::Save)
            saveProject();
    }

    _modified = false;
    _undoStack->clear();
    setNode(NULL);
    delete _node;
}

void GPNodeProject::configBoard()
{
    ConfigNodeDialog configNodeDialog(_nodeEditorWindow);
    configNodeDialog.setProject(this);
    if(configNodeDialog.exec() == QDialog::Accepted)
    {
        QString boardName;
        if(_node->board())
            boardName = _node->board()->name();

        _undoStack->push(new NodeCmdConfigBoard(this,
                         boardName, _node->iosList(),
                         configNodeDialog.boardName(), configNodeDialog.iosName()));
    }
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

QWidget *GPNodeProject::nodeEditorWindow() const
{
    return _nodeEditorWindow;
}

void GPNodeProject::setNodeEditorWindow(QWidget *nodeEditorWindow)
{
    _nodeEditorWindow = nodeEditorWindow;
}

void GPNodeProject::cmdRenameBlock(const QString &block_name, const QString &newName)
{
    ModelBlock *block = _node->getBlock(block_name);
    if(!block)
        return;

    // rename connection to this block
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }
    foreach (ModelFlowConnect *flowConnect, fiBlock->flowConnects())
    {
        if(flowConnect->fromblock()==block_name)
            flowConnect->setFromblock(newName);
        if(flowConnect->toblock()==block_name)
            flowConnect->setToblock(newName);
    }

    block->setName(newName);
    emit blockUpdated(block);
    setModified(true);
}

void GPNodeProject::cmdMoveBlockTo(const QString &block_name, const QString &part_name, QPoint pos)
{
    ModelBlock *block = _node->getBlock(block_name);
    if(block)
    {
        ModelComponentPart *part = block->getPart(part_name);
        if(part)
        {
            part->setPos(pos);
            emit blockUpdated(block);
            setModified(true);
        }
    }
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

void GPNodeProject::cmdRemoveBlock(const QString &block_name)
{
    ModelFIBlock *fiBlock = _node->getFIBlock();
    if(!fiBlock)
    {
        fiBlock = new ModelFIBlock();
        _node->addBlock(fiBlock);
    }

    foreach (ModelFlowConnect *flowConnect, fiBlock->flowConnects(block_name))
    {
        cmdDisconnectFlow(*flowConnect);
    }

    ModelBlock *block = _node->getBlock(block_name);
    _node->removeBlock(block);
    emit blockRemoved(block_name);
    setModified(true);
    if(block)
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

void GPNodeProject::cmdRenameNode(QString nodeName)
{
    _node->setName(nodeName);
}

void GPNodeProject::cmdConfigBoard(QString boardName, QStringList iosName)
{
    int count = 0;
    foreach (QString ioName, _node->iosList())
    {
        count++;
        if(!iosName.contains(ioName))
            cmdRemoveBlock(ioName);
    }

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
                count++;
                ModelIO *io = new ModelIO(*ioLib->modelIO());
                io->setName(ioName);
                int count2=0;
                foreach (ModelComponentPart *part, io->parts())
                    part->setPos(QPoint(count*200, (count2++)*200));
                cmdAddBlock(io);
            }
        }
    }
}

void GPNodeProject::cmdSetParam(const QString &blockName, const QString &paramName, const QVariant &value)
{
    ModelBlock *block = _node->getBlock(blockName);
    if(!block)
        return;

    ModelParam *param = block->getParam(paramName);
    if(!param)
        return;

    // set value of param
    param->setValue(value);

    //emit blockUpdated(block);
    setModified(true);
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

void GPNodeProject::moveBlock(const QString &block_name, const QString &part_name, const QPoint &oldPos, const QPoint &newPos)
{
    _undoStack->push(new BlockCmdMove(this, block_name, part_name, oldPos, newPos));
}

void GPNodeProject::renameBlock(const QString &block_name, const QString &newName)
{
    QString name = newName;
    QRegExp nameChecker("^[a-zA-Z][a-zA-Z0-9_]*$");

    if(name.isEmpty())
        name = QInputDialog::getText(_nodeEditorWindow, "Enter a new name for this block", "New name", QLineEdit::Normal, block_name);

    if(block_name == name)
        return;
    ModelBlock *block = _node->getBlock(name);
    while(block != NULL || nameChecker.indexIn(name)==-1)
    {
        if(block != NULL)
        {
            name = QInputDialog::getText(_nodeEditorWindow, "Enter a new name for this block", "This name already exists, try another name", QLineEdit::Normal, name + "_1");
            if(name.isEmpty())
                return;
        }
        else
        {
            name = QInputDialog::getText(_nodeEditorWindow, "Enter a new name for this block", "Invalid name, try another name", QLineEdit::Normal, name.replace(QRegExp("\\W"),""));
            if(name.isEmpty())
                return;
        }
        block = _node->getBlock(name);
    }

    if(!name.isEmpty())
        _undoStack->push(new BlockCmdRename(this, block_name, name));
}

void GPNodeProject::addBlock(ModelBlock *block)
{
    if(block->name().isEmpty() || block->name()==block->driver())
    {
        int i = 1;
        QString name = QString("%1_%2").arg(block->driver()).arg(i);
        while(_node->getBlock(name)!=NULL)
            name = QString("%1_%2").arg(block->driver()).arg(++i);
        block->setName(name);
    }
    _undoStack->push(new BlockCmdAdd(this, block));
}

void GPNodeProject::addBlock(const QString &driver, const QPoint &pos)
{
    BlockLib *processLib = Lib::getLib().process(driver);
    if(!processLib)
        return;

    ModelProcess *modelProcess = new ModelProcess(*processLib->modelProcess());
    foreach (ModelComponentPart *part, modelProcess->parts())
        part->setPos(pos);
    addBlock(modelProcess);
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

void GPNodeProject::beginMacro(const QString &text)
{
    _undoStack->beginMacro(text);
}

void GPNodeProject::endMacro()
{
    _undoStack->endMacro();
}
