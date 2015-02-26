#ifndef PARAMBITFIELD_H
#define PARAMBITFIELD_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

#include "paramenum.h"

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

    QList<ParamEnum *> &paramenums();
    const QList<ParamEnum *> &paramenums() const;
    void addParamEnum(ParamEnum *paramenum);

public:
    static ParamBitField *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    QVariant _value;
    QString _bitfield;
    QString _description;
    QList<ParamEnum *> _paramenums;
};

#endif // PARAMBITFIELD_H
