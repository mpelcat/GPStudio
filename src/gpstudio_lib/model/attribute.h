#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

class Attribute
{
public:
    Attribute();

    QString name() const;
    void setName(const QString &name);

    QString value() const;
    void setValue(const QString &value);

    QString type() const;
    void setType(const QString &type);

public:
    static Attribute *fromNodeGenerated(const QDomElement &domElement);
    static QList<Attribute *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _value;
    QString _type;
};

#endif // ATTRIBUTE_H
