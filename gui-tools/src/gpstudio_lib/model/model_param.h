#ifndef MODEL_PARAM_H
#define MODEL_PARAM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QList>
#include <QDomElement>

#include "model_parambitfield.h"

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelParam
{
public:
    ModelParam(ModelBlock *parent=NULL);
    ~ModelParam();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    qint32 regAddr() const;
    void setRegAddr(const qint32 &regAddr);
    qint32 absoluteAddr() const;

    const QVariant &value() const;
    void setValue(const QVariant &value);

    QVariant defaultValue() const;
    void setDefaultValue(const QVariant &defaultValue);

    const QVariant &min() const;
    void setMin(const QVariant &min);

    const QVariant &max() const;
    void setMax(const QVariant &max);

    bool isHard() const;
    void setHard(bool hard);

    QString propertyMap() const;
    void setPropertyMap(const QString &propertyMap);

    QString description() const;
    void setDescription(const QString &description);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

    bool isDynamicParam() const;

    QList<ModelParamBitField *> &paramBitFields();
    const QList<ModelParamBitField *> &paramBitFields() const;
    void addParamBitField(ModelParamBitField *bitField);
    void addParamBitFields(const QList<ModelParamBitField *> &bitFields);

public:
    static ModelParam *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelParam *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    qint32 _regAddr;
    QVariant _value;
    QVariant _defaultValue;
    QVariant _min;
    QVariant _max;
    bool _hard;
    QString _description;
    QString _propertyMap;

    ModelBlock *_parent;

    QList<ModelParamBitField *> _parambitfields;
};

#endif // MODEL_PARAM_H
