#ifndef FLOWCONNECT_H
#define FLOWCONNECT_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ModelFlowConnect
{
public:
    ModelFlowConnect();

    QString fromblock() const;
    void setFromblock(const QString &fromblock);

    QString fromflow() const;
    void setFromflow(const QString &fromflow);

    QString toblock() const;
    void setToblock(const QString &toblock);

    QString toflow() const;
    void setToflow(const QString &toflow);

    QString order() const;
    void setOrder(const QString &order);

public:
    static ModelFlowConnect *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelFlowConnect *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _fromblock;
    QString _fromflow;
    QString _toblock;
    QString _toflow;
    QString _order;
};

#endif // FLOWCONNECT_H
