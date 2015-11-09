#include "processconnectoritem.h"

#include "processitem.h"

#include <QDebug>
#include <QPainter>

ProcessConnectorItem::ProcessConnectorItem(ProcessItem *itemOut, ProcessItem *itemIn)
    : _itemOut(itemOut), _itemIn(itemIn)
{

}

ProcessConnectorItem::~ProcessConnectorItem()
{
}

int ProcessConnectorItem::type() const
{
    return Type;
}

QRectF ProcessConnectorItem::boundingRect() const
{
    if(_itemOut!=NULL && _itemIn!=NULL)
    {
        return QRectF(_itemOut->pos(), _itemIn->pos()).normalized();
    }
    return QRectF();
}

void ProcessConnectorItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    if(_itemOut && _itemIn)
    {
        painter->setPen(QPen(Qt::black, 3));
        painter->drawLine(_itemOut->pos(), _itemIn->pos());
    }
}

