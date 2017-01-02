#ifndef MODEL_GPVIEWER_H
#define MODEL_GPVIEWER_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QMap>
#include <QString>
#include <QDomElement>

class ModelViewer;
class ModelViewerFlow;

class GPSTUDIO_LIB_EXPORT ModelGPViewer
{
public:
    ModelGPViewer();
    ~ModelGPViewer();

    QString name() const;
    void setName(const QString &name);

    QList<ModelViewer *> &viewers();
    const QList<ModelViewer *> &viewers() const;
    void addViewer(ModelViewer *viewer);
    void addViewer(QList<ModelViewer *> viewers);
    void removeViewer(ModelViewer *viewer);
    ModelViewer *getViewer(const QString &name) const;

    ModelViewerFlow *getViewerFlow(const QString &viewerName, const QString &flowName) const;

public:
    static ModelGPViewer *fromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _name;

    QList<ModelViewer *> _viewers;
    QMap<QString, ModelViewer*> _viewersMap;
};

#endif // MODEL_GPVIEWER_H
