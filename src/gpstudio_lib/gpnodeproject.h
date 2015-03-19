#ifndef GPNODEPROJECT_H
#define GPNODEPROJECT_H

#include "gpstudio_lib_common.h"

#include "lib_parser/lib.h"

class GPSTUDIO_LIB_EXPORT GPNodeProject
{
public:
    GPNodeProject();
    ~GPNodeProject();

    Lib *lib() const;

    QString name() const;
    void setName(const QString &name);

private:
    Lib *_lib;
    QString _name;
};

#endif // GPNODEPROJECT_H
