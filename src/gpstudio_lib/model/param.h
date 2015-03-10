#ifndef PARAM_H
#define PARAM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QList>
#include <QDomElement>

#include "parambitfield.h"

class Block;

class GPSTUDIO_LIB_EXPORT Param
{
public:
    Param(Block *parent=NULL);
    ~Param();

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

    Block *parent() const;
    void setParent(Block *parent);

    bool isDynamicParam() const;

    QList<ParamBitField *> &paramBitFields();
    const QList<ParamBitField *> &paramBitFields() const;
    void addParamBitField(ParamBitField *bitField);
    void addParamBitFields(const QList<ParamBitField *> &bitFields);

public:
    static Param *fromNodeGenerated(const QDomElement &domElement);
    static QList<Param *> listFromNodeGenerated(const QDomElement &domElement);

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

    Block *_parent;

    QList<ParamBitField *> _parambitfields;
};

#endif // PARAM_H
