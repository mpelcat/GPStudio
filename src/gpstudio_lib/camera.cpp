#include "camera.h"

#include <QDebug>

#include "cameraproperty.h"

Camera::Camera(const QString &fileCameraConfig)
{
    _paramsBlocks = NULL;
    _node = NULL;
    setNode(Node::readFromFile(fileCameraConfig));
}

Camera::~Camera()
{
    delete _node;
    delete _paramsBlocks;
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
            Property *paramprop = CameraProperty::fromBlockProperty(property);
            propBlock->addSubProperty(paramprop);
        }
        _paramsBlocks->addSubProperty(propBlock);
    }
}

Property *Camera::paramsBlocks() const
{
    return _paramsBlocks;
}
