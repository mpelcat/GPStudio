#include "comconnect.h"

ComConnect::ComConnect()
{
}

QString ComConnect::link() const
{
    return _link;
}

void ComConnect::setLink(const QString &link)
{
    _link = link;
}

QString ComConnect::id() const
{
    return _id;
}

void ComConnect::setId(const QString &id)
{
    _id = id;
}

QString ComConnect::type() const
{
    return _type;
}

void ComConnect::setType(const QString &type)
{
    _type = type;
}

ComConnect *ComConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ComConnect *comConnect=new ComConnect();

    comConnect->setLink(domElement.attribute("link",""));
    comConnect->setId(domElement.attribute("id",""));
    comConnect->setType(domElement.attribute("type",""));

    return comConnect;
}

QList<ComConnect *> ComConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ComConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="com_connect") list.append(ComConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
