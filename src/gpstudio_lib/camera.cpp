#include "camera.h"

#include <QDebug>
#include <QStringList>

#include "property.h"
#include "propertyclass.h"

Camera::Camera(const QString &fileCameraConfig)
    : _registers(this)
{
    _paramsBlocks = NULL;
    _node = NULL;
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
        propBlock->setCaption(block->name());
        propBlock->setType(Property::Group);
        foreach (BlockProperty *property, block->properties())
        {
            Property *paramprop = Property::fromBlockProperty(property);
            propBlock->addSubProperty(paramprop);
        }
        _paramsBlocks->addSubProperty(propBlock);

        foreach (Param *param, block->params())
        {
            if(param->isDynamicParam())
            {
                CameraRegister *cameraRegister = CameraRegister::fromParam(param);
                //cameraRegister->dependsProperties();
                _registers.addRegister(cameraRegister);
            }
        }
    }

    foreach (Property *property, _paramsBlocks->subProperties().properties())
    {
        PropertyClass *prop=new PropertyClass(&_engine, property);
        QScriptValue value = _engine.newObject(prop);
        _engine.globalObject().setProperty(property->name(), value);
    }

    QMapIterator<uint, CameraRegister *> it(_registers.registersMap());
    while (it.hasNext())
    {
        it.next();
        CameraRegister *cameraRegister = it.value();

        const QStringList &deps = cameraRegister->dependsProperties();
        foreach (QString propName, deps)
        {
            Property *prop = _paramsBlocks->path(cameraRegister->blockName()+"."+propName);
            if(prop) connect(prop, SIGNAL(valueChanged(QVariant)), cameraRegister, SLOT(eval()));
        }

        connect(cameraRegister, SIGNAL(registerChange(uint,uint)), this, SLOT(setRegister(uint,uint)));
    }
}

Property *Camera::paramsBlocks() const
{
    return _paramsBlocks;
}

CameraRegistersMap &Camera::registers()
{
    return _registers;
}

uint Camera::evalPropertyMap(QString propertyMap, QString blockContext)
{
    QScriptValue global;
    if(!blockContext.isEmpty())
    {
        global = _engine.globalObject();
        _engine.currentContext()->setThisObject(_engine.globalObject().property(blockContext));
    }

    const QScriptValue &result = _engine.evaluate(propertyMap);

    if(!blockContext.isEmpty()) _engine.setGlobalObject(global);

    return result.toUInt32();
}

void Camera::setRegister(uint addr, uint value)
{
    qDebug()<<"setReg"<<addr<<value;
    if(_com) _com->writeParam(addr, value);
}

CameraCom *Camera::com() const
{
    return _com;
}

QScriptEngine *Camera::engine()
{
    return &_engine;
}

bool Camera::isConnected() const
{
    return _com != NULL;
}

void Camera::connectCam(const CameraInfo &cameraInfo)
{
    _com = new CameraCom(cameraInfo);
}
