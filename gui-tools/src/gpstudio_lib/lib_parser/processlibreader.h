#ifndef PROCESSLIBREADER_H
#define PROCESSLIBREADER_H

#include "gpstudio_lib_common.h"

#include <QString>
#include "lib.h"
#include "processlib.h"

class GPSTUDIO_LIB_EXPORT ProcessLibReader
{
public:
    static void readFromPath(const QString &path, Lib &lib);
    static void readProcessLib(const QString &configFile, ProcessLib &processType);
};

#endif // PROCESSLIBREADER_H
