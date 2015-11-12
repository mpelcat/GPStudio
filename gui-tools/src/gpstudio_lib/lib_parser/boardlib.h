#ifndef BOARDLIB_H
#define BOARDLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>
#include <QMap>

#include "ioboardlib.h"
#include "iolibgroup.h"

class GPSTUDIO_LIB_EXPORT BoardLib
{
public:
    BoardLib();

    QString name() const;
    void setName(const QString &name);

    QList<IOBoardLib *> &ios();
    const QList<IOBoardLib *> &ios() const;
    void addIO(IOBoardLib *io);
    void addIOs(const QList<IOBoardLib *> &ios);
    IOBoardLib *io(const QString &name) const;
    const QMap<QString, IOLibGroup> &iosGroups() const;

public:
    static BoardLib *readFromFile(const QString &fileName);
    static BoardLib *fromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;

    QList<IOBoardLib *> _ios;
    QMap<QString, IOBoardLib *> _iosMap;
    QMap<QString, IOLibGroup> _iosGroups;
};

#endif // BOARDLIB_H
