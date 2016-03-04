#include "flow.h"

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
