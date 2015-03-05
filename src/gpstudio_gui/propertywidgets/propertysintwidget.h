#ifndef PROPERTYSINTWIDGET_H
#define PROPERTYSINTWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class GPSTUDIO_GUI_EXPORT PropertySIntWidget : public PropertyWidget
{
public:
    PropertySIntWidget();
    virtual ~PropertySIntWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();
};

#endif // PROPERTYSINTWIDGET_H
