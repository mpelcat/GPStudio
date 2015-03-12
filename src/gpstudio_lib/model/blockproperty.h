#ifndef BLOCKPROPERTY_H
#define BLOCKPROPERTY_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class Block;

#include "blockpropertyenum.h"

class GPSTUDIO_LIB_EXPORT BlockProperty
{
public:
    BlockProperty();
    ~BlockProperty();

    QString name() const;
    void setName(const QString &name);

    QString caption() const;
    void setCaption(const QString &caption);

    QString type() const;
    void setType(const QString &type);

    QString value() const;
    void setValue(const QString &value);

    QString min() const;
    void setMin(const QString &min);

    QString max() const;
    void setMax(const QString &max);

    QString step() const;
    void setStep(const QString &step);

    QString assert() const;
    void setAssert(const QString &assert);

    QString description() const;
    void setDescription(const QString &description);

    Block *parent() const;
    void setParent(Block *parent);

    QList<BlockProperty *> &properties();
    const QList<BlockProperty *> &properties() const;
    void addProperty(BlockProperty *propertyEnum);

    QList<BlockPropertyEnum *> &propertyEnums();
    const QList<BlockPropertyEnum *> &propertyEnums() const;
    void addPropertyEnum(BlockPropertyEnum *propertyEnum);

public:
    static BlockProperty *fromNodeGenerated(const QDomElement &domElement);
    static QList<BlockProperty *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _caption;
    QString _type;
    QString _value;
    QString _min;
    QString _max;
    QString _step;
    QString _assert;
    QString _description;

    Block *_parent;

    QList<BlockProperty *> _properties;
    QList<BlockPropertyEnum *> _propertyEnums;
};

#endif // BLOCKPROPERTY_H
