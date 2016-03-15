#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class Flow;

class ModelBlock;

/**
 * @brief The Block class is part of the run time model and represent a block with the list of flow interfaces
 */
class GPSTUDIO_LIB_EXPORT Block
{
public:
    Block();

    QString name() const;

    const QList<Flow *> &flows() const;
    Flow *flow(int i) const;
    Flow *flow(QString name) const;

    Property *assocProperty() const;

    const ModelBlock *modelBlock() const;

protected:
    void setName(const QString &name);

public:
    static Block *fromModelBlock(const ModelBlock *modelBlock);

protected:
    QString _name;

    QList<Flow*> _flows;
    QMap<QString, Flow*> _flowsMap;

    Property *_assocProperty;

    const ModelBlock *_modelBlock;
};

#endif // BLOCK_H
