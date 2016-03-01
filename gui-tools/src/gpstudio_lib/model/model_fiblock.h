#ifndef FIBLOCK_H
#define FIBLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>

#include "model_block.h"
#include "model_flowconnect.h"
#include "model_treeconnect.h"

class GPSTUDIO_LIB_EXPORT ModelFIBlock : public ModelBlock
{
public:
    ModelFIBlock();
    virtual ~ModelFIBlock();

    QString type() const;

    QList<ModelFlowConnect *> flowConnects();
    const QList<ModelFlowConnect *> flowConnects() const;
    void addFlowConnect(ModelFlowConnect *flowConnect);
    void addFlowConnects(const QList<ModelFlowConnect *> &flowConnects);

    QList<ModelTreeConnect *> treeConnects();
    const QList<ModelTreeConnect *> treeConnects() const;
    void addTreeConnect(ModelTreeConnect *treeConnect);
    void addTreeConnects(const QList<ModelTreeConnect *> &treeConnects);

public:
    static ModelFIBlock *fromNodeGenerated(const QDomElement &domElement, ModelFIBlock *fiBlock=NULL);

protected:
    QList<ModelFlowConnect *> _flowConnects;
    QList<ModelTreeConnect *> _treeConnects;
};

#endif // FIBLOCK_H
