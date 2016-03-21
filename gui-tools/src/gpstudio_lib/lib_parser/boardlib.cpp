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

#include "boardlib.h"

#include <QFile>
#include <QDebug>

BoardLib::BoardLib()
{
}
QString BoardLib::name() const
{
    return _name;
}

void BoardLib::setName(const QString &name)
{
    _name = name;
}

QList<IOBoardLib *> &BoardLib::ios()
{
    return _ios;
}

const QList<IOBoardLib *> &BoardLib::ios() const
{
    return _ios;
}

void BoardLib::addIO(IOBoardLib *io)
{
    _ios.append(io);
    _iosMap.insert(io->name(), io);
    if(_iosGroups.contains(io->group()))
    {
        _iosGroups[io->group()].addIos(io->name());
    }
    else
    {
        _iosGroups.insert(io->group(), IOLibGroup(io->type()));
        _iosGroups[io->group()].addIos(io->name());
    }
}

void BoardLib::addIOs(const QList<IOBoardLib *> &ios)
{
    foreach (IOBoardLib *io, ios)
    {
        addIO(io);
    }
}

IOBoardLib *BoardLib::io(const QString &name) const
{
    if(_iosMap.contains(name)) return _iosMap[name];
    return NULL;
}

BoardLib *BoardLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return BoardLib::fromNodeGenerated(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

BoardLib *BoardLib::fromNodeGenerated(const QDomElement &domElement)
{
    BoardLib *board=new BoardLib();
    board->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ios") board->addIOs(IOBoardLib::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return board;
}

const QMap<QString, IOLibGroup> &BoardLib::iosGroups() const
{
    return _iosGroups;
}
