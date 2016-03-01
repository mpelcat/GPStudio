#ifndef FILE_H
#define FILE_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelFile
{
public:
    ModelFile(ModelBlock *parent=NULL);
    ~ModelFile();

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

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

public:
    static ModelFile *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelFile *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _type;
    QString _group;
    QString _path;
    QString _description;

    ModelBlock *_parent;
};

#endif // FILE_H
