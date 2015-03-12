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

    void reloadProcess();
    void addProcess(ProcessLib *process);
    const QList<ProcessLib *> &process() const;

    void reloadBoards();
    void addBoard(BoardLib *board);
    const QList<BoardLib *> &boards()const;

    void reloadLib();
private:
    QList<ProcessLib*> _process;
    QList<BoardLib*> _boards;
    QString _path;
};

#endif // LIB_H
