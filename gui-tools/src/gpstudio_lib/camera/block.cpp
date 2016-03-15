#include "block.h"

#include "model/model_block.h"

#include "flow.h"
#include "register.h"

Block::Block()
{

}

QString Block::name() const
{
    return _name;
}

Property *Block::assocProperty() const
{
    return _assocProperty;
}

Block *Block::fromModelBlock(const ModelBlock *modelBlock)
{
    Block *block = new Block();
    block->_modelBlock = modelBlock;
    block->setName(modelBlock->name());

    Property *propBlock = Property::fromModelBlock(modelBlock);
    block->_assocProperty = propBlock;

    // block property
    foreach (ModelProperty *property, modelBlock->properties())
    {
        Property *paramprop = Property::fromModelProperty(property);
        propBlock->addSubProperty(paramprop);
    }

    // flow property
    foreach (ModelFlow *modelFlow, modelBlock->flows())
    {
        Flow *flow = Flow::fromModelFlow(modelFlow);
        block->_flows.append(flow);
        block->_flowsMap.insert(flow->name(), flow);
        propBlock->addSubProperty(flow->assocProperty());
    }

    return block;
}

const ModelBlock *Block::modelBlock() const
{
    return _modelBlock;
}

void Block::setName(const QString &name)
{
    _name = name;
}

const QList<Flow *> &Block::flows() const
{
    return _flows;
}

Flow *Block::flow(int i) const
{
    if(i<_flows.count()) return _flows[i];
    return NULL;
}

Flow *Block::flow(QString name) const
{
    QMap<QString, Flow*>::const_iterator localConstFind = _flowsMap.constFind(name);
    if(localConstFind!=_flowsMap.constEnd()) return *localConstFind;
    return NULL;
}
