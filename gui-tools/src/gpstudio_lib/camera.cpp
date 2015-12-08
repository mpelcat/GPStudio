#include "camera.h"

#include <QDebug>
#include <QStringList>

#include "property.h"
#include "propertyclass.h"

#include "flowmanager.h"

Camera::Camera(const QString &fileCameraConfig)
    : _registers(this)
{
    _paramsBlocks = NULL;
    _node = NULL;
    _com = NULL;
    setNode(Node::readFromFile(fileCameraConfig));
}

Camera::~Camera()
{
    delete _node;
    delete _paramsBlocks;
    delete _com;
}

Node *Camera::node() const
{
    return _node;
}

void Camera::setNode(Node *node)
{
    if(_node) delete _node;
    _node = node;

    if(_paramsBlocks) delete _paramsBlocks;
    _paramsBlocks = new Property();

    foreach (Block *block, _node->blocks())
    {
        Property *propBlock = new Property(block->name());
        propBlock->setCaption(block->name() + " (" + block->driver() + ")");
        propBlock->setType(Property::Group);
        foreach (BlockProperty *property, block->properties())
        {
            Property *paramprop = Property::fromBlockProperty(property);
            propBlock->addSubProperty(paramprop);
        }
        foreach (Flow *flow, block->flows())
        {
            Property *flowprop = Property::fromFlow(flow);
            propBlock->addSubProperty(flowprop);
        }

        _paramsBlocks->addSubProperty(propBlock);
        _engine.addProperty(propBlock);

        foreach (Param *param, block->params())
        {
            if(param->isDynamicParam())
            {
                CameraRegister *cameraRegister = CameraRegister::fromParam(param);
                _registers.addRegister(cameraRegister);
            }
        }
    }

    foreach (Property *property, _paramsBlocks->subProperties().properties())
    {
        property->computePropertyMap(_paramsBlocks);
    }

    int maxAddr=0;
    QMapIterator<uint, CameraRegister *> it(_registers.registersMap());
    while (it.hasNext())
    {
        it.next();
        CameraRegister *cameraRegister = it.value();

        if(cameraRegister->addr()>maxAddr) maxAddr=cameraRegister->addr();

        //if(cameraRegister->bitFields().count())
        {
            const QStringList &deps = cameraRegister->dependsProperties();
            foreach (QString propName, deps)
            {
                Property *prop = _paramsBlocks->path(cameraRegister->blockName()+"."+propName);
                if(prop) connect(prop, SIGNAL(bitsChanged(uint)), cameraRegister, SLOT(eval()));
            }
        }
        //else
        {
            foreach (CameraRegisterBitField *bitField, cameraRegister->bitFields())
            {
                const QStringList &deps = bitField->dependsProperties();
                foreach (QString propName, deps)
                {
                    Property *prop = _paramsBlocks->path(cameraRegister->blockName()+"."+propName);
                    if(prop) connect(prop, SIGNAL(bitsChanged(uint)), bitField, SLOT(eval()));
                }
            }
        }

        _registerData.fill(0,(maxAddr+1)*4);
        connect(cameraRegister, SIGNAL(registerChange(uint,uint)), this, SLOT(setRegister(uint,uint)));
    }

    _flowManager = new FlowManager(_node, _paramsBlocks);
}

Property *Camera::paramsBlocks() const
{
    return _paramsBlocks;
}

CameraRegistersMap &Camera::registers()
{
    return _registers;
}

ScriptEngine *Camera::engine()
{
    return &_engine;
}

uint Camera::evalPropertyMap(const QString &propertyMap, const QString &blockContext)
{
    return _engine.evalPropertyMap(propertyMap, blockContext);
}

void Camera::setRegister(uint addr, uint value)
{
    qDebug()<<"setReg"<<addr<<value;
    if(_com)
    {
        if(_com->isConnected())
        {
            _com->writeParam(addr, value);

            _registerData.data()[addr*4+0]=value>>24;
            _registerData.data()[addr*4+1]=value>>16;
            _registerData.data()[addr*4+2]=value>>8;
            _registerData.data()[addr*4+3]=value;

            emit registerDataChanged();
        }
    }
}

QByteArray Camera::registerData() const
{
    return _registerData;
}

CameraCom *Camera::com() const
{
    return _com;
}

FlowManager *Camera::flowManager() const
{
    return _flowManager;
}

bool Camera::isConnected() const
{
    if(_com)
    {
        return _com->isConnected();
    }
    else return false;
}

void Camera::connectCam(const CameraInfo &cameraInfo)
{
    _com = new CameraCom(cameraInfo);

    if(_com->isConnected())
    {
        _registers.evalAll();
    }

    _flowManager->setCom(_com);
    connect(_com, SIGNAL(flowReadyToRead(int)), _flowManager, SLOT(processFlow(int)));
}
