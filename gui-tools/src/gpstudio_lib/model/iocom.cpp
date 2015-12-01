#include "iocom.h"

#include "comconnect.h"

IOCom::IOCom()
{
}

IOCom::~IOCom()
{
    for(int i=0; i<_comConnects.size(); i++) delete _comConnects[i];
}

QString IOCom::type() const
{
    return "iocom";
}

QString IOCom::driverIO() const
{
    return _driverIO;
}

void IOCom::setDriverIO(const QString &driverIO)
{
    _driverIO = driverIO;
}

void IOCom::addComConnect(ComConnect *comConnect)
{
    _comConnects.append(comConnect);
}

void IOCom::addComConnects(const QList<ComConnect *> &comConnects)
{
    foreach (ComConnect *comConnect, comConnects)
    {
        addComConnect(comConnect);
    }
}

QList<ComConnect *> IOCom::comConnects()
{
    return _comConnects;
}

const QList<ComConnect *> IOCom::comConnects() const
{
    return _comConnects;
}

IO *IOCom::fromNodeGenerated(const QDomElement &domElement, IOCom *ioCom)
{
    if(ioCom==NULL) ioCom = new IOCom();

    ioCom->setDriverIO(domElement.attribute("driverio",""));

    IO::fromNodeGenerated(domElement, ioCom);

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="com_connects") ioCom->addComConnects(ComConnect::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return ioCom;
}

