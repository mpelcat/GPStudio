#ifndef FLOWCONNECTION_H
#define FLOWCONNECTION_H

#include "gpstudio_lib_common.h"

#include <QWidget>
#include "model/model_flow.h"
#include "datawrapper/datawrapper.h"
#include <QDateTime>

class GPSTUDIO_LIB_EXPORT FlowConnection
{
public:
    FlowConnection();

    int flowId() const;
    void setFlowId(int flowId);

    ModelFlow *flow() const;
    void setFlow(ModelFlow *flow);

    void recImg();
    float fps() const;

private:
    int _flowId;
    ModelFlow *_flow;

    QDateTime _prevImgReceive;
    float _fps;
};

#endif // FLOWCONNECTION_H
