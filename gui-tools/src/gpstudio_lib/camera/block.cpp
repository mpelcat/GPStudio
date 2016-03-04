#include "block.h"

#include "model/model_block.h"

Block::Block()
{

}

QString Block::name() const
{
    return _name;
}

void Block::setName(const QString &name)
{
    _name = name;
}

Property *Block::assocProperty() const
{
    return _assocProperty;
}

void Block::setAssocProperty(Property *assocProperty)
{
    _assocProperty = assocProperty;
}

Block *Block::fromModelBlock(const ModelBlock *modelBlock)
{
    Block *block = new Block();
    block->setName(block->name());

    return block;
}
