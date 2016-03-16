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
    if(camera==NULL) return;

    _blockCom=_camera->comBlock();
    ModelIOCom *iOCom = camera->node()->getIOCom();

    foreach (Block *block, camera->blocks())
    {
        foreach (Flow *flow, block->flows())
        {
            foreach (Property *property, flow->assocProperty()->subProperties())
            {
                property->eval();
            }
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
                //qDebug()<<flowConnection->flow()->name()<<flowConnection->flowId();
            }
        }
    }

    _fi=_camera->fiBlock();
    ModelFIBlock *fIBlock = camera->node()->getFIBlock();

    if(fIBlock)
    {
        foreach(ModelTreeConnect *treeConnect, fIBlock->treeConnects())
        {
            //qDebug()<<treeConnect->toblock()<<treeConnect->toflow();
            foreach(ModelTreeItem *treeItem, treeConnect->treeitems())
            {
                //qDebug()<<"\t"<<treeItem->fromblock()<<treeItem->fromflow();
            }

            if(treeConnect->treeitems().count()==1) // direct connection
            {
                const Property *propIn = _camera->rootProperty().path(treeConnect->toblock()+"."+treeConnect->toflow());

                ModelTreeItem *treeItem = treeConnect->treeitems()[0];
                const Property *propOut = _camera->rootProperty().path(treeItem->fromblock()+"."+treeItem->fromflow());
                //qDebug()<<"rrr "<<propOut->parent()->name()<<propOut->name()<<propIn->parent()->name()<<propIn->name();

                foreach (Property *subBlockProperty, propOut->subProperties())
                {
                    //qDebug()<<subBlockProperty->parent()->name()<<subBlockProperty->name();
                    //propIn->addSubProperty(subBlockProperty);
                }
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
    if(idFlow>=_camera->com()->inputFlow().count()) return;

    int id = _camera->com()->inputFlow()[idFlow]->idFlow();
    FlowPackage data = _camera->com()->inputFlow()[idFlow]->getData();
    FlowConnection *flowConnection = _flowConnectionsMap[id];
    flowConnection->recImg(data);
    qDebug()<<Q_FUNC_INFO<<id<<flowConnection->flow()->name();
}
