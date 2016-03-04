#ifndef PROPERTY_H
#define PROPERTY_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>

#include "propertyenum.h"

class Camera;

class ModelProperty;
class ModelFlow;

class GPSTUDIO_LIB_EXPORT Property : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Property)
public:
    Property(QString name=QString());
    //Property(const Property &other);
    //Property &operator =(const Property &other);
    virtual ~Property();

    const QString &name() const;
    void setName(const QString &name);
    Q_PROPERTY(QString name READ name WRITE setName SCRIPTABLE true)

    const QString &caption() const;
    void setCaption(const QString &caption);

    const QVariant &value() const;
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged SCRIPTABLE true)

    uint bits() const;
    Q_PROPERTY(uint bits READ bits WRITE setBits NOTIFY bitsChanged SCRIPTABLE true)

    const QVariant &min() const;
    void setMin(const QVariant &min);

    const  QVariant &max() const;
    void setMax(const QVariant &max);

    const QVariant &step() const;
    void setStep(const QVariant &step);

    const QMap<QString, PropertyEnum *> &enumsMap() const;
    const QList<PropertyEnum *> enums() const;

    enum Type {Group, Int, SInt, Bool, Enum, Matrix, FlowType};
    Type type() const;
    void setType(const Type &type);

    const QString &propertymap() const;
    void setPropertymap(const QString &propertymap);

    const QString &onchange() const;
    void setOnchange(const QString &onchange);

    Property &operator[](const QString &name);
    const QMap<QString, Property* > &subProperties() const;
    void addSubProperty(Property *property);

    Property *parent() const;
    void setParent(Property *parent);

    const Property *path(const QString &path) const;

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
    static Property *fromModelProperty(ModelProperty *modelProperty);
    static Property *fromFlow(ModelFlow *modelFlow);

protected:
    QString _name;
    QString _caption;
    QVariant _value;
    uint _bits;
    Type _type;

    // TODO move these attributes to sub-properties
    QVariant _min;
    QVariant _max;
    QVariant _step;

    QString _propertyMap;
    QString _onchange;

    Property *_parent;
    QMap<QString, PropertyEnum* > _enumsMap;

    QMap<QString, Property* > _subProperties;

};

#endif // PROPERTY_H
