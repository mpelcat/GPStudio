#ifndef PROCESSCONNECTORITEM_H
#define PROCESSCONNECTORITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>

class ProcessItem;

class GPSTUDIO_GUI_EXPORT ProcessConnectorItem : public QGraphicsItem
{
public:
    ProcessConnectorItem(ProcessItem *itemOut, ProcessItem *itemIn);
    ~ProcessConnectorItem();

    enum { Type = UserType + 2 };
    int type() const;

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

private:
    ProcessItem *_itemOut;
    ProcessItem *_itemIn;
};

#endif // PROCESSCONNECTORITEM_H
