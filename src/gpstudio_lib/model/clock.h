#ifndef CLOCK_H
#define CLOCK_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT Clock
{
public:
    Clock();
    ~Clock();

    QString name() const;
    void setName(const QString &name);

    QString group() const;
    void setGroup(const QString &group);

    qint16 shift() const;
    void setShift(const qint16 &shift);

    qint32 min() const;
    void setMin(const qint32 &min);

    qint32 max() const;
    void setMax(const qint32 &max);

    qint32 typical() const;
    void setTypical(const qint32 &typical);

    QString description() const;
    void setDescription(const QString &description);

public:
    static Clock *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _group;
    qint16 _shift;
    qint32 _min;
    qint32 _max;
    qint32 _typical;
    QString _description;
};

#endif // CLOCK_H
