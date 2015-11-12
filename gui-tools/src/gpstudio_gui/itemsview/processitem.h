#ifndef PROCESSITEM_H
#define PROCESSITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>
#include <QSvgRenderer>

class ProcessLib;
class IOLib;

class ProcessConnectorItem;

class GPSTUDIO_GUI_EXPORT ProcessItem : public QGraphicsItem
{
public:
    ProcessItem(ProcessLib *processLib=NULL);
    ProcessItem(IOLib *ioLib=NULL);
    ~ProcessItem();

    enum { Type = UserType + 1 };
    int type() const;

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    QString processName() const;
    void setProcessName(const QString &processName);

    QString name() const;
    void setName(const QString &name);

    void update(ProcessLib *processLib);
    void update(IOLib *ioLib);

    void addConnect(ProcessConnectorItem *connectItem);

protected:
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);

private:
    QString _processName;
    QString _name;

    QRectF _boundingRect;
    QSvgRenderer _svgRenderer;

    QList<ProcessConnectorItem *> _connects;
};

#endif // PROCESSITEM_H
