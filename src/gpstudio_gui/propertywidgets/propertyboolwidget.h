#ifndef PROPERTYBOOLWIDGET_H
#define PROPERTYBOOLWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QCheckBox;

class GPSTUDIO_GUI_EXPORT PropertyBoolWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyBoolWidget();
    virtual ~PropertyBoolWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);

private:
    QCheckBox *_checkBox;
};

#endif // PROPERTYBOOLWIDGET_H
