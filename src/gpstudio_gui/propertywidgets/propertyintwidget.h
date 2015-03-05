#ifndef PROPERTYINTWIDGET_H
#define PROPERTYINTWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class GPSTUDIO_GUI_EXPORT PropertyIntWidget : public PropertyWidget
{
public:
    PropertyIntWidget();
    virtual ~PropertyIntWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();
};

#endif // PROPERTYINTWIDGET_H
