#include "file.h"

File::File()
{
}

File::~File()
{
}

QString File::name() const
{
    return _name;
}

void File::setName(const QString &name)
{
    _name = name;
}

QString File::type() const
{
    return _type;
}

void File::setType(const QString &type)
{
    _type = type;
}

QString File::group() const
{
    return _group;
}

void File::setGroup(const QString &group)
{
    _group = group;
}

QString File::path() const
{
    return _path;
}

void File::setPath(const QString &path)
{
    _path = path;
}

QString File::description() const
{
    return _description;
}

void File::setDescription(const QString &description)
{
    _description = description;
}

File *File::fromNodeGenerated(const QDomElement &domElement)
{
    File *file=new File();

    file->setName(domElement.attribute("name","no_name"));
    file->setType(domElement.attribute("type",""));
    file->setGroup(domElement.attribute("group",""));
    file->setPath(domElement.attribute("path",""));
    file->setDescription(domElement.attribute("desc",""));

    return file;
}
