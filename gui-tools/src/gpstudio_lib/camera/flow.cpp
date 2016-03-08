#include "flow.h"

#include "model/model_flow.h"

#include "property.h"

Flow::Flow()
{

}

QString Flow::name() const
{
    return _name;
}

void Flow::setName(const QString &name)
{
    _name = name;
}

Flow *Flow::fromModelFlow(const ModelFlow *modelFlow)
{
    Flow *flow = new Flow();
    flow->setName(modelFlow->name());
    if(modelFlow->type()=="in")
        flow->setType(Input);
    else
        flow->setType(Output);

    Property *flowprop = Property::fromModelFlow(modelFlow);
    flow->_assocProperty = flowprop;

    return flow;
}

Flow::Type Flow::type() const
{
    return _type;
}

void Flow::setType(const Flow::Type &type)
{
    _type = type;
}

Property *Flow::assocProperty() const
{
    return _assocProperty;
}
