#include "register.h"

#include <QDebug>
#include <QRegExp>
#include <QStringList>

#include "model/model_param.h"
#include "model/model_block.h"

#include "camera.h"

Register::Register(const QString &name, const uint &addr)
    : _name(name), _addr(addr)
{
    _value=0;
}

Register::~Register()
{
}

QString Register::name() const
{
    return _name;
}

void Register::setName(const QString &name)
{
    _name = name;
}

uint Register::addr() const
{
    return _addr;
}

void Register::setAddr(const uint &addr)
{
    _addr = addr;
}

uint Register::value() const
{
    return _value;
}

void Register::setValue(const uint &value)
{
    //if(_value!=value)
    {
        _value = value;
        emit registerChange(_addr, value);
    }
}

void Register::setValue(const QVariant &value)
{
    setValue(value.toUInt());
}

void Register::eval()
{
    setValue(ScriptEngine::getEngine().evalPropertyMap(_propertyMap));
}

void Register::setField(uint value, uint mask)
{
    //qDebug()<<"setfiel"<<value<<mask<<(((~mask)&_value)|(mask&value));
    setValue(((~mask)&_value)|(mask&value));
}

const ModelParam *Register::modelParam() const
{
    return _modelParam;
}

QString Register::blockName() const
{
    return _blockName;
}

void Register::setBlockName(const QString &blockName)
{
    _blockName = blockName;
}

QString Register::propertyMap() const
{
    return _propertyMap;
}

void Register::setPropertyMap(const QString &propertyMap)
{
    _propertyMap = propertyMap;
}

QStringList Register::dependsProperties() const
{
    return ScriptEngine::dependsProperties(_propertyMap);
}

Camera *Register::camera() const
{
    return _camera;
}

void Register::setCamera(Camera *camera)
{
    _camera = camera;
}

void Register::addBitField(RegisterBitField *bitField)
{
    bitField->setParent(this);
    connect(bitField, SIGNAL(bitfieldChange(uint,uint)), this, SLOT(setField(uint,uint)));
    _bitFields.append(bitField);
}

const QList<RegisterBitField *> &Register::bitFields() const
{
    return _bitFields;
}

Register *Register::fromParam(const ModelParam *modelParam)
{
    Register *cameraRegister = new Register(modelParam->name(), modelParam->absoluteAddr());
    cameraRegister->_modelParam = modelParam;
    cameraRegister->setPropertyMap(modelParam->propertyMap());
    if(modelParam->parent()) cameraRegister->setBlockName(modelParam->parent()->name());

    foreach(ModelParamBitField *bitField, modelParam->paramBitFields())
    {
        RegisterBitField *camBitField = RegisterBitField::fromParamBitField(bitField);
        cameraRegister->addBitField(camBitField);
    }

    return cameraRegister;
}
