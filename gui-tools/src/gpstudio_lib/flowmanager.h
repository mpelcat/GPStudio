#ifndef FLOWMANAGER_H
#define FLOWMANAGER_H

#include "gpstudio_lib_common.h"

#include "model/model_node.h"
#include "flowconnection.h"
#include "cameracom.h"

#include "model/model_fiblock.h"
#include "model/model_iocom.h"
#include "property.h"

#include <QMap>

class GPSTUDIO_LIB_EXPORT FlowManager : public QObject
{
    Q_OBJECT
public:
    FlowManager(ModelNode *node, Property *paramProperties);

    ModelNode *node() const;
    void setNode(ModelNode *node);

    CameraCom *com() const;
    void setCom(CameraCom *com);

    const QMap<int, FlowConnection* > flowConnectionsID() const;
    void addFlowConnection(FlowConnection *flowConnection);

private:
    ModelNode *_node;
    CameraCom *_com;
    QMap<int, FlowConnection* > _flowConnectionsID;

    ModelIOCom *_blockCom;
    ModelFIBlock *_fi;
    Property *_paramProperties;

public slots:
    void processFlow(int idFlow);
};

#endif // FLOWMANAGER_H
