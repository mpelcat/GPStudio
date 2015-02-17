#include "lib.h"

#include <QDebug>

#include "processlibreader.h"

Lib::Lib(const QString &path)
{
    qDebug()<<path;

    ProcessLibReader::readFromPath(path, *this);
}

Lib::~Lib()
{

}

void Lib::addProcess(const ProcessLib &lib)
{
    _process.append(lib);
}

