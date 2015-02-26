#include "lib.h"

#include <QDebug>
#include <QDir>

#include "processlibreader.h"

Lib::Lib(const QString &libPath)
{
    QDir dir(QDir::currentPath()+'/'+libPath);
    qDebug()<<dir.absolutePath();

    ProcessLibReader::readFromPath(dir.absolutePath()+"/process", *this);
}

Lib::~Lib()
{

}

void Lib::addProcess(const ProcessLib &lib)
{
    _process.append(lib);
}

