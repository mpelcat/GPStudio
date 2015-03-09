#ifndef BOARDLIB_H
#define BOARDLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>

class GPSTUDIO_LIB_EXPORT BoardLib
{
public:
    BoardLib();

    QString name() const;
    void setName(const QString &name);

public:
    static BoardLib *readFromFile(const QString &fileName);
    static BoardLib *fromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;
};

#endif // BOARDLIB_H
