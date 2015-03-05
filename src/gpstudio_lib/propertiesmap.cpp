#include "propertiesmap.h"

#include "property.h"

PropertiesMap::PropertiesMap()
{

}

PropertiesMap::~PropertiesMap()
{
    QMapIterator<QString, Property *> i(_properties);
    while (i.hasNext())
    {
        i.next();
        delete i.value();
    }
}

void PropertiesMap::addProperty(Property *property)
{
    _properties.insert(property->name(), property);
}

const QMap<QString, Property *> &PropertiesMap::properties() const
{
    return _properties;
}

