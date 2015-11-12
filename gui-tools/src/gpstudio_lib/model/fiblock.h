#ifndef FIBLOCK_H
#define FIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"

class GPSTUDIO_LIB_EXPORT FIBlock : public Block
{
public:
    FIBlock();
    virtual ~FIBlock();

    QString type() const;

public:
    static FIBlock *fromNodeGenerated(const QDomElement &domElement, FIBlock *fiBlock=NULL);
};

#endif // FIBLOCK_H
