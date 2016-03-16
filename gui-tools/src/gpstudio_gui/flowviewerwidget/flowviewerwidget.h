#ifndef FLOWVIEWERWIDGET_H
#define FLOWVIEWERWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>
#include <QSharedPointer>
#include <QMutex>
#include <QMutexLocker>

#include <QLabel>
#include <QComboBox>

#include "flowviewerinterface.h"
#include "abstractviewer.h"

class GPSTUDIO_GUI_EXPORT FlowViewerWidget : public QWidget
{
    Q_OBJECT
public:
    explicit FlowViewerWidget(const QSharedPointer<FlowViewerInterface> &flowViewerInterface);
    FlowViewerWidget(FlowViewerInterface *flowViewerInterface);
    FlowViewerWidget(const FlowViewerWidget &other);
    ~FlowViewerWidget();

    FlowViewerWidget &operator= (const FlowViewerWidget &other);

signals:

protected slots:
    void changeType();

protected:
    void setupWidgets();

protected:
    QSharedPointer<FlowViewerInterface> _flowViewerInterface;
    QMutex _viewerMutex;

    QLayout *_layout;
    QWidget *_viewer;

    QLayout *_statusLayout;
    QLabel *_statusLabel;
    QComboBox *_typeComboBox;
};

#endif // FLOWVIEWERWIDGET_H
