#ifndef MODEL_VIEWERFLOW_H
#define MODEL_VIEWERFLOW_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ModelViewerFlow
{
public:
    ModelViewerFlow();
    ModelViewerFlow(const ModelViewerFlow &modelViewerFlow);
    ~ModelViewerFlow();

    QString flowName() const;
    void setFlowName(const QString &name);

public:
    static ModelViewerFlow *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelViewerFlow *> listFromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _flowname;
};

#endif // MODEL_VIEWERFLOW_H
