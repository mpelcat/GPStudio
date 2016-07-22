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

#include "model_process.h"

#include "lib_parser/lib.h"

#include <QDebug>

ModelProcess::ModelProcess()
{
}

ModelProcess::ModelProcess(const ModelProcess &modelProcess)
    : ModelBlock(modelProcess)
{
}

ModelProcess::~ModelProcess()
{
}

QString ModelProcess::type() const
{
    return "process";
}

ModelProcess *ModelProcess::fromNodeGenerated(const QDomElement &domElement, ModelProcess *process)
{
    if(process==NULL)
        process = new ModelProcess();

    ModelBlock::fromNodeGenerated(domElement, process);

    return process;
}

ModelProcess *ModelProcess::fromNodeDef(const QDomElement &domElement, ModelProcess *process)
{
    bool inLib = (domElement.attribute("inlib","")=="1" || domElement.attribute("inlib","")=="true");
    QString driver = domElement.attribute("driver","");

    if(inLib)
    {
        BlockLib *processLib = Lib::getLib().process(driver);
        if(processLib)
            process = new ModelProcess(*processLib->modelProcess());
    }

    if(process==NULL)
        process = new ModelProcess();
        
    ModelBlock::fromNodeDef(domElement, process);

    return process;
}
