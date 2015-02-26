#ifndef RESET_H
#define RESET_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT Reset
{
public:
    Reset();
    ~Reset();

    enum Direction {DirUndef, DirIn, DirOut};

    QString name() const;
    void setName(const QString &name);

    QString group() const;
    void setGroup(const QString &group);

    Direction direction() const;
    void setDirection(const Direction &direction);

    QString description() const;
    void setDescription(const QString &description);

public:
    static Reset *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _group;
    Direction _direction;
    QString _description;
};

#endif // RESET_H
