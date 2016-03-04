#ifndef MODEL_PIBLOCK_H
#define MODEL_PIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "model_block.h"

class GPSTUDIO_LIB_EXPORT ModelPIBlock : public ModelBlock
{
public:
    ModelPIBlock();
    virtual ~ModelPIBlock();

    QString type() const;

public:
    static ModelPIBlock *fromNodeGenerated(const QDomElement &domElement, ModelPIBlock *piBlock=NULL);
};

#endif // MODEL_PIBLOCK_H
