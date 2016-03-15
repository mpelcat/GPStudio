#ifndef FLOWMANAGER_H
#define FLOWMANAGER_H

#include "gpstudio_lib_common.h"
#include "property.h"

#include <QMap>
#include <QList>

class Block;
class FlowConnection;

class GPSTUDIO_LIB_EXPORT FlowManager : public QObject
{
    Q_OBJECT
public:
    FlowManager(Camera *camera);

    Camera *camera() const;
    void setCamera(Camera *camera);

    const QMap<int, FlowConnection* > flowConnectionsMap() const;
    const QList<FlowConnection *> flowConnections() const;

private:
    void addFlowConnection(FlowConnection *flowConnection);

public slots:
    void processFlow(int idFlow);

private:
    QMap<int, FlowConnection* > _flowConnectionsMap;
    QList<FlowConnection* > _flowConnections;

    Block *_blockCom;
    Block *_fi;
    Camera *_camera;
};

#endif // FLOWMANAGER_H
