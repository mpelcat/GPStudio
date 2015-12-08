#ifndef FLOWCONNECTION_H
#define FLOWCONNECTION_H

#include "gpstudio_lib_common.h"

#include <QWidget>
#include "model/flow.h"
#include "datawrapper/datawrapper.h"
#include <QDateTime>

class GPSTUDIO_LIB_EXPORT FlowConnection
{
public:
    FlowConnection();

    int flowId() const;
    void setFlowId(int flowId);

    Flow *flow() const;
    void setFlow(Flow *flow);

    DataWrapper *wrapper() const;
    void setWrapper(DataWrapper *wrapper);

    QWidget *flowViewer() const;
    void setFlowViewer(QWidget *flowViewer);

    void recImg();
    float fps() const;

private:
    int _flowId;
    Flow *_flow;
    DataWrapper *_wrapper;
    QWidget *_flowViewer;

    QDateTime _prevImgReceive;
    float _fps;
};

#endif // FLOWCONNECTION_H
