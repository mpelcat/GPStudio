#ifndef NODE_H
#define NODE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

#include "block.h"

class FIBlock;
class CIBlock;
class PIBlock;
class IOCom;

class GPSTUDIO_LIB_EXPORT Node
{
public:
    Node();
    ~Node();

    QString name() const;
    void setName(const QString &name);

    bool isValid() const;

    QList<Block *> &blocks();
    const QList<Block *> &blocks() const;
    void addBlock(Block *block);

    FIBlock *getFIBlock() const;
    CIBlock *getCIBlock() const;
    PIBlock *getPIBlock() const;
    IOCom *getIOCom() const;

public:
    static Node *readFromFile(const QString &fileName);
    static Node *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    bool _valid;

    QList<Block *> _blocks;
};

#endif // NODE_H
