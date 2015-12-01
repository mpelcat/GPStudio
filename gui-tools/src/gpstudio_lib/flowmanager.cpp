#include "flowmanager.h"

#include <QDebug>

#include "model/fiblock.h"
#include "model/iocom.h"

FlowManager::FlowManager(Node *node)
{
    setNode(node);
}

Node *FlowManager::node() const
{
    return _node;
}

void FlowManager::setNode(Node *node)
{
    _node = node;
    if(node==NULL) return;

    IOCom *blockCom=node->getIOCom();
    FIBlock *fi=node->getFIBlock();

    if(blockCom)
    {
        for(int i=0; i<blockCom->comConnects().size(); i++)
        {
            ComConnect *comConnect=blockCom->comConnects().at(i);
            if(comConnect->type()=="flow")
            {
                FlowConnection *flowConnection = new FlowConnection();
                flowConnection->setFlowId(comConnect->id().toInt());
                flowConnection->setFlow(blockCom->getFlow(comConnect->link()));
                flowConnection->setWrapper(NULL);
                flowConnection->setFlowViewer(NULL);
                addFlowConnection(flowConnection);
                qDebug()<<flowConnection->flow()->name();
            }
        }
    }
}

void FlowManager::addFlowConnection(FlowConnection *flowConnection)
{
    _flowConnectionsID.insert(flowConnection->flowId(), flowConnection);
}

void FlowManager::processFlow(int idFlow)
{
    //qDebug()<<idFlow;
}

