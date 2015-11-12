#ifndef IOLIB_H
#define IOLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>
#include <QIcon>

class GPSTUDIO_LIB_EXPORT IOLib
{
public:
    IOLib();

    QString name() const;
    void setName(const QString &name);

    QString description() const;
    void setDescription(const QString &description);

    QString categ() const;
    void setCateg(const QString &categ);

    QString path() const;
    void setPath(const QString &path);

    QString configFile() const;
    void setConfigFile(const QString &configFile);

    QString draw() const;
    void setDraw(const QString &draw);

    QIcon icon() const;
    void setIcon(const QIcon &icon);

public:
    static IOLib *readFromFile(const QString &fileName);
    static IOLib *fromDomElement(const QDomElement &domElement);

private:
    QString _name;
    QString _categ;
    QString _path;
    QString _configFile;
    QString _description;
    QString _draw;
    QIcon _icon;
};

#endif // IOLIB_H
