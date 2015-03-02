#ifndef PARAM_H
#define PARAM_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QList>
#include <QDomElement>

#include "paramenum.h"
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

    QVariant value() const;
    void setValue(const QVariant &value);

    QVariant defaultValue() const;
    void setDefaultValue(const QVariant &defaultValue);

    QVariant min() const;
    void setMin(const QVariant &min);

    QVariant max() const;
    void setMax(const QVariant &max);

    bool isHard() const;
    void setHard(bool hard);

    QString description() const;
    void setDescription(const QString &description);

    Block *parent() const;
    void setParent(Block *parent);

    bool isDynamicParam() const;

    QList<ParamBitField *> &parambitfields();
    const QList<ParamBitField *> &parambitfields() const;
    void addParamBitField(ParamBitField *parambitfield);

    QList<ParamEnum *> &paramenums();
    const QList<ParamEnum *> &paramenums() const;
    void addParamEnum(ParamEnum *paramenum);

public:
    static Param *fromNodeGenerated(const QDomElement &domElement);

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

    Block *_parent;

    QList<ParamBitField *> _parambitfields;
    QList<ParamEnum *> _paramenums;
};

#endif // PARAM_H
