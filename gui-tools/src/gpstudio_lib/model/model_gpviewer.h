#ifndef MODEL_GPVIEWER_H
#define MODEL_GPVIEWER_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QString>
#include <QDomElement>

class ModelViewer;

class GPSTUDIO_LIB_EXPORT ModelGPViewer
{
public:
    ModelGPViewer();
    ~ModelGPViewer();

    QString name() const;
    void setName(const QString &name);

    const QList<ModelViewer *> &viewers() const;
    void addViewer(ModelViewer *viewer);
    void addViewer(QList<ModelViewer *> viewers);

public:
    static ModelGPViewer *fromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _name;

    QList<ModelViewer *> _viewers;
};

#endif // MODEL_GPVIEWER_H
