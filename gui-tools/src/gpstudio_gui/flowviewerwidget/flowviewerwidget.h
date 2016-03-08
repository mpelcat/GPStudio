#ifndef FLOWVIEWERWIDGET_H
#define FLOWVIEWERWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>
#include <QSharedPointer>
#include <QMutex>
#include <QMutexLocker>

#include "flowviewerinterface.h"
#include "abstractviewer.h"

class GPSTUDIO_GUI_EXPORT   FlowViewerWidget : public QWidget
{
    Q_OBJECT
public:
    explicit FlowViewerWidget(FlowViewerInterface *flowViewerInterface);
    FlowViewerWidget(const FlowViewerWidget &other);
    ~FlowViewerWidget();

    FlowViewerWidget &operator= (const FlowViewerWidget &other);

signals:

public slots:

private:
    QSharedPointer<FlowViewerInterface> _flowViewerInterface;
    AbstractViewer *_viewer;
    QMutex _viewerMutex;
};

#endif // FLOWVIEWERWIDGET_H
