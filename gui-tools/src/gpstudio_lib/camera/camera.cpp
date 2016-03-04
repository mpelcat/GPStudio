#include "camera.h"

#include <QDebug>
#include <QStringList>

#include "property.h"
#include "propertyclass.h"

#include "flowmanager.h"
#include "cameracom.h"

Camera::Camera(const QString &fileCameraConfig)
    : _registermanager(this)
{
    _paramsBlocks = NULL;
    _node = NULL;
    _com = NULL;
    setNode(ModelNode::readFromFile(fileCameraConfig));
}

Camera::~Camera()
{
    delete _node;
    delete _paramsBlocks;
    delete _com;
}

ModelNode *Camera::node() const
{
    return _node;
}

void Camera::setNode(ModelNode *node)
{
    if(_node) delete _node;
    _node = node;

    if(!_node) return;

    if(_paramsBlocks) delete _paramsBlocks;
    _paramsBlocks = new Property();

    foreach (ModelBlock *modelBlock, _node->blocks())
    {
        Property *propBlock = new Property(modelBlock->name());
        propBlock->setCaption(modelBlock->name() + " (" + modelBlock->driver() + ")");
        propBlock->setType(Property::Group);

        // block property
        foreach (ModelProperty *property, modelBlock->properties())
        {
            Property *paramprop = Property::fromModelProperty(property);
            propBlock->addSubProperty(paramprop);
        }

        // flow property
        foreach (ModelFlow *flow, modelBlock->flows())
        {
            Property *flowprop = Property::fromFlow(flow);
            propBlock->addSubProperty(flowprop);
        }

        // registers and const values
        foreach (ModelParam *param, modelBlock->params())
        {
            // register
            if(param->isDynamicParam())
            {
                Register *cameraRegister = Register::fromParam(param);
                _registermanager.addRegister(cameraRegister);
            }
            // const values
            else
            {
                // TODO add const value as RO property
            }
        }

        Block *block = Block::fromModelBlock(modelBlock);
        block->setAssocProperty(propBlock);
        _blocks.insert(block->name(), block);

        _paramsBlocks->addSubProperty(propBlock);
    }

    ScriptEngine::getEngine().setRootProperty(_paramsBlocks);

    _registermanager.start();

    _flowManager = new FlowManager(_node, _paramsBlocks);
}

Property *Camera::rootProperty() const
{
    return _paramsBlocks;
}

RegisterManager &Camera::registers()
{
    return _registermanager;
}

uint Camera::evalPropertyMap(const QString &propertyMap)
{
    return ScriptEngine::getEngine().evalPropertyMap(propertyMap).toUInt();
}

void Camera::setRegister(uint addr, uint value)
{
    _registermanager.setRegister(addr, value);
    emit registerDataChanged();
}

const QMap<QString, Block*> &Camera::blocks() const
{
    return _blocks;
}

QByteArray Camera::registerData() const
{
    return _registermanager.registerData();
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
        _registermanager.evalAll();
    }

    _flowManager->setCom(_com);
    connect(_com, SIGNAL(flowReadyToRead(int)), _flowManager, SLOT(processFlow(int)));
}
