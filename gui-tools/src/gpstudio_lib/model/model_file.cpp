#include "model_file.h"

#include "model_block.h"

ModelFile::ModelFile(ModelBlock *parent)
    : _parent(parent)
{
    _parent = NULL;
}

ModelFile::~ModelFile()
{
}

QString ModelFile::name() const
{
    return _name;
}

void ModelFile::setName(const QString &name)
{
    _name = name;
}

QString ModelFile::type() const
{
    return _type;
}

void ModelFile::setType(const QString &type)
{
    _type = type;
}

QString ModelFile::group() const
{
    return _group;
}

void ModelFile::setGroup(const QString &group)
{
    _group = group;
}

QString ModelFile::path() const
{
    return _path;
}

void ModelFile::setPath(const QString &path)
{
    _path = path;
}

QString ModelFile::description() const
{
    return _description;
}

void ModelFile::setDescription(const QString &description)
{
    _description = description;
}

ModelBlock *ModelFile::parent() const
{
    return _parent;
}

void ModelFile::setParent(ModelBlock *parent)
{
    _parent = parent;
}

ModelFile *ModelFile::fromNodeGenerated(const QDomElement &domElement)
{
    ModelFile *file=new ModelFile();

    file->setName(domElement.attribute("name","no_name"));
    file->setType(domElement.attribute("type",""));
    file->setGroup(domElement.attribute("group",""));
    file->setPath(domElement.attribute("path",""));
    file->setDescription(domElement.attribute("desc",""));

    return file;
}

QList<ModelFile *> ModelFile::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelFile *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="file") list.append(ModelFile::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
