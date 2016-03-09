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
    _node = NULL;
    _com = NULL;
    setNode(ModelNode::readFromFile(fileCameraConfig));
}

Camera::~Camera()
{
    delete _node;
    delete _com;
}

const ModelNode *Camera::node() const
{
    return _node;
}

void Camera::setNode(ModelNode *node)
{
    if(_node) delete _node;
    _node = node;

    if(!_node) return;

    _paramsBlocks.removeAllSubProperties();
    _paramsBlocks.setName(node->name());

    foreach (ModelBlock *modelBlock, _node->blocks())
    {
        Block *block = Block::fromModelBlock(modelBlock);

        _blocks.append(block);
        _blocksMap.insert(block->name(), block);

        _paramsBlocks.addSubProperty(block->assocProperty());

        // TODO move this part to dynamic model
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
    }

    ScriptEngine::getEngine().setRootProperty(&_paramsBlocks);

    _registermanager.start();

    _flowManager = new FlowManager(_node, &_paramsBlocks);
}

const Property &Camera::rootProperty() const
{
    return _paramsBlocks;
}

Property &Camera::rootProperty()
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

const QList<Block*> &Camera::blocks() const
{
    return _blocks;
}

Block *Camera::block(int i) const
{
    if(i<_blocks.count()) return _blocks[i];
    return NULL;
}

Block *Camera::block(QString name) const
{
    QMap<QString, Block*>::const_iterator localConstFind = _blocksMap.constFind(name);
    if(localConstFind!=_blocksMap.constEnd()) return *localConstFind;
    return NULL;
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
