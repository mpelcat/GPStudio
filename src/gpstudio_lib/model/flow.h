#ifndef FLOW_H
#define FLOW_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

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

public:
    static Flow *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    quint8 _size;
    QString _description;

    Block *_parent;
};

#endif // FLOW_H
