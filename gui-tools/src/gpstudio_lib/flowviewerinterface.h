#ifndef FLOWVIEWERINTERFACE_H
#define FLOWVIEWERINTERFACE_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QList>

#include "camera/flowconnection.h"

class GPSTUDIO_LIB_EXPORT FlowViewerInterface : public QObject
{
    Q_OBJECT
public:
    explicit FlowViewerInterface(FlowConnection *flowConnection);
    FlowViewerInterface(const QList<FlowConnection *> &flowConnections=QList<FlowConnection *>());
    ~FlowViewerInterface();

    // flowConnections access and management
    const QList<FlowConnection *> &flowConnections() const;
    void addFlowConnection(FlowConnection *flowConnection);
    void removeFlowConnection(FlowConnection *flowConnection);
    void moveFlowConnection(FlowConnection *flowConnection, int index);

signals:
    void dataTypeChanged();
    void dataReceived();

protected slots:
    void changeDataType();

private:
    QList<FlowConnection *> _flowConnections;
};

#endif // FLOWVIEWERINTERFACE_H
