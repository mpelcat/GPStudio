#ifndef MODEL_COMCONNECT_H
#define MODEL_COMCONNECT_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ModelComConnect
{
public:
    ModelComConnect();

    QString link() const;
    void setLink(const QString &link);

    QString id() const;
    void setId(const QString &id);

    QString type() const;
    void setType(const QString &type);

public:
    static ModelComConnect *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelComConnect *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _link;
    QString _id;
    QString _type;
};

#endif // MODEL_COMCONNECT_H
