#include "model_comconnect.h"

ModelComConnect::ModelComConnect()
{
}

QString ModelComConnect::link() const
{
    return _link;
}

void ModelComConnect::setLink(const QString &link)
{
    _link = link;
}

QString ModelComConnect::id() const
{
    return _id;
}

void ModelComConnect::setId(const QString &id)
{
    _id = id;
}

QString ModelComConnect::type() const
{
    return _type;
}

void ModelComConnect::setType(const QString &type)
{
    _type = type;
}

ModelComConnect *ModelComConnect::fromNodeGenerated(const QDomElement &domElement)
{
    ModelComConnect *comConnect=new ModelComConnect();

    comConnect->setLink(domElement.attribute("link",""));
    comConnect->setId(domElement.attribute("id",""));
    comConnect->setType(domElement.attribute("type",""));

    return comConnect;
}

QList<ModelComConnect *> ModelComConnect::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelComConnect *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="com_connect") list.append(ModelComConnect::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
