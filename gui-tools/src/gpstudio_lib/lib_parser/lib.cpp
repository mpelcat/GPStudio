/****************************************************************************
** Copyright (C) 2014 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "lib.h"

#include <QDebug>
#include <QDir>
#include <QCoreApplication>

Lib::Lib(const QString &libPath)
{
    QDir dir(QCoreApplication::applicationDirPath()+'/'+libPath+"/support");
    _path = dir.absolutePath();

    reloadLib();
}

Lib::~Lib()
{
}

void Lib::reloadProcess()
{
    closeProcess();

    QDir dirPath(_path+"/process");

    foreach (QFileInfo pathLib, dirPath.entryInfoList(QStringList(), QDir::Dirs | QDir::NoDotAndDotDot))
    {
        QDir dirIP(pathLib.absoluteFilePath());
        foreach (QFileInfo ipInfo, dirIP.entryInfoList(QStringList("*.proc")))
        {
            ProcessLib *process = ProcessLib::readFromFile(ipInfo.absoluteFilePath());
            if(process) addProcess(process);
        }
    }
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

void Lib::reloadIos()
{
    closeIos();

    QDir dirPath(_path+"/io");

    foreach (QFileInfo pathLib, dirPath.entryInfoList(QStringList(), QDir::Dirs | QDir::NoDotAndDotDot))
    {
        QDir dirIP(pathLib.absoluteFilePath());
        foreach (QFileInfo ipInfo, dirIP.entryInfoList(QStringList("*.io")))
        {
            IOLib *io = IOLib::readFromFile(ipInfo.absoluteFilePath());
            if(io) addIo(io);
        }
    }
}

void Lib::addIo(IOLib *io)
{
    _ios.append(io);
    _iosMap.insert(io->name(), io);
}

const QList<IOLib *> &Lib::ios() const
{
    return _ios;
}

IOLib *Lib::io(const QString &name)
{
    if(_iosMap.contains(name))
    {
        return _iosMap[name];
    }
    return NULL;
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
    closeBoards();

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
    reloadIos();
}

void Lib::closeProcess()
{
    for(int i=0; i<_process.size(); i++) delete _process[i];
    _process.clear();
}

void Lib::closeIos()
{
    for(int i=0; i<_ios.size(); i++) delete _ios[i];
    _ios.clear();
}

void Lib::closeBoards()
{
    for(int i=0; i<_boards.size(); i++) delete _boards[i];
    _boards.clear();
}
