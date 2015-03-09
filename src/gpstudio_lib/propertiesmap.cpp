#include "propertiesmap.h"

#include "property.h"

PropertiesMap::PropertiesMap()
{

}

PropertiesMap::~PropertiesMap()
{
    foreach (Property *property, _properties) delete property;
}

void PropertiesMap::addProperty(Property *property)
{
    _propertiesMap.insert(property->name(), property);
    _properties.append(property);
}

const QList<Property *> &PropertiesMap::properties() const
{
    return _properties;
}

const QMap<QString, Property *> &PropertiesMap::propertiesMap() const
{
    return _propertiesMap;
}
