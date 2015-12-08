#ifndef FLOW_H
#define FLOW_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

#include "blockproperty.h"

class Block;

class GPSTUDIO_LIB_EXPORT Flow
{
public:
    Flow(Block *parent=NULL);
    ~Flow();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    quint8 size() const;
    void setSize(const quint8 &size);

    QString description() const;
    void setDescription(const QString &description);

    Block *parent() const;
    void setParent(Block *parent);

    QList<BlockProperty *> &properties();
    const QList<BlockProperty *> &properties() const;
    void addProperty(BlockProperty *property);
    void addProperties(const QList<BlockProperty *> &properties);
    BlockProperty *getBlockProperty(const QString &name) const;

public:
    static Flow *fromNodeGenerated(const QDomElement &domElement);
    static QList<Flow *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    quint8 _size;
    QString _description;

    QList<BlockProperty *> _properties;

    Block *_parent;
};

#endif // FLOW_H
