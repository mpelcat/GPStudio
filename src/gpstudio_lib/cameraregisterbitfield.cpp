#include "cameraregisterbitfield.h"

#include "model/parambitfield.h"
#include "model/param.h"
#include "model/block.h"

#include "cameraregister.h"

#include "camera.h"

#include <QRegExp>
#include <QDebug>

CameraRegisterBitField::CameraRegisterBitField()
{
    _parent = NULL;
}

CameraRegisterBitField::~CameraRegisterBitField()
{

}

uint CameraRegisterBitField::mask() const
{
    return _mask;
}

void CameraRegisterBitField::setMask(const uint &mask)
{
    _mask = mask;
}

uint CameraRegisterBitField::value() const
{
    return _value;
}

void CameraRegisterBitField::setValue(const uint &value)
{
    uint projectedValue=0;

    uint mask = 1;
    for(int i=0; i<_bits.count(); i++)
    {
        if(value&mask) projectedValue|=(1<<_bits[_bits.count()-i-1]);
        else projectedValue&=(~(1<<_bits[_bits.count()-i-1]));
        mask<<=1;
    }
    _value = projectedValue;
    //qDebug()<<"setVal bf: "<<value<<projectedValue<<_bits<<_mask;
    emit bitfieldChange(_value, _mask);
}

QString CameraRegisterBitField::blockName() const
{
    return _blockName;
}

void CameraRegisterBitField::setBlockName(const QString &blockName)
{
    _blockName = blockName;
}

QString CameraRegisterBitField::propertyMap() const
{
    return _propertyMap;
}

void CameraRegisterBitField::setPropertyMap(const QString &propertyMap)
{
    _propertyMap = propertyMap;
}

QStringList CameraRegisterBitField::dependsProperties() const
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

const QList<uint> &CameraRegisterBitField::bits() const
{
    return _bits;
}

CameraRegisterBitField *CameraRegisterBitField::fromParamBitField(const ParamBitField *paramBitField)
{
    CameraRegisterBitField *cameraRegisterBitField = new CameraRegisterBitField();
    cameraRegisterBitField->setPropertyMap(paramBitField->propertyMap());
    if(paramBitField->parent())
    {
        if(paramBitField->parent()->parent()) cameraRegisterBitField->setBlockName(paramBitField->parent()->parent()->name());
    }

    cameraRegisterBitField->_bits=ParamBitField::listBitFromBitField(paramBitField->bitfield());

    uint mask = 0;
    foreach(uint bit, cameraRegisterBitField->_bits)
    {
        mask|=(1<<bit);
    }
    cameraRegisterBitField->_mask = mask;

    return cameraRegisterBitField;
}

void CameraRegisterBitField::eval()
{
    if(_parent)
    {
        if(_parent->camera())
        {
            setValue(_parent->camera()->evalPropertyMap(_propertyMap, _blockName));
        }
    }
}
CameraRegister *CameraRegisterBitField::parent() const
{
    return _parent;
}

void CameraRegisterBitField::setParent(CameraRegister *parent)
{
    _parent = parent;
}

