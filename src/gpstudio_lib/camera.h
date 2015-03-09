#ifndef CAMERA_H
#define CAMERA_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QMap>

#include <QScriptEngine>
#include <QtScriptTools/QScriptEngineDebugger>

#include "model/node.h"
#include "property.h"
#include "cameraregistersmap.h"

#include "cameracom.h"

class GPSTUDIO_LIB_EXPORT Camera : public QObject
{
    Q_OBJECT
public:
    Camera(const QString &fileCameraConfig);
    ~Camera();

    Node *node() const;
    void setNode(Node *node);

    Property *paramsBlocks() const;
    CameraRegistersMap &registers();

    QScriptEngine *engine();

    bool isConnected() const;
    void connectCam(const CameraInfo &cameraInfo);

    CameraCom *com() const;

signals:

public slots:
    uint evalPropertyMap(QString propertyMap, QString blockContext);
    void setRegister(uint addr, uint value);

private:
    Node *_node;

    Property *_paramsBlocks;
    CameraRegistersMap _registers;

    QScriptEngine _engine;

    CameraCom *_com;
};

#endif // CAMERA_H
