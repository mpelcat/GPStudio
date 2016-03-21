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

#include "model_io.h"

#include <QDebug>

ModelIO::ModelIO()
{
}

ModelIO::~ModelIO()
{
}

QString ModelIO::type() const
{
    return "io";
}

ModelIO *ModelIO::fromNodeGenerated(const QDomElement &domElement, ModelIO *io)
{
    if(io==NULL) io = new ModelIO();

    ModelBlock::fromNodeGenerated(domElement, io);

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ports") io->addPorts(ModelPort::listFromNodeGenerated(e));
            if(e.tagName()=="pins") io->addPins(ModelPin::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return io;
}
