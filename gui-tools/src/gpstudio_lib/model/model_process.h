#ifndef PROCESS_H
#define PROCESS_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "model_block.h"

class GPSTUDIO_LIB_EXPORT ModelProcess : public ModelBlock
{
public:
    ModelProcess();
    virtual ~ModelProcess();

    QString type() const;

public:
    static ModelProcess *fromNodeGenerated(const QDomElement &domElement, ModelProcess *process=NULL);
};

#endif // PROCESS_H
