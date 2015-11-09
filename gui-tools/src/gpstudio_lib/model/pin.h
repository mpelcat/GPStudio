#ifndef PIN_H
#define PIN_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

#include "attribute.h"

class Block;

class GPSTUDIO_LIB_EXPORT Pin
{
public:
    Pin(Block *parent=NULL);
    ~Pin();

    QString name() const;
    void setName(const QString &name);

    QString mapTo() const;
    void setMapTo(const QString &mapTo);

    QList<Attribute *> &attributes();
    const QList<Attribute *> &attributes() const;
    void addAttribute(Attribute *attribute);

    Block *parent() const;
    void setParent(Block *parent);

public:
    static Pin *fromNodeGenerated(const QDomElement &domElement);
    static QList<Pin *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _mapTo;

    Block *_parent;

    QList<Attribute *> _attributes;
};

#endif // PIN_H
