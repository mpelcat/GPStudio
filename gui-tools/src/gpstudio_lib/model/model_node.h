#ifndef NODE_H
#define NODE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

#include "model_block.h"

class ModelFIBlock;
class ModelCIBlock;
class ModelPIBlock;
class ModelIOCom;

class GPSTUDIO_LIB_EXPORT ModelNode
{
public:
    ModelNode();
    ~ModelNode();

    QString name() const;
    void setName(const QString &name);

    bool isValid() const;

    QList<ModelBlock *> &blocks();
    const QList<ModelBlock *> &blocks() const;
    void addBlock(ModelBlock *block);

    ModelFIBlock *getFIBlock() const;
    ModelCIBlock *getCIBlock() const;
    ModelPIBlock *getPIBlock() const;
    ModelIOCom *getIOCom() const;

public:
    static ModelNode *readFromFile(const QString &fileName);
    static ModelNode *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    bool _valid;

    QList<ModelBlock *> _blocks;
};

#endif // NODE_H
