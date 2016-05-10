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

#include "processlib.h"

#include <QFile>
#include <QSvgRenderer>
#include <QDebug>
#include <QPainter>

ProcessLib::ProcessLib()
{
    _modelProcess = NULL;
}

ProcessLib::~ProcessLib()
{
    delete _modelProcess;
}

const QString &ProcessLib::name() const
{
    return _name;
}

void ProcessLib::setName(const QString &name)
{
    _name = name;
}

const QString &ProcessLib::description() const
{
    return _description;
}

void ProcessLib::setDescription(const QString &description)
{
    _description = description;
}

const QString &ProcessLib::categ() const
{
    return _categ;
}

void ProcessLib::setCateg(const QString &categ)
{
    _categ = categ;
}

const QString &ProcessLib::path() const
{
    return _path;
}

void ProcessLib::setPath(const QString &path)
{
    _path = path;
}

const QString &ProcessLib::configFile() const
{
    return _configFile;
}

void ProcessLib::setConfigFile(const QString &configFile)
{
    _configFile = configFile;
}

const QString &ProcessLib::draw() const
{
    return _draw;
}

void ProcessLib::setDraw(const QString &draw)
{
    _draw = draw;
}

const QIcon &ProcessLib::icon() const
{
    return _icon;
}

void ProcessLib::setIcon(const QIcon &icon)
{
    _icon = icon;
}

ProcessLib *ProcessLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    ProcessLib *processLib = NULL;

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file))
            qDebug()<<"Cannot open"<<file.fileName();
        else
            processLib = ProcessLib::fromDomElement(doc.documentElement());
        file.close();
    }
    return processLib;
}

ProcessLib *ProcessLib::fromDomElement(const QDomElement &domElement)
{
    ProcessLib *processLib = new ProcessLib();
    processLib->setName(domElement.attribute("name","no_name"));
    processLib->setCateg(domElement.attribute("categ",""));
    processLib->setDescription(domElement.attribute("description",""));

    // get svg part of file and save as string
    const QDomNodeList &nodesSvg = domElement.elementsByTagName("svg");
    if(nodesSvg.size()>0)
    {
        QString svg;
        QTextStream streamSvg(&svg);
        streamSvg << nodesSvg.at(0);
        processLib->setDraw(svg);
    }

    // render an 32px icon from svg
    QSvgRenderer render;
    QPixmap pixIcon(32,32);
    QPainter painter(&pixIcon);
    render.load(processLib->draw().toUtf8());
    render.render(&painter, QRectF(0,0,32,32));
    painter.end();
    processLib->_icon.addPixmap(pixIcon);

    // get process model for creating instance of ModelProcess
    processLib->_modelProcess = ModelProcess::fromNodeGenerated(domElement);
    processLib->_modelProcess->setDriver(processLib->_name); // TODO fixe me

    return processLib;
}

ModelProcess *ProcessLib::modelProcess() const
{
    return _modelProcess;
}
