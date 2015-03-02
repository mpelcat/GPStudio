#ifndef FILE_H
#define FILE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class Block;

class GPSTUDIO_LIB_EXPORT File
{
public:
    File(Block *parent=NULL);
    ~File();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    QString group() const;
    void setGroup(const QString &group);

    QString path() const;
    void setPath(const QString &path);

    QString description() const;
    void setDescription(const QString &description);

    Block *parent() const;
    void setParent(Block *parent);

public:
    static File *fromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    QString _group;
    QString _path;
    QString _description;

    Block *_parent;
};

#endif // FILE_H
