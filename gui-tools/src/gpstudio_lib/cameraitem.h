#ifndef CAMERAITEM_H
#define CAMERAITEM_H

#include "gpstudio_lib_common.h"

#include <QList>

class Camera;
class Block;
class Flow;

class GPSTUDIO_LIB_EXPORT CameraItem
{
public:
    CameraItem();
    CameraItem(const Camera *camera);
    CameraItem(const Block *block);
    CameraItem(const Flow *flow);
    ~CameraItem();

    enum Type {
        CameraType,
        BlockType,
        FlowType,

        NullType
    };

    Type type() const;

    const Camera *camera() const;
    const Block *block() const;
    const Flow *flow() const;

    const QList<CameraItem*> &childrens() const;
    const CameraItem *children(int i) const;
    int count() const;

    CameraItem *append(const Camera *camera);
    CameraItem *append(const Block *block);
    CameraItem *append(const Flow *flow);

    int row();
    void *ptr() const;
    CameraItem *parent() const;

protected:
    Type _type;
    const void *_ptr;

    int _row;
    CameraItem *_parent;

    QList<CameraItem*> _childrens;
};

#endif // CAMERAITEM_H
