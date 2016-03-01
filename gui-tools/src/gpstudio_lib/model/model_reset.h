#ifndef RESET_H
#define RESET_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class ModelBlock;

class GPSTUDIO_LIB_EXPORT ModelReset
{
public:
    ModelReset(ModelBlock *parent=NULL);
    ~ModelReset();

    enum Direction {DirUndef, DirIn, DirOut};

    QString name() const;
    void setName(const QString &name);

    QString group() const;
    void setGroup(const QString &group);

    Direction direction() const;
    void setDirection(const Direction &direction);

    QString description() const;
    void setDescription(const QString &description);

    ModelBlock *parent() const;
    void setParent(ModelBlock *parent);

public:
    static ModelReset *fromNodeGenerated(const QDomElement &domElement);
    static QList<ModelReset *> listFromNodeGenerated(const QDomElement &domElement);

protected:
    QString _name;
    QString _group;
    Direction _direction;
    QString _description;

    ModelBlock *_parent;
};

#endif // RESET_H
