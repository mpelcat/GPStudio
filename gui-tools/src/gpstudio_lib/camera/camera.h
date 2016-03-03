#ifndef CAMERA_H
#define CAMERA_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QMap>

#include "scriptengine.h"

#include "model/model_node.h"
#include "property.h"
#include "cameraregistersmap.h"

#include "cameracom.h"
class FlowManager;

class GPSTUDIO_LIB_EXPORT Camera : public QObject
{
    Q_OBJECT
public:
    Camera(const QString &fileCameraConfig);
    ~Camera();

    ModelNode *node() const;
    void setNode(ModelNode *node);

    Property *paramsBlocks() const;
    CameraRegistersMap &registers();

    bool isConnected() const;
    void connectCam(const CameraInfo &cameraInfo);

    CameraCom *com() const;
    FlowManager *flowManager() const;

    QByteArray registerData() const;

signals:
    void registerDataChanged();

public slots:
    uint evalPropertyMap(const QString &propertyMap);
    void setRegister(uint addr, uint value);

private:
    ModelNode *_node;

    Property *_paramsBlocks;
    CameraRegistersMap _registers;
    // TODO remove _registerData and put into CameraRegistersMap
    QByteArray _registerData;

    CameraCom *_com;

    FlowManager *_flowManager;
};

#endif // CAMERA_H
