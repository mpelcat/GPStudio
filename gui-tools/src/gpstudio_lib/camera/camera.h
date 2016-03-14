#ifndef CAMERA_H
#define CAMERA_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QMap>

#include "block.h"
#include "flow.h"
#include "property.h"

#include "scriptengine.h"

#include "model/model_node.h"
#include "registermanager.h"

class CameraCom;
class CameraInfo;
class FlowManager;

/**
 * @brief The Camera class is part of the run time model and represent the main camera.
 * Camera could be created from a node_generated.xml file. After that you can connect to a real camera with connectCam method.
 */
class GPSTUDIO_LIB_EXPORT Camera : public QObject
{
    Q_OBJECT
public:
    Camera(const QString &fileCameraConfig=QString());
    ~Camera();

    const ModelNode *node() const;

    const Property &rootProperty() const;
    Property &rootProperty();
    RegisterManager &registers();

    void connectCam(const CameraInfo &cameraInfo);
    bool isConnected() const;

    CameraCom *com() const;
    FlowManager *flowManager() const;

    QByteArray registerData() const;

    const QList<Block *> &blocks() const;
    Block *block(QString name) const;
    Block *block(int i) const;

signals:
    void registerDataChanged();

public slots:
    uint evalPropertyMap(const QString &propertyMap);
    void setRegister(uint addr, uint value);

protected:
    void setNode(ModelNode *node);
    ModelNode *_node;

    Property _paramsBlocks;
    RegisterManager _registermanager;
    FlowManager *_flowManager;

    CameraCom *_com;

    // blocks conntainers
    QList<Block*> _blocks;
    QMap<QString, Block*> _blocksMap;
};

#endif // CAMERA_H
