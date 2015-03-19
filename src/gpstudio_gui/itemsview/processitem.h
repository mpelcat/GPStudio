#ifndef PROCESSITEM_H
#define PROCESSITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>
#include <QSvgRenderer>

class ProcessLib;

class GPSTUDIO_GUI_EXPORT ProcessItem : public QGraphicsItem
{
public:
    ProcessItem(ProcessLib *processLib=NULL);
    ~ProcessItem();

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    QString processName() const;
    void setProcessName(const QString &processName);

    QString name() const;
    void setName(const QString &name);

    void update(ProcessLib *processLib);

private:
    QString _processName;
    QString _name;

    QSvgRenderer _svgRenderer;
};

#endif // PROCESSITEM_H
