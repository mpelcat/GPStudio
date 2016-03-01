#ifndef CIBLOCK_H
#define CIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "model_block.h"

class GPSTUDIO_LIB_EXPORT ModelCIBlock : public ModelBlock
{
public:
    ModelCIBlock();
    virtual ~ModelCIBlock();

    QString type() const;

public:
    static ModelCIBlock *fromNodeGenerated(const QDomElement &domElement, ModelCIBlock *ciBlock=NULL);
};

#endif // CIBLOCK_H
