#ifndef COMCONNECT_H
#define COMCONNECT_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ComConnect
{
public:
    ComConnect();

    QString link() const;
    void setLink(const QString &link);

    QString id() const;
    void setId(const QString &id);

    QString type() const;
    void setType(const QString &type);

public:
    static ComConnect *fromNodeGenerated(const QDomElement &domElement);
    static QList<ComConnect *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _link;
    QString _id;
    QString _type;
};

#endif // COMCONNECT_H
