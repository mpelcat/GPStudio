#ifndef ABSTRACTVIEWER_H
#define ABSTRACTVIEWER_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "camera/property.h"

class FlowViewerInterface;

class GPSTUDIO_GUI_EXPORT AbstractViewer : public QWidget
{
    Q_OBJECT
public:
    AbstractViewer(FlowViewerInterface *flowViewerInterface);

    const Property &properties() const;

public:
    static AbstractViewer *fromDataTypeName(const QString &dataTypeName);

protected:
    virtual void setupWidgets() =0;

protected:
    Property _properties;
};

#endif // ABSTRACTVIEWER_H
