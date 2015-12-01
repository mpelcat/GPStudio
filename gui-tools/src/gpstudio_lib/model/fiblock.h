#ifndef FIBLOCK_H
#define FIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"
#include "flowconnect.h"

class GPSTUDIO_LIB_EXPORT FIBlock : public Block
{
public:
    FIBlock();
    virtual ~FIBlock();

    QString type() const;

    QList<FlowConnect *> flowConnects();
    const QList<FlowConnect *> flowConnects() const;
    void addFlowConnect(FlowConnect *flowConnect);
    void addFlowConnects(const QList<FlowConnect *> &flowConnects);

public:
    static FIBlock *fromNodeGenerated(const QDomElement &domElement, FIBlock *fiBlock=NULL);

protected:
    QList<FlowConnect *> _flowConnects;
};

#endif // FIBLOCK_H
