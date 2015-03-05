#ifndef BLOCKPROPERTYENUM_H
#define BLOCKPROPERTYENUM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT BlockPropertyEnum
{
public:
    BlockPropertyEnum();
    ~BlockPropertyEnum();

    QString name() const;
    void setName(const QString &name);

    QVariant value() const;
    void setValue(const QVariant &value);

    QString description() const;
    void setDescription(const QString &description);

public:
    static BlockPropertyEnum *fromNodeGenerated(const QDomElement &domElement);
    static QList<BlockPropertyEnum *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QVariant _value;
    QString _description;
};

#endif // BLOCKPROPERTYENUM_H
