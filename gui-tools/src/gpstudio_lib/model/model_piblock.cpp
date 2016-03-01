#include "model_piblock.h"

ModelPIBlock::ModelPIBlock()
{
}

ModelPIBlock::~ModelPIBlock()
{
}

QString ModelPIBlock::type() const
{
    return "pi";
}

ModelPIBlock *ModelPIBlock::fromNodeGenerated(const QDomElement &domElement, ModelPIBlock *piBlock)
{
    if(piBlock==NULL) piBlock = new ModelPIBlock();

    ModelBlock::fromNodeGenerated(domElement, piBlock);

    return piBlock;
}
