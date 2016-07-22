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

#include "flowmanager.h"

#include <QDebug>

#include "model/model_node.h"
#include "model/model_fiblock.h"
#include "model/model_iocom.h"

#include "flowconnection.h"
#include "camera.h"
#include "cameracom.h"

FlowManager::FlowManager(Camera *camera)
{
    setCamera(camera);
}

Camera *FlowManager::camera() const
{
    return _camera;
}

void FlowManager::setCamera(Camera *camera)
{
    _camera = camera;
    if(camera==NULL)
        return;

    _blockCom=_camera->comBlock();
    ModelIOCom *iOCom = camera->node()->getIOCom();

    foreach (Block *block, camera->blocks())
    {
        foreach (Flow *flow, block->flows())
        {
            foreach (Property *property, flow->assocProperty()->subProperties())
                property->eval();
        }
    }

    if(iOCom)
    {
        for(int i=0; i<iOCom->comConnects().size(); i++)
        {
            ModelComConnect *comConnect=iOCom->comConnects().at(i);
            if(comConnect->type()=="flow")
            {
                FlowConnection *flowConnection = new FlowConnection();
                flowConnection->setFlowId(comConnect->id().toInt());

                ModelFlow *flow = iOCom->getFlow(comConnect->link());
                flowConnection->setFlow(_blockCom->flow(flow->name()));

                addFlowConnection(flowConnection);
            }
        }
    }
}

void FlowManager::addFlowConnection(FlowConnection *flowConnection)
{
    _flowConnectionsMap.insert(flowConnection->flowId(), flowConnection);
    _flowConnections.append(flowConnection);
}

const QMap<int, FlowConnection *> FlowManager::flowConnectionsMap() const
{
    return _flowConnectionsMap;
}

const QList<FlowConnection *> FlowManager::flowConnections() const
{
    return _flowConnections;
}

void FlowManager::processFlow(int idFlow)
{
    if(idFlow>=_camera->com()->inputFlow().count())
        return;

    int id = _camera->com()->inputFlow()[idFlow]->idFlow();
    FlowPackage data = _camera->com()->inputFlow()[idFlow]->getData();
    FlowConnection *flowConnection = _flowConnectionsMap[id];
    flowConnection->recImg(data);
    //qDebug()<<Q_FUNC_INFO<<id<<flowConnection->flow()->name();
}
