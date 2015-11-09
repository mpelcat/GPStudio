#ifndef PROPERTYGROUPWIDGET_H
#define PROPERTYGROUPWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class GPSTUDIO_GUI_EXPORT PropertyGroupWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyGroupWidget();
    virtual ~PropertyGroupWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);
};

#endif // PROPERTYGROUPWIDGET_H
