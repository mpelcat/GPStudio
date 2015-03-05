#include "propertyenumwidget.h"

#include <QVBoxLayout>
#include <QComboBox>

PropertyEnumWidget::PropertyEnumWidget()
{
}

PropertyEnumWidget::~PropertyEnumWidget()
{
}

PropertyWidget::Type PropertyEnumWidget::type() const
{
    return Field;
}

void PropertyEnumWidget::createWidget()
{
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    if(_linkedProperty->value().canConvert(QVariant::Map))
    {
        const QMap<QString, QVariant> enums = _linkedProperty->value().toMap();
        QComboBox *combo = new QComboBox();

        QMapIterator<QString, QVariant> i(enums);
        while (i.hasNext())
        {
            i.next();
            combo->addItem(i.key(), i.value());
        }

        layout->addWidget(combo);
    }

    setLayout(layout);
}

void PropertyEnumWidget::destroyWidget()
{
}
