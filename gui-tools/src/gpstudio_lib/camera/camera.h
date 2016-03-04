#ifndef CAMERA_H
#define CAMERA_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QMap>

#include "block.h"
#include "scriptengine.h"

#include "model/model_node.h"
#include "property.h"
#include "registermanager.h"

class CameraCom;
class CameraInfo;
class FlowManager;

class GPSTUDIO_LIB_EXPORT Camera : public QObject
{
    Q_OBJECT
public:
    Camera(const QString &fileCameraConfig=QString());
    ~Camera();

    ModelNode *node() const;
    void setNode(ModelNode *node);

    Property *rootProperty() const;
    RegisterManager &registers();

    bool isConnected() const;
    void connectCam(const CameraInfo &cameraInfo);

    CameraCom *com() const;
    FlowManager *flowManager() const;

    QByteArray registerData() const;

    const QMap<QString, Block*> &blocks() const;

signals:
    void registerDataChanged();

public slots:
    uint evalPropertyMap(const QString &propertyMap);
    void setRegister(uint addr, uint value);

private:
    ModelNode *_node;

    Property *_paramsBlocks;
    RegisterManager _registermanager;
    FlowManager *_flowManager;

    CameraCom *_com;

    QMap<QString, Block*> _blocks;
};

#endif // CAMERA_H
