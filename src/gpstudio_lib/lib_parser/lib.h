#ifndef LIB_H
#define LIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>

#include "processlib.h"

class GPSTUDIO_LIB_EXPORT Lib
{
public:
    Lib(const QString &libPath);
    ~Lib();

    void addProcess(const ProcessLib &lib);

private:
    QList<ProcessLib> _process;
};

#endif // LIB_H
