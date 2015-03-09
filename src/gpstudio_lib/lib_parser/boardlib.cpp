#include "boardlib.h"

#include <QFile>
#include <QDebug>

BoardLib::BoardLib()
{
}
QString BoardLib::name() const
{
    return _name;
}

void BoardLib::setName(const QString &name)
{
    _name = name;
}

BoardLib *BoardLib::readFromFile(const QString &fileName)
{
    QDomDocument doc;
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) qDebug()<<"Cannot open"<<file.fileName();
    else
    {
        if(!doc.setContent(&file)) qDebug()<<"Cannot open"<<file.fileName();
        else
        {
            return BoardLib::fromNodeGenerated(doc.documentElement());
        }
        file.close();
    }
    return NULL;
}

BoardLib *BoardLib::fromNodeGenerated(const QDomElement &domElement)
{
    BoardLib *board=new BoardLib();
    board->setName(domElement.attribute("name","no_name"));

    return board;
}

