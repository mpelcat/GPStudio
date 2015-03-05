#ifndef PROPERTY_H
#define PROPERTY_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QVariant>

#include "propertiesmap.h"

class GPSTUDIO_LIB_EXPORT Property : public QObject
{
    Q_OBJECT
public:
    Property(QString name=QString());
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

    enum Type {Group, Int, SInt, Bool, Enum};
    Type type() const;
    void setType(const Type &type);

    const PropertiesMap &subProperties() const;
    void addSubProperty(Property *property);

    Property *parent() const;
    void setParent(Property *parent);

signals:
    void valueChanged(QVariant &value);

public slots:
    void setValue(const QVariant &value);

protected:
    QString _name;
    QString _caption;
    QVariant _value;
    QVariant _min;
    QVariant _max;
    Type _type;

    Property *_parent;

    PropertiesMap _subProperties;
};

#endif // PROPERTY_H
