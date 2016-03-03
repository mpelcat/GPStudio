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
    explicit FlowViewerInterface(const FlowConnection &flowConnection);
    FlowViewerInterface(const QList<FlowConnection> &flowConnections=QList<FlowConnection>());
    ~FlowViewerInterface();

    const QList<FlowConnection> &flowConnections() const;

signals:
    void dataTypeChanged();

private:
    QList<FlowConnection> _flowConnections;
    void updateFlowConnection();
};

#endif // FLOWVIEWERINTERFACE_H
