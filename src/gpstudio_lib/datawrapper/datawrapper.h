#ifndef DATAWRAPPER_H
#define DATAWRAPPER_H

#include "gpstudio_lib_common.h"

#include <QImage>

class GPSTUDIO_LIB_EXPORT DataWrapper
{
public:
    DataWrapper();
    virtual ~DataWrapper();

    virtual QImage *transform(QImage *input) =0;
};

#endif // DATAWRAPPER_H
