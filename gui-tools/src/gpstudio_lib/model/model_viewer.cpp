#include "model_viewer.h"

ModelViewer::ModelViewer()
{
}

ModelViewer::~ModelViewer()
{
}

QString ModelViewer::name() const
{
    return _name;
}

void ModelViewer::setName(const QString &name)
{
    _name = name;
}

ModelViewer *ModelViewer::fromNodeGenerated(const QDomElement &domElement)
{
    ModelViewer *viewer = new ModelViewer();

    viewer->setName(domElement.attribute("name","no_name"));

    return viewer;
}

QList<ModelViewer *> ModelViewer::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelViewer *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="viewer")
                list.append(ModelViewer::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}

QDomElement ModelViewer::toXMLElement(QDomDocument &doc)
{
    QDomElement element = doc.createElement("viewer");

    element.setAttribute("name", _name);

    return element;
}
