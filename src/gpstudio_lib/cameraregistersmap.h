#ifndef REGISTERSMAP_H
#define REGISTERSMAP_H

#include "gpstudio_lib_common.h"

#include <QMap>

#include "cameraregister.h"

class CameraRegister;
class Camera;

class GPSTUDIO_LIB_EXPORT CameraRegistersMap
{
public:
    CameraRegistersMap(Camera *camera);
    ~CameraRegistersMap();

    CameraRegister *operator[](const uint addr);
    void addRegister(CameraRegister *cameraRegister);
    const QMap<uint, CameraRegister *> &registersMap() const;

private:
    QMap<uint, CameraRegister *> _registersMap;

    Camera *_camera;
};

#endif // REGISTERSMAP_H
