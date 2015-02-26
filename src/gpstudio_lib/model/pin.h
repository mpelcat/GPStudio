#ifndef PIN_H
#define PIN_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT Pin
{
public:
    Pin();
    ~Pin();

    QString name() const;
    void setName(const QString &name);

    QString mapTo() const;
    void setMapTo(const QString &mapTo);

public:
    static Pin *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _mapTo;
};

#endif // PIN_H
