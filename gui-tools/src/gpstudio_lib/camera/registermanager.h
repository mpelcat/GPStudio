#ifndef REGISTERSMAP_H
#define REGISTERSMAP_H

#include "gpstudio_lib_common.h"

#include <QMap>

#include "register.h"

class Register;
class Camera;

class GPSTUDIO_LIB_EXPORT RegisterManager
{
public:
    RegisterManager(Camera *camera);
    ~RegisterManager();

    Register *operator[](const uint addr);
    void addRegister(Register *cameraRegister);
    const QMap<uint, Register *> &registersMap() const;

    QByteArray registerData() const;

    void evalAll();

    void start();

    void setRegister(uint addr, uint value);

private:
    QMap<uint, Register *> _registersMap;

    QMap<uint, uint> _regToSend;
    QByteArray _registerData;

    Camera *_camera;
};

#endif // REGISTERSMAP_H
