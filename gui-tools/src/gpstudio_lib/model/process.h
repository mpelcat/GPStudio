#ifndef PROCESS_H
#define PROCESS_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"

class GPSTUDIO_LIB_EXPORT Process : public Block
{
public:
    Process();
    virtual ~Process();

    QString type() const;

public:
    static Process *fromNodeGenerated(const QDomElement &domElement, Process *process=NULL);
};

#endif // PROCESS_H
