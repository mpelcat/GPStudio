#ifndef PROPERTY_H
#define PROPERTY_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>

#include "camera.h"
#include "propertyenum.h"

#include "model/model_property.h"

class GPSTUDIO_LIB_EXPORT Property : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Property)
public:
    Property(QString name=QString());
    //Property(const Property &other);
    //Property &operator =(const Property &other);
    virtual ~Property();

    QString name() const;
    void setName(const QString &name);
    Q_PROPERTY(QString name READ name WRITE setName SCRIPTABLE true)

    QString caption() const;
    void setCaption(const QString &caption);

    QVariant &value();
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged SCRIPTABLE true)

    uint bits() const;
    Q_PROPERTY(uint bits READ bits WRITE setBits NOTIFY bitsChanged SCRIPTABLE true)

    QVariant min() const;
    void setMin(const QVariant &min);

    QVariant max() const;
    void setMax(const QVariant &max);

    QVariant step() const;
    void setStep(const QVariant &step);

    const QMap<QString, PropertyEnum *> &enumsMap() const;
    const QList<PropertyEnum *> &enums() const;

    enum Type {Group, Int, SInt, Bool, Enum, Matrix, FlowType};
    Type type() const;
    void setType(const Type &type);

    QString propertymap() const;
    void setPropertymap(const QString &propertymap);

    QString onchange() const;
    void setOnchange(const QString &onchange);

    Property &operator[](const QString &name);
    const QMap<QString, Property* > &subProperties() const;
    void addSubProperty(Property *property);

    Property *parent() const;
    void setParent(Property *parent);

    Property *path(QString path);

    QStringList dependsProperties() const;

signals:
    void valueChanged(QVariant value);
    void bitsChanged(uint value);

public slots:
    void setValue(bool value);
    void setValue(int value);
    void setValue(const QVariant &value);

    void setBits(const uint bits);

    void eval();

public:
    static Property *fromBlockProperty(ModelProperty *blockProperty);
    static Property *fromFlow(ModelFlow *flow);

protected:
    QString _name;
    QString _caption;
    QVariant _value;
    uint _bits;
    QVariant _min;
    QVariant _max;
    QVariant _step;
    Type _type;

    QString _propertyMap;
    QString _onchange;

    Property *_parent;
    QMap<QString, PropertyEnum* > _enumsMap;
    QList<PropertyEnum*> _enums;

    QMap<QString, Property* > _subProperties;

};

#endif // PROPERTY_H
