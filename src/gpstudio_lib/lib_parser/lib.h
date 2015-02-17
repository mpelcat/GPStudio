#ifndef LIB_H
#define LIB_H

#include <QString>
#include <QList>

#include "processlib.h"

class Lib
{
public:
    Lib(const QString &path);
    ~Lib();

    void addProcess(const ProcessLib &lib);

private:
    QList<ProcessLib> _process;
};

#endif // LIB_H
