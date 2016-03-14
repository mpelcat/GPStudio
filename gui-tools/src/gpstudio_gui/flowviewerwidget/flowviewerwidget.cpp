#include "flowviewerwidget.h"

#include <QBoxLayout>
#include <QStatusBar>

#include <QDebug>

FlowViewerWidget::FlowViewerWidget(FlowViewerInterface *flowViewerInterface) :
    QWidget(NULL),
    _flowViewerInterface(flowViewerInterface),
    _viewer(NULL)
{
    setupWidgets();
}

FlowViewerWidget::FlowViewerWidget(const FlowViewerWidget &other) :
    QWidget(NULL),
    _flowViewerInterface(other._flowViewerInterface),
    _viewer(other._viewer)
{
    setupWidgets();
}

FlowViewerWidget::~FlowViewerWidget()
{
}

FlowViewerWidget &FlowViewerWidget::operator=(const FlowViewerWidget &other)
{
    _flowViewerInterface = other._flowViewerInterface;
    return *this;
}

void FlowViewerWidget::setupWidgets()
{
    _layout = new QVBoxLayout();
    _layout->setContentsMargins(0,0,0,0);

    _viewer = new QWidget();
    _layout->addWidget(_viewer);

    // status
    _statusLayout = new QHBoxLayout();
    _statusLayout->setContentsMargins(0,0,0,0);

    _statusLabel = new QLabel("22 fps image 320*240px");
    _statusLayout->addWidget(_statusLabel);

    _typeComboBox = new QComboBox();
    _statusLayout->addWidget(_typeComboBox);
    _typeComboBox->addItem("image");
    _typeComboBox->addItem("hexa");

    _layout->addItem(_statusLayout);

    setLayout(_layout);
}

//QMutexLocker _viewerLock;
