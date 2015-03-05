#ifndef CAMERA_H
#define CAMERA_H

#include "gpstudio_lib_common.h"
#include "property.h"

#include <QObject>
#include <QMap>

#include "model/node.h"

class GPSTUDIO_LIB_EXPORT Camera : public QObject
{
    Q_OBJECT
public:
    Camera(const QString &fileCameraConfig);
    ~Camera();

    Node *node() const;
    void setNode(Node *node);

    Property *paramsBlocks() const;

signals:

public slots:

private:
    Node *_node;

    Property *_paramsBlocks;
};

#endif // CAMERA_H
