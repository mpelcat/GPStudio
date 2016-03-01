#include "model_flowconnect.h"

ModelFlowConnect::ModelFlowConnect()
{
}

QString ModelFlowConnect::fromblock() const
{
    return _fromblock;
}

void ModelFlowConnect::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}

QString ModelFlowConnect::fromflow() const
{
    return _fromflow;
}

void ModelFlowConnect::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}

QString ModelFlowConnect::toblock() const
{
    return _toblock;
}

void ModelFlowConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

QString ModelFlowConnect::toflow() const
{
    return _toflow;
}

void ModelFlowConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

QString ModelFlowConnect::order() const
{
    return _order;
}

void ModelFlowConnect::setOrder(const QString &order)
{
    _order = order;
}

ModelFlowConnect *ModelFlowConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ModelFlowConnect *flowConnect=new ModelFlowConnect();

    flowConnect->setFromflow(domElement.attribute("fromblock",""));
    flowConnect->setFromflow(domElement.attribute("fromflow",""));
    flowConnect->setToblock(domElement.attribute("toblock",""));
    flowConnect->setToflow(domElement.attribute("toflow",""));
    flowConnect->setOrder(domElement.attribute("order",""));

    return flowConnect;
}

QList<ModelFlowConnect *> ModelFlowConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelFlowConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connect") list.append(ModelFlowConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
