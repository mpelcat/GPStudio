#ifndef PROPERTY_H
#define PROPERTY_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>

#include "propertiesmap.h"
#include "propertyenum.h"

#include "model/blockproperty.h"

class GPSTUDIO_LIB_EXPORT Property : public QObject
{
    Q_OBJECT
public:
    Property(QString name=QString());
    Property(const Property &other);
    Property &operator =(const Property &other);
    virtual ~Property();

    QString name() const;
    void setName(const QString &name);
    Q_PROPERTY(QString name READ name WRITE setName SCRIPTABLE true)

    QString caption() const;
    void setCaption(const QString &caption);

    QVariant &value();
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged SCRIPTABLE true)

    QVariant min() const;
    void setMin(const QVariant &min);

    QVariant max() const;
    void setMax(const QVariant &max);

    QVariant step() const;
    void setStep(const QVariant &step);

    const QMap<QString, PropertyEnum *> &enumsMap() const;
    const QList<PropertyEnum *> &enums() const;

    enum Type {Group, Int, SInt, Bool, Enum};
    Type type() const;
    void setType(const Type &type);

    Property &operator[](const QString &name);
    const PropertiesMap &subProperties() const;
    void addSubProperty(Property *property);

    Property *parent() const;
    void setParent(Property *parent);

    Property *path(QString path);

signals:
    void valueChanged(QVariant value);

public slots:
    void setValue(bool value);
    void setValue(int value);
    void setValue(const QVariant &value);

public:
    static Property *fromBlockProperty(BlockProperty *blockProperty);

protected:
    QString _name;
    QString _caption;
    QVariant _value;
    QVariant _min;
    QVariant _max;
    QVariant _step;
    Type _type;

    Property *_parent;
    QMap<QString, PropertyEnum* > _enumsMap;
    QList<PropertyEnum*> _enums;

    PropertiesMap _subProperties;
};

#endif // PROPERTY_H
