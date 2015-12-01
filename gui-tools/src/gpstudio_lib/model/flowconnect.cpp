#include "flowconnect.h"

FlowConnect::FlowConnect()
{
}

QString FlowConnect::fromblock() const
{
    return _fromblock;
}

void FlowConnect::setFromblock(const QString &fromblock)
{
    _fromblock = fromblock;
}

QString FlowConnect::fromflow() const
{
    return _fromflow;
}

void FlowConnect::setFromflow(const QString &fromflow)
{
    _fromflow = fromflow;
}

QString FlowConnect::toblock() const
{
    return _toblock;
}

void FlowConnect::setToblock(const QString &toblock)
{
    _toblock = toblock;
}

QString FlowConnect::toflow() const
{
    return _toflow;
}

void FlowConnect::setToflow(const QString &toflow)
{
    _toflow = toflow;
}

QString FlowConnect::order() const
{
    return _order;
}

void FlowConnect::setOrder(const QString &order)
{
    _order = order;
}

FlowConnect *FlowConnect::fromNodeGenerated(const QDomElement &domElement)
{
    FlowConnect *flowConnect=new FlowConnect();

    flowConnect->setFromflow(domElement.attribute("fromblock",""));
    flowConnect->setFromflow(domElement.attribute("fromflow",""));
    flowConnect->setToblock(domElement.attribute("toblock",""));
    flowConnect->setToflow(domElement.attribute("toflow",""));
    flowConnect->setOrder(domElement.attribute("order",""));

    return flowConnect;
}

QList<FlowConnect *> FlowConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<FlowConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow_connect") list.append(FlowConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
