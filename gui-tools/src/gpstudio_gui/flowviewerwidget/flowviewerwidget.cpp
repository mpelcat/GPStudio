#include "flowviewerwidget.h"

#include <QDebug>

//#define __FLOW_DEBUG__

FlowViewerWidget::FlowViewerWidget(FlowViewerInterface *flowViewerInterface) :
    QWidget(NULL),
    _flowViewerInterface(flowViewerInterface),
    _viewer(NULL)
{
#ifdef __FLOW_DEBUG__
    qDebug()<<"-- construct widget";
#endif
}

FlowViewerWidget::FlowViewerWidget(const FlowViewerWidget &other) :
    QWidget(NULL),
    _flowViewerInterface(other._flowViewerInterface),
    _viewer(other._viewer)
{
#ifdef __FLOW_DEBUG__
    qDebug()<<"-- copy widget";
#endif
}

FlowViewerWidget::~FlowViewerWidget()
{
#ifdef __FLOW_DEBUG__
    qDebug()<<"-- destruct widget";
#endif
}

FlowViewerWidget &FlowViewerWidget::operator=(const FlowViewerWidget &other)
{
    _flowViewerInterface = other._flowViewerInterface;
    return *this;
}

//QMutexLocker _viewerLock;
