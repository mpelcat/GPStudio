#ifndef PROPERTYSINTWIDGET_H
#define PROPERTYSINTWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QSlider;
class QLabel;

class GPSTUDIO_GUI_EXPORT PropertySIntWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertySIntWidget();
    virtual ~PropertySIntWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);

private:
    QSlider *_slider;
    QLabel *_label;
};

#endif // PROPERTYSINTWIDGET_H
