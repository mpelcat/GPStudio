#ifndef MODEL_FLOW_H
#define MODEL_FLOW_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

#include "model_property.h"

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelFlow
{
public:
    ModelFlow(ModelBlock *parent=NULL);
    ~ModelFlow();

    const QString &name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    quint8 size() const;
    void setSize(const quint8 &size);

    QString description() const;
    void setDescription(const QString &description);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

    QList<ModelProperty *> &properties();
    const QList<ModelProperty *> &properties() const;
    void addProperty(ModelProperty *property);
    void addProperties(const QList<ModelProperty *> &properties);
    ModelProperty *getBlockProperty(const QString &name) const;

public:
    static ModelFlow *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelFlow *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    quint8 _size;
    QString _description;

    QList<ModelProperty *> _properties;

    ModelBlock *_parent;
};

#endif // MODEL_FLOW_H
