#include "fiblock.h"

FIBlock::FIBlock()
{
}

FIBlock::~FIBlock()
{
}

QString FIBlock::type() const
{
    return "fi";
}

FIBlock *FIBlock::fromNodeGenerated(const QDomElement &domElement, FIBlock *fiBlock)
{
    if(fiBlock==NULL) fiBlock = new FIBlock();

    Block::fromNodeGenerated(domElement, fiBlock);

    return fiBlock;
}
