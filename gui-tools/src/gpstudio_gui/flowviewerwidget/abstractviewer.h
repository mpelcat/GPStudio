#ifndef ABSTRACTVIEWER_H
#define ABSTRACTVIEWER_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "property.h"

class GPSTUDIO_GUI_EXPORT AbstractViewer
{
public:
    AbstractViewer();

    static AbstractViewer *fromDataTypeName(const QString &dataTypeName);

    const Property &properties() const;

protected:
    Property _properties;
};

#endif // ABSTRACTVIEWER_H
