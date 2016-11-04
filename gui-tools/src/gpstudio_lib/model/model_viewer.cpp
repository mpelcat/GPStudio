#include "model_viewer.h"

#include "model_viewerflow.h"

ModelViewer::ModelViewer(const QString &name)
    : _name(name)
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

const QList<ModelViewerFlow *> &ModelViewer::viewerFlows() const
{
    return _viewerFlows;
}

void ModelViewer::addViewerFlow(ModelViewerFlow *viewerFlow)
{
    _viewerFlows.append(viewerFlow);
}

void ModelViewer::addViewerFlow(QList<ModelViewerFlow *> viewerFlows)
{
    foreach (ModelViewerFlow *viewerFlow, viewerFlows)
        addViewerFlow(viewerFlow);
}

ModelViewer *ModelViewer::fromNodeGenerated(const QDomElement &domElement)
{
    ModelViewer *viewer = new ModelViewer();

    viewer->setName(domElement.attribute("name","no_name"));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flows")
                viewer->addViewerFlow(ModelViewerFlow::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

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

    QDomElement flowsList = doc.createElement("flows");
    foreach (ModelViewerFlow *viewerFlow, _viewerFlows)
    {
        flowsList.appendChild(viewerFlow->toXMLElement(doc));
    }
    element.appendChild(flowsList);

    return element;
}
