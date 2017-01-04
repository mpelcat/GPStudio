#ifndef MODEL_VIEWERFLOW_H
#define MODEL_VIEWERFLOW_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QString>
#include <QDomElement>

class ModelViewer;

class GPSTUDIO_LIB_EXPORT ModelViewerFlow
{
public:
    ModelViewerFlow(const QString &flowName=QString());
    ModelViewerFlow(const ModelViewerFlow &modelViewerFlow);
    ~ModelViewerFlow();

    QString flowName() const;
    void setFlowName(const QString &flowName);

    ModelViewer *viewer() const;
    void setViewer(ModelViewer *viewer);

public:
    static ModelViewerFlow *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelViewerFlow *> listFromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _flowname;

    ModelViewer *_viewer;
};

#endif // MODEL_VIEWERFLOW_H
