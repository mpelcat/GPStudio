#include "flowviewerwidget.h"

#include <QDebug>

FlowViewerWidget::FlowViewerWidget(FlowViewerInterface *flowViewerInterface) :
    QWidget(NULL),
    _flowViewerInterface(flowViewerInterface),
    _viewer(NULL)
{
    qDebug()<<"-- construct widget";
}

FlowViewerWidget::FlowViewerWidget(const FlowViewerWidget &other) :
    QWidget(NULL),
    _flowViewerInterface(other._flowViewerInterface),
    _viewer(other._viewer)
{
    qDebug()<<"-- copy widget";
}

FlowViewerWidget::~FlowViewerWidget()
{
    qDebug()<<"-- destruct widget";
}

FlowViewerWidget &FlowViewerWidget::operator=(const FlowViewerWidget &other)
{
    _flowViewerInterface = other._flowViewerInterface;
    return *this;
}

//QMutexLocker _viewerLock;
