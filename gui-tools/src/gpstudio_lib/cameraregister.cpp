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
    _value=0;
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
    //if(_value!=value)
    {
        _value = value;
        emit registerChange(_addr, value);
    }
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

void CameraRegister::setField(uint value, uint mask)
{
    //qDebug()<<"setfiel"<<value<<mask<<(((~mask)&_value)|(mask&value));
    setValue(((~mask)&_value)|(mask&value));
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
    return ScriptEngine::dependsProperties(_propertyMap);
}

Camera *CameraRegister::camera() const
{
    return _camera;
}

void CameraRegister::setCamera(Camera *camera)
{
    _camera = camera;
}

void CameraRegister::addBitField(CameraRegisterBitField *bitField)
{
    bitField->setParent(this);
    connect(bitField, SIGNAL(bitfieldChange(uint,uint)), this, SLOT(setField(uint,uint)));
    _bitFields.append(bitField);
}

const QList<CameraRegisterBitField *> &CameraRegister::bitFields() const
{
    return _bitFields;
}

CameraRegister *CameraRegister::fromParam(const Param *param)
{
    CameraRegister *cameraRegister = new CameraRegister(param->name(), param->absoluteAddr());
    cameraRegister->setPropertyMap(param->propertyMap());
    if(param->parent()) cameraRegister->setBlockName(param->parent()->name());

    foreach(ParamBitField *bitField, param->paramBitFields())
    {
        CameraRegisterBitField *camBitField = CameraRegisterBitField::fromParamBitField(bitField);
        cameraRegister->addBitField(camBitField);
    }

    return cameraRegister;
}
