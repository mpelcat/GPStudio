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

#include "iolib.h"

#include <QFile>
#include <QSvgRenderer>
#include <QDebug>
#include <QPainter>

IOLib::IOLib()
{
    _modelIO = NULL;
}

IOLib::~IOLib()
{
}

const QString &IOLib::name() const
{
    return _name;
}

void IOLib::setName(const QString &name)
{
    _name = name;
}

const QString &IOLib::description() const
{
    return _description;
}

void IOLib::setDescription(const QString &description)
{
    _description = description;
}

const QString &IOLib::categ() const
{
    return _categ;
}

void IOLib::setCateg(const QString &categ)
{
    _categ = categ;
}

const QString &IOLib::path() const
{
    return _path;
}

void IOLib::setPath(const QString &path)
{
    _path = path;
}

const QString &IOLib::configFile() const
{
    return _configFile;
}

void IOLib::setConfigFile(const QString &configFile)
{
    _configFile = configFile;
}

const QString &IOLib::draw() const
{
    return _draw;
}

void IOLib::setDraw(const QString &draw)
{
    _draw = draw;
}

const QIcon &IOLib::icon() const
{
    return _icon;
}

void IOLib::setIcon(const QIcon &icon)
{
    _icon = icon;
}

IOLib *IOLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    IOLib *ioLib = NULL;

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file))
            qDebug()<<"Cannot open"<<file.fileName();
        else
            ioLib = IOLib::fromDomElement(doc.documentElement());
        file.close();
    }
    return ioLib;
}

IOLib *IOLib::fromDomElement(const QDomElement &domElement)
{
    IOLib *ioLib = new IOLib();
    ioLib->setName(domElement.attribute("driver","no_name"));
    ioLib->setCateg(domElement.attribute("categ",""));
    ioLib->setDescription(domElement.attribute("description",""));

    // icon
    const QDomNodeList &nodesSvg = domElement.elementsByTagName("svg");
    if(nodesSvg.size()>0)
    {
        QString svg;
        QTextStream streamSvg(&svg);
        streamSvg << nodesSvg.at(0);
        ioLib->setDraw(svg);
    }

    QSvgRenderer render;
    QPixmap pixIcon(32,32);
    QPainter painter(&pixIcon);
    render.load(ioLib->draw().toUtf8());
    render.render(&painter, QRectF(0,0,32,32));
    painter.end();
    ioLib->_icon.addPixmap(pixIcon);

    return ioLib;
}

ModelIO *IOLib::modelIO() const
{
    return _modelIO;
}
