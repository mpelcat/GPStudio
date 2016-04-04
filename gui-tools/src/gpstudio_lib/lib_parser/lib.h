/****************************************************************************
** Copyright (C) 2016 Dream IP
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

#ifndef LIB_H
#define LIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QMap>

#include "processlib.h"
#include "ioboardlib.h"
#include "iolib.h"
#include "boardlib.h"

class GPSTUDIO_LIB_EXPORT Lib
{
    Q_DISABLE_COPY(Lib)

private:
    Lib();

public:
    ~Lib();

    void reloadProcess();
    void addProcess(ProcessLib *process);
    const QList<ProcessLib *> &processes() const;
    ProcessLib *process(const QString &name);

    void reloadIos();
    void addIo(IOLib *io);
    const QList<IOLib *> &ios() const;
    IOLib *io(const QString &name);

    void reloadBoards();
    void addBoard(BoardLib *board);
    const QList<BoardLib *> &boards()const;
    BoardLib *board(const QString &name);

    void reloadLib();

    static inline Lib &getLib() {if(!_instance) _instance = new Lib(); return *_instance;}

private:
    void closeProcess();
    void closeIos();
    void closeBoards();

private:
    QList<ProcessLib*> _process;
    QMap<QString, ProcessLib*> _processMap;

    QList<IOLib*> _ios;
    QMap<QString, IOLib*> _iosMap;

    QList<BoardLib*> _boards;
    QMap<QString, BoardLib*> _boardsMap;

    QString _path;

    static Lib *_instance;
};

#endif // LIB_H
