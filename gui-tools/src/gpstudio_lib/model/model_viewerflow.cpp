#include "model_viewerflow.h"
#include "model_viewer.h"

#include <QDebug>

ModelViewerFlow::ModelViewerFlow(const QString &flowName)
    :_flowname(flowName), _viewer(NULL)
{
}

ModelViewerFlow::ModelViewerFlow(const ModelViewerFlow &modelViewerFlow)
{
    _flowname = modelViewerFlow._flowname;
}

ModelViewerFlow::~ModelViewerFlow()
{
}

QString ModelViewerFlow::flowName() const
{
    return _flowname;
}

void ModelViewerFlow::setFlowName(const QString &flowName)
{
    if(_flowname != flowName)
    {
        QString oldflowName = _flowname;
        _flowname = flowName;
        if(_viewer)
            _viewer->updateKeyViewerFlow(this, oldflowName);
    }
}

ModelViewer *ModelViewerFlow::viewer() const
{
    return _viewer;
}

void ModelViewerFlow::setViewer(ModelViewer *viewer)
{
    _viewer = viewer;
}

ModelViewerFlow *ModelViewerFlow::fromNodeGenerated(const QDomElement &domElement)
{
    ModelViewerFlow *viewerFlow = new ModelViewerFlow();

    viewerFlow->setFlowName(domElement.attribute("flowName","no_name"));

    return viewerFlow;
}

QList<ModelViewerFlow *> ModelViewerFlow::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelViewerFlow *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow")
                list.append(ModelViewerFlow::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}

QDomElement ModelViewerFlow::toXMLElement(QDomDocument &doc)
{
    QDomElement element = doc.createElement("flow");

    element.setAttribute("flowName", _flowname);

    return element;
}
