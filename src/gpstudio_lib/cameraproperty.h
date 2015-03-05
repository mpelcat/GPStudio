#ifndef CAMERAPROPERTY_H
#define CAMERAPROPERTY_H

#include "gpstudio_lib_common.h"
#include "model/blockproperty.h"

#include <QObject>
#include <QVariant>

#include "property.h"

class GPSTUDIO_LIB_EXPORT CameraProperty : public Property
{
public:
    CameraProperty(QString name=QString());
    virtual ~CameraProperty();

    unsigned int getAddr() const;
    void setAddr(unsigned int value);

public:
    static CameraProperty *fromBlockProperty(BlockProperty *blockProperty);

public slots:

protected:
    unsigned int addr;
};

#endif // CAMERAPROPERTY_H
