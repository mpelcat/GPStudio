#include "flowmanager.h"

#include <QDebug>

FlowManager::FlowManager(ModelNode *node, Property *paramProperties)
{
    _com = NULL;
    _paramProperties = paramProperties;
    setNode(node);
}

ModelNode *FlowManager::node() const
{
    return _node;
}

void FlowManager::setNode(ModelNode *node)
{
    _node = node;
    if(node==NULL) return;

    _blockCom=node->getIOCom();
    _fi=node->getFIBlock();

    if(_blockCom)
    {
        for(int i=0; i<_blockCom->comConnects().size(); i++)
        {
            ModelComConnect *comConnect=_blockCom->comConnects().at(i);
            if(comConnect->type()=="flow")
            {
                FlowConnection *flowConnection = new FlowConnection();
                flowConnection->setFlowId(comConnect->id().toInt());
                flowConnection->setFlow(_blockCom->getFlow(comConnect->link()));
                addFlowConnection(flowConnection);
                //qDebug()<<flowConnection->flow()->name()<<flowConnection->flowId();
            }
        }
    }

    if(_fi)
    {
        foreach(ModelTreeConnect *treeConnect, _fi->treeConnects())
        {
            //qDebug()<<treeConnect->toblock()<<treeConnect->toflow();
            foreach(ModelTreeItem *treeItem, treeConnect->treeitems())
            {
                //qDebug()<<"\t"<<treeItem->fromblock()<<treeItem->fromflow();
            }

            if(treeConnect->treeitems().count()==1) // direct connection
            {
                const Property *propIn = _paramProperties->path(treeConnect->toblock()+"."+treeConnect->toflow());

                ModelTreeItem *treeItem = treeConnect->treeitems()[0];
                const Property *propOut = _paramProperties->path(treeItem->fromblock()+"."+treeItem->fromflow());
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

CameraCom *FlowManager::com() const
{
    return _com;
}

void FlowManager::setCom(CameraCom *com)
{
    _com = com;
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
    int id = _com->inputFlow()[idFlow]->idFlow();
    //qDebug()<<id;
    _flowConnectionsMap[id]->recImg();
}

