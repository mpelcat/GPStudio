#ifndef PROPERTYMATRIXWIDGET_H
#define PROPERTYMATRIXWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QSpinBox;

class GPSTUDIO_GUI_EXPORT PropertyMatrixWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyMatrixWidget();
    virtual ~PropertyMatrixWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);
};

#endif // PROPERTYMATRIXWIDGET_H
