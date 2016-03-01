#ifndef PORT_H
#define PORT_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelPort
{
public:
    ModelPort(ModelBlock *parent=NULL);
    ~ModelPort();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    quint8 size() const;
    void setSize(const quint8 &size);

    QString description() const;
    void setDescription(const QString &description);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

public:
    static ModelPort *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelPort *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    quint8 _size;
    QString _description;

    ModelBlock *_parent;
};

#endif // PORT_H
