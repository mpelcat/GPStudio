#include "model_gpviewer.h"

#include "model_viewer.h"

ModelGPViewer::ModelGPViewer()
{
}

ModelGPViewer::~ModelGPViewer()
{
    for(int i=0; i<_viewers.size(); i++)
        delete _viewers[i];
}

QString ModelGPViewer::name() const
{
    return _name;
}

void ModelGPViewer::setName(const QString &name)
{
    _name = name;
}

const QList<ModelViewer *> &ModelGPViewer::viewers() const
{
    return _viewers;
}

void ModelGPViewer::addViewer(ModelViewer *viewer)
{
    _viewers.append(viewer);
}

void ModelGPViewer::addViewer(QList<ModelViewer *> viewers)
{
    foreach (ModelViewer *viewer, viewers)
        addViewer(viewer);
}

ModelGPViewer *ModelGPViewer::fromNodeGenerated(const QDomElement &domElement)
{
    ModelGPViewer *gpviewer = new ModelGPViewer();

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="viewers")
                gpviewer->addViewer(ModelViewer::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return gpviewer;
}

QDomElement ModelGPViewer::toXMLElement(QDomDocument &doc)
{
    QDomElement element = doc.createElement("gpviewer");

    QDomElement viewersList = doc.createElement("viewers");
    foreach (ModelViewer *viewer, _viewers)
    {
        viewersList.appendChild(viewer->toXMLElement(doc));
    }
    element.appendChild(viewersList);

    return element;
}
