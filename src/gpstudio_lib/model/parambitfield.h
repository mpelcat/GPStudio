#ifndef PARAMBITFIELD_H
#define PARAMBITFIELD_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class Param;

class GPSTUDIO_LIB_EXPORT ParamBitField
{
public:
    ParamBitField();
    ~ParamBitField();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    QVariant value() const;
    void setValue(const QVariant &value);

    QString bitfield() const;
    void setBitfield(const QString &bitfield);

    QString description() const;
    void setDescription(const QString &description);

    QString propertyMap() const;
    void setPropertyMap(const QString &propertyMap);

    Param *parent() const;
    void setParent(Param *parent);

public:
    static ParamBitField *fromNodeGenerated(const QDomElement &domElement);
    static QList<ParamBitField *> listFromNodeGenerated(const QDomElement &domElement);

    static QList<uint> listBitFromBitField(const QString &bitField);

protected:
    QString _name;
    QString _type;
    QVariant _value;
    QString _bitfield;
    QString _description;
    QString _propertyMap;

    Param *_parent;
};

#endif // PARAMBITFIELD_H
