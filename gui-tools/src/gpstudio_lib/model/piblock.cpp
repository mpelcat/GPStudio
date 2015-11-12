#include "piblock.h"

PIBlock::PIBlock()
{
}

PIBlock::~PIBlock()
{
}

QString PIBlock::type() const
{
    return "pi";
}

PIBlock *PIBlock::fromNodeGenerated(const QDomElement &domElement, PIBlock *piBlock)
{
    if(piBlock==NULL) piBlock = new PIBlock();

    Block::fromNodeGenerated(domElement, piBlock);

    return piBlock;
}
