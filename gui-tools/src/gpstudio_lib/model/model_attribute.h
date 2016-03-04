#ifndef MODEL_ATTRIBUTE_H
#define MODEL_ATTRIBUTE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

class ModelAttribute
{
public:
    ModelAttribute();

    QString name() const;
    void setName(const QString &name);

    QString value() const;
    void setValue(const QString &value);

    QString type() const;
    void setType(const QString &type);

public:
    static ModelAttribute *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelAttribute *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _value;
    QString _type;
};

#endif // MODEL_ATTRIBUTE_H
