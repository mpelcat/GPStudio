#include "ciblock.h"

CIBlock::CIBlock()
{
}

CIBlock::~CIBlock()
{
}

QString CIBlock::type() const
{
    return "ci";
}

CIBlock *CIBlock::fromNodeGenerated(const QDomElement &domElement, CIBlock *ciBlock)
{
    if(ciBlock==NULL) ciBlock = new CIBlock();

    Block::fromNodeGenerated(domElement, ciBlock);

    return ciBlock;
}
