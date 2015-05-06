#ifndef DATAWRAPPER_H
#define DATAWRAPPER_H

#include "gpstudio_lib_common.h"

#include <QImage>
#include <flowdata.h>

class GPSTUDIO_LIB_EXPORT DataWrapper
{
public:
    DataWrapper();
    virtual ~DataWrapper();

    virtual QImage *transform(const FlowData &data) =0;
};

#endif // DATAWRAPPER_H
