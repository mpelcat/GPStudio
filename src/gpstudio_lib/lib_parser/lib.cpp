#include "lib.h"

#include <QDebug>
#include <QDir>

#include "processlibreader.h"

Lib::Lib(const QString &libPath)
{
    QDir dir(QDir::currentPath()+'/'+libPath);
    _path = dir.absolutePath();

    reloadBoards();
}

Lib::~Lib()
{
}

void Lib::addProcess(ProcessLib *process)
{
    _process.append(process);
}

void Lib::addBoard(BoardLib *board)
{
    _boards.append(board);
}

QList<BoardLib *> &Lib::boards()
{
    return _boards;
}

void Lib::reloadBoards()
{
    QDir dirPath(_path+"/board");

    foreach (QFileInfo pathLib, dirPath.entryInfoList(QStringList(), QDir::Dirs | QDir::NoDotAndDotDot))
    {
        QDir dirIP(pathLib.absoluteFilePath());
        foreach (QFileInfo ipInfo, dirIP.entryInfoList(QStringList("*.dev")))
        {
            BoardLib *board = BoardLib::readFromFile(ipInfo.absoluteFilePath());
            addBoard(board);
        }
    }
}
