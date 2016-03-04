#ifndef FLOW_H
#define FLOW_H

#include "gpstudio_lib_common.h"

#include <QString>

class GPSTUDIO_LIB_EXPORT Flow
{
public:
    Flow();

    QString name() const;
    void setName(const QString &name);

private:
    QString _name;
};

#endif // FLOW_H
