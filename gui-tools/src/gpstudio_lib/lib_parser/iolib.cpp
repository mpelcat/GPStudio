#include "iolib.h"

IOLib::IOLib()
{

}

IOLib::~IOLib()
{

}

QString IOLib::name() const
{
    return _name;
}

void IOLib::setName(const QString &name)
{
    _name = name;
}

QString IOLib::type() const
{
    return _type;
}

void IOLib::setType(const QString &type)
{
    _type = type;
}

QString IOLib::driver() const
{
    return _driver;
}

void IOLib::setDriver(const QString &driver)
{
    _driver = driver;
}

bool IOLib::isOptional() const
{
    return _optional;
}

void IOLib::setOptional(bool optional)
{
    _optional = optional;
}

QString IOLib::group() const
{
    return _group;
}

void IOLib::setGroup(const QString &group)
{
    _group = group;
}

QString IOLib::description() const
{
    return _description;
}

void IOLib::setDescription(const QString &description)
{
    _description = description;
}

IOLib *IOLib::fromNodeGenerated(const QDomElement &domElement)
{
    IOLib *io=new IOLib();
    io->setName(domElement.attribute("name","no_name"));
    io->setType(domElement.attribute("type",""));
    io->setDriver(domElement.attribute("driver",""));

    io->setOptional((domElement.attribute("optional","")=="1" || domElement.attribute("optional","")=="true"));
    io->setGroup(domElement.attribute("optionalgroup",""));

    io->setDescription(domElement.attribute("description",""));

    return io;
}

QList<IOLib *> IOLib::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<IOLib *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="io") list.append(IOLib::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
