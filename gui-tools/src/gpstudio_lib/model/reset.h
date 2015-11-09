#ifndef RESET_H
#define RESET_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class Block;

class GPSTUDIO_LIB_EXPORT Reset
{
public:
    Reset(Block *parent=NULL);
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

    Block *parent() const;
    void setParent(Block *parent);

public:
    static Reset *fromNodeGenerated(const QDomElement &domElement);
    static QList<Reset *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _group;
    Direction _direction;
    QString _description;

    Block *_parent;
};

#endif // RESET_H
