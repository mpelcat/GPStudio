#ifndef FLOWCONNECTION_H
#define FLOWCONNECTION_H

#include "gpstudio_lib_common.h"

#include <QObject>
#include <QDateTime>

#include "flow.h"
#include "flowpackage.h"

class GPSTUDIO_LIB_EXPORT FlowConnection : public QObject
{
    Q_OBJECT
public:
    FlowConnection();

    int flowId() const;
    void setFlowId(int flowId);

    Flow *flow() const;
    void setFlow(Flow *flow);

    void recImg(FlowPackage data);
    float fps() const;

signals:
    void flowReceived(FlowPackage data);

private:
    int _flowId;
    Flow *_flow;

    FlowPackage _lastData;

    QDateTime _prevImgReceive;
    float _fps;
};

#endif // FLOWCONNECTION_H
