#ifndef MODEL_VIEWER_H
#define MODEL_VIEWER_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QMap>
#include <QString>
#include <QDomElement>

class ModelViewerFlow;

class GPSTUDIO_LIB_EXPORT ModelViewer
{
public:
    ModelViewer(const QString &name=QString());
    ModelViewer(const ModelViewer &modelViewer);
    ~ModelViewer();

    QString name() const;
    void setName(const QString &name);

    QList<ModelViewerFlow *> &viewerFlows();
    const QList<ModelViewerFlow *> &viewerFlows() const;
    void addViewerFlow(ModelViewerFlow *viewerFlow);
    void addViewerFlow(QList<ModelViewerFlow *> viewerFlows);
    void removeViewerFlow(ModelViewerFlow *viewerFlow);
    ModelViewerFlow *getViewerFlow(const QString &name) const;

public:
    static ModelViewer *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelViewer *> listFromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _name;

    QList<ModelViewerFlow *> _viewerFlows;
    QMap<QString, ModelViewerFlow*> _viewerFlowsMap;
};

#endif // MODEL_VIEWER_H
