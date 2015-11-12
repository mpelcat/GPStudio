#include "flowmanager.h"

#include <QDebug>

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

    Block *blockCom=NULL;
    Block *fi=NULL;
    for(int i=0; i<_node->blocks().size(); i++)
    {
        Block *block=_node->blocks().at(i);
        if(block->categ()=="communication") blockCom=block;
        if(block->type()=="fi") fi=block;
    }

    if(blockCom)
    {
        for(int i=0; i<blockCom->flows().size(); i++)
        {
            Flow *flow=blockCom->flows().at(i);
            if(flow->type()=="in")
            {
                FlowConnection *flowConnection = new FlowConnection();
                flowConnection->setFlowId(i);
                flowConnection->setWrapper(NULL);
                flowConnection->setFlowViewer(NULL);
                addFlowConnection(flowConnection);
            }
        }
    }
}

void FlowManager::addFlowConnection(FlowConnection *flowConnection)
{
    _flowConnectionsID.insert(flowConnection->flowId(), flowConnection);
}

