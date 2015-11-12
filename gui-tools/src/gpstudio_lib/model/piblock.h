#ifndef PIBLOCK_H
#define PIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"

class GPSTUDIO_LIB_EXPORT PIBlock : public Block
{
public:
    PIBlock();
    virtual ~PIBlock();

    QString type() const;

public:
    static PIBlock *fromNodeGenerated(const QDomElement &domElement, PIBlock *piBlock=NULL);
};

#endif // PIBLOCK_H
