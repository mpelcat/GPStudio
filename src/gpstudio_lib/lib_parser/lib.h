#ifndef LIB_H
#define LIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QList>

#include "processlib.h"
#include "boardlib.h"

class GPSTUDIO_LIB_EXPORT Lib
{
public:
    Lib(const QString &libPath);
    ~Lib();

    void addProcess(ProcessLib *process);

    void addBoard(BoardLib *board);
    QList<BoardLib *> &boards();

    void reloadBoards();

private:
    QList<ProcessLib*> _process;
    QList<BoardLib*> _boards;
    QString _path;
};

#endif // LIB_H
