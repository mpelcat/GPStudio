#ifndef DATAWRAPPER_H
#define DATAWRAPPER_H

#include "gpstudio_lib_common.h"

#include <QImage>
#include <flowpackage.h>

class GPSTUDIO_LIB_EXPORT DataWrapper
{
public:
    DataWrapper();
    virtual ~DataWrapper();

    virtual QImage *transform(const FlowPackage &data) =0;
};

#endif // DATAWRAPPER_H
