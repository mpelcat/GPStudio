#ifndef PROPERTYENUMWIDGET_H
#define PROPERTYENUMWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class GPSTUDIO_GUI_EXPORT PropertyEnumWidget : public PropertyWidget
{
public:
    PropertyEnumWidget();
    virtual ~PropertyEnumWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();
};

#endif // PROPERTYENUMWIDGET_H
