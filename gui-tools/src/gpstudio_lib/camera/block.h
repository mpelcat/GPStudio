#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class Flow;

class ModelBlock;

class GPSTUDIO_LIB_EXPORT Block
{
public:
    Block();

    QString name() const;

    Property *assocProperty() const;

    const QList<Flow *> &flows() const;
    Flow *flow(int i) const;
    Flow *flow(QString name) const;

protected:
    void setName(const QString &name);

public:
    static Block *fromModelBlock(const ModelBlock *modelBlock);

protected:
    QString _name;

    QList<Flow*> _flows;
    QMap<QString, Flow*> _flowsMap;

    Property *_assocProperty;
};

#endif // BLOCK_H
