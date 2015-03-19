#include "lib.h"

#include <QDebug>
#include <QDir>

#include "processlibreader.h"

Lib::Lib(const QString &libPath)
{
    QDir dir(QDir::currentPath()+'/'+libPath);
    _path = dir.absolutePath();

    reloadLib();
}

Lib::~Lib()
{
}

void Lib::addProcess(ProcessLib *process)
{
    _process.append(process);
    _processMap.insert(process->name(), process);
}

const QList<ProcessLib *> &Lib::processes() const
{
    return _process;
}

ProcessLib *Lib::process(const QString &name)
{
    if(_processMap.contains(name))
    {
        return _processMap[name];
    }
    return NULL;
}

void Lib::reloadProcess()
{
    QDir dirPath(_path+"/process");

    foreach (QFileInfo pathLib, dirPath.entryInfoList(QStringList(), QDir::Dirs | QDir::NoDotAndDotDot))
    {
        QDir dirIP(pathLib.absoluteFilePath());
        foreach (QFileInfo ipInfo, dirIP.entryInfoList(QStringList("*.proc")))
        {
            ProcessLib *process = ProcessLib::readFromFile(ipInfo.absoluteFilePath());
            addProcess(process);
        }
    }
}

void Lib::addBoard(BoardLib *board)
{
    _boards.append(board);
    _boardsMap.insert(board->name(), board);
}

const QList<BoardLib *> &Lib::boards() const
{
    return _boards;
}

BoardLib *Lib::board(const QString &name)
{
    if(_boardsMap.contains(name))
    {
        return _boardsMap[name];
    }
    return NULL;
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

void Lib::reloadLib()
{
    reloadBoards();
    reloadProcess();
}
