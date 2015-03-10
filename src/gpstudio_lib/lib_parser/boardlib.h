#ifndef BOARDLIB_H
#define BOARDLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

#include "iolib.h"

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

public:
    static BoardLib *readFromFile(const QString &fileName);
    static BoardLib *fromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;

    QList<IOLib *> _ios;
};

#endif // BOARDLIB_H
