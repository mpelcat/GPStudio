#include "model_ciblock.h"

ModelCIBlock::ModelCIBlock()
{
}

ModelCIBlock::~ModelCIBlock()
{
}

QString ModelCIBlock::type() const
{
    return "ci";
}

ModelCIBlock *ModelCIBlock::fromNodeGenerated(const QDomElement &domElement, ModelCIBlock *ciBlock)
{
    if(ciBlock==NULL) ciBlock = new ModelCIBlock();

    ModelBlock::fromNodeGenerated(domElement, ciBlock);

    return ciBlock;
}
