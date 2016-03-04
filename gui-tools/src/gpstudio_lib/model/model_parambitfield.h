#ifndef MODEL_PARAMBITFIELD_H
#define MODEL_PARAMBITFIELD_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class ModelParam;

class GPSTUDIO_LIB_EXPORT ModelParamBitField
{
public:
    ModelParamBitField();
    ~ModelParamBitField();

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

    ModelParam *parent() const;
    void setParent(ModelParam *parent);

public:
    static ModelParamBitField *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelParamBitField *> listFromNodeGenerated(const QDomElement &domElement);

    static QList<uint> listBitFromBitField(const QString &bitField);

protected:
    QString _name;
    QString _type;
    QVariant _value;
    QString _bitfield;
    QString _description;
    QString _propertyMap;

    ModelParam *_parent;
};

#endif // MODEL_PARAMBITFIELD_H
