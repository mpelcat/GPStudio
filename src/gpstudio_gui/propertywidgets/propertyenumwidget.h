#ifndef PROPERTYENUMWIDGET_H
#define PROPERTYENUMWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QComboBox;

class GPSTUDIO_GUI_EXPORT PropertyEnumWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyEnumWidget();
    virtual ~PropertyEnumWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);

protected slots:
    virtual void wrapValue(int value);

private:
    QComboBox *_comboBox;
};

#endif // PROPERTYENUMWIDGET_H
