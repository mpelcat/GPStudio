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

GPNodeProject::GPNodeProject(QObject *parent)
    : QObject(parent)
{
    _node = NULL;
}

GPNodeProject::~GPNodeProject()
{
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
    setNode(new ModelNode());
    setModified(false);
}

bool GPNodeProject::openProject(const QString &nodeFileName)
{
    ModelNode *node;
    QString fileName;

    if(nodeFileName.isEmpty())
    {
        fileName = QFileDialog::getOpenFileName(0, "Open node project", "", "Node project (*.node)");
        if(fileName.isEmpty())
            return false;
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

    setPath(fileName);
    setModified(false);
    setNode(node);

    return true;
}

bool GPNodeProject::saveProject()
{
    setModified(false);
    return true;
}

bool GPNodeProject::saveProjectAs(const QString &nodeFileName)
{
    setModified(false);
    return true;
}

void GPNodeProject::closeProject()
{
    if(_modified)
    {
        saveProject();
    }

    delete _node;
}

void GPNodeProject::setPath(const QString &path)
{
    _path = path;
    emit nodePathChanged(_path);
}

void GPNodeProject::setModified(bool modified)
{
    _modified = modified;
    emit nodeModified(_modified);
}

void GPNodeProject::setNode(ModelNode *node)
{
    _node = node;
    emit nodeChanged();
}
