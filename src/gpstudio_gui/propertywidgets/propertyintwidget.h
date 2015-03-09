#ifndef PROPERTYINTWIDGET_H
#define PROPERTYINTWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QSpinBox;

class GPSTUDIO_GUI_EXPORT PropertyIntWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyIntWidget();
    virtual ~PropertyIntWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);

private:
    QSpinBox *_spinBox;
};

#endif // PROPERTYINTWIDGET_H
