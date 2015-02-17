#include "processlib.h"

ProcessLib::ProcessLib()
{
}

QString ProcessLib::name() const
{
    return _name;
}

void ProcessLib::setName(const QString &name)
{
    _name = name;
}

QString ProcessLib::description() const
{
    return _description;
}

void ProcessLib::setDescription(const QString &description)
{
    _description = description;
}

QString ProcessLib::categ() const
{
    return _categ;
}

void ProcessLib::setCateg(const QString &categ)
{
    _categ = categ;
}

QString ProcessLib::path() const
{
    return _path;
}

void ProcessLib::setPath(const QString &path)
{
    _path = path;
}

QString ProcessLib::configFile() const
{
    return _configFile;
}

void ProcessLib::setConfigFile(const QString &configFile)
{
    _configFile = configFile;
}

QString ProcessLib::draw() const
{
    return _draw;
}

void ProcessLib::setDraw(const QString &draw)
{
    _draw = draw;
}
