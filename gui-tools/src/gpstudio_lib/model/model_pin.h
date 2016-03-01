#ifndef PIN_H
#define PIN_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

#include "model_attribute.h"

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelPin
{
public:
    ModelPin(ModelBlock *parent=NULL);
    ~ModelPin();

    QString name() const;
    void setName(const QString &name);

    QString mapTo() const;
    void setMapTo(const QString &mapTo);

    QList<ModelAttribute *> &attributes();
    const QList<ModelAttribute *> &attributes() const;
    void addAttribute(ModelAttribute *attribute);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

public:
    static ModelPin *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelPin *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _mapTo;

    ModelBlock *_parent;

    QList<ModelAttribute *> _attributes;
};

#endif // PIN_H
