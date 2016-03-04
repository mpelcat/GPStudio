#ifndef MODEL_BLOCKPROPERTY_H
#define MODEL_BLOCKPROPERTY_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QVariant>
#include <QDomElement>

class ModelBlock;

#include "model_propertyenum.h"

class GPSTUDIO_LIB_EXPORT ModelProperty
{
public:
    ModelProperty();
    ~ModelProperty();

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

    QString propertymap() const;
    void setPropertymap(const QString &propertymap);

    QString onchange() const;
    void setOnchange(const QString &onchange);

    QString description() const;
    void setDescription(const QString &description);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

    QList<ModelProperty *> &properties();
    const QList<ModelProperty *> &properties() const;
    void addProperty(ModelProperty *property);

    QList<ModelPropertyEnum *> &propertyEnums();
    const QList<ModelPropertyEnum *> &propertyEnums() const;
    void addPropertyEnum(ModelPropertyEnum *propertyEnum);

public:
    static ModelProperty *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelProperty *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _caption;
    QString _type;
    QString _value;
    QString _min;
    QString _max;
    QString _step;
    QString _assert;
    QString _onchange;
    QString _propertymap;
    QString _description;

    ModelBlock *_parent;

    QList<ModelProperty *> _properties;
    QList<ModelPropertyEnum *> _propertyEnums;
};

#endif // MODEL_BLOCKPROPERTY_H
