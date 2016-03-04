#ifndef MODEL_BLOCKPROPERTYENUM_H
#define MODEL_BLOCKPROPERTYENUM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ModelPropertyEnum
{
public:
    ModelPropertyEnum();
    ~ModelPropertyEnum();

    QString name() const;
    void setName(const QString &name);

    QVariant value() const;
    void setValue(const QVariant &value);

    QString description() const;
    void setDescription(const QString &description);

public:
    static ModelPropertyEnum *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelPropertyEnum *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QVariant _value;
    QString _description;
};

#endif // MODEL_BLOCKPROPERTYENUM_H
