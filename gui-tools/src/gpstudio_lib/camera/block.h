#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class ModelBlock;

class GPSTUDIO_LIB_EXPORT Block
{
public:
    Block();

    QString name() const;
    void setName(const QString &name);

    Property *assocProperty() const;
    void setAssocProperty(Property *assocProperty);

public:
    static Block *fromModelBlock(const ModelBlock *modelBlock);

protected:
    QString _name;

    Property *_assocProperty;
};

#endif // BLOCK_H
