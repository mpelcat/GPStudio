#ifndef FLOWCONNECTION_H
#define FLOWCONNECTION_H

#include "gpstudio_lib_common.h"

#include "QWidget"
#include "datawrapper/datawrapper.h"

class GPSTUDIO_LIB_EXPORT FlowConnection
{
public:
    FlowConnection();

    int flowId() const;
    void setFlowId(int flowId);

    DataWrapper *wrapper() const;
    void setWrapper(DataWrapper *wrapper);

    QWidget *flowViewer() const;
    void setFlowViewer(QWidget *flowViewer);

private:
    int _flowId;
    DataWrapper *_wrapper;
    QWidget *_flowViewer;
};

#endif // FLOWCONNECTION_H
