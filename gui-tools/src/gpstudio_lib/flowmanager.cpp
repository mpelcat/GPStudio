#include "flowmanager.h"

#include <QDebug>

FlowManager::FlowManager(Node *node, Property *paramProperties)
{
    _com = NULL;
    _paramProperties = paramProperties;
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

    _blockCom=node->getIOCom();
    _fi=node->getFIBlock();

    if(_blockCom)
    {
        for(int i=0; i<_blockCom->comConnects().size(); i++)
        {
            ComConnect *comConnect=_blockCom->comConnects().at(i);
            if(comConnect->type()=="flow")
            {
                FlowConnection *flowConnection = new FlowConnection();
                flowConnection->setFlowId(comConnect->id().toInt());
                flowConnection->setFlow(_blockCom->getFlow(comConnect->link()));
                flowConnection->setWrapper(NULL);
                flowConnection->setFlowViewer(NULL);
                addFlowConnection(flowConnection);
                //qDebug()<<flowConnection->flow()->name();
            }
        }
    }

    if(_fi)
    {
        foreach(TreeConnect *treeConnect, _fi->treeConnects())
        {
            //qDebug()<<treeConnect->toblock()<<treeConnect->toflow();
            foreach(TreeItem *treeItem, treeConnect->treeitems())
            {
                //qDebug()<<"\t"<<treeItem->fromblock()<<treeItem->fromflow();
            }

            if(treeConnect->treeitems().count()==1) // direct connection
            {
                Property *propIn = _paramProperties->path(treeConnect->toblock()+"."+treeConnect->toflow());

                TreeItem *treeItem = treeConnect->treeitems()[0];
                Property *propOut = _paramProperties->path(treeItem->fromblock()+"."+treeItem->fromflow());
                //qDebug()<<"rrr "<<propIn->name();

                foreach (Property *subBlockProperty, propOut->subProperties().properties())
                {
                    //qDebug()<<subBlockProperty->name();
                    //propIn->addSubProperty(subBlockProperty);
                }
            }
        }
    }
}

void FlowManager::addFlowConnection(FlowConnection *flowConnection)
{
    _flowConnectionsID.insert(flowConnection->flowId(), flowConnection);
}

CameraCom *FlowManager::com() const
{
    return _com;
}

void FlowManager::setCom(CameraCom *com)
{
    _com = com;
}

const QMap<int, FlowConnection *> FlowManager::flowConnectionsID() const
{
    return _flowConnectionsID;
}

void FlowManager::processFlow(int idFlow)
{
    int id = _com->inputFlow()[idFlow]->idFlow();
    //qDebug()<<id;
    _flowConnectionsID[id]->recImg();
}

