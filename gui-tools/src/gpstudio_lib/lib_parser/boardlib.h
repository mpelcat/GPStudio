#ifndef BOARDLIB_H
#define BOARDLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>
#include <QMap>

#include "iolib.h"
#include "iolibgroup.h"

class GPSTUDIO_LIB_EXPORT BoardLib
{
public:
    BoardLib();

    QString name() const;
    void setName(const QString &name);

    QList<IOLib *> &ios();
    const QList<IOLib *> &ios() const;
    void addIO(IOLib *io);
    void addIOs(const QList<IOLib *> &ios);
    IOLib *io(const QString &name) const;
    const QMap<QString, IOLibGroup> &iosGroups() const;

public:
    static BoardLib *readFromFile(const QString &fileName);
    static BoardLib *fromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;

    QList<IOLib *> _ios;
    QMap<QString, IOLib *> _iosMap;
    QMap<QString, IOLibGroup> _iosGroups;
};

#endif // BOARDLIB_H
