#include "cameraregistersmap.h"

#include "cameraregister.h"

CameraRegistersMap::CameraRegistersMap(Camera *camera)
    : _camera(camera)
{
}

CameraRegistersMap::~CameraRegistersMap()
{
    QMapIterator<uint, CameraRegister *> it(_registersMap);
    while (it.hasNext())
    {
        it.next();
        delete it.value();
    }
}

CameraRegister *CameraRegistersMap::operator[](const uint addr)
{
    if(!_registersMap.contains(addr)) return NULL;
    return _registersMap[addr];
}

void CameraRegistersMap::addRegister(CameraRegister *cameraRegister)
{
    if(!cameraRegister) return;
    cameraRegister->setCamera(_camera);
    _registersMap.insert(cameraRegister->addr(), cameraRegister);
}

const QMap<uint, CameraRegister *> &CameraRegistersMap::registersMap() const
{
    return _registersMap;
}

void CameraRegistersMap::evalAll()
{
    QMapIterator<uint, CameraRegister *> it(_registersMap);
    while (it.hasNext())
    {
        it.next();
        CameraRegister *cameraRegister = it.value();

        cameraRegister->eval();
        foreach (CameraRegisterBitField *bitField, cameraRegister->bitFields())
        {
            bitField->eval();
        }
    }
}
