#ifndef FLOWMANAGER_H
#define FLOWMANAGER_H

#include "gpstudio_lib_common.h"

#include "model/node.h"
#include "flowconnection.h"
#include "cameracom.h"

#include "model/fiblock.h"
#include "model/iocom.h"
#include "property.h"

#include <QMap>

class GPSTUDIO_LIB_EXPORT FlowManager : public QObject
{
    Q_OBJECT
public:
    FlowManager(Node *node, Property *paramProperties);

    Node *node() const;
    void setNode(Node *node);

    CameraCom *com() const;
    void setCom(CameraCom *com);

    const QMap<int, FlowConnection* > flowConnectionsID() const;
    void addFlowConnection(FlowConnection *flowConnection);

private:
    Node *_node;
    CameraCom *_com;
    QMap<int, FlowConnection* > _flowConnectionsID;

    IOCom *_blockCom;
    FIBlock *_fi;
    Property *_paramProperties;

public slots:
    void processFlow(int idFlow);
};

#endif // FLOWMANAGER_H
