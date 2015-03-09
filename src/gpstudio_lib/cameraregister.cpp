#include "cameraregister.h"

#include <QDebug>
#include <QRegExp>
#include <QStringList>

#include "model/param.h"
#include "model/block.h"

#include "camera.h"

CameraRegister::CameraRegister(const QString &name, const uint &addr)
    : _name(name), _addr(addr)
{
}

CameraRegister::~CameraRegister()
{
}

QString CameraRegister::name() const
{
    return _name;
}

void CameraRegister::setName(const QString &name)
{
    _name = name;
}

uint CameraRegister::addr() const
{
    return _addr;
}

void CameraRegister::setAddr(const uint &addr)
{
    _addr = addr;
}

uint CameraRegister::value() const
{
    return _value;
}

void CameraRegister::setValue(const uint &value)
{
    //qDebug()<<_blockName<<_name<<value;
    _value = value;
    emit registerChange(_addr, value);
}

void CameraRegister::setValue(const QVariant &value)
{
    setValue(value.toUInt());
}

void CameraRegister::eval()
{
    if(_camera)
    {
        setValue(_camera->evalPropertyMap(_propertyMap, _blockName));
    }
}

QString CameraRegister::blockName() const
{
    return _blockName;
}

void CameraRegister::setBlockName(const QString &blockName)
{
    _blockName = blockName;
}

QString CameraRegister::propertyMap() const
{
    return _propertyMap;
}

void CameraRegister::setPropertyMap(const QString &propertyMap)
{
    _propertyMap = propertyMap;
}

QStringList CameraRegister::dependsProperties() const
{
    QRegExp exp("([a-zA-Z0-9_]+\\.?)+");
    int pos=0;
    QStringList props;
    while((pos = exp.indexIn(_propertyMap, pos)) != -1)
    {
        pos += exp.matchedLength();
        props.append(exp.cap(0));
    }
    return props;
}

Camera *CameraRegister::camera() const
{
    return _camera;
}

void CameraRegister::setCamera(Camera *camera)
{
    _camera = camera;
}

CameraRegister *CameraRegister::fromParam(const Param *param)
{
    CameraRegister *cameraRegister = new CameraRegister(param->name(), param->absoluteAddr());
    cameraRegister->setPropertyMap(param->propertyMap());
    if(param->parent()) cameraRegister->setBlockName(param->parent()->name());
    return cameraRegister;
}
