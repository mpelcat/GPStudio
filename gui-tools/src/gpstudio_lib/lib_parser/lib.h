#ifndef LIB_H
#define LIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>
#include <QMap>

#include "processlib.h"
#include "boardlib.h"

class GPSTUDIO_LIB_EXPORT Lib
{
public:
    Lib(const QString &libPath);
    ~Lib();

    void reloadProcess();
    void addProcess(ProcessLib *process);
    const QList<ProcessLib *> &processes() const;
    ProcessLib *process(const QString &name);

    void reloadBoards();
    void addBoard(BoardLib *board);
    const QList<BoardLib *> &boards()const;
    BoardLib *board(const QString &name);

    void reloadLib();
private:
    QList<ProcessLib*> _process;
    QMap<QString, ProcessLib*> _processMap;

    QList<BoardLib*> _boards;
    QMap<QString, BoardLib*> _boardsMap;

    QString _path;
};

#endif // LIB_H
