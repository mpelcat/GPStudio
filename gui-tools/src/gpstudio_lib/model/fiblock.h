#ifndef FIBLOCK_H
#define FIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "block.h"
#include "flowconnect.h"
#include "treeconnect.h"

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

    QList<TreeConnect *> treeConnects();
    const QList<TreeConnect *> treeConnects() const;
    void addTreeConnect(TreeConnect *treeConnect);
    void addTreeConnects(const QList<TreeConnect *> &treeConnects);

public:
    static FIBlock *fromNodeGenerated(const QDomElement &domElement, FIBlock *fiBlock=NULL);

protected:
    QList<FlowConnect *> _flowConnects;
    QList<TreeConnect *> _treeConnects;
};

#endif // FIBLOCK_H
