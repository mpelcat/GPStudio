#ifndef CIBLOCK_H
#define CIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"

class GPSTUDIO_LIB_EXPORT CIBlock : public Block
{
public:
    CIBlock();
    virtual ~CIBlock();

    QString type() const;

public:
    static CIBlock *fromNodeGenerated(const QDomElement &domElement, CIBlock *ciBlock=NULL);
};

#endif // CIBLOCK_H
