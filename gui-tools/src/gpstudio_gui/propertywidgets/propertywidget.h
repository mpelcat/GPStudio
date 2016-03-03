#ifndef PROPERTYWIDGET_H
#define PROPERTYWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "camera/property.h"

class GPSTUDIO_GUI_EXPORT PropertyWidget : public QWidget
{
    Q_OBJECT
public:
    PropertyWidget();
    virtual ~PropertyWidget();

    Property *linkedProperty() const;
    virtual void setLinkedProperty(Property *linkedProperty);

    enum Type {Field, SimpleField, Group};
    virtual Type type() const =0;

public:
    static PropertyWidget *getWidgetFromProperty(Property *property);

protected:
    virtual void createWidget() =0;
    virtual void destroyWidget() =0;

signals:
    void valueChanged(QVariant value);

public slots:
    virtual void setValue(QVariant value) =0;

protected:
    Property *_linkedProperty;
};

#endif // PROPERTYWIDGET_H
