#ifndef PROPERTYCOMPLETER_H
#define PROPERTYCOMPLETER_H

#include <QCompleter>

#include "propertyitemmodel.h"

class GPSTUDIO_GUI_EXPORT PropertyCompleter : public QCompleter
{
    Q_OBJECT
public:
    PropertyCompleter(QObject *parent, const Property *rootProperty);

    // QCompleter interface
public:
    QStringList splitPath(const QString &path) const;
    QString pathFromIndex(const QModelIndex &index) const;
};

#endif // PROPERTYCOMPLETER_H
