#ifndef MODEL_VIEWER_H
#define MODEL_VIEWER_H

#include "gpstudio_lib_common.h"

#include <QList>
#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT ModelViewer
{
public:
    ModelViewer();
    ~ModelViewer();

    QString name() const;
    void setName(const QString &name);

public:
    static ModelViewer *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelViewer *> listFromNodeGenerated(const QDomElement &domElement);
    QDomElement toXMLElement(QDomDocument &doc);

protected:
    QString _name;
};

#endif // MODEL_VIEWER_H
