#ifndef PROPERTYBOOLWIDGET_H
#define PROPERTYBOOLWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class GPSTUDIO_GUI_EXPORT PropertyBoolWidget : public PropertyWidget
{
public:
    PropertyBoolWidget();
    virtual ~PropertyBoolWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();
};

#endif // PROPERTYBOOLWIDGET_H
